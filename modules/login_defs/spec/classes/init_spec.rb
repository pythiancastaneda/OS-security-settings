require 'spec_helper'
describe 'login_defs' do

  let(:facts) do
    {
      :osfamily => 'RedHat',
    }
  end

  context 'with default parameters' do
    header = <<-EOT
#
# HEADER: This file is managed by Puppet
# HEADER: Do not make modifications directly!
#
###############################################################################
#
# /etc/login.defs - Configuration control definitions for the login package.
#
EOT

    default_options = {
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
    content = default_options.map{|k,v| "#{k} #{v}"}.join("\n")

    it { should contain_class('login_defs') }
    it { should contain_file('/etc/login.defs').with_content(/#{header}#{content}/) }
  end

  context 'on an unsupported osfamily' do
    let(:facts) {{ :osfamily => 'Windows' }}
    it 'should fail when osfamily is windows' do
      should raise_error(
        Puppet::Error, /Windows not supported by login_defs/
      )
    end
  end

end
