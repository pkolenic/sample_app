require 'spec_helper'

describe RuneGlyph do
  let!(:item_type)    { FactoryGirl.create(:item_type) }
  let!(:aspect_rune)  { FactoryGirl.create(:aspect_rune) }
  let!(:essence_rune) { FactoryGirl.create(:essence_rune) }
  let!(:potency_rune) { FactoryGirl.create(:potency_rune) }
  
  before do
    @glyph = RuneGlyph.new(name: "Trifling Glyph of Hardening", description: "Grants (x) point Damage Shield for (y) seconds", x_value: 10, y_value: 4, item_type_id: item_type.id, essence_rune_id: essence_rune.id, aspect_rune_id: aspect_rune.id, potency_rune_id: potency_rune.id)
  end

  subject { @glyph }
  
  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:x_value) }
  it { should respond_to(:y_value) }
  it { should respond_to(:item_type_id) }
  it { should respond_to(:item_type) }   
  it { should respond_to(:essence_rune_id) }
  it { should respond_to(:essence_rune) }
  it { should respond_to(:aspect_rune_id) }
  it { should respond_to(:aspect_rune) }
  it { should respond_to(:potency_rune_id) }
  it { should respond_to(:potency_rune) }
  
  it { should be_valid }
  
  describe "when name is too long" do
    before { @glyph.name = "a" * 65 }
    it { should_not be_valid }
  end

  describe "when name is not present" do
    before { @glyph.name = nil }
    it { should_not be_valid }
  end
  
  describe "when description is to long" do
    before { @glyph.description = "a" * 129 }
    it { should_not be_valid }
  end
  
  describe "when description is not present" do
    before { @glyph.description = nil }
    it { should_not be_valid }
  end

  describe "when x_value is too low" do
    before { @glyph.x_value = 0 }
    it { should_not be_valid }
  end   
  
  describe "when x_value not set" do
    before { @glyph.x_value = '' }
    it { should be_valid }
  end
  
  describe "when y_value is too low" do
    before { @glyph.y_value = 0 }
    it { should_not be_valid }    
  end
  
  describe "when_y_value not set" do
    before { @glyph.y_value = '' }
    it { should be_valid }
  end
  
  describe "when item_type_id is too low" do
    before { @glyph.item_type_id = 0 }
    it { should_not be_valid }
  end
  
  describe "when item_type_id is not set" do
    before { @glyph.item_type_id = nil }
    it { should_not be_valid }
  end
  
  describe "when essence_rune_id is too low" do
    before { @glyph.essence_rune_id = 0 }
    it { should_not be_valid }
  end
  
  describe "when essence_rune_id is not set" do
    before { @glyph.essence_rune_id = nil }
    it { should_not be_valid }
  end
  
   describe "when aspect_rune_id is too low" do
    before { @glyph.aspect_rune_id = 0 }
    it { should_not be_valid }
  end
  
  describe "when aspect_rune_id is not set" do
    before { @glyph.aspect_rune_id = nil }
    it { should_not be_valid }
  end
  
  describe "when potency_rune_id is too low" do
    before { @glyph.potency_rune_id = 0 }
    it { should_not be_valid }
  end
  
  describe "when potency_rune_id is not set" do
    before { @glyph.potency_rune_id = nil }
    it { should_not be_valid }
  end     
end
