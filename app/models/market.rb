class Market < ApplicationRecord
  has_many :market_vendors, dependent: :destroy
  has_many :vendors, through: :market_vendors

  scope :filter_by_name, ->(name) { where('name ILIKE ?', "%#{name}%") }
  scope :filter_by_city, ->(city) { where('city ILIKE ?', "%#{city}%") }
  scope :filter_by_state, ->(state) { where('state ILIKE ?', "%#{state}%") }

  def vendor_count
    vendors.count
  end
end