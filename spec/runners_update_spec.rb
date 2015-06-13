require 'spec_helper'

describe RunnersUpdate do

  it 'has a version number' do
    expect(RunnersUpdate::VERSION).not_to be nil
  end

  describe '#client' do
    before do
      ranges = [1..3, 5..7]
      @result = RunnersUpdate.get('2015sibamata100', ranges)
    end

    it 'number' do
      expect(@result[0].number).to eq '1'
    end

  end

  describe '' do
    error_result = RunnersUpdate.get('2015sibamata100', [1000])
    it 'error' do
      expect(error_result).to eq []
    end
  end

end
