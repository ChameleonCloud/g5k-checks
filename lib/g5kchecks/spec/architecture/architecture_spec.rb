describe "Architecture" do

  before(:all) do
    @api = RSpec.configuration.node.api_description["architecture"]
    @system = RSpec.configuration.node.ohai_description
    @instruction_set = @system[:kernel][:machine].sub('_','-')
  end

  it "should have the correct number of core" do
    core_api = 0
    core_api = @api['smp_size'].to_i if @api
    if @system[:cpu][:real] == 0
      if @instruction_set == 'aarch64'
        core_ohai = 1
      else
        core_ohai = @system[:cpu][:total].to_i
      end
    else
      core_ohai = @system[:cpu][:real].to_i
    end
    RSpec.configuration.expect_with(:rspec) { |c| c.syntax = :should }
    expect(core_ohai).to eql(core_api), "#{core_ohai}, #{core_api}, architecture, smp_size"
  end

  it "should have the correct number of thread" do
    threads_api = 0
    threads_api = @api['smt_size'].to_i if @api
    threads_ohai = @system[:cpu][:total].to_i
    expect(threads_ohai.to_i).to eql(threads_api), "#{threads_ohai}, #{threads_api}, architecture, smt_size"
  end

  it "should have the correct platform type" do
    plat_api = ""
    plat_api = @api['platform_type'] if @api
    plat_ohai = @system[:kernel][:machine]
    expect(plat_ohai).to eq(plat_api), "#{plat_ohai}, #{plat_api}, architecture, platform_type"
  end

end
