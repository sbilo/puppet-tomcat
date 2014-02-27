# This resource installs default tomee resources in an instance, don't use it directly.
#
# === Authors
#
# Sander Bilo <sander@proteon.nl>
#
# === Copyright
#
# Copyright 2013 Proteon.
#
define tomcat::tomee::init ($instance = $name, $version, $ensure = present) {
  
  tomcat::webapp::maven { "${name}:tomee-webaccess.war":
    instance   => $instance,
    webapp     => 'tomee',
    groupid    => 'org.apache.openejb',
    artifactid => 'tomee-webaccess',
    version    => $version,
  }

  tomcat::listener { "${name}:org.apache.tomee.catalina.ServerListener":
    instance   => $instance,
    class_name => 'org.apache.tomee.catalina.ServerListener',
    require    => Tomcat::Lib::Maven["${name}:tomee-catalina.jar"]
  }

  if($version == '1.6.0') {
     tomcat::tomee::v1_6_0 { $instance: }
  }
}