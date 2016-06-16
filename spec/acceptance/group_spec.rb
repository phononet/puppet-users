require 'spec_helper_acceptance'

describe 'users::group' do
  context 'default parameters' do
    it 'should create group' do
      pp = <<-EOS
        users::group { group1:
          ensure => 'present',
        }
      EOS
      apply_manifest(pp, :catch_failures => true)
    end

    describe group('group1') do
      it { is_expected.to exist }
    end
  end

  context 'set parameters' do
    it 'should create group with gid and member' do
      pp = <<-EOS
        users::group { group2:
          ensure => 'present',
          gid    => '6002',
        }
      EOS
      apply_manifest(pp, :catch_failures => true)
    end

    describe group('group2') do
      it { is_expected.to exist }
      it { is_expected.to have_gid '6002' }
    end
  end
end
