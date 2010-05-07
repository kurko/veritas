require File.expand_path('../../../../../spec_helper', __FILE__)

describe 'Veritas::Attribute::Numeric#valid_value?' do
  let(:attribute) { Veritas::Attribute::Numeric.new(:numeric, :size => 1..50) }

  subject { attribute.valid_value?(value) }

  context 'with a numeric value' do
    context 'that is within the allowed size range' do
      let(:value) { 1 }

      it { should be(true) }
    end

    context 'that is greater than the allowed size range' do
      let(:value) { 51 }

      it { should be(false) }
    end

    context 'that is less than the allowed size range' do
      let(:value) { 0 }

      it { should be(false) }
    end
  end

  context 'with a value that is not a numeric' do
    let(:value) { 'a' }

    it { should be(false) }
  end
end
