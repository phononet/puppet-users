require 'spec_helper_acceptance'

describe 'users::manage' do
  context 'create system user' do
    let(:pp) do
      <<-EOS
        include users
        users::manage { 'user30':
          ensure => 'present',
          system => true,
        }
      EOS
    end

    it_behaves_like "a idempotent resource"

    describe user('user30') do
      it { is_expected.to exist }
    end
  end

  context 'create users' do
    it do
      pp = <<-EOS
        users::manage { 'user31':
          ensure  => 'present',
          uid     => '5031',
          gid     => '5031',
          shell   => '/bin/bash',
          system  => false,
          groups  => 'adm',
          comment => 'Test User',
        }
        users::manage { 'user32':
          ensure  => 'present',
          uid     => '5032',
          gid     => '5032',
          shell   => '/bin/bash',
          system  => false,
          groups  => 'adm',
          comment => 'Test User',
        }
        users::manage { 'user33':
          ensure  => 'present',
          group   => 'developer',
        }
        users::manage { 'user34':
          ensure  => 'present',
          group   => 'developer',
        }
      EOS

      apply_manifest(pp, :catch_falures => true)
    end

    describe user('user31') do
      it { is_expected.to exist }
      it { is_expected.to have_uid '5031' }
      it { is_expected.to have_login_shell '/bin/bash' }
      it { is_expected.to have_home_directory '/home/user31' }
      it { is_expected.to belong_to_group 'adm' }
    end

    describe file('/home/user31') do
      it { is_expected.to be_directory }
      it { is_expected.to be_mode '755' }
      it { is_expected.to be_owned_by 'user31' }
      it { is_expected.to be_grouped_into 'user31' }
    end

    describe group('user31') do
      it { is_expected.to exist }
      it { is_expected.to have_gid '5031' }
    end

    describe file('/home/user33') do
      it { is_expected.to be_directory }
      it { is_expected.to be_mode '755' }
      it { is_expected.to be_owned_by 'user33' }
      it { is_expected.to be_grouped_into 'developer' }
    end

    describe group('developer') do
      it { is_expected.to exist }
    end
  end

  context 'delete users' do
    it do
      pp = <<-EOS
        users::manage { 'user31':
          ensure      => 'absent',
          remove_home => true,
        }
        users::manage { 'user33':
          ensure      => 'absent',
          remove_home => true,
        }
        users::manage { 'user34':
          ensure => 'present',
          group  => 'developer',
        }
      EOS

      apply_manifest(pp, :catch_falures => true, :opts => {:debug => true, :trace => true})
    end

    describe user('user31') do
      it { is_expected.to_not exist }
    end

    describe file('/home/user31') do
      it { is_expected.to_not exist }
    end

    describe user('user33') do
      it { is_expected.to_not exist }
    end

    describe file('/home/user33') do
      it { is_expected.to_not exist }
    end

    describe group('developer') do
      it { is_expected.to exist }
    end

    describe user('user34') do
      it { is_expected.to exist }
    end

    describe file('/home/user34') do
      it { is_expected.to exist }
    end
  end
end
