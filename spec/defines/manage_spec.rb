require 'spec_helper'

describe 'users::manage' do
  let(:title) do
    'user1'
  end

  let(:default_params) do {
    :ensure => 'present',
  } end

  context 'user1 with user parameters' do
    let(:params) do
      {
        :home     => '/srv/user1',
        :groups   => ['adm'],
        :uid      => '1099',
        :gid      => '1099',
        :group    => 'dev',
        :mode     => '777',
        :shell    => '/bin/bash',
        :system   => 'false',
        :comment  => 'User1',
        :password => 'secret',
      }
    end

    it { should contain_users__user('user1').with(
      {
        :uid      => '1099',
        :gid      => '1099',
        :home     => '/srv/user1',
        :shell    => '/bin/bash',
        :system   => 'false',
        :group    => 'dev',
        :groups   => ['adm'],
        :comment  => 'User1',
        :password => 'secret',
      })
    }

    it { should contain_users__home('user1').with(
      {
        :home  => '/srv/user1',
        :mode  => '777',
        :group => 'dev',
      })
    }
  end
end
