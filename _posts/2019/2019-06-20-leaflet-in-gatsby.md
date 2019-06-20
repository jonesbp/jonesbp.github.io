---
layout: post
title: "Building a Gatsby Site with Leaflet Maps"
excerpt: "How to work around Webpack build errors with Leaflet maps in Gatsby"
type: tech_note
date: 2019-06-20T08:31:00+02:00
---
Recently I was working on a custom touring map for [an article on _Local Memory_][gardner]. The site is built with [Gatsby][gatsby], and I use [Leaflet][leaflet] for mapping. I use [React-Leaflet][react-leaflet] for some convenience with treating the Leaflet maps as React components.

The problem comes when running `gatsby build`. In the Node.js environment, there is no `window` object, and Webpack fails to build the first page it encounters where a React-Leaflet `Map` component is rendered.

The fix is to make a check against the `window` object in the page’s `render()` function before using a `Map` component:

{% raw %}
```javascript
render() {
  if (typeof window !== 'undefined') {
    return (
      <div ref={this.mapWrapperRef} className="map-wrapper">
         <Map ref={this.mapRef}
            style={{height: '540px'}}
          >
          <TileLayer
            url="https://tiles.wmflabs.org/bw-mapnik/{z}/{x}/{y}.png"
            attribution='&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
          />
        </Map>
      </div>
    );
  }
  
  return null;
}
```
{% endraw %}

This was enough to avoid the Webpack error, but the problem was that the map would intermittently fail to display in the built version.

The problem was returning `null` from the `render()` function which meant that there was not an element in the DOM to mount the map on when it was ready. Outputting an empty wrapper `<div>` rather than nothing at all from the `render()` function when not in a browser environment satisfies both conditions.

{% raw %}
```javascript
render() {
  return (
    <div ref={this.mapWrapperRef} className="map-wrapper">
      {(typeof window !== 'undefined') ? (
         <Map ref={this.mapRef}
            style={{height: '540px'}}
          >
          <TileLayer
            url="https://tiles.wmflabs.org/bw-mapnik/{z}/{x}/{y}.png"
            attribution='&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
          />
        </Map>
      ) : null}
    </div>
  );
}
```
{% endraw %}

---

A related Webpack related build error can be fixed with the following in your `gatsby-node.js` so that the build doesn’t fail on pages that import `react-leaflet` because of the absence of a browser environment:

{% raw %}
```javascript
exports.onCreateWebpackConfig = ({ stage, rules, loaders, actions }) => {
  switch (stage) {
    case 'build-html':
      actions.setWebpackConfig({
        module: {
          rules: [
            {
              test: /react-leaflet/,
              use: [loaders.null()]
            }
          ]
        }
      });
      break;
  }
};
```
{% endraw %}

[gatsby]: https://gatsbyjs.org
[leaflet]: https://leafletjs.com
[gardner]: https://local-memory.org/athens-on-the-colorado/narratives/territory-bands
[react-leaflet]: https://react-leaflet.js.org