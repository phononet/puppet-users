users::ssh { 'user1':
  ensure              => 'present',
  key_ensure          => 'absent',
  key_public_content  => 'rsa test',
  key_private_content => 'rsa test',
}

users::ssh { 'user2':
  ensure             => 'present',
  home               => '/srv/user2',
  key_ensure         => 'present',
  key_public_name    => 'test_id_rsa',
  key_public_source  => 'file:///etc/ssh/ssh_host_rsa_key.pub',
  key_private_name   => 'test_id_rsa',
  key_private_source => 'file:///etc/ssh/ssh_host_rsa_key.pub',
}
