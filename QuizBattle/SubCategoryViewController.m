//
//  ArtsViewController.m
//  QuizBattle
//
//  Created by GBS-mac on 8/14/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import "SubCategoryViewController.h"
#import "ViewController.h"
#import <Parse/Parse.h>
#import "SingletonClass.h"
#import "GameViewController.h"
#import "Ranking.h"
#import "CreateDiscussionViewController.h"
#import "GamePLayMethods.h"
#import "FriendsViewController.h"
@interface SubCategoryViewController ()

@end

@implementation SubCategoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
-(void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToPreviousView:) name:KDismissView object:nil];

}
-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KDismissView object:nil];
}
-(void) goToPreviousView:(NSNotification *)notify
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.gradeName=[[NSMutableArray alloc]init];

    self.view.backgroundColor=[UIColor colorWithRed:(CGFloat)244/255 green:(CGFloat)186/255 blue:(CGFloat)226/255 alpha:1.0];
    self.arrSubCatId=[[NSMutableArray alloc]init];
    
    self.batteryName=[[NSMutableArray alloc]init];
    
    currentSelection = -1;
    
    [self fetcHAllSubCategory];

    
    
}
-(void) createTable{
    
    if (!tableV) {
        tableV = [[UITableView alloc] initWithFrame:CGRectMake(20, 10, self.view.frame.size.width-40, self.view.frame.size.height-10)];
        tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableV.delegate=self;
        tableV.dataSource=self;
        tableV.bounces=NO;
       tableV.backgroundColor=[UIColor clearColor];
        [self.view addSubview:tableV];
    }
    else{
        [tableV reloadData];
    }
}
-(void)backBtnAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark---
#pragma mark Table View Delegates.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.arrData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    }

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (currentSelection == indexPath.section) {
        return 120;
    }
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell Identifier";
    
    MessageCustomCell *cell = [tableV dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[MessageCustomCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    if (currentSelection == indexPath.section) {
        
        cell.menuView.hidden=NO;
        
        [UIView animateWithDuration:1 animations:^{
            cell.menuView.layer.opacity = 1.0f;
        }];
    }
    else{
        cell.menuView.layer.opacity = 0.0f;
        cell.menuView.hidden=YES;
        
    }
    //------------Button Actions---
    [cell.rankingButton addTarget:self action:@selector(rankingAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.discussionButton addTarget:self action:@selector(discussionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.challengeButton addTarget:self action:@selector(challengeAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.playNowButton addTarget:self action:@selector(playNowButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    //------------
   // cell.gameDelegate=self;
    cell.topView.frame =CGRectMake(0, 0, 280,50);

    cell.backgroundColor=[UIColor clearColor];
    cell.messageLable.frame = CGRectMake(60,10, 260, 20);
    cell.messageLable.font=[UIFont fontWithName:@"BMHANNA" size:15];
   // cell.lblDescription.frame=CGRectMake(60, 28, 260, 10);
   
    PFObject *object = [self.arrData objectAtIndex:indexPath.section];
    NSString *message = object[@"SubCategoryName"];
    [self.arrSubCatId addObject:object[@"SubCategoryId"]];
    cell.messageLable.text = message;
    cell.picImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.selectedCategoryID]];
    cell.batteryImage.image=[UIImage imageNamed:[self.batteryName objectAtIndex:indexPath.section]];
    cell.gradeName.text=[self.gradeName objectAtIndex:indexPath.section];
    NSString *description = object[@"SubCategoryDesc"];
    cell.lblDescription.text=description;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSNumber *selectedSubCatId = [self.arrSubCatId objectAtIndex:indexPath.section];
    
    NSString *selSubCat = [self.arrData objectAtIndex:indexPath.section];
    [SingletonClass sharedSingleton].strSelectedSubCat = selSubCat;
    
    [SingletonClass sharedSingleton].selectedSubCat=selectedSubCatId;
    NSLog(@"Selected Sub Category %@", [SingletonClass sharedSingleton].selectedSubCat);
    [SingletonClass sharedSingleton].popularityScore=[self.arrPopScore objectAtIndex:indexPath.section];
 //   [SingletonClass sharedSingleton].objectId=@"GhCtviQ1NJ";
    
  
   // [SingletonClass sharedSingleton].objectId=[self.arrObjectId objectAtIndex:indexPath.section];
    //------------------------------------
    PFObject *object = [self.arrData objectAtIndex:indexPath.section];
    NSString *message = object[@"SubCategoryName"];
    [SingletonClass sharedSingleton].strSelectedSubCat=message;
    [SingletonClass sharedSingleton].selectedSubCat=object[@"SubCategoryId"];
    [SingletonClass sharedSingleton].strSelectedCategoryId=[NSString stringWithFormat:@"%d",[object[@"CategoryId"] intValue]];
    NSLog(@"Object Id =-=- %@",[SingletonClass sharedSingleton].objectId);
    
    if (currentSelection == indexPath.section) {
        currentSelection = -1;
        [tableView reloadData];
        return;
    }
    NSInteger row = [indexPath section];
    currentSelection = row;
    
    [UIView animateWithDuration:1 animations:^{
        [tableV reloadData];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
        headerView.contentView.backgroundColor = [UIColor clearColor];
        headerView.backgroundView.backgroundColor = [UIColor clearColor];
    }
}
//-(void)playNowButtonAction:(id)sender {
//
//    [NSThread detachNewThreadSelector:@selector(fetchQuestions) toTarget:self withObject:nil];
//}

#pragma mark GameViewController

-(void)playNowButtonAction:(id)sender {
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playNowButtonAction:) name:@"PlayAnother" object:nil];
    //    [self displaySelectFriendsUI];
    //
    //    [self performSelector:@selector(selectionFriendMethod) withObject:nil afterDelay:2];
    
    GamePLayMethods * obj=[[GamePLayMethods alloc]init];
    obj.gameDelegate=self;
    [obj playNowButtonAction];
}


-(void)gameDetailsAnotherGame:(NSDictionary *)details
{
    
    GameViewController *obj = [[GameViewController alloc] init];
    obj.arrPlayerDetail=details;
    NSLog(@"obj Players Details -== %@",obj.arrPlayerDetail);
    [self presentViewController:obj animated:YES completion:nil];
}

//-(void)gameDetails:(NSDictionary*)details {
//    
//    GameViewController *obj = [[GameViewController alloc] init];
//    obj.arrPlayerDetail=details;
//    NSLog(@"obj Players Details -== %@",obj.arrPlayerDetail);
//    [self presentViewController:obj animated:YES completion:nil];
//}

#pragma mark Challenge Action and game methods
-(void)challengeAction:(id)sender
{
    //---------
    [SingletonClass sharedSingleton].pickFriendsChallenge=TRUE;
    FriendsViewController *frnd=[[FriendsViewController alloc]init];
    frnd.previousView=@"Challenge";
    [self.navigationController pushViewController:frnd animated:YES];
    
//    NSDictionary* dict = [NSDictionary dictionaryWithObject:
//                          [NSString stringWithFormat:@"Show"]
//                                                     forKey:@"detect"];
    
  //  [[NSNotificationCenter defaultCenter]postNotificationName:@"backButtonHome" object:nil userInfo:dict];
    //[self.navController pushViewController:frnd animated:YES];
    //  [self presentViewController:frnd animated:YES completion:nil];
}
#pragma mark Discussion Action
-(void)discussionBtnAction:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KUpdateBackButtonNotification object:@"Home_Again_Discussion"];    CreateDiscussionViewController * createDiscussoin = [[CreateDiscussionViewController alloc]init];
    [self.navigationController pushViewController:createDiscussoin animated:YES];
    //--------
    NSDictionary* dict = [NSDictionary dictionaryWithObject:
                          [NSString stringWithFormat:@"Show"]
                                                     forKey:@"detect"];
    
  //  [[NSNotificationCenter defaultCenter]postNotificationName:@"backButtonHome" object:nil userInfo:dict];
}

#pragma mark Ranking=====
-(void)rankingAction:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KUpdateBackButtonNotification object:@"Home_Again_Ranking"];
    Ranking * ranks=[[Ranking alloc]init];
    [self.navigationController pushViewController:ranks animated:YES];
    
    //--------
    NSDictionary* dict = [NSDictionary dictionaryWithObject:
                          [NSString stringWithFormat:@"Show"]
                                                     forKey:@"detect"];
    
  //  [[NSNotificationCenter defaultCenter]postNotificationName:@"backButtonHome" object:nil userInfo:dict];
}


