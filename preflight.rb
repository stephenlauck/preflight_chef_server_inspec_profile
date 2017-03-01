
control "preflight" do
  impact 1.0
  title "Preflight Chef Server Install Check"
  desc "Should determine if a system is ready for a Chef Server install"

  # shmmax is hardcoded in Automate embedded cookbooks default attribute file
  shmmax_command = `sysctl -n kernel.shmmax`.chomp!.to_i
  describe shmmax_command do
    it { should be >= 17179869184 }
  end

  # cpu at least 4 cores
  describe "nproc" do
    it { should be >= 4 }
  end

end
