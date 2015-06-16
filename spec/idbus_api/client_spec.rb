require 'spec_helper'
require 'json'

describe IdbusApi::Client do

  before do
    IdbusApi.reset!
  end

  after do
    IdbusApi.reset!
  end

  describe "module configuration" do

    before do
      IdbusApi.reset!
      IdbusApi.configure do |config|
        IdbusApi::Configurable.keys.each do |key|
          config.send("#{key}=", "Some #{key}")
        end
      end
    end

    after do
      IdbusApi.reset!
    end

    it "inherits the module configuration" do
      client = IdbusApi::Client.new
      IdbusApi::Configurable.keys.each do |key|
        expect(client.instance_variable_get(:"@#{key}")).to eq("Some #{key}")
      end
    end

    describe "with class level configuration" do

      before do
        @opts = {
          :connection_options => {:ssl => {:verify => false}},
          :access_token => "il0veruby"
        }
      end

      it "overrides module configuration" do
        client = IdbusApi::Client.new(@opts)
        expect(client.instance_variable_get(:"@access_token")).to eq("il0veruby")
        expect(client.connection_options[:ssl][:verify]).to be(false)
      end

      it "can set configuration after initialization" do
        client = IdbusApi::Client.new
        client.configure do |config|
          @opts.each do |key, value|
            config.send("#{key}=", value)
          end
        end
        expect(client.instance_variable_get(:"@access_token")).to eq("il0veruby")
      end

     it "masks tokens on inspect" do
        client = IdbusApi::Client.new(:access_token => 'token123')
        inspected = client.inspect
        expect(inspected).not_to include("tokent123")
      end
    end
  end

  describe "authentication" do
    before do
      IdbusApi.reset!
      @client = IdbusApi.client
    end

    describe "with module level config" do
      before do
        IdbusApi.reset!
      end
      it "sets token with .configure" do
        IdbusApi.configure do |config|
          config.access_token = 'token123'
        end
        expect(IdbusApi.client).to be_token_authenticated
      end
      it "sets token with module methods" do
        IdbusApi.access_token = 'token123'
        expect(IdbusApi.client).to be_token_authenticated
      end
    end

    describe "with class level config" do
      it "sets token with instance methods" do
        @client.access_token = 'token123'
        expect(@client).to be_token_authenticated
      end
    end

    describe "when token authenticated", :vcr do
      it "makes authenticated calls" do
        client = token_client

        root_request = stub_get("/").
          with(:headers => {:authorization => "token #{test_token}"})
        client.get("/")
        assert_requested root_request
      end
    end
  end

  describe ".agent" do
    before do
      IdbusApi.reset!
    end
    it "acts like a Sawyer agent" do
      expect(IdbusApi.client.agent).to respond_to :start
    end
    it "caches the agent" do
      agent = IdbusApi.client.agent
      expect(agent.object_id).to eq(IdbusApi.client.agent.object_id)
    end
  end # .agent

  describe ".root" do
    it "fetches the API root" do
      IdbusApi.reset!
      VCR.use_cassette 'root' do
        root = IdbusApi.client.root
        expect(root).to match("This document describes the official iDBUS API")
      end
    end
 end

  describe ".last_response", :vcr do
    before do
      IdbusApi.client.instance_variable_set(:@last_response, nil)
    end

    it "caches the last agent response" do
      IdbusApi.reset!
      client = IdbusApi.client
      expect(client.last_response).to be_nil
      client.get "/"
      expect(client.last_response.status).to eq(200)
    end
  end # .last_response

  describe ".get", :vcr do
    before(:each) do
      IdbusApi.reset!
    end
    it "handles query params" do
      IdbusApi.get "/", :foo => "bar"
      assert_requested :get, "https://api.idbus.com?foo=bar"
    end
    it "handles headers" do
      request = stub_get("/zen").
        with(:query => {:foo => "bar"}, :headers => {:accept => "text/plain"})
      IdbusApi.get "/zen", :foo => "bar", :accept => "text/plain"
      assert_requested request
    end
  end # .get

  describe "when making requests" do
    before do
      IdbusApi.reset!
      @client = IdbusApi.client
    end
    it "sets a default user agent" do
      root_request = stub_get("/").
        with(:headers => {:user_agent => IdbusApi::Default.user_agent})
      @client.get "/"
      assert_requested root_request
      expect(@client.last_response.status).to eq(200)
    end
    it "sets a custom user agent" do
      user_agent = "Mozilla/5.0 I am Spartacus!"
      root_request = stub_get("/").
        with(:headers => {:user_agent => user_agent})
      client = IdbusApi::Client.new(:user_agent => user_agent)
      client.get "/"
      assert_requested root_request
      expect(client.last_response.status).to eq(200)
    end
  end

  describe "redirect handling" do
    it "follows redirect for 301 response" do
      client = token_client

      original_request = stub_get("/foo").
        to_return(:status => 301, :headers => { "Location" => "/bar" })
      redirect_request = stub_get("/bar").to_return(:status => 200)

      client.get("/foo")
      assert_requested original_request
      assert_requested redirect_request
    end

    it "follows redirect for 302 response" do
      client = token_client

      original_request = stub_get("/foo").
        to_return(:status => 302, :headers => { "Location" => "/bar" })
      redirect_request = stub_get("/bar").to_return(:status => 200)

      client.get("/foo")
      assert_requested original_request
      assert_requested redirect_request
    end

    it "keeps authentication info when redirecting to the same host" do
      client = token_client

      original_request = stub_get("/foo").
        with(:headers => {"Authorization" => "token #{test_token}"}).
        to_return(:status => 301, :headers => { "Location" => "/bar" })
      redirect_request = stub_get("/bar").
        with(:headers => {"Authorization" => "token #{test_token}"}).
        to_return(:status => 200)

      client.get("/foo")
      assert_requested original_request
      assert_requested redirect_request
    end

    it "drops authentication info when redirecting to a different host" do
      client = token_client

      original_request = stub_request(:get, idbus_url("/foo")).
        with(:headers => {"Authorization" => "token #{test_token}"}).
        to_return(:status => 301, :headers => { "Location" => "https://example.com/bar" })
      redirect_request = stub_request(:get, "https://example.com/bar").
        to_return(:status => 200)

      client.get("/foo")

      assert_requested original_request
      assert_requested(:get, "https://example.com/bar") { |req|
        req.headers["Authorization"].nil?
      }
    end
  end

  context "error handling" do
    before do
      IdbusApi.reset!
      VCR.turn_off!
    end

    after do
      VCR.turn_on!
    end

    it "raises on 404" do
      stub_get('/booya').to_return(:status => 404)
      expect { IdbusApi.get('/booya') }.to raise_error IdbusApi::NotFound
    end

    it "raises on 500" do
      stub_get('/boom').to_return(:status => 500)
      expect { IdbusApi.get('/boom') }.to raise_error IdbusApi::InternalServerError
    end
  end
end
