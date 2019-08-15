require 'beaker-rspec'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'

puppet_repo_url = 'http://apt.puppetlabs.com'
# TODO: lsbdistcode dynamic
puppet_release_package = "puppet-release-#{shell('lsb_release -c -s').stdout.chomp}.deb"

phononet_repo_url = 'http://debrepo.phononet.local'
phononet_release_package = 'phononet-keyring.deb'

phononet_scm_url = 'https://scm.phononet.local'
phononet_scm_modules_path = 'infra/puppet-modules/pn'
phononet_scm_puppet_modules = "#{phononet_scm_url}/#{phononet_scm_modules_path}"

git_repos = [
  # { mod: 'users', repo: "#{phononet_scm_puppet_modules}/phononet-users" }
]

hosts.each do |host|
  # install puppet repository
  on(host, "wget #{puppet_repo_url}/#{puppet_release_package}")
  on(host, "dpkg -i #{puppet_release_package}")
  # install phononet repository
  on(host, "wget #{phononet_repo_url}/#{phononet_release_package}")
  on(host, "dpkg -i #{phononet_release_package}")
end
run_puppet_install_helper unless ENV['BEAKER_provision'] == 'no'
install_module_on(hosts)
# install_module_dependencies_on(hosts)

UNSUPPORTED_PLATFORMS = ['Windows', 'Solaris', 'AIX'].freeze

RSpec.configure do |c|
  # Project root
  module_path = '/etc/puppetlabs/code/modules'

  # Readable test descriptions
  c.formatter = :documentation

  # detect the situation where PUP-5016 is triggered and skip the idempotency tests in that case
  # also note how fact('puppetversion') is not available because of PUP-4359
  if fact('osfamily') == 'Debian' && fact('operatingsystemmajrelease') == '8' && shell('puppet --version').stdout =~ %r{^4\.2}
    c.filter_run_excluding skip_pup_5016: true
  end

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    hosts.each do |host|
      puppet_version = on(host, 'puppet --version').stdout
      puts("PHONONET Debrepo URL: #{phononet_repo_url}")
      puts("PHONONET SCM URL: #{phononet_scm_puppet_modules}")
      puts("Puppet-Version: #{puppet_version}")

      on(host, puppet('module', 'install', 'puppetlabs-stdlib'))

      if fact('osfamily') == 'Debian'
        pp = <<-EOS
        class { '::apt': }
        apt::source { 'phononet':
          location => '#{phononet_repo_url}/phononet/',
          release  => $lsbdistcodename,
          repos    => main,
          include  => { source => false },
          pin      => '1000',
        } ->
        apt::source { 'phononet-unstable':
          location => '#{phononet_repo_url}/phononet/',
          release  => unstable,
          repos    => main,
          include  => { source => false },
          pin      => '1000',
        } ->
        apt::source { '#{fact('lsbdistcodename')}-unstable':
          location => '#{phononet_repo_url}/phononet/',
          release  => #{fact('lsbdistcodename')}-unstable,
          repos    => main,
          include  => { source => false },
          pin      => '1000',
          notify   => 'Exec[apt_update]',
        }
        EOS
      end

      if fact('osfamily') == 'Debian'
        on(host, puppet('module', 'install', 'puppetlabs-apt'))
        apply_manifest_on(hosts, pp, catch_failures: false)
      end

      # install modules from git
      # TODO: work out how to do branches and tags
      next if git_repos.empty?
      install_package(host, 'git')
      on(host, 'git config --global http.sslVerify false')
      git_repos.each do |g|
        step "Installing puppet module \'#{g[:repo]}\' from git on Master to #{module_path}/#{g[:mod]}"
        on(host, "git clone #{g[:repo]} #{module_path}/#{g[:mod]}")
      end
    end
  end
end

shared_examples 'a idempotent resource' do
  it 'applies with no errors' do
    apply_manifest(pp, catch_failures: true)
  end

  it 'applies a second time without changes', :skip_pup_5016 do
    apply_manifest(pp, catch_changes: true)
  end
end
