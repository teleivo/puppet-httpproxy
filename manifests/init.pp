# See README.md for documentation.
class httpproxy (
  $http_proxy,
  $http_proxy_port,
  $no_proxy = 'localhost,127.0.0.1',
  $keep_sudoers_env = false,
) {
  validate_ipv4_address($http_proxy)
  validate_re($http_proxy_port, '^\d+$')
  validate_string($no_proxy)
  validate_bool($keep_sudoers_env)

  file { '/etc/profile.d/proxy.sh':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('httpproxy/proxy.sh.erb'),
  }

  if ($keep_sudoers_env) {
    file { '/etc/sudoers.d/proxy':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0440',
      content =>
        "Defaults env_keep += \"HTTP_PROXY HTTPS_PROXY FTP_PROXY NO_PROXY\"\nDefaults env_keep += \"http_proxy https_proxy ftp_proxy no_proxy\"\n",
    }
  }
}
