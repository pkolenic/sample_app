require 'spec_helper'

describe UserPrivilege do
  let(:user)            { FactoryGirl.create(:user) }
  let(:privilege)       { FactoryGirl.create(:privilege) }
  let(:user_privilege)  { user.user_privileges.build(privilege_id: privilege.id) }
  
  subject { user_privilege }
  
  it { should be_valid }
  
  describe ":=user_privilege methods" do
    it { should respond_to(:user) }
    it { should respond_to(:privilege) }
    its(:user) { should eq user }
    its(:privilege) { should eq privilege }
  end
  
  describe "when user id is not present" do
    before { user_privilege.user_id = nil }
    it { should_not be_valid }
  end
  
  describe "when privilege id is not present" do
    before { user_privilege.privilege_id = nil }
    it { should_not be_valid }
  end
end
