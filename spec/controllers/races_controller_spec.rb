require "rails_helper"

RSpec.describe RacesController, type: :controller do
  let(:student1) { Student.create!(name: "Alice") }
  let(:student2) { Student.create!(name: "Bob") }
  let(:valid_attributes) do
    {
      name: "5K",
      race_participants_attributes: [
        { student_id: student1.id, lane: 1 },
        { student_id: student2.id, lane: 2 }
      ]
    }
  end
  let(:invalid_attributes) do
    {
      name: "5K",
      race_participants_attributes: [
        { student_id: student1.id, lane: 1 }
      ]
    }
  end

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
      it "creates a new race and two race_participants" do
        expect {
          post :create, params: { race: valid_attributes }
        }.to change(Race, :count).by(1)
          .and change(RaceParticipant, :count).by(2)
      end

      it "redirects to the created race" do
        post :create, params: { race: valid_attributes }

        expect(flash[:notice]).to eq("Race was successfully created.")
        expect(response).to redirect_to(Race.last)
      end
    end

    context "with invalid params" do
      it "does not create a new race" do
        expect {
          post :create, params: { race: invalid_attributes }
        }.not_to change(Race, :count)

        expect(RaceParticipant.count).to eq(0)
      end

      it "returns an unsuccessful response" do
        post :create, params: { race: invalid_attributes }

        expect(flash.now[:alert]).to eq("Race was not created. Please try again.")
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "requires at least 2 participants" do
        race = Race.new(name: "Some Race")
        race.race_participants.build(student_id: student1.id, lane: 1)

        expect(race).not_to be_valid
        expect(race.errors[:base]).to include("A race must have at least two participants.")
      end
    end

    context "with duplicate lane or student assignments" do
      it "does not create a race when two students are assigned to the same lane" do
        conflicting_attributes = {
          name: "Conflicting Race",
          race_participants_attributes: [
            { student_id: student1.id, lane: 1 },
            { student_id: student2.id, lane: 1 }
          ]
        }

        expect {
          post :create, params: { race: conflicting_attributes }
        }.not_to change(Race, :count)

        expect(flash.now[:alert]).to eq("A race participant with the same lane or student already exists.")
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "does not create a race when the same student is assigned to multiple lanes" do
        conflicting_attributes = {
          name: "Conflicting Race",
          race_participants_attributes: [
            { student_id: student1.id, lane: 1 },
            { student_id: student1.id, lane: 2 }
          ]
        }

        expect {
          post :create, params: { race: conflicting_attributes }
        }.not_to change(Race, :count)

        expect(flash.now[:alert]).to eq("A race participant with the same lane or student already exists.")
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

        expect(flash[:notice]).to eq("Race was successfully updated.")
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

    context "with duplicate lane or student assignments" do
      it "does not update the race when two students are assigned to the same lane" do
        race = Race.create!(valid_attributes)

        duplicate_attributes = {
          name: "Updated Race",
          race_participants_attributes: [
            { id: race.race_participants.first.id, student_id: student1.id, lane: 1 },
            { id: race.race_participants.last.id, student_id: student2.id, lane: 1 } # Same lane as student1
          ]
        }

        put :update, params: { id: race.to_param, race: duplicate_attributes }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(race.reload.name).not_to eq("Updated Race")
      end

      it "does not update the race when the same student is assigned to multiple lanes" do
        race = Race.create!(valid_attributes)

        duplicate_attributes = {
          name: "Updated Race",
          race_participants_attributes: [
            { id: race.race_participants.first.id, student_id: student1.id, lane: 1 },
            { id: race.race_participants.last.id, student_id: student1.id, lane: 2 }
          ]
        }

        put :update, params: { id: race.to_param, race: duplicate_attributes }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(race.reload.name).not_to eq("Updated Race")
      end
    end
  end


  describe "DELETE #destroy" do
    it "destroys the requested race" do
      race = Race.create! valid_attributes

      expect {
        delete :destroy, params: { id: race.to_param }
      }.to change(Race, :count).by(-1)
      expect(flash[:notice]).to eq("Race was successfully destroyed.")
    end
  end
end
