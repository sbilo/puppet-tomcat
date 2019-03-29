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
  $ensure   = 'running',
  $provider = 'base',
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
    file { "/opt/tomcat/sites/${name}/tomcat/bin/startup.sh":
      ensure => present,
      source => "puppet:///modules/tomcat/tomcat_startup.sh_for_systemd",
      owner  => 'root',
      group  => 'root',
      mode   => '0755',

    }->
    file {"/etc/systemd/system/${name}.service":
      ensure => 'present',
      content => template('tomcat/systemd.unit.erb'),
    }->
    service { $name:
      ensure   => 'running',
      enable   => true,
      provider => 'systemd',
    }    
  } else {
    fail("Not implemented!")
  }
}
