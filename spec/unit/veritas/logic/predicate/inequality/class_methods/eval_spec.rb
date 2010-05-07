require File.expand_path('../../../../../../../spec_helper', __FILE__)

describe 'Veritas::Logic::Predicate::Inequality.eval' do
  context 'with statement that is true' do
    subject { Logic::Predicate::Inequality.eval(true, false) }

    it { should be(true) }
  end

  context 'with statement that is false' do
    subject { Logic::Predicate::Inequality.eval(true, true) }

    it { should be(false) }
  end
end
