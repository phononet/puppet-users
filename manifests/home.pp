# == Define users::home
define users::home (
  $ensure = 'directory',
  $force  = false,
  $mode   = '0755',
  $home   = 'UNSET',
)
{
  include users::params
  # Don't remove root directory
  if ( $title == 'root' ) {
    $home_real        = '/root'
    $ensure_directory = 'directory'
    $mode_real        = '0750'
  } else {
    $mode_real   = $mode
    $home_real   = $home ? {
      'UNSET' => "${users::params::home}/${title}",
      default => $home,
    }
    $ensure_directory = $ensure ? {
      'present' => 'directory',
      default   => $ensure,
    }
  }
  if $ensure == 'absent' {
    $group        = undef
    $owner        = undef
    $require_home = undef
  } else {
    $group        = $title
    $owner        = $title
    $require_home = Exec [ "${title}_home" ]
    # Create prefix dir
    exec { "${title}_home":
      path      => '/usr/bin:/bin',
      command   => "mkdir -p ${home_real}",
      logoutput => true,
      unless    => "test -d ${home_real}",
    }
  }

  # Create home dir
  file { $home_real:
    ensure  => $ensure_directory,
    owner   => $owner,
    group   => $group,
    force   => $force,
    mode    => $mode_real,
    require => $require_home,
  }
}
