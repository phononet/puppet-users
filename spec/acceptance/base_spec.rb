require 'spec_helper_acceptance'

describe 'users' do
  describe 'with "/usr/bin/test -e %"' do
    let(:pp) do
      <<-MANIFEST
      include '::users'
      MANIFEST
    end

    it 'applies the manifest twice with no stderr' do
      idempotent_apply(pp)
    end
  end
end
