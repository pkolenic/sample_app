require 'spec_helper'

describe Rank do
  before do
    @rank = Rank.new(title: "Pending")
  end

  subject { @rank }
  
  it { should be_valid }

  it { should respond_to(:title) }
  it { should respond_to(:users) }
  
  describe "when name is too long" do
    before { @rank.title = "a" * 51 }
    it { should_not be_valid }
  end
end
