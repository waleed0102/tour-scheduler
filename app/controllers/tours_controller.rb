# frozen_string_literal: true

# Tours controller to create and index tours
class ToursController < ApplicationController
  before_action :set_operator, only: [:create]

  def create
    tour = @operator.tours.new(tour_params)
    tour.dates = JSON.parse(params[:tour][:dates]) if params[:tour][:dates]
    tour.repeating_weekdays = JSON.parse(params[:tour][:repeating_weekdays]) if params[:tour][:repeating_weekdays]

    if tour.save
      render json: { success: true, tour: tour }
    else
      render json: { success: false, errors: tour.errors.full_messages.join(',') }
    end
  end

  private

  def set_operator
    @operator = Operator.find(tour_params[:operator_id])
  end

  def tour_params
    params.require(:tour).permit(:name, :operator_id, :recurring,
                                 :repeating_weekdays, :repeating_weekday_no,
                                 :starting_hour, :starting_minute, :length)
  end
end
