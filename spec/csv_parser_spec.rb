require 'rspec'
require './lib/csv_parser'

RSpec.describe CSVParser do
  describe '.parse' do
    let(:file_name) { "test_file.csv" }
    let(:file_data) { "My sample csv file data" }

    before do
      expect(CSV).to receive(:read).with(file_name).and_return(file_data)
    end

    it 'returns the csv format for the given file' do
      expect(CSVParser.parse(file_name)).to eq(file_data)
    end
  end
end
