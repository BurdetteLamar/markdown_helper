### Image Attributes

Use the markdown helper to assign attributes to images.

If you're using the markdown helper to [resolve image file paths for a Ruby gem](./rubygem_images.md), you'll be using the GitHub markdown image-description idiom (begins with exclamation point), and not the HTML <code>img</code> idiom.

The image description does not accept attributes (such as height and width), but the markdown helper does accept those, passing them through to an <code>img</code> HTML element.
s