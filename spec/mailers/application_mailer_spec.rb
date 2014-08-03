require 'spec_helper'
 
describe ApplicationMailer do
  let!(:clan)           { FactoryGirl.create(:clan) }        
  let!(:user)           { FactoryGirl.create(:user, clan_id: clan.id) }
  let!(:application)    { FactoryGirl.create(:application, user_id: user.id, clan_id: clan.id) }
  
  describe 'rejected_application' do
    let(:mail) { ApplicationMailer.rejected_application(user, clan) }
    
    #ensure that the subject is correct
    it 'renders the subject' do
      mail.subject.should == "Application to #{clan.name} has been rejected"
    end
    
    #ensure that the receiver is correct
    it 'renders the receiver email' do
      mail.to.should == [user.email]
    end
    
    #ensure tha the sender is correct
    it 'renders the sender email' do
      mail.from.should == [clan.noreply()]
    end
    
    #ensure that the @user.name variable appears in the email body
    it 'assigns @user.name' do
      mail.body.encoded.should match(user.name)
    end
    
    #ensure that the @clan.name appears in the email body
    it 'assigns @clan.name' do
      mail.body.encoded.should match(clan.name)
    end
    
    #ensure that the ALLIANCE_NAME appears in the email body
    it 'uses ALLIANCE_NAME' do
      mail.body.encoded.should match(ALLIANCE_NAME)
    end    
  end
end