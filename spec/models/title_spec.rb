require 'spec_helper'

describe Title do
  before do
    @title = Title.new(name: "SkyShards", region: "The Daggerfall Covenant")
  end

  subject { @title }
  
  it { should respond_to(:name) }
  it { should respond_to(:region) }
  it { should respond_to(:appointments) }
  it { should respond_to(:users) }
  
  describe "when name is too long" do
    before { @title.name = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "title appointment associations" do
    before { @title.save }
    
    let!(:user)       { FactoryGirl.create(:user) }
    let!(:appointment) { @title.appointments.build(user_id: user.id) }
    
    it "should have title appointments" do
      expect(@title.appointments.to_a).to eq [appointment]
    end
    
    it "should destory associated title appointments" do
      appointments = @title.appointments.to_a
      @title.destroy
      expect(appointments).not_to be_empty
      appointments.each do |appt|
        expect(Appointment.where(id: appt.id)).to be_empty
      end
    end
  end
  
  describe "titles" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      @title.save
      @title.appointments.create!(user_id: user.id)
    end
       
    its(:users) { should include(user) }
  end  
end
