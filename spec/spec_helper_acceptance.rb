require 'beaker-rspec'
require 'beaker/puppet_install_helper'

PUPPET_VERSION = ENV['PUPPET_VERSION'] || '3.8.7'

if PUPPET_VERSION == "3.8.7"
  PUPPET_INSTALL_VERSION = 3
  PUPPET_INSTALL_TYPE = "foss"
else
  PUPPET_INSTALL_VERSION = 4
  PUPPET_INSTALL_TYPE = "agent"
end

if PUPPET_INSTALL_VERSION < 4
  install_puppet_from_gem_on(hosts, { :version => PUPPET_VERSION })
else
  run_puppet_install_helper
end

UNSUPPORTED_PLATFORMS = [ 'Windows', 'Solaris', 'AIX' ]

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  modules_dir = File.dirname(proj_root)
  ignore_files = {:ignore => [".bundle", ".git", ".hg", ".idea", ".vagrant", ".vendor", "vendor", "acceptance", "bundle", "spec", "tests", "log", ".", ".."]}

  # Readable test descriptions
  c.formatter = :documentation

  # detect the situation where PUP-5016 is triggered and skip the idempotency tests in that case
  # also note how fact('puppetversion') is not available because of PUP-4359
  if fact('osfamily') == 'Debian' && fact('operatingsystemmajrelease') == '8' && shell('puppet --version').stdout =~ /^4\.2/
    c.filter_run_excluding :skip_pup_5016 => true
  end

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    puppet_module_install(:source => proj_root, :module_name => 'users')
    hosts.each do |host|
      on host, puppet('module','install', 'puppetlabs-stdlib')
    end
  end
end

shared_examples "a idempotent resource" do
  it 'should apply with no errors' do
    apply_manifest(pp, :catch_failures => true)
  end

  it 'should apply a second time without changes', :skip_pup_5016 do
    apply_manifest(pp, :catch_changes => true)
  end
end
