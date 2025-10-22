require "rails_helper"

RSpec.describe StoragesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/storages").to route_to("storages#index")
    end

    it "routes to #show" do
      expect(get: "/storages/1").to route_to("storages#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/storages").to route_to("storages#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/storages/1").to route_to("storages#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/storages/1").to route_to("storages#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/storages/1").to route_to("storages#destroy", id: "1")
    end
  end
end
