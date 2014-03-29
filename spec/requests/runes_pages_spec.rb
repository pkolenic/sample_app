require 'spec_helper'

describe "RunesPages" do
  let!(:title) { FactoryGirl.create(:title, name:"Enchanting") }
  let!(:quality) { FactoryGirl.create(:quality, id: 1, name:"White") }
  let!(:gear_level) { FactoryGirl.create(:gear_level, id: 1, name:"Level 1-10") }
  let!(:glyph_prefix) { FactoryGirl.create(:glyph_prefix, id: 1, name:"Trifling") }
  let!(:essence_type) { FactoryGirl.create(:rune_type, id: 1, name:"Essence") }
  let!(:aspect_type) { FactoryGirl.create(:rune_type, id: 2, name:"Aspect") }
  let!(:potency_type) { FactoryGirl.create(:rune_type, id: 3, name:"Potency") }
  
  subject { page }
  
  shared_examples_for "all rune pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
  end
  
  describe "create rune page" do
    let(:heading)    { 'Add New Rune' }
    let(:page_title) { 'Add New Rune' }
    let(:user) { FactoryGirl.create(:user) }
        
    before do
      sign_in user
      user.appoint_title!(title)      
      visit new_rune_path
    end

    it_should_behave_like "all rune pages"    
  end
  
  describe "create a new rune" do
    let(:user) { FactoryGirl.create(:user) }
    let(:submit) { "Create Rune" }
        
    before do
      sign_in user
      user.appoint_title!(title)
      visit new_rune_path 
    end

    
    describe "with invalid information" do
      it "should not create a rune" do
        expect { click_button submit }.not_to change(Rune, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_title('Add New Rune') }
        it { should have_content('error') }
      end      
    end
    
    describe "with valid information" do   
      before do
          fill_in "Name",         with: "Joda"
          fill_in "Translation",  with: "Base"
      end
      
      describe "essence rune" do
        before { select essence_type.name, from: "rune[rune_type_id]" }
        
        it "should not create a rune" do
          expect { click_button submit }.not_to change(Rune, :count)
        end
        
        it "should create an essence rune" do
          expect { click_button submit }.to change(EssenceRune, :count).by(1)
        end
                
        describe "after saving the rune" do
          before { click_button submit }
          let(:rune) { EssenceRune.find_by(name: 'Joda') }
          
          specify { expect(rune.name).to eq 'Joda' }
          specify { expect(rune.translation).to eq 'Base' }
          it { should have_success_message("Rune created!") }
        end          
      end
      
      describe "aspect rune" do
        before do
            select "1",               from: "rune[level]",        visible: false
            select quality.name,      from: "rune[quality_id]",   visible: false
            select aspect_type.name,  from: "rune[rune_type_id]"
        end    

        it "should not create a rune" do
          expect { click_button submit }.not_to change(Rune, :count)
        end
        
        it "should create an aspect rune" do
          expect { click_button submit }.to change(AspectRune, :count).by(1)
        end 
        
        describe "after saving the rune" do
          before { click_button submit }
          let(:rune) { AspectRune.find_by(name: 'Joda') }
          
          specify { expect(rune.name).to eq 'Joda' }
          specify { expect(rune.translation).to eq 'Base' }
          specify { expect(rune.quality_id).to eq quality.id }
          it { should have_success_message("Rune created!") }
        end                     
      end
      
      describe "potency rune" do
        before do
            select "1",                from: "rune[level]",           visible: false
            select gear_level.name,    from: "rune[gear_level_id]",   visible: false
            select glyph_prefix.name,  from: "rune[glyph_prefix_id]", visible: false
            select potency_type.name,  from: "rune[rune_type_id]"
        end   
        
        it "should not create a rune" do
          expect { click_button submit }.not_to change(Rune, :count)
        end
        
        it "should create an potency rune" do
          expect { click_button submit }.to change(PotencyRune, :count).by(1)
        end    
        
        describe "after saving the rune" do
          before { click_button submit }
          let(:rune) { PotencyRune.find_by(name: 'Joda') }
          
          specify { expect(rune.name).to eq 'Joda' }
          specify { expect(rune.translation).to eq 'Base' }
          specify { expect(rune.gear_level_id).to eq gear_level.id }
          specify { expect(rune.glyph_prefix_id).to eq glyph_prefix.id }
          it { should have_success_message("Rune created!") }
        end                   
      end        
    end    
  end

  describe "index with Aspect Rune" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:rune) { FactoryGirl.create(:aspect_rune)} 
    
    before do 
      sign_in user
      visit runes_path
    end
    
    describe "not an Enchantment Loremaster" do
      it { should_not have_link('delete') }
      it { should_not have_link('edit') }
    end
    
    describe "as an Enchantment Loremaster" do
      before do
        user.appoint_title!(title)
        visit runes_path 
      end
      
      describe "delete links" do
        it { should have_link('delete', href: aspect_rune_path(AspectRune.first)) }
        it "should be able to delete a rune" do
          expect do
            click_link('delete', match: :first)
          end.to change(AspectRune, :count).by(-1)
        end            
      end
      
      describe "edit links" do
        it { should have_link('edit', href: edit_aspect_rune_path(AspectRune.first)) }
                  
        describe "clicking on an edit link" do
          before { click_link('edit', match: :first) }
          
          it { should have_title('Edit Rune') }
        end
      end       
    end
  end
  
  describe "index" do
    let(:heading) { 'Runes' }
    let(:page_title) { 'Runes' }
    let(:user) { FactoryGirl.create(:user) }
          
    before(:all) do
       25.times { FactoryGirl.create(:essence_rune) }       
    end
    after(:all) { EssenceRune.delete_all }
    
    before do
      sign_in user
      visit runes_path
     end
    
    it_should_behave_like "all rune pages"
    it { should_not have_selector('#add-rune') }    
    
    describe "should have add rune button" do
      before do
        user.appoint_title!(title)
        visit runes_path 
      end
              
      it { should have_selector('#add-rune') }      
    end
    
    describe "pagination" do
      it { should have_selector('div.pagination') }

      it "should list each rune" do
        EssenceRune.paginate(page: 1, :per_page => 10).each do |rune|
          expect(page).to have_selector('td', text: rune.name)
          expect(page).to have_selector('td', text: rune.translation)
        end
      end      
    end
    
    describe "not an Enchantment Loremaster" do
      it { should_not have_link('delete') }
      it { should_not have_link('edit') }
    end
    
    describe "as an Enchantment Loremaster" do
      before do
        user.appoint_title!(title)
        visit runes_path 
      end
              
      describe "delete links" do
        it { should have_link('delete', href: essence_rune_path(EssenceRune.first)) }
        it "should be able to delete a rune" do
          expect do
            click_link('delete', match: :first)
          end.to change(EssenceRune, :count).by(-1)
        end            
      end
      
      describe "edit links" do
        it { should have_link('edit', href: edit_essence_rune_path(EssenceRune.first)) }
                  
        describe "clicking on an edit link" do
          before { click_link('edit', match: :first) }
          
          it { should have_title('Edit Rune') }
        end
      end      
    end
  end
end
