require 'spec_helper'

describe Pairs do
  let(:pairs) { Pairs.new(&block) }
  let(:block) { -> { } }
  let(:solution) { pairs.solution }

  context "without a block" do
    it "returns an empty solution" do
      expect(solution).to eq([])
    end
  end

  context "with 1 item" do
    let(:block) { -> { item "a" } }

    it "returns that item" do
      expect(solution).to eq([["a"]])
    end
  end

  context "with 2 items" do
    let(:block) { -> { item "a"; item "b" } }

    generative do
      it "returns both items" do
        expect(solution.flatten).to match_array(%w[a b])
      end
    end
  end

  context "with 3 items" do
    let(:block) { -> { item "a"; item "b"; item "c" } }

    generative do
      it "has all items" do
        expect(solution.flatten).to match_array(%w[a b c])
      end

      it "groups them in pairs" do
        expect(solution.first.size).to eq(2)
      end
    end
  end

  context "with a constraint" do
    context "with only one solution" do
      let(:block) {
        -> {
          n 1; n 2; n 3
          constraint { |both| both.reduce(:+) == 3 }
        }
      }

      generative do
        it "returns the solution" do
          expect(solution.first).to match_array([1, 2])
          expect(solution.last).to match_array([3])
        end
      end
    end
  end

  context "with an unsolvable constraint" do
    let(:block) {
      -> {
        n 1; n 2; n 3
        constraint { |both| both.reduce(:+) == 100 }
      }
    }

    generative do
      it "raises a NoSolutionError" do
        expect { solution }.to raise_error(Pairs::NoSolutionError)
      end
    end
  end

  context "with predicate constraints" do
    let(:block) {
      -> {
        good "a"; good "b"; bad "c"; bad "d"
        constraint { |a, b| !(bad?(a) && bad?(b)) }
      }
    }

    generative do
      it "returns a solution" do
        expect(solution.size).to eq(2)
      end
    end
  end

  describe "#together" do
    let(:block) {
      -> {
        item "a"; item "b"; item "c"; item "d"
        together "a", "b"
      }
    }

    generative do
      it "keeps those 2 items together" do
        expect(solution.any? { |both| both.sort == %w[a b] }).to eq(true)
      end
    end
  end

  describe "#separate" do
    let(:block) {
      -> {
        item "a"; item "b"; item "c"; item "d"
        separate "a", "b"
      }
    }

    generative do
      it "keeps those 2 items separate" do
        expect(solution.any? { |both| both.sort == %w[a b] }).to_not eq(true)
      end
    end
  end
end
