class Api::V0::VendorsController < ApplicationController
  before_action :find_vendor, only: %i[show update destroy]

  def show
    render json: VendorSerializer.new(@vendor)
  end

  def create
    render json: VendorSerializer.new(Vendor.create!(vendor_params)), status: :created
  end

  def update
    @vendor.update!(vendor_params)
    render json: VendorSerializer.new(@vendor)
  end

  def destroy
    @vendor.destroy
  end

  private

  def find_vendor
    @vendor = Vendor.find(params[:id])
  end

  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
  end
end