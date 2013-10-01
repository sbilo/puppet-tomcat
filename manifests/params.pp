# == Class: tomcat::params
#
# This class manages Tomcat parameters.
#
# === Parameters
#
# === Variables
#
# === Examples
#
# === Authors
#
# Sander Bilo <sander@proteon.nl>
#
# === Copyright
#
# Copyright 2013 Proteon.
#
class tomcat::params {
    $root                           = '/opt/tomcat'
    $home                           = "${root}/sites"
    $version                        = '7.0.26-1ubuntu1.2'
    $major_version                  = 7
    $jsp_development                = false
    $jsp_fork                       = true
    $jsp_gen_string_as_char_array   = true
    $jsp_modification_test_interval = 4
    $jsp_trim_spaces                = true
    $jsp_x_powered_by               = false
}
