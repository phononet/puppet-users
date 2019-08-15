require 'spec_helper'

describe 'users::manage' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      let(:title) do
        'user1'
      end

      let(:default_params) do
        {
          ensure: 'present',
        }
      end

      context 'user1 with user parameters' do
        let(:params) do
          {
            home: '/srv/user1',
            groups: ['adm'],
            uid: '1099',
            gid: '1099',
            group: 'dev',
            mode: '777',
            shell: '/bin/bash',
            system: 'false',
            comment: 'User1',
            password: 'secret',
          }
        end

        it {
          is_expected.to contain_users__user('user1').with(
            uid: '1099',
            gid: '1099',
            home: '/srv/user1',
            shell: '/bin/bash',
            system: 'false',
            group: 'dev',
            groups: ['adm'],
            comment: 'User1',
            password: 'secret',
          )
        }

        it {
          is_expected.to contain_users__home('user1').with(
            home: '/srv/user1',
            mode: '777',
            group: 'dev',
          )
        }

        it { is_expected.not_to contain_users__ssh('user1') }
      end

      context 'user1 with sftp parameters' do
        let(:params) do
          {
            sftp_jail: true,
            sftp_jail_dirs: ['incoming', 'outgoing'],
          }
        end

        it {
          is_expected.to contain_users__jail('user1').with(
            ensure: 'present',
            home: '/home/user1',
            dirs: ['incoming', 'outgoing'],
          )
        }

        it {
          is_expected.to contain_file('/home/user1').with(
            owner: 'root',
            group: 'root',
          )
        }
      end

      context 'user1 with key parameters' do
        let(:params) do
          {
            ssh_options: { 'Host' => 'dev' },
            mode_ssh_dir: '0750',
            mode_authorized_key: '0440',
            mode_ssh_config_file: '0440',
            key_authorized: 'ssh rsa dev',
            key_public_name: 'sftp_import',
            key_public_content: 'ssh rsa sftp-import',
            key_private_name: 'sftp_import',
            key_private_content: 'private key',
          }
        end

        it {
          is_expected.to contain_users__ssh('user1').with(
            ensure: 'present',
            mode_ssh_dir: '0750',
            mode_authorized_key: '0440',
            mode_config_file: '0440',
            key_authorized: 'ssh rsa dev',
            key_public_name: 'sftp_import',
            key_public_content: 'ssh rsa sftp-import',
            key_private_name: 'sftp_import',
            key_private_content: 'private key',
          )
        }
      end
    end
  end
end
