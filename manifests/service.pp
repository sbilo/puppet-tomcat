# This class installs default service resources in an instance, don't use it directly.
#
# === Authors
#
# Sander Bilo <sander@proteon.nl>
#
# === Copyright
#
# Copyright 2013 Proteon.
#
define tomcat::service (
  $ensure          = 'running',
  $provider        = 'base',
  $systemd_restart = false,
) {
  if ($provider == 'base') {
    service { $name:
      ensure     => $ensure,
      provider   => 'base',
      pattern    => "-Dcatalina.base=${tomcat::params::home}/${name}/tomcat",
      start      => "/usr/sbin/tomcat start --instance=${name} --timeout=0",
      stop       => "/usr/sbin/tomcat stop --instance=${name} --timeout=0",
      hasrestart => false,
      hasstatus  => false,
    }
  } elsif ($provider == 'systemd') {
    file {"/etc/systemd/system/${name}.service":
      ensure => 'present',
      content => template('tomcat/systemd.unit.erb'),
    }->
    service { $name:
      ensure   => 'running',
      enable   => true,
      provider => 'systemd',
    }
    service { 'tomcat':
      ensure => 'stopped',
      enable => false,
    }
  } else {
    fail("Not implemented!")
  }
}
