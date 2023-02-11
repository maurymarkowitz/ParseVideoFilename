# ParseVideoFilename usage notes

Copyright (c) 2023 Maury Markowitz

## Inputs and outputs

ParseVideoFilename has a single class method, `parse`. It takes a single required parameter, a string containing the `filename` to be parsed. `parse` returns a dictionary of string keywords and values, all of which are optional. An empty dictionary is returned if the system cannot parse the filename at all, but in most common cases it will include at least the path, extension, and 'bare' file name.

As the original data is often missing values, you should always check the resulting data for each item being present. For instance, iTunes trims the name of files copied into its library, so parsing the filename from an iTunes collection will result in an episode number being returned, but not the season or the name of the show. You should always check that the key is present for all of the values you intend to use.

For files that you know will be missing certain values, like the iTunes example, the optional `defaults` dictionary can be used. After attempting the various matches, if any data was found successfully, values in `defaults` will be copied into the results *if that key does not already exist*. For instance, in the case of iTunes the show name is part of the file path, so one can add a "name" key to `defaults`, pass that into `parse`, and then if the show name is not found during parsing, the name value will be copied in from `defaults`.

The keywords include:

filename
:The filename extracted from the complete path, with the extension removed.

extension
:The filename extension alone.

didParse
:Present if the parser was able to match a pattern on the filename. The value is meaningless. If this value is missing, the rest of the items below are invalid and/or missing.

isMovie
:Present if the parser thinks this file is a movie. The value is meaningless.

isTV
:Present if the parser thinks this is a TV show. The value is meaningless.

name
:Name of the movie or television show (etc.).

year
:Present if this is a movie and a year was found in the filename.

imdb
:Contains the movie's imdb code, if found.

season
:Contains the season number if this is a TV show and a season number was found. Season and episode numbers are sometimes entered as Roman numberals or spelled out like "season one". These values will be converted to 

disk
:Disk number from a collection. Similar to season.

episode
:Contains the episode number within the season or disk collection, if found.

end_episode
:If an episode range was found, like Eaa-Ebb, this is the end value, bb. episode has the aa value.

part
:If the show or movie has been broken into multiple files, this is the part number. Part numbers are often found in the file names as letters, like 'S01E10a' and 'S01E10b', which are converted to numbers in this value.

episode_name
:Name of the individual episode, if present.

## Examples

