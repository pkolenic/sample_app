require 'spec_helper'
include ActionView::Helpers::DateHelper

describe "Event pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user, rank: UserGuildMaster) }
  before { sign_in user }

  describe "visit event page" do
    let!(:e1) { FactoryGirl.create(:event, user: user, title: "Private Bar", public: false) }    
    
    before { visit event_path(e1.id) }
    
    it { should have_title(full_title(e1.title)) }
    it { should have_content(e1.title) }
    it { should have_content(e1.deck) }
    it { should have_content(e1.start_time.strftime('%b %d %Y, %l:%M%p')) }
    it { should have_content(e1.end_time.strftime('%b %d %Y, %l:%M%p')) }
    it { should have_content(distance_of_time_in_words(e1.start_time, e1.end_time)) }
    it { should have_link('<Back to the Calendar>') }
    it { should have_link('<delete>') }
    
    describe "as private event" do
      let(:user2) { FactoryGirl.create(:user, rank: UserPending) }
      
      before do
        sign_in user2
        visit event_path(e1.id)
      end
      
      it { should have_title(full_title('Calendar')) }
      it { should have_error_message("Only full guild members can view that event!") }      
      end
  end
  
  describe "visit calendar" do
    before { visit calendar_path }
    
    it { should have_title(full_title('Calendar')) }
  end

  describe "event creation" do
    before { visit calendar_path }

    describe "with invalid information" do

      it "should not create an event" do
        expect { find("#event-submit",:visible=>false).click }.not_to change(Event, :count)
      end

      describe "error messages" do
        before { find("#event-submit", :visible=>false).click }

        it { should have_selector('#error_explanation', :visible=>false) }
      end
    end

    describe "with valid information" do

      before do
        find("#event_title", :visible=>false).set "Lorem ipsum"
        find("#event_deck", :visible=>false).set "Lorem ipsum"
        find("#event_start_time", :visible=>false).set "2014-02-10 12:00:00"
        find("#event_end_time", :visible=>false).set "2014-02-10 12:00:15"
      end

      it "should create a event" do
        expect { find("#event-submit",:visible=>false).click }.to change(Event, :count).by(1)
      end
      
      describe "without proper rank" do
          let!(:user3) { FactoryGirl.create(:user, email: "user3@fearthefallen.com") }
          before do
            sign_in user3
            visit calendar_path
          end
          
          it "should not create an event" do
            expect { find("#event-submit",:visible=>false).click }.not_to change(Event, :count)
          end
          
          it { should_not have_selector('#add-event') }
      end
    end
  end

  describe "event destruction" do
    let!(:user2) { FactoryGirl.create(:user, rank: UserGuildMaster, email: "user2@fearthefallen.com") }
    before do
       FactoryGirl.create(:event, user: user)
       FactoryGirl.create(:event, user: user2)
    end 
    
    describe "as correct user from user page" do
      before { visit user_path(user.id) }
  
      it "should delete an event" do
        expect { click_link "delete" }.to change(Event, :count).by(-1)
      end
    end
    
    describe "as correct user from event page" do
      let!(:event) { FactoryGirl.create(:event, user: user) }
      
      before { visit event_path(event.id) }
      
      it "should delete an event" do
        expect { click_link "delete" }.to change(Event, :count).by(-1)
      end
      
      it { should_not have_link('delete', href: event_path(user2.events.first)) }
      
      describe "it should redirect to user page" do
        before { click_link "delete" }
        
        it { should have_content(user.name) }
      end
      
    end
  end
end