require 'spec_helper'

describe GlyphPrefix do
  before do
    @glyph = GlyphPrefix.new(name: "Trifling")
  end

  subject { @glyph }
  
  it { should be_valid }

  it { should respond_to(:name) }
  it { should respond_to(:potency_runes) }
  
  describe "when name is too long" do
    before { @glyph.name = "a" * 17 }
    it { should_not be_valid }
  end
  
  describe "when name is not present" do
    before { @glyph.name = nil }
    it { should_not be_valid }
  end
end
