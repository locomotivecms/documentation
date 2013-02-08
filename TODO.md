## To do site

- add multi site, upgrade to 2.0 in guides
- main nav active when in sub child
  -> idem sub nav
    => JS ? plus simple
- editor : configure git + gitignore (deploy, ds store etc)

## To write documentation

- foreword / Why should you use LocomotiveCMS ?
- foreword / organisation
- overview / anatomy / key features
- templating / liquid syntax / filters
- templating / liquid syntax / tags
- Locomotive editor
- Writing custom Liquid tags
- Models > rendering
- Models > public submission (nb csrf) + file submission https://groups.google.com/forum/?fromgroups=#!topic/locomotivecms/qhLaBGF8LZs
- verifier dans quels cas content_types ne marche pas, et modifier la doc officielle en consequence
- specify cdn : https://groups.google.com/forum/?fromgroups#!topic/locomotivecms/9GjjtnD80gU
- Reference >> ajouter created_at et updated_at
- to do : editable control etc editables things
- with scope ne marche pas >>> https://groups.google.com/forum/?fromgroups=#!topic/locomotivecms/vAq0IIij4Ag
- menu custom : https://github.com/locomotivecms/documentation/blob/master/app/views/pages/index.liquid.haml#L39
- Using Locomotive in an existing rails app
- Tips > Using multi-sites

- reference :  
  - filters:
    - strip_html

## Questions

- quick links footer : on les gardes ? ils redirigeront sur le site principal

## Ideas

- page pour proposer les articles externes.

- pour chaque item du guide, on pourrait avoir un "aller plus loin" ou "expert" ?
- page how to contribute
- page ce qu'il y a a documenter
- page submit question / idea for the doc site

## NB How To Contribute

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