require 'spec_helper'

describe Pairs do
  it "works" do
    expect(Pairs).to be_a(Module)
  end

  generative do
    it { expect(1).to eq(1) }
  end
end
