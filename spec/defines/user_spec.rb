require 'spec_helper'

describe 'users::user' do
  context 'user root with wrong home directory' do
    let( :title ){ 'root' }
    let( :params ) do {
      :home => '/home/test',
    } end

    it { should contain_user( 'root' ).with( { :home => nil } ) }
  end

  context 'user1' do
    let( :title ){ 'user1' }

    context 'default parameters' do
      it { should contain_user( 'user1' ) }
    end

    context 'set parameters' do
      let( :params ) do {
        :ensure     => 'present',
        :uid        => '1099',
        :gid        => '1099',
        :home       => '/srv/user1',
        :groups     => [ 'adm' ],
        :password   => 'secure',
      } end

      it { should contain_user( 'user1' ).with(
        {
          :ensure     => 'present',
          :uid        => '1099',
          :gid        => '1099',
          :home       => '/srv/user1',
          :groups     => [ 'adm' ],
          :password   => 'secure',
          :membership => 'inclusive',
        } )
      }
    end
  end
end

