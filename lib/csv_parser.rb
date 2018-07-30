require 'active_support/core_ext/time'
require 'csv'

class CSVParser
  EST_TIME_ZONE = 'Eastern Time (US & Canada)'
  ZIP_CODE_LENGTH = 5
  ZIP_CODE_PLACEHOLDER = '0'

  attr_accessor :csv

  def self.parse(filename)
    parser = new filename
    parser.csv = parser.csv.each do |line|
      line[0] = parser.convert_timestamp(line[0])
      line[2] = parser.convert_zipcode(line[2])
      line[3] = parser.upcase_name(line[3])
      line[4] = parser.convert_duration_to_seconds(line[4])
      line[5] = parser.convert_duration_to_seconds(line[5])
      line[6] = parser.sum_durations(line[4], line[5])
    end
    parser.csv
  end

  def initialize(filename)
    @csv = CSV.read(filename)
  end

  def convert_timestamp(timestamp)
    Time.strptime("#{timestamp} PST", '%m/%e/%y %r %Z')
        .in_time_zone(EST_TIME_ZONE)
        .iso8601
  end

  def convert_zipcode(zipcode)
    zipcode.rjust(ZIP_CODE_LENGTH, ZIP_CODE_PLACEHOLDER)
  end

  def upcase_name(name)
    name.upcase
  end

  def convert_duration_to_seconds(duration)
    duration_parts = duration.split(':')
    hour_seconds = duration_parts[0].to_i * 60 * 60
    minute_seconds = duration_parts[1].to_i * 60
    second_seconds = duration_parts[2].to_f
    hour_seconds + minute_seconds + second_seconds
  end

  def sum_durations(foo, bar)
    (BigDecimal.new("#{foo}") + BigDecimal.new("#{bar}")).to_f
  end
end
