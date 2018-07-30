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
end
