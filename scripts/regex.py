#!/usr/bin/python3

import re

with open('/home/redadmin/dhcpd.leases') as f:
    content = f.readlines()

macfilter = re.compile('([a-f0-9][a-f0-9]:?){6}')
ipfilter = re.compile('((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.){3}(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])')

macs = [x.group() for i in content for x in re.finditer(macfilter,i)]
ips = [x.group() for i in content for x in re.finditer(ipfilter,i)]

print(macs)
print(ips)
