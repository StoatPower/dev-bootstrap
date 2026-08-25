# GPG Signing Setup

GPG key creation and restoration are intentionally **not automated** by `dev-bootstrap`.
This document covers the manual setup for Git commit/tag signing.

## Generate a new key

```bash
gpg --full-generate-key
```

Use a modern ECC key:

- Primary/signing key: **Ed25519**
- Encryption subkey: **Curve25519** (`cv25519`), if offered
- Protect the key with a strong passphrase

Find the resulting fingerprint:

```bash
gpg --list-secret-keys --keyid-format=long
gpg --fingerprint
```

Use the **full fingerprint**, not the shorter key ID.

## Configure Git

```bash
git config --global user.signingkey FULL_FINGERPRINT
git config --global commit.gpgsign true
git config --global tag.gpgsign true
git config --global gpg.program gpg
```

`dev-bootstrap` configures the terminal for GPG in the managed Bash configuration:

```bash
if tty -s; then
  export GPG_TTY="$(tty)"
fi
```

## Add the key to GitHub

Export the public key:

```bash
gpg --armor --export FULL_FINGERPRINT
```

Copy the complete output, including:

```text
-----BEGIN PGP PUBLIC KEY BLOCK-----
...
-----END PGP PUBLIC KEY BLOCK-----
```

Add it under:

**GitHub → Settings → SSH and GPG keys → New GPG key**

Old public keys can remain registered so historical signed commits continue to verify.

## Test signing

Test GPG directly:

```bash
echo "GPG signing test" | gpg --clearsign
```

Test Git:

```bash
mkdir -p /tmp/gpg-test
cd /tmp/gpg-test

git init
git commit --allow-empty -S -m "Test GPG signing"
git log --show-signature -1
```

## Back up the key

Create a protected working directory:

```bash
mkdir -p ~/gpg-backup
chmod 700 ~/gpg-backup

FINGERPRINT="FULL_FINGERPRINT"
```

Export the secret key, public key, and ownertrust:

```bash
gpg --armor --export-secret-keys "$FINGERPRINT" \
  > ~/gpg-backup/private-key.asc

gpg --armor --export "$FINGERPRINT" \
  > ~/gpg-backup/public-key.asc

gpg --export-ownertrust \
  > ~/gpg-backup/ownertrust.txt

chmod 600 ~/gpg-backup/private-key.asc
chmod 644 ~/gpg-backup/public-key.asc
chmod 600 ~/gpg-backup/ownertrust.txt
```

Create an independently encrypted archive:

```bash
tar -C ~/gpg-backup \
  -czf - \
  private-key.asc public-key.asc ownertrust.txt |
gpg --pinentry-mode loopback \
  --symmetric \
  --cipher-algo AES256 \
  --output ~/gpg-backup.tar.gz.gpg
```

Use a strong backup passphrase and store it separately.

Copy `gpg-backup.tar.gz.gpg` somewhere outside the WSL distro and keep a second
secure backup if possible.

After verifying the backup, remove the plaintext exports:

```bash
rm -rf ~/gpg-backup
```

## Restore from backup

Decrypt and unpack:

```bash
mkdir -p ~/gpg-restore

gpg --decrypt ~/gpg-backup.tar.gz.gpg |
  tar -xz -C ~/gpg-restore
```

Import:

```bash
gpg --import ~/gpg-restore/public-key.asc
gpg --import ~/gpg-restore/private-key.asc
gpg --import-ownertrust ~/gpg-restore/ownertrust.txt
```

Verify:

```bash
gpg --list-secret-keys --keyid-format=long
gpg --fingerprint
```

Then configure `git user.signingkey` with the restored fingerprint and delete
the temporary plaintext restore directory.