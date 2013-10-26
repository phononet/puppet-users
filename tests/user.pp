users::user { 'hans':
  ensure  => 'present',
  uid     => '1024',
  groups  => [ 'adm' ],
}
