# Default values for /etc/login.defs .
# These can be overridden or added to by passing a hash to the $options parameter in the main class.
#
class login_defs::params {

  case $::osfamily {
    'RedHat': {
      case $::operatingsystemmajrelease {
        '7': {
          $default_options = {
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
        }
        default: {
          $default_options = {
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
        }
      }
    }
    'Debian': {
      $default_options = {
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
    }
    default: {
      fail("${::osfamily} not supported by ${module_name}")
    }
  }

}
