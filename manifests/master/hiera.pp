# Class puppet::master::hiera

class puppet::master::hiera (
  $hiera_backends = undef,
  $hierarchy      = $puppet::master::params::hiera_hierarchy,
  $hieradata_path = $puppet::master::params::hieradata_path,
  $env_owner      = $puppet::master::params::env_owner,
  $eyaml_keys     = false) inherits puppet::master::params {
  file { $hieradata_path:
    ensure => directory,
    owner  => $env_owner,
    group  => $env_owner,
    mode   => '0755',
  }

  file { '/etc/hiera.yaml':
    ensure  => file,
    content => template('puppet/hiera.yaml.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Class['apache::service']
  }

  file { '/etc/puppet/hiera.yaml':
    ensure  => link,
    target  => '/etc/hiera.yaml',
    require => File['/etc/hiera.yaml']
  }

  # eyaml for hiera
  if $eyaml_keys {
    file { '/etc/puppet/keys':
      ensure => directory,
      owner  => 'puppet',
      group  => 'puppet',
      mode   => '0700',
    }

    # eyaml keys
    file { '/etc/puppet/keys/eyaml':
      ensure => directory,
      owner  => 'puppet',
      group  => 'puppet',
      mode   => '0700',
    }

    file { '/etc/puppet/keys/eyaml/private_key.pkcs7.pem':
      ensure => file,
      owner  => 'puppet',
      group  => 'puppet',
      mode   => '0600',
      source => 'puppet:///modules/local/eyaml/private_key.pkcs7.pem',
    }

    file { '/etc/puppet/keys/eyaml/public_key.pkcs7.pem':
      ensure => file,
      owner  => 'puppet',
      group  => 'puppet',
      mode   => '0600',
      source => 'puppet:///modules/local/eyaml/public_key.pkcs7.pem',
    }
  }

}
