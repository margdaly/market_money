class Api::V0::MarketsController < ApplicationController
  def index
    render json: MarketSerializer.new(Market.all)
  end

  def show
    render json: MarketSerializer.new(Market.find(params[:id]))
  end

  def search
    if (params[:state]).nil? && (params[:city]).nil? || search_params.empty?
      render json: ErrorSerializer.serialize("Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint."), status: 422
    else
      render json: MarketSerializer.new(Market.filter_all(search_params))
    end
  end

  private

  def search_params
    params.permit(:state, :city, :name)
  end
end