require 'spec_helper'

describe Appointment do
  let(:user)        { FactoryGirl.create(:user) }
  let(:title)       { FactoryGirl.create(:title) }
  let(:appointment) { user.appointments.build(title_id: title.id) }
  
  subject { appointment }
  
  it { should be_valid }
  
  describe "appointment methods" do
    it { should respond_to(:user) }
    it { should respond_to(:title) }
    its(:user) { should eq user }
    its(:title) { should eq title }
  end
  
  describe "when user id is not present" do
    before { appointment.user_id = nil }
    it { should_not be_valid }
  end
  
  describe "when title id is not present" do
    before { appointment.title_id = nil }
    it { should_not be_valid }
  end
end
