# Publish

This repo is safe to publish after reviewing secrets.

Do not add:

- Browser profiles
- SSH private keys
- API tokens
- Password stores
- CopyQ clipboard history databases
- Large personal data files

Recommended remote setup:

```bash
gh repo create nixos-setup --private --source . --remote origin --push
```

Or create an empty GitHub repository manually, then run:

```bash
git remote add origin git@github.com:YOUR_NAME/nixos-setup.git
git push -u origin main
```

Clone and rebuild on another machine:

```bash
git clone git@github.com:YOUR_NAME/nixos-setup.git
cd nixos-setup
sudo nixos-rebuild switch --flake .#nixos
```
