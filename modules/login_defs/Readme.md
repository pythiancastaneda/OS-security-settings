# login_defs

[![Build Status](https://travis-ci.org/joshbeard/puppet-login_defs.svg?branch=master)](https://travis-ci.org/joshbeard/puppet-login_defs)

## Overview

Manages `/etc/login.defs` on Linux systems.

## Usage

### Class: `login_defs`

#### Parameters

##### `mode`

Specifies the file mode for `/etc/login.defs`.  Defaults to `0644`.

##### `owner`

Specifies the file owner for `/etc/login.defs`. Defaults to 'root'

##### `group`

Specifies the file group for `/etc/login.defs`. Defaults to '0'

##### `options`

A _hash_ of options to populate the `login.defs` file with.

Reference the `login.defs(5)` man page for a list of configuration items and
their description.  [http://linux.die.net/man/5/login.defs](http://linux.die.net/man/5/login.defs)

* Any option you add here will be *merged* with the default options.
* You can override a default value here as well by using a key with the same
  name.
* You can remove a default option by specifying `undef` or an empty string for
  its value.
* Your options will *not* be validated for correctness.

For example:

All the default options *plus* `MY_CUSTOM_OPT` being added:

```puppet
class { '::login_defs':
  options => {
    'MY_CUSTOM_OPT' => 'foo',
  },
}
```

Default `ENCRYPT_METHOD` overridden with 'SHA256':

```puppet
class { '::login_defs':
  options => {
    'ENCRYPT_METHOD' => 'SHA256',
  },
}
```

Remove the default `ENCRYPT_METHOD` entirely:


```puppet
class { '::login_defs':
  options => {
    'ENCRYPT_METHOD' => undef,
  },
}
```

__Default Options:__

__RedHat 5/6:__

```ruby
{
'CREATE_HOME'     => 'yes',
'ENCRYPT_METHOD'  => 'SHA512',
'GID_MAX'         => '60000',
'GID_MIN'         => '500',
'MAIL_DIR'        => '/var/spool/mail',
'PASS_MAX_DAYS'   => '99999',
'PASS_MIN_LEN'    => '5',
'PASS_WARN_AGE'   => '7',
'UID_MAX'         => '60000',
'UID_MIN'         => '500',
'UMASK'           => '022',
'USERGROUPS_ENAB' => 'yes',
}
```

__RedHat 7:__

```ruby
{
'CREATE_HOME'     => 'yes',
'ENCRYPT_METHOD'  => 'SHA512',
'GID_MAX'         => '60000',
'GID_MIN'         => '1000',
'MAIL_DIR'        => '/var/spool/mail',
'PASS_MAX_DAYS'   => '99999',
'PASS_MIN_DAYS'   => '0',
'PASS_MIN_LEN'    => '5',
'PASS_WARN_AGE'   => '7',
'SYS_GID_MAX'     => '999',
'SYS_GID_MIN'     => '201',
'SYS_UID_MAX'     => '999',
'SYS_UID_MIN'     => '201',
'UID_MAX'         => '60000',
'UID_MIN'         => '1000',
'UMASK'           => '077',
'USERGROUPS_ENAB' => 'yes',
}
```

__Debian:__

```ruby
{
'CHFN_RESTRICT'    => 'rwh',
'CREATE_HOME'      => 'yes',
'DEFAULT_HOME'     => 'yes',
'ENCRYPT_METHOD'   => 'SHA512',
'ENV_PATH'         => 'PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games',
'ENV_SUPATH'       => 'PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
'ERASECHAR'        => '0177',
'FAILLOG_ENAB'     => 'yes',
'FTMP_FILE'        => '/var/log/btmp',
'GID_MAX'          => '60000',
'GID_MIN'          => '1000',
'HUSHLOGIN_FILE'   => '.hushlogin',
'KILLCHAR'         => '025',
'LOG_OK_LOGINS'    => 'no',
'LOG_UNKFAIL_ENAB' => 'no',
'LOGIN_RETRIES'    => '5',
'LOGIN_TIMEOUT'    => '60',
'MAIL_DIR'         => '/var/mail',
'MD5_CRYPT_ENAB'   => 'no',
'PASS_MAX_DAYS'    => '99999',
'PASS_MIN_DAYS'    => '0',
'PASS_WARN_AGE'    => '7',
'SU_NAME'          => 'su',
'SYSLOG_SG_ENAB'   => 'yes',
'SYSLOG_SU_ENAB'   => 'yes',
'TTYGROUP'         => 'tty',
'TTYPERM'          => '0600',
'UID_MAX'          => '60000',
'UID_MIN'          => '1000',
'UMASK'            => '022',
'USERGROUPS_ENAB'  => 'yes',
}
```

## Limitations

Only supports RedHat and Debian family operating systems right now.

## Authors

Josh Beard, josh@signalboxes.net
