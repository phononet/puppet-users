#
class users (
  $account = '',
  $ssh     = '',
  $user    = '',
  $group   = '',
  $home    = '',
){

  if $account != '' {
    validate_hash($account)
    create_resources('::users::manage', $account)
  }
  if $ssh != '' {
    validate_hash($ssh)
    create_resources('::users::ssh', $ssh)
  }
  if $user != '' {
    validate_hash($user)
    create_resources('::users::user', $user)
  }
  if $group != '' {
    validate_hash($group)
    create_resources('::users::group', $group)
  }
  if $home != '' {
    validate_hash($home)
    create_resources('::users::home', $home)
  }
}
