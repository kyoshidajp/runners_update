require 'spec_helper'
require 'webmock'
require 'sinatra/base'
require 'erb'

describe RunnersUpdate do

  let(:race_id) { '2015sibamata100' }

  WebMock::API.stub_request(:any, /update\.runnet\.jp/).to_rack(
    Class.new(Sinatra::Base) {
      get '/*' do
        erb = ERB.new(fixture('search.html'))
        erb
      end
      post '*' do
        "Hello"
      end
    })

  it 'has a version number' do
    expect(RunnersUpdate::VERSION).not_to be nil
  end

  describe '#client' do
    it 'return number' do
      result = RunnersUpdate.get(race_id, 1..3, 5..7)
      expect(result[0].number).to eq('1')
    end

    it 'return size' do
      result = RunnersUpdate.get(race_id, 1..3, 5..7)
      expect(result.size).to eq(6)
    end

    it 'not exist runner' do
      result = RunnersUpdate.get(race_id, 1000)
      expect(result).to be_empty
    end

    it 'allow string number' do
      result = RunnersUpdate.get(race_id, '1')
      expect(result[0].number).to eq('1')
    end

    it 'ivalid number' do
      result = RunnersUpdate.get(race_id, 'xxxx')
      expect(result).to be_empty
    end

    it 'closed race url' do
      expect { RunnersUpdate.get('2014fujitozan', 3314) }.to raise_error(RunnersUpdate::RaceError)
    end
  end
end
