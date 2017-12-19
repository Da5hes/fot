echo "Installing dependencies..."
sudo apt install -y cmake python-pip libspdlog-dev redis-tools redis-server liblzma-dev libhwloc-dev libc6-dev-i386

echo "get rust environment (need manual selected to 'nightly' branch"
curl https://sh.rustup.rs -sSf | sh
# echo "export PATH=\"$HOME/.cargo/bin:$PATH\"" >> $HOME/.bashrc
