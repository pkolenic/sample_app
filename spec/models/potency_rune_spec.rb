require 'spec_helper'

describe PotencyRune do
  let!(:gear_level) { FactoryGirl.create(:gear_level) }
  let!(:glyph_prefix) { FactoryGirl.create(:glyph_prefix) }
  
  before do
    @rune = PotencyRune.new(name: "Jora", translation: "Develop", level: 1, gear_level_id: gear_level.id, glyph_prefix_id: glyph_prefix.id)
  end

  subject { @rune }

  it { should respond_to(:name) }
  it { should respond_to(:translation) }
  it { should respond_to(:level) }
  it { should respond_to(:gear_level_id) }
  it { should respond_to(:gear_level) }
  it { should respond_to(:glyph_prefix_id) }
  it { should respond_to(:glyph_prefix) }

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
