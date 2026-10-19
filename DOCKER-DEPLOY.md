# Blue Knight Gate: Docker deployment

This is the index.js version, not the separate server.js repository.

## Build configuration

Commit all files from this folder, including Dockerfile, .dockerignore,
package-lock.json, index.js, package.json and any assets, to the repository
branch you intend to deploy. Changes on this computer do not update GitHub.
For Blue-Knight-Panel-V3 the previously verified branch is blue-knight-net;
choose the actual branch containing these updated files.

Dockerfile: Dockerfile (repository root)
Build context: repository root
Container HTTP port: 8080
Start command: leave blank (the image starts node index.js)
Architecture: linux/amd64 for Blitz

## Public HTTPS hosting

The image defaults to an HTTP listener on 8080 and generated client links
using HTTPS on public port 443. The hosting edge must support WebSocket
upgrades and the outbound traffic used by the application.

Set these environment variables using the hostname actually assigned to
THIS deployment (no scheme or path for DOMAIN):

DOMAIN=your-app.example.com
PUBLIC_BASE_URL=https://your-app.example.com

Remove any stale FORCE_HOST, LINK_HOST or LINK_SNI pointing to another app.
If moving from a different repository, do not reuse its credentials or
subscription URLs. This version uses UUID for VLESS/VMess identity;
VLESS_UUID belongs to the separate server.js version.
Optionally set UUID to a valid UUID and PANEL_PASSWORD to a strong password.
Never commit passwords, subscription tokens or runtime data to GitHub.

Persist /app/bk-data to retain passwords, UUID, certificates, downloaded engines
and traffic data. The mounted directory must be writable by UID/GID 1000.
Without persistent storage these values may change on replacement/redeploy.

On first startup the app downloads sing-box and Xray from GitHub. This needs
outbound HTTPS access and may take several minutes. Read runtime logs if it
fails. A successful panel page is not proof that proxy traffic works.

Open https://your-app.example.com/knight and refresh subscriptions after
changing host settings. WS is the first transport to check. Do not assume
raw TCP, UDP, gRPC, HTTPUpgrade or XHTTP pass through an HTTP hosting edge.

## Blitz deployment

Choose My own code, select your updated repository and branch, choose the
root Dockerfile, and leave the start-command override empty. The declared
container port is 8080. Use the assigned public app hostname above.
Blitz's published terms prohibit VPN/proxy services including V2Ray/Xray.
Technical Docker support is not permission to run those services; obtain
provider permission or use hosting that allows this use.
https://blitz.cloud/terms/
https://blitz.cloud/docs/deploy-from-github/

## Local Docker verification

For a local HTTP-only test (not the HTTPS-edge defaults):

docker build -t blue-knight-gate .
docker run --rm -p 8080:8080 -e DOMAIN=localhost -e PUBLIC_BASE_URL=http://localhost:8080 -e LINK_PORT=8080 -e LINK_TLS=false -e FORCE_HTTPS=false -v blue-knight-data:/app/bk-data blue-knight-gate

Visit http://localhost:8080/knight.

Validation performed here: JavaScript syntax and dependency lock generation.
Docker was not installed, so the image build and hosted connectivity were not tested.
