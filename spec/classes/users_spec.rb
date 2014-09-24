require 'spec_helper'

describe 'users' do
  context 'default params' do
    it { should_not contain_users__account( '' ) }
    it { should_not contain_users__ssh( '' ) }
    it { should_not contain_users__user( '' ) }
    it { should_not contain_users__group( '' ) }
  end
  context 'set all parames' do
    let :params do
      {
        :ssh   => { 'user1' => { 'ensure' => 'present' } },
        :user  => { 'user1' => { 'ensure' => 'present' } },
        :home  => { 'user1' => { 'ensure' => 'present' } },
        :group => { 'user1' => { 'ensure' => 'present' } },
      }
    end

    it { should contain_users__ssh( 'user1' ) }
    it { should contain_users__user( 'user1' ) }
    it { should contain_users__home( 'user1' ) }
    it { should contain_users__group( 'user1' ) }
  end
end
