

$packs = split($extra_packs, ";")

$packs.each |String $value| {
  package{$value:
    ensure => present
  }
}

if $php_debug == 'true' {
  package {'php70w-pecl-xdebug':
    ensure => present,
  }
}

if $pre_run_cmd != '' {
  $real_pre_run_cmd = $pre_run_cmd
} else {
  $real_pre_run_cmd = "echo 0;"
}

# Using Pre-run CMD
exec {'Pre Run CMD':
  path  => '/bin:/sbin:/usr/bin:/usr/sbin',
  command => $real_pre_run_cmd
} ->

# Starting gcc
exec {'Starting php-fpm':
  path  => '/bin:/sbin:/usr/bin:/usr/sbin',
  command => "php-fpm "
} ->
exec {'Starting nginx':
  path  => '/bin:/sbin:/usr/bin:/usr/sbin',
  command => "nginx "
}