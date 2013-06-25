define users::home (
  $ensure = 'directory',
  $force  = false,
  $home   = 'UNSET'
)
{
  include users::params

  $home_real = $home ? {
    'UNSET' => $users::params::home,
    default => $home,
  }

  if $ensure == 'absent' {
    $group = undef
    $owner = undef
  } else {
    $group = $title
    $owner = $title
  }

  $ensure_directory = $ensure ? {
    'present' => 'directory',
    default   => $ensure,
  }

  exec { "${title}_prefix_home":
    command   => "mkdir -p ${home_real}",
    logoutput => true,
    onlyif    => "test ! -d ${home_real}",
  }

  file { "${home_real}/${title}":
    ensure  => $ensure_directory,
    owner   => $owner,
    group   => $group,
    force   => $force,
    mode    => '0755',
    require => Exec [ "${title}_prefix_home" ],
  }
}
