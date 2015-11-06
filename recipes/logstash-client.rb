#
# Cookbook Name:: mconf-stats
# Recipe:: default
# Author:: Fernando de Avila Bottin (<fbottin@mconf.org>)
#
# This file is part of the Mconf project.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

node.run_state['lumberjack_for'] = :logstash_client

include_recipe 'mconf-stats::logstash'

gem_package 'xml-simple'

directory '/var/cache/sincedbs' do
  owner 'logstash'
  group 'logstash'
  mode '0755'
  action :create
end

execute "setfacl -m u:logstash:r /var/log/syslog"
execute "setfacl -m u:logstash:r /var/log/auth.log"
execute "usermod -a -G daemon logstash"
execute "mv /opt/logstash/mconf/etc/conf.d/patterns /opt/logstash/mconf/etc/conf.d/.patterns" do
	only_if { ::FileTest.directory?("/opt/logstash/mconf/etc/conf.d/patterns") }
end