/**
 * @file ParseVideoFilename.swift
 * @author Maury Markowitz
 * @date 5 February 2023
 *
 * @title ParseVideoFilename
 * @brief Parses filenames of video files to extract season and episode data
 */

import Foundation

public struct ParseVideoFilename {
    /// VERSION string
    public private(set) var VERSION = "1.0"
    
    /**
     * Returns a dictionary of [String: String] containing any matches against the list of patterns.
     * This is the only public method.
     *
     * @param list a node in the list to traverse.
     * @return the previous node.
     */
    public static func parse(_ filename: String, defaults: [String: String] = [String: String]()) -> [String: String]
    {
        // set up the return dictionary
        var result = [String: String]()
        
        // if filename is empty, return the empty dictionary
        if filename.count == 0 {
            return result
        }
        
        // pull off the extension and save it, and find the path if its there
        // NOTE: the "path" may include data if they used slashes as delimiters
        var file = filename
        let ext = (filename as NSString).pathExtension
        if ext.count > 0 {
            result["extension"] = ext
        }
        let dir = (filename as NSString).deletingLastPathComponent
        if dir.count > 0 {
            result["dir"] = dir
        }
        file = (filename as NSString).deletingPathExtension
        
        // these ones confuse the "part" pattern
        file = file.replacingOccurrences(of: "480p", with: "")
        file = file.replacingOccurrences(of: "720p", with: "")
        file = file.replacingOccurrences(of: "1080p", with: "")
        file = file.replacingOccurrences(of: "2160p", with: "")
        // and these ones confuse the season x episode (sxee) pattern
        file = file.replacingOccurrences(of: "x263", with: "")
        file = file.replacingOccurrences(of: "x264", with: "")
        file = file.replacingOccurrences(of: "x265", with: "")
        
        // now look for any roman numerals found in disk/season/episode values
        // NOTE: what about years for movies? this only looks in TV fields
        let roman = #"""
        (d|dvd|disc|disk|s|se|season|e|ep|episode|p|part|day)[\s._-](?<roman>M{0,4}(CM|CD|D?C{0,3})(XC|XL|L?X{0,3})(IX|IV|V?I{0,3}))(?=[\s._-])
        """#
        // if we found any, clip it out and replace it with the numeric value
        // of course, work backwards...
        
        
        
        // and do the same for spelled-out numbers
        let units = "zero|one|two|three|five|(?:twen|thir|four|fif|six|seven|nine)(?:|teen|ty)|eight(?:|een|y)|ten|eleven|twelve"
        let mults = "hundred|thousand|(?:m|b|tr)illion"
        let nums = #"((?:(?:\#(units)|\#(mults))(?:\#(units)|\#(mults)|\s|,|and|&)+)?(?:\#(units)|\#(mults)))"#
        
        
        
        // get the list of movie and show patterns
        let patterns = setupPatterns()
        
        // and try each one in turn
        var foundSomething = false
        for pattern in patterns {
            foundSomething = findMatches(withPattern:pattern, inFilename:file, addTo:&result)
            if foundSomething { break }
        }
        // and we're done!
        return result
    }
    
    /**
     * Sets up an array of regex patterns to parse the filenames. The
     * patterns are applied against the filename in order. New patterns
     * should be added here, in the proper sequence, likely at the bottom.
     */
    static func setupPatterns() -> [String]
    {
        var patterns = [String]()
        
        // look for TV episodes from a DVD collection, DddEee format. Example:
        // Series Name.D01E02..avi
        patterns.append(#"^(?:(?<name>.*?)[\/\s._-]+)?(?:d|dvd|disc|disk)[\s._]?(?<dvd>\d{1,2})[x\/\s._-]*(?:e|ep|episode)[\s._]?(?<episode>\d{1,2}(?:\.\d{1,2})?)(?:-?(?:(?:e|ep)[\s._]*)?(?<endepisode>\d{1,2}))?(?:[\s._]?(?:p|part)[\s._]?(?<part>\d+))?(?<subepisode>[a-z])?(?:[\/\s._-]*(?<episodename>[^\/]+?))?$"#)
        
        // look for TV episodes in the common season/episode format, SssEee. Example:
        // Series Name.S01E02..avi
        patterns.append(#"^(?:(?<name>.*?)[\/\s._-]+)?(?:d|dvd|disc|disk)[\s._]?(?<dvd>\d{1,2})[x\/\s._-]*(?:e|ep|episode)[\s._]?(?<episode>\d{1,2}(?:\.\d{1,2})?)(?:-?(?:(?:e|ep)[\s._]*)?(?<endepisode>\d{1,2}))?(?:[\s._]?(?:p|part)[\s._]?(?<part>\d+))?(?<subepisode>[a-z])?(?:[\/\s._-]*(?<episodename>[^\/]+?))?$"#)
        
        // match against IMDB movie codes in the name. Example:
        // Movie Name [1996] [imdb 1234567].mkv
        patterns.append(#"^(?<movie>.*?)?(?:[\/\s._-]*(?<openb>\[)?(?<year>(?:19|20)\d{2})(?(<openb>)\]))?(?:[\/\s._-]*(?<openc>\[)?(?:(?:imdb|tt)[\s._-]*)*(?<imdb>\d{7})(?(<openc>)\]))(?:[\s._-]*(?<title>[^\/]+?))?$"#)
        
        // look for movies with a year in the title. Example:
        // Movie Name [1988].avi
        patterns.append(#"^(?:(?<movie>.*?)[\/\s._-]*)?(?<openb>\[\(?)?(?<year>(?:19|20)\d{2})(?(<openb>)\)?\])(?:[\s._-]*(?<title>[^\/]+?))?$"#)
        
        // look for television shows with season and episode in 'see' format. Example:
        // Series Name.102.Episode name.mkv
        patterns.append(#"^(?:(?<name>.*?)[\/\s._-]*)?(?<season>\d{1,2}?)(?<episode>\d{2})(?:[^0-9][\s._-]*(?<episodename>.+?))?$"#)
        
        // look for television shows with a season and episode using "sxee" format. Example:
        // Series Name.1x02.Episode name.avi
        patterns.append(#"^(?:(?<name>.*?)[\/\s._-]*)?(?<openb>\[)?(?<season>\d{1,2})[x\/](?<episode>\d{1,2})(?:-(?:\k<season>x)?(?<endepisode>\d{1,2}))?(?(<openb>)\])(?:[\s._-]*(?<episodename>[^\/]+?))?$"#)
        
        // look for television shows with a season only. Example:
        // Series Name.s1.Episode name.m4v
        patterns.append(#"^(?:(?<name>.*?)[\/\s._-]+)?(?:s|se|season|series)[\s._]?(?<season>\d{1,2})(?:[\/\s._-]*(?<episodename>[^\/]+?))?$"#)
        
        // look for television shows with an episode only. Example:
        // Series Name.Episode 02.Episode name.mov
        patterns.append(#"^(?:(?<name>.*?)[\/\s._-]*)?(?:(?:e|ep|episode)[\s._]?)?(?<episode>\d{1,2})(?:-(?:e|ep)?(?<endepisode>\d{1,2}))?(?:(?:p|part)(?<part>\d+))?(?<subepisode>[a-z])?(?:[\/\s._-]*(?<episodename>[^\/]+?))?$"#)
        
        // and if nothing else matches, assume its a movie and the name is the entire match
        patterns.append(#"^(?<movie>.*)$"#)
        
        // that's it!
        return patterns
    }
    
    /**
     * Looks for any matching groups in the filename and adds them to the passed-in dictionary.
     *
     * @param withPattern A string containing the pattern to match on.
     * @param inFilename A string containing the filename to scan.
     * @param addTo A [String:String] dictionary of results.
     * @return true if the match was successful.
     */
    static func findMatches(withPattern pattern: String, inFilename string: String, addTo result: inout [String:String]) -> Bool
    {
        // make a mutatable version of the results
        var gotIt = false
        
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) else { return gotIt }
        let values = namedCaptureGroupMatches(forPattern: regex, inString: string)
        if values.count > 0 {
            // copy over everything we got
            result = result.merging(values) { (_, new) in new }
            
            // and mark this as a success
            result["didParse"] = "1"
            gotIt = true
        }
        return gotIt
    }
    
    /**
     * Converts a roman numeral string to an Int. Returns nil if it can't be converted.
     *
     * This does not support "large numbers" as these will not appear in the filenames,
     * where the largest numbers we expect are year numbers less than 3999
     */
    func romanNumeralValue(_ romanNumber: String) -> Int?  {
        guard romanNumber.range(of: "^(?=[MDCLXVI])M*(C[MD]|D?C{0,3})(X[CL]|L?X{0,3})(I[XV]|V?I{0,3})$", options: .regularExpression) != nil else {
            return nil
        }
        var result = 0
        var maxValue = 0
        romanNumber.uppercased().reversed().forEach {
            let value: Int
            switch $0 {
            case "M":
                value = 1000
            case "D":
                value = 500
            case "C":
                value = 100
            case "L":
                value = 50
            case "X":
                value = 10
            case "V":
                value = 5
            case "I":
                value = 1
            default:
                value = 0
            }
            maxValue = max(value, maxValue)
            result += value == maxValue ? value : -value
        }
        return result
    }
}
