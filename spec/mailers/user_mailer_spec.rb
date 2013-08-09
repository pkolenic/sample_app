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
      mail.from.should == ['noreply@fearthefallen.net']
    end
 
    #ensure that the @name variable appears in the email body
    it 'assigns @name' do
      mail.body.encoded.should match(user.wot_name)
    end
  end
end