require 'spec_helper'

describe EssenceRune do
  before do
    @rune = EssenceRune.new(name: "Dekeipa", translation: "Frost")
  end

  subject { @rune }

  it { should respond_to(:name) }
  it { should respond_to(:translation) }
  it { should respond_to(:rune_glyphs) }  

  it { should be_valid }

  describe "when name is too long" do
    before { @rune.name = "a" * 37 }
    it { should_not be_valid }
  end

  describe "when name id is not present" do
    before { @rune.name = nil }
    it { should_not be_valid }
  end
  
  describe "when translation is to long" do
    before { @rune.translation = "a" * 37 }
    it { should_not be_valid }
  end
end
