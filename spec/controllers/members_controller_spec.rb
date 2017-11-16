require 'rails_helper'

RSpec.describe MembersController, type: :controller do
  include Devise::Test::ControllerHelpers

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @current_user = FactoryGirl.create(:user)
    sign_in @current_user
  end

  describe "POST #create" do
    
    context "the user owns the campaign" do
      before(:each) do
        @campaign = create(:campaign, user: @current_user)
        @member = create(:member, campaign: @campaign)
      end

      it "created member with correct data" do
        expect(Member.last).to eql(@member)     
      end

      it "created member was associated with the correct campaign" do
        expect(Member.last.campaign).to eql(@campaign)
      end

      it "return the status 200 when it successful" do
        expect(response).to have_http_status(:success)
      end
  
      it "return the status 422 when member is already present" do
        @campaign.members << @member
        # expect(response).to have_http_status(422)
      end
    end

    it "the user not owns campaign" do
      @campaign = create(:campaign)
      @campaign.members << create(:member)
      expect(response).to have_http_status(403)
    end
  end

  describe "GET #destroy" do
    it "returns http success" do
      # get :destroy
      # expect(response).to have_http_status(:success)
    end
  end

  describe "GET #update" do
    it "returns http success" do
      # get :update
      # expect(response).to have_http_status(:success)
    end
  end

end
