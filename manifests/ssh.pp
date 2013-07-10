define users::ssh (
  $ensure = 'present',
  $sshkey = '',
  $home   = 'UNSET'
)
{
  include users::params
  $home_real = $home ? {
    'UNSET' => $users::params::home,
    default => $home,
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
    $ensure_directory = $ensure ? {
      'present'  => 'directory',
      default    => $ensure,
    }
    file { "ssh_dir_${title}":
      ensure  => $ensure_directory,
      path    => "${home_real}/${title}/.ssh",
      owner   => $owner,
      group   => $group,
      mode    => '700',
      require => File [ "${home_real}/${title}" ],
    }

    file { "authorized_keys_${title}":
      ensure  => $ensure,
      path    => "${home_real}/${title}/.ssh/authorized_keys",
      owner   => $title,
      group   => $title,
      mode    => '640',
      require => File [ "ssh_dir_${title}" ],
      content => template( 'users/authorized_keys.erb' )
    }
  }
}
