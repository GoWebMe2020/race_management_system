require "rails_helper"

RSpec.describe StudentsController, type: :controller do
  let(:valid_attributes) { { name: "John Doe" } }
  let(:invalid_attributes) { { name: nil } }

  describe "GET #index" do
    context "get all students" do
      it "returns a success response" do
        Student.create! valid_attributes
        get :index, params: {}

        expect(response).to be_successful
      end
    end
  end

  describe "GET #show" do
    context "get a student" do
      it "returns a success response" do
        student = Student.create! valid_attributes
        get :show, params: { id: student.to_param }

        expect(response).to be_successful
      end
    end
  end

  describe "GET #new" do
    context "get a new student's form" do
      it "returns a success response" do
        get :new, params: {}

        expect(response).to be_successful
      end
    end
  end

  describe "GET #edit" do
    context "get a student to edit" do
      it "returns a success response" do
        student = Student.create! valid_attributes
        get :edit, params: { id: student.to_param }

        expect(response).to be_successful
      end
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Student" do
        expect {
          post :create, params: { student: valid_attributes }
        }.to change(Student, :count).by(1)
      end

      it "redirects to the created student" do
        post :create, params: { student: valid_attributes }

        expect(flash.now[:notice]).to eq("Student was successfully created.")
        expect(response).to redirect_to(Student.last)
      end
    end

    context "with invalid params" do
      it "does not create a new Student" do
        expect {
          post :create, params: { student: invalid_attributes }
        }.to change(Student, :count).by(0)
      end

      it "returns an unsuccessful response (i.e. to display the 'new' template)" do
        post :create, params: { student: invalid_attributes }

        expect(flash.now[:alert]).to eq("Student was not created. Please try again.")
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { name: "Jane Doe" }
      }

      it "updates the requested student" do
        student = Student.create! valid_attributes
        put :update, params: { id: student.to_param, student: new_attributes }

        expect(flash.now[:notice]).to eq("Student was successfully updated.")
        expect(student.reload.name).to eq("Jane Doe")
      end
    end

    context "with invalid params" do
      it "returns an unsuccessful response (i.e. to display the 'edit' template)" do
        student = Student.create! valid_attributes
        put :update, params: { id: student.to_param, student: invalid_attributes }

        expect(flash.now[:alert]).to eq("Student was not updated. Please try again.")
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested student" do
      student = Student.create! valid_attributes
      expect {
        delete :destroy, params: { id: student.to_param }
      }.to change(Student, :count).by(-1)

      expect(flash.now[:notice]).to eq("Student was successfully deleted.")
    end
  end
end
