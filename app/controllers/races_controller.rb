class RacesController < ApplicationController
  before_action :set_race, only: [ :show, :edit, :update, :destroy ]

  def index
    @races = Race.all
  end

  def show
  end

  def new
    @race = Race.new
    8.times { @race.race_participants.build }
  end

  def create
    @race = Race.new(race_params)

    if @race.save
      redirect_to @race, notice: "Race was successfully created."
    else
      flash[:alert] = "Race was not created. Please try again."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    (8 - @race.race_participants.size).times { @race.race_participants.build } if @race.race_participants.size < 8
  end

  def update
    if @race.update(race_params)
      redirect_to @race, notice: "Race was successfully updated."
    else
      flash.now[:alert] = "Race was not updated. Please try again."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @race.destroy!

    redirect_to races_path, status: :see_other, notice: "Race was successfully destroyed."
  end

  private

  def set_race
    @race = Race.find(params[:id])
  end

  def race_params
    params.require(:race).permit(
      :name,
      race_participants_attributes: [:id, :student_id, :lane, :place, :_destroy]
    )
  end
end
