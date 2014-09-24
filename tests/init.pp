$ensure = 'present'
$user = { user1 => {
          ensure => $ensure,
        },
}

$home = {
  user1 => {
    ensure => $ensure,
    force  => true,
  },
}

$ssh = {
  user1 => {
    ensure => $ensure,
    key_public_content => 'ssh-rsa user1',
  },
  user1_test => {
    ensure => $ensure,
    user   => 'user1',
    key_public_name    => 'test_id_rsa',
    key_public_content => 'ssh-rsa user1',
  },
}

$grop = { testuser => {
          ensure => $ensure,
        },
}

class { 'users':
  ssh   => $ssh,
  user  => $user,
  home  => $home,
  group => $group,
}
