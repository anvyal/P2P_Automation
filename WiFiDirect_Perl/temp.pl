adb -s f071a0d9 shell busybox ifconfig

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:16436  Metric:1
          RX packets:127 errors:0 dropped:0 overruns:0 frame:0
          TX packets:127 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:9872 (9.6 KiB)  TX bytes:9872 (9.6 KiB)

p2p0      Link encap:Ethernet  HWaddr 00:0A:F2:35:63:33
          inet addr:192.168.49.98  Bcast:192.168.49.255  Mask:255.255.255.0
          inet6 addr: fe80::20a:f2ff:fe35:6333/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:19 errors:0 dropped:0 overruns:0 frame:0
          TX packets:21 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:100
          RX bytes:2684 (2.6 KiB)  TX bytes:3099 (3.0 KiB)

wlan0     Link encap:Ethernet  HWaddr 00:0A:F1:35:63:33
          inet addr:192.168.1.21  Bcast:192.168.1.255  Mask:255.255.255.0
          inet6 addr: fe80::20a:f1ff:fe35:6333/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:3077 errors:0 dropped:0 overruns:0 frame:0
          TX packets:184 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:100
          RX bytes:374937 (366.1 KiB)  TX bytes:16891 (16.4 KiB)