-(NSString*)getProgressFromGradeValue:(NSNumber *)gradePoints
{
    int gradevalue=[gradePoints intValue];
    NSString * grade;
    if (gradevalue >=0 && gradevalue<=810)
    {
        grade=@"베이비";
        [self.gradeName addObject:grade];
        return @"0_Battery.png";
    }
    else if (gradevalue >=811 && gradevalue <=1220)
    {
        grade=@"초1";
        [self.gradeName addObject:grade];
        return @"1_Battery.png";
    }
    else if (gradevalue >=1221 && gradevalue <=1700)
    {
        grade=@"초2";
        [self.gradeName addObject:grade];
        return @"1_Battery.png";
    }
    else if (gradevalue>=1701 && gradevalue <=2250)
    {
        grade=@"초3";
        [self.gradeName addObject:grade];
        return @"2_Battery.png";
    }
    else if (gradevalue >=2251 && gradevalue <=2870)
    {
        grade=@"초4";
        [self.gradeName addObject:grade];
        return @"2_Battery.png";
    }
     else if (gradevalue >=2871 && gradevalue <=3560)
    {
        grade=@"초5";
        [self.gradeName addObject:grade];
        return @"3_Battery.png";
    }
    else if (gradevalue >=3561 && gradevalue <=5150)
    {
        grade=@"초6";
        [self.gradeName addObject:grade];
        return @"3_Battery.png";
    }
     else if (gradevalue >=5151 && gradevalue<=7020)
    {
        grade=@"중1";
        [self.gradeName addObject:grade];
        return @"4_Battery.png";
    }
    else if (gradevalue >=7021 && gradevalue <=9170)
    {
        grade=@"중2";
        [self.gradeName addObject:grade];
        return @"4_Battery.png";
    }
     else if (gradevalue >=9171 && gradevalue <=15770)
    {
        grade=@"중3";
        [self.gradeName addObject:grade];
        return @"5_Battery.png";
    }
    else  if (gradevalue >=15771 && gradevalue <=24120)
    {
        grade=@"고1";
        [self.gradeName addObject:grade];
        return @"5_Battery.png";
    }
    else if (gradevalue >=24121 && gradevalue<=34220)
    {
        grade=@"고2";
        [self.gradeName addObject:grade];
        return @"6_Battery.png";
    }
    else if (gradevalue >=34221 && gradevalue <=59670)
    {
        grade=@"고3";
        [self.gradeName addObject:grade];
        return @"6_Battery.png";
    }
    else if (gradevalue >=59671 && gradevalue <=92120)
    {
        grade=@"대1";
        [self.gradeName addObject:grade];
        return @"7_Battery.png";
    }
    else if (gradevalue >=92121 && gradevalue <=131570)
    {   grade=@"대2";
        [self.gradeName addObject:grade];
        return @"7_Battery.png";
    }
    else if (gradevalue >=131571 && gradevalue <=178020)
    {
        grade=@"대3";
        [self.gradeName addObject:grade];
        return @"8_Battery.png";
    }
     else if (gradevalue >=178021 && gradevalue <=359370)
     {
         grade=@"대4";
         [self.gradeName addObject:grade];
        return @"8_Battery.png";
    }
    else if (gradevalue >=359371 && gradevalue <=801620)
    {
        grade=@"석사";
        [self.gradeName addObject:grade];
        return @"9_Battery.png";
    }
    else if (gradevalue >=801621 && gradevalue <=1418870)
    {
        grade=@"박사";
        [self.gradeName addObject:grade];
        return @"10_Battery.png";
    }
    else if (gradevalue>=1418871)
    {
        grade=@"퀴즈왕";
        [self.gradeName addObject:grade];
        return @"11_Battery.png";
    }
    else
    {
        return nil;
    }
    
    
}
#pragma mark Parse Methods
-(void)fetchgradeForSubCategory
{
    NSLog(@"Selected SubCtegory=%@",self.selectedCategoryID);
    PFQuery *query=[PFQuery queryWithClassName:@"UserGrade"];
    [query whereKey:@"UserId" equalTo:[SingletonClass sharedSingleton].objectId];
    [query whereKey:@"CategoryId" equalTo:self.selectedCategoryID];
    [query orderByAscending:@"SubcategoryId"];
    dispatch_async(dispatch_get_global_queue(0,0),^
                   {
                       NSArray *arrObjects=[query findObjects];
                       //arrGradeDetails=[NSArray arrayWithArray:arrObjects];
                       PFObject *objSub,*objGrade;
                       for(int i=0;i<=[arrObjects count];i++)
                       {
                           NSMutableDictionary * grade=[[NSMutableDictionary alloc]init];
                           [grade setValue:objSub[@"SubcategoryId"] forKey:@"SubCategoryId"];
                           [grade setValue:objGrade[@"gradepoints"] forKey:@"grade"];
                       }
                       
                       
                       
                   });
    
}

