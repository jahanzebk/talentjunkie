require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Contract do
  before(:each) do
    @contract = Contract.new
  end

  it "should set 'from' datetime given a year and a month" do
    @contract.from = 2005, 11
    
    @contract.from.year.should eql(2005)
    @contract.from.month.should eql(11)
    @contract.from.day.should eql(1)
    @contract.from.hour.should eql(0)
    @contract.from.min.should eql(0)
    @contract.from.sec.should eql(0)
  end
  
  it "should set 'from' datetime given nil" do
    @contract.from = nil
    @contract.from.should be_nil
  end

  it "should set 'to' datetime given a year and a month" do
    @contract.to = 2010, 7
    
    @contract.to.year.should eql(2010)
    @contract.to.month.should eql(7)
    @contract.to.day.should eql(31)
    @contract.to.hour.should eql(23)
    @contract.to.min.should eql(59)
    @contract.to.sec.should eql(59)
  end
  
  it "should set 'to' datetime given nil" do
    @contract.to = nil
    @contract.to.should be_nil
  end
end