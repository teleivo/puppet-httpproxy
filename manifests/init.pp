# See README.md for documentation.
class httpproxy (
  $http_proxy,
  $http_proxy_port,
  $no_proxy = 'localhost,127.0.0.1',
) {
  validate_ipv4_address($http_proxy)
  validate_re($http_proxy_port, '^\d+$')
  validate_string($no_proxy)

  file { '/etc/profile.d/proxy.sh':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('httpproxy/proxy.sh.erb'),
  }
}
