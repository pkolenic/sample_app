require 'spec_helper'

describe AccessType do
  before do
    @accessType = AccessType.new(name: "Public")
  end

  subject { @accessType }
  
  it { should respond_to(:name) }
  it { should respond_to(:videos) }
  
  describe "when name is too long" do
    before { @accessType.name = "a" * 51 }
    it { should_not be_valid }
  end   
  
  describe "when name is not present" do
    before { @accessType.name = nil }
    it { should_not be_valid }
  end 
end
