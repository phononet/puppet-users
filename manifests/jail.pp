#
# users::jail
#
define users::jail (
  $ensure                    = 'present',
  Stdlib::Absolutepath $home = "/home/${title}",
  String $user               = $title,
  $owner                     = undef,
  $group                     = undef,
  $mode                      = '0755',
  Array $dirs                = ['in', 'out'],
){
  $_home = prefix($dirs, "${home}/")

  $ensure_dir = $ensure ? {
    /absent|purged/ => $ensure,
    default         => 'directory',
  }

  if $owner {
    $_owner = $owner
  } else {
    $_owner = $user
  }

  if $group {
    $_group = $group
  } else {
    $_group = $user
  }

  file { "${home}/dev":
    ensure => $ensure_dir,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }

  file { $_home:
    ensure => $ensure_dir,
    mode   => $mode,
    owner  => $_owner,
    group  => $_group,
  }
}
