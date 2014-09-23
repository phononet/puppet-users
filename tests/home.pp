users::home { 'user1':
  ensure => 'present',
}

users::home { 'user2':
  ensure => 'present',
  home   => '/srv/user2',
  mode   => '0740',
}
