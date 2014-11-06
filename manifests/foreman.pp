node default {

  include infra::foreman

  package { 'supervisor':
  	ensure => present
	} ->

  file { '/etc/supervisord.conf':
  	ensure => present,
  	owner => 'root',
  	group => 'root',
  	mode => 644,
  	source => 'puppet:///modules/infra/supervisord/foreman.conf'
	}

}