require 'active_support/core_ext/time'
require 'csv'

class CSVParser
  EST_TIME_ZONE = 'Eastern Time (US & Canada)'

  attr_reader :csv

  def self.parse(filename)
    parser = new filename
    parser.convert_timestamp
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
end
