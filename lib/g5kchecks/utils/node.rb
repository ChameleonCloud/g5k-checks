# retrieve node configuration (with Ohai) and the corresponding API
# characteristics.
require 'socket'
require 'restclient'
require 'json'
require 'yaml'
require 'ohai'
Ohai::Config[:plugin_path] << File.expand_path(File.join(File.dirname(__FILE__), '/../ohai'))
# Backported from Ohai 6 to support direct access to attributes without using the data dictionary
#binding.pry

module Ohai
  class System
    def get_attribute(name)
      @data[name]
    end

    def set_attribute(name, *values)
      @data[name] = Array18(*values)
      @data[name]
    end

    def method_missing(name, *args)
      return get_attribute(name) if args.length == 0

      set_attribute(name, *args)
    end
  end
end

module Grid5000
  class Node
    attr_reader :hostname
    attr_reader :node_uid, :cluster_uid, :site_uid, :grid_uid
    attr_reader :api, :node_path, :conf

    def initialize(conf)
      @conf = conf
      @hostname = Socket.gethostname
      @ohai_description = nil
      @api_description = nil
      @max_retries = 2
      #Syslog.open("g5k-checks", Syslog::LOG_ODELAY, Syslog::LOG_DAEMON)
      #Syslog.log(Syslog::LOG_INFO, "About to try the API")
      #TODO: Skip if using no_api mode
      #get_openstack_vendor_data
      #Syslog.log(Syslog::LOG_INFO, "Did it happen?")
      #Syslog.close()
      print
    end

    def get_openstack_vendor_data
      #Syslog.log(Syslog::LOG_INFO, "Oh no!")
      openstack_vendor_data = JSON.parse RestClient.get("http://169.254.169.254/openstack/latest/vendor_data2.json", :accept => :json)
      if openstack_vendor_data.key?("chameleon")
          openstack_vendor_data = openstack_vendor_data['chameleon']
      else
          openstack_vendor_data = JSON.parse RestClient.get("http://169.254.169.254/openstack/latest/vendor_data.json", :accept => :json)
      end
      @node_uid = openstack_vendor_data["node"]
      @cluster_uid = openstack_vendor_data["cluster"]
      @site_uid = openstack_vendor_data["site"]
      @grid_uid = openstack_vendor_data["grid"]
      @ltd = "org"
    end

    def api_description
      #binding.pry
      return @api_description if @api_description != nil
      if @conf["mode"] == "api" || "no_api"
        @api_description = JSON.parse "{}"
      elsif @conf["retrieve_from"] == "rest"
        if conf["branch"] == nil
          @branch=""
        else
          @branch="?branch="+conf["branch"]
        end
        @node_path = [
          conf["retrieve_url"],
          "sites", site_uid,
          "clusters", cluster_uid,
          "nodes", node_uid
        ].join("/")
        begin
          @api_description = JSON.parse RestClient.get(@node_path+@branch, :accept => :json)
        rescue RestClient::ResourceNotFound
          if @conf["fallback_branch"] != nil
            begin
              @api_description = JSON.parse RestClient.get(@node_path+"?branch="+@conf["fallback_branch"], :accept => :json)
            rescue RestClient::ResourceNotFound
              raise "Node not found with url #{@node_path+@branch} and #{@node_path+"?branch="+@conf["fallback_branch"]}"
            rescue RestClient::ServiceUnavailable => error
              @retries ||= 0
              if @retries < @max_retries
                @retries += 1
                sleep 10
                retry
              else
                raise error
              end
            end
          else
            raise "Node not find with url #{@node_path+@branch}"
          end
        rescue RestClient::ServiceUnavailable => error
          @retries ||= 0
          if @retries < @max_retries
            @retries += 1
            sleep 10
            retry
          else
            raise error
          end
        end
      elsif @conf["retrieve_from"] == "file"
	@node_path = File.join(@conf["retrieve_dir"], @hostname+".json") 
	@api_description = JSON.parse(File.read(@node_path))	
      end
      return @api_description
    end

    def get_wanted_mountpoint
	return @conf["mountpoint"] if @conf["mountpoint"] != nil
	return [] 
    end 

    def ohai_description
      if !@ohai_description
        @ohai_description = Ohai::System.new
        @ohai_description.all_plugins
      end
      @ohai_description
    end

  end
end
