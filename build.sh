#!/bin/bash
# This should rather be a makefile or 'ruby-like' build file (thor or rake).
# This can be improved to match scripting language conventions, take args, etc.
# clean everything but the .vagrant dir, or we'll lose our vm.
git clean -fdx -e .vagrant
# make the build temp directory.
# Ideally, the name gets decorated with datetimes or git hash refs:
# enough decoration/grist to make it distinct and fit with system naming conventions.
sudo mkdir -p /var/www/krecipe/1.0_hashref
# copy all the production source
sudo rsync -avz --exclude .git --exclude .gitignore --exclude .vagrant --exclude unicorn.conf.rb /vagrant/* /var/www/krecipec/1.0_hashref/
# customize the config file to point to the to-be-installed directory.
sudo /bin/bash -c 'cat /vagrant/unicorn.conf.rb | perl -pe "s:^(working_directory ).*:\1 \"/var/www/krecipec/1.0_hashref\":" > /var/www/krecipec/1.0_hashref/unicorn.conf.rb'
# fix up permissions.
# not sure what the default groups are this should run as.
# we flip it back to match the vagrant user.
sudo chown -hR vagrant:vagrant /var/www/krecipec/1.0_hashref
pushd /var/www/krecipec/1.0_hashref && bundle package
sudo fpm -s dir -t deb -n "krecipec" -v 1.0 --provides krecipec --config-files /var/www/krecipec/1.0_hashref/unicorn.conf.rb -p /var/cache/apt/archives /var/www/krecipec/1.0_hashref