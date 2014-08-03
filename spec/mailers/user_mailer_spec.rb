require 'spec_helper'
 
describe UserMailer do
  let!(:clan)           { FactoryGirl.create(:clan) }       
  let!(:clan2)          { FactoryGirl.create(:clan) }                   
  let!(:user)           { FactoryGirl.create(:user, clan_id: clan.id) }
  let!(:clanless_user)  { FactoryGirl.create(:user) }
  let!(:application)    { FactoryGirl.create(:application, user_id: user.id, clan_id: clan.id) }
  
  describe 'promoted' do
    let(:mail) { UserMailer.promoted(user, 'Soldier', '') }
    
    #ensure that the subject is correct
    it 'renders the subject' do
      mail.subject.should == 'You have been promoted'
    end
    
    #ensure that the receiver is correct
    it 'renders the receiver email' do
      mail.to.should == [user.email]
    end
    
    #ensure that the sender is correct
    it 'renders the sender email' do
      mail.from.should == [user.clan.noreply()]
    end
    
    #ensure that the @name variable appears in the email body
    it 'assigns @name' do
      mail.body.encoded.should match(user.name)
    end
    
    it 'assigns @role' do
      mail.body.encoded.should match('Soldier')
    end
  end
  
  describe 'demoted' do
    let(:reason) { 'You have been demoted for failing to accomplish your duties' }
    let(:mail) { UserMailer.demoted(user, 'Recruit', reason) }
    
    #ensure that the subject is correct
    it 'renders the subject' do
      mail.subject.should == 'You have been demoted'
    end
    
    #ensure that the receiver is correct
    it 'renders the receiver email' do
      mail.to.should == [user.email]
    end
    
    #ensure that the sender is correct
    it 'renders the sender email' do
      mail.from.should == [user.clan.noreply()]
    end
    
    #ensure that the @name variable appears in the email body
    it 'assigns @name' do
      mail.body.encoded.should match(user.name)
    end    
    
    #ensure that the reason variable appears in the email body
    it 'assigns reason' do
      mail.body.encoded.should match(reason)
    end
    
    it 'assigns @role' do
      mail.body.encoded.should match('Recruit')
    end
  end
  
  describe 'add clanwar' do
    let(:mail) { UserMailer.clanwar_added(user) }
    
    #ensure that the subject is correct
    it 'renders the subject' do
      mail.subject.should == 'You have been added to the clan war team'
    end
    
    #ensure that the receiver is correct
    it 'renders the receiver email' do
      mail.to.should == [user.email]
    end
    
    #ensure that the sender is correct
    it 'renders the sender email' do
      mail.from.should == [user.clan.noreply()]
    end
    
    #ensure that the @name variable appears in the email body
    it 'assigns @name' do
      mail.body.encoded.should match(user.name)
    end
  end
  
  describe 'remove clanwar' do
    let(:mail) { UserMailer.clanwar_removed(user) }
    
    #ensure that the subject is correct
    it 'renders the subject' do
      mail.subject.should == 'You have been removed from the clan war team'
    end
    
    #ensure that the receiver is correct
    it 'renders the receiver email' do
      mail.to.should == [user.email]
    end
    
    #ensure that the sender is correct
    it 'renders the sender email' do
      mail.from.should == [user.clan.noreply()]
    end
    
    #ensure that the @name variable appears in the email body
    it 'assigns @name' do
      mail.body.encoded.should match(user.name)
    end    
  end
  
  describe 'request_password_reset' do
    let(:token) { User.new_remember_token }
    let(:mail) { UserMailer.request_password_reset(user, token) }
 
    #ensure that the subject is correct
    it 'renders the subject' do
      mail.subject.should == "#{user.clan.name} Website Password Reset Request"
    end
 
    #ensure that the receiver is correct
    it 'renders the receiver email' do
      mail.to.should == [user.email]
    end
 
    #ensure that the sender is correct
    it 'renders the sender email' do
      mail.from.should == [user.clan.noreply()]
    end
 
    #ensure that the @name variable appears in the email body
    it 'assigns @name' do
      mail.body.encoded.should match(user.name)
    end
  end  
  
  describe 'clanless request_password_reset' do
    let(:token) { User.new_remember_token }
    let(:mail) { UserMailer.request_password_reset(clanless_user, token) }
 
    #ensure that the subject is correct
    it 'renders the subject' do
      mail.subject.should == "#{ALLIANCE_NAME} Website Password Reset Request"
    end
 
    #ensure that the receiver is correct
    it 'renders the receiver email' do
      mail.to.should == [clanless_user.email]
    end
 
    #ensure that the sender is correct
    it 'renders the sender email' do
      mail.from.should == [ALLIANCE_NOREPLY]
    end
 
    #ensure that the @name variable appears in the email body
    it 'assigns @name' do
      mail.body.encoded.should match(clanless_user.name)
    end    
  end
  
  describe 'password_reset' do
    let(:mail) { UserMailer.password_reset(user) }
 
    #ensure that the subject is correct
    it 'renders the subject' do
      mail.subject.should == "#{user.clan.name} Website Password has been Reset"
    end
 
    #ensure that the receiver is correct
    it 'renders the receiver email' do
      mail.to.should == [user.email]
    end
 
    #ensure that the sender is correct
    it 'renders the sender email' do
      mail.from.should == [user.clan.noreply()]
    end
 
    #ensure that the @name variable appears in the email body
    it 'assigns @name' do
      mail.body.encoded.should match(user.name)
    end
  end   
  
  describe 'clanless password_reset' do
    let(:mail) { UserMailer.password_reset(clanless_user) }
 
    #ensure that the subject is correct
    it 'renders the subject' do
      mail.subject.should == "#{ALLIANCE_NAME} Website Password has been Reset"
    end
 
    #ensure that the receiver is correct
    it 'renders the receiver email' do
      mail.to.should == [clanless_user.email]
    end
 
    #ensure that the sender is correct
    it 'renders the sender email' do
      mail.from.should == [ALLIANCE_NOREPLY]
    end
 
    #ensure that the @name variable appears in the email body
    it 'assigns @name' do
      mail.body.encoded.should match(clanless_user.name)
    end    
  end
  
  describe 'user applied_to_clan' do
    let(:mail) { UserMailer.applied_to_clan(user, clan2) }
    
    #ensure that the subject is correct
    it 'renders the subject' do
      mail.subject.should == "Application to #{clan2.name} pending"
    end
    
    #ensure that the receiver is correct
    it 'renders the receiver email' do
      mail.to.should == [user.email]
    end
    
    #ensure that the sender is correct
    it 'renders the sender email' do
      mail.from.should == [clan2.noreply()]
    end
    
    #ensure that the @name variable appears in the email body
    it 'assigns @name' do
      mail.body.encoded.should match(user.name)
    end
    
    #ensure that the @clan variable appears in the email body
    it 'assigns @clan' do
      mail.body.encoded.should match(clan2.name)
    end
    
    #ensure that the sign in link is correct
    # it 'assigns sign_in link' do
      # mail.body.encoded.should match(signin_url(host: ALLIANCE_WEBSITE, clan_id: clan.slug))
    # end
    
    #ensure that the @url variable appears in the email body
    # it 'assigns @url' do
      # mail.body.encoded.should match(signin_url(host: ALLIANCE_WEBSITE, clan_id: clan.slug))
    # end
  end
  
  describe 'user application_deleted' do
    let(:mail) { UserMailer.application_deleted(application) }
    
    #ensure that the subject is correct
    it 'renders the subject' do
      mail.subject.should == "Application to #{application.clan.name} removed"
    end
    
    #ensure that the receiver is correct
    it 'renders the receiver email' do
      mail.to.should == [application.user.email]
    end
    
    #ensure that the sender is correct
    it 'renders the sender email' do
      mail.from.should == [application.clan.noreply()]
    end
    
    #ensure that the @name variable appears in the email body
    it 'assigns @name' do
      mail.body.encoded.should match(application.user.name)
    end
    
    #ensure that the @clan variable appears in the email body
    it 'assigns @clan' do
      mail.body.encoded.should match(application.clan.name)
    end
  end
  
  describe 'user_activated_account' do
    let(:mail) { UserMailer.user_activated_account(user) }
    
    #ensure that the subject is correct
    it 'renders the subject' do
      mail.subject.should == "Welcome to #{clan.name}'s website"
    end
    
    #ensure that the receiver is correct
    it 'renders the receiver email' do
      mail.to.should == [user.email]
    end
    
    #ensure that the sender is correct
    it 'renders the sender email' do
      mail.from.should == [clan.noreply()]
    end
    
    #ensure that the @name variable appears in the email body
    it 'assigns @user.name' do
      mail.body.encoded.should match(application.user.name)
    end
    
    #ensure that the @clan variable appears in the email body
    it 'assigns @clan' do
      mail.body.encoded.should match(application.clan.name)
    end
  end
  
  describe 'user_activated_account_apply_to_clan' do
    let(:mail) { UserMailer.user_activated_account_apply_to_clan(user, clan2) }
    
    #ensure that the subject is correct
    it 'renders the subject' do
      mail.subject.should == "Application to #{clan2.name} pending"
    end
    
    #ensure that the receiver is correct
    it 'renders the receiver email' do
      mail.to.should == [user.email]
    end
    
    #ensure that the sender is correct
    it 'renders the sender email' do
      mail.from.should == [clan.noreply()]
    end
    
    #ensure that the @user.name variable appears in the email body
    it 'assigns @user.name' do
      mail.body.encoded.should match(user.name)
    end
    
    #ensure that the @clan variable appears in the email body
    it 'assigns @clan' do
      mail.body.encoded.should match(clan.name)
    end    
    
    #ensure that the @clan_new variable appears in the email body
    it 'assigns @clan_new' do
      mail.body.encoded.should match(clan2.name)
    end
  end
  
  describe 'joined_alliance' do
    let(:mail) { UserMailer.joined_alliance(user) }
    
    #ensure that the subject is correct
    it 'renders the subject' do
      mail.subject.should == "Welcome to #{ALLIANCE_NAME}"
    end
    
    #ensure that the receiver is correct
    it 'renders the receiver email' do
      mail.to.should == [user.email]
    end
    
    #ensure tha the sender is correct
    it 'renders the sender email' do
      mail.from.should == [ALLIANCE_NOREPLY]
    end
    
    #ensure that the @user.name variable appears in the email body
    it 'assigns @user.name' do
      mail.body.encoded.should match(user.name)
    end
    
    #ensure that the ALLIANCE_NAME appears in the email body
    it 'uses ALLIANCE_NAME' do
      mail.body.encoded.should match(ALLIANCE_NAME)
    end
  end
end