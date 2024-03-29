# arcts/keepalived

A small [Alpine](https://alpinelinux.org/) based Docker container that provides a method of IP high availability via [keepalived](http://www.keepalived.org/) (VRRP failover), and optional Kubernetes API Server monitoring. If allowed to auto configure (default behaviour) it will automatically generate a unicast based failover configuration with a minimal amount of user supplied information.

For specific information on Keepalived, please see the man page on [keepalived.conf](http://linux.die.net/man/5/keepalived.conf) or the [Keepalived User Guide](http://www.keepalived.org/pdf/UserGuide.pdf).


## Index
* [Prerequisites](#prerequisites)
* [Configuration](#configuration)
  * [Execution Control](#execution-control)
  * [Autoconfiguration Options](#autoconfiguration-options)
  * [Kubernetes Options](#kubernetes-options)
* [Suggested Kubernetes Settings](#suggested-kubernetes-settings)
* [Example keepalived Configs](#example-keepalived-config)
* [Example Run Commands](#example-run-commands)


## Prerequisites

Before attempting to deploy the keepalived container, the host must allow non local binding of ipv4 addresses. To do this, configure the sysctl tunable `net.ipv4.ip_nonlocal_bind=1`.

In addition to enabling the nonlocal binds, the container must be run with both host networking (`--net=host`) and security setting CAP_NET_ADMIN (`--cap-add NET_ADMIN`) capability. These allow the container to manage the host's networking configuration, and this is essential to the function of keepalived.


## Configuration
### Execution Control

|        Variable       |                      Default                     |
|:---------------------:|:------------------------------------------------:|
| `KEEPALIVED_AUTOCONF` |                      `true`                      |
|   `KEEPALIVED_CONF`   |         `/etc/keepalived/keepalived.conf`        |
|    `KEEPALIVED_CMD`   | `/usr/sbin/keepalived -n -l -f $KEEPALIVED_CONF` |
|   `KEEPALIVED_DEBUG`  |                      `false`                     |

* `KEEPALIVED_AUTOCONF` -  Enables or disables the auto-configuration of keepalived.

* `KEEPALIVED_CONF` - The path to the keepalived configuration file.

* `KEEPALIVED_CMD` - The command called to execute keepalived.

* `KEEPALIVED_DEBUG` - Enables or disables debug level logging for keepalived (adds `-D` to `KEEPALIVED_CMD`.


### Autoconfiguration Options

|                   Variable                  |               Default              |
|:-------------------------------------------:|:----------------------------------:|
|           `KEEPALIVED_ADVERT_INT`           |                 `1`                |
|            `KEEPALIVED_AUTH_PASS`           | `pwd$KEEPALIVED_VIRTUAL_ROUTER_ID` |
|            `KEEPALIVED_INTERFACE`           |               `eth0`               |
|            `KEEPALIVED_PRIORITY`            |                `200`               |
|              `KEEPALIVED_STATE`             |              `MASTER`              |
|       `KEEPALIVED_TRACK_INTERFACE_###`      |                                    |
|         `KEEPALIVED_UNICAST_SRC_IP`         |                                    |
|        `KEEPALIVED_UNICAST_PEER_###`        |                                    |
|      `KEEPALIVED_VIRTUAL_IPADDRESS_###`     |                                    |
| `KEEPALIVED_VIRTUAL_IPADDRESS_EXCLUDED_###` |                                    |
|        `KEEPALIVED_VIRTUAL_ROUTER_ID`       |                 `1`                |
|      `KEEPALIVED_KUBE_APISERVER_CHECK`      |               `false`              |

* `KEEPALIVED_ADVERT_INT` - The VRRP advertisement interval (in seconds).

* `KEEPALIVED_AUTH_PASS` - A shared password used to authenticate each node in a VRRP group (**Note:** If password is longer than 8 characters, only the first 8 characters are used).

* `KEEPALIVED_INTERFACE` - The host interface that keepalived will monitor and use for VRRP traffic.

* `KEEPALIVED_PRIORITY` - Election value, the server configured with the highest priority will become the Master.

* `KEEPALIVED_STATE` - Defines the server role as Master or Backup. (**Options:** `MASTER` or `BACKUP`).

* `KEEPALIVED_TRACK_INTERFACE_###` - An interface that's state should be monitored (e.g. eth0). More than one can be supplied as long as the variable name ends in a number from 0-999.

* `KEEPALIVED_UNICAST_SRC_IP` - The IP on the host that the keepalived daemon should bind to. **Note:** If not specified, it will be the first IP bound to the interface specified in `KEEPALIVED_INTERFACE`.

* `KEEPALIVED_UNICAST_PEER_###` - An IP of a peer participating in the VRRP group. More tha one can be supplied as long as the variable name ends in a number from 0-999.

* `KEEPALIVED_VIRTUAL_IPADDRESS_###` - An instance of an address that will be monitored and failed over from one host to another. These should be a quoted string in the form of: `<IPADDRESS>/<MASK> brd <BROADCAST_IP> dev <DEVICE> scope <SCOPE> label <LABEL>` At a minimum the ip address, mask and device should be specified e.g. `KEEPALIVED_VIRTUAL_IPADDRESS_1="10.10.0.2/24 dev eth0"`. More than one can be supplied as long as the variable name ends in a number from 0-999. **Note:** Keepalived has a hard limit of **20** addresses that can be monitored. More can be failed over with the monitored addresses via `KEEPALIVED_VIRTUAL_IPADDRESS_EXCLUDED_###`.


* `KEEPALIVED_VIRTUAL_IPADDRESS_EXCLUDED_###` - An instance of an address that will be failed over with the monitored addresses supplied via `KEEPALIVED_VIRTUAL_IPADDRESS_###`.  These should be a quoted string in the form of: `<IPADDRESS>/<MASK> brd <BROADCAST_IP> dev <DEVICE> scope <SCOPE> label <LABEL>` At a minimum the ip address, mask and device should be specified e.g. `KEEPALIVED_VIRTUAL_IPADDRESS_EXCLUDED_1="172.16.1.20/24 dev eth1"`. More than one can be supplied as long as the variable name ends in a number from 0-999.

* `KEEPALIVED_VIRTUAL_ROUTER_ID` - A unique number from 0 to 255 that should identify the VRRP group. Master and Backup should have the same value. Multiple instances of keepalived can be run on the same host, but each pair **MUST** have a unique virtual router id.

* `KEEPALIVED_KUBE_APISERVER_CHECK` -  If enabled it configures a simple check script for the Kubernetes API-Server. For more information on this feature, please see the [Kubernetes Options](#kubernetes-options) section.


### Kubernetes Options


|          **Variable**         |                   **Default**                  |
|:-----------------------------:|:----------------------------------------------:|
|    `KUBE_APISERVER_ADDRESS`   | parsed from `KEEPALIVED_VIRTUAL_IPADDRESS_###` |
|     `KUBE_APISERVER_PORT`     |                     `6443`                     |
| `KUBE_APISERVER_CHK_INTERVAL` |                       `3`                      |
|   `KUBE_APISERVER_CHK_FALL`   |                      `10`                      |
|   `KUBE_APISERVER_CHK_RISE`   |                       `2`                      |
|  `KUBE_APISERVER_CHK_WEIGHT`  |                      `-50`                     |



* `KUBE_APISERVER_ADDRESS` - The Virtual IP being used for the Kube API Server. If none is supplied, it is assumed to be the lowest numbered entry in the `KEEPALIVED_VIRTUAL_IPADDRESS_###` variables.

* `KUBE_APISERVER_PORT` - The port to use in conjunction with the `KUBE_APISERVER_ADDRESS`.

* `KUBE_APISERVER_CHK_INTERVAL` - The interval in seconds between calling the script.

* `KUBE_APISERVER_CHK_FALL` - The number of consecutive non-zero script exits before setting the state to `FAULT`.

* `KUBE_APISERVER_CHK_RISE` - The number of consecutive zero script exits before exiting the `FAULT` state.

* `KUBE_APISERVER_CHK_WEIGHT` - The weight to apply to the priority when the service enters the `FAULT` state.



---

### Suggested Kubernetes Settings

Assuming there are three nodes running the kube-apiserver, you cannot rely on setting just the`KEEPALIVED_STATE` parameter to manage failover across the nodes.

To manage kube-apiserver failover, enable the healthcheck option with `KEEPALIVED_KUBE_APISERVER_CHECK`, and set the `KEEPALIVED_PRIORITY` manually for the three instances.

| **Node** | **Priority** |
|:--------:|:------------:|
|  node-01 |      200     |
|  node-02 |      190     |
|  node-03 |      180     |

With the default weight of `-50`, if `node-01` has an issue, it's priority will drop to `150` and allow `node-02` to take over, the same is repeated if `node-02` has a failure dropping it's weight to `140` and `node-03` takes over.

Recovery occurs in the same order with the system with the highest priority being promoted to master.

### Example Keepalived Configs

##### Example Autogenerated Keepalived Master Config
```
vrrp_instance MAIN {
  state MASTER
  interface eth0
  virtual_router_id 2
  priority 200
  advert_int 1
  unicast_src_ip 10.10.0.21
  unicast_peer {
    10.10.0.22
  }
  authentication {
    auth_type PASS
    auth_pass pwd1
  }
  virtual_ipaddress {
    10.10.0.2/24 dev eth0
  }
  virtual_ipaddress_excluded {
    172.16.1.20/24 dev eth1
  }
  track_interface {
    eth0
    eth1
  }
}
```

##### Example Autogenerated Keepalived Backup Config
```
vrrp_instance MAIN {
  state BACKUP
  interface eth0
  virtual_router_id 2
  priority 100
  advert_int 1
  unicast_src_ip 10.10.0.22
  unicast_peer {
    10.10.0.21
  }
  authentication {
    auth_type PASS
    auth_pass pwd1
  }
  virtual_ipaddress {
    10.10.0.2/24 dev eth0
  }
  virtual_ipaddress_excluded {
    172.16.1.20/24 dev eth1
  }
  track_interface {
    eth0
    eth1
  }
}

```


## Example Run Commands
##### Example Master Run Command
```bash
docker run -d --net=host --cap-add NET_ADMIN \
-e KEEPALIVED_AUTOCONF=true                  \
-e KEEPALIVED_STATE=MASTER                   \
-e KEEPALIVED_INTERFACE=eth0                 \
-e KEEPALIVED_VIRTUAL_ROUTER_ID=2            \
-e KEEPALIVED_UNICAST_SRC_IP=10.10.0.21      \
-e KEEPALIVED_UNICAST_PEER_0=10.10.0.22      \
-e KEEPALIVED_TRACK_INTERFACE_1=eth0         \
-e KEEPALVED_TRACK_INTERFACE_2=eth1          \
-e KEEPALIVED_VIRTUAL_IPADDRESS_1="10.10.0.3/24 dev eth0" \
-e KEEPALIVED_VIRTUAL_IPADDRESS_EXCLUDED_1="172.16.1.20/24 dev eth1" \
arcts/keepalived
```

##### Example Backup Run Command
```bash
docker run -d --net=host --cap-add NET_ADMIN \
-e KEEPALIVED_AUTOCONF=true                  \
-e KEEPALIVED_STATE=BACKUP                   \
-e KEEPALIVED_INTERFACE=eth0                 \
-e KEEPALIVED_VIRTUAL_ROUTER_ID=2            \
-e KEEPALIVED_UNICAST_SRC_IP=10.10.0.22      \
-e KEEPALIVED_UNICAST_PEER_0=10.10.0.21      \
-e KEEPALIVED_TRACK_INTERFACE_1=eth0         \
-e KEEPALVED_TRACK_INTERFACE_2=eth1          \
-e KEEPALIVED_VIRTUAL_IPADDRESS_1="10.10.0.3/24 dev eth0" \
-e KEEPALIVED_VIRTUAL_IPADDRESS_EXCLUDED_1="172.16.1.20/24 dev eth1" \
arcts/keepalived
```
