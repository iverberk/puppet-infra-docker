class infra::puppetdb {

  class { '::puppetdb::server':
    database_host => 'localhost',
    listen_address => '0.0.0.0'
  }

  class { '::puppetdb::database::postgresql':
    listen_addresses => 'localhost',
  }

}