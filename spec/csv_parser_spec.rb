require 'rspec'
require './lib/csv_parser'

RSpec.describe CSVParser do
  let(:file_name) { "test_file.csv" }
  let(:file_data) { "My sample csv file data" }

  before do
    expect(CSV).to receive(:read).with(file_name).and_return(file_data)
  end

  describe '.parse' do
    let(:file_data) do
      [
        ['1/1/11 12:00:01 AM', '', '1', '', '1:23:32.123'],
        ['12/31/16 11:59:59 PM', '', '94121', '', '0:0:0.1'],
      ]
    end

    it 'returns the csv format for the given file' do
      expect(CSVParser.parse(file_name)).to eq([
        ['2011-01-01T03:00:01-05:00', '', '00001', '', 5012.123],
        ['2017-01-01T02:59:59-05:00', '', '94121', '', 0.1]
      ])
    end
  end

  describe '#convert_timestamp' do
    let(:file_data) do
      [
        ['1/1/11 12:00:01 AM'],
        ['12/31/16 11:59:59 PM'],
      ]
    end
    subject { CSVParser.new(file_name).convert_timestamp }

    it 'parses outputs ISO format in the EST time zone' do
      expect(subject[0][0]).to eq('2011-01-01T03:00:01-05:00')
      expect(subject[1][0]).to eq('2017-01-01T02:59:59-05:00')
    end
  end

  describe '#convert_zipcode' do
    let(:file_data) do
      [
        ['', '', '1'],
        ['', '', '581'],
        ['', '', '94121'],
      ]
    end
    subject { CSVParser.new(file_name).convert_zipcode }

    it 'converts zipcodes to be exactly 5 digits long' do
      expect(subject[0][2]).to eq('00001')
      expect(subject[1][2]).to eq('00581')
      expect(subject[2][2]).to eq('94121')
    end
  end

  describe '#convert_foo_duration_to_seconds' do
    let(:file_data) do
      [
        ['', '', '', '', '1:23:32.123'],
        ['', '', '', '', '111:23:32.123'],
        ['', '', '', '', '0:0:0.1'],
      ]
    end
    subject { CSVParser.new(file_name).convert_foo_duration_seconds }

    it 'converts duration to number of seconds' do
      expect(subject[0][4]).to eq(5012.123)
      expect(subject[1][4]).to eq(401012.123)
      expect(subject[2][4]).to eq(0.1)
    end
  end
end
