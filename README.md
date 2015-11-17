# puppet-httpproxy

[![Build Status](https://secure.travis-ci.org/teleivo/puppet-httpproxy.png?branch=master)](https://travis-ci.org/teleivo/puppet-httpproxy)

#### Table of Contents

1. [Module Description - What the module does and why it is useful](#module-description)
2. [Setup - The basics of getting started with httpproxy](#setup)
    * [Beginning with httpproxy](#beginning-with-httpproxy)
3. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    * [Classes](#classes)
    * [Parameters](#parameters)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development](#development)

## Module Description

The httpproxy module configures http proxy on Ubuntu 14.04.
It currently adds
* /etc/profile.d/proxy.sh (from template)

## Setup

### Beginning with httpproxy

The quickest setup httpproxy is to add the following to your manifest

```puppet
class{ '::httpproxy':
  http_proxy      => '192.168.1.100',
  http_proxy_port => '8000',
}
```

## Reference

### Classes

#### Public classes

* [`httpproxy`](#httpproxy): Configures httpproxy.

#### Private classes

### Parameters

All parameters are optional except where otherwise noted.

#### httpproxy

##### `http_proxy`

*Required.* Specifies the ipv4 address of the http proxy which will be
configured.
Valid options: string containing ipv4 address.

##### `http_proxy_port`

*Required.* Specifies the port of the http proxy which will be configured.
Valid options: string containing digits from [0-9].

##### `no_proxy`

Specifies a comma separated list of ip addresses which should not go through the proxy.
Currently only used in line 'export no_proxy="${no_proxy}"' in /etc/profile.d/proxy.sh.
Valid options: string.
Defaults to "localhost,127.0.0.1"

## Limitations

This module is currently only tested on Ubuntu 14.04 64bit.  

## Development

Please feel free to open pull requests!

### Running tests
This project contains tests for [rspec-puppet](http://rspec-puppet.com/) to
verify functionality.

To install all dependencies for the testing environment:
```bash
sudo gem install bundler
bundle install
```

To run tests, lint and syntax checks once:
```bash
bundle exec rake test
```

To run the tests on any change of puppet files in the manifests folder:
```bash
bundle exec guard
```

