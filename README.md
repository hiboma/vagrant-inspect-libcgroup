# vagrant-inspect-libcgroup

## setup vagrant

```
git clone https://github.com/hiboma/vagrant-inspect-libcgroup.git
cd vagrant-inspect-libcgroup
bundle install
vagrant up
```

## libcgroup-0.40.rc1-5.el6_5.1.x86_64

libcgroup-0.40.rc1-5.el6_5.1.x86_64 seems to have bug if `cgrules.conf` and `cgrules.conf` use ___tempalte___ notation.

### How to reproduce bug

```sh
vagrant provision
```

Serverspec of cgroup fails.

```
$ bundle exec rake spec
/Users/hiroya/.rbenv/versions/2.1.0/bin/ruby -S rspec spec/default/cgroup_root_spec.rb spec/default/cgroup_vagrant_spec.rb
....F.F.F.F.F

Failures:

  1) /cgroup/*/vagrant/vagrant - vagrant に制限が課されているかどうか File "/cgroup/cpuset/vagrant/cpuset.mems" content should match /0/
     Failure/Error: its(:content) { should match /0/ }
       sudo cat /cgroup/cpuset/vagrant/cpuset.mems 2> /dev/null || sudo echo -n
       
       expected "\n" to match /0/
       Diff:
       @@ -1,2 +1 @@
       -/0/
     # ./spec/default/cgroup_vagrant_spec.rb:6:in `block (3 levels) in <top (required)>'

  2) /cgroup/*/vagrant/vagrant - vagrant に制限が課されているかどうか File "/cgroup/cpuset/vagrant/cpuset.cpus" content should match /0/
     Failure/Error: its(:content) { should match /0/ }
       sudo cat /cgroup/cpuset/vagrant/cpuset.cpus 2> /dev/null || sudo echo -n
       
       expected "\n" to match /0/
       Diff:
       @@ -1,2 +1 @@
       -/0/
     # ./spec/default/cgroup_vagrant_spec.rb:11:in `block (3 levels) in <top (required)>'

  3) /cgroup/*/vagrant/vagrant - vagrant に制限が課されているかどうか File "/cgroup/cpu/vagrant/cpu.cfs_quota_us" content should match /50000/
     Failure/Error: its(:content) { should match /50000/ }
       sudo cat /cgroup/cpu/vagrant/cpu.cfs_quota_us 2> /dev/null || sudo echo -n
       -1
       expected "-1\n" to match /50000/
       Diff:
       @@ -1,2 +1,2 @@
       -/50000/
       +-1
     # ./spec/default/cgroup_vagrant_spec.rb:16:in `block (3 levels) in <top (required)>'

  4) /cgroup/*/vagrant/vagrant - vagrant に制限が課されているかどうか File "/cgroup/memory/vagrant/memory.memsw.limit_in_bytes" content should match /104857600/
     Failure/Error: its(:content) { should match /104857600/ }
       sudo cat /cgroup/memory/vagrant/memory.memsw.limit_in_bytes 2> /dev/null || sudo echo -n
       9223372036854775807
       expected "9223372036854775807\n" to match /104857600/
       Diff:
       @@ -1,2 +1,2 @@
       -/104857600/
       +9223372036854775807
     # ./spec/default/cgroup_vagrant_spec.rb:21:in `block (3 levels) in <top (required)>'

  5) /cgroup/*/vagrant/vagrant - vagrant に制限が課されているかどうか File "/cgroup/memory/vagrant/memory.memsw.limit_in_bytes" content should match /104857600/
     Failure/Error: its(:content) { should match /104857600/ }
       sudo cat /cgroup/memory/vagrant/memory.memsw.limit_in_bytes 2> /dev/null || sudo echo -n
       9223372036854775807
       expected "9223372036854775807\n" to match /104857600/
       Diff:
       @@ -1,2 +1,2 @@
       -/104857600/
       +9223372036854775807
     # ./spec/default/cgroup_vagrant_spec.rb:26:in `block (3 levels) in <top (required)>'
```

## libcgroup-0.41

libcgroup-0.41 works fine.

```sh
$ LIBCGROUP_VERSION=0.41 vagrant provision 
```

Serverspec of cgorup success

```sh
[$ bundle exec rake spec
.............

Finished in 3.24 seconds
13 examples, 0 failures
```