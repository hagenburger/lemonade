Lemonade is deprecated
======================

Lemonade was a [cool way to create sprites](http://www.hagenburger.net/BLOG/Lemonade-CSS-Sprites-for-Sass-Compass.html).
Now I [merged Lemonade into Compass](http://chriseppstein.github.com/blog/2010/09/11/compass-merging-with-lemonade/) in [v0.11](https://github.com/chriseppstein/compass/tree/v0.11.0) and redefined the API with [Chris Eppstein](https://twitter.com/chriseppstein). Even better, [Scott Davis](https://twitter.com/jetviper21) made some enhancements.

So thanks for all the buzz for Lemonade and take a look at our Compass
Sprites implementation:

<http://compass-style.org/help/tutorials/spriting/>

Follow @[hagenburger](http://twitter.com/hagenburger) for updates.

Cheers,

Nico)


Still need to use Lemonade?
---------------------------

Try to use an older implementation of ChunkyPNG if you get empty PNGs:

    # Gemfile
    gem 'lemonade'
    gem 'chunky_png', '0.11.1'

You can find the old Lemonade code in the [master branch](https://github.com/hagenburger/lemonade/tree/master)
