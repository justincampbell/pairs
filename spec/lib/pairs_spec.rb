require 'spec_helper'

describe Pairs do
  let(:pairs) { Pairs.new(&block) }
  let(:block) {
    -> { }
  }
  let(:solution) { pairs.solution }

  context "without a block" do
    it "returns an empty solution" do
      expect(solution).to eq([])
    end
  end

  context "and 1 item" do
    let(:block) { -> { thing "a" } }

    it "returns that item" do
      expect(solution).to eq([["a"]])
    end
  end

  context "and 2 items" do
    let(:block) { -> { thing "a"; thing "b" } }

    generative do
      it "returns both items" do
        expect(solution.flatten).to match_array(%w[a b])
      end
    end
  end

  context "and 3 items" do
    let(:block) {
      -> {
        thing "a"
        thing "b"
        thing "c"
      }
    }

    generative do
      it "has all items" do
        expect(solution.flatten).to match_array(%w[a b c])
      end

      it "groups them in pairs" do
        expect(solution.first.size).to eq(2)
      end
    end
  end
end
