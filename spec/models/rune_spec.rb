require 'spec_helper'

describe Rune do
  let!(:quality) { FactoryGirl.create(:quality) }
  let!(:type) { FactoryGirl.create(:rune_type) }
  let!(:gear_level) { FactoryGirl.create(:gear_level) }
  let!(:glyph_prefix) { FactoryGirl.create(:glyph_prefix) }  
  
  before do
    @rune = Rune.new(name: "Ta", translation: "Base", level: 1, rune_type_id: type.id, quality_id: quality.id, gear_level_id: gear_level.id, glyph_prefix_id: glyph_prefix.id)
  end

  subject { @rune }

  it { should respond_to(:name) }
  it { should respond_to(:translation) }
  it { should respond_to(:level) }
  it { should respond_to(:rune_type_id) }
  it { should respond_to(:rune_type) }
  it { should respond_to(:quality_id) }
  it { should respond_to(:quality) }
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

  describe "when rune type id is not present" do
    before { @rune.rune_type_id = nil }
    it { should_not be_valid }
  end
end
