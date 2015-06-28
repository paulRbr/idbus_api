require "spec_helper"

describe IdbusApi::Endpoint::Fares do

  before do
    IdbusApi.reset!
  end

  context "Not authenticated", :vcr do
    describe ".fares" do
      it "raises an unauthorized execption" do
        expect {
          IdbusApi.client.fares
        }.to raise_error(Api::Unauthorized)
      end
    end
  end

  context "authenticated", :vcr do
    describe ".fares for a specific route" do
      it "returns a list of fares" do
        client = token_client
        fares = client.fares(origin_id: 1, destination_id: 6)

        expect(fares).to be_an(Array)
        expect(fares.count).to be(85)
        expect(fares.first).to be_a(Sawyer::Resource)

        fare = fares.first
        expect(fare.id).to be(11_640)
        expect(fare.price_cents).to be(2900)
      end
    end

    describe ".fares with wrong parameters" do
      it "raises an error" do
        expect {
          IdbusApi.client.fares(:wrong => true)
        }.to raise_error(Api::Error)
      end
    end
  end
end
