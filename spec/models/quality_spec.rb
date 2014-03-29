require 'spec_helper'

describe Quality do
  before do
    @quality = Quality.new(name: "Normal", color: "White")
  end

  subject { @quality }
  
  it { should be_valid }

  it { should respond_to(:name) }
  it { should respond_to(:color) }
  it { should respond_to(:runes) }
  it { should respond_to(:aspect_runes) }
  
  describe "when name is too long" do
    before { @quality.name = "a" * 17 }
    it { should_not be_valid }
  end
  
  describe "when color is to long" do
    before { @quality.color = "a" * 17 }
    it { should_not be_valid }
  end
  
  describe "when name id is not present" do
    before { @quality.name = nil }
    it { should_not be_valid }
  end
  
  describe "when color id is not present" do
    before { @quality.color = nil }
    it { should_not be_valid }
  end
end
