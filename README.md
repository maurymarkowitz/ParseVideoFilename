# ParseVideoFilename

Copyright (c) 2023 Maury Markowitz

## Introduction

ParseVideoFilename parses the filenames of video files to extract the name of the movie or the name of a TV show along with its season and episode numbers and other information. It can parse a wide variety of formats commonly found in video files. It returns values which can then be strung together to perform queries against tools like [TheTVDB](https://thetvdb.com) or Apple's iTunes metadata service.

The system works by applying a series of regex patterns until one, if any, returns valid data. New patterns can be added to the list in the appropriate location, typically at the end. The patterns understand various whitespace replacements, items in brackets, and other noise. They allow common short forms to be used interchangably, for instance, "d" "dvd", "disk" and "disc" are all recognized as being part of files from a DVD collection. The code also translates roman numerals and english number words to numeric values, so filenames containing things like "Season XI, Episode Four" will produce S11E04.

As filenames are often incomplete, missing season numbers for instance, the system allows default values to be passed in for the series name, season and episode numbers, and year of a movie. These override anything found in the patterns. This is particularily useful when working with iTunes, which strips the show name and season number from the name when files are added to the iTunes library and Organize is turned on (which it normally is).

## Author

This package was developed by Maury Markowitz, [maury.markowitz@gmail.com](mailto:maury.markowitz@gmail.com).

## Credits

ParseVideoFilename is based on VideoFilename by Behan Webster, a perl script. The majority of the regex patterns are taken unchanged from VideoFilename, but a number of updates have been made to address modern video formats like x265. At the time of writing this document in 2023, VideoFilename is [hosted at metacpan](https://metacpan.org/dist/Video-Filename/source/lib/Video/Filename.pm).

## Contributing

Pull requests are welcome. Feel free to create pull requests for any kind of improvements, bug fixes or enhancements.

## License

This software was published under the [MIT license](https://choosealicense.com/licenses/mit/).

## Usage

See the USAGE document for detailed notes.

