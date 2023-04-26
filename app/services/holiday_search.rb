require 'httparty'
require 'json'
require './app/services/holiday_service'
require './app/poros/holidayz'

class HolidaySearch
  def holiday_finder
    service.get_holiday[0..2].map do |data|
      Holidayz.new(data)
    end
  end

  def service
    HolidayService.new
  end
end 