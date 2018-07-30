require 'active_support/core_ext/time'
require 'csv'

class CSVParser
  EST_TIME_ZONE = 'Eastern Time (US & Canada)'
  ZIP_CODE_LENGTH = 5
  ZIP_CODE_PLACEHOLDER = '0'

  attr_reader :csv

  def self.parse(filename)
    parser = new filename
    parser.convert_timestamp
    parser.convert_zipcode
    parser.convert_foo_duration_seconds
    parser.csv
  end

  def initialize(filename)
    @csv = CSV.read(filename)
  end

  def convert_timestamp
    @csv = csv.each do |line|
      line[0] = Time.strptime("#{line[0]} PST", '%m/%e/%y %r %Z')
                    .in_time_zone(EST_TIME_ZONE)
                    .iso8601
    end
  end

  def convert_zipcode
    @csv = csv.each do |line|
      line[2] = line[2].rjust(ZIP_CODE_LENGTH, ZIP_CODE_PLACEHOLDER)
    end
  end

  def convert_foo_duration_seconds
    @csv = csv.each do |line|
      duration = line[4].split(':')
      hour_seconds = duration[0].to_i * 60 * 60
      minute_seconds = duration[1].to_i * 60
      second_seconds = duration[2].to_f
      line[4] = hour_seconds + minute_seconds + second_seconds
    end
  end
end
