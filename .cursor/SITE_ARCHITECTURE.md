# Documentation Site Architecture Guide

This document explains how the documentation site works, its structure, and how to add new content. Use this as a reference when migrating documentation from Readme.com or other platforms.

## Overview

This is a **Sitepress**-based documentation site that uses:

- **Sitepress** for static site generation (Ruby-based, similar to Jekyll)
- **Rails conventions** for structure (ViewComponents, helpers, layouts)
- **Markdown** for content with YAML frontmatter
- **Liquid tags** for custom syntax (inherited from Gitbook)
- **Tailwind CSS** for styling
- **Stimulus** for JavaScript interactions
- **ViewComponents** for reusable UI components

## Project Structure

```
doc-site/
├── pages/                    # Documentation content (markdown files)
│   ├── index.html.md         # Homepage
├── components/               # ViewComponents (Rails-style)
│   └── app_layout/          # Layout components (sidebar, topbar, etc.)
├── assets/                   # Static assets
│   ├── images/              # Images and screenshots
│   ├── stylesheets/         # CSS (Tailwind + custom)
│   └── javascripts/         # JavaScript (Stimulus controllers)
├── layouts/                  # HTML layout templates
├── helpers/                  # Ruby view helpers
├── liquid/                   # Custom Liquid tags
│   └── tags/                # Tag implementations
├── config/                   # Configuration files
│   ├── site.rb              # Sitepress configuration
│   └── settings.yml         # Site settings
├── lib/                      # Custom Ruby libraries
│   ├── site_page.rb         # Page navigation logic
│   └── sitemap.rb           # Sitemap generation
└── scripts/                  # Automation scripts
```

## How Pages Work

### Page File Structure

Pages are stored in the `pages/` directory and can be:

- **Markdown files** (`.html.md`) - Most common, supports frontmatter
- **ERB files** (`.html.erb`) - For index pages or complex layouts

### Page Frontmatter

Every page should start with YAML frontmatter:

```yaml
---
title: Page Title
order: 5
sidebar: true # Optional: set to false to hide from sidebar
---
```

**Frontmatter fields:**

- `title` (required): Page title displayed in navigation and page header
- `order` (optional): Numeric order for sidebar sorting (default: infinity, appears last)
- `sidebar` (optional): Set to `false` to hide from sidebar navigation

### Page Content

After the frontmatter, write your content in Markdown:

```markdown
---
title: My Page
order: 1
---

# My Page Title

This is regular markdown content.

## Section

You can use:

- Regular markdown syntax
- Custom Liquid tags (see below)
- Code blocks with syntax highlighting
```

### Page URLs

Page URLs are determined by the file path:

- `pages/guides/setup-authentication.html.md` → `/guides/setup-authentication`
- `pages/index.html.md` → `/`
- `pages/concepts/block.html.md` → `/concepts/block`

## Adding New Pages

### Step 1: Create the Markdown File

Create a new `.html.md` file in the appropriate directory:

```bash
# Example: Adding a new guide
touch pages/guides/my-new-guide.html.md
```

### Step 2: Add Frontmatter

Add YAML frontmatter at the top:

```yaml
---
title: My New Guide
order: 10
---
```

### Step 3: Write Content

Write your content in Markdown below the frontmatter:

```markdown
---
title: My New Guide
order: 10
---

# My New Guide

Your content here...
```

### Step 4: Organize in Directories

Organize pages by topic:

- **`guides/`** - How-to guides and tutorials
- **`concepts/`** - Conceptual explanations
- **`pro/`** - Pro/advanced features
- **`integrations/`** - Third-party integrations
- **`quickstart/`** - Getting started guides

### Step 5: Set Order

Use the `order` field to control sidebar navigation order:

- Lower numbers appear first
- Pages without `order` appear last
- Use increments of 5 or 10 to leave room for reordering

## Custom Liquid Tags

The site supports custom Liquid tags inherited from Gitbook:

### Code Blocks with Titles

