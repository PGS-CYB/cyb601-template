# CYB 601 – Software and Systems Security

Your working repository for the term. You provision one Kubernetes environment
on the course Proxmox server, then secure one reference system across seven labs.

## Prerequisites (Week 0)

- An SSH client, Git, VS Code, `kubectl`, Terraform or OpenTofu, and `jq`.
- Access to the course Proxmox URL and the public bastion (your instructor sends both).
- A GitHub account and a Google account (for the Google Skills labs).

Run the environment check with your bastion details:

```bash
BASTION=BASTION_IP BASTION_USER=BASTION_USER ./tools/week0-check.sh | tee week0/check.txt
```

## Reaching your environment

- Proxmox console: `https://PROXMOX_URL:8006`
- Bastion (SSH jump host): `ssh BASTION_USER@BASTION_IP`
- Your VM, through the bastion: `ssh -J BASTION_USER@BASTION_IP ubuntu@VM_IP`
- Your cluster, from your laptop: tunnel the API, then use `kubectl`
  ```bash
  ssh -J BASTION_USER@BASTION_IP -f -N -L 6443:127.0.0.1:6443 ubuntu@VM_IP
  export KUBECONFIG=~/.kube/cyb601.yaml
  kubectl get nodes
  ```

Student VMs have no public address. Everything in reaches you through the bastion;
the cluster only calls out (DNS and 443) for images, GitHub and signature checks.

## Provisioning (Week 1)

```bash
cd infra
cp terraform.tfvars.example terraform.tfvars   # then edit the values
export PROXMOX_VE_ENDPOINT="https://PROXMOX_URL:8006"
read -rs PROXMOX_VE_API_TOKEN; export PROXMOX_VE_API_TOKEN   # user@realm!id=secret
terraform init
terraform plan -out=lab1.tfplan
terraform apply lab1.tfplan
```

## Layout

| Path | What it is |
| --- | --- |
| `infra/` | Terraform for your VM and k3s (bpg/proxmox provider) |
| `app/` | The reference system: Juice Shop, a customer API, Postgres, a WAF placeholder |
| `tools/` | The Week 0 environment check |
| `.github/workflows/` | The Lab 4 image build and the Lab 7 security pipeline |
| `labs/` | Your evidence and reports, one folder per lab |

## Submitting a lab

Commit your work, then tag it:

```bash
git add labs/labN
git commit -m "Lab N: <summary>"
git push
git tag labN-submit && git push origin labN-submit
```

Then upload the 2-page report PDF to the LMS. See `labs/README.md`.

## Rules

- Attack only your own VM and cluster; in the capstone, only your assigned target.
- Never scan or test anything outside the course Proxmox environment.
- Keep secrets out of Git. If one is exposed, rotate it, then clean history.
- AI tools may explain errors and syntax; analysis and conclusions are your own
  and are disclosed in each lab's `README`.