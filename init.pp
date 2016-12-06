
# Setting up issue file
exec { "cp /etc/issue /root;":
  path   => '/usr/bin:/usr/sbin:/bin',
}~>
file { '/etc/issue':
  ensure => file,
  owner  => 'root',
  group  => 'root',
  mode   => '0644',
  source => 'puppet:///modules/custom_settings/issue',
}

# Setting up issue.net file for remote logins
exec { "cp /etc/issue.net /root;":
  path   => '/usr/bin:/usr/sbin:/bin',
}~>
file { '/etc/issue.net':
  ensure => file,
  owner  => 'root',
  group  => 'root',
  mode   => '0644',
  source => 'puppet:///modules/custom_settings/issue',
}

# Setting up Password age settings for new accounts 
exec { "cp /etc/login.defs /root;":
  path   => '/usr/bin:/usr/sbin:/bin',
}~>
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

# Configuring password complexity in PAM, remembering last 4 passwords
#ucredit=-1, the number of capital characters required in password
#lcredit=-1, the number of lower case characters required in password
#dcredit=-1, the number numbers required in password
#ocredit=-1, the number of symbols required in password
exec { "cp /etc/pam.d/system-auth /root;":
  path   => '/usr/bin:/usr/sbin:/bin',
}~>
pam { "Set cracklib limits in password-auth":
  ensure    => present,
  service   => 'system-auth',
  type      => 'password',
  module    => 'pam_cracklib.so',
  arguments => ['try_first_pass','retry=3', 'minlen=10','ucredit=-1','lcredit=-1','dcredit=-1','ocredit=-1'],
}~>
pam { "Set password remember limit in system-auth":
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

# Setting up SSHd options 
exec { "cp /etc/ssh/sshd_config /root;":
  path   => '/usr/bin:/usr/sbin:/bin',
}~>
class { 'ssh::server':
      storeconfigs_enabled => false,
      options => {
        'Banner'	                  => '/etc/issue.net',
	'SyslogFacility'	          => 'AUTHPRIV',
	'PermitRootLogin' 	          => 'yes',
	'AuthorizedKeysFile'              => '.ssh/authorized_keys',
	'PasswordAuthentication'          => 'no',
	'ChallengeResponseAuthentication' => 'no',
	'UsePAM' 			  => 'yes',
	'X11Forwarding' 		  => 'yes',
	'PrintLastLog' 			  => 'yes',
	'AcceptEnv' 			  => 'LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES',
	'AcceptEnv' 			  => 'LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT',
	'AcceptEnv' 			  => 'LC_IDENTIFICATION LC_ALL LANGUAGE',
	'AcceptEnv' 			  => 'XMODIFIERS',
	'Subsystem' 			  => 'sftp  /usr/libexec/openssh/sftp-server',
      },
}

# Notify stanza for changes that require sshd to restart 
class ssh {
service { 'sshd':
    ensure  => 'running',
    enable  => true,
  }

# add a notify to the file resource
  file { '/etc/ssh/sshd_config':
    notify  => Service['sshd'],  # this sets up the relationship
    mode    => '0600',
    owner   => 'root',
    group   => 'root',
  }

}
