# == Define users::ssh
define users::ssh (
  $ensure              = 'present',
  $user                = $title,
  $home                = 'UNSET',
  $key_authorized      = 'UNSET',
  $key_ensure          = 'present',
  $key_public_name     = 'id_rsa',
  $key_public_content  = undef,
  $key_public_source   = undef,
  $key_private_name    = 'id_rsa',
  $key_private_content = undef,
  $key_private_source  = undef,
  $options             = {},
)
{
  include users::params
  if ( $title == 'root' ) {
    $home_real        = '/root'
    $ensure_directory = 'directory'
  } else {
    $ensure_real = $ensure
    $home_real = $home ? {
      'UNSET' => "${users::params::home}/${user}",
      default => $home,
    }
    $ensure_directory = $ensure ? {
      'present' => 'directory',
      default   => $ensure,
    }
  }
  if $ensure == 'absent' {
    $owner = undef
    $group = undef
    $key_ensure_real = 'absent'
  }
  else {
    $owner = $user
    $group = $user
    $key_ensure_real = $key_ensure
  }

  $ssh_dir = {
    ensure => $ensure_directory,
    path   => "${home_real}/.ssh",
    owner  => $owner,
    group  => $group,
    mode   => '0700',
  }
  ensure_resource( 'file', "ssh_dir_${user}", $ssh_dir )

  if $key_authorized != 'UNSET' {
    file { "key_authorized_${title}":
      ensure  => $ensure,
      path    => "${home_real}/.ssh/authorized_keys",
      owner   => $owner,
      group   => $group,
      mode    => '0640',
      require => File["ssh_dir_${user}"],
      content => template( 'users/authorized_keys.erb' )
    }
  }

  if !empty($options) {
    file { "ssh_config_${title}":
      ensure  => $ensure,
      path    => "${home_real}/.ssh/config",
      owner   => $owner,
      group   => $group,
      mode    => '0644',
      require => File["ssh_dir_${user}"],
      content => template("${module_name}/config.erb")
    }
  }

  if $key_public_content or $key_public_source {
    if $key_public_content and $key_public_source {
      $key_public_source_real = undef
    } else {
      $key_public_source_real = $key_public_source
    }
    file { "${title}_key_public_${key_public_name}":
      ensure  => $key_ensure_real,
      path    => "${home_real}/.ssh/${key_public_name}.pub",
      owner   => $owner,
      group   => $group,
      mode    => '0640',
      require => File["ssh_dir_${user}"],
      content => $key_public_content,
      source  => $key_public_source_real,
    }
  }

  if $key_private_content or $key_private_source {
    if $key_private_content and $key_private_source {
      $key_private_source_real = undef
    } else {
      $key_private_source_real = $key_private_source
    }
    file { "${title}_key_private_${key_private_name}":
      ensure  => $key_ensure_real,
      path    => "${home_real}/.ssh/${key_private_name}",
      owner   => $user,
      group   => $user,
      mode    => '0600',
      require => File["ssh_dir_${user}"],
      content => $key_private_content,
      source  => $key_private_source_real,
    }
  }
}
