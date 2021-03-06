# encoding: utf-8

require 'spec_helper'

describe Tuple, '#header' do
  subject { object.header }

  let(:header) { Relation::Header.new([ [ :id, Integer ] ]) }
  let(:object) { described_class.new(header, [ 1 ])         }

  it_should_behave_like 'an idempotent method'

  it { should equal(header) }
end
