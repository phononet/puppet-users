require 'spec_helper'

describe 'users::ssh' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'user root with set home directory' do
        let(:title) { 'root' }
        let(:params) do
          {
            home: '/home/test',
          }
        end

        it {
          is_expected.to contain_file('ssh_dir_root').with(
            ensure: 'directory',
            path: '/home/test/.ssh',
          )
        }
      end

      describe 'user1' do
        let(:title) { 'user1' }
        let(:default_params) do
          {
            key_public_name: 'id_rsa',
            key_private_name: 'id_rsa',
          }
        end

        context 'with default params' do
          it {
            is_expected.not_to contain_file('ssh_dir_user1').with(
              ensure: 'directory',
              path: '/home/user1',
              owner: 'user1',
              group: 'user1',
              mode: '0700',
            )
          }
        end

        context 'home parameter' do
          let(:params) do
            {
              key_public_name: 'rsa_id',
              key_private_name: 'rsa_id',
            }
          end

          it { is_expected.not_to contain_file('user1_key_private_rsa_id') }
          it { is_expected.not_to contain_file('user1_key_public_rsa_id') }
          it { is_expected.not_to contain_file('key_authorized_user1') }

          it {
            is_expected.to contain_file('ssh_dir_user1').with(
              ensure: 'directory',
              path: '/home/user1/.ssh',
              mode: '0700',
              owner: 'user1',
              group: 'user1',
            )
          }
        end

        context 'with set options' do
          let(:params) do
            {
              home: '/srv/user1',
              mode_config_file: '0440',
              options: {
                'Host *' => {
                  'HostName' => 'test.com',
                  'IgnoreUnknown' => true,
                },
              },
            }
          end

          it {
            is_expected.to contain_file('ssh_config_user1').with(
              ensure: 'present',
              path: '/srv/user1/.ssh/config',
              mode: '0440',
              owner: 'user1',
              group: 'user1',
            )
          }
          it {
            is_expected.to contain_file('ssh_config_user1').with_content(
              %r{# File managed by Puppet},
              %r{Host *},
              %r{ +HostName test.com},
              %r{ +IgnoreUnknown yes},
            )
          }
        end

        context 'with set authorized_key' do
          let(:params) do
            {
              home: '/srv/user1',
              key_authorized: ['ssh-rsa test', 'ssh-dsa test'],
              mode_authorized_key: '0440',
            }
          end

          it {
            is_expected.to contain_file('key_authorized_user1').with(
              ensure: 'present',
              path: '/srv/user1/.ssh/authorized_keys',
              mode: '0440',
              owner: 'user1',
              group: 'user1',
              content: %r{^ssh-rsa test\nssh-dsa test},
            )
          }
        end

        context 'with set ssh mode' do
          let(:params) do
            {
              mode_ssh_dir: '0750',
            }
          end

          it { is_expected.to contain_file('ssh_dir_user1').with_mode('0750') }
        end

        describe 'key_public is set' do
          context 'content and name parameter is set' do
            let(:params) do
              {
                key_public_name: 'test_rsa_id',
                key_public_content: 'ssh-rsa key_public user1',
              }
            end

            it {
              is_expected.to contain_file('user1_key_public_test_rsa_id').with(
                ensure: 'present',
                path: '/home/user1/.ssh/test_rsa_id.pub',
                mode: '0640',
                owner: 'user1',
                group: 'user1',
                content: %r{^ssh-rsa key_public user1},
              )
            }
          end
          context 'source parameter is set' do
            let(:params) do
              {
                key_public_name: 'rsa_id',
                key_public_source: 'puppet://private/ssh/user1.pub',
              }
            end

            it {
              is_expected.to contain_file('user1_key_public_rsa_id').with(
                path: '/home/user1/.ssh/rsa_id.pub',
              )
            }
          end
        end
        describe 'key_private is set' do
          context 'content and name parameter is set' do
            let(:params) do
              {
                key_private_name: 'test_rsa_id',
                key_private_content: 'ssh-rsa key_private user1',
              }
            end

            it {
              is_expected.to contain_file('user1_key_private_test_rsa_id').with(
                ensure: 'present',
                path: '/home/user1/.ssh/test_rsa_id',
                mode: '0600',
                owner: 'user1',
                group: 'user1',
                content: %r{^ssh-rsa key_private user1},
              )
            }
          end
          context 'source parameter is set' do
            let(:params) do
              {
                key_private_name: 'rsa_id',
                key_private_source: 'puppet://private/ssh/user1',
              }
            end

            it {
              is_expected.to contain_file('user1_key_private_rsa_id').with(
                path: '/home/user1/.ssh/rsa_id',
              )
            }
          end
        end
      end
    end
  end
end
