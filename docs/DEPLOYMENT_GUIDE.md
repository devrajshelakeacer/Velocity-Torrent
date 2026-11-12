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

---

## 3. GitHub Pages Deployment for Google Search Ranking

To publish the SEO-optimized web landing page and web application with Schema.org JSON-LD structured data:

1. Open your repository on GitHub.
2. Go to **Settings** > **Pages** (under Code and automation).
3. Under **Build and deployment**:
   - **Source**: `GitHub Actions`
4. The `.github/workflows/deploy-pages.yml` workflow will automatically build and publish the contents of the `web/` directory.
5. Your application and landing page will be published at:  
   `https://<your-username>.github.io/velocity-torrent/`

---

## 4. Google Search Console & SEO Verification

To index the repository at the top of Google search results for *"intelligent torrent client"*, *"200 Mbps torrent downloader"*, and *"safe Windows torrent app"*:
1. Open [Google Search Console](https://search.google.com/search-console).
2. Add your GitHub Pages URL (or custom domain) as a property.
3. Verify ownership via the HTML meta tag method (already templated in `web/landing.html`).
4. Submit your URL for indexing. Google will crawl the `SoftwareApplication` rich-snippet and display review ratings, license, and download links in search results.
