require 'spec_helper'

describe AspectRune do
  let!(:quality) { FactoryGirl.create(:quality) }
  
  before do
    @rune = AspectRune.new(name: "Ta", translation: "Base", level: 1, quality_id: quality.id)
  end

  subject { @rune }

  it { should respond_to(:name) }
  it { should respond_to(:translation) }
  it { should respond_to(:level) }
  it { should respond_to(:quality_id) }
  it { should respond_to(:quality) }
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

  describe "when level is too low" do
    before { @rune.level = 0 }
    it { should_not be_valid }
  end
end
