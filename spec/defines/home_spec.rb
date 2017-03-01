require 'spec_helper'

describe 'users::home' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'user root with set parameters' do
        let(:title){ 'root' }
        let(:params) do {
          :home  => '/home/test',
          :mode  => '777',
          :owner => 'user1',
          :group => 'user1',
        } end

        it { should contain_file('/root').with(
          {
            :mode  => '0750',
            :owner => 'root',
            :group => 'root',
          })
        }
      end

      context 'user1' do
        let(:title){ 'user1' }

        context 'default home parameter' do
          it { should contain_file('/home/user1').with(
            {
              :ensure => 'directory',
              :path   => '/home/user1',
              :mode   => '0755',
              :owner  => 'user1',
              :group  => 'user1',
            })
          }
        end

        context 'home path is set' do
          let(:params) do {
            :home   => '/srv/user1',
            :ensure => 'present',
          } end

          it { should contain_file('/srv/user1').with(
            {
              :ensure => 'directory',
              :owner  => 'user1',
              :group  => 'user1',
            })
          }
        end

        context 'with owner, group and mode' do
          let(:params) do {
            :ensure => 'present',
            :owner  => 'user2',
            :group  => 'developer',
            :mode   => '0777',
          } end

          it { should contain_file('/home/user1').with(
            {
              :ensure => 'directory',
              :owner  => 'user2',
              :group  => 'developer',
              :mode   => '0777',
            })
          }
        end

        context 'with bash files content' do
          let(:params) do {
            :ensure               => 'present',
            :bashrc_content       => 'alias testcommand="echo testcommand"',
            :bash_profile_content => 'test -f $HOME/.bashrc && source $HOME/.bashrc',
          } end

          it { should contain_file('/home/user1/.bash_profile').with(
            {
              :ensure => 'present',
              :owner  => 'user1',
              :mode   => '0644',
            })
          }
        end

        context 'with bash files source' do
          let(:params) do {
            :ensure              => 'present',
            :bashrc_source       => '/etc/skel/.bashrc',
            :bash_profile_source => '/etc/skel/.profile',
          } end

          it { should contain_file('/home/user1/.bashrc').with_ensure('present') }
          it { should contain_file('/home/user1/.bash_profile').with_ensure('present') }
        end

        context 'with bashrc source and content' do
          let(:params) do {
            :bashrc_source  => '/etc/skel/.bashrc',
            :bashrc_content => 'alias testcommand="echo testcommand"',
          } end

          it do
            expect { is_expected.to compile }.to \
              raise_error(/\*\*\*use bashrc_source or bashrc_content parameter\*\*\*/)
          end
        end

        context 'with bash_profile source and content' do
          let(:params) do {
            :bash_profile_source  => '/etc/skel/.profile',
            :bash_profile_content => 'alias testcommand="echo testcommand"',
          } end

          it do
            expect { is_expected.to compile }.to \
              raise_error(/\*\*\*use bash_profile_source or bash_profile_content parameter\*\*\*/)
          end
        end
      end
    end
  end
end

