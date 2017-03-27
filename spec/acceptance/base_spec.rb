require 'spec_helper_acceptance'

describe 'users' do
  context 'default parameters' do
    let(:pp) do
      <<-EOS
      include '::users'
      EOS
    end
    # Run it twice and test for idempotency
    it_behaves_like "a idempotent resource"
  end
end
