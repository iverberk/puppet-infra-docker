node default {

  include infra::foreman

  # Adjust shared memory for Docker containers which 
  # might not have the required amount available and
  # no way to change it
  file_line { 'pgsql_shared_memory_setting':
    path    => '/var/lib/pgsql/data/postgresql.conf',
    line    => 'shared_buffers = 16MB',
    match   => '^shared_buffers =.*',
    require => Exec['foreman-installer']
  }

  package { 'supervisor':
    ensure => present
  } ->

  file { '/etc/supervisord.conf':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/infra/supervisord/foreman.conf'
  }

}