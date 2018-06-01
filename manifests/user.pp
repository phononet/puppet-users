#
# users.user
#
define users::user (
  $uid      = undef,
  $gid      = undef,
  $home     = 'UNSET',
  $shell    = 'UNSET',
  $ensure   = 'present',
  $system   = false,
  $group    = $title,
  $groups   = undef,
  $comment  = undef,
  $password = undef,
) {
  anchor { "users::user::${title}::start": }
  anchor { "users::user::${title}::end": }

  include users::params

  if ( $title == 'root' ) {
    $_ensure     = 'present'
    $_uid        = undef
    $_gid        = undef
    $_home       = '/root'
    $_system     = false
    $_group      = 'root'
    $_groups     = undef
    $_comment    = undef
    $_membership = undef
    $user_group  = undef
  } else {
    $_ensure     = $ensure
    $_home       = $home ? {
      'UNSET' => "${users::params::home}/${title}",
      default => $home,
    }
    $_uid        = $uid
    $_gid        = $gid
    $_system     = $system
    $_group      = $group
    $_groups     = $groups
    $_comment    = $comment
    $_membership = 'inclusive'

    if $gid {
      $user_group = $gid
    } else {
      $user_group = $_group
    }
  }

  $_shell = $shell ? {
    'UNSET' => $users::params::shell,
    default => $shell,
  }

  $ensure_group = {
    ensure => $_ensure,
    name   => $_group,
    gid    => $_gid,
    system => $_system,
  }
  ensure_resource('group', $_group, $ensure_group)

  # Create user
  user { $title:
    ensure     => $_ensure,
    uid        => $_uid,
    gid        => $user_group,
    comment    => $_comment,
    home       => $_home,
    groups     => $_groups,
    shell      => $_shell,
    system     => $_system,
    password   => $password,
    membership => $_membership,
  }

  if $_ensure == 'absent' {
    Anchor["users::user::${title}::start"]
    -> User[$title]
    -> Group[$_group]
    -> Anchor["users::user::${title}::end"]
  } else {
    Anchor["users::user::${title}::start"]
    -> Group[$_group]
    -> User[$title]
    -> Anchor["users::user::${title}::end"]
  }
}
