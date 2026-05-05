# Pail

A two-pane S3 file browser. Drag and drop between buckets, copy, move, delete,
preview, and download — all from the browser.

---

## Quick start (Windows)

1. Make sure Python 3.10+ is installed. Get it from
   <https://www.python.org/downloads/>. **Tick "Add Python to PATH"** during
   install.
2. Double-click **`start.bat`**.

First launch creates a virtual environment and installs dependencies (~30s).
After that, launches take a couple of seconds. The app opens automatically at
<http://127.0.0.1:5000>. Closing the console window stops the server.

---

## Setting up AWS credentials

Pail reads credentials the same way the AWS CLI does — from `%USERPROFILE%\.aws\`
(i.e. `C:\Users\<you>\.aws\`). Pick whichever option matches how your team
distributes access:

### Option A — SSO (recommended for org users, auto-refreshes)

If your company uses AWS SSO / Identity Center, this is the cleanest setup.
You log in once, and Pail refreshes credentials silently for the rest of the
SSO session.

```powershell
aws configure sso
```

Follow the prompts (start URL, region, account, role, profile name). Then any
time your token expires:

```powershell
aws sso login --profile <your-profile-name>
```

Pick your profile in Pail's login screen → **Profile** tab → **Login**.

### Option B — Static keys (simplest)

Edit `C:\Users\<you>\.aws\credentials`:

```ini
[default]
aws_access_key_id = AKIA...
aws_secret_access_key = ...

[work]
aws_access_key_id = AKIA...
aws_secret_access_key = ...
```

And `C:\Users\<you>\.aws\config`:

```ini
[default]
region = us-east-1

[profile work]
region = us-west-2
```

(Note: in `config`, named profiles need the `profile ` prefix; in `credentials`
they don't.)

In Pail, the **Default chain** tab will pick up `[default]` automatically. Other
profiles show up in the **Profile** dropdown.

### Option C — Temporary keys (one-off)

If your org hands out time-limited Access Key / Secret Key / Session Token
triples, paste them into the **Keys** tab and click Login. They'll work until
the token expires (usually 1–12 hours), then you'll need to re-paste fresh
ones.

### Verifying credentials work

Before debugging Pail, confirm AWS itself is happy:

```powershell
aws sts get-caller-identity --profile <your-profile>
```

If that prints your identity, Pail will work too. If it errors, fix it there
first — Pail uses the same boto3 stack underneath.

---

## Using Pail

- **Two panels**, top/bottom or side-by-side (toggle in the top bar).
- **Pick a bucket** in either panel from the bucket dropdown.
- **Drag and drop** files between panels — plain drop = move, hold **Ctrl** =
  copy.
- **Right-click** a file for preview / download / delete.
- **Action bar** between panels has bulk Copy / Move / Swap.
- **Sessions persist for 7 days** — you don't need to re-log in every time you
  restart Pail.
- **Logout** is the bottom icon in the left sidebar.

---

## Updating

When new dependencies are added, `start.bat` detects the change to
`requirements.txt` and reinstalls automatically on next launch. If something
breaks, the safe reset is:

```powershell
Remove-Item -Recurse -Force venv
.\start.bat
```

---

## Troubleshooting

- **"Python is not on PATH"** — re-run the Python installer and tick the PATH
  box, or restart your terminal after installing.
- **Login succeeds but no buckets show up** — your profile probably doesn't
  have `s3:ListAllMyBuckets`. Check with `aws s3 ls --profile <name>`.
- **SSO login keeps prompting** — the SSO refresh token has expired; run
  `aws sso login --profile <name>` again.
- **Cookie / re-auth loop** — delete `.flask_secret` and restart; a new key
  will be generated and you'll log in once.
