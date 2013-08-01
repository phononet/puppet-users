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
  if ( $title == 'root' ) {
    $home_real = '/root'
  } else {
    $home_real = $home ? {
      'UNSET' => $users::params::home,
      ''      => $users::params::home,
      default => $home,
    }
  }
  $shell_real = $shell ? {
    'UNSET' => $users::params::shell,
    ''      => $users::params::shell,
    default => $shell,
  }

  $password_real = $password ? {
    'UNSET' => undef,
    'unset' => undef,
    ''      => undef,
    default => $password,
  }
  $uid_real = $uid ? {
    'UNSET' => undef,
    'unset' => undef,
    ''      => undef,
    default => $uid,
  }
  $gid_real = $gid ? {
    'UNSET' => undef,
    'unset' => undef,
    ''      => undef,
    default => $gid,
  }

  users::user { $title:
    ensure   => $ensure,
    uid      => $uid_real,
    gid      => $gid_real,
    home     => $home_real,
    shell    => $shell_real,
    groups   => $groups,
    comment  => $comment,
    password => $password_real,
    }
  if $gid != '' {
    users::group { $title:
      ensure => $ensure,
      gid    => $gid_real,
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