-(void) fetcHAllSubCategory
{
    UIImageView *imageVAnim = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-10, self.view.frame.size.height/2-30, 30, 50)];
    [self.view addSubview:imageVAnim];
    
    NSArray *arrAnimImages = [NSArray arrayWithObjects:
                              [UIImage imageNamed:@"burning_rocket_01.png"],
                              [UIImage imageNamed:@"burning_rocket_02.png"],
                              [UIImage imageNamed:@"burning_rocket_03.png"],
                              [UIImage imageNamed:@"burning_rocket_04.png"],
                              [UIImage imageNamed:@"burning_rocket_05.png"],
                              [UIImage imageNamed:@"burning_rocket_06.png"],
                              [UIImage imageNamed:@"burning_rocket_07.png"],
                              [UIImage imageNamed:@"burning_rocket_08.png"], nil];
    
    imageVAnim.animationImages=arrAnimImages;
    imageVAnim.animationDuration=0.5;
    imageVAnim.animationRepeatCount=0;
    
    [imageVAnim startAnimating];
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"SubCategory"];
    [query whereKey:@"CategoryId" equalTo:self.selectedCategoryID];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSArray *tempArray = [query findObjects];
        self.arrData = [NSArray arrayWithArray:tempArray];
        
        //        [self.tableV reloadData];
        PFQuery *query=[PFQuery queryWithClassName:@"UserGrade"];
        [query whereKey:@"UserId" equalTo:[SingletonClass sharedSingleton].objectId];
       // [query whereKey:@"SubcategoryId" equalTo:@101];
        [query orderByAscending:@"SubcategoryId"];
        NSArray * userGrade=[query findObjects];
        NSLog(@"Data From User Grade %@",userGrade);
        for(int i=0;i<[tempArray count];i++)
        {
            BOOL flag=FALSE;
            PFObject * subCategory=[self.arrData objectAtIndex:i];
            for(int j=0;j<[userGrade count];j++)
            {
                
                PFObject * obj=[userGrade objectAtIndex:j];
                if([obj[@"SubcategoryId"] isEqualToNumber:subCategory[@"SubCategoryId"]] )
                {
                    NSString * imageNamed=[self getProgressFromGradeValue:obj[@"gradepoints"]];
                    [self.batteryName addObject:imageNamed];
                    flag=TRUE;
                }
                
            }
            if(flag==FALSE)
            {
                [self.batteryName addObject:@"0_Battery.png"];
                [self.gradeName addObject:@"베이비"];
                
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [imageVAnim stopAnimating];
            [self createTable];
        });
    });
    
}

//-(void)fetchQuestions {
//
//
//    PFQuery *query = [PFQuery queryWithClassName:@"Questions"];
//    [query whereKey:@"SubCategoryId" equalTo:@"101"];
//
//    NSArray *arrDetails = [query findObjects];
//
//    NSLog(@"Arry Details --= %@",arrDetails);
//
//}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
