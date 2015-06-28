require "spec_helper"

describe IdbusApi::Endpoint::Stops do

  before do
    IdbusApi.reset!
  end

  context "Not authenticated", :vcr do
    describe ".stops" do
      it "raises an unauthorized execption" do
        expect {
          IdbusApi.client.stops
        }.to raise_error(Api::Unauthorized)
      end
    end
  end

  context "authenticated", :vcr do
    describe ".stops" do
      it "returns a list of stops" do
        client = token_client
        stops = client.stops

        expect(stops).to be_an(Array)
        expect(stops.count).to be(23)
        expect(stops.first).to be_a(Sawyer::Resource)

        stop = stops.first
        expect(stop.id).to be(2)
        expect(stop.short_name).to eql("Paris CDG (aéroport)")
      end
    end
  end
end
