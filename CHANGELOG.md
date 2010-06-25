Changelog
=========


0.3.0
-----

* Switched from RMagick to chunky_png gem
  * No RMagick/ImageMagick required anymore (Rails 2.3.x sometimes crashed)
  * Only PNG files are supported (both input and output)
* Don’t compose the same image twice (use background-position of first image instead)
* Space between images now works as expected if more than 1 output image (path) is used
* Wrote this changelog


0.2.0
-----

* Support for background-positions
* Support for 100%/right aligned images


0.1.0
-----

* Initial release