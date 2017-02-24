# raspberryPi_openVPN
OpenVPN server on raspberryPi 3

                          +-------------------------+
               (public IP)|                         |
  {INTERNET}=============={   router (192.168.1.1)  |
                          |                         |
                          |         LAN switch      |
                          +------------+------------+
                                       | (192.168.1.0/24)
                                       |
                                       |              +-----------------------+
                                       |              |                       |
                                       |              |        openVPN        |  eth0: 192.168.1.13/24
                                       +--------------{eth0    server         |  tun0: 10.8.0.1/24
                                       |              |                       |
                                       |              |           {tun0}      |
                                       |              +-----------------------+
                                       |
                              +--------+-----------+
                              |                    |
                              |  other LAN clients |
                              |                    |
                              |   192.168.1.0/24   |
                              |   (internal net)   |
                              +--------------------+

To convert client files (client.conf) to ".ovpn" format use the following script:

https://gist.github.com/laurenorsini/10013430
