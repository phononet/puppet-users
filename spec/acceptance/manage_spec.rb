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

    it_behaves_like 'a idempotent resource'

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
          ensure               => 'present',
          group                => 'developer',
          bashrc_content       => 'alias testfunction_bashrc=""',
          bash_profile_content => 'alias testfunction_profile=""',
        }
        users::manage { 'user34':
          ensure  => 'present',
          group   => 'developer',
        }
      EOS

      apply_manifest(pp, catch_falures: true)
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

    describe file('/home/user33/.bash_profile') do
      it { is_expected.to exist }
      it { is_expected.to be_mode '644' }
    end

    describe file('/home/user33/.bashrc') do
      it { is_expected.to exist }
      it { is_expected.to be_mode '644' }
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

      apply_manifest(pp, catch_falures: true)
    end

    describe user('user31') do
      it { is_expected.not_to exist }
    end

    describe file('/home/user31') do
      it { is_expected.not_to exist }
    end

    describe user('user33') do
      it { is_expected.not_to exist }
    end

    describe file('/home/user33') do
      it { is_expected.not_to exist }
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

  context 'create multi ssh keys' do
    it do
      pp = <<-EOS
        users::manage { 'user35':
          ensure              => 'present',
          key_public_content  => 'ssh-rsa user35',
          key_private_content => 'RSA PRIVATE',
        }
        users::ssh { 'user35_import':
          user                => 'user35',
          key_public_name     => 'import_id_rsa',
          key_public_content  => 'ssh-rsa user35-import',
          key_private_name    => 'import_id_rsa',
          key_private_content => 'RSA PRIVATE import',
        }
      EOS
      apply_manifest(pp, catch_falures: true)
    end

    describe file('/home/user35/.ssh/id_rsa') do
      it { is_expected.to exist }
      it { is_expected.to be_owned_by 'user35' }
    end

    describe file('/home/user35/.ssh/import_id_rsa') do
      it { is_expected.to exist }
      it { is_expected.to be_owned_by 'user35' }
    end
  end

  context 'create sftp users' do
    it do
      pp = <<-EOS
        users::group { 'sftpuser': }
        users::manage { 'user35':
          shell     => '/bin/false',
          comment   => 'SFTP user',
          sftp_jail => true,
          require   => Users::Group['sftpuser'],
        }
      EOS
      apply_manifest(pp, catch_falures: true)
    end

    describe user('user35') do
      it { is_expected.to exist }
    end

    describe file('/home/user35') do
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_grouped_into 'root' }
    end

    describe file('/home/user35/dev') do
      it { is_expected.to be_directory }
    end

    describe file('/home/user35/in') do
      it { is_expected.to be_directory }
    end

    describe file('/home/user35/out') do
      it { is_expected.to be_directory }
    end
  end
end
