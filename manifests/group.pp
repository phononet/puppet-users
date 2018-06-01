#
# users::group
#
# @param ensure
#  [String] Create group
#
# @param gid
#  [String] User GID
#
define users::group (
  $ensure = 'present',
  $gid    = undef,
) {
  group { $title:
    ensure => $ensure,
    gid    => $gid,
  }
}
