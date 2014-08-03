require 'spec_helper'

describe "User pages" do
  let!(:clan)         { FactoryGirl.create(:clan) }
  let!(:user)         { FactoryGirl.create(:user) }
  let!(:application)  { FactoryGirl.create(:application, user_id: user.id, clan_id: clan.id) }
    
  subject { page }
  
  describe "as non user" do      
    describe "submitting a Reject to the applications#reject action" do
      before { delete application_path(application) }
      
      specify { expect(response).to redirect_to(root_url) }
      specify { expect(request.flash[:error]).to eq 'You do not have permission to reject an application!' }      
    end
    
    it "should not destroy an appplication" do
      expect { delete application_path(application) }.not_to change(Application, :count)
    end
  end
  
  describe "as user in a different clan" do
    let!(:clan2)        { FactoryGirl.create(:clan) }
    let!(:attemptor)    { FactoryGirl.create(:user, clan_id: clan2.id, role: UserDeputyCommander) }
    
    before { sign_in attemptor, no_capybara: true }
    
    describe "submitting a Reject to the applications#reject action" do
      before { delete application_path(application) }
      
      specify { expect(response).to redirect_to(clan_path(clan2)) }
      specify { expect(request.flash[:error]).to eq 'You do not have permission to reject an application from that clan' }        
    end 

    it "should not destroy an appplication" do
      expect { delete application_path(application) }.not_to change(Application, :count)
    end    
  end
   
  describe "as non clan leadership" do
    let!(:attemptor)    { FactoryGirl.create(:user, clan_id: clan.id, role: UserSoldier) }
    
    before { sign_in attemptor, no_capybara: true }
    
    describe "submitting a Reject to the applications#reject action" do
      before { delete application_path(application) }
      
      specify { expect(response).to redirect_to(clan_path(clan)) }
      specify { expect(request.flash[:error]).to eq 'You do not have permission to reject an application!' }        
    end 

    it "should not destroy an appplication" do
      expect { delete application_path(application) }.not_to change(Application, :count)
    end      
  end
   
  describe "as valid rejector" do
    let!(:attemptor)    { FactoryGirl.create(:user, clan_id: clan.id, role: UserDeputyCommander) }
    
    before { sign_in attemptor, no_capybara: true }
    
    describe "submitting a Reject to the applications#reject action" do
      before { delete application_path(application) }
      
      specify { expect(response).to redirect_to(clan_applications_path(clan)) }
      specify { expect(request.flash[:success]).to eq "Application for #{user.name} has been deleted" }
      specify { expect(ActionMailer::Base.deliveries.last.to).to eq [user.email] }
      specify { expect(ActionMailer::Base.deliveries.last.subject).to eq "Application to #{clan.name} has been rejected" }
    end
    
    it "should destroy appplication" do
      expect { delete application_path(application) }.to change(Application, :count).by(-1)
    end      
  end   
end