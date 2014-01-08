require 'spec_helper'
 
describe UserMailer do
  describe 'approved' do
    let(:user) { mock_model(User, :wot_name => 'Lucas', :email => 'lucas@email.com') }
    let(:mail) { UserMailer.approved(user) }
 
    #ensure that the subject is correct
    it 'renders the subject' do
      mail.subject.should == 'Clan Status Approved'
    end
 
    #ensure that the receiver is correct
    it 'renders the receiver email' do
      mail.to.should == [user.email]
    end
 
    #ensure that the sender is correct
    it 'renders the sender email' do
      mail.from.should == [CLAN_NO_REPLAY]
    end
 
    #ensure that the @name variable appears in the email body
    it 'assigns @name' do
      mail.body.encoded.should match(user.wot_name)
    end
  end
  
  describe 'promoted' do
    let(:user) { mock_model(User, :wot_name => 'Lucas', :email => 'lucas@email.com') }
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
      mail.from.should == [CLAN_NO_REPLAY]
    end
    
    #ensure that the @name variable appears in the email body
    it 'assigns @name' do
      mail.body.encoded.should match(user.wot_name)
    end
    
    it 'assigns @role' do
      mail.body.encoded.should match('Soldier')
    end
  end
  
  describe 'demoted' do
    let(:user) { mock_model(User, :wot_name => 'Lucas', :email => 'lucas@email.com') }
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
      mail.from.should == [CLAN_NO_REPLAY]
    end
    
    #ensure that the @name variable appears in the email body
    it 'assigns @name' do
      mail.body.encoded.should match(user.wot_name)
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
    let(:user) { mock_model(User, :wot_name => 'Lucas', :email => 'lucas@email.com') }
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
      mail.from.should == [CLAN_NO_REPLAY]
    end
    
    #ensure that the @name variable appears in the email body
    it 'assigns @name' do
      mail.body.encoded.should match(user.wot_name)
    end
  end
  
  describe 'remove clanwar' do
    let(:user) { mock_model(User, :wot_name => 'Lucas', :email => 'lucas@email.com') }
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
      mail.from.should == [CLAN_NO_REPLAY]
    end
    
    #ensure that the @name variable appears in the email body
    it 'assigns @name' do
      mail.body.encoded.should match(user.wot_name)
    end    
  end
  
  describe 'set as ambassador' do
    let(:user) { mock_model(User, :wot_name => 'Lucas', :email => 'lucas@email.com', :clan_name => 'Another Clan') }
    let(:mail) { UserMailer.made_ambassador(user) }
    
    # ensure that the subject is correct
    it 'renders the subject' do
      mail.subject.should == "You have been appointed as an ambassador to #{CLAN_NAME} for Another Clan"
    end
    
    #ensure that the receiver is correct
    it 'renders the receiver email' do
      mail.to.should == [user.email]
    end
    
    #ensure that the sender is correct
    it 'renders the sender email' do
      mail.from.should == [CLAN_NO_REPLAY]
    end
    
    #ensure that the @name variable appears in the email body
    it 'assigns @name' do
      mail.body.encoded.should match(user.wot_name)
    end 
    
    #ensure that the user.clan appears in the email body
    it 'assigns user.clan' do
      mail.body.encoded.should match(user.clan_name)
    end
  end
  
  describe 'request_password_reset' do
    let(:user) { mock_model(User, :wot_name => 'Lucas', :email => 'lucas@email.com') }
    let(:token) { User.new_remember_token }
    let(:mail) { UserMailer.request_password_reset(user, token) }
 
    #ensure that the subject is correct
    it 'renders the subject' do
      mail.subject.should == "#{CLAN_NAME} Password Reset Request"
    end
 
    #ensure that the receiver is correct
    it 'renders the receiver email' do
      mail.to.should == [user.email]
    end
 
    #ensure that the sender is correct
    it 'renders the sender email' do
      mail.from.should == [CLAN_NO_REPLAY]
    end
 
    #ensure that the @name variable appears in the email body
    it 'assigns @name' do
      mail.body.encoded.should match(user.wot_name)
    end
  end  
  
  describe 'password_reset' do
    let(:user) { mock_model(User, :wot_name => 'Lucas', :email => 'lucas@email.com') }
    let(:mail) { UserMailer.password_reset(user) }
 
    #ensure that the subject is correct
    it 'renders the subject' do
      mail.subject.should == "#{CLAN_NAME} Password has been Reset"
    end
 
    #ensure that the receiver is correct
    it 'renders the receiver email' do
      mail.to.should == [user.email]
    end
 
    #ensure that the sender is correct
    it 'renders the sender email' do
      mail.from.should == [CLAN_NO_REPLAY]
    end
 
    #ensure that the @name variable appears in the email body
    it 'assigns @name' do
      mail.body.encoded.should match(user.wot_name)
    end
  end   
end