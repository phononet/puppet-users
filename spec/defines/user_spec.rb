require 'spec_helper'

describe 'users::user' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'user root with wrong home directory' do
        let(:title) { 'root' }
        let(:params) do
          {
            uid: '111',
            gid: '111',
            system: true,
            group: 'testroot',
            comment: 'TEST ROOT',
            home: '/home/test',
            groups: ['testgroup'],
          }
        end

        it do
          is_expected.to contain_user('root').with(
            uid: nil,
            gid: nil,
            system: false,
            groups: ['testgroup'],
            home: '/root',
            comment: nil,
          )
        end
        it { is_expected.to contain_group('root') }
      end

      context 'user1' do
        let(:title) { 'user1' }

        context 'default parameters' do
          it { is_expected.to contain_user('user1') }
        end

        context 'set parameters' do
          let(:params) do
            {
              ensure: 'present',
              uid: '1099',
              gid: '1099',
              home: '/srv/user1',
              groups: ['adm'],
              password: 'secure',
            }
          end

          it {
            is_expected.to contain_user('user1').with(
              ensure: 'present',
              uid: '1099',
              gid: '1099',
              home: '/srv/user1',
              groups: ['adm'],
              password: 'secure',
              membership: 'inclusive',
            )
          }
        end
      end
    end
  end
end
