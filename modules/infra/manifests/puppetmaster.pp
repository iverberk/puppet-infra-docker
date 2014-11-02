class infra::puppetmaster {

  # Provide the answerfile for the puppet installer
  file { "/etc/foreman/foreman-installer-answers.yaml":
    ensure  => present,
    source  => "puppet:///modules/infra/puppetmaster.answers",
    owner => root,
    group => root,
    mode  => 600,
    require => Package["foreman-installer"],
  }

  class { 'puppetdb::master::config':
    puppetdb_server => 'puppetdb.localdomain',
    require => Exec['foreman-installer'],
    strict_validation => false,
    restart_puppet => false
  }

  include infra::installer

}