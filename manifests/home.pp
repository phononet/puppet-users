define users::home (
  $ensure = 'directory',
  $force  = false,
  $home   = 'UNSET'
)
{
  include users::params

  if ( $title == 'root' ) {
    $home_real        = '/root'
    $ensure_directory = 'directory'
    $mode_real        = '0750'
  } else {
    $ensure_real = $ensure
    $mode_real   = '0755'
    $home_real   = $home ? {
      'UNSET' => "${users::params::home}/${title}",
      ''      => "${users::params::home}/${title}",
      default => "${home}/${title}",
    }
    $ensure_directory = $ensure ? {
      'present' => 'directory',
      default   => $ensure,
    }
  }

  if $ensure == 'absent' {
    $group = undef
    $owner = undef
  } else {
    $group = $title
    $owner = $title
  }

  exec { "${title}_prefix_home":
    command   => "mkdir -p ${home_real}",
    logoutput => true,
    onlyif    => "test ! -d ${home_real}",
  }

  file { $home_real:
    ensure  => $ensure_directory,
    owner   => $owner,
    group   => $group,
    force   => $force,
    mode    => $mode_real,
    require => Exec [ "${title}_prefix_home" ],
  }
}
