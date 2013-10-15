# This resource installs a library (jar) from a maven repository in an instance.
#
# === Parameters
#
# Document parameters here.
#
# [*lib*]           The outputfile (artifactid). Defaults to $name.jar
# [*instance*]      The instance this library should be installed in (see tomcat::instance).
# [*groupid*]       The groupid of the library to install.
# [*artifactid*]    The artifactid of the library to install.
# [*version*]       The version of the library to install.
#
# === Variables
#
# === Examples
#
#  tomcat::lib::maven { 'mysql-connector-java-5.1.24':
#   instance   => 'instance_1',
#   groupid    => 'mysql',
#   artifactid => 'mysql-connector-java',
#   version    => '5.1.24',
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
define tomcat::lib::maven ($lib = "${name}.jar", $instance, $groupid, $artifactid, $version, $repos =[]) {
    include ::maven

    if (!defined(Maven["/usr/share/java/${artifactid}-${version}.jar"])) {
        maven { "/usr/share/java/${artifactid}-${version}.jar":
            groupid    => $groupid,
            artifactid => $artifactid,
            version    => $version,
            packaging  => 'jar',
            repos      => $repos,
        }
    }
    
    file { "${tomcat::params::home}/${instance}/tomcat/lib/${lib}":
        ensure     => 'link',
        target     => "/usr/share/java/${artifactid}-${version}.jar",
        force      => true,
        require    => Maven["/usr/share/java/${artifactid}-${version}.jar"],
        notify     => Tomcat::Service[$instance],
    }
}
