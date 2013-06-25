users::user { 'hans':
	uid		=> '1024',
	ensure	=> 'present',
	groups	=> [ 'adm' ],
}
