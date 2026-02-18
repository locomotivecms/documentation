---
title: Introduction
order: 1
---

Before version 4.0, the only way to mark parts of a page editable for the end users was to use the `editable_text` or `editable_image` liquid tags. Although it was very easy to use for developers, these tags were pretty limited. For instance, it was quite difficult to implement repeatable regions (think about a gallery of images or a carousel) unless using content types which made the editor experience not great.

{% hint style="warning" %}
**You can't combine editable elements and sections inside a site.**

If your site doesn't declare any section, you'll still have access to the editable elements content editor in the back-office.
{% endhint %}


This issue is now solved thanks to what we call `sections`. It even becomes a core concept in LocomotiveCMS. The main idea is to slice as much as possible a page into different "sections".
Sections can be totally re-used (or not) in different pages. We also provide a way to group them and let the user re-order, delete sections or add new one.
The system is really flexible.

What we want to focus on is encouraging web agencies and freelancers to build their own library of sections that they will enhance site after site. We're strongly convinced that this will help them launch websites faster with a higher quality. 

One big thing that we haven't mentioned yet. Regarding sections, the editing experience for editors is truly awesome. Here is a small animation that speaks for itself 

<div class="wistia-embed">
<script src="https://fast.wistia.com/embed/medias/7tw7y2z769.jsonp" async></script>
<script src="https://fast.wistia.com/assets/external/E-v1.js" async></script>
<div class="wistia_responsive_padding" style="padding:56.25% 0 0 0;position:relative;">
<div class="wistia_responsive_wrapper" style="height:100%;left:0;position:absolute;top:0;width:100%;">
<div class="wistia_embed wistia_async_7tw7y2z769 videoFoam=true" style="height:100%;position:relative;width:100%"></div>
</div>
</div>
</div>


## What exactly is a section?

Like snippets, a sections is a piece of HTML/Liquid code. The similarities end here. Compared to a snippet, a section comes with a JSON definition at the top of the file, describing the structure of the content.
This definition will be also used to generate the user interface in the LocomotiveCMS back-office.

A section definition is composed of:

* **settings** (see them as properties) 
* **block types**. Each block type has its own settings. Very useful to create a carousel for instance. 
* **display options**. To control the display of the section in the back-office

## How to use a section in page?

We offer three ways to include a section in a page:

* as a global section. Its content will be shared across all pages. Used for the top header of your site for instance or the footer.
* as a stand-alone section. In that case, the section can only update the content of the section but not delete it. Imagine a hero section present at the top of each sub page of your site.
* in a **dropzone** area. Sections within a dropzone can be added (from your catalogue of sections), removed, re-ordered and updated. Your editor has total control over the sections. This is extremely powerful.
