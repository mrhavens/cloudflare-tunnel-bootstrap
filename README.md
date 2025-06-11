## 📄 README.md (First Version)

````markdown
# Cloudflare Tunnel Bootstrap 🌀

Expose any local Linux server to the internet securely using a Cloudflare Tunnel with Zero Configuration DNS routing. This setup allows resilient access to ports and services via subdomains like:

- `samson.thefoldwithin.earth`
- `forgejo.samson.thefoldwithin.earth`
- `rpc.samson.thefoldwithin.earth`
- `ssh.samson.thefoldwithin.earth`

## 🔧 Requirements

- A Linux server (bare metal, VM, or WSL)
- Domain managed by Cloudflare
- Installed: `cloudflared`, `git`, `bash`, `curl`

## 🚀 Quickstart

### 1. Clone the repo

```bash
git clone https://github.com/thefoldwithin/cloudflare-tunnel-bootstrap.git
cd cloudflare-tunnel-bootstrap
````

### 2. Install `cloudflared` (if needed)

```bash
./install-cloudflared.sh
```

### 3. Authenticate with Cloudflare

```bash
cloudflared tunnel login
```

### 4. Create a tunnel named after your host (e.g., `samson`)

```bash
cloudflared tunnel create samson
```

### 5. Auto-generate a full config file and DNS records

```bash
./bootstrap-tunnel.sh samson thefoldwithin.earth 8000
```

This will:

* Create `~/.cloudflared/config.yml`
* Route `samson.thefoldwithin.earth` to port 8000
* Create subdomains and restart the tunnel

### 6. Run the tunnel as a service

```bash
sudo cloudflared service install
sudo systemctl restart cloudflared
```

---

## 🛠 Included Scripts

| File                     | Description                                                         |
| ------------------------ | ------------------------------------------------------------------- |
| `install-cloudflared.sh` | Installs the latest `cloudflared` binary                            |
| `bootstrap-tunnel.sh`    | Creates a tunnel config, routes subdomains, and writes `config.yml` |
| `config.template.yml`    | Editable template for generating configs                            |

---

## 📜 Example Generated Config

```yaml
tunnel: abc123-abc123-abc123
credentials-file: /home/username/.cloudflared/abc123-abc123-abc123.json

ingress:
  - hostname: samson.thefoldwithin.earth
    service: http://localhost:8000
  - service: http_status:404
```

---

## 🌐 Result

Access your local server at:

```
https://samson.thefoldwithin.earth
```

---

## 🧬 About

This repo is part of **The Fold** infrastructure initiative. It provides a resilient, mirrored, recursive service model for distributed digital sanctuaries.

---

> 🔒 Everything you run locally stays private — unless *you* decide to expose it.

---
