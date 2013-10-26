# == Define users::group
define users::group (
  $ensure = 'present',
  $gid    = undef,
  $user   = ''
)
{
  if ( $ensure != 'absent' ) {
    group { $title:
      ensure => $ensure,
      gid    => $gid,
    }
  }
  elsif ( $ensure == 'absent' ) and ( $user == '' ){
    group { $title:
      ensure => $ensure,
      gid    => $gid,
    }
  }
}
