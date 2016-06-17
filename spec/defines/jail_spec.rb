require 'spec_helper'

describe 'users::jail' do
  let(:title) { 'user1' }

  context 'default parameters' do
    it do is_expected.to contain_file('/home/user1/dev').with(
      {
        :ensure => 'directory',
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0755',
      })
    end

    it do is_expected.to contain_file('/home/user1/in').with(
      {
        :ensure => 'directory',
        :owner  => 'user1',
        :group  => 'user1',
        :mode   => '0755',
      })
    end
  end

  context 'set dirs parameter' do
    let(:params) do
      {
        :dirs => ['incoming', 'output'],
      }
    end

    it do is_expected.to contain_file('/home/user1/incoming').with(
      {
        :ensure => 'directory',
        :owner  => 'user1',
        :group  => 'user1',
        :mode   => '0755',
      })
    end

    it { is_expected.to contain_file('/home/user1/output') }
  end

  context 'change owner' do
    let(:params) do
      {
        :owner => 'user2',
        :group => 'user2',
      }
    end

    it do is_expected.to contain_file('/home/user1/in').with(
      {
        :ensure => 'directory',
        :owner  => 'user2',
        :group  => 'user2',
      })
    end
  end
end
