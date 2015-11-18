require 'spec_helper'

describe 'httpproxy', :type => :class do
  $http_proxy = '192.168.1.100'
  $http_proxy_port = '8000'
  $default_no_proxy = 'localhost,127.0.0.1'
  let :valid_required_params do
    {
      :http_proxy => $http_proxy,
      :http_proxy_port => $http_proxy_port,
    }
  end

  context 'on Ubuntu 14.04 64bit' do

    context 'with only required parameters given' do
      let :params do
        valid_required_params
      end
      it { is_expected.to compile }
      it { is_expected.to contain_class('httpproxy') }
      it { is_expected.to contain_file('/etc/profile.d/proxy.sh')
          .with(
            'ensure' => 'present',
            'owner'  => 'root',
            'group'  => 'root',
            'mode'   => '0644',
          )
          .with_content(/export http_proxy=http:\/\/#{$http_proxy}:#{$http_proxy_port}/)
          .with_content(/export https_proxy=http:\/\/#{$http_proxy}:#{$http_proxy_port}/)
          .with_content(/export ftp_proxy=http:\/\/#{$http_proxy}:#{$http_proxy_port}/)
          .with_content(/export no_proxy="#{$default_no_proxy}"/)
      }

      it { is_expected.to contain_file_line('/etc/apt/apt.conf_http_proxy')
        .with(
          'ensure' => 'present',
          'path'   => '/etc/apt/apt.conf',
          'line'   => "Acquire::http::Proxy \"http://#{$http_proxy}:#{$http_proxy_port}/\";",
        )
      }
    end

    context 'with invalid parameters' do
      describe 'should not compile when http_proxy is not a valid ipv4 address' do
        let :params do
          valid_required_params.merge({
            :http_proxy => 'some.server.com',
          })
        end
        it { should_not compile }
      end

      describe 'should not compile when http_proxy_port contains characters other than [0-9]' do
        let :params do
          valid_required_params.merge({
            :http_proxy_port => '999!!!',
          })
        end
        it { should_not compile }
      end

      describe 'should not compile when no_proxy is not a string' do
        let :params do
          valid_required_params.merge({
            :no_proxy => true,
          })
        end
        it { should_not compile }
      end
    end
  end
end
