# == Define users::home
define users::home (
  $ensure = 'directory',
  $force  = false,
  $owner  = $title,
  $group  = $title,
  $mode   = '0755',
  $home   = 'UNSET',
)
{
  include users::params
  # Don't remove root directory
  if $title == 'root' {
    $_home            = '/root'
    $_mode            = '0750'
    $_owner           = 'root'
    $_group           = 'root'
    $ensure_directory = 'directory'
  } else {
    $_mode  = $mode
    $_owner = $owner
    $_group = $group
    $_home  = $home ? {
      'UNSET' => "${users::params::home}/${title}",
      default => $home,
    }
    $ensure_directory = $ensure ? {
      'present' => 'directory',
      default   => $ensure,
    }
  }
  if $ensure == 'absent' {
    $require_home = undef
  } else {
    $require_home = Exec["${title}_home"]
    # Create prefix dir
    exec { "${title}_home":
      path      => '/usr/bin:/bin',
      command   => "mkdir -p ${_home}",
      logoutput => true,
      unless    => "test -d ${_home}",
    }
  }

  # Create home dir
  file { $_home:
    ensure  => $ensure_directory,
    owner   => $_owner,
    group   => $_group,
    mode    => $_mode,
    force   => $force,
    require => $require_home,
  }
}
