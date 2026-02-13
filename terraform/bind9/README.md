Documentation: https://registry.terraform.io/providers/hashicorp/dns/latest/docs

### T-Sig Key Authentication
**RFC 8945: Secret Key Transaction Authentication for DNS**
- Multiple hash algorithms supported
	- Use at least sha2
	- MD5 should NOT be used. Considered insecure
1. Create tsig key with sha256. If running Bind9 in Docker, run this inside the container:
```sh
tsig-keygen -a hmac-sha256
```
2. In bind9 config directory, paste the output to a file called `named.conf.key`. Make sure this is protected with correct permissions
3. Add that .conf.key by adding an "include" to `named.conf`
```sh
include "/etc/bind/named.conf.key";
```

### Bind9 Dynamic Updates
- To accept dynamic updates to a zone from any client that authenticates with the **tsig-key** above, you need to add the following `update-policy` to that zone. Example:
```sh
zone "hughboi.cc" {
    type master;
    file "/etc/bind/zones/db.hughboi.cc";
    update-policy { grant tsig-key zonesub any; }; // allow dynamic updates
};
```

**tsig-key** is the same name that is defined in `named.conf.key` e.g. **tsig-key**. Very important that these keys match!

- Restart the container to apply changes


### .tf file
- make sure this is stored securely!! Don't want a DNS spoof attack to happen

```sh
git clone https://github.com/itshughboi/iac.git
cd /iac/terraform/bind9

terraform init
terraform plan
terraform apply
```

### Test
```sh 
dig proxmox.hughboi.cc
```
- This should resolve back 4 IP's: 10.10.10.1-4 using DNS Round Robin


### Merge journal records to zone record
Tool: **rndc**

- Add a `rndc.conf` file in the /config directory on bind. It will use the same key auth
`rndc.conf`
```sh
include "/etc/bind/named.conf.key";

options {
    default-key "tsig-key"
    default-server 127.0.0.1;
    default-port 953;  # Secure DNS protocol
}
```

- Now enable settings on bind9 named.conf options
- Since we run this on the host, we can reference the local IP

`named.conf.options`
```sh
controls {
    inet 127.0.0.1 port 953
    allow { 127.0.0.1; } keys { "tsig-key"; };
};
```

- Now actually use the tool to merge
```sh
sudo docker exec -it # /bin/sh

rndc sync
```


### Merge Automation
- Use Ansible to periodically sync these changes. Not super important because the journal file that gets written to is still persistent storage. It won't go away. This is just to have everything in one file for viewability