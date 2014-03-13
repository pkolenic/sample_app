require 'spec_helper'

describe "Event pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

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
    end
  end

  describe "event destruction" do
    let!(:user2) { FactoryGirl.create(:user) }
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