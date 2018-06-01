require 'spec_helper_acceptance'

describe 'users::user' do
  context 'create user10' do
    it do
      pp = <<-EOS
        users::user { 'user10':
          ensure => 'present',
        }
      EOS
      apply_manifest(pp, catch_falures: true)
    end

    describe user('user10') do
      it { is_expected.to exist }
      it { is_expected.to belong_to_primary_group 'user10' }
      it { is_expected.to have_home_directory '/home/user10' }
      it { is_expected.to have_login_shell '/bin/bash' }
      its(:encrypted_password) { is_expected.to match(%r{!}) }
    end

    describe file('/home/user10') do
      it { is_expected.not_to exist }
    end
  end

  context 'manage root user' do
    it 'removes root user' do
      pp = <<-EOS
        users::user { 'root':
          ensure => 'absent',
        }
      EOS
      apply_manifest(pp, catch_failures: true)
    end

    describe user('root') do
      it { is_expected.to exist }
    end
  end

  context 'modify root user' do
    it 'with set root parameters' do
      pp = <<-EOS
        users::user { 'root':
          home   => '/home/root',
          uid    => '5000',
          gid    => '5000',
          system => true,
          groups => 'adm',
        }
      EOS
      apply_manifest(pp, catch_failures: true)
    end

    describe user('root') do
      it { is_expected.to have_home_directory '/root' }
      it { is_expected.to have_uid '0' }
      it { is_expected.to belong_to_primary_group 'root' }
      it { is_expected.not_to belong_to_group 'adm' }
    end
  end

  context 'modify user1' do
    it 'with set parameters' do
      pp = <<-EOS
      users::user { 'user1':
        home     => '/home/pub/user1',
        uid      => '5001',
        gid      => '5001',
        groups   => 'adm',
        shell    => '/bin/sh',
        comment  => 'Test User',
        password => '$6$xYvlTRb5$OocebFLvunvHMnp97wsLza6T73WkkcuWEfWlsEjOl9vUP/9OdvB.3d3YjnXq.Nh2IN9DXWUtlKu48pmUnemZT1',
      }

      users::user { 'user2':
        home     => '/home/pub/user2',
        uid      => '5002',
        gid      => '5002',
        groups   => 'adm',
        shell    => '/bin/sh',
        comment  => 'Test User',
        password => '$6$0cNtxAC6$gJLgql9AVBVnay62aRjP687.7GyRx3C8NN7ErB45kqgPGg2Gz0OYQ/ixg3fM/rqr4xgXtDpo8.UJqmU/27NBY/',
      }
      EOS
      apply_manifest(pp, catch_failures: true)
    end

    describe user('user1') do
      it { is_expected.to exist }
      it { is_expected.to belong_to_primary_group 'user1' }
      it { is_expected.to have_home_directory '/home/pub/user1' }
      it { is_expected.to have_login_shell '/bin/sh' }
      it { is_expected.to have_uid '5001' }
      it { is_expected.to belong_to_group 'adm' }
      # its(:encrypted_password) { is_expected.to match(/\$6\$.{8}\$.{86}$/) }
    end

    describe user('user2') do
      it { is_expected.to exist }
      it { is_expected.to belong_to_primary_group 'user2' }
      it { is_expected.to have_home_directory '/home/pub/user2' }
      it { is_expected.to have_login_shell '/bin/sh' }
      it { is_expected.to have_uid '5002' }
      it { is_expected.to belong_to_group 'adm' }
      # its(:encrypted_password) { is_expected.to match(/\$6\$.{8}\$.{86}$/) }
    end

    describe file('/home/pub/user1') do
      it { is_expected.not_to exist }
    end

    describe file('/home/pub/user2') do
      it { is_expected.not_to exist }
    end
  end

  context 'create users with shared group' do
    it 'with set group' do
      pp = <<-EOS
      users::user { 'user21':
        group => 'sharegroup',
      }
      users::user { 'user22':
        group => 'sharegroup',
      }
      EOS
      apply_manifest(pp, catch_failures: true)
    end

    describe user('user21') do
      it { is_expected.to exist }
      it { is_expected.to belong_to_primary_group 'sharegroup' }
    end

    describe user('user22') do
      it { is_expected.to exist }
      it { is_expected.to belong_to_primary_group 'sharegroup' }
    end
  end

  context 'modify users group' do
    it 'with set group' do
      pp = <<-EOS
      users::user { 'user21': }
      users::user { 'user22': }
      EOS
      apply_manifest(pp, catch_failures: true)
    end

    describe user('user21') do
      it { is_expected.to exist }
      it { is_expected.to belong_to_primary_group 'user21' }
    end

    describe user('user22') do
      it { is_expected.to exist }
      it { is_expected.to belong_to_primary_group 'user22' }
    end

    describe group('user21') do
      it { is_expected.to exist }
    end

    describe group('user22') do
      it { is_expected.to exist }
    end
  end

  context 'modify users gid' do
    it 'with set gid' do
      pp = <<-EOS
      users::user { 'user21':
        gid => 5021,
      }
      users::user { 'user22':
        gid => 5022,
      }
      EOS
      apply_manifest(pp, catch_failures: true)
    end

    describe group('user21') do
      it { is_expected.to exist }
      it { is_expected.to have_gid '5021' }
    end

    describe group('user22') do
      it { is_expected.to exist }
      it { is_expected.to have_gid '5022' }
    end
  end
end
