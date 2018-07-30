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
    parser.upcase_name
    parser.convert_foo_duration_seconds
    parser.convert_bar_duration_seconds
    parser.sum_durations
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

  def upcase_name
    @csv = csv.each do |line|
      line[3] = line[3].upcase
    end
  end

  def convert_foo_duration_seconds
    @csv = csv.each do |line|
      line[4] = convert_duration_to_seconds(line[4])
    end
  end

  def convert_bar_duration_seconds
    @csv = csv.each do |line|
      line[5] = convert_duration_to_seconds(line[5])
    end
  end

  def sum_durations
    @csv = csv.each do |line|
      line[6] = (BigDecimal.new("#{line[4]}") + BigDecimal.new("#{line[5]}")).to_f
    end
  end

  private

  def convert_duration_to_seconds(duration)
    duration_parts = duration.split(':')
    hour_seconds = duration_parts[0].to_i * 60 * 60
    minute_seconds = duration_parts[1].to_i * 60
    second_seconds = duration_parts[2].to_f
    hour_seconds + minute_seconds + second_seconds
  end
end
