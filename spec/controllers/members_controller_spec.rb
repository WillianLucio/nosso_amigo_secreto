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
  
      it "return the status 422 when member is already present" do
        post :create, params: {member: @member.attributes}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    it "the user not owns campaign" do
      @campaign = create(:campaign)
      @member = build(:member, campaign: @campaign)
      post :create, params: {member: @member.attributes}
      
      expect(response).to have_http_status(403)
    end
  end

  describe "GET #destroy" do
    context "member exists" do
      context "have permission" do
        before(:each) do
          @campaign = create(:campaign, user: @current_user)
          @member = create(:member, campaign: @campaign)
          @before_count_member = Member.all.size

          delete :destroy, params: {id: @member.id}
        end

        it "member was withdrawn from campaign" do
          expect(@campaign.reload.members).to_not include(@member)
        end

        it "member has been deleted" do
          expect(@before_count_member).to_not eql(Member.all.size)
        end

        it "return status 200 when it successful" do
          expect(response).to have_http_status(:success)
        end
      end

      context "don't have permission" do
        it "return 403 when the user is not allowed" do
          @campaign = create(:campaign)
          @member = create(:member, campaign: @campaign)
          
          delete :destroy, params: { id: @member.id }
          
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    it "return 404 when did not find member" do
      delete :destroy, params: { id: 9999}
      expect(response).to have_http_status(302)
    end
    

    


      #======TESTES======
      # O membro foi removido da campanha?
      # O membro foi apagado
      # O método retornou status 200 quando teve sucesso?
      # O método retornou 404 quando não encontrou o membro para remover naquela equipe?
      # O método retornou 403 quando o usuário não tem permissão de remover aquele membro?
  end

  

  describe "GET #update" do
    it "returns http success" do
      # get :update
      # expect(response).to have_http_status(:success)

      #======TESTES======
      # O membro foi atualizado com sucesso?
      # O método retornou status 200 quando teve sucesso?
      # O método devolveu o status 422 quando o email atualizado já foi adicionado?
    end
  end

end
