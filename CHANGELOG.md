## 02-06-2015 release 0.5.0
  * Introduced new parameter to users::manage
    - parameter "group"
  * ensure user group is created in users::user
  * make it work under future parser
  * Add acceptance tests
  * remove deprecated Modulefile

## 02-06-2015 release 0.4.0
  * Add new parameters to users::ssh
    - parameter "options"
    - parameter "knownhosts"

## 26-09-2014 release 0.3.0:
  * Add stdlib dependency. Add some tests
  * Rename sshkey to key_authorized. Add hiera support for all defindes. Small bugfixes
  * Clean up the defines. Add key prameter for managing ssh keys. Add rspec tests
  * Allow to create system user

## 11-02-2014 release 0.1.0:
  * Allow to create system user

## 26-10-2013 release 0.0.5:
  * puppet-lint small fixes

## 20-08-2013 release 0.0.4:
  * [BUGFIX] Don't create prefix home dir if ensure parameter is set 'absent'

## 01-08-2013 release 0.0.3:
  * user root should not be removed
  * chage mode of home directory, user 755, root 750

## phononet-users 0.0.2:
  * key_authorized variable can be an array. key_authorized file will be created from a template

## phononet-users 0.0.1:
  * Initial release