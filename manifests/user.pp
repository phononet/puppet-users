define users::user (
  $uid      = undef,
  $gid      = undef,
  $home     = 'UNSET',
  $shell    = 'UNSET',
  $ensure   = 'present',
  $groups   = undef,
  $comment  = undef,
  $password = undef
)
{
  include users::params
  $home_real = $home ? {
    'UNSET' => $users::params::home,
    default => $home,
  }
  $shell_real = $shell ? {
    'UNSET' => $users::params::shell,
    default => $shell,
  }

 # Create user
  user { $title:
    ensure     => $ensure,
    uid        => $uid,
    gid        => $gid,
    comment    => $comment,
    home       => "${home_real}/${title}",
    groups     => $groups,
    shell      => $shell_real,
    password   => $password,
    membership => 'inclusive',
  }
}
