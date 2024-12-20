# frozen_string_literal: true

require "rails_helper"

RSpec.describe Tin, type: :model do
  describe "initialization" do
    it "Create Tin with country:CA and number:123456789RT0001" do
      tin = Tin.new("CA", "123456789RT0001")

      expect(tin.country).to eq("CA")
      expect(tin.tin).to eq("123456789RT0001")
    end
  end

  describe "Test attribute accessors after modification" do
    it "allows reading and writing of attributes" do
      tin = Tin.new("CA", "123456789RT0001")
      tin.country = "CA"
      tin.tin = "123456789RT0001"

      expect(tin.country).to eq("CA")
      expect(tin.tin).to eq("123456789RT0001")
    end
  end
end
