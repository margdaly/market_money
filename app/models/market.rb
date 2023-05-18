class Market < ApplicationRecord
  has_many :market_vendors, dependent: :destroy
  has_many :vendors, through: :market_vendors

  validates :name, :city, :state, presence: true

  def vendor_count
    self.vendors.count
  end
end