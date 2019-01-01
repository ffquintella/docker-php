Exec {
  path  => '/bin:/sbin:/usr/bin:/usr/sbin',
}

package {'sudo':
  ensure => present,
}

package{'zip':
  ensure => present,
}

package{'vim-common':
  ensure => present,
}

package{'htop':
  ensure  => present,
  require => Package['epel-release'],
}

package{'wget':
  ensure => present,
}

package{'epel-release':
  ensure => present
}

package{'git':
  ensure => present,
}

package{'samba-client':
  ensure => present,
}

exec {'Intall WebTatic':
  command => 'rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm',
  creates => '/etc/yum.repos.d/webtatic.repo',
  require => Package['epel-release'],
} ->

# Full update
exec {'Full update':
  path  => '/bin:/sbin:/usr/bin:/usr/sbin',
  command => 'yum -y update',
}

package{'php72w-cli':
  ensure  => present,
  require => Exec['Intall WebTatic'],
} ->

package{'php72w-fpm':
  ensure  => present,
  require => Exec['Intall WebTatic'],
} ->

package{'php72w-mbstring':
  ensure  => present,
  require => Exec['Intall WebTatic'],
} ->

package{'php72w-mysql':
  ensure  => present,
  require => Exec['Intall WebTatic'],
} ->

package{'php72w-xml':
  ensure  => present,
  require => Exec['Intall WebTatic'],
} ->

file{ '/libs':
  ensure => directory,
} ->

wget::fetch { "Download composer phar":
  source      => 'https://getcomposer.org/composer.phar',
  destination => '/libs/',
  timeout     => 0,
  verbose     => false,
} ->

wget::fetch { "Download phing phar":
  source      => 'http://www.phing.info/get/phing-2.16.1.phar',
  destination => '/libs/phing.phar',
  timeout     => 0,
  verbose     => false,
} ->

class { "pear":
  package => "php72w-pear",
  require => Package["php72w-cli"],
} ->

pear::package { "PEAR": } ->
pear::package { "Archive_Tar": } ->

# Cleaning unused packages to decrease image size
exec {'erase installer':
  path  => '/bin:/sbin:/usr/bin:/usr/sbin',
  command => 'rm -rf /tmp/*; rm -rf /opt/staging/*'
} ->

exec {'erase cache':
  path  => '/bin:/sbin:/usr/bin:/usr/sbin',
  command => 'rm -rf /var/cache/*'
}

package {'openssh-server': ensure => absent }
package {'rhn-check': ensure => absent }
package {'rhn-client-tools': ensure => absent }
package {'rhn-setup': ensure => absent }
package {'rhnlib': ensure => absent }

package {'/usr/share/kde4':
  ensure => absent
}
