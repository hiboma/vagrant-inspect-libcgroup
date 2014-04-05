require 'spec_helper'

describe "/cgroup/*/vagrant/root - root が制限に入ってないかどうか" do
  describe file('/cgroup/cpu/root/cpu.cfs_quota_us') do
    it { should_not be_file }
  end

  describe file('/cgroup/memory/root/memory.memsw.limit_in_bytes') do
    it { should_not be_file }
  end

  describe file('/cgroup/memory/root/memory.memsw.limit_in_bytes') do
    it { should_not be_file }
  end
end

