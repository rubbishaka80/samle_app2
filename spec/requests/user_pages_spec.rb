require 'spec_helper'
include UsersHelper
describe "UserPages" do
  subject { page } 

  describe "signup page" do
  	before { visit signup_path }

  	it { should have_selector('h1', text: 'Sign up') }
  	it { should have_selector('title', text: full_title('Sign up')) } 

  	describe "with invalid information" do
  		it "should not create a user" do
  			expect { click_button "Create my account" }.not_to change(User, :count)
        page.should have_selector('li', text: "Password can't be blank")
  		end
      describe "error messages" do
        before { click_button "Create my account" }
        it { should have_selector 'title', text: 'Sign up' }
        it { should have_content 'error'  }
        it { should have_content "Password confirmation can't be blank"}
      end
  	end

  	describe "with valid information" do
  		before do 
  			fill_in "Name", with: "Example User"
  			fill_in "Email", with: "user@example.com"
  			fill_in "Password", with: "foobar"
  			fill_in "Confirmation", with: "foobar"
  		end

  		it "should create a user" do
  			expect { click_button "Create my account" }.to change(User, :count).by(1)
  		end
  	

      describe "after saving the user" do
        before { click_button "Create my account"} 
        let(:user) { User.find_by_email("user@example.com") }

        it { should have_selector 'title', text: user.name }
        it { should have_selector 'div.alert.alert-sucess', text: 'Welcome' }
      end
    end
  end

  describe "profile page" do
  	let(:user) { FactoryGirl.create(:user) }
  	before { visit user_path(user) }

  	it { should have_selector('h1', text: user.name) }
  	it { should have_selector('title', text: user.name) }
  end

end
