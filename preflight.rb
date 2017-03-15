#All examples preceded by the ruby pattern variable=`some_command`.chomp!.to_i
#could use a custom resource that feeds into a matcher capable of <= >= < > and so on

control "preflight" do
  impact 1.0
  title "Preflight Chef Server Install Check"
  desc "Should determine if a system is ready for a Chef Server install"

  # cpu at least 4 cores
  describe command('nproc') do
    it { should exist }
    its('stdout') { should cmp /[4-9][0-9]?/ }
  end

  # shmmax is hardcoded in Automate embedded cookbooks default attribute file
  describe kernel_parameter('kernel.shmmax') do
    its('value') { should be >= 17179869184 }
  end
  
  describe directory("/var") do
    it { should exist }
  end

  # Got 80GB available?
  var_disk_free=`df -m /var | tail -1 | cut -d' ' -f6`.chomp!.to_i
  describe var_disk_free do
    it { should be >= 80000 }
  end
  
  describe directory("/etc") do
    it { should exist }
  end

  describe command("su -c 'umask' -l root") do
    its('stdout') { should eq "0022\n" }
  end
end
