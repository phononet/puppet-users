# USERS Module

This module manage users on Linux servers.

# Quick Start

Create user Bob

```puppet
node default {
  users::manage { 'bob': }
}
```

Set password for user Bob

```puppet
node default {
  users::manage { 'bob':
    uid      => '1100',
    gid      => '1100',
    home     => '/home',
    shell    => '/bin/bash',
    ensure   => 'present',
    comment  => 'Admin user',
    password => '<shadow password>',
  }
}
```

Add group

```puppet
node default {
  users::group { 'admin' }
  users::manage { 'bob': groups => 'admin' }
}
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

#####`sshkey`

  Add ssh public key to the user. (Array)

#####`groups`

  What group should the user belong to. (Array)

#####`remove_home`

  Remove user home directory by `absent`. Default value is `false`.

####users::user

#####`ensure`

#####`uid`

#####`gid`

#####`home`

#####`shell`

#####`comment`

#####`password`

#####`groups`

####users::group

#####`ensure`

#####`gid`

#####`user`

####users::home

#####`ensure`

#####`home`

#####`force`

####users::ssh

#####`ensure`

#####`sshkey`

#####`home`

