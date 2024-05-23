# OpenVPN Client Docker Image

## WTF Is This?

Yo, hackers and punks! Welcome to the most badass OpenVPN Client Docker image you'll ever see. This ain't your grandma's VPN setup. It's sleek, it's stealthy, and it’s ready to serve your rebellious needs.

## What's Inside?

This container is a lean, mean, tunneling machine built on top of the latest Alpine image. It’s got OpenVPN, bash, and curl installed. What more do you need? Oh, and there’s a nifty script (`run.sh`) that takes care of all the dirty work.

## How to Use It?

1. **Pull the image**:

   ```sh
   docker pull psyb0t/openvpn-client:latest
   ```

2. **Create your OpenVPN config**:
   Make sure you have your `vpn-config.ovpn` and `vpn-auth.txt` (if needed) ready.

3. **Run the container**:

   ```sh
   docker run -v /path/to/vpn-config.ovpn:/vpn-config.ovpn -v /path/to/vpn-auth.txt:/vpn-auth.txt psyb0t/openvpn-client:latest
   ```

   Bam! You’re now connected to your VPN. But wait, there’s more...

## Anarchy in Docker Compose

Wanna route all your container traffic through this VPN? Of course you do! Here’s how you do it in style with Docker Compose:

```yaml
version: "3.8"

services:
  openvpn-client:
    image: psyb0t/openvpn-client:latest
    cap_add:
      - NET_ADMIN
    volumes:
      - ./openvpn/config.ovpn:/vpn-config.ovpn
      - ./openvpn/auth.txt:/vpn-auth.txt
    restart: always
  curl:
    image: curlimages/curl
    depends_on:
      - openvpn-client
    network_mode: service:openvpn-client
    command: >
      sh -c "while true; do
               curl -s https://icanhazip.com;
               sleep 10;
             done"
    restart: always
```

Just throw your app in there, and watch it ride the encrypted waves of your VPN like a boss.

## Features

- **Stealth Mode**: Your IP’s got an invisibility cloak. It constantly checks to make sure your real IP isn’t exposed, and if it is, it freaks out and kills everything. No leaks, no bullshit.
- **Easy Setup**: Drop in your config files, and you’re good to go.
- **WTFPL License**: Do whatever the f\*ck you want. Seriously.

## Contribute or Die Trying

Got some sick ideas? Found a bug? Wanna make it even more badass? Fork it, PR it, or open an issue. Just don’t be a douche about it.

## Credits

To all the anarchists, hackers, and misfits who make the internet a fun place to be. You rock!

Stay safe, stay anonymous. Peace out.

---

_P.S. Remember, friends don't let friends surf the web without a VPN._
