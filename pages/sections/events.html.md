---
title: Javascript events
order: 4
---

A lot of our efforts were put to the Editor UI in order to get the smoothest editing experience for our users. 

For instance, when you add a new block in a section from the Editor UI, behind the scene, we make a quick call to our rendering API and replace the current HTML of the section by the new version.
For most of the sections, this works really well. 

Unfortunately, this mechanism might break some Javascript plugins like a carousel or any section which requires Javascript. 

To solve this issue, the Editor UI fires a javascript event as soon as the user updates any piece of a content of a section. 

This is the responsibility of the developer to answer those events accordingly. Basically, the developer will have to remove all the listeners bound to a DOM element before the section gets refreshed and re-create them once the new version of the section is displayed.

Fortunately for our developer friends, when you generate a new Wagon site, we add helper files that will guide them to manage the section javascript lifecycle.

## Section manager

Generating a new Wagon site will create the `app/assets/javascripts/sections`  folder including the `SectionsManager` javascript class. Each section has to register itself to the manager in the \``app/assets/javascripts/app.js` file.

{% hint style="info" %}
**How to use the SectionsManager for older sites?**

Just type  `bundle exec wagon generate webpack` at the root of your Wagon site.
{% endhint %}


Actually, most of the time, you won't have to deal with all of this since the Wagon generator section will complete this file for you

All you have to do is to uncomment the methods that your section will need and fill it accordingly. 

{% code title="app/assets/javascripts/sections/my_section.js" %}
```javascript
const Section = {

  // load: (section) => {
  // },

  // unload: (section) => {
  // },

  // select: (section) => {
  // },

  // deselect: (section) => {
  // },

  // reorder: (section) => {
  // },

  // blockSelect: (section, block) => {
  // },

  // blockDeselect: (section, block) => {
  // }

}

export default Section;
```
{% endcode %}

For instance, if your carousel is based on an external Javascript lib, you'll have to initialize it in the `load` method. 

Now, let's say your section is available as a dropzone section, then you'll have to handle the case where your section is removed from the DOM (see the `unload` method).

Finally, if you want to edit a specific item of your carousel, it will be nice to see this item in the preview. To achieve it, fill the `select` method.

Take a look at the next chapter for a description of all the events.\ <br/>

<hr/>

## Section events

### List

| Event name | Context | Data |
| :--- | :--- | :--- |
| locomotive::section::load | A new section has been added to the DOM | sectionId |
| locomotive::section::unload | An existing section is going to remove from the DOM | sectionId |
| locomotive::section::select | The user is viewing the section | sectionId |
| locomotive::section::deselect | The user is done viewing the section | sectionId |
| locomotive::section::reorder | The section has been re-ordered | sectionId |


### Example

```javascript
// ES6 syntax

document.addEventListener('locomotive::section::select', event => {
  const { sectionId } = event.detail;
  const $section  = $(`[data-locomotive-section-id="${sectionId}"]`);

  console.log('the user is viewing: ', $section);
});
```

<hr/>

## Block events

### List

| Event name | Context | Data |
| :--- | :--- | :--- |
| locomotive::block::select | The user is viewing a block | sectionId, blockId |
| locomotive::block::deselect | The user is done viewing the block | sectionId, blockId |


### Example

```javascript
// ES6 syntax

document.addEventListener('locomotive::block::select', event => {
  const { sectionId, blockId } = event.detail;
  const $section  = $(`[data-locomotive-section-id="${sectionId}"]`);
  const $block    = $(`[data-locomotive-block="section-${sectionId}-block-${blockId}"]`, $section);

  console.log('the user has updated: ', $block);
});
```
