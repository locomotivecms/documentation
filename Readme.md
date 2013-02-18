## Locomotive Documentation Site

We woud appreciate any contribution to this guide.

## How to contribute ?

Just fork the repository and send us a pull request!

## Conventions

- alerts :
  - plain html inside, no haml parsed
  - "blue style" alert is a div with class .alert .alert-info
  - "orange style" alert is a div with class .alert. .alert-warning
- code :
  - raw tag before each liquid sentence
  - inline : ```{% raw %} {% block %} {% endraw %}```
  - indent code with two tabs
- tables : raw html
- Markdown:
  - the first md line must be right after :markdown, no empty line or error
- images :
  - stored in samples/guides/ ...
  - <img src="{{ '/samples/guides/templating/FILE.png' }}">
