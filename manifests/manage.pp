# Define: users::manage
#
define users::manage (
  $uid                 = undef,
  $gid                 = undef,
  $mode                = undef,
  $home                = 'UNSET',
  $shell               = 'UNSET',
  $ensure              = 'present',
  $system              = false,
  $groups              = undef,
  $comment             = undef,
  $password            = undef,
  $remove_home         = false,
  $key_ensure          = undef,
  $key_authorized      = undef,
  $key_public_name     = undef,
  $key_public_content  = undef,
  $key_public_source   = undef,
  $key_private_name    = undef,
  $key_private_content = undef,
  $key_private_source  = undef,
)
{
  users::user { $title:
    ensure   => $ensure,
    uid      => $uid,
    gid      => $gid,
    home     => $home,
    shell    => $shell,
    system   => $system,
    groups   => $groups,
    comment  => $comment,
    password => $password,
  }
  if $gid != '' {
    users::group { $title:
      ensure => $ensure,
      gid    => $gid,
      user   => $title,
    }
  }
  users::home { $title:
    ensure  => $ensure,
    home    => $home,
    mode    => $mode,
    force   => $remove_home,
    require => Users::User [ $title ],
  }
  if $key_authorized != '' or $key_public_content != '' or
    $key_public_source != '' or $key_private_content != '' or
    $key_private_source != '' {
    users::ssh { $title:
      ensure              => $ensure,
      home                => $home,
      key_authorized      => $key_authorized,
      key_ensure          => $key_ensure,
      key_public_name     => $key_public_name,
      key_public_content  => $key_public_content,
      key_public_source   => $key_public_source,
      key_private_name    => $key_private_name,
      key_private_content => $key_private_content,
      key_private_source  => $key_private_source,
      require             => Users::Home [ $title ],
    }
  }
}
