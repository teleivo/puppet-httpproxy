Exec {
    path => [ '/usr/bin', '/bin', '/usr/sbin', '/sbin' ]
}

class{ '::httpproxy':
  http_proxy      => '192.168.1.100',
  http_proxy_port => '8000',
}
