require 'spec_helper_acceptance'

describe 'users::jail' do
  context 'default params' do
    let(:pp) do
      <<-EOS
        users::manage { 'user70':
          ensure => 'present',
        }
        users::jail { 'user70':
          ensure  => 'present',
        }
      EOS
    end

    it_behaves_like 'a idempotent resource'

    describe user('user70') do
      it { is_expected.to exist }
    end

    describe file('/home/user70/dev') do
      it { is_expected.to be_directory }
      it { is_expected.to be_mode '755' }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_grouped_into 'root' }
    end

    describe file('/home/user70/in') do
      it { is_expected.to be_directory }
      it { is_expected.to be_mode '755' }
      it { is_expected.to be_owned_by 'user70' }
      it { is_expected.to be_grouped_into 'user70' }
    end

    describe file('/home/user70/out') do
      it { is_expected.to be_directory }
      it { is_expected.to be_mode '755' }
      it { is_expected.to be_owned_by 'user70' }
      it { is_expected.to be_grouped_into 'user70' }
    end
  end

  context 'set dirs parameter' do
    it do
      pp = <<-EOS
        users::jail { 'user70':
          dirs => ['incoming', 'outgoing'],
        }
      EOS
      apply_manifest(pp, catche_falures: true)
    end

    describe file('/home/user70/incoming') do
      it { is_expected.to exist }
    end

    describe file('/home/user70/outgoing') do
      it { is_expected.to exist }
    end
  end
end