````liquid
{% code title="config/initializers/maglev.rb" %}
```ruby
Maglev.configure do |c|
  # config here
end
````

{% endcode %}

````

### Hints/Callouts

```liquid
{% hint style="info" %}
This is an informational hint.
{% endhint %}

{% hint style="warning" %}
This is a warning.
{% endhint %}

{% hint style="tip" %}
This is a tip.
{% endhint %}
````

### Code Tabs

````liquid
{% tabs %}
{% tab title="Ruby" %}
```ruby
# Ruby code
````

{% endtab %}
{% tab title="JavaScript" %}

```javascript
// JavaScript code
```

{% endtab %}
{% endtabs %}

````

### Descriptions

```liquid
{% description %}
This is a description block.
{% enddescription %}
````

## Layout and Components

### Main Layout

The site uses `layouts/layout.html.erb` as the base layout, which:

- Sets up HTML structure
- Includes CSS and JavaScript
- Renders the `AppLayoutComponent` (sidebar, topbar, navigation)
- Handles theme switching (light/dark mode)

### AppLayoutComponent

The main layout component (`components/app_layout_component.rb`) provides:

- **Sidebar navigation** - Auto-generated from page structure
- **Topbar** - Header with links and search
- **Page navigation** - Previous/next page links
- **Footer** - Page footer with metadata

### Navigation Structure

Navigation is automatically generated from the `pages/` directory structure:

- Pages are organized hierarchically based on directory structure
- The `order` frontmatter field controls sorting
- Pages with `sidebar: false` are hidden from navigation
- The `SitePage` class (`lib/site_page.rb`) builds the navigation tree

## Configuration

### Site Settings

Edit `config/settings.yml` for global settings:

```yaml
site:
  title: "Documentation Site"
  github_repo: "org/repo"

appearance:
  theme: "light"

features:
  analytics_enabled: true
  search_enabled: true

seo:
  meta_description: "Site description"
  meta_keywords: "keywords, here"
```

### Sitepress Configuration

Edit `config/site.rb` for Sitepress-specific settings (usually minimal).

## Development Workflow

### Starting the Development Server

```bash
# Install dependencies
bundle install
yarn install

# Start development server (runs Sitepress + asset watchers)
foreman start -f Procfile.dev
```

The server runs on `http://127.0.0.1:8080`

### Development Process

1. **Edit pages** - Modify `.html.md` files in `pages/`
2. **Add images** - Place in `assets/images/` and reference with markdown: `![alt](path/to/image.png)`
3. **Update components** - Edit ViewComponents in `components/`
4. **Modify styles** - Edit `assets/stylesheets/site.source.css` (Tailwind)
5. **Add JavaScript** - Edit `assets/javascripts/site.source.js` or add Stimulus controllers

### Asset Pipeline

- **CSS**: `site.source.css` → compiled to `site.css` (Tailwind processes it)
- **JavaScript**: `site.source.js` → bundled to `site.js` (esbuild)
- Assets are watched during development and auto-compiled

## Building for Production

### Compile the Site

```bash
bundle exec rake compile
```

This:

1. Compiles CSS (Tailwind)
2. Bundles JavaScript (esbuild)
3. Generates search index
4. Compiles Sitepress site to `./build/`
5. Generates sitemap
6. Generates LLM markdown (for AI/LLM consumption)

### Build Output

The `./build/` directory contains the static site ready for deployment:

- HTML files
- Compiled assets (CSS, JS, images)
- Search index JSON
- Sitemap XML

## Deployment

### Deployment Process

The site is deployed to AWS S3 with CDN (BunnyCDN):

```bash
# Full deployment (compile + publish + purge cache)
bundle exec rake

# Or step by step:
bundle exec rake compile      # Build the site
bundle exec rake publish      # Upload to S3
bundle exec rake purge_cache  # Purge CDN cache
```

### CI/CD

GitHub Actions (`.github/workflows/publish.yml`) automatically:

- Builds on push to `main`
- Deploys to S3
- Purges CDN cache

### Environment Variables

Required for deployment:

