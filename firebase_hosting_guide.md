# Firebase Hosting — Flutter Web Reference Guide

## One-Time Setup

### Prerequisites

```bash
# Install Firebase CLI if not already installed
npm install -g firebase-tools

# Enable Flutter web support
flutter config --enable-web

# Log into Firebase
firebase login
```

### Initialize Hosting

Run from your Flutter project root:

```bash
firebase init hosting
```

Answer the prompts as follows:

- **Public directory** → `build/web`
- **Single-page app (rewrite all URLs to index.html)?** → `Yes`
- **Set up automatic builds with GitHub?** → `No`
- **File build/web/index.html already exists. Overwrite?** → `No`

### Verify firebase.json

Your `firebase.json` should look like this:

```json
{
  "hosting": {
    "public": "build/web",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ]
  }
}
```

The `rewrites` rule is critical for go_router — without it, deep links return a 404.

---

## Deploying

### Every Deploy (Two Commands)

```bash
flutter build web --release
firebase deploy --only hosting
```

After deploying, Firebase prints your live URL:

``` text
Hosting URL: https://your-project-id.web.app
```

### Deploy Only Hosting (Not Functions)

```bash
firebase deploy --only hosting
```

### Deploy Only Functions (Not Hosting)

```bash
firebase deploy --only functions
```

### Deploy Everything

```bash
firebase deploy
```

---

## Disabling / Taking Down

### Option 1 — Disable Hosting Temporarily

In the Firebase Console:

- Go to **Hosting** → Select your site → **⋮ Menu** → **Disable**

This takes the site offline immediately. Re-enable from the same menu.

### Option 2 — Roll Back to a Previous Deploy

```bash
# List previous deploys
firebase hosting:releases:list

# Roll back to a specific release
firebase hosting:rollback
```

### Option 3 — Deploy a Blank Site (Instant Takedown)

Create an empty `index.html` and deploy it:

```bash
echo "<html><body>Site unavailable</body></html>" > build/web/index.html
firebase deploy --only hosting
```

### Option 4 — Delete the Hosting Site Entirely

In the Firebase Console:

- Go to **Hosting** → Select your site → **⋮ Menu** → **Delete site**

This is permanent and cannot be undone.

---

## Emergency — Lock Down Everything Fast

If you need to shut down the entire backend immediately:

### Block all Firestore access (deploy in under 1 minute)

```bash
# Create a deny-all rules file and deploy
echo 'rules_version = "2"; service cloud.firestore { match /databases/{database}/documents { match /{document=**} { allow read, write: if false; } } }' > firestore.rules
firebase deploy --only firestore:rules
```

### Disable Firebase Auth sign-ins

Firebase Console → **Authentication** → **Settings** → **User actions** → Disable sign-in.

### Delete a specific Cloud Function

```bash
firebase functions:delete functionName
```

---

## Folder Structure

``` markdown
xp_todo_app/                    ← root
  xp_todo_app/                  ← Flutter project
    firebase.json               ← hosting config (points to build/web)
    .firebaserc                 ← project ID
    build/
      web/                      ← flutter build web output
  firebase_project/             ← Firebase backend
    functions/
    firestore.rules
    firebase.json               ← functions/rules config
```

Keep Flutter hosting config and Firebase backend config in separate folders so deploys never interfere with each other.
