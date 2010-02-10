// Extraction.m
// Created by Rob Rix on 2010-02-10
// Copyright 2010 Monochrome Industries

#import <Foundation/Foundation.h>

int EXLogError(NSError *error) {
	printf("%s", [error.localizedDescription UTF8String]);
	return error.code;
}

// fixme: user-specified criteria would be nice
BOOL EXTrackMatchesCriteria(QTTrack *track) {
	return [[track.media attributeForKey: QTMediaTypeAttribute] isEqual: QTMediaTypeSound];
}

int main (int argc, const char * argv[]) {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	// fixme: usage info when input is invalid
	NSString *path = [[NSProcessInfo processInfo].arguments objectAtIndex: 1];
	NSString *outputPath = [[NSProcessInfo processInfo].arguments objectAtIndex: 2];
	NSError *error = nil; 
	QTMovie *movie = [QTMovie movieWithFile: path error: &error];
	[movie setAttribute: [NSNumber numberWithBool: YES] forKey: QTMovieEditableAttribute];
	
	if(!movie) {
		return EXLogError(error);
	} else {
		NSArray *tracks = [movie.tracks copy];
		for(QTTrack *track in tracks) {
			if(!EXTrackMatchesCriteria(track)) {
				[movie removeTrack: track];
			}
		}
		
		// fixme: by default, refuse to overwrite existing files
		if(![movie writeToFile: outputPath withAttributes: [NSDictionary dictionaryWithObject: [NSNumber numberWithBool: YES] forKey: QTMovieFlatten] error: &error]) {
			return EXLogError(error);
		}
	}
	
	[pool drain];
	return 0;
}
