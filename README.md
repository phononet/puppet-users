# USERS Module

This module manage users on Linux servers.

# Quick Start

Create user user1

```puppet
node default {
  users::manage { 'user1': }
}
```

Set password for user user1

```puppet
node default {
  users::manage { 'user1':
    uid      => '1100',
    gid      => '1100',
    home     => '/srv/user1',
    shell    => '/bin/bash',
    ensure   => 'present',
    comment  => 'Admin user',
    password => '<shadow password>',
  }
}
```

Add ssh public and private key

```puppet
node default {
  users::ssh { 'user1':
    ensure             => 'present',
    home               => '/srv/user1',
    options            => { 'HashKnownHosts' => 'yes' },
    key_ensure         => 'present',
    key_public_name    => 'test_id_rsa',
    key_public_source  => 'file:///etc/ssh/ssh_host_rsa_key.pub',
    key_private_name   => 'test_id_rsa',
    key_private_source => 'file:///etc/ssh/ssh_host_rsa_key.pub',
  }
}
```

Add group

```puppet
node default {
  users::group { 'admin' }
  users::manage { 'user1': groups => 'admin' }
}
```

Hiera support
```puppet
class { 'users':
  account => user1 => {
               uid  => '1100',
               gid  => '1100',
               home => '/srv/user1',
             }
}
```

Hiera repository
```puppet
users::account
  user1:
    uid: '1100'
    gid: '1100'
    home: '/srv/user1'
```

##Reference

###Defines

###Parameters

####users::manage

#####`ensure`

#####`uid`

  Set with N user id.

#####`gid`

  Set with N group id.

#####`home`

  Set home directory. Default is `/home/<username>`.

#####`shell`

  User shell. Default is `/bin/bash`.

#####`comment`

  User comment.

#####`password`

  Set user password.

#####`ssh_options`

  Add ssh options per user

#####`mode_ssh_dir`

  Default to '0700'

#####`mode_authorized_key`

  Default to '0640'

#####`mode_ssh_config_file`

  Default to '0644'

#####`key_authorized`

  Add ssh public key to the user. (Array)

#####`groups`

  What group should the user belong to. (Array)

#####`remove_home`

  Remove user home directory by `absent`. Default value is `false`.

#####`bashrc_content`

#####`bashrc_source`

#####`bashrc_file_name`

#####`bash_profile_content`

#####`bash_profile_source`

####users::user

#####`ensure`

#####`uid`

#####`gid`

#####`home`

#####`shell`

#####`comment`

#####`password`

#####`system`

#####`groups`

####users::group

#####`ensure`

#####`gid`

#####`user`

####users::home

#####`ensure`

#####`home`

#####`force`

#####`owner`

#####`group`

#####`bashrc_content`

#####`bashrc_source`

#####`bashrc_file_name`

#####`bash_profile_content`

#####`bash_profile_source`

####users::ssh

#####`ensure`

#####`options`

#####`mode_ssh_dir`

  Default to '0700'

#####`mode_authorized_key`

  Default to '0640'

#####`mode_config_file`

  Default to '0644'

#####`key_authorized`

#####`key_public_name`

#####`key_public_content`

#####`key_public_source`

#####`key_private_name`

#####`key_private_content`

#####`key_private_source`

#####`home`

