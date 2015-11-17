require 'spec_helper'

describe 'httpproxy', :type => :class do
  context 'on Ubuntu 14.04 64bit' do
    $http_proxy = '192.168.1.100'
    $http_proxy_port = '8000'
    $default_no_proxy = 'localhost,127.0.0.1'

    let(:params) { {
      :http_proxy => $http_proxy,
      :http_proxy_port => $http_proxy_port,
    } }

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

    context 'should not compile when http_proxy is not a valid ipv4 address' do
      [
        true,
        'some.server.com',
        'nonesense',
        9999,
      ].each do |bad_param_http_proxy|
        it "should fail with http_proxy #{bad_param_http_proxy}" do
          params.merge!({ :http_proxy => $bad_param_http_proxy })
          should_not compile
        end
      end
    end

    context 'should not compile when http_proxy_port contains characters other than [0-9]' do
      [
        true,
        'nonesense',
        '!9999',
      ].each do |bad_param_http_proxy_port|
        it "should fail with http_proxy_port #{bad_param_http_proxy_port}" do
          params.merge!({ :http_proxy_port => $bad_param_http_proxy_port })
          should_not compile
        end
      end
    end

    it 'should not compile when no_proxy is not a string' do
      params.merge!({'no_proxy' => true})
      should_not compile
    end
  end
end
