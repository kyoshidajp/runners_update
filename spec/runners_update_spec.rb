require 'spec_helper'

describe RunnersUpdate do

  it 'has a version number' do
    expect(RunnersUpdate::VERSION).not_to be nil
  end

  describe '#client' do
    it 'return number' do
      result = RunnersUpdate.get('2015sibamata100', 1..3, 5..7)
      expect(result[0].number).to eq('1')
    end

    it 'return size' do
      result = RunnersUpdate.get('2015sibamata100', 1..3, 5..7)
      expect(result.size).to eq(6)
    end

    it 'not exist runner' do
      result = RunnersUpdate.get('2015sibamata100', 1000)
      expect(result).to be_empty
    end

    it 'allow string number' do
      result = RunnersUpdate.get('2015sibamata100', '1')
      expect(result[0].number).to eq('1')
    end

    it 'ivalid number' do
      result = RunnersUpdate.get('2015sibamata100', 'xxxx')
      expect(result).to be_empty
    end

    it 'closed race url' do
      expect { RunnersUpdate.get('2014fujitozan', 3314) }.to raise_error(RunnersUpdate::RaceError)
    end
  end
end
