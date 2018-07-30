require 'rspec'
require './lib/csv_parser'

RSpec.describe CSVParser do
  let(:file_name) { "test_file.csv" }

  describe '.parse' do
    let(:file_data) do
      [
        ['1/1/11 12:00:01 AM', '', '1', 'Superman übertan', '1:23:32.123', '0:0:0.1', 'asasasas'],
        ['12/31/16 11:59:59 PM', '', '94121', '株式会社スタジオジブリ', '0:0:0.1', '0:23:32.123', 'asasasas'],
      ]
    end

    before do
      expect(CSV).to receive(:read).with(file_name).and_return(file_data)
    end

    it 'returns the csv format for the given file' do
      expect(CSVParser.parse(file_name)).to eq([
        ['2011-01-01T03:00:01-05:00', '', '00001', 'SUPERMAN ÜBERTAN', 5012.123, 0.1, 5012.223],
        ['2017-01-01T02:59:59-05:00', '', '94121', '株式会社スタジオジブリ', 0.1, 1412.123, 1412.223]
      ])
    end
  end

  describe '#convert_timestamp' do
    let(:timestamp) { '12/31/16 11:59:59 PM' }
    subject { CSVParser.convert_timestamp(timestamp) }

    it 'parses outputs ISO format in the EST time zone' do
      expect(subject).to eq('2017-01-01T02:59:59-05:00')
    end
  end

  describe '#convert_zipcode' do
    let(:zipcode) { '1' }
    subject { CSVParser.convert_zipcode(zipcode) }

    it 'converts zipcodes to be exactly 5 digits long' do
      expect(subject).to eq('00001')
    end
  end

  describe "#upcase_name" do
    subject { CSVParser.upcase_name(name) }

    context 'when name is all English characters with no accents' do
      let(:name) { 'steve' }
      it {is_expected.to eq('STEVE')}
    end

    context 'when name contains accents' do
      let(:name) { 'Superman übertan' }
      it {is_expected.to eq('SUPERMAN ÜBERTAN')}
    end

    context 'when name is non-English characters' do
      let(:name) { '株式会社スタジオジブリ' }
      it {is_expected.to eq('株式会社スタジオジブリ')}
    end
  end

  describe '#convert_duration_to_seconds' do
    let(:duration) { '111:23:32.123' }
    subject { CSVParser.convert_duration_to_seconds(duration) }

    it 'converts duration to number of seconds' do
      expect(subject).to eq(401012.123)
    end
  end

  describe '#sum_durations' do
    let(:foo) { 5012.123 }
    let(:bar) { 401012.123 }
    subject { CSVParser.sum_durations(foo, bar) }

    it 'converts duration to number of seconds' do
      expect(subject).to eq(406024.246)
    end
  end
end
