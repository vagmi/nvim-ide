#!/bin/bash
#
git clone https://github.com/rbenv/rbenv.git $HOME/.rbenv
eval "$($HOME/.rbenv/bin/rbenv init - bash)"
git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
rbenv install 3.1.2
rbenv global 3.1.2
gem install bundler solargraph
