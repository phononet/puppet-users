# == Define users.user
define users::user (
  $uid      = undef,
  $gid      = undef,
  $home     = 'UNSET',
  $shell    = 'UNSET',
  $ensure   = 'present',
  $system   = false,
  $groups   = undef,
  $comment  = undef,
  $password = undef
)
{
  include users::params
  if ( $title == 'root' ) {
    $home_real = undef
    $ensure_real = 'present'
  } else {
    $ensure_real = $ensure
    $home_real = $home ? {
      'UNSET' => "${users::params::home}/${title}",
      default => $home,
    }
  }
  $shell_real = $shell ? {
    'UNSET' => $users::params::shell,
    default => $shell,
  }

  # Create user
  user { $title:
    ensure     => $ensure_real,
    uid        => $uid,
    gid        => $gid,
    comment    => $comment,
    home       => $home_real,
    groups     => $groups,
    shell      => $shell_real,
    system     => $system,
    password   => $password,
    membership => 'inclusive',
  }
}
