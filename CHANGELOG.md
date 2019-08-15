# CHANGELOG

## [0.7.6] (2019-08-15)
* pdk: convert to 1.12.0

## [0.7.5] (2019-02-08)
* pdk: convert to 1.9

## [0.7.4] (2019-01-30)
* pdk: convert to 1.8

## [0.7.3]
* cosmetics (pdk validate)
* fix pdk warnings
* puppet 5 suport

## [0.7.2] (2017-03-31)
* cosmetics (future parser)
* fix `STRIC_VARIABLES`
* update puppet files

## [0.7.1] (2016-08-22)
* [BUGFIX] define multiple ssh keys

## [0.7.0] (2016-08-22)
* Intoduced new parameters
  * `bash_profile_source`, `bash_profile_content and ``
  * `bashrc_source` and `bashrc_content`
* Introduced new parameter in ssh type
  * parameter `mode_ssh_dir`, `mode_authorized_key` and `mode_config_file`
* Introduced new parameter in manager type
  * parameter `mode_ssh_dir`, `mode_authorized_key` and `mode_ssh_config_file`
* [FEATURE] allow to import ssh keys to any directory as root user
* rename hidden variables
* Introduced new parameter in ssh type
  * parameter `group`

## [0.5.0] (2015-06-02)
* Introduced new parameter to users::manage
  * parameter "group"
* ensure user group is created in users::user
* make it work under future parser
* Add acceptance tests
* remove deprecated Modulefile

## [0.4.0] (2015-06-02)
* Add new parameters to users::ssh
  * parameter "options"
  * parameter "knownhosts"

## [0.3.0] (2014-09-26)
* Add stdlib dependency. Add some tests
* Rename sshkey to key_authorized. Add hiera support for all defindes. Small bugfixes
* Clean up the defines. Add key prameter for managing ssh keys. Add rspec tests
* Allow to create system user

## [0.1.0] (2014-02-11)
* Allow to create system user

## [0.0.5] (2013-10-26)
* puppet-lint small fixes

## [0.0.4] (2013-08-20)
* [BUGFIX] Don't create prefix home dir if ensure parameter is set 'absent'

## [0.0.3] (2013-08-01)
* user root should not be removed
* chage mode of home directory, user 755, root 750

## [0.0.2]
* key_authorized variable can be an array. key_authorized file will be created from a template

## [0.0.1]
* Initial release