- `AWS_S3_BUCKET_NAME` - S3 bucket name
- `AWS_ACCESS_KEY_ID` - AWS access key
- `AWS_SECRET_ACCESS_KEY` - AWS secret key
- `AWS_REGION` - AWS region
- `BUNNYCDN_ACCESS_KEY` - CDN access key
- `BUNNYCDN_ZONE_ID` - CDN zone ID
- `SITE_BASE_URL` - Base URL for sitemap

## Styling Guidelines

### Tailwind CSS

The site uses Tailwind CSS for styling:

- Edit `assets/stylesheets/site.source.css` for custom styles
- Use Tailwind utility classes in components
- Prefer Tailwind classes over custom CSS

### Components

ViewComponents use Tailwind classes for consistent styling:

- All components are in `components/`
- Components follow Rails ViewComponent conventions
- Use Tailwind utility classes, not custom CSS classes

## JavaScript Guidelines

### Stimulus Controllers

Use Stimulus controllers for JavaScript interactions:

- Controllers in `assets/javascripts/controllers/`
- Follow Stimulus conventions
- Register in `site.source.js`

### Example Stimulus Controller

```javascript
// assets/javascripts/controllers/example_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    // Controller logic
  }
}
```

## Search Functionality

Search is implemented via:

- **Search index**: Generated by `scripts/generate_search_index.rb`
- **Search component**: `components/app_layout/search_component.rb`
- Index is built during compilation and stored as JSON

## Migration Tips

When migrating from Readme.com or other platforms:

1. **Export content** - Get markdown files from the source platform
2. **Create page structure** - Organize into `guides/`, `concepts/`, etc.
3. **Add frontmatter** - Add `title` and `order` to each page
4. **Convert syntax** - Replace platform-specific syntax with:
   - Standard markdown
   - Custom Liquid tags (for code blocks, hints, etc.)
5. **Update links** - Convert internal links to relative paths
6. **Add images** - Move images to `assets/images/` and update paths
7. **Test locally** - Use `foreman start -f Procfile.dev` to preview
8. **Build and deploy** - Use `rake compile` to test production build

## Common Tasks

### Adding a New Section/Category

1. Create a directory in `pages/` (e.g., `pages/api/`)
2. Create an `index.html.erb` or `index.html.md` for the section landing page
3. Add pages to the directory
4. Navigation will automatically include the new section

### Hiding a Page from Navigation

Add `sidebar: false` to frontmatter:

```yaml
---
title: Hidden Page
sidebar: false
---
```

### Adding Topbar Links

Edit `layouts/layout.html.erb`:

```erb
<%= render AppLayoutComponent.new(site: site, current_page: current_page) do |layout| %>
  <% layout.with_topbar_link label: 'Website', href: 'https://example.com' %>
  <% layout.with_topbar_link href: 'https://github.com/org/repo' do %>
    <i class="fa-brands fa-github"></i><span class="ml-2">Source Code</span>
  <% end %>
  <%= yield %>
<% end %>
```

### Customizing Theme

Edit `config/settings.yml`:

```yaml
appearance:
  theme: "light" # or "dark"
```

The site supports light/dark mode with automatic detection based on user preference.

## Troubleshooting

### Page Not Appearing in Navigation

- Check that `sidebar: false` is not set in frontmatter
- Verify the file has a valid `title` in frontmatter
- Check that the file is in the correct directory

### Styles Not Updating

- Ensure Tailwind is watching: `npx @tailwindcss/cli -i ./assets/stylesheets/site.source.css -o ./assets/stylesheets/site.css --watch`
- Check that you're using Tailwind classes, not custom CSS
- Clear browser cache

### Liquid Tags Not Working

- Verify the tag syntax matches the examples above
- Check that tags are properly closed
- Ensure you're using the correct tag names (case-sensitive)

### Build Errors

- Run `bundle install` and `yarn install` to ensure dependencies are up to date
- Check that all required environment variables are set
- Review error messages for specific issues

## Additional Resources

- **Sitepress Documentation**: https://sitepress.cc
- **Tailwind CSS**: https://tailwindcss.com
- **Stimulus**: https://stimulus.hotwired.dev
- **ViewComponent**: https://viewcomponent.org
