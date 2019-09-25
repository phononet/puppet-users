users::user { 'user1': }

users::user { 'user2':
  ensure => 'present',
  uid    => '1099',
  groups => [ 'adm' ],
  home   => '/srv/user2',
}
