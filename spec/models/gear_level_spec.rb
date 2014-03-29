require 'spec_helper'

describe GearLevel do
  before do
    @gear = GearLevel.new(name: "Level 1—10")
  end

  subject { @gear }
  
  it { should be_valid }

  it { should respond_to(:name) }
  it { should respond_to(:potency_runes) }
  
  describe "when name is too long" do
    before { @gear.name = "a" * 17 }
    it { should_not be_valid }
  end
  
  describe "when name is not present" do
    before { @gear.name = nil }
    it { should_not be_valid }
  end
end
