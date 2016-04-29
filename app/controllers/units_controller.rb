class UnitsController < ApplicationController
  before_action :set_unit, only: [:show, :edit, :update, :destroy]

  # GET /units/1
  # GET /units/1.json
  def show
  end

  # GET /units/new
  def new
    @unit = Unit.new
    @user_building = UserBuilding.new
  end

  # GET /units/1/edit
  def edit
    @user_building = UserBuilding.find(@unit.user_building_id)
  end

  # POST /units
  # POST /units.json
  def create
    @unit = Unit.new(unit_params)
    @user_building = UserBuilding.new

    if user_building_id_nonexistant? # create new user_building and assign to new unit
      @user_building.update(user_building_params)
      @unit.user_building = @user_building if @user_building.save
    end

    respond_to do |format|
      if @unit.save
        format.html { redirect_to @unit, notice: 'Unit was successfully created.' }
        format.json { render :show, status: :created, location: @unit }
      else
        all_errors = @unit.errors.full_messages + @user_building.errors.full_messages
        format.html { render :new, notice: all_errors }
        format.json { render json: all_errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /units/1
  # PATCH/PUT /units/1.json
  def update
    respond_to do |format|
      if @unit.update(unit_params)
        format.html { redirect_to @unit, notice: 'Unit was successfully updated.' }
        format.json { render :show, status: :ok, location: @unit }
      else
        format.html { render :edit }
        format.json { render json: @unit.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_unit
      @unit = Unit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def unit_params
      params.require(:unit).permit(:user_building_id, :unit_number, :sqfootage, :number_bedrooms, :number_bathrooms, :number_rooms, :number_occupants)
    end

    def user_building_params
      params.require(:user_building).permit(:address, :lat, :lon)
    end

    def user_building_id_nonexistant?
      params[:unit][:user_building_id].empty?
    end
end
