require 'spec_helper'

describe "/cgroup/*/vagrant/vagrant - vagrant に制限が課されているかどうか" do
  describe file('/cgroup/cpuset/vagrant/cpuset.mems') do
    it { should be_file }
    its(:content) { should match /0/ }
  end

  describe file('/cgroup/cpuset/vagrant/cpuset.cpus') do
    it { should be_file }
    its(:content) { should match /0/ }
  end

  describe file('/cgroup/cpu/vagrant/cpu.cfs_quota_us') do
    it { should be_file }
    its(:content) { should match /50000/ }
  end

  describe file('/cgroup/memory/vagrant/memory.memsw.limit_in_bytes') do
    it { should be_file }
    its(:content) { should match /104857600/ }
  end

  describe file('/cgroup/memory/vagrant/memory.memsw.limit_in_bytes') do
    it { should be_file }
    its(:content) { should match /104857600/ }
  end
end
