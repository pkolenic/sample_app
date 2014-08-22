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
  
  shared_examples_for "all pages with video player" do
    it { should have_selector('div#player_wrapper') }
    it { should have_selector('#player') }
    it { should have_selector('div#videos') }
  end
   
  describe "view page" do
    let!(:access_type)    { FactoryGirl.create(:access_type, name: PUBLIC) }
    let!(:video)          { FactoryGirl.create(:video, clan_id: clan.id, access_type_id: access_type.id) }
    let(:heading)         { video.header }
    let(:page_title)      { video.title }
    
    before { visit clan_video_path(clan, video) }
    it_should_behave_like "all video pages"    
                  
    describe "with public access" do      
      describe "visit as nonuser" do
        before { visit clan_video_path(clan, video) }
        
        specify { current_url.should eq clan_video_url(clan, video) }        
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
       
        specify { current_url.should eq signin_url(:clan_id => clan.slug) }
        it { should have_notice_message('Please sign in') }
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
        
        specify { current_url.should eq signin_url(:clan_id => clan.slug) }
        it { should have_notice_message('Please sign in') }
      end
      
      describe "visit as user" do
        before do
          sign_in user
          visit clan_video_path(clan, video)
        end
        
        specify { current_url.should eq clan_url(clan) }
        it { should have_error_message("You must be a memeber of #{clan.name} to watch those videos") }
      end
      
      describe "visit as clan user" do
        before do
          sign_in clan_user
          visit clan_video_path(clan, video)
        end
        
        specify { current_url.should eq clan_video_url(clan, video) }        
      end          
    end
 
    describe "for YouTube channel" do
      let!(:video)          { FactoryGirl.create(:video, clan_id: clan.id, access_type_id: access_type.id, youtube_channel: 'fearthefallenclan', video_list: nil, filters: nil) }
      before { visit clan_video_path(clan, video) }
      
      it_should_behave_like "all pages with video player"
      it { should_not have_selector('div.video-list') }
      it { should_not have_selector('div.video_thumbnail_row') }
      it { should_not have_selector('div.filter_headers') }
      it { should_not have_selector('div.filters') }            
    end
    
    describe "for video list page" do
      let!(:video)          { FactoryGirl.create(:video, clan_id: clan.id, access_type_id: access_type.id, filters: nil, youtube_channel: nil, video_list: "[{\"id\":\"sP0uk76wuq8\",\"title\":\"World Of Tanks Mapguide - Sacred Valley\"},{\"id\":\"5cv4G59BY3c\",\"title\":\"World Of Tanks 8.7 Patch Review\"},{\"id\":\"k4DZau_l-EI\",\"title\":\"World Of Tanks 8.8 Maps Review\"}]") }
      before { visit clan_video_path(clan, video) }
            
      it_should_behave_like "all pages with video player"
      it { should have_selector('div.video-list') }
      it { should have_selector('div.video_thumbnail_row') }
      it { should_not have_selector('div.filter_headers') }
      it { should_not have_selector('div.filters') }
      # @TODO check that each video is in the video list
    end
    
    describe "for page with filters" do
      let!(:video)          { FactoryGirl.create(:video, 
                                                        clan_id: clan.id, 
                                                        access_type_id: access_type.id, 
                                                        youtube_channel: nil, 
                                                        video_list: "[{\"id\":\"sP0uk76wuq8\",\"title\":\"World Of Tanks Mapguide - Sacred Valley\"},{\"id\":\"5cv4G59BY3c\",\"title\":\"World Of Tanks 8.7 Patch Review\"},{\"id\":\"k4DZau_l-EI\",\"title\":\"World Of Tanks 8.8 Maps Review\"}]") }
      let!(:filters)  { JSON.parse(video.filters) }
                                                              
      before { visit clan_video_path(clan, video) }
            
      it_should_behave_like "all pages with video player"      
      it { should have_selector('div.filter_headers') }
      it { should have_selector('div.filters') }
      
      # check that each filter is present      
      it "should list each filter" do                
        filters.each do |filter|
          expect(page).to have_selector('span', text: filter['name'])
          expect(page).to have_select("tanks_#{filter['name']}", :options => filter['values'].unshift('All'))
        end
      end
    end
  end

end