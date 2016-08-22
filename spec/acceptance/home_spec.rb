require 'spec_helper_acceptance'

describe 'users::home' do
  context 'default params' do
    it do
      pp = <<-EOS
        users::user { 'user50':
          ensure => 'present',
        }
        users::home { 'user50':
          require => Users::User['user50'],
          ensure  => 'present',
        }
      EOS
      apply_manifest(pp, :catche_falures => true)
    end

    describe file('/home/user50') do
      it { is_expected.to be_directory }
      it { is_expected.to be_mode '755' }
    end

    describe file('/home/user50/.bashrc') do
      it { is_expected.to_not exist }
    end

    describe file('/home/user50/.bash_profile') do
      it { is_expected.to_not exist }
    end
  end

  context 'with set bash content' do
    it do
      pp = <<-EOS
        users::user { 'user51':
          ensure => 'present',
        }
        users::home { 'user51':
          ensure               => 'present',
          bashrc_content       => 'alias testfunction=""',
          bash_profile_content => 'TESTVARIABLE="testvariable"',
        }
      EOS
      apply_manifest(pp, :catche_falures => true)
    end

    describe file('/home/user51/.bashrc') do
      its(:content) { is_expected.to match /alias testfunction=""/ }
    end

    describe file('/home/user51/.bash_profile') do
      its(:content) { is_expected.to match /TESTVARIABLE="testvariable"/ }
    end
  end

  context 'with set bash source' do
    it do
      pp = <<-EOS
        users::user { 'user51':
          ensure => 'present',
        }
        users::home { 'user51':
          ensure              => 'present',
          bashrc_source       => '/etc/skel/.bashrc',
          bash_profile_source => '/etc/skel/.profile',
        }
      EOS
      apply_manifest(pp, :catche_falures => true)
    end

    describe file('/home/user51/.bashrc') do
      its(:content) { is_expected.to match /\~\/\.bashrc: executed by bash/ }
    end

    describe file('/home/user51/.bash_profile') do
      its(:content) { is_expected.to match /set PATH so it includes/ }
    end
  end
end
