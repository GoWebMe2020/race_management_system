require "rails_helper"

RSpec.describe RacesController, type: :controller do
  let(:valid_attributes) { { name: "5K" } }
  let(:invalid_attributes) { { name: nil } }

  describe "GET #index" do
    context "get all races" do
      it "returns a success response" do
        Race.create! valid_attributes

        get :index, params: {}

        expect(response).to be_successful
      end
    end
  end

  describe "GET #show" do
    context "get a race" do
      it "returns a success response" do
        race = Race.create! valid_attributes

        get :show, params: { id: race.to_param }

        expect(response).to be_successful
      end
    end
  end

  describe "GET #new" do
    context "get a new race's form" do
      it "returns a success response" do
        get :new, params: {}

        expect(response).to be_successful
      end
    end
  end

  describe "GET #edit" do
    context "get a race to edit" do
      it "returns a success response" do
        race = Race.create! valid_attributes

        get :edit, params: { id: race.to_param }

        expect(response).to be_successful
      end
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new race" do
        expect {
          post :create, params: { race: valid_attributes }
        }.to change(Race, :count).by(1)
      end

      it "redirects to the created race" do
        post :create, params: { race: valid_attributes }

        expect(flash.now[:notice]).to eq("Race was successfully created.")
        expect(response).to redirect_to(Race.last)
      end
    end

    context "with invalid params" do
      it "does not create a new race" do
        expect {
          post :create, params: { race: invalid_attributes }
        }.to change(Race, :count).by(0)
      end

      it "returns an unsuccessful response" do
        post :create, params: { race: invalid_attributes }

        expect(flash.now[:alert]).to eq("Race was not created. Please try again.")
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) { { name: "10K" } }

      it "updates the requested race" do
        race = Race.create! valid_attributes

        put :update, params: { id: race.to_param, race: new_attributes }

        expect(flash.now[:notice]).to eq("Race was successfully updated.")
        expect(race.reload.name).to eq("10K")
      end
    end

    context "with invalid params" do
      it "returns an unsuccessful response (i.e. to display the 'edit' template)" do
        race = Race.create! valid_attributes

        put :update, params: { id: race.to_param, race: invalid_attributes }

        expect(flash.now[:alert]).to eq("Race was not updated. Please try again.")
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested race" do
      race = Race.create! valid_attributes

      expect {
        delete :destroy, params: { id: race.to_param }
      }.to change(Race, :count).by(-1)
      expect(flash.now[:notice]).to eq("Race was successfully destroyed.")
    end
  end
end
