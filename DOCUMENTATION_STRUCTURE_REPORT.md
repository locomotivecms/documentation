# LocomotiveCMS Documentation Structure Report

Generated: $(date)

## Overview

This report maps the complete content structure of the LocomotiveCMS documentation site hosted on README.com (doc.locomotivecms.com).

## Versions Available

Based on version selector analysis, the following versions are available:
- **v4.0** (latest) - `/docs/version-40`
- **v3.4** - `/docs/version-34`
- **v3.3** - `/docs/version-33`
- **v3.2** - `/docs/version-32`
- **v3.1** - `/docs/version-31`

## Version 3.3 Documentation Structure

Based on extracted navigation links from `https://doc.locomotivecms.com/v3.3/docs`, the following pages exist:

### Quick Start & Getting Started
1. **Quick Start** - `/v3.3/docs/quick-start`
2. **Getting Started with Locomotive** - `/v3.3/docs/getting-started-with-locomotive`
3. **Heroku** - `/v3.3/docs/heroku`

### Pages & Templates
4. **Create a Page** - `/v3.3/docs/create-a-page`
5. **Page Inheritance** - `/v3.3/docs/page-inheritance`
6. **Layouts** - `/v3.3/docs/layouts`
7. **Snippets** - `/v3.3/docs/snippets`
8. **Assets** - `/v3.3/docs/assets`

### Content Types
9. **Define a Content Type** - `/v3.3/docs/define-a-content-type`
10. **Relate Two Content Types** - `/v3.3/docs/relate-two-content-types`
11. **Use Them in Templates** - `/v3.3/docs/use-them-in-templates`
12. **Filter and Paginate** - `/v3.3/docs/filter-and-paginate`

### Liquid Language
13. **Liquid Language** - `/v3.3/docs/liquid-language`
14. **Logic** - `/v3.3/docs/logic`
15. **Drops** - `/v3.3/docs/drops`
16. **Default Filters** - `/v3.3/docs/default-filters`
17. **Filters** - `/v3.3/docs/filters`
18. **Tags** - `/v3.3/docs/tags`

### Liquid Helpers
19. **Introduction** - `/v3.3/docs/introduction`
20. **Access Liquid Variables** - `/v3.3/docs/access-liquid-variables`
21. **Access Session Variables** - `/v3.3/docs/access-session-variables`
22. **Content Entries** - `/v3.3/docs/content-entries`
23. **Send Emails** - `/v3.3/docs/send-emails`
24. **External API** - `/v3.3/docs/external-api`
25. **Other Methods** - `/v3.3/docs/other-methods`

### Advanced Topics
26. **Introduction** (Advanced) - `/v3.3/docs/introduction-1`
27. **Setup** - `/v3.3/docs/setup`
28. **Actions** - `/v3.3/docs/actions`
29. **Liquid Helpers** - `/v3.3/docs/liquid-helpers`

### Wagon CLI
30. **Create a New Site** - `/v3.3/docs/create-a-new-site`
31. **Commands** - `/v3.3/docs/commands`
32. **Deploy** - `/v3.3/docs/deploy`
33. **Synchronize Content** - `/v3.3/docs/synchronize-content`
34. **Backup a Site** - `/v3.3/docs/backup-a-site`
35. **Delete Resources** - `/v3.3/docs/delete-resources`
36. **Preview Locally** - `/v3.3/docs/preview-locally`
37. **Domains** - `/v3.3/docs/domains`

### Features & Configuration
38. **Create a Contact Form** - `/v3.3/docs/create-a-contact-form`
39. **Localization** - `/v3.3/docs/localization`
40. **Site Metafields** - `/v3.3/docs/site-metafields`
41. **Protect a Site by a Password** - `/v3.3/docs/protect-a-site-by-a-password`
42. **Create a RSS Feed** - `/v3.3/docs/create-a-rss-feed`

### Installation & Upgrades
43. **Install Wagon Using Devstep and Docker** - `/v3.3/docs/install-wagon-using-devstep-and-docker`
44. **Upgrade to v3** - `/v3.3/docs/upgrade-to-v3`
45. **Custom Rendering** - `/v3.3/docs/custom-rendering`

### FAQ
46. **How Do I Change the Language of My User Interface** - `/v3.3/docs/how-do-i-change-the-language-of-my-user-interface`
47. **How Do I Change My Password** - `/v3.3/docs/how-do-i-change-my-password`

### Version History
48. **Version 3.3** - `/v3.3/docs/version-33`
49. **Version 3.2** - `/v3.3/docs/version-32`
50. **Version 3.1** - `/v3.3/docs/version-31`
51. **Changelog** - `/v3.3/docs/changelog`

**Total Pages in v3.3: 51 pages**

## Version 4.0 Documentation Structure

Based on content analysis from fetched pages, Version 4.0 includes:

### Sections (New Feature in v4.0)
- **Section Introduction** - `/docs/section-introduction`
- **How to Display Sections** - `/docs/how-to-display-sections`
- **Events** (JavaScript events for sections) - `/docs/events`

### Deployment
- **Deploy** - `/docs/deploy`

### Quick Start
- **Quick Start Guide** - `/docs` (main page)

**Note:** The sidebar navigation for v4.0 appears to be JavaScript-rendered and requires browser execution to extract fully. The structure above is based on accessible page content.

## Page Categories Analysis

Based on the fetched content, the documentation is organized into these main categories:

### 1. Getting Started
- Quick Start guides
- Installation instructions
- Platform setup (Heroku, etc.)

### 2. Core Concepts
- Pages and Templates
- Layouts
- Snippets
- Assets

### 3. Content Management
- Content Types
- Content Entries
- Relationships between content types

### 4. Templating (Liquid)
- Liquid Language basics
- Logic and control structures
- Filters
- Tags
- Drops

### 5. Sections (v4.0+)
- Section introduction
- Displaying sections
- Global sections
- Standalone sections
- Sections in dropzones
- JavaScript events

### 6. Wagon CLI
- Site creation
- Commands
- Deployment
- Content synchronization
- Backup and restore

### 7. Advanced Features
- Liquid Helpers
- API integration
- Email sending
- Forms
- Localization
- Metafields
- Security

## Known Issues

1. **JavaScript-Rendered Navigation**: The sidebar navigation on README.com is rendered client-side using JavaScript, making it difficult to extract via simple HTTP requests.

2. **404 Pages**: The following URLs returned 404 errors:
   - `/docs/content-types`
   - `/docs/templates`
   - `/docs/liquid-syntax`
   - `/docs/liquid-tags`

   These may have been moved or renamed in newer versions.

3. **Version Differences**: Version 4.0 introduces significant changes, particularly around Sections, which replace the older editable elements system.

## Recommendations

1. **Use Browser Automation**: To fully extract the navigation structure, consider using a headless browser like Puppeteer or Selenium to execute JavaScript and extract the rendered sidebar.

2. **API Access**: Check if README.com provides an API endpoint for documentation structure.

3. **Sitemap**: Look for XML sitemaps that might list all pages.

4. **Manual Review**: For complete accuracy, manually review each version's sidebar in a browser.

## Next Steps

To complete the mapping:
1. Use browser automation to extract JavaScript-rendered navigation
2. Visit each version's main docs page and extract sidebar structure
3. Verify all page URLs are accessible
4. Document the hierarchical structure (categories and sub-pages)
5. Map relationships between versions (what changed, what's new)
