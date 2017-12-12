#
define users::home (
  $ensure               = 'directory',
  $force                = false,
  $owner                = $title,
  $group                = $title,
  $mode                 = '0755',
  $home                 = 'UNSET',
  $bashrc_content       = undef,
  $bashrc_source        = undef,
  $bashrc_file_name     = '.bashrc',
  $bash_profile_content = undef,
  $bash_profile_source  = undef,
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

  if $bash_profile_source and $bash_profile_content {
    fail('***use bash_profile_source or bash_profile_content parameter***')
  }

  if $bashrc_source and $bashrc_content {
    fail('***use bashrc_source or bashrc_content parameter***')
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

  if $bash_profile_content or $bash_profile_source {
    file { "${_home}/.bash_profile":
      ensure  => $ensure,
      mode    => '0644',
      owner   => $_owner,
      group   => $_group,
      content => $bash_profile_content,
      source  => $bash_profile_source,
      require => $require_home,
    }
  }

  if $bashrc_content or $bashrc_source {
    file { "${_home}/${bashrc_file_name}":
      ensure  => $ensure,
      mode    => '0644',
      owner   => $_owner,
      group   => $_group,
      content => $bashrc_content,
      source  => $bashrc_source,
      require => $require_home,
    }
  }
}
