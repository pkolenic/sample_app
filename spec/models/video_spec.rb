require 'spec_helper'

describe Video do
  let!(:clan) { FactoryGirl.create(:clan) }
  let!(:access_type) { FactoryGirl.create(:access_type) }
  
  before { @video = Video.new(title: "Good Videos", disqus: "goodvideos", header: "Good Videos", youtube_channel: 'goodvideos', 
                       video_list: '[{"id": "id1","title": "title1"},{"id": "id2","title": "title2"}]',
                       filters: '[{"name": "nation","values":["Germany", "France", "US", "USSR"]}]',
                       clan_id: clan.id, access_type_id: access_type.id) }

  subject { @video }
  
  it { should respond_to(:title) }
  it { should respond_to(:disqus) }
  it { should respond_to(:header) }
  it { should respond_to(:youtube_channel) }
  it { should respond_to(:video_list) }
  
  # Clan
  it { should respond_to(:clan_id) }
  it { should respond_to(:clan) }
  
  # Access Type
  it { should respond_to(:access_type_id) }
  it { should respond_to(:access_type) }
  
  describe "when title is too long" do
    before { @video.title = "a" * 51 }
    it { should_not be_valid }
  end 
  
  describe "when title is not present" do
    before { @video.title = nil }
    it { should_not be_valid }
  end
  
  describe "when disqus is too long" do
    before { @video.disqus = "a" * 37 }
    it { should_not be_valid }
  end
  
  describe "when disqus is not present" do
    before { @video.disqus = nil }
    it { should_not be_valid }
  end
  
  describe "when header is too long" do
    before { @video.header = "a" * 257 }
    it { should_not be_valid }
  end
  
  describe "when header is not present" do
    before { @video.header = nil }
    it { should_not be_valid }
  end
  
  describe "when youtube channel is too long" do
    before { @video.youtube_channel = "a" * 57 }
    it { should_not be_valid }
  end
  
  describe "when both youtube channel and video list missing" do
    before do
      @video.youtube_channel = nil
      @video.video_list = nil
    end
    it { should_not be_valid }
  end
  
  describe "when youtube channel is missing but video list present" do
    before { @video.youtube_channel = nil }
    it { should be_valid }
  end
  
  describe "when video list is missing but youtube channel is present" do
    before { @video.video_list = nil }
    it { should be_valid }
  end
  
  describe "when video list is not json" do
    before { @video.video_list = "'sP0uk76wuq8', 'World of Tanks 8.7 Patch Review'" }
    it { should_not be_valid }
  end
  
  describe "when filters is not json" do
    before { @video.filters = "stuff, 'more stuff'" }
    it { should_not be_valid }
  end
  
  describe "when clan id missing" do
    before { @video.clan_id = nil }
    it { should_not be_valid }
  end
  
  describe "when access type id missing" do
    before { @video.access_type_id = nil }
    it { should_not be_valid }
  end
end
