import XCTest
@testable import ParseVideoFilename

final class ParseVideoFilenameTests: XCTestCase {
    
    // test that a nil or empty input returns an empty dictionary
    func testEmptyFilename() throws {
        XCTAssertEqual(ParseVideoFilename.parse("").count, 0, "empty filename did not return empty dictionary.")
    }
    
    // test that a non-empty filename returns something
    func testNonEmptyFilename() throws {
        XCTAssertGreaterThan(ParseVideoFilename.parse("non-empty-filename.m4v").count, 0, "non-empty filename did not return empty dictionary.")
    }

    // test that it will at least return the file and extension if they are both there
    func testFilenameFileAndExtension() throws {
        XCTAssertNotEqual(ParseVideoFilename.parse("futurama D2E06 the buggalo.m4v")["file"], "non-empty-filename", "filename was not extracted.")
        XCTAssertNotEqual(ParseVideoFilename.parse("futurama D2E06 the buggalo.m4v")["ext"], ".m4v", "extension was not extracted.")
    }

    func testDVDCollections() throws {
//        ['D01E02.Episode_name.avi', undef, 1, 2, undef, undef, undef, 'Episode_name', 'avi'],
        XCTAssertEqual(ParseVideoFilename.parse("D01E02.Episode_name.avi")["dvd"], "01", "series was not found.")
        XCTAssertEqual(ParseVideoFilename.parse("D01E02.Episode_name.avi")["episode"], "02", "episode number was not found.")
        XCTAssertEqual(ParseVideoFilename.parse("D01E02.Episode_name.avi")["episodename"], "Episode_name", "episode name was not found.")
        
//        ['Series Name.D01E02.Episode_name.avi', 'Series Name', 1, 2, undef, undef, undef, 'Episode_name', 'avi'],
        XCTAssertEqual(ParseVideoFilename.parse("Series Name.D01E02.Episode_name.avi")["name"], "Series Name", "series was not found.")
        XCTAssertEqual(ParseVideoFilename.parse("Series Name.D01E02.Episode_name.avi")["dvd"], "01", "disk number was not found.")
        XCTAssertEqual(ParseVideoFilename.parse("Series Name.D01E02.Episode_name.avi")["episode"], "02", "episode number was not found.")
        XCTAssertEqual(ParseVideoFilename.parse("Series Name.D01E02.Episode_name.avi")["episodename"], "Episode_name", "episode name was not found.")

//        ['Series Name/D01E02.Episode_name.avi', 'Series Name', 1, 2, undef, undef, undef, 'Episode_name', 'avi'],
        // not supported, original code might not either?
        XCTAssertEqual(ParseVideoFilename.parse("Series Name/D01E02.Episode_name.avi")["name"], "Series Name", "series was not found.")
        XCTAssertEqual(ParseVideoFilename.parse("Series Name/D01E02.Episode_name.avi")["dvd"], "01", "disk number was not found.")
        XCTAssertEqual(ParseVideoFilename.parse("Series Name/D01E02.Episode_name.avi")["episode"], "02", "episode number was not found.")
        XCTAssertEqual(ParseVideoFilename.parse("Series Name/D01E02.Episode_name.avi")["episodename"], "Episode_name", "episode name was not found.")

//        ['Series Name.D01E02a.Episode_name.avi', 'Series Name', 1, 2, undef, undef, 'a', 'Episode_name', 'avi'],
        XCTAssertEqual(ParseVideoFilename.parse("Series Name.D01E02a.Episode_name.avi")["name"], "Series Name", "series was not found.")
        XCTAssertEqual(ParseVideoFilename.parse("Series Name.D01E02a.Episode_name.avi")["dvd"], "01", "disk number was not found.")
        XCTAssertEqual(ParseVideoFilename.parse("Series Name.D01E02a.Episode_name.avi")["episode"], "02", "episode number was not found.")
        XCTAssertEqual(ParseVideoFilename.parse("Series Name.D01E02a.Episode_name.avi")["episodename"], "Episode_name", "episode name was not found.")
        XCTAssertEqual(ParseVideoFilename.parse("Series Name.D01E02a.Episode_name.avi")["subepisode"], "a", "subepisode was not found.")

//        ['Series Name.D01E02p4.Episode_name.avi', 'Series Name', 1, 2, undef, 4, undef, 'Episode_name', 'avi'],
        XCTAssertEqual(ParseVideoFilename.parse("Series Name.D01E02p4.Episode_name.avi")["name"], "Series Name", "series was not found.")
        XCTAssertEqual(ParseVideoFilename.parse("Series Name.D01E02p4.Episode_name.avi")["dvd"], "01", "disk number was not found.")
        XCTAssertEqual(ParseVideoFilename.parse("Series Name.D01E02p4.Episode_name.avi")["episode"], "02", "episode number was not found.")
        XCTAssertEqual(ParseVideoFilename.parse("Series Name.D01E02p4.Episode_name.avi")["episodename"], "Episode_name", "episode name was not found.")
        XCTAssertEqual(ParseVideoFilename.parse("Series Name.D01E02p4.Episode_name.avi")["part"], "4", "part was not found.")

//        ['Series Name.D01E02-03.Episode_name.avi', 'Series Name', 1, 2, 3, undef, undef, 'Episode_name', 'avi'],
        XCTAssertEqual(ParseVideoFilename.parse("Series Name.D01E02-03.Episode_name.avi")["name"], "Series Name", "series was not found.")
        XCTAssertEqual(ParseVideoFilename.parse("Series Name.D01E02-03.Episode_name.avi")["dvd"], "01", "disk number was not found.")
        XCTAssertEqual(ParseVideoFilename.parse("Series Name.D01E02-03.Episode_name.avi")["episode"], "02", "episode number was not found.")
        XCTAssertEqual(ParseVideoFilename.parse("Series Name.D01E02-03.Episode_name.avi")["episodename"], "Episode_name", "episode name was not found.")
        XCTAssertEqual(ParseVideoFilename.parse("Series Name.D01E02-03.Episode_name.avi")["endepisode"], "03", "end episode was not found.")
        
//        ['Series Name.D01E02E.03.Episode_name.avi', 'Series Name', 1, 2, 3, undef, undef, 'Episode_name', 'avi'],
        XCTAssertEqual(ParseVideoFilename.parse("Series Name.D01E02E.03.Episode_name.avi")["name"], "Series Name", "series was not found.")
        XCTAssertEqual(ParseVideoFilename.parse("Series Name.D01E02E.03.Episode_name.avi")["dvd"], "01", "disk number was not found.")
        XCTAssertEqual(ParseVideoFilename.parse("Series Name.D01E02E.03.Episode_name.avi")["episode"], "02", "episode number was not found.")
        XCTAssertEqual(ParseVideoFilename.parse("Series Name.D01E02E.03.Episode_name.avi")["episodename"], "Episode_name", "episode name was not found.")
        XCTAssertEqual(ParseVideoFilename.parse("Series Name.D01E02E.03.Episode_name.avi")["endepisode"], "03", "end episode was not found.")

//        ['Series Name/D01E02E03/Episode_name.avi', 'Series Name', 1, 2, 3, undef, undef, 'Episode_name', 'avi'],
        XCTAssertEqual(ParseVideoFilename.parse("Series Name/D01E02E03/Episode_name.avi")["name"], "Series Name", "series was not found.")
        XCTAssertEqual(ParseVideoFilename.parse("Series Name/D01E02E03/Episode_name.avi")["dvd"], "01", "disk number was not found.")
        XCTAssertEqual(ParseVideoFilename.parse("Series Name/D01E02E03/Episode_name.avi")["episode"], "02", "episode number was not found.")
        XCTAssertEqual(ParseVideoFilename.parse("Series Name/D01E02E03/Episode_name.avi")["episodename"], "Episode_name", "episode name was not found.")
        XCTAssertEqual(ParseVideoFilename.parse("Series Name/D01E02E03/Episode_name.avi")["endepisode"], "03", "end episode was not found.")

//        ['D01E02E03/Episode name.avi', undef, 1, 2, 3, undef, undef, 'Episode name', 'avi'],
        //print(ParseVideoFilename.parse("D01E02E03/Episode name.avi"))
        XCTAssertEqual(ParseVideoFilename.parse("D01E02E03/Episode name.avi")["dvd"], "01", "disk number was not found.")
        XCTAssertEqual(ParseVideoFilename.parse("D01E02E03/Episode name.avi")["episode"], "02", "episode number was not found.")
        XCTAssertEqual(ParseVideoFilename.parse("D01E02E03/Episode name.avi")["episodename"], "Episode name", "episode name was not found.")
        XCTAssertEqual(ParseVideoFilename.parse("D01E02E03/Episode name.avi")["endepisode"], "03", "end episode was not found.")

//        ['Series Name.DVD_01.Episode_02.Episode_name.avi', 'Series Name', 1, 2, undef, undef, undef, 'Episode_name', 'avi'],
        XCTAssertEqual(ParseVideoFilename.parse("Series Name.DVD_01.Episode_02.Episode_name.avi")["name"], "Series Name", "series was not found.")
        XCTAssertEqual(ParseVideoFilename.parse("Series Name.DVD_01.Episode_02.Episode_name.avi")["dvd"], "01", "disk number was not found.")
        XCTAssertEqual(ParseVideoFilename.parse("Series Name.DVD_01.Episode_02.Episode_name.avi")["episode"], "02", "episode number was not found.")
        XCTAssertEqual(ParseVideoFilename.parse("Series Name.DVD_01.Episode_02.Episode_name.avi")["episodename"], "Episode_name", "episode name was not found.")

//        ['Series Name.disk_V.Episode_XI.Episode_name.avi', 'Series Name', 5, 11, undef, undef, undef, 'Episode_name', 'avi'],
        
//        ['Series Name.disc_V.Episode_XI.Part.XXV.Episode_name.avi', 'Series Name', 5, 11, undef, 25, undef, 'Episode_name', 'avi'],
        
//        ['Series Name.DVD01.Ep02.Episode_name.avi', 'Series Name', 1, 2, undef, undef, undef, 'Episode_name', 'avi'],
        XCTAssertEqual(ParseVideoFilename.parse("Series Name.DVD01.Ep02.Episode_name.avi")["name"], "Series Name", "series was not found.")
        XCTAssertEqual(ParseVideoFilename.parse("Series Name.DVD01.Ep02.Episode_name.avi")["dvd"], "01", "disk number was not found.")
        XCTAssertEqual(ParseVideoFilename.parse("Series Name.DVD01.Ep02.Episode_name.avi")["episode"], "02", "episode number was not found.")
        XCTAssertEqual(ParseVideoFilename.parse("Series Name.DVD01.Ep02.Episode_name.avi")["episodename"], "Episode_name", "episode name was not found.")

//        ['Series Name/dvd_01.Episode_02.Episode_name.avi', 'Series Name', 1, 2, undef, undef, undef, 'Episode_name', 'avi'],
        XCTAssertEqual(ParseVideoFilename.parse("Series Name/dvd_01.Episode_02.Episode_name.avi")["name"], "Series Name", "series was not found.")
        XCTAssertEqual(ParseVideoFilename.parse("Series Name/dvd_01.Episode_02.Episode_name.avi")["dvd"], "01", "disk number was not found.")
        XCTAssertEqual(ParseVideoFilename.parse("Series Name/dvd_01.Episode_02.Episode_name.avi")["episode"], "02", "episode number was not found.")
        XCTAssertEqual(ParseVideoFilename.parse("Series Name/dvd_01.Episode_02.Episode_name.avi")["episodename"], "Episode_name", "episode name was not found.")

//        ['Series Name/disk_01/Episode_02.Episode_name.avi', 'Series Name', 1, 2, undef, undef, undef, 'Episode_name', 'avi'],
        XCTAssertEqual(ParseVideoFilename.parse("Series Name/disk_01/Episode_02.Episode_name.avi")["name"], "Series Name", "series was not found.")
        XCTAssertEqual(ParseVideoFilename.parse("Series Name/disk_01/Episode_02.Episode_name.avi")["dvd"], "01", "disk number was not found.")
        XCTAssertEqual(ParseVideoFilename.parse("Series Name/disk_01/Episode_02.Episode_name.avi")["episode"], "02", "episode number was not found.")
        XCTAssertEqual(ParseVideoFilename.parse("Series Name/disk_01/Episode_02.Episode_name.avi")["episodename"], "Episode_name", "episode name was not found.")

//        ['Series Name/D.I/Ep02.Episode_name.avi', 'Series Name', 1, 2, undef, undef, undef, 'Episode_name', 'avi'],
        
//        ['Series Name/D three/Ep five Episode_name.avi', 'Series Name', 3, 5, undef, undef, undef, 'Episode_name', 'avi'],
        
    }

}
