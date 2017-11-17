require 'rails_helper'

RSpec.describe MembersController, type: :controller do
  include Devise::Test::ControllerHelpers

  before(:each) do
    request.env["HTTP_ACCEPT"] = 'application/json'
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @current_user = FactoryGirl.create(:user)
    sign_in @current_user
  end

  describe "POST #create" do
    
    context "the user owns the campaign" do
      before(:each) do
        @campaign = create(:campaign, user: @current_user)
        @member = build(:member, campaign: @campaign)

        post :create, params: {member: @member.attributes}
      end

      it "created member with correct name" do
        expect(Member.last.name).to eql(@member.name)   
      end

      it "created member with correct email" do
        expect(Member.last.email).to eql(@member.email)   
      end

      it "created member was associated with the correct campaign" do
        expect(Member.last.campaign).to eql(@campaign)
      end

      it "return the status 200 when it successful" do
        expect(response).to have_http_status(:success)
      end
  
      # it "return the status 422 when member is already present" do
      #   post :create, params: {member: @member.attributes}
      #   expect(response).to have_http_status(:unprocessable_entity)
      # end
    end

    it "the user not owns campaign" do
      @campaign = create(:campaign)
      @member = build(:member, campaign: @campaign)
      post :create, params: {member: @member.attributes}
      
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
