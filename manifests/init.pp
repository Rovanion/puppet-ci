# == Class: puppetci
#
#  Install Jenkins.  Add a job called PuppetCI to statically test puppet code.
#
# === Parameters
#
# === Variables
#
#
# === Examples
# For now, it needs manual editing, you can do this via the Jenkins GUI.  You'll need to set the Repo's on the Main settings,
# and the URL for the github project in the job configuration.
#
# === Authors
#
# Matthew Barr <mbarr@mbarr.net>
#
# === Copyright
#
# Copyright 2013 Matthew Barr.
#

class puppetci {

  package { 'java-1.7.0-openjdk':
    ensure => installed,
  }

  package { 'git': ; }

  # For RVM
  package {
    'gcc-c++':
    ;

    'patch':
    ;

    'readline':
    ;

  #For RVM 
  package {
    'gcc-c++':;
    'patch':;
    'readline':;
    'readline-devel':;
    'zlib':;
    'zlib-devel':;
    'libyaml-devel':;
    'libffi-devel':;
    'openssl-devel':;
    'libxml2-devel':;
    'libxslt-devel':;
    'make':;
    'bzip2':;
    'autoconf':;
    'automake':;
    'libtool':;
    'bison':;
    'libcurl-devel':;
  }

  class { 'jenkins':
    lts  => true,
    repo => true,
  }

  class { 'puppetci::plugins':
    require => Package['jenkins'];
  }

  file {
    '/var/lib/jenkins/org.jenkinsci.plugins.ghprb.GhprbTrigger.xml':
      source  => 'puppet:///modules/puppetci/org.jenkinsci.plugins.ghprb.GhprbTrigger.xml',
      replace => 'no',
      owner   => 'jenkins',
      group   => 'jenkins';

    '/var/lib/jenkins/jobs':
      ensure => directory,
      owner  => 'jenkins',
      group  => 'jenkins';

    '/var/lib/jenkins/jobs/Template_puppet_module':
      ensure => directory,
      owner  => 'jenkins',
      group  => 'jenkins';

    '/var/lib/jenkins/jobs/Template_puppet_module/config.xml':
      ensure  => file,
      replace => 'no',
      source  => 'puppet:///modules/puppetci/template_config.xml',
      owner   => 'jenkins',
      group   => 'jenkins';

    '/var/lib/jenkins/jobs/PuppetCI':
      ensure => directory,
      owner  => 'jenkins',
      group  => 'jenkins';

    '/var/lib/jenkins/jobs/PuppetCI/config.xml':
      ensure  => file,
      replace => 'no',
      content  => file('puppetci/seedjob_config.xml'),
      owner   => 'jenkins',
      group   => 'jenkins';
  }

}
