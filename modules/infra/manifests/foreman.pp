class infra::foreman {

  file { '/var/lib/puppet/ssl/certs':
  	ensure => present,
  	source  => "puppet:///modules/infra/ssl/certs",
  	owner => 'puppet',
  	group => 'puppet',
    recurse => true,
  	mode => 644
  } ->

  file { '/var/lib/puppet/ssl/private_keys':
  	ensure => present,
  	source  => "puppet:///modules/infra/ssl/private_keys",
  	owner => 'puppet',
  	group => 'puppet',
    recurse => true,
  	mode => 644
  } ->

  # Provide the answerfile for the puppet installer
  file { "/etc/foreman/foreman-installer-answers.yaml":
    ensure  => present,
    source  => "puppet:///modules/infra/foreman.answers",
    owner => root,
    group => root,
    mode  => 600,
    require => Package["foreman-installer"],
  }

  include infra::installer

}