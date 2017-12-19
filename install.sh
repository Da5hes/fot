echo "Installing dependencies..."
sudo apt install cmake python-pip libspdlog-dev redis-tools redis-server liblzma-dev libhwloc-dev -y

echo "get rust environment (need manual selected to 'nightly' branch"
curl https://sh.rustup.rs -sSf | sh
# echo "export PATH=\"$HOME/.cargo/bin:$PATH\"" >> $HOME/.bashrc
