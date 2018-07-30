require 'csv'

class CSVParser
  attr_reader :csv

  def self.parse(filename)
    parser = new filename
    parser.csv
  end

  def initialize(filename)
    @csv = CSV.read(filename)
  end
end
