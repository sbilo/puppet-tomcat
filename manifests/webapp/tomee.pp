# This resource installs the tomee functionality in a tomcat instance.
#
# === Parameters
#
# [*instance*]  The instance this application should be installed in (see tomcat::instance). Defaults to $name.
#
# === Variables
#
# === Examples
#
#  tomcat::webapp::manager { 'instance_1': }
#
# === Authors
#
# Sander Bilo <sander@proteon.nl>
#
# === Copyright
#
# Copyright 2013 Proteon.
#
define tomcat::webapp::tomee ($instance = $name, $version = 'LATEST') {
    include tomcat

    tomcat::webapp::maven { "${name}:tomee-plus-webapp.war":
        instance    => $instance,
        webapp      => 'tomee',
        groupid     => 'org.apache.openejb',
        artifactid  => 'tomee-plus-webapp',
        version     => $version,
    }
}
