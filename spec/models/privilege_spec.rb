require 'spec_helper'

describe Privilege do
  before do
    @privilege = Privilege.new(name: "Clan Admin")
  end

  subject { @privilege }
  
  it { should respond_to(:name) }
  it { should respond_to(:user_privileges) }
  it { should respond_to(:users) }
  
  describe "when name is too long" do
    before { @privilege.name = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "user privilege associations" do
    before { @privilege.save }
    
    let!(:user)           { FactoryGirl.create(:user) }
    let!(:user_privilege) { @privilege.user_privileges.build(user_id: user.id) }
    
    it "should have user privileges" do
      expect(@privilege.user_privileges.to_a).to eq [user_privilege]
    end
    
    it "should destory associated user privileges" do
      user_privileges = @privilege.user_privileges.to_a
      @privilege.destroy
      expect(user_privileges).not_to be_empty
      user_privileges.each do |privilege|
        expect(UserPrivilege.where(id: privilege.id)).to be_empty
      end
    end
  end
  
  describe "users" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      @privilege.save
      @privilege.user_privileges.create!(user_id: user.id)
    end
       
    its(:users) { should include(user) }
  end    
end
