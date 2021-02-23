describe "Rights on /tmp" do

  it "should have mode 41777" do
    tmp_mode = File.stat("/tmp").mode.to_s(8)
    expect(tmp_mode).to eql("41777"), "/tmp mode to #{tmp_mode} instead of 41777"
  end

end
