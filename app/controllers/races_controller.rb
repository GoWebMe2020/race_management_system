class RacesController < ApplicationController
  # Before any action, find the race based on the ID provided in the params.
  # This applies to :show, :edit, :update, and :destroy actions.
  before_action :set_race, only: [:show, :edit, :update, :destroy]

  # GET /races
  # Displays a list of all races.
  def index
    @races = Race.all
  end

  # GET /races/:id
  # Displays details of a specific race, including its participants.
  def show
  end

  # GET /races/new
  # Renders the form for creating a new race and builds 8 participant slots.
  def new
    @race = Race.new
    # Pre-build 8 race participants for the form.
    8.times { @race.race_participants.build }
  end

  # POST /races
  # Handles the creation of a new race.
  def create
    @race = Race.new(race_params)

    if @race.save
      # Redirect to the race's show page if successfully created.
      redirect_to @race, notice: "Race was successfully created."
    else
      # If creation fails, display an alert and render the form again.
      flash[:alert] = "Race was not created. Please try again."
      render :new, status: :unprocessable_entity
    end
  end

  # GET /races/:id/edit
  # Renders the form for editing an existing race.
  def edit
    # Ensure there are always 8 participant slots in the form.
    (8 - @race.race_participants.size).times { @race.race_participants.build } if @race.race_participants.size < 8
  end

  # PATCH/PUT /races/:id
  # Handles the update of an existing race.
  def update
    if @race.update(race_params)
      # Redirect to the race's show page if successfully updated.
      redirect_to @race, notice: "Race was successfully updated."
    else
      # If update fails, display an alert and render the form again.
      flash.now[:alert] = "Race was not updated. Please try again."
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /races/:id
  # Handles the deletion of a race.
  def destroy
    @race.destroy!

    # Redirect to the races index page with a success message.
    redirect_to races_path, status: :see_other, notice: "Race was successfully destroyed."
  end

  private

  # Finds and sets the race based on the ID provided in the params.
  def set_race
    @race = Race.find(params[:id])
  end

  # Strong parameters: Permits only the allowed parameters to prevent mass assignment vulnerabilities.
  def race_params
    params.require(:race).permit(
      :name,
      race_participants_attributes: [:id, :student_id, :lane, :place, :_destroy]
    )
  end
end
