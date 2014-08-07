require 'spec_helper'

describe User do
  let!(:clan)   { FactoryGirl.create(:clan) }
  before do
    @clan = Clan.new(name: "Fear the Fallen", wot_clanId: "1000001", clan_short_name:"FTF", clan_email: "fearthefallenclan@gmail.com",
                     clan_motto: "Don't Fear Death As It Is Only The Beginning", clan_google_plus_id: "103259274594875534773",
                     clan_requirements: "Play the Game", 
                     clan_about: "A Clan of Tankers", 
                     clan_logo: "FTF.png", slug: "fear-the-fallen")
    @user = User.new(name: "Tanker", email: "user@example.com", password: "foobar", password_confirmation: "foobar", clan_id: clan.id)
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:role) }
  it { should respond_to(:clan_war_team) }
  it { should respond_to(:admin) }
  it { should respond_to(:wot_id) }
  it { should respond_to(:reset_token) }
  it { should respond_to(:reset_expire) }
  it { should respond_to(:active) }
  it { should respond_to(:time_zone) }
  it { should respond_to(:last_online) }
  
  # Privileges
  it { should respond_to(:user_privileges) }
  it { should respond_to(:privileges) }
  
  # Application
  it { should respond_to(:application) }

  # Clan Details
  it { should respond_to(:clan) }
  it { should respond_to(:clan_id) }

  # Overall Stats
  it { should respond_to(:wins) }
  it { should respond_to(:losses) }
  it { should respond_to(:battles_count) }
  it { should respond_to(:spotted) }
  it { should respond_to(:frags) }
  it { should respond_to(:survived) }
  it { should respond_to(:experiance) }
  it { should respond_to(:max_experiance) }
  it { should respond_to(:capture_points) }
  it { should respond_to(:defense_points) }
  it { should respond_to(:damage_dealt) }
  it { should respond_to(:hit_percentage) }
  it { should respond_to(:avg_tier) }

  # 24hr Stats
  it { should respond_to(:wins_24hr) }
  it { should respond_to(:losses_24hr) }
  it { should respond_to(:battles_count_24hr) }
  it { should respond_to(:spotted_24hr) }
  it { should respond_to(:frags_24hr) }
  it { should respond_to(:survived_24hr) }
  it { should respond_to(:experiance_24hr) }
  it { should respond_to(:capture_points_24hr) }
  it { should respond_to(:defense_points_24hr) }
  it { should respond_to(:damage_dealt_24hr) }
  it { should respond_to(:hit_percentage_24hr) }
  it { should respond_to(:avg_tier_24hr) }

  # 7 day Stats
  it { should respond_to(:wins_7day) }
  it { should respond_to(:losses_7day) }
  it { should respond_to(:battles_count_7day) }
  it { should respond_to(:spotted_7day) }
  it { should respond_to(:frags_7day) }
  it { should respond_to(:survived_7day) }
  it { should respond_to(:experiance_7day) }
  it { should respond_to(:capture_points_7day) }
  it { should respond_to(:defense_points_7day) }
  it { should respond_to(:damage_dealt_7day) }
  it { should respond_to(:hit_percentage_7day) }
  it { should respond_to(:avg_tier_7day) }

  # 30 day Stats
  it { should respond_to(:wins_30day) }
  it { should respond_to(:losses_30day) }
  it { should respond_to(:battles_count_30day) }
  it { should respond_to(:spotted_30day) }
  it { should respond_to(:frags_30day) }
  it { should respond_to(:survived_30day) }
  it { should respond_to(:experiance_30day) }
  it { should respond_to(:capture_points_30day) }
  it { should respond_to(:defense_points_30day) }
  it { should respond_to(:damage_dealt_30day) }
  it { should respond_to(:hit_percentage_30day) }
  it { should respond_to(:avg_tier_30day) }

  # 60 day Stats
  it { should respond_to(:wins_60day) }
  it { should respond_to(:losses_60day) }
  it { should respond_to(:battles_count_60day) }
  it { should respond_to(:spotted_60day) }
  it { should respond_to(:frags_60day) }
  it { should respond_to(:survived_60day) }
  it { should respond_to(:experiance_60day) }
  it { should respond_to(:capture_points_60day) }
  it { should respond_to(:defense_points_60day) }
  it { should respond_to(:damage_dealt_60day) }
  it { should respond_to(:hit_percentage_60day) }
  it { should respond_to(:avg_tier_60day) }

  # Meta
  it { should respond_to(:tournaments) }
  it { should be_valid }
  it { should_not be_admin }
  it { should_not be_clan_war_team }

  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end

  describe "with clan war team set to 'true" do
    before do
      @user.save!
      @user.toggle!(:clan_war_team)
    end

    it { should be_clan_war_team}
  end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
    its(:role) { should_not be_blank }
    it{ should be_pending_approval }
  end

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
      foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn name_@f.net]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    it "should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end

  describe "name is already taken" do
    before do
      user_with_same_name = @user.dup
      user_with_same_name.active = true
      user_with_same_name.email = "new-email@email.com"
      user_with_same_name.save
    end
    
    it { should_not be_valid }
  end
  
  describe "name is already taken by holder account" do
    before do
      user_with_same_name = @user.dup
      user_with_same_name.active = false
      user_with_same_name.email = "new-email@email.com"
      user_with_same_name.save
    end
 
    it { should be_valid }
  end
  
  describe "when password is not present" do
    before do
      @user = User.new(name: "Example User", email: "user@example.com",
                     password: " ", password_confirmation: " ")
    end
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  describe "when clan_id is too low" do
    before { @user.clan_id = 0 }
    it { should_not be_valid }
  end

  describe "privilege user_privilege associations" do
    before { @user.save }
    
    let!(:privilege)        { FactoryGirl.create(:privilege) }
    let!(:user_privilege)   { @user.user_privileges.build(privilege_id: privilege.id) }
    
    it "should have user privileges" do
      expect(@user.user_privileges.to_a).to eq [user_privilege]
    end
    
    it "should destory associated user privileges" do
      user_privileges = @user.user_privileges.to_a
      @user.destroy
      expect(user_privileges).not_to be_empty
      user_privileges.each do |privilege|
        expect(UserPrivilege.where(id: privilege.id)).to be_empty
      end
    end
  end

  describe "privileges" do
    let(:privilege) { FactoryGirl.create(:privilege) }
    before do
      @user.save
      @user.user_privileges.create!(privilege_id: privilege.id)
    end
       
    its(:privileges) { should include(privilege) }
  end 

  describe "tournament associations" do

    before { @user.save }
    let!(:later_start_tournament) do
      FactoryGirl.create(:tournament, user: @user, start_date: "2099-08-28 18:30:00".to_datetime)
    end
    let!(:earlier_start_tournament) do
      FactoryGirl.create(:tournament, user: @user, start_date: "2099-08-20 18:30:00".to_datetime)
    end

    it "should have the right tournaments in the right order" do
      expect(@user.tournaments.to_a).to eq [earlier_start_tournament, later_start_tournament]
    end

    it "should destroy associated tournaments" do
      tournaments = @user.tournaments.to_a
      @user.destroy
      expect(tournaments).not_to be_empty
      tournaments.each do |tournament|
        expect(Tournament.where(id: tournament.id)).to be_empty
      end
    end
  end
end
