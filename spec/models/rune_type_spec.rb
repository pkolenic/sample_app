require 'spec_helper'

describe RuneType do
  before do
    @type = RuneType.new(name: "Aspect")
  end

  subject { @type }
  
  it { should be_valid }

  it { should respond_to(:name) }
  it { should respond_to(:runes) }
  
  describe "when name is too long" do
    before { @type.name = "a" * 17 }
    it { should_not be_valid }
  end
  
  describe "when name id is not present" do
    before { @type.name = nil }
    it { should_not be_valid }
  end  
end
