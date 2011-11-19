//
//  WordNetJPN.m
//
//  Created by 大森 智史 on 09/03/31.
//  Copyright 2009-2011 Satoshi Oomori. All rights reserved.
//

//
//  Bug Fix 伊藤真央さん　2011/6/28(at //Mao Ito added this code)


#import "WordNetJPN.h"

//Synset
@implementation Synset
@synthesize synset;
@synthesize pos;
@synthesize name;
@synthesize src;
@end

//Sense
@implementation Sense
@synthesize rank;
@synthesize lexid;
@synthesize synset;
@synthesize freq;
@synthesize src;
@synthesize lang;
@synthesize wordid;
@end

//Word
@implementation Word
@synthesize wordid;
@synthesize lang;
@synthesize lemma;
@synthesize pron;
@synthesize pos;
@synthesize gloss;

@end

//Synlink
@implementation Synlink
@synthesize synset1;
@synthesize synset2;
@synthesize link;
@synthesize src;
@end

@implementation WordNetJPN
@synthesize path;	//辞書のパス

- (id) initWithPath:(NSString *)aPath
{
	self = [super init];
	self.path = aPath;
	return self;
}
//語を与えてwordidを得る
-(NSArray *)getWords:(NSString *)lemma{
	
	
	NSMutableArray *retArry = [NSMutableArray arrayWithCapacity:1];
	
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
		const char *sql = [[NSString stringWithFormat:@"select word.wordid,word.lang,word.lemma,word.pos from word where word.lemma='%@'",lemma] UTF8String];
		
		//NSString * sqlString = [NSString stringWithFormat:@"select lemma from word join sense on word.wordid =sense.wordid where synset = '%@' and sense.lang = 'jpn'",synset];
		
        sqlite3_stmt *statement;
		
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
			
            while (sqlite3_step(statement) == SQLITE_ROW) {
				Word *word =	[[Word alloc] init];
				word.wordid = sqlite3_column_int(statement, 0);
				word.lang =	[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
				word.lemma =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
				//word.pron = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
				word.pos =	[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
				[retArry addObject:word];
				[word release];
            }
        }else{
			//データベースが開けなかったとき
			sqlite3_close(database);
			NSLog(@"error message '%s'.", sqlite3_errmsg(database));
		}
		
		sqlite3_finalize(statement);
    } else {
        //データベースが開けなかったとき
        sqlite3_close(database);
        NSAssert1(0, @"error message '%s'.", sqlite3_errmsg(database));
		
    }
	sqlite3_close(database); //Mao Ito added this code
	return [NSArray arrayWithArray:retArry];
}

