require 'spec_helper'
 
describe UserMailer do
  describe 'approved' do
    let(:user) { mock_model(User, :name => 'Luke Skywalker', :email => 'luke.skywalker@email.com') }
    let(:mail) { UserMailer.approved(user) }
 
    #ensure that the subject is correct
    it 'renders the subject' do
      mail.subject.should == 'Guild Status Approved'
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
      mail.body.encoded.should match(user.name)
    end
  end
  
  describe 'request_password_reset' do
    let(:user) { mock_model(User, :name => 'Luke Skywalker', :email => 'luke.skywalker@email.com') }
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
      mail.body.encoded.should match(user.name)
    end
    
    #ensure that the @email variable appears in the email body
    it 'assigns @email' do
      mail.body.encoded.should match(user.email)
    end
  end  
  
  describe 'password_reset' do
    let(:user) { mock_model(User, :name => 'Luke Skywalker', :email => 'luke.skywalker@email.com') }
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
      mail.body.encoded.should match(user.name)
    end
  end   
end