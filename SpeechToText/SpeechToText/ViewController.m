//
//  ViewController.m
//  SpeechToText
//
//  Created by webwerks on 11/18/17.
//  Copyright © 2017 PT. All rights reserved.
//

#import "ViewController.h"
#import "PTSiriView.h"

@interface ViewController ()
{
    PTSiriView *siriView;
    NSMutableArray *aryData;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialiseArray];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [PTSiriView checkAndRequestPermissionForSiri];
     siriView = (PTSiriView *)[[[NSBundle mainBundle] loadNibNamed:@"PTSiriView" owner:self options:nil] objectAtIndex:0];
    siriView.frame = self.view.bounds;
    [self.view addSubview:siriView];
    siriView.alpha = 0.0f;
    // Do any additional setup after loading the view, typically from a nib.
}

-(void) initialiseArray {
    
    aryData = [[NSMutableArray alloc] init];
    
    [aryData addObject:@{@"name":@"Like", @"alternative":@"admiration,approval,desire,esteem,fondness,friendship,good will,happiness,kindness,like,liking,love,loving,pleasure,regard,respect,satisfaction,sympathy"}];
    [aryData addObject:@{@"name":@"Dislike", @"alternative":@"animosity,animus,antipathy,aversion,disapproval,disgust,displeasure,dissatisfaction,distaste,enmity,hostility,loathing,prejudice,deprecation,detestation,disapprobation,disesteem,disfavor,disinclination,indisposition,objection,offense,opposition,repugnance"}];
    
    [aryData addObject:@{@"name":@"Happy", @"alternative":@"cheerful,contented,delighted,ecstatic,elated,glad,joyful,joyous,jubilant,lively,merry,overjoyed,peaceful,pleasant,pleased,thrilled,upbeat,blessed,blest,blissful,blithe,can't complain,captivated,chipper"}];
    
    [aryData addObject:@{@"name":@"Unlucky", @"alternative":@"hapless,miserable,tragic,unhappy,luckless,afflicted,bad break,behind eight ball,black,calamitous,cataclysmic,catastrophic,cursed,dire"}];
    
    [aryData addObject:@{@"name":@"Blissful", @"alternative":@"dreamy,enchanted,euphoric,heavenly,joyous,beatific,cool,crazy,delighted,ecstatic,elated,enraptured,floating,flying"}];

    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark * UITableview Delegate Methods * -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return aryData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    cell.textLabel.text = [[aryData objectAtIndex:indexPath.row] valueForKey:@"name"];
    
    cell.detailTextLabel.text = [[aryData objectAtIndex:indexPath.row] valueForKey:@"alternative"];
    cell.detailTextLabel.numberOfLines = 0;
    return cell;
    
    
}
- (IBAction)tapOnSiri:(id)sender {
    siriView.alpha = 1.0f;
    [siriView startRecordingWithArrat:aryData];
}

@end
