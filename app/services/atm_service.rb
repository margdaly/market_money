class AtmService
  def self.nearby_atms(lat, lon)
    get_url("/search/2/categorySearch/cash_dispensers.json?geobias=point:#{lat},#{lon}")
  end

  private

  def conn
    Faraday.new(url: 'https://api.tomtom.com') do |f|
      f.params['key'] = ENV['TOMTOM_API_KEY']
      f.params['language'] = 'en-US'
    end
  end

  def get_url(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end
end