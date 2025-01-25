class RacesController < ApplicationController
  before_action :set_race, only: [ :show, :edit, :update, :destroy ]

  def index
    @races = Race.all
  end

  def show
  end

  def new
    @race = Race.new
  end

  def create
    @race = Race.new(race_params)

    if @race.save
      redirect_to @race, notice: "Race was successfully created."
    else
      flash.now[:alert] = "Race was not created. Please try again."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
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
    params.require(:race).permit(:name, :string)
  end
end
