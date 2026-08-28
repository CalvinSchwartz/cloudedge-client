# Getting the init string with mitmproxy in Docker

The CloudEdge app returns the `deviceP2PInitString` field in the response to
`/device/info`. One practical way to capture it from an iPhone is to run
mitmproxy in Docker, point the phone at it as an HTTP proxy, and inspect the
recorded requests.

## Start mitmproxy

Run the proxy container on a machine that is on the same network as the
iPhone:

```bash
docker run --rm -it \
  --name mitmproxy \
  -p 8080:8080 \
  -p 8081:8081 \
  mitmproxy/mitmproxy \
  mitmweb --listen-host 0.0.0.0 --web-host 0.0.0.0 --set block_global=false
```

This exposes:

- `8080` for the proxy itself
- `8081` for the mitmweb UI

Open `http://localhost:8081` in a browser on the Docker host to view traffic.

## Point the iPhone at the proxy

1. Find the Docker host's LAN IP address.
2. On the iPhone, open the Wi-Fi network details.
3. Set the HTTP proxy to Manual.
4. Enter the Docker host IP and port `8080`.

## Install the certificate

1. On the iPhone, open `http://mitm.it`.
2. Install the iOS certificate profile.
3. Trust the certificate in Settings > General > About > Certificate Trust Settings.

If certificate installation or trust is missing, the CloudEdge app will usually
fail to decrypt the traffic, so the `/device/info` response will not be visible.

## Capture the init string

Open the CloudEdge app and trigger the device info request. In mitmweb, look
for a `/device/info` request and inspect the JSON response. The field you want
is:

```json
"deviceP2PInitString": "EDHNFFBLL...:WeEye2ppStronGer"
```

Copy that value into your config file or environment variable.

## Troubleshooting

- If you see no traffic, confirm the iPhone proxy settings point at the Docker
  host IP and port `8080`.
- If requests appear but are unreadable, the certificate is not trusted on the
  iPhone.
- If mitmweb is inaccessible, make sure port `8081` is not blocked by a local
  firewall.