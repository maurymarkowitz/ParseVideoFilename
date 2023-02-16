/**
 * @file RegexHelpers.swift
 * @author Maury Markowitz
 * @date 1 February 2023
 *
 * @title RegexHelpers
 * @brief Various functions to ease use of NSRegularExpression
 *
 * This file contains helper methods that make NSRegularExpression slightly easier to use
 * when your pattern contains named capture groups. Is is not, nor is it meant to be, very
 * robust. For instance, it there are multiple hits for a given named group, it will only
 * return one value for that key. This is in keeping with the use-case for file names where
 * more than one episode, for instance, is likely going to fail anyway.
 *
 */

import Foundation

/**
 * Returns the names of capture groups in the regular expression.
 *
 * @param inPattern the NSRegularExpression to examine.
 * @return an array of Strings with the names of the capture groups.
 *
 * So, for example, the regular expression 'a(?<middleChar.)z returns one capture group named "middleChar".
 */
func namedCaptureGroups(inPattern regularExpression:NSRegularExpression) -> [String]
{
  let regexString = regularExpression.pattern
  let range = NSRange(regexString.startIndex..<regexString.endIndex, in:regexString)
  let nameRegex = try! NSRegularExpression(pattern: "\\(\\?\\<(\\w+)\\>", options: [])
  let nameMatches = nameRegex.matches(in: regexString, options: [], range: range)
  let names = nameMatches.map { (textCheckingResult) -> String in
    return (regexString as NSString).substring(with: textCheckingResult.range(at: 1))
  }
  return names
}

/**
 * Returns the names and values for any matching capture groups in the regular expression.
 *
 * @param inPattern the NSRegularExpression to examine.
 * @param andString the string to match against.
 * @return an array of dictionaries of [[String:Substring?]] with the names of the groups and the values of any matches.
 *
 * In the return value, every element represents a distinct match of the entire regular expression against the string.
 * Every element is itself a `Dictionary<String,Substring?>`, mapping the name of the capture groups to the Substring
 * which matched that capture group.
 *
 * So, for example, a match on the regular expression 'a(?<middleChar.)z includes one capture group named "middleChar".
 * It would match three times against against the string "aaz abz acz". This would be expressed as the array
 * [["middleChar":"a"], ["middleChar":"b"], ["middleChar":"c"]]
 */
func namedCaptureGroupMatches(forPattern regularExpression:NSRegularExpression, inString string:String) -> [String:String] //"][[String:Substring?]]
{
    var results = [String:String]()
    
    let names = namedCaptureGroups(inPattern: regularExpression)
    let range = NSRange(string.startIndex..<string.endIndex, in:string)

    let match = regularExpression.firstMatch(in: string, options: [], range: range)
    
    for name in names {
        guard let nsrange = match?.range(withName: name) else { return results }
        if nsrange.location != NSNotFound,
            let range = Range(nsrange, in: string)
        {
            results[name] = String(string[range])
        }
    }

//    let ms = regularExpression.matches(in: string, options: [], range:range)
//    let ret = ms.map({
//        (tcr:NSTextCheckingResult) -> [String:Substring?] in
//        let keyvalues = names.map({ (name:String) -> (String,Substring?) in
//          let captureGroupRange = tcr.range(withName: name)
//          if captureGroupRange.location == NSNotFound {
//            return (name,nil)
//          }
//          else {
//            return (name,string[Range(captureGroupRange, in: string)!])
//          }
//        })
//
//        return Dictionary(uniqueKeysWithValues: keyvalues)
//      })
    
    return results
}
