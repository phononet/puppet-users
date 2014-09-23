require 'spec_helper'

describe 'users::ssh' do
  context 'user root with wrong home directory' do
    let( :title ){ 'root' }
    let( :params ) do {
      :home => '/home/test',
    } end

    it { should contain_file( 'ssh_dir_root' ).with(
      {
        :ensure => 'directory',
        :path   => '/root/.ssh',
      } )
    }
  end

  describe 'user1' do
    let( :title ){ 'user1' }
    let( :default_params ) do
      {
        :key_public_name  => 'id_rsa',
        :key_private_name => 'id_rsa',
      }
    end

    context 'default home parameter' do
      let( :params ) do {
        :key_public_name   => 'rsa_id',
        :key_private_name  => 'rsa_id',
      } end

      it { should_not contain_file( 'user1_key_private_rsa_id' ) }
      it { should_not contain_file( 'user1_key_public_rsa_id' ) }
      it { should_not contain_file( 'key_authorized_user1' ) }

      it { should contain_file( 'ssh_dir_user1' ).with(
        {
          :ensure => 'directory',
          :path   => '/home/user1/.ssh',
          :mode   => '0700',
          :owner  => 'user1',
          :group  => 'user1',
        } )
      }
    end
    context 'with set authorized_key' do
      let( :params ) do {
        :home            => '/srv/user1',
        :key_authorized => [ 'ssh-rsa test', 'ssh-dsa test' ],
      } end
      it { should contain_file( 'key_authorized_user1' ).with(
        {
          :ensure  => 'present',
          :path    => '/srv/user1/.ssh/authorized_keys',
          :mode    => '0640',
          :owner   => 'user1',
          :group   => 'user1',
          :content => /^ssh-rsa test\nssh-dsa test/,
        } )
      }
    end

    describe 'key_public is set' do
      context 'content and name parameter is set' do
        let( :params ) do {
          :key_public_name    => 'test_rsa_id',
          :key_public_content => 'ssh-rsa key_public user1',
        } end
        it { should contain_file( 'user1_key_public_test_rsa_id' ).with(
          {
            :ensure  => 'present',
            :path    => '/home/user1/.ssh/test_rsa_id.pub',
            :mode    => '0640',
            :owner   => 'user1',
            :group   => 'user1',
            :content => /^ssh-rsa key_public user1/,
          } )
        }
      end
      context 'source parameter is set' do
        let( :params ) do {
          :key_public_name   => 'rsa_id',
          :key_public_source => 'puppet://private/ssh/user1.pub',
        } end
        it { should contain_file( 'user1_key_public_rsa_id' ).with(
          {
            :path => '/home/user1/.ssh/rsa_id.pub',
          } )
        }
      end
    end
    describe 'key_private is set' do
      context 'content and name parameter is set' do
        let( :params ) do {
          :key_private_name    => 'test_rsa_id',
          :key_private_content => 'ssh-rsa key_private user1',
        } end
        it { should contain_file( 'user1_key_private_test_rsa_id' ).with(
          {
            :ensure  => 'present',
            :path    => '/home/user1/.ssh/test_rsa_id',
            :mode    => '0600',
            :owner   => 'user1',
            :group   => 'user1',
            :content => /^ssh-rsa key_private user1/,
          } )
        }
      end
      context 'source parameter is set' do
        let( :params ) do {
          :key_private_name   => 'rsa_id',
          :key_private_source => 'puppet://private/ssh/user1',
        } end

        it { should contain_file( 'user1_key_private_rsa_id' ).with(
          {
            :path => '/home/user1/.ssh/rsa_id',
          } )
        }
      end
    end
  end
end
