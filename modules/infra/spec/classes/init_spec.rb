require 'spec_helper'
describe 'puppetmaster' do

  context 'with defaults for all parameters' do
    it { should contain_class('puppetmaster') }
  end
end
