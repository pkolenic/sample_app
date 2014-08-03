require 'spec_helper'

describe Application do
  let(:clan)        { FactoryGirl.create(:clan) }
  let(:user)        { FactoryGirl.create(:user) }
  let(:application) { FactoryGirl.create(:application, user_id: user.id, clan_id: clan.id) }
  
  subject { application }
  
  it { should be_valid }
  
  describe "application methods" do
    it { should respond_to(:user) }
    it { should respond_to(:clan) }
    its(:user) { should eq user }
    its(:clan) { should eq clan }
  end
  
  describe "when user id is not present" do
    before { application.user_id = nil }
    it { should_not be_valid }
  end
  
  describe "when clan id is not present" do
    before { application.clan_id = nil }
    it { should_not be_valid }
  end
end
