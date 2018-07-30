require 'active_support/core_ext/time'
require 'csv'

class CSVParser
  EST_TIME_ZONE = 'Eastern Time (US & Canada)'
  ZIP_CODE_LENGTH = 5
  ZIP_CODE_PLACEHOLDER = '0'

  attr_accessor :csv

  def self.parse(filename)
    csv = CSV.read(filename)
    [csv[0]] + csv[1..-1].map do |line|
      foo_duration = convert_duration_to_seconds(line[4])
      bar_duration = convert_duration_to_seconds(line[5])
      [
        convert_timestamp(line[0]),
        line[1],
        convert_zipcode(line[2]),
        upcase_name(line[3]),
        foo_duration,
        bar_duration,
        sum_durations(foo_duration, bar_duration),
      ]
    end
  end

  def self.convert_timestamp(timestamp)
    Time.strptime("#{timestamp} PST", '%m/%e/%y %r %Z')
        .in_time_zone(EST_TIME_ZONE)
        .iso8601
  end

  def self.convert_zipcode(zipcode)
    zipcode.rjust(ZIP_CODE_LENGTH, ZIP_CODE_PLACEHOLDER)
  end

  def self.upcase_name(name)
    name.upcase
  end

  def self.convert_duration_to_seconds(duration)
    duration_parts = duration.split(':')
    hour_seconds = duration_parts[0].to_i * 60 * 60
    minute_seconds = duration_parts[1].to_i * 60
    second_seconds = duration_parts[2].to_f
    hour_seconds + minute_seconds + second_seconds
  end

  def self.sum_durations(foo, bar)
    (BigDecimal.new("#{foo}") + BigDecimal.new("#{bar}")).to_f
  end
end
