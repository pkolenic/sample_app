require 'spec_helper'

describe Clan do
  before do
    @clan = Clan.new(name: "Fear the Fallen", wot_clanId: "1000001", clan_short_name:"FTF", clan_email: "fearthefallenclan@gmail.com",
                     clan_motto: "Don't Fear Death As It Is Only The Beginning", clan_google_plus_id: "103259274594875534773",
                     clan_requirements: "Play the Game", 
                     clan_about: "A Clan of Tankers", 
                     clan_logo: "FTF.png", slug: "fear-the-fallen")
  end
  
  subject { @clan }
  
  it { should respond_to(:name) }
  it { should respond_to(:wot_clanId) }
  it { should respond_to(:clan_short_name) }
  it { should respond_to(:clan_email) }
  it { should respond_to(:clan_motto) }
  it { should respond_to(:clan_google_plus_id) }
  it { should respond_to(:clan_requirements) }
  it { should respond_to(:clan_about) }
  it { should respond_to(:clan_logo) }
  it { should respond_to(:slug) }
  it { should respond_to(:users) } 
  it { should respond_to(:applications) }
  
  describe "when name is not present" do
    before { @clan.name = " " }
    it { should_not be_valid }
  end
  
  describe "when name is too long" do
    before { @clan.name = "a" * 257 }
    it { should_not be_valid }
  end
  
  describe "when wot_clanId is not present" do
    before { @clan.wot_clanId = "" }
    it { should_not be_valid }
  end
  
  describe "when wot_clanId is too long" do
    before { @clan.wot_clanId = "1" * 51 }
    it { should_not be_valid }
  end
  
  describe "when clan_wotId format is invalid" do
    it "should be invalid" do
      ids = %w[123a a123 12a34]
      ids.each do |invalid_id|
        @clan.wot_clanId = invalid_id
        expect(@clan).not_to be_valid
      end
    end
  end
  
  describe "when clan_wotId format is valid" do
    it "should be valid" do
      ids = %w[1 12 123 1234]
      ids.each do |valid_id|
        @clan.wot_clanId = valid_id
        expect(@clan).to be_valid
      end
    end
  end
  
  describe "when clan_short_name is not present" do
    before { @clan.clan_short_name = "" }
    it { should_not be_valid }
  end
  
  describe "when clan_short_name is too long" do
    before { @clan.clan_short_name = "a" * 7 }
    it { should_not be_valid }
  end
  
  describe "when clan email is not present" do
    before { @clan.clan_email = "" }
    it { should_not be_valid }
  end
  
  describe "when clan email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
      foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      addresses.each do |invalid_address|
        @clan.clan_email = invalid_address
        expect(@clan).not_to be_valid
      end
    end
  end

  describe "when clan email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn name_@f.net]
      addresses.each do |valid_address|
        @clan.clan_email = valid_address
        expect(@clan).to be_valid
      end
    end
  end
  
  describe "when clan logo is not present" do
    before { @clan.clan_logo = "" }
    it { should_not be_valid }
  end
  
  describe "when clan logo format is invalid" do
    it "should be invalid" do
      paths = %w[logo logo.exe]
      paths.each do |invalid_path|
        @clan.clan_logo = invalid_path
        expect(@clan).not_to be_valid
      end
    end
  end
  
  describe "when clan logo format is valid" do
    it "should be valid" do
      paths = %w[logo.jpg logo.png logo.gif clan-logo.png clan_logo.png]
      paths.each do |valid_path|
        @clan.clan_logo = valid_path
        expect(@clan).to be_valid
      end
    end
  end
  
  describe "clan Methods" do
    it "should generate correct noreply email address" do
       @clan.noreply().should == "noreply@#{@clan.name.downcase.gsub(/\s+/,"")}.net"
    end
  end
end