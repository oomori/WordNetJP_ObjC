//
//  Controll.m
//
//  Created by Satoshi Oomori on 09/04/01.
//  Copyright 2008 Satoshi Oomori. All rights reserved.






#import "Controll.h"
#import "WordNetJPN.h"

@implementation Controll

-(IBAction)buttonAction:(id)sender{
	//辞書ファイルから辞書を作る
	

	NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"wnjpn" ofType:@"db"];

	WordNetJPN *wordnet = [[WordNetJPN alloc] initWithPath:path];

	//語を与えて関連語セットを返す
	NSArray *synsets = [wordnet synsetWithLemma:@"人達"];
	for (Synset* synset in synsets) {
		NSArray *words = [wordnet wordsOfSynset:synset.synset language:@"jpn"];
		NSLog(@"---------関連グループ-----------------------------------");
		for (Word *element in words) {
			
			NSLog(@"%@,品詞:%@", element.lemma , element.pos);
		}
	}
	
	
	//語それぞれに対してリンクを返す。
	NSArray *words = [wordnet getWords:@"人達"];
	
	NSArray *senseArray;
	if (words){
		senseArray = [wordnet getSenses:words];
		
		NSUInteger i, count = [senseArray count];
		for (i = 0; i < count; i++) {
			NSLog(@"----------------------------------");
			Sense *sense = [senseArray objectAtIndex:i];
			//
			NSArray *wordArray = [wordnet getWord:sense.wordid];
			NSUInteger u2, wordCount = [wordArray count];
			for (u2 = 0; u2 < wordCount; u2++) {
				Word *word = [wordArray objectAtIndex:u2];
				NSLog(@"「%@」 についての関連語",word.lemma);
			}
			
			//NSLog(@"getSsenses--%@,%d",sense.synset,sense.lexid);
			NSArray *synsetArray3 = [wordnet getSynset:sense.synset];
			Word* word3 = (Word *)[synsetArray3 objectAtIndex:0];
			NSLog(@"「%@」の下位語を表示",word3.lemma);
					
			NSArray *synLinks = [wordnet getSynLinks: sense link:@"hypo"];
			//hype 上位語
			//hypo 下位語
			//inst インスタンス
			NSUInteger u, count2 = [synLinks count];
				for (u = 0; u < count2; u++) {
					Synlink *synlink = [synLinks objectAtIndex:u];
					
					NSArray *synsetArray1 = [wordnet getSynset:synlink.synset1];
					Word* word1 = (Word *)[synsetArray1 objectAtIndex:0];
					NSArray *synsetArray2 = [wordnet getSynset:synlink.synset2];
					Word* word2 = (Word *)[synsetArray2 objectAtIndex:0];
					NSLog(@"%@ -> %@",word1.lemma,word2.lemma);
					[wordnet getSynset:synlink.synset2];
				} 
			
			
		} 
	}else{
		NSLog(@"NG");
	}
	
	//オブジェクト解放
	[wordnet release];

}


-(IBAction)sliderAction:(id)sender{

	theLabel.text = [NSString stringWithFormat:@"%f",[(UISlider *)sender value]];
	

}

@end
