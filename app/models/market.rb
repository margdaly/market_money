class Market < ApplicationRecord
  has_many :market_vendors
  has_many :vendors, through: :market_vendors

  validates_presence_of :id
  
  def vendor_count
    self.vendors.count
  end
end