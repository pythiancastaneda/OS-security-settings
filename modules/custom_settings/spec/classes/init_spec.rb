require 'spec_helper'
describe 'custom_settings' do

  context 'with defaults for all parameters' do
    it { should contain_class('custom_settings') }
  end
end
