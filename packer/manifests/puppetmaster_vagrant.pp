node default {

  include infra::puppetmaster

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