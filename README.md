# LocomotiveCMS Documentation

This repository contains the documentation site for LocomotiveCMS.

## Project Structure

- **pages/**: Main documentation content, organized into:

- **components/**: View components for reusable UI elements.
  - `app_layout/`: Layout-related components (sidebar, topbar, navigation, etc.).
  - `app_layout_component.*`: Main layout component files.

- **assets/**: Static assets and frontend code.
  - `images/`: Logos, favicons, and documentation screenshots (with subfolder for page-specific images).
  - `stylesheets/`: CSS files, including Tailwind and code highlighting styles.
  - `javascripts/`: JavaScript files, including Stimulus controllers for interactive features.
  - `config/`: Asset pipeline configuration.

- **liquid/**: Custom Liquid tags and concerns for dynamic content rendering inherited from Gitbook
  - `tags/`: Custom tag implementations (e.g., code blocks, tabs, hints, descriptions).
  - `tags/concerns/`: Shared logic for tags.

- **layouts/**: HTML layout templates for the site.

- **helpers/**: Ruby helpers for view logic shared across pages and layouts.

- **config/**: Site configuration and initializers.

- **scripts/**: Ruby scripts for automation (e.g., generating markdown, search indexes, migrations).

- **spec/**: RSpec tests for custom tags and helpers.

## Getting Started

1. **Install dependencies:**
   - Ruby gems: `bundle install`
   - JavaScript packages: `yarn install`

```bash
gem install foreman
```

2. **Start the development server:**

   ```sh
   foreman start -f Procfile.dev
   ```

   Then open [http://127.0.0.1:8080](http://127.0.0.1:8080) to view the docs locally.

3. **Edit or add documentation:**
   - Add or update markdown files in `pages/`.
   - Add images to `assets/images/`.
   - Update or create components in `components/`.

4. **Compile for production:**
   ```sh
   bundle exec rake compile
   ```
   The static site will be built in the `./build` directory.

## Contributing

- Follow the established structure for new guides, concepts, or integrations.
- Use components for reusable UI.
- Use Stimulus controllers for JavaScript interactions.
- Prefer Tailwind CSS classes for styling.

## More Information

- For more on Sitepress, see [https://sitepress.cc](https://sitepress.cc)
- For LocomotiveCMS documentation, browse this site or contribute via pull requests.
