require 'spec_helper_acceptance'

describe 'users::ssh' do
  context 'add ssh keys' do
    it do
      pp = <<-EOS
        users::user { 'user40':
          ensure => 'present',
        }
        users::home { 'user40':
          ensure => 'present',
        }
        users::ssh { 'user40':
          require             => Users::Home['user40'],
          ensure              => 'present',
          home                => '/home/user40',
          key_authorized      => 'ssh-rsa test user10',
          key_public_content  => 'ssh-rsa test user40',
          key_private_content => 'ssh private user40',
        }
      EOS
      apply_manifest(pp, :catch_falures => true)
    end

    describe user('user40') do
      it { is_expected.to exist }
    end
    
    describe file('/home/user40/.ssh') do
      it { is_expected.to exist }
      it { is_expected.to be_mode '700' }
      it { is_expected.to be_owned_by 'user40' }
      it { is_expected.to be_grouped_into 'user40' }
    end

    describe file('/home/user40/.ssh/authorized_keys') do
      it { is_expected.to exist }
      it { is_expected.to be_mode '640' }
      it { is_expected.to be_owned_by 'user40' }
      it { is_expected.to be_grouped_into 'user40' }
      its(:content) { is_expected.to match /ssh-rsa test user10/ }
    end

    describe file('/home/user40/.ssh/id_rsa.pub') do
      it { is_expected.to exist }
      it { is_expected.to be_mode '640' }
      it { is_expected.to be_owned_by 'user40' }
      it { is_expected.to be_grouped_into 'user40' }
      its(:content) { is_expected.to match /ssh-rsa test user40/ }
    end

    describe file('/home/user40/.ssh/id_rsa') do
      it { is_expected.to exist }
      it { is_expected.to be_mode '600' }
      it { is_expected.to be_owned_by 'user40' }
      it { is_expected.to be_grouped_into 'user40' }
      its(:content) { is_expected.to match /ssh private user40/ }
    end
  end

  context 'with set parameters' do
    it do
      pp = <<-EOS
        users::user { 'user41':
          ensure => 'present',
        }
        users::home { 'user41':
          ensure => 'present',
        }
        users::ssh { 'user41':
          require             => Users::Home['user41'],
          ensure              => 'present',
          home                => '/home/user41',
          mode_ssh_dir        => '0550',
          mode_authorized_key => '0440',
          mode_config_file    => '0440',
          key_authorized      => 'ssh-rsa test user11',
          key_public_name     => 'import_id_rsa',
          key_public_source   => '/etc/ssh/ssh_host_rsa_key.pub',
          key_private_name    => 'import_id_rsa',
          key_private_source  => '/etc/ssh/ssh_host_rsa_key',
          options             => { 'Host' => '*' },
        }
      EOS
      apply_manifest(pp, :catch_falures => true)
    end

    describe user('user41') do
      it { is_expected.to exist }
    end
    
    describe file('/home/user41/.ssh') do
      it { is_expected.to exist }
      it { is_expected.to be_mode '550' }
    end

    describe file('/home/user41/.ssh/config') do
      it { is_expected.to exist }
      its(:content) { is_expected.to match /Host \*/ }
      it { is_expected.to be_mode '440' }
    end

    describe file('/home/user41/.ssh/authorized_keys') do
      it { is_expected.to exist }
      it { is_expected.to be_mode '440' }
    end

    describe file('/home/user41/.ssh/import_id_rsa.pub') do
      it { is_expected.to exist }
    end

    describe file('/home/user41/.ssh/import_id_rsa') do
      it { is_expected.to exist }
    end
  end
end
