# VELOCITY — GitHub Deployment & Global Release Runbook

This guide details the exact steps to publish **VELOCITY** to a public GitHub repository, enable automated CI/CD builds, and deploy the high-ranking Google SEO landing page.

---

## 1. Remote Repository Connection

If you have already created a public repository on GitHub (e.g. `https://github.com/<your-username>/velocity-torrent`):

```bash
# Add your GitHub remote
git remote add origin https://github.com/<your-username>/velocity-torrent.git

# Push main branch with release tag
git branch -M main
git push -u origin main --tags
```

*(If using an SSH key: `git remote add origin git@github.com:<your-username>/velocity-torrent.git`)*

---

## 2. Automated GitHub Actions CI/CD Pipeline

The repository includes pre-configured workflow configurations under `.github/workflows/`:
1. `ci.yml`: Runs on every push and pull request. Validates formatting, C++20 unit tests, and Python test harnesses.
2. `release.yml`: Runs automatically when a tag matching `v*` (like `v1.0.0-rc1`) is pushed. Generates the release package, attaches `SBOM.json`, and creates the GitHub Release with automated changelogs.
3. `deploy-cloudflare.yml`: Automatically deploys the `web/` web client and SEO landing page to Cloudflare Pages upon push to `main` (requires Cloudflare credentials).

---

## 3. Cloudflare Pages Deployment for Web Application & SEO Showcase

VELOCITY deploys its web client and SEO landing page directly to **Cloudflare Pages** for sub-20ms global edge delivery and zero host sandboxing.

### Method A: Automated GitHub Actions Deployment (Recommended)
1. In Cloudflare Dashboard: Go to **My Profile** > **API Tokens** > **Create Token** > Use template **"Edit Cloudflare Workers"** (or custom token with `Account:Cloudflare Pages:Edit` permissions).
2. Note your **Account ID** from the right sidebar of the Cloudflare Dashboard overview page.
3. In your GitHub repository: Go to **Settings** > **Secrets and variables** > **Actions** > **New repository secret**:
   - `CLOUDFLARE_API_TOKEN`: Your Cloudflare API token.
   - `CLOUDFLARE_ACCOUNT_ID`: Your Cloudflare Account ID.
4. On every push affecting `web/`, the `.github/workflows/deploy-cloudflare.yml` workflow deploys your site directly to `https://velocity-torrent.pages.dev`.

### Method B: Native Cloudflare Dashboard Git Integration
1. Log in to [Cloudflare Dashboard](https://dash.cloudflare.com/) > **Workers & Pages** > **Create application** > **Pages** > **Connect to Git**.
2. Select your `devrajshelakeacer/Velocity-Torrent` repository.
3. Configure build settings:
   - **Framework preset**: `None`
   - **Build command**: *(Leave empty)*
   - **Build output directory**: `web`
4. Click **Save and Deploy**.

---

## 4. Google Search Console & SEO Verification

To index the repository at the top of Google search results for *"intelligent torrent client"*, *"200 Mbps torrent downloader"*, and *"safe Windows torrent app"*:
1. Open [Google Search Console](https://search.google.com/search-console).
2. Add your Cloudflare Pages URL (e.g. `https://velocity-torrent.pages.dev` or custom domain) as a property.
3. Verify ownership via the HTML meta tag method (already templated in `web/landing.html`).
4. Submit your URL for indexing. Google will crawl the `SoftwareApplication` rich-snippet and display review ratings, license, and download links in search results.
