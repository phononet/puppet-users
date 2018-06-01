#
# users
#
# @param account
#  [Hash] Create accounts
#
# @param ssh
#  [Hash] Create ssh keys
#
# @param user
#  [Hash] Create users
#
# @param group
#  [Hash] Create groups
#
# @param home
#  [Hash] Create home
#
class users (
  Optional[Hash] $account = undef,
  Optional[Hash] $ssh     = undef,
  Optional[Hash] $user    = undef,
  Optional[Hash] $group   = undef,
  Optional[Hash] $home    = undef,
){
  if $account {
    create_resources('::users::manage', $account)
  }
  if $ssh {
    create_resources('::users::ssh', $ssh)
  }
  if $user {
    create_resources('::users::user', $user)
  }
  if $group {
    create_resources('::users::group', $group)
  }
  if $home {
    create_resources('::users::home', $home)
  }
}
