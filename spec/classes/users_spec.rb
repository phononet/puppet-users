require 'spec_helper'

describe 'users' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'default params' do
        it { is_expected.not_to contain_users__account('') }
        it { is_expected.not_to contain_users__ssh('') }
        it { is_expected.not_to contain_users__user('') }
        it { is_expected.not_to contain_users__group('') }
      end
      context 'set all parameters' do
        let :params do
          {
            ssh: { 'user1' => { 'ensure' => 'present' } },
            user: { 'user1' => { 'ensure' => 'present' } },
            home: { 'user1' => { 'ensure' => 'present' } },
            group: { 'dev' => { 'ensure' => 'present' } },
          }
        end

        it { is_expected.to contain_users__ssh('user1') }
        it { is_expected.to contain_users__user('user1') }
        it { is_expected.to contain_users__home('user1') }
        it { is_expected.to contain_users__group('dev') }
      end
    end
  end
end
