file { '/etc/issue':
  ensure => file,
  owner  => 'root',
  group  => 'root',
  mode   => '0644',
  source => 'puppet:///modules/custom_settings/issue',
}

file { '/etc/issue.net':
  ensure => file,
  owner  => 'root',
  group  => 'root',
  mode   => '0644',
  source => 'puppet:///modules/custom_settings/issue',
}

class { '::login_defs':
  options => {
    'PASS_MAX_DAYS'   => '99999', # Recommended 90 
    'PASS_MIN_DAYS'   => '0',     # Recommended 2
    'PASS_MIN_LEN'    => '5',     # Recommended 5
    'PASS_WARN_AGE'   => '7',     # Recommended 14
  },

}

#ucredit=-1, the number of capital characters required in password
#lcredit=-1, the number of lower case characters required in password
#dcredit=-1, the number numbers required in password
#ocredit=-1, the number of symbols required in password

pam { "Set cracklib limits in password-auth":
  ensure    => present,
  service   => 'system-auth',
  type      => 'password',
  module    => 'pam_cracklib.so',
  arguments => ['try_first_pass','retry=3', 'minlen=10','ucredit=-1','lcredit=-1','dcredit=-1','ocredit=-1'],
}

pam { "Set password remember limit in password-auth":
  ensure    => present,
  service   => 'system-auth',
  type      => 'password',
  module    => 'pam_unix.so',
  arguments => ['md5','shadow', 'nullok','try_first_pass','use_authtok','remember=4'],
}

pam { "Set invalid login 3 times deny in password-auth -fail":
  ensure           => present,
  service          => 'password-auth',
  type             => 'auth',
  control          => '[default=die]',
  control_is_param => true,
  module           => 'pam_faillock.so',
  arguments        => ['authfail','deny=3','unlock_time=604800','fail_interval=900'],
}

file { '/etc/security/opasswd':
  ensure => file,
  owner  => 'root',
  group  => 'root',
  mode   => '0600',
}



