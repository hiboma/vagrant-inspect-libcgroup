# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

$script = <<SCRIPT

LIBCGROUP_VERSION=$1

set -eux

:
: yum-install
(
    yum install libcgroup -y byacc flex wget pam-devel

    if [ "$LIBCGROUP_VERSION" = "" ]; then
        yum reinstall -y libcgroup
    fi
)

:
: install-cgroup
(
    # See availavle versions: http://sourceforge.net/projects/libcg/files/libcgroup/
    if [ "$LIBCGROUP_VERSION" ]; then

        # build and install
        if [ ! -d "/usr/local/libcgroup-${LIBCGROUP_VERSION}" ]; then
            rm -rf libcgroup-${LIBCGROUP_VERSION}
            wget http://jaist.dl.sourceforge.net/project/libcg/libcgroup/v${LIBCGROUP_VERSION}/libcgroup-${LIBCGROUP_VERSION}.tar.bz2
            tar xf libcgroup-${LIBCGROUP_VERSION}.tar.bz2
            cd libcgroup-${LIBCGROUP_VERSION}
            ./configure --prefix=/usr/local/libcgroup-${LIBCGROUP_VERSION}/
            make
            make install
        fi

        sudo ln -svf /usr/local/libcgroup-${LIBCGROUP_VERSION}/sbin/cgrulesengd    /sbin/
        sudo ln -svf /usr/local/libcgroup-${LIBCGROUP_VERSION}/sbin/cgconfigparser /sbin/
    fi
)

:
: setup-cgroup
(
cat << CGRULES > /etc/cgrules.conf
# /etc/cgrules.conf
#The format of this file is described in cgrules.conf(5)
#manual page.
#
# Example:
#<user>         <controllers>   <destination>
vagrant         cpuset,cpu,memory  %u
*               *                  default
CGRULES

cat << CGCONFIG > /etc/cgconfig.conf
mount {
        cpuset  = /cgroup/cpuset;
        cpu     = /cgroup/cpu;
        cpuacct = /cgroup/cpuacct;
        memory  = /cgroup/memory;
        devices = /cgroup/devices;
        freezer = /cgroup/freezer;
        net_cls = /cgroup/net_cls;
        blkio   = /cgroup/blkio;
}

template %u {
    cpu {
        cpu.cfs_quota_us = 50000;
    }
    cpuset {
        cpuset.mems = 0;
        cpuset.cpus = 0;
    }
    memory {
        memory.limit_in_bytes       = 104857600;
        memory.memsw.limit_in_bytes = 104857600;
    }
}
CGCONFIG

    chkconfig cgconfig on
    chkconfig cgred    on

    service cgconfig restart
    service cgred    restart

    # 'fork(2) + setuid(2)' make /cgroup/*/vagrant/vagrnat directory
    su - vagrant -c "echo hello >/dev/null"
)
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box     = "CentOS 6.5 x86_64"
  config.vm.box_url = "https://github.com/2creatives/vagrant-centos/releases/download/v6.5.1/centos65-x86_64-20131205.box"
  config.vm.provision "shell" do |s|
    s.inline = $script
    s.args   = ENV["LIBCGROUP_VERSION"]
  end

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "off"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "off"]
  end
end
