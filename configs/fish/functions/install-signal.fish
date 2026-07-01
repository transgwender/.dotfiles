# Based off https://discussion.fedoraproject.org/t/accurate-way-to-install-signal-in-fedora/117236/9 adapted for Fish
function install-signal --description 'Fetches repo and installs Signal Desktop on Fedora'
	# Get the kernel version
	set -l kernel_ver (uname --kernel-release)

	# Strip suffix, get last dot-seperated field
	set -l distro_ver (string replace -r '\.x86_64$' '' $kernel_ver | awk -F '.' '{print $NF}')

	# Skip the first two characters
	set -l distro_ver (string sub --start=3 $distro_ver)

	# Run installation
	sudo dnf config-manager addrepo --from-repofile=https://opensuse.org/repositories/network:/im:/signal/Fedora_$distro_ver/network:im:signal.repo
	sudo dnf install signal-desktop --quiet --assumeyes
end

