require 'spec_helper'

describe 'users::manage' do
  let( :title ){ 'user1' }
  let( :default_params ) do {
    :ensure => 'present',
  } end

  context 'user1 with user parameters' do
    let( :params ) do
      {
        :home     => '/srv/user1',
        :groups   => [ 'adm' ],
        :uid      => '1099',
        :gid      => '1099',
        :shell    => '/bin/bash',
        :system   => 'false',
        :comment  => 'User1',
        :password => 'secret',
      }
    end

    it { should contain_users__user( 'user1' ).with(
      {
        :uid      => '1099',
        :gid      => '1099',
        :home     => '/srv/user1',
        :shell    => '/bin/bash',
        :system   => 'false',
        :groups   => [ 'adm' ],
        :comment  => 'User1',
        :password => 'secret',
      } )
    }
  end

  context 'user1 with group parameters' do
    let( :params ) do {
      :gid  => '1099',
    } end

    it { should contain_users__group( 'user1' ).with(
      {
        :gid  => '1099',
      } )
    }
  end
end

