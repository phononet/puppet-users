#
class users (
  $account = '',
){
  if $account != '' {
    create_resources ( '::users::manage', $account )
  }
}
