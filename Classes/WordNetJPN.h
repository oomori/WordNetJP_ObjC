//
//  WordNetJPN.h
//
//  Created by 大森 智史 on 09/03/31.
//  Copyright 2009 Satoshi Oomori. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
//********************* Synset *************************
//関連性
//Synset 1:多 Sense
//Synset 1:多 Synlink
//Synset 1:多 SynsetDef
@interface Synset : NSObject {
	NSString *pos;		//品詞（名詞=n、動詞=v、形容詞=a、=r）
	NSString *synset;	//関連ID（"06589574-n"）
	NSString *src;		//（"eng30"）	
	NSString *name;		//名称（"publication"）

}

	@property (nonatomic, retain) NSString *synset;
	@property (nonatomic, retain) NSString *pos;
	@property (nonatomic, retain) NSString *name;
	@property (nonatomic, retain) NSString *src;
@end


//********************* Sense *************************
//概念クラス
//Sense 多:1 Word
//Sense 多:1 Synset
@interface Sense : NSObject {
	int rank;			//
	int lexid;			//
	NSString *synset;	//
	int freq;			//
	NSString *src;		//
	NSString *lang;		//言語（日本語=jpn、英語=eng）
	int wordid;			//語 ID（1から始まる整数）
}
	//nonatomic　マルチスレッド環境を考慮しない代わりに高速。
	//retain retainする。
	//asign 参照を持つだけ
	@property (nonatomic, assign) int rank;	//ランク
	@property (nonatomic, assign) int lexid;	//
	@property (nonatomic, assign) NSString *synset;
	@property (nonatomic, assign) int freq;	//
	@property (nonatomic, assign) NSString *src;
	@property (nonatomic, assign) NSString *lang;
	@property (nonatomic, assign) int wordid;
@end

//語クラス
//********************* Word *************************
@interface Word : NSObject {
	int wordid;		//語 ID（1から始まる整数）
	NSString *lang;	//言語（日本語=jpn、英語=eng）
	NSString *lemma;//語（"理性的"、"アルデヒド"）
	NSString *pron;	//
	NSString *pos;	//品詞（名詞=n、動詞=v、形容詞=a、=r）
    
	NSString *gloss;	// kaisetu 

}
	@property (nonatomic, assign) int wordid;
	@property (nonatomic, assign) NSString *lang;
	@property (nonatomic, assign) NSString *lemma;
	@property (nonatomic, assign) NSString *pron;
	@property (nonatomic, assign) NSString *pos;
    @property (nonatomic, assign) NSString *gloss;

@end


//********************* Synlink *************************
@interface Synlink : NSObject {
	NSString *synset1;
	NSString *synset2;
	NSString *link;
	NSString *src;

}
	@property (nonatomic, assign) NSString *synset1;
	@property (nonatomic, assign) NSString *synset2;
	@property (nonatomic, assign) NSString *link;
	@property (nonatomic, assign) NSString *src;
@end




@interface WordNetJPN : NSObject {
	NSString *path;
	sqlite3 *database;
}
-(NSArray *)getSynset:(NSString *)synset;
-(NSArray *)getWord:(int)wordid;
-(NSArray *)getSense:(NSArray *)words;
-(NSArray *)getSynLinks:(Sense *)sense link:(NSString *)link;
-(NSArray *)getSenses:(NSArray *)words;
-(NSArray *)getWords:(NSString *)lemma;

//Synsetと言語で、Wordの配列を返します。
-(NSArray *)wordsOfSynset:(NSString *)synset language:(NSString *)lang;

//語を与えてsynset（同じ意味合いの語のグループ）を得ます。
-(NSArray *)synsetWithLemma:(NSString *)lemma;
	@property (nonatomic, retain) NSString *path;
@end








