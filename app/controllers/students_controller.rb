class StudentsController < ApplicationController
  # Before any action, find the student based on the ID provided in the params.
  # This applies to :show, :edit, :update, and :destroy actions.
  before_action :find_student, only: [:show, :edit, :update, :destroy]

  # GET /students
  # Displays a list of all students.
  def index
    @students = Student.all
  end

  # GET /students/:id
  # Displays details of a specific student.
  def show
  end

  # GET /students/new
  # Renders the form for creating a new student.
  def new
    @student = Student.new
  end

  # POST /students
  # Handles the creation of a new student.
  def create
    @student = Student.new(student_params)
    if @student.save
      # Redirect to the student's show page if successfully created.
      redirect_to @student, notice: "Student was successfully created."
    else
      # If creation fails, display an alert and re-render the form with errors.
      flash.now[:alert] = "Student was not created. Please try again."
      render :new, status: :unprocessable_entity
    end
  end

  # GET /students/:id/edit
  # Renders the form for editing an existing student.
  def edit
  end

  # PATCH/PUT /students/:id
  # Handles updating an existing student.
  def update
    if @student.update(student_params)
      # Redirect to the student's show page if successfully updated.
      redirect_to @student, notice: "Student was successfully updated."
    else
      # If update fails, display an alert and re-render the form with errors.
      flash.now[:alert] = "Student was not updated. Please try again."
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /students/:id
  # Handles deleting a student from the database.
  def destroy
    @student.destroy
    # Redirect to the students index page with a success message.
    redirect_to students_path, notice: "Student was successfully deleted."
  end

  private

  # Finds and sets the student based on the ID provided in the params.
  def find_student
    @student = Student.find(params[:id])
  end

  # Strong parameters: Permits only the allowed attributes to prevent mass assignment vulnerabilities.
  def student_params
    params.require(:student).permit(:name)
  end
end
