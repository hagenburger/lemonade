Lemonade—On the fly sprite generator for Sass/Compass
=====================================================

Usage (SCSS or Sass):

    .fanta {
      background: sprite-image("bottles/fanta.png");
    }
    .seven-up {
      background: sprite-image("bottles/seven-up.png");
    }
    .coke {
      background: sprite-image("cans/coke.png") no-repeat;
    }

Output (CSS):

    .fanta {
      background: url('/images/bottles.png');
    }
    .seven-up {
      background: url('/images/bottles.png') 0 -50px;
    }
    .coke {
      background: url('/images/cans.png') no-repeat;
    }


Background
----------

* Generates a sprite image for each folder (e. g. “bottles” and “cans”)
* Sets the background position (unless “0 0”)
* It uses the `images_dir` defined by Compass (just like `image-url()`)
* No Rake task needed
* No additional classes
* No configuration


Installation
------------

    gem install haml
    gem install compass
    gem install rmagick
    gem install lemonade


Options
-------

You can pass an additional background position.
It will be added to the calculated position:

    .seven-up {
      background: sprite-image("bottles/seven-up.png", 12px, 3px);
    }

Output (assuming the calculated position would be “0 -50px” as shown above):

    .seven-up {
      background: url('/images/bottles.png') 12px -47px;
    }


Note on Patches/Pull Requests
-----------------------------

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

Copyright
---------

Copyright (c) 2010 [Nico Hagenburger](http://www.hagenburger.net).
See MIT-LICENSE for details.
[Follow me](http://twitter.com/hagenburger) on twitter.
