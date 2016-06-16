# == Define users::group
define users::group (
  $ensure = 'present',
  $gid    = undef,
)
{
  group { $title:
    ensure => $ensure,
    gid    => $gid,
  }
}
