class Market < ApplicationRecord
  attr_accessor :id,
                :name,
                :street,
                :city,
                :county,
                :state,
                :zip,
                :lat,
                :lon

end