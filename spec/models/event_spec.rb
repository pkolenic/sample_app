require 'spec_helper'

describe Event do
  let(:user) { FactoryGirl.create(:user, email: "eventTest@fearthefallen.com") }
  
  before { @event = user.events.build(title: "Test Event", deck: "This is a test event to test events", start_time: "2014-03-10 10:00:00", end_time: "2014-03-10 10:00:05", public: true) }
  
  subject { @event }
  
  it { should respond_to(:title) }
  it { should respond_to(:deck) }
  it { should respond_to(:start_time) }
  it { should respond_to(:end_time) }
  it { should respond_to(:public) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should eq user }
  
  it { should be_valid }
  
  describe "when user_id is not present" do
    before { @event.user_id = nil }
    it { should_not be_valid }
  end
  
  describe "with blank title" do
    before { @event.title = " " }
    it { should_not be_valid }
  end

  describe "with title that is too long" do
    before { @event.title = "a" * 73 }
    it { should_not be_valid }
  end  
  
  describe "with blank deck" do
    before { @event.deck = " " }
    it { should_not be_valid }
  end
  
  describe "with no start time" do
    before { @event.start_time = nil }
    it { should_not be_valid }
  end
  
  describe "with no end time" do
    before { @event.end_time = nil }
    it { should_not be_valid }
  end
  
  describe "with end time before start time" do
    before do
      @event.start_time = 10.hour.ago
      @event.end_time = 12.hour.ago
    end
       
    it { should_not be_valid }
  end
  
  describe "when public status not set" do
    before do
      @event.public = nil
      @event.save!
    end

    it { should be_valid }
    it { should_not be_public }
  end  
end
