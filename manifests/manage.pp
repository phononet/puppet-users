# Define: users::manage
#
define users::manage (
  $uid                  = undef,
  $gid                  = undef,
  $mode                 = undef,
  $home                 = undef,
  $shell                = undef,
  $ensure               = 'present',
  $system               = false,
  $owner                = undef,
  $group                = undef,
  $groups               = undef,
  $comment              = undef,
  $password             = undef,
  $remove_home          = false,
  $sftp_jail            = false,
  $sftp_jail_dirs       = undef,
  $ssh_options          = undef,
  $mode_ssh_dir         = undef,
  $mode_authorized_key  = undef,
  $mode_ssh_config_file = undef,
  $key_ensure           = undef,
  $key_authorized       = undef,
  $key_public_name      = undef,
  $key_public_content   = undef,
  $key_public_source    = undef,
  $key_private_name     = undef,
  $key_private_content  = undef,
  $key_private_source   = undef,
  $bashrc_content       = undef,
  $bashrc_source        = undef,
  $bashrc_file_name     = undef,
  $bash_profile_content = undef,
  $bash_profile_source  = undef,
)
{
  validate_bool($sftp_jail)
  validate_bool($remove_home)

  if $sftp_jail {
    $_home_owner = 'root'
    $_home_group = 'root'
  } else {
    $_home_owner = $owner
    $_home_group = $group
  }

  users::user { $title:
    ensure   => $ensure,
    uid      => $uid,
    gid      => $gid,
    home     => $home,
    shell    => $shell,
    system   => $system,
    group    => $group,
    groups   => $groups,
    comment  => $comment,
    password => $password,
  }

  users::home { $title:
    ensure               => $ensure,
    home                 => $home,
    owner                => $_home_owner,
    group                => $_home_group,
    mode                 => $mode,
    force                => $remove_home,
    bashrc_content       => $bashrc_content,
    bashrc_source        => $bashrc_source,
    bashrc_file_name     => $bashrc_file_name,
    bash_profile_content => $bash_profile_content,
    bash_profile_source  => $bash_profile_source,
    require              => Users::User[$title],
  }

  if $sftp_jail {
    users::jail { $title:
      ensure  => $ensure,
      mode    => $mode,
      group   => $group,
      home    => $home,
      dirs    => $sftp_jail_dirs,
      require => Users::User[$title],
    }
  }

  if $key_authorized or $key_public_content or
    $key_public_source or $key_private_content or
    $key_private_source or $ssh_options {
    users::ssh { $title:
      ensure              => $ensure,
      group               => $group,
      home                => $home,
      options             => $ssh_options,
      mode_ssh_dir        => $mode_ssh_dir,
      mode_authorized_key => $mode_authorized_key,
      mode_config_file    => $mode_ssh_config_file,
      key_authorized      => $key_authorized,
      key_ensure          => $key_ensure,
      key_public_name     => $key_public_name,
      key_public_content  => $key_public_content,
      key_public_source   => $key_public_source,
      key_private_name    => $key_private_name,
      key_private_content => $key_private_content,
      key_private_source  => $key_private_source,
      require             => Users::Home[$title],
    }
  }
}
