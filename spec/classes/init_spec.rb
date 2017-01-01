require 'spec_helper'

shared_examples 'shared examples' do
  it { should compile.with_all_deps }
  it { should contain_class('apt') }
  it { should contain_class('puppetlabs_apt') }
  it { should contain_package('puppetlabs-release') }
  it { should contain_apt__source('puppetlabs').with_location('http://apt.puppetlabs.com/') }
  it { should contain_apt__source('puppetlabs').with_key({'id' => '6F6B15509CF8E59E6E469F327F438280EF8D349F',
                                                          'server' => 'pgp.mit.edu'}) }
end

describe 'puppetlabs_apt' do
  describe 'On a supported Debian version' do
    let(:facts) {{
      :osfamily  => 'Debian',
      :lsbdistid => 'Debian',
      :lsbdistcodename => 'wheezy',
    }}

    context "without any parameters" do
      let(:params) {{ }}

      it_behaves_like "shared examples"
      it { should contain_apt__source('puppetlabs').with_repos('main dependencies') }
    end

    context "with enable_collection => true" do
      let(:params) { { :enable_collection => true } }

      it_behaves_like "shared examples"
      it { should contain_apt__source('puppetlabs').with_repos('main dependencies PC1') }
    end

    context "with enable_collection => false" do
      let(:params) { { :enable_collection => false } }

      it_behaves_like "shared examples"
      it { should contain_apt__source('puppetlabs').with_repos('main dependencies') }
    end

    context "with enable_devel => true" do
      let(:params) { {:enable_devel => true} }

      it_behaves_like "shared examples"
      it { should contain_apt__source('puppetlabs').with_repos('main dependencies devel') }

      context "with enable_collection => true" do
        let(:params) { { :enable_collection => true, :enable_devel => true } }

        it_behaves_like "shared examples"
        it { should contain_apt__source('puppetlabs').with_repos('main dependencies devel PC1') }
      end
    end

    describe 'On an unsupported Debian version' do
      let(:facts) {{
          :osfamily  => 'Debian',
          :lsbdistid => 'Debian',
          :lsbdistcodename => 'stretch',
      }}
      context "when on stretch" do
        let(:params) {{ }}
        it { should contain_apt__source('puppetlabs').with_release('wheezy') }
      end
    end
  end

  context 'undef release codename' do
    let(:params) {{ }}
    let(:facts) {{
      :osfamily => 'Debian',
      :lsbdistid => 'Debian',
      :lsbdistcodename => nil,
    }}

    it { expect { should contain_package('puppetlabs_release') }.to raise_error(Puppet::Error, /Failed to determine the release codename/) }
  end

  context 'unsupported operating system' do
    describe 'puppetlabs_apt class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { should contain_package('puppetlabs_release') }.to raise_error(Puppet::Error, /This module only works on Debian or derivatives like Ubuntu/) }
    end
  end
end
