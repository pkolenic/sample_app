require 'spec_helper'

describe "Promotion pages" do

  subject { page }
  
  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    let(:non_leader) { FactoryGirl.create(:user) }
    let(:params) do
      { id: non_leader.id,
        promotion: { role_id: UserCompanyCommander, reason: "Tanker has proven himself in combat." } 
      }
    end  
    let(:submit) { "Promote" }

   before do
      user.update_attribute(:role, UserCompanyCommander)
      user.reload.role
      sign_in user
    end

    describe "page" do
      let(:heading)    { 'Promoting' }
      let(:page_title) { 'Promote' }
      
      before do
        visit edit_promotion_path(non_leader)
      end      
      
      it { should have_selector('h1', text: heading) }
      it { should have_title(full_title(page_title)) }
    end
    
    describe "promoting user" do     
      before do
        visit edit_promotion_path(non_leader)
        select "Soldier", from: "promotion[role_id]"
        click_button submit
        non_leader.reload.role
       end
       
       specify { expect(non_leader.role).to eq(UserSoldier) }
       it { should have_success_message('promoted') }
       specify { expect(ActionMailer::Base.deliveries.last.to).to eq [non_leader.email] }
       specify { expect(ActionMailer::Base.deliveries.last.subject).to eq "You have been promoted" }
    end
    
    describe "Demoting user" do     
      before do
        non_leader.update_attribute(:role, UserSoldier)
        non_leader.reload.role
        visit edit_promotion_path(non_leader)
        select "Recruit", from: "promotion[role_id]"
      end
       
      describe "Without reason" do
        before do
          click_button submit
          non_leader.reload.role          
        end

        it { should have_error_message('Unable to demote') }
      end
      
      describe "With reason" do
        before do
          fill_in "promotion[reason]", with: "Unable to perform required duties."
          click_button submit
          non_leader.reload.role   
        end
        
        specify { expect(non_leader.role).to eq(UserRecruit) }
        it { should have_success_message('demoted') }
        specify { expect(ActionMailer::Base.deliveries.last.to).to eq [non_leader.email] }
        specify { expect(ActionMailer::Base.deliveries.last.subject).to eq "You have been demoted" }
      end
      
    end
  end
end