-(NSArray *)getWord:(int)wordid{
	
	
	NSMutableArray *retArry = [NSMutableArray arrayWithCapacity:1];
	
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
		NSString *aqlString = [NSString stringWithFormat:@"select * from word where wordid=%d",wordid];
		const char *sql = [aqlString UTF8String];
		sqlite3_stmt *statement;
		
		if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
			
			while (sqlite3_step(statement) == SQLITE_ROW) {
				Word *word =	[[Word alloc] init];
				[word setWordid : wordid];
				word.lang =	[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
				word.lemma =		[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
				//word.pron =		[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
				word.pos =		[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
				[retArry addObject:word];
				[word release];
			}
		}else{
			//データベースが開けなかったとき
			sqlite3_close(database);
			NSLog(@"message '%s'.", sqlite3_errmsg(database));
		}
		
		//} 
		
		sqlite3_finalize(statement);
        
    } else {
        //データベースが開けなかったとき
        sqlite3_close(database);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
		
    }
	sqlite3_close(database);
	return [NSArray arrayWithArray:retArry];
}

//wordidを与えてsenseを得る
-(NSArray *)getSenses:(NSArray *)words{
	
	
	NSMutableArray *retArry = [NSMutableArray arrayWithCapacity:1];	
	
	
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
		
		NSUInteger i, count = [words count];
		for (i = 0; i < count; i++) {
			//NSNumber * obj = [words objectAtIndex:i];
			Word *word = [words objectAtIndex:i];
			NSString *sqlString = [NSString stringWithFormat:@"select sense.synset,sense.lang,sense.wordid from sense where wordid=%d  and sense.lang='jpn'",word.wordid];
			const char *sql = [sqlString UTF8String];
			sqlite3_stmt *statement;
			
			if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
				
				while (sqlite3_step(statement) == SQLITE_ROW) {
					//sense = sqlite3_column_value(statement, 0);
					Sense *sense = [[Sense alloc] init];
					sense.synset = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
					//sense.lexid = sqlite3_column_int(statement, 1);//
					sense.lang = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
					//sense.rank = sqlite3_column_int(statement, 3);//freqかも4
					sense.wordid = sqlite3_column_int(statement, 2);
					
					//NSLog(@"getSense--%d , wordid = %d",sense.wordid,word.wordid);
					
					
					[retArry addObject:sense ];
					[sense release];
					
				}
			}else{
				//データベースが開けなかったとき
				sqlite3_close(database);
				NSLog(@"message '%s'.", sqlite3_errmsg(database));
			}
			
			sqlite3_finalize(statement);	
		} 
        
    } else {
        //データベースが開けなかったとき
        sqlite3_close(database);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
		
    }
	sqlite3_close(database); //Mao Ito added this code
	//sqlite3_close(database);
	return [NSArray arrayWithArray:retArry];
}

//wordidを与えてsenseを得る
-(NSArray *)getSense:(NSArray *)words{
	
	
	NSMutableArray *retArry = [NSMutableArray arrayWithCapacity:1];	
	
	
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
		
		NSUInteger i, count = [words count];
		for (i = 0; i < count; i++) {
			Word *word = [words objectAtIndex:i];
			NSString *aqlString = [NSString stringWithFormat:@"select * from sense where wordid=%d",word.wordid];
			const char *sql = [aqlString UTF8String];
			sqlite3_stmt *statement;
			
			if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
				
				while (sqlite3_step(statement) == SQLITE_ROW) {
					//sense = sqlite3_column_value(statement, 0);
					Sense *sense = [[Sense alloc] init];
					sense.synset = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
					//sense.wordid = [NSNumber numberWithInt: sqlite3_column_int(statement, 1) ];
					NSString *str = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
					[retArry addObject:sense.synset];
					NSLog(@"getSense--%@",str);
				}
			}else{
				//データベースが開けなかったとき
				sqlite3_close(database);
				NSLog(@"message '%s'.", sqlite3_errmsg(database));
			}
			
			sqlite3_finalize(statement);
		} 
		
        
    } else {
        //データベースが開けなかったとき
        sqlite3_close(database);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
		
    }
	sqlite3_close(database); //Mao Ito added this code
	return [NSArray arrayWithArray:retArry];
}


-(NSArray *)getSynset:(NSString *)synset{
	NSMutableArray *retArry = [NSMutableArray arrayWithCapacity:1];
	
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
		NSString * sqlString = [NSString stringWithFormat:@"select * from synset where synset='%@'",synset];
		
		const char *sql = [sqlString UTF8String];
		sqlite3_stmt *statement;
		
		if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
			
			while (sqlite3_step(statement) == SQLITE_ROW) {
				Word *word =	[[Word alloc] init];
				word.wordid = sqlite3_column_int(statement, 0);
				word.lang =	[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
				word.lemma =		[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
				//word.pron =		[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
				//word.pos =		[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
				[retArry addObject:word];
				[word release];
			}
		}else{
			//データベースが開けなかったとき
			sqlite3_close(database);
			NSLog(@"message '%s'.", sqlite3_errmsg(database));
		}
		
		//} 
		
		sqlite3_finalize(statement);
        
    } else {
        //データベースが開けなかったとき
        sqlite3_close(database);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
		
    }
	sqlite3_close(database); //Mao Ito added this code
	return [NSArray arrayWithArray:retArry];
}



