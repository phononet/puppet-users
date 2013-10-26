class { 'users': }

users::group { 'phononet':
  ensure => $user1_ensure,
  gid    => '555',
}

$user1          = 'hugo'
$user1_uid      = 1030
$user1_gid      = undef
$user1_home     = '/home'
$user1_ensure   = 'absent'
$user1_groups   = [ 'sudo', 'adm', 'phononet' ]
$user1_sshkey   = '# Managed by Puppet'
$user1_comment  = 'Hugo'
$user1_password = '!'

$user2          = 'fritz'
$user2_uid      = 1012
$user2_gid      = 1012
$user2_home     = '/home'
$user2_ensure   = 'absent'
$user2_groups   = [ 'sudo', 'adm' ]
$user2_sshkey   = '# Managed by Puppet'
$user2_comment  = 'Fritz'
$user2_password = '!'

# user1 configuration
users::user { $user1:
  ensure   => $user1_ensure,
  uid      => $user1_uid,
  home     => $user1_home,
  groups   => $user1_groups,
  comment  => $user1_comment,
  password => $user1_password,
}
users::home { $user1:
  ensure => $user1_ensure,
  force  => true,
}
users::ssh { $user1:
  ensure => $user1_ensure,
  home   => $user1_home,
  sshkey => $user1_sshkey,
}

# user2 configuration
users::user { $user2:
  ensure   => $user2_ensure,
  uid      => $user2_uid,
  home     => $user2_home,
  groups   => $user2_groups,
  comment  => $user2_comment,
  password => $user2_password,
}
users::home { $user2:
  ensure => $user2_ensure,
  force  => true,
}
users::ssh { $user2:
  ensure => $user2_ensure,
  home   => $user2_home,
  sshkey => $user2_sshkey,
}
