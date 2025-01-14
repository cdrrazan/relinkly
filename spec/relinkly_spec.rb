require "spec_helper"

describe Relinkly do
  it "has a version number" do
    expect(Relinkly::VERSION).not_to be nil
  end

  describe '#configure' do
    before do
      Relinkly.configure do |config|
        config.api_key = '123456789'
      end
    end

    it 'has a configurable api key' do
      key = Relinkly.api_key
      expect(key).to eq '123456789'
    end
  end
end
