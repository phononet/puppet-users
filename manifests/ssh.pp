define users::ssh (
  $ensure = 'present',
  $sshkey = '',
  $home   = 'UNSET'
)
{
  include users::params
  if ( $title == 'root' ) {
    $home_real        = '/root'
    $ensure_directory = 'directory'
  } else {
    $ensure_real = $ensure
    $home_real = $home ? {
      'UNSET' => "${users::params::home}/${title}",
      ''      => "${users::params::home}/${title}",
      default => "${home}/${title}",
    }
    $ensure_directory = $ensure ? {
      'present' => 'directory',
      default   => $ensure,
    }
  }
  if ( $sshkey != '' ) {
    if $ensure == 'absent' {
      $owner = undef
      $group = undef
    }
    else {
      $owner = $title
      $group = $title
    }
    file { "ssh_dir_${title}":
      ensure  => $ensure_directory,
      path    => "${home_real}/.ssh",
      owner   => $owner,
      group   => $group,
      mode    => '700',
      require => File [ $home_real ],
    }

    file { "authorized_keys_${title}":
      ensure  => $ensure,
      path    => "${home_real}/.ssh/authorized_keys",
      owner   => $title,
      group   => $title,
      mode    => '640',
      require => File [ "ssh_dir_${title}" ],
      content => template( 'users/authorized_keys.erb' )
    }
  }
}
