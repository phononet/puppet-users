class users::params {
  $home = '/home'
  $shell = '/bin/bash'

  case $operatingsystem {
    'debian', 'ubuntu', 'centos': { $supported = true }
    default: {
      $supported = false
      notify { "${module_name}_unsupported":
        message => "The ${module_name} module is not supported on ${operatingsystem}",
      }
    }
  }
}