-(NSArray *)getSynLinks:(Sense *)sense link:(NSString *)link{
	
	
	NSMutableArray *synLinks = [NSMutableArray arrayWithCapacity:1];
	
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
		NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM synlink where synset1 ='%@' and link='%@'",sense.synset,link ];
		const char *sql = [sqlString UTF8String];
		sqlite3_stmt *statement;
		
		if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
			
			while (sqlite3_step(statement) == SQLITE_ROW) {
				Synlink *synlink =	[[Synlink alloc] init];
				synlink.synset1 =	[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
				synlink.synset2 =	[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
				synlink.link =		[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
				synlink.src =		[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
				
				[synLinks addObject:synlink];
				[synlink release];
			}
		}else{
			//データベースが開けなかったとき
			
			sqlite3_close(database);
			NSLog(@"message '%s'.", sqlite3_errmsg(database));
		}
		
		
		sqlite3_finalize(statement);
	}
	sqlite3_close(database); //Mao Ito added this code
	return  [NSArray arrayWithArray:synLinks];
}

//synsetに含まれるWordの配列を返します。
-(NSArray *)wordsOfSynset:(NSString *)synset language:(NSString *)lang{
	
	
	NSMutableArray *retArry = [NSMutableArray arrayWithCapacity:1];
	
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
		NSString * sqlString = [NSString stringWithFormat:@"select  word.wordid,word.lang,word.lemma,word.pos  from word join sense on word.wordid =sense.wordid where synset = '%@' and sense.lang = '%@'",synset,lang];
		
		const char *sql = [sqlString UTF8String];
		sqlite3_stmt *statement;
		
		if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
			
			while (sqlite3_step(statement) == SQLITE_ROW) {
				Word *word =	[[Word alloc] init];
				word.wordid = sqlite3_column_int(statement, 0);
				word.lang =		[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
				word.lemma =		[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
				//word.pron =		[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
				word.pos =		[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
				[retArry addObject:word];
				[word release];
			}
		}else{
			//データベースが開けなかったとき
			sqlite3_close(database);
			NSLog(@"message '%s'.", sqlite3_errmsg(database));
		}
		
		//} 
		sqlite3_finalize(statement);
		
        
    } else {
        //データベースが開けなかったとき
        sqlite3_close(database);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
		
    }
	sqlite3_close(database); //Mao Ito added this code
	return [NSArray arrayWithArray:retArry];
}


//語を与えてsynset（同じ意味合いの語のグループ）を得る
//When "lemma" is a proper noun, return NULL
-(NSArray *)synsetWithLemma:(NSString *)lemma{
	
	NSMutableArray *retArry = [NSMutableArray arrayWithCapacity:1];
	
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
		const char *sql = [[NSString stringWithFormat:@"select synset,src,pos from word  join sense on word.wordid =sense.wordid where word.lemma='%@'",lemma] UTF8String];
        sqlite3_stmt *statement;
		
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
			
            while (sqlite3_step(statement) == SQLITE_ROW) {
				
				Synset *synset =	[[Synset alloc] init];
				synset.synset =	[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
				synset.pos =		[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
				//synset.name =		[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
				synset.src =		[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
				[retArry addObject:synset];
				[synset release];
				//NSLog(synset.src);
            }
        }else{
			//データベースが開けなかったとき
			sqlite3_close(database);
			return NULL;
			//NSAssert1(0, @"error message '%s'.", sqlite3_errmsg(database));
		}
		sqlite3_finalize(statement);
    } else {
        //データベースが開けなかったとき
        sqlite3_close(database);
        NSAssert1(0, @"error message '%s'.", sqlite3_errmsg(database));
		
    }
	sqlite3_close(database); //Mao Ito added this code
	return [NSArray arrayWithArray:retArry];
}
@end
