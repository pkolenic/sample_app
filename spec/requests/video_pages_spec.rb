require 'spec_helper'

describe "Video pages" do
  let!(:clan)           { FactoryGirl.create(:clan) }
  let!(:user)           { FactoryGirl.create(:user) }
  let!(:clan_user)      { FactoryGirl.create(:user, clan_id:clan.id) }
  
  subject { page }
  
  shared_examples_for "all video pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
  end
 
  describe "view page" do
    describe "with public access" do
      let!(:access_type)    { FactoryGirl.create(:access_type, name: PUBLIC) }
      let!(:video)          { FactoryGirl.create(:video, clan_id: clan.id, access_type_id: access_type.id) }
      let(:heading)         { video.title }
      let(:page_title)      { video.header }
      
      describe "visit as nonuser" do
        before { visit clan_video_path(clan, video) }
        it_should_behave_like "all video pages"
      end
      
      describe "visit as user" do
        before do
          sign_in user
          visit clan_video_path(clan, video)                    
        end
        specify { current_url.should eq clan_video_url(clan, video) }
      end
    
      describe "visit as clan user" do
        before do
          sign_in clan_user
          visit clan_video_path(clan, video)                    
        end
        specify { current_url.should eq clan_video_url(clan, video) }
      end
    end

    describe "view page with account access" do
      let!(:access_type)    { FactoryGirl.create(:access_type, name: ACCOUNT) }
      let!(:video)          { FactoryGirl.create(:video, clan_id: clan.id, access_type_id: access_type.id) }
      
      describe "visit as nouser" do
        before { visit clan_video_path(clan,video) }        
        specify { current_url.should eq signin_url(clan.slug) }
        specify { expect(request.flash[:notice]).to eq 'Please sign in' }
      end
      
      describe "visit as user" do
        before do
          sign_in user
          visit clan_video_path(clan, video)
        end
        specify { current_url.should eq clan_video_url(clan, video) }
      end
      
      describe "visit as clan user" do
        before do
          sign_in clan_user
          visit clan_video_path(clan, video)
        end
        specify { current_url.should eq clan_video_url(clan, video) }        
      end
    end
    
    describe "view page with clan access" do
      let!(:access_type)    { FactoryGirl.create(:access_type, name: CLAN) }
      let!(:video)          { FactoryGirl.create(:video, clan_id: clan.id, access_type_id: access_type.id) }

      describe "visit as nouser" do
        before { visit clan_video_path(clan,video) }        
        specify { current_url.should eq signin_url(clan.slug) }
        specify { expect(request.flash[:notice]).to eq 'Please sign in' }
      end
      
      describe "visit as user" do
        before do
          sign_in user
          visit clan_video_path(clan, video)
        end
        specify { current_url.should eq signin_url(clan.slug) }
        specify { expect(request.flash[:error]).to eq "You must be a memeber of #{clan.name} to watch those videos" }
      end
      
      describe "visit as clan user" do
        before do
          sign_in clan_user
          visit clan_video_path(clan, video)
        end
        specify { current_url.should eq clan_video_url(clan, video) }        
      end          
    end
  
    # Test You Channel Page
    # Test Static Page
    # Test Page with Filters
  end

end