require 'spec_helper'

describe RunnersUpdate do

  it 'has a version number' do
    expect(RunnersUpdate::VERSION).not_to be nil
  end

  describe '#client' do
    before do
      @result = RunnersUpdate.get('2015sibamata100', 1..3, 5..7)
    end

    it 'Correct number' do
      expect(@result[0].number).to eq '1'
    end
    it 'Correct result size' do
      expect(@result.size).to eq 6
    end

  end

  describe '' do
    result = RunnersUpdate.get('2015sibamata100', 1000)
    it 'Not exist runner' do
      expect(result).to eq []
    end
  end

  describe '' do
    it 'String number' do
      result = RunnersUpdate.get('2015sibamata100', '1')
      expect(result[0].number).to eq '1'
    end
    it 'String not number' do
      result = RunnersUpdate.get('2015sibamata100', 'xxxx')
      expect(result).to eq []
    end
  end

end
