# == Class: Tomcat 
#
# === Parameters
#
# [*version*] The tomcat version to install, defaults to 7.
#
# === Variables
#
# === Examples
#
#  class { tomcat:
#    version  => 6
#  }
#
# === Authors
#
# Sander Bilo <sander@proteon.nl>
#
# === Copyright
#
# Copyright 2013 Proteon.
#
class tomcat ($version = $tomcat::params::version, $major_version = $tomcat::params::major_version) inherits tomcat::params {
    
    include concat::setup

    if($major_version == 7) {
        $ensure = $::tomcat7version ? {
            $version => held,
            default  => $version,
        }

        package { "tomcat7": 
            ensure => $ensure 
        }
    }

    elsif($major_version == 6) {
        $ensure = $::tomcat6version ? {
            $version => held,
            default  => $version,
        }
        package { "tomcat7":               
            ensure => $ensure
        }
    }
                                    
    
    package { ['libtcnative-1', 'liblog4j1.2-java', 'libcommons-logging-java']: ensure => held, }

    file { [$tomcat::params::root, $tomcat::params::home, '/etc/tomcat.d/',]:
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
    }

    file { '/etc/init.d/tomcat':
        source => 'puppet:///modules/tomcat/tomcat',
        owner  => 'root',
        group  => 'root',
    }

    file { '/usr/sbin/tomcat':
        ensure => link,
        target => '/etc/init.d/tomcat',
        owner  => 'root',
        group  => 'root',
    }

    service { "tomcat${major_version}":
        ensure  => stopped,
        pattern => "/var/lib/tomcat${major_version}",
        enable  => false,
        require => Package["tomcat${major_version}"],
    }

    profile_d::script { 'CATALINA_HOME.sh':
        ensure  => present,
        content => "export CATALINA_HOME=/usr/share/tomcat${major_version}",
    }

    profile_d::script { 'CATALINA_BASE.sh':
        ensure  => present,
        content => 'export CATALINA_BASE=$HOME/tomcat',
    }
}
