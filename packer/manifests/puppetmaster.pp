node default {

  include infra::puppetmaster

  package { 'supervisor':
    ensure => present
  } ->

  file { '/etc/supervisord.conf':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/infra/supervisord/puppetmaster.conf'
  }

  # Keep the foreman-proxy in the foreground so we
  # can manage it with supervisord
  file_line { 'foreman_proxy_no_daemonize':
    path    => '/etc/foreman-proxy/settings.yml',
    line    => ':daemon: false',
    match   => '^:daemon:.*',
    require => Exec['foreman-installer']
  }

  # Fix the common module path
  file_line { 'puppetmaster_common_modules':
    path    => '/etc/puppet/puppet.conf',
    line    => '    basemodulepath   = /etc/puppet/environments/common/modules:/etc/puppet/modules:/usr/share/puppet/modules',
    match   => '    basemodulepath.*',
    require => Exec['foreman-installer']
  }

  class { 'hiera':
    eyaml     => true,
    datadir   => '/etc/puppet/hiera',
    hierarchy => [
      '%{::environment}/nodes/%{::clientcert}',
      '%{::environment}/modules/%{module_name}',
      '%{::environment}/common'
    ]
  }

}