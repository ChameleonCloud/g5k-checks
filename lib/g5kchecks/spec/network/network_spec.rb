def correct_nic_name_second(nic_name, expected_pattern="eth")
  is_ubuntu = RSpec.configuration.node.ohai_description[:platform] == "ubuntu"
  if is_ubuntu
    # The Chameleon API provides network interface in the "enoX" format, while
    # Ubuntu is setting the network interface to the "ethY" format. This 
    # function transform "enoX" nic name in "ethY". Please note that Y = X-1.
    if nic_name.include? "eno"
      nic_number_str = nic_name.sub("eno", "").to_i
      nic_number_int = nic_number_str.to_i
      nic_number_int = nic_number_int - 1
      new_nic_name = expected_pattern + nic_number_int.to_s
      return new_nic_name
    end
  end
  return nic_name
end

describe "Network" do

  before(:all) do
    @api_desc = RSpec.configuration.node.api_description["network_adapters"]
    @api = {}
    if @api_desc
      @api_desc.each { |a|
        # Check any incompatibility between Ubuntu network interfaces names and
        # centos network interfaces names.
        new_nic_name =  correct_nic_name_second(a["device"])
        a['device'] = new_nic_name
        @api[a['device']] = a
      }
    end
  end

  RSpec.configuration.node.ohai_description[:network][:interfaces].to_hash.select { |d,i| /(en|eth|ib|myri).*/.match(d) }.each do |dev|

    it "should be the correct interface name" do
      name_api = ""
      corrected_dev_0 = correct_nic_name_second(dev[0])
      name_api = @api[corrected_dev_0]['interface'] if @api_desc
      type = /(en|eth|ib|myri).*/.match(dev[0])[1]
      name_ohai = Utils.interface_name(type)
      expect(name_ohai).to eql(name_api), "#{name_ohai}, #{name_api}, network_interfaces, #{dev[0]}, interface"
    end

    #it "should have the correct IPv4" do
      #ip_api = ""
      #ip_api = @api[dev[0]]['ip'] if @api_desc
      #ip_ohai = dev[1][:ip]
      #ip_ohai.should eql(ip_api), "#{ip_ohai}, #{ip_api}, network_interfaces, #{dev[0]}, ip"
    #end

    #it "should have the correct IPv6" do
      #ip_api = ""
      #ip_api = @api[dev[0]]['ip6'] if @api_desc
      #ip_ohai = dev[1][:ip6]
      #ip_ohai.should eql(ip_api), "#{ip_ohai}, #{ip_api}, network_interfaces, #{dev[0]}, ip6"
    #end

    it "should have the correct Driver" do
      driver_api = ""
      corrected_dev_0 = correct_nic_name_second(dev[0])
      driver_api = @api[corrected_dev_0]['driver'] if @api_desc      
      driver_ohai = dev[1][:driver]
      expect(driver_ohai).to eql(driver_api), "#{driver_ohai}, #{driver_api}, network_interfaces, #{dev[0]}, driver"
    end

    if dev[0] =~ /ib/
      it "should have the correct guid" do
      mac_api = ""
      mac_api = @api[dev[0]]['guid'] if @api_desc
      mac_ohai = dev[1][:mac]
      expect(mac_ohai).to eql(mac_api), "#{mac_ohai}, #{mac_api}, network_interfaces, #{dev[0]}, guid"
    end
    else
      it "should have the correct Mac Address" do
        mac_api = ""
        corrected_dev_0 = correct_nic_name_second(dev[0])
        mac_api = @api[corrected_dev_0]['mac'] if @api_desc
        mac_ohai = dev[1][:mac].downcase
        expect(mac_ohai).to eql(mac_api), "#{mac_ohai}, #{mac_api}, network_interfaces, #{dev[0]}, mac"
      end
    end

    it "should have the correct Rate" do
      corrected_dev_0 = correct_nic_name_second(dev[0])
      mnt_api = @api[corrected_dev_0]['mounted'] if @api_desc
      if mnt_api
        rate_api = ""
        rate_api = @api[corrected_dev_0]['rate'] if @api_desc
        if dev[1][:rate] == ""
          rate_ohai = dev[1][:rate]
        else
          rate_ohai = dev[1][:rate].to_i
        end
        expect(rate_ohai).to eql(rate_api), "#{rate_ohai}, #{rate_api}, network_interfaces, #{dev[0]}, rate"
      end
    end

    it "should have the correct version" do
      ver_api = ""
      corrected_dev_0 = correct_nic_name_second(dev[0])
      ver_api = @api[corrected_dev_0]['version'] if @api_desc
      ver_ohai = dev[1][:version]
      expect(ver_ohai).to eql(ver_api), "#{ver_ohai}, #{ver_api}, network_interfaces, #{dev[0]}, version"
    end

    #it "should have the correct vendor" do
      #ven_api = ""
      #ven_api = @api[dev[0]]['vendor'] if @api_desc
      #ven_ohai = dev[1][:vendor]
      #ven_ohai.should eql(ven_api), "#{ven_ohai}, #{ven_api}, network_interfaces, #{dev[0]}, vendor"
    #end

#    it "should have the correct enabled mode" do
#      ven_api = nil
#      ven_api = @api[dev[0]]['enabled'] if @api_desc
#      ven_ohai = dev[1][:enabled]
#      expect(ven_ohai).to eql(ven_api), "#{ven_ohai}, #{ven_api}, network_interfaces, #{dev[0]}, enabled"
#    end

#    it "should have the correct mountable mode" do
#      ven_api = nil
#      ven_api = @api[dev[0]]['mountable'] if @api_desc
#      ven_ohai = dev[1][:mountable]
#      expect(ven_ohai).to eql(ven_api), "#{ven_ohai}, #{ven_api}, network_interfaces, #{dev[0]}, mountable"
#    end

    it "should have the correct mounted mode" do
      ven_api = nil
      corrected_dev_0 = correct_nic_name_second(dev[0])
      ven_api = @api[corrected_dev_0]['mounted'] if @api_desc
      ven_ohai = dev[1][:mounted]
      expect(ven_ohai).to eql(ven_api), "#{ven_ohai}, #{ven_api}, network_interfaces, #{dev[0]}, mounted"
    end

    it "should not be a management card" do
      mgt_api = nil
      corrected_dev_0 = correct_nic_name_second(dev[0])
      mgt_api = @api[corrected_dev_0]['management'] if @api_desc
      mgt_ohai = dev[1][:management]
      expect(mgt_ohai).to eql(mgt_api), "#{mgt_ohai}, #{mgt_api}, network_interfaces, #{dev[0]}, management"
    end

  end

end
