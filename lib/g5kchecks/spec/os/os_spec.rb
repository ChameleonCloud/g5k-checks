describe "OS" do

  before(:all) do
    @api = RSpec.configuration.node.api_description["operating_system"]
    @system = RSpec.configuration.node.ohai_description
  end

  it "should be the correct name" do
    name_api = ""
    name_api = @api['name'] if @api
    name_ohai = @system[:platform]
    expect(name_ohai).to eql(name_api), "#{name_ohai}, #{name_api}, operating_system, name"
  end

  it "should be the correct kernel version" do
    kernel_api = ""
    kernel_api = @api['kernel'] if @api
    kernel_ohai = @system[:kernel][:release]
    expect(kernel_ohai).to eql(kernel_api), "#{kernel_ohai}, #{kernel_api}, operating_system, kernel"
  end

  it "should be the correct version" do
    release_api = ""
    release_api = @api['version'] if @api
    release_ohai = @system[:platform_version]
    expect(release_ohai).to eql(release_api), "#{release_ohai}, #{release_api}, operating_system, version"
  end

end
