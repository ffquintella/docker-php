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

package{'nginx':
  ensure => present,
}

exec {'Intall remi':
  command => 'dnf -y install dnf-utils http://rpms.remirepo.net/enterprise/remi-release-8.rpm',
  require => Package['epel-release'],
} ->

exec {'points php to 8.2':
  command => 'dnf -y module reset php; dnf -y module enable php:remi-8.2',
  require => Package['epel-release'],
} ->

# Full update
exec {'Full update':
  path  => '/bin:/sbin:/usr/bin:/usr/sbin',
  command => 'dnf -y update',
}

package{'php':
  ensure  => present,
} ->

package{'php-cli':
  ensure  => present,
} ->

package{'php-gd':
  ensure  => present,
} ->

package{'php-fpm':
  ensure  => present,
} ->

package{'php-mbstring':
  ensure  => present,
} ->

package{'php-mysql':
  ensure  => present,
} ->

package{'php-xml':
  ensure  => present,
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
  package => "php-pear",
  require => Package["php-cli"],
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
