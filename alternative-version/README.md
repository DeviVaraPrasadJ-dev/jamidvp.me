# Alternative DevOps Portfolio Version (Port 8080 Design)

This directory contains the alternative design and layout for the DevOps Portfolio website (originally hosted on `http://localhost:8080`).

---

## 📁 Files Included
* **`index.html`**: Alternative layout featuring streamlined hero, compact metrics, and clean card styling.
* **`style.css`**: Design system stylesheet for the alternative version.
* **`app.js`**: JavaScript interactions and terminal behaviors.

---

## 🚀 How to Preview Locally
You can preview this alternative version anytime using Python's built-in HTTP server:
```bash
python3 -m http.server 8080
```
Then visit: `http://localhost:8080`

---

## 🔄 How to Switch to this Design as the Main Version
If you ever decide you prefer this alternative design as your live website on `https://jamidvp.me`:
1. Copy the files to the root directory:
   ```bash
   cp alternative-version/index.html alternative-version/style.css alternative-version/app.js .
   ```
2. Run `./deploy.sh` to update S3 and CloudFront.
3. Commit and push: `git add . && git commit -m "Switch to alternative portfolio design" && git push`
