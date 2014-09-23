require 'spec_helper'

describe 'users::home' do
  context 'user root with wrong home directory' do
    let( :title ){ 'root' }
    let( :params ) do {
      :home => '/home/test',
    } end

    it { should contain_file( '/root' ).with_mode( '0750' ) }
  end

  context 'user user1' do
    let( :title ){ 'user1' }

    context 'default home parameter' do
      it { should contain_file( '/home/user1' ).with(
        {
          :ensure => 'directory',
          :path   => '/home/user1',
          :mode   => '0755',
          :owner  => 'user1',
          :group  => 'user1',
        } )
      }
    end

    context 'home path is set' do
      let( :params ) do {
        :home   => '/srv/user1',
        :ensure => 'present',
      } end

      it { should contain_file( '/srv/user1' ).with(
        {
          :ensure => 'directory',
          :owner  => 'user1',
          :group  => 'user1',
        } )
      }
    end
  end
end

