require 'spec_helper'

describe "Video pages" do
  let!(:clan)           { FactoryGirl.create(:clan) }
  let!(:clan2)            { FactoryGirl.create(:clan) }
  let!(:user)           { FactoryGirl.create(:user) }
  let!(:clan_user)      { FactoryGirl.create(:user, clan_id:clan.id) }
  let!(:access_type)    { FactoryGirl.create(:access_type, name: PUBLIC) }
  let!(:video)          { FactoryGirl.create(:video, clan_id: clan.id, access_type_id: access_type.id) }
  let!(:admin_privilege)  { FactoryGirl.create(:privilege, name: CLAN_ADMIN) }
        
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
      let!(:video)  { FactoryGirl.create(:video, clan_id: clan.id, access_type_id: access_type.id, filters: nil, youtube_channel: nil, video_list: "[{\"id\":\"sP0uk76wuq8\",\"title\":\"World Of Tanks Mapguide - Sacred Valley\"},{\"id\":\"5cv4G59BY3c\",\"title\":\"World Of Tanks 8.7 Patch Review\"},{\"id\":\"k4DZau_l-EI\",\"title\":\"World Of Tanks 8.8 Maps Review\"}]") }
      let!(:videos) { JSON.parse(video.video_list) }
      before { visit clan_video_path(clan, video) }
            
      it_should_behave_like "all pages with video player"
      it { should have_selector('div.video-list') }
      it { should have_selector('div.video_thumbnail_row') }
      it { should_not have_selector('div.filter_headers') }
      it { should_not have_selector('div.filters') }
      
      it "should list each video" do
        videos.each do |video|
          expect(page).to have_xpath(".//div[@video-id='#{video['id']}']")
        end
      end
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
          expect(page).to have_xpath(".//div[@#{filter['name'].downcase}-id]")
        end
      end
    end
  end

  describe "new page" do
    
  end
  
  describe "index page" do
    let(:heading)         { "#{clan.name} Video Pages" }
    let(:page_title)      { 'Video Pages' }
        
    describe "as non clan admin" do
      before do
        sign_in clan_user
        visit clan_videos_path(clan)
      end
      
      specify { current_url.should eq clan_url(clan) }
      it { should have_error_message('Only clan admins can visit the videos list page!') }
    end
    
    describe "as clan admin" do      
      describe "for another clan" do
        before do
          clan_user.user_privileges.create!(privilege_id: admin_privilege.id)
          sign_in clan_user
          visit clan_videos_path(clan2)
        end 
               
        specify { current_url.should eq clan_url(clan2) }
        it { should have_error_message('You can only visit the videos list page for your clan!') }                
      end
      
      describe "for the clan" do    
        before do
          clan_user.user_privileges.create!(privilege_id: admin_privilege.id)
          sign_in clan_user
          visit clan_videos_path(clan)
        end 
        
        specify { current_url.should eq clan_videos_url(clan) }
        it_should_behave_like "all video pages" 
        
        # @TODO test that each video in pagination shows
        # @TODO test that there is a link to create a new video page
        
        describe "deleting a video" do
          it { should have_link('delete', href: clan_video_path(clan, video)) }
          
          it "admin should be able to delete video" do
            expect do
              click_link('delete', match: :first)
            end.to change(Video, :count).by(-1)
          end
        end
      end
    end
  end
  
  describe "submitting a DELETE request to the Video#destroy action" do          
    describe "as non clan admin" do
      before { sign_in clan_user, no_capybara: true }
      
      it "should not delete the video" do
          expect { delete clan_video_path(clan, video) }.not_to change(Video, :count)
      end
        
      describe "should have error flash" do
        before { delete clan_video_path(clan, video) }
        
        specify { expect(response).to redirect_to(clan_url(clan)) }
        specify { expect(request.flash[:error]).to eq 'You do not have permission to delete video pages' }        
      end
    end
    
    describe "as clan admin" do
      before do
        clan_user.user_privileges.create!(privilege_id: admin_privilege.id)
        sign_in clan_user, no_capybara: true
      end
      
      describe "for another clan" do
        let!(:video2)          { FactoryGirl.create(:video, clan_id: clan2.id, access_type_id: access_type.id) }
        
        it "should not delete the video" do
          expect { delete clan_video_path(clan2, video2) }.not_to change(Video, :count)
        end
            
        describe "should have error flash" do
          before { delete clan_video_path(clan2, video2) }
          
          specify { expect(response).to redirect_to(clan_url(clan2)) }
          specify { expect(request.flash[:error]).to eq 'You do not have permission to delete video pages from another clan' }
        end                
      end
      
      describe "for the clan" do
        it "should delete the video" do
          expect { delete clan_video_path(clan, video) }.to change(Video, :count).by(-1)
        end
    
        describe "should have correct flash message" do
          before { delete clan_video_path(clan, video) }
          
          specify { expect(request.flash[:success]).to eq 'Video Page has been deleted' }
        end        
      end
    end
  end
end