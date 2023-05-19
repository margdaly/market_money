class Atm
  attr_reader :id, :name, :address, :lat, :lon, :distance

  def initialize(attributes)
    @id = nil
    @name = attributes[:name]
    @address = attributes[:address]
    @lat = attributes[:lat]
    @lon = attributes[:lon]
    @distance = attributes[:distance]
  end
end