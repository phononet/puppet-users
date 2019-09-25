users::manage { 'root':
  ensure => 'absent',
  home   => '/srv/root',
}

users::manage { 'user1':
  ensure         => 'present',
  ssh_options    => { 'Host *' => { 'X11Forwarding' => 'no' } },
  remove_home    => true,
  key_authorized => [ 'ssh-rsa test', 'ssh-dsa test', ],
  groups         => [ 'adm' ],
}

users::manage { 'user2':
  ensure      => 'present',
  remove_home => true,
  ssh_options => { 'X11Forwarding' => 'no' },
  home        => '/srv/user2',
  uid         => '1099',
  gid         => '1099',
}
