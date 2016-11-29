#
class login_defs (
  $mode            = '0644',
  $owner           = 'root',
  $group           = '0',
  $options         = {},
) inherits login_defs::params {

  validate_re($mode, '^\d{3,4}$', 'mode should be a 3-4 digit number')
  validate_hash($options)

  $merged_options = merge($login_defs::params::default_options, $options)

  file { '/etc/login.defs':
    ensure  => 'file',
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    content => template('login_defs/login.defs.erb'),
  }

}
