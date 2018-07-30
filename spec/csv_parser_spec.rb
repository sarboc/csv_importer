require 'rspec'
require './lib/csv_parser'

RSpec.describe CSVParser do
  it "can init" do
    expect(CSVParser.new.class).to eq(CSVParser)
  end
end
