require 'spec_helper'

describe IdbusApi do
  before do
    IdbusApi.reset!
  end

  after do
    IdbusApi.reset!
  end

 describe "::client" do
    it "creates an IdbusApi::Client" do
      expect(IdbusApi.client).to be_kind_of IdbusApi::Client
    end
    it "caches the client when the same options are passed" do
      expect(IdbusApi.client).to eq(IdbusApi.client)
    end
    it "returns a fresh client when options are not the same" do
      client = IdbusApi.client
      IdbusApi.access_token = "87614b09dd141c22800f96f11737ade5226d7ba8"
      client_two = IdbusApi.client
      client_three = IdbusApi.client
      expect(client).not_to eq(client_two)
      expect(client_three).to eq(client_two)
    end
  end

  describe ".configure" do
    Api::Configurable.keys.each do |key|
      it "sets the #{key.to_s.gsub('_', ' ')}" do
        IdbusApi.configure do |config|
          config.send("#{key}=", key)
        end
        expect(IdbusApi.instance_variable_get(:"@#{key}")).to eq(key)
      end
    end
  end

end
