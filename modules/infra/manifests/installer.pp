class infra::installer {

  package { "cronie": 
  	ensure => present 
  } ->

  package { 'foreman-installer':
  	ensure => '1.6.2-1.el6',
  	notify => Exec['foreman-installer']
  } 

  # Execute the foreman installer
  exec { 'foreman-installer':
    command => "/usr/sbin/foreman-installer",
    timeout => 0,
    refreshonly => true,
    require => File['/etc/foreman/foreman-installer-answers.yaml']
  }

}