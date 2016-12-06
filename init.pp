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

#Setting access only to root to these binaries
$rootbins = [ '/usr/bin/wget', '/usr/bin/gcc', '/usr/bin/nc', ]
file { $rootbins:
  owner  => 'root',
  group  => 'root',
  mode   => '0700',
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

file { '/etc/security/opasswd':
  ensure => file,
  owner  => 'root',
  group  => 'root',
  mode   => '0600',
}

class { 'ssh::server':
      storeconfigs_enabled => false,
      options => {
        #'PasswordAuthentication' => 'no',
        #'PermitRootLogin'        => 'no',
        #'Port'                   => [22, 2222],
        'Banner'	          => '/etc/issue.net',
      },
}


class ssh {
service { 'sshd':
    ensure  => 'running',
    enable  => true,
    require => Package['openssh-server'],
  }

# add a notify to the file resource
  file { '/etc/ssh/sshd_config':
    notify  => Service['sshd'],  # this sets up the relationship
    mode    => '0600',
    owner   => 'root',
    group   => 'root',
  }

}
