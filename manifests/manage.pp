# Class: users::manage
#
# This module manages users
#
# Parameters:
#   [*ensure*]
#
#   [*uid*]
#
#   [*gid*]
#
#   [*home*]
#
#   [*groups*]
#
#   [*shell*]
#
#   [*comment*]
#
#   [*password*]
#
#   [*remove_home*]
#
# Actions:
#
# Requires:
#   Nothing
#
# Sample Usage:
#   users::manage { 'dummy':
#     ensure      => 'present',
#     uid         => '1010',
#     gid         => '1010',
#     home        => '/home',
#     groups      => [ 'adm' ],
#     shell       => '/bin/bash',
#     comment     => 'Dummy user',
#     sshkey      => 'sshkey',
#     password    => 'secret',
#   }
#

define users::manage (
  $uid         = undef,
  $gid         = undef,
  $home        = 'UNSET',
  $shell       = 'UNSET',
  $ensure      = 'present',
  $groups      = undef,
  $sshkey      = undef,
  $comment     = undef,
  $password    = undef,
  $remove_home = false
)
{
  include users::params
  $home_real = $home ? {
    'UNSET' => $users::params::home,
    default => $home,
  }
  $shell_real = $shell ? {
    'UNSET' => $users::params::shell,
    default => $shell,
  }

  users::user { $title:
    ensure   => $ensure,
    uid      => $uid,
    gid      => $gid,
    home     => $home_real,
    shell    => $shell_real,
    groups   => $groups,
    comment  => $comment,
    password => $password,
    }
  if $gid != '' {
    users::group { $title:
      ensure => $ensure,
      gid    => $gid,
      user   => $title,
    }
  }
  users::home { $title:
    ensure => $ensure,
    home   => $home_real,
    force  => $remove_home,
  }
  users::ssh { $title:
    ensure => $ensure,
    home   => $home_real,
    sshkey => $sshkey,
  }
}
