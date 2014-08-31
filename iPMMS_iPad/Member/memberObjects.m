//
//  memberObjects.m
//  iPMMS_iPad
//
//  Created by Imac DOM on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "memberObjects.h"

@implementation memberObjects
static bool shouldScroll = true;


- (id) initWithDictionary:(NSDictionary*) p_dict andFrame:(CGRect) p_frame andOrientation:(UIInterfaceOrientation) p_intOrientation forMode:(NSString*) p_forMode withScroll:(UIScrollView*) p_scrollView andPhotoNotifyMethod:(METHODCALLBACK) p_photoNotify andLocNotifyMethod:(METHODCALLBACK) p_locationNotify andEmirateCallback:(METHODCALLBACK) p_emirateCallback andNationNotify:(METHODCALLBACK) p_nationNotify
{
    self = [super init];
    if (p_dict) 
        _initDict = [[NSDictionary alloc] initWithDictionary:p_dict copyItems:YES];
    else
        _initDict = nil;
    _parentScroll = p_scrollView;
    _photoNotifyMethod = p_photoNotify;
    currMode = [[NSString alloc] initWithFormat:@"%@", p_forMode];
    _locationNotifyMethod = p_locationNotify;
    _emirateNotifyMethod = p_emirateCallback;
    _nationNotifyMethod = p_nationNotify;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];    lblTextColor = [UIColor whiteColor];
    [self initializeVariables];
    stdDefaults = [NSUserDefaults standardUserDefaults];
    if ([stdDefaults valueForKey:@"LOCATIONSERVER"]) 
        MAIN_URL = [[NSString alloc] initWithFormat:@"http://%@/", [stdDefaults valueForKey:@"LOCATIONSERVER"]];
    else
        MAIN_URL = [[NSString alloc] initWithFormat:@"%@", HO_URL];
    /*imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;*/
    
    //[self setForOrientation:p_intOrientation];
    //cellHeight = 40;
    return  self;
}

- (void) releaseViewObjects
{
    [entryTV removeFromSuperview];
    entryTV = nil;
}

- (void) setForOrientation: (UIInterfaceOrientation) p_forOrientation
{
    currOrientation = p_forOrientation;
    if (UIInterfaceOrientationIsPortrait(currOrientation)) 
    {
        [entryTV setFrame:CGRectMake(0, 50, 703, 930)];
    }
    else
    {
        [entryTV setFrame:CGRectMake(0, 20, 703, 630)];
    }
    //[self generateTableView];
}

- (void) generateTableView
{
    //return;
    if (entryTV) {
        //[self storeDispValues];
        [entryTV removeFromSuperview];
    }
    CGRect tvrect;
    if (UIInterfaceOrientationIsPortrait(currOrientation)) 
        tvrect = CGRectMake(0, 50, 703, 930);
    else
        tvrect = CGRectMake(0, 20, 703, 630);
    entryTV = [[UITableView alloc] initWithFrame:tvrect style:UITableViewStylePlain];
    [entryTV setDelegate:self];
    [entryTV setDataSource:self];
    [entryTV setBackgroundView:nil];
    [entryTV setBackgroundView:[[UIView alloc] init]] ;
    [entryTV setBackgroundColor:[_parentScroll backgroundColor]];
    [entryTV setSeparatorColor:[entryTV backgroundColor]];
    [_parentScroll addSubview:entryTV];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int noofRows =1;
    switch (section) {
        case 0:
            //noofRows = 12;
            noofRows = 11;
            break;
    }
    return noofRows;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int l_rowheight =0;
    switch (indexPath.row) {
        case 0:
            l_rowheight = 180;
            break;
        case 1:
            l_rowheight = 45;
            break;
        default:
            l_rowheight = 45;
            break;
    }
    return  l_rowheight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

/*-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    int l_retval;
    l_retval = 15;
    return l_retval;
}*/

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // as one row is removed adding one number to all indexpath rows
    switch (indexPath.row) {
        case 0:
            //return [self getCellFor2L2T1BforSection:indexPath.section andRow:indexPath.row];
            //return [self getCellFor2L2TforSection:indexPath.section andRow:indexPath.row];
            return [self getCellForFirstRowWithPicture];
            break;
        /*case 1:
            //return [self getCellFor3L3TforSection:indexPath.section andRow:indexPath.row];
            return [self getCellFor2L2TforSection:indexPath.section andRow:indexPath.row];
            break;*/
        case 1:
            return [self getCellFor2L2TforSection:indexPath.section andRow:indexPath.row+1];
            break;
        case 2: 
            return [self getCellFor3L3T1BforSection:indexPath.section andRow:indexPath.row+1];
            break;
        case 3:
            return [self getCellFor3L3TforSection:indexPath.section andRow:indexPath.row+1];
            break;
        case 4:
            return [self getCellFor2L1T1SforSection:indexPath.section andRow:indexPath.row+1];
            break;
        case 5:
            return [self getCellFor2L2TforSection:indexPath.section andRow:indexPath.row+1];
            break;
        case 6:
            return [self getCellFor2L2TforSection:indexPath.section andRow:indexPath.row+1];
            break;
        case 7:
            return [self getCellFor3L2TforSection:indexPath.section andRow:indexPath.row+1];
            break;
        case 8:
            return [self getCellFor2L2TforSection:indexPath.section andRow:indexPath.row+1];
            break;
        case 9:
            return [self getCellFor2L2T1BLforSection:indexPath.section andRow:indexPath.row+1];
            break;
        case 10:
            return [self getCellFor2L2TforSection:indexPath.section andRow:indexPath.row+1];
            break;
        default:
            break;
    }
    return nil;
}

- (UITableViewCell*) getCellForFirstRowWithPicture
{
    static NSString *cellid=@"Cell4T1P";
    UITableViewCell  *cell = [entryTV dequeueReusableCellWithIdentifier:cellid];
    BOOL assignValues = NO;
    UILabel *lbl1, *lbl2, *lbl3, *lbl4;
    UITextField *txt1, *txt2, *txt3, *txt4;
    NSURL *urlPath;
    UIButton *btnSelectLocation;
    int   lblWidth, txtWidth, cellHeight, yPosition ;
    lblWidth = 116; txtWidth =232; cellHeight = 40;

    UIFont *txtfont = [UIFont systemFontOfSize:14.0f];

    if(cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[entryTV backgroundColor];

        yPosition = 0;
        lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(lblPosition, yPosition, lblWidth-lblPosition, cellHeight-1)];
        lbl1.font = txtfont;
        lbl1.textAlignment = UITextAlignmentRight;
        lbl1.tag = 1;
        lbl1.backgroundColor = [entryTV backgroundColor];
        lbl1.textColor = lblTextColor;
        [cell.contentView addSubview:lbl1];
        
        txt1 = [[UITextField alloc] initWithFrame:CGRectMake(lblWidth, yPosition + 5, txtWidth, cellHeight-5)];
        txt1.font = txtfont;
        txt1.textAlignment = UITextAlignmentLeft;
        txt1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txt1.tag = 2;
        txt1.backgroundColor = lblTextColor;
        txt1.borderStyle = UITextBorderStyleRoundedRect;
        [cell.contentView addSubview:txt1];

        yPosition = yPosition+45;
        lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(lblPosition, yPosition, lblWidth-lblPosition, cellHeight-1)];
        lbl2.font = txtfont;
        lbl2.textAlignment = UITextAlignmentRight;
        lbl2.tag = 3;
        lbl2.backgroundColor = [entryTV backgroundColor];
        lbl2.textColor = lblTextColor;
        [cell.contentView addSubview:lbl2];
        
        txt2 = [[UITextField alloc] initWithFrame:CGRectMake(lblWidth, yPosition + 5, txtWidth, cellHeight-5)];
        txt2.font = txtfont;
        txt2.textAlignment = UITextAlignmentLeft;
        txt2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txt2.tag = 4;
        txt2.backgroundColor = lblTextColor;
        txt2.borderStyle = UITextBorderStyleRoundedRect;
        [cell.contentView addSubview:txt2];

        btnSelectLocation =(UIButton*) [cell.contentView viewWithTag:13];
        if (!btnSelectLocation) 
        {
            btnSelectLocation = [[UIButton alloc] initWithFrame:CGRectMake(txt2.frame.origin.x+txtWidth-25, yPosition + 5, 25, cellHeight-5)];
            btnSelectLocation.titleLabel.text=@"";
            [btnSelectLocation setImage:[UIImage imageNamed:@"s.png"] forState:UIControlStateNormal];
            [btnSelectLocation addTarget:self action:@selector(getLocation:) forControlEvents:UIControlEventTouchDown];
            btnSelectLocation.tag = 13;
            [cell.contentView addSubview:btnSelectLocation]; 
        }
        [txt2 setFrame:CGRectMake(txt2.frame.origin.x, txt2.frame.origin.y, txtWidth-25, txt2.frame.size.height)];
        
        yPosition = yPosition+45;
        lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(lblPosition, yPosition, lblWidth-lblPosition, cellHeight-1)];
        lbl3.font = txtfont;
        lbl3.textAlignment = UITextAlignmentRight;
        lbl3.tag = 5;
        lbl3.backgroundColor = [entryTV backgroundColor];
        lbl3.textColor = lblTextColor;
        [cell.contentView addSubview:lbl3];

        txt3 = [[UITextField alloc] initWithFrame:CGRectMake(lblWidth, yPosition + 5, txtWidth, cellHeight-5)];
        txt3.font = txtfont;
        txt3.textAlignment = UITextAlignmentLeft;
        txt3.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txt3.tag = 6;
        txt3.backgroundColor = lblTextColor;
        txt3.borderStyle = UITextBorderStyleRoundedRect;
        [cell.contentView addSubview:txt3];

        yPosition = yPosition+45;
        lbl4 = [[UILabel alloc] initWithFrame:CGRectMake(lblPosition, yPosition, lblWidth-lblPosition, cellHeight-1)];
        lbl4.font = txtfont;
        lbl4.textAlignment = UITextAlignmentRight;
        lbl4.tag = 7;
        lbl4.backgroundColor = [entryTV backgroundColor];
        lbl4.textColor = lblTextColor;
        [cell.contentView addSubview:lbl4];

        txt4 = [[UITextField alloc] initWithFrame:CGRectMake(lblWidth, yPosition + 5, txtWidth, cellHeight-5)];
        txt4.font = txtfont;
        txt4.textAlignment = UITextAlignmentLeft;
        txt4.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txt4.tag = 8;
        txt4.backgroundColor = lblTextColor;
        txt4.borderStyle = UITextBorderStyleRoundedRect;
        [cell.contentView addSubview:txt4];

        memberPhoto = [[UIImageView alloc] init];
        [memberPhoto setFrame:CGRectMake(2*lblWidth+2*txtWidth-130, 0, 130, 130)];
        memberPhoto.tag = 9;
        [cell.contentView addSubview:memberPhoto];

        assignValues = YES;
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    lbl1 = (UILabel*) [cell.contentView viewWithTag:1];
    lbl1.text = [[NSString stringWithFormat:@"%@ ",@"Bar Code"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    
    lbl2 = (UILabel*) [cell.contentView viewWithTag:3];
    lbl2.text = [[NSString stringWithFormat:@"%@ ",@"Location"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];

    lbl3 = (UILabel*) [cell.contentView viewWithTag:5];
    lbl3.text = [[NSString stringWithFormat:@"%@ ",@"First Name"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];

    lbl4 = (UILabel*) [cell.contentView viewWithTag:7];
    lbl4.text = [[NSString stringWithFormat:@"%@ ",@"Last Name"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    if (!txtBarcode)
    {
        txtBarcode = (UITextField*) [cell.contentView viewWithTag:2];
        txtBarcode.delegate = self;
    }
    if (!txtLocation)
    {
        txtLocation = (UITextField*) [cell.contentView viewWithTag:4];
        txtLocation.delegate = self;
    }
    if (!txtFirstname)
    {
        txtFirstname = (UITextField*) [cell.contentView viewWithTag:6];
        txtFirstname.delegate = self;
    }
    if (!txtSurname)
    {
        txtSurname = (UITextField*) [cell.contentView viewWithTag:8];
        txtSurname.delegate = self;
    }

    if (assignValues) 
    {
        [self setValueforText:txtBarcode andField:@"BARCODE"];
        [self setValueforText:txtLocation andField:@"LOCATIONID"];
        [self setValueforText:txtSurname andField:@"LASTNAME"];
        [self setValueforText:txtFirstname andField:@"FIRSTNAME"];
    }
    if ([currMode isEqualToString:@"I"] | [currMode isEqualToString:@"U"]) 
    {
        txtFirstname.enabled = YES;
        txtSurname.enabled = YES;
    }
    else
    {
        txtFirstname.enabled = NO;
        txtSurname.enabled = NO;
    }
    txtLocation.enabled = NO;
    txtBarcode.enabled = NO;
    
    memberPhoto =(UIImageView*) [cell.contentView viewWithTag:9];
    if ([currMode isEqualToString:@"I"] | [currMode isEqualToString:@"U"]) 
        memberPhoto.image = [UIImage imageWithData:[stdDefaults valueForKey:@"currimage"]];
    else
    {
        //NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
        //NSString *imgName = [[NSString alloc] initWithFormat:@"Imagem%d",[[tmpDict valueForKey:@"MEMBERID"] intValue]];
        NSString *imgName = [[NSString alloc] initWithFormat:@"Image%d",[_initDict valueForKey:@"MEMBERID"]];
        NSData *imgData = [stdDefaults valueForKey:imgName];
        if (!imgData) 
        {
            urlPath = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@//Images//m%d.jpeg",MAIN_URL, WS_ENV, [[_initDict valueForKey:@"MEMBERID"]intValue]]];
            imgData = [NSData dataWithContentsOfURL:urlPath];
            [stdDefaults setValue:imgData forKey:imgName];
        }
        memberPhoto.image = [UIImage imageWithData:imgData];
    }
    [memberPhoto setNeedsDisplay];

    btnTakePhoto =(UIButton*) [cell.contentView viewWithTag:11];
    if (!btnTakePhoto) 
    {
        btnTakePhoto = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnTakePhoto setFrame:CGRectMake(2*lblWidth+txtWidth, 3*45+5, txtWidth, cellHeight-5)];
        //btnTakePhoto.titleLabel.text=@"";
        //[btnTakePhoto setImage:[UIImage imageNamed:@"s.png"] forState:UIControlStateNormal];
        [btnTakePhoto setTitle:@"Take Photo" forState:UIControlStateNormal];
        [btnTakePhoto addTarget:self action:@selector(grabPhoto:) forControlEvents:UIControlEventTouchDown];
        [cell.contentView addSubview:btnTakePhoto]; 
    }
    if ([currMode isEqualToString:@"I"] | [currMode isEqualToString:@"U"]) 
        btnTakePhoto.enabled = YES;
    else
        btnTakePhoto.enabled = NO;
    return cell;
}


- (UITableViewCell*) getCellFor2L1T1SforSection:(int) p_section andRow:(int) p_rowno
{
    static NSString *cellid=@"Cell2L1T1S";
    UITableViewCell  *cell = [entryTV dequeueReusableCellWithIdentifier:cellid];
    BOOL assignValues = NO;
    UILabel *lbl1, *lbl2;
    UITextField *txt1;
    UISegmentedControl *sc2;
    int   lblWidth, txtWidth, cellHeight ;
    lblWidth = 116; txtWidth =232; cellHeight = 40;
    
    UIFont *txtfont = [UIFont systemFontOfSize:14.0f];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[entryTV backgroundColor];
        
        lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(lblPosition, 0, lblWidth-lblPosition, cellHeight-1)];
        lbl1.font = txtfont;
        lbl1.textAlignment = UITextAlignmentRight;
        lbl1.tag = 1;
        lbl1.backgroundColor = [entryTV backgroundColor];
        lbl1.textColor = lblTextColor;
        [cell.contentView addSubview:lbl1];
        
        txt1 = [[UITextField alloc] initWithFrame:CGRectMake(lblWidth, 5, txtWidth, cellHeight-5)];
        txt1.font = txtfont;
        txt1.textAlignment = UITextAlignmentLeft;
        txt1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txt1.tag = 2;
        txt1.backgroundColor = lblTextColor;
        txt1.borderStyle = UITextBorderStyleRoundedRect;
        [cell.contentView addSubview:txt1];
        
        lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(lblWidth+txtWidth+lblPosition, 0,lblWidth-lblPosition , cellHeight-1)];
        lbl2.font = txtfont;
        lbl2.tag = 3;
        lbl2.textAlignment = UITextAlignmentRight;
        lbl2.backgroundColor = [entryTV backgroundColor];
        lbl2.textColor = lblTextColor;
        [cell.contentView addSubview:lbl2];
        
        
        NSArray *scData = [NSArray arrayWithObjects:@"Male",@"Female", nil];
        sc2  = [[UISegmentedControl alloc] initWithItems:scData];
        NSDictionary *colorAttrib = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
        NSDictionary *bcAttrib = [NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:UITextAttributeTextShadowColor];
    
        //[sc2 setTitleTextAttributes:fontAttrib  forState:UIControlStateNormal];
        [sc2 setTitleTextAttributes:colorAttrib 
                           forState:UIControlStateNormal];
        [sc2 setTitleTextAttributes:bcAttrib 
                           forState:UIControlStateNormal];
    
        //[sc2 setb	
        // Customize font and items color
        [sc2 setFrame:CGRectMake(2*lblWidth+txtWidth, 5, txtWidth, cellHeight-5)];
        //sc2.segmentedControlStyle = UISegmentedControlStylePlain;
        sc2.tag = 4;
        [cell.contentView addSubview:sc2];
        assignValues = YES;
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    lbl1 = (UILabel*) [cell.contentView viewWithTag:1];
    lbl1.text = [[NSString stringWithFormat:@"%@ ",@"Mobile"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    
    lbl2 = (UILabel*) [cell.contentView viewWithTag:3];
    lbl2.text = [[NSString stringWithFormat:@"%@ ",@"Gender"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    
    if (!txtMobile) 
    {
        txtMobile = (UITextField*) [cell.contentView viewWithTag:2];
        txtMobile.delegate = self;
    }
    
    if (!scGender)
        scGender = (UISegmentedControl*) [cell.contentView viewWithTag:4];

    if (assignValues) 
    {
        [self setValueforText:txtMobile andField:@"MOBILEPHONE"];
        
        if (_initDict)
            if ([_initDict valueForKey:@"GENDER"]) 
                scGender.selectedSegmentIndex = [[_initDict valueForKey:@"GENDER"] intValue];
    }
    
    if ([currMode isEqualToString:@"I"] | [currMode isEqualToString:@"U"]) 
    {
        txtMobile.enabled = YES;
        scGender.enabled = YES;
    }
    else
    {
        txtMobile.enabled = NO;
        scGender.enabled = NO;
    }
    return cell;
}

- (UITableViewCell*) getCellFor2L2TforSection:(int) p_section andRow:(int) p_rowno
{
    static NSString *cellid=@"Cell2L2T";
    UITableViewCell  *cell = [entryTV dequeueReusableCellWithIdentifier:cellid];
    BOOL assignValues = NO;
    UILabel *lbl1, *lbl2;
    UIButton *btnNationSelect;
    UITextField *txt1, *txt2;
    int   lblWidth, txtWidth, cellHeight ;
    lblWidth = 116; txtWidth =232; cellHeight = 40;
    
    UIFont *txtfont = [UIFont systemFontOfSize:14.0f];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[entryTV backgroundColor];
        
        lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(lblPosition, 0, lblWidth-lblPosition, cellHeight-1)];
        lbl1.font = txtfont;
        lbl1.textAlignment = UITextAlignmentRight;
        lbl1.tag = 1;
        lbl1.backgroundColor = [entryTV backgroundColor];
        lbl1.textColor = lblTextColor;
        [cell.contentView addSubview:lbl1];
        
        txt1 = [[UITextField alloc] initWithFrame:CGRectMake(lblWidth, 5, txtWidth, cellHeight-5)];
        txt1.font = txtfont;
        txt1.textAlignment = UITextAlignmentLeft;
        txt1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txt1.tag = 2;
        txt1.backgroundColor = lblTextColor;
        txt1.borderStyle = UITextBorderStyleRoundedRect;
        [cell.contentView addSubview:txt1];
        
        lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(lblWidth+txtWidth+lblPosition, 0,lblWidth-lblPosition , cellHeight-1)];
        lbl2.font = txtfont;
        lbl2.tag = 3;
        lbl2.textAlignment = UITextAlignmentRight;
        lbl2.backgroundColor = [entryTV backgroundColor];
        lbl2.textColor = lblTextColor;
        [cell.contentView addSubview:lbl2];
        
        
        txt2 = [[UITextField alloc] initWithFrame:CGRectMake(2*lblWidth+txtWidth, 5, txtWidth, cellHeight-5)];
        txt2.font = txtfont;
        txt2.tag = 4;
        txt2.textAlignment = UITextAlignmentLeft;
        txt2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txt2.backgroundColor = lblTextColor;
        txt2.borderStyle = UITextBorderStyleRoundedRect;
        [cell.contentView addSubview:txt2];
        assignValues = YES;
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    lbl1 = (UILabel*) [cell.contentView viewWithTag:1];
    
    lbl2 = (UILabel*) [cell.contentView viewWithTag:3];
    /*if (p_rowno!=10) 
    {*/
        btnNationSelect =(UIButton*) [cell.contentView viewWithTag:11];
        if (btnNationSelect) 
            btnNationSelect.hidden = YES;
    //}
    switch (p_rowno) {
        case 0:
            lbl1.text = [[NSString stringWithFormat:@"%@ ",@"Bar code"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
            lbl2.text = [[NSString stringWithFormat:@"%@ ",@"Agreement Ref"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
            if (!txtBarcode)
            {
                txtBarcode = (UITextField*) [cell.contentView viewWithTag:2];
                txtBarcode.delegate = self;
            }
            if (!txtLocation)
            {
                txtLocation = (UITextField*) [cell.contentView viewWithTag:4];
                txtLocation.delegate = self;
            }
            if (assignValues) 
            {
                [self setValueforText:txtBarcode andField:@"BARCODE"];
                [self setValueforText:txtLocation andField:@"AGREEMNETREF"];
                  
            }
            if ([currMode isEqualToString:@"I"] | [currMode isEqualToString:@"U"]) 
                txtLocation.enabled = YES;
            else
                txtLocation.enabled = NO;
            txtBarcode.enabled = NO;
            break;
        case 1:
            lbl1.text = [[NSString stringWithFormat:@"%@ ",@"First Name"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
            lbl2.text = [[NSString stringWithFormat:@"%@ ",@"Last Name"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
            if (!txtFirstname)
            {
                txtFirstname = (UITextField*) [cell.contentView viewWithTag:2];
                txtFirstname.delegate = self;
            }
            if (!txtSurname)
            {
                txtSurname = (UITextField*) [cell.contentView viewWithTag:4];
                txtSurname.delegate = self;
            }
            if (assignValues) 
            {
                [self setValueforText:txtSurname andField:@"LASTNAME"];
                [self setValueforText:txtFirstname andField:@"FIRSTNAME"];
            }
            if ([currMode isEqualToString:@"I"] | [currMode isEqualToString:@"U"]) 
            {
                txtFirstname.enabled = YES;
                txtSurname.enabled = YES;
            }
            else
            {
                txtFirstname.enabled = NO;
                txtSurname.enabled = NO;
            }
            break;
        case 2:
            lbl1.text = [[NSString stringWithFormat:@"%@ ",@"Address1"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
            lbl2.text = [[NSString stringWithFormat:@ "%@ ",@"Address2"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
            if (!txtAddress1) 
            {
                txtAddress1 = (UITextField*) [cell.contentView viewWithTag:2];
                txtAddress1.delegate = self;
            }
            if (!txtAddress2)
            {
                txtAddress2 = (UITextField*) [cell.contentView viewWithTag:4];
                txtAddress2.delegate = self;
            }
            if (assignValues) 
            {
                [self setValueforText:txtAddress1 andField:@"ADDRESS1"];
                [self setValueforText:txtAddress2 andField:@"ADDRESS2"];
            }
            if ([currMode isEqualToString:@"I"] | [currMode isEqualToString:@"U"]) 
            {
                txtAddress1.enabled = YES;
                txtAddress2.enabled = YES;
            }
            else
            {
                txtAddress1.enabled = NO;
                txtAddress2.enabled = NO;
            }
            break;
        case 6:
            lbl1.text = [[NSString stringWithFormat:@"%@ ",@"Emer Contact"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
            lbl2.text = [[NSString stringWithFormat:@"%@ ",@"Emer Phone"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
            if (!txtEmerContact) 
            {
                txtEmerContact = (UITextField*) [cell.contentView viewWithTag:2];
                txtEmerContact.delegate = self;
            }
            if (!txtEmerPh)
            {
                txtEmerPh = (UITextField*) [cell.contentView viewWithTag:4];
                txtEmerPh.delegate = self;
            }
            if (assignValues) 
            {
                [self setValueforText:txtEmerContact andField:@"EMERCONTACT"];
                [self setValueforText:txtEmerPh andField:@"EMERPHONE"];
            }
            if ([currMode isEqualToString:@"I"] | [currMode isEqualToString:@"U"]) 
            {
                txtEmerContact.enabled = YES;
                txtEmerPh.enabled = YES;
            }
            else
            {
                txtEmerContact.enabled = NO;
                txtEmerPh.enabled = NO;
            }
            break;
        case 7:
            lbl1.text = [[NSString stringWithFormat:@"%@ ",@"Email Address"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
            lbl2.text = [[NSString stringWithFormat:@"%@ ",@"Mbr Svc Login"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
            if (!txtEmail) 
            {
                txtEmail = (UITextField*) [cell.contentView viewWithTag:2];
                txtEmail.delegate = self;
            }
            if (!txtMbrLogin)
            {
                txtMbrLogin = (UITextField*) [cell.contentView viewWithTag:4];
                txtMbrLogin.delegate = self;
            }
            if (assignValues) 
            {
                [self setValueforText:txtEmail andField:@"EMAIL"];
                [self setValueforText:txtMbrLogin andField:@"MBRSVCLOGIN"];
            }
            if ([currMode isEqualToString:@"I"] | [currMode isEqualToString:@"U"]) 
            {
                txtEmail.enabled = YES;
                txtMbrLogin.enabled = YES;
            }
            else
            {
                txtEmail.enabled = NO;
                txtMbrLogin.enabled = NO;
            }
            break;
        case 9:
            lbl1.text = [[NSString stringWithFormat:@"%@ ",@"Car Regn#"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
            lbl2.text = [[NSString stringWithFormat:@"%@ ",@"Agreement Ref"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
            if (!txtCarRegnNo) 
            {
                txtCarRegnNo = (UITextField*) [cell.contentView viewWithTag:2];
                txtCarRegnNo.delegate = self;
            }
            if (!txtAgreement)
            {
                txtAgreement = (UITextField*) [cell.contentView viewWithTag:4];
                txtAgreement.delegate = self;
            }
            if (assignValues) 
            {
                [self setValueforText:txtCarRegnNo andField:@"CARREGNO"];
                [self setValueforText:txtAgreement andField:@"AGREEMENTREF"];
            }
            if ([currMode isEqualToString:@"I"] | [currMode isEqualToString:@"U"]) 
            {
                txtCarRegnNo.enabled = YES;
                txtAgreement.enabled = YES;
            }
            else
            {
                txtCarRegnNo.enabled = NO;
                txtAgreement.enabled = NO;
            }
            break;
        case 10:
            lbl1.text = [[NSString stringWithFormat:@"%@ ",@"Nationality"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
            lbl2.text = [[NSString stringWithFormat:@"%@ ",@"Occupation"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
            
            if (!txtNation) 
                txtNation = (UITextField*) [cell.contentView viewWithTag:2];
            
            if (!txtOccupation)
            {
                txtOccupation = (UITextField*) [cell.contentView viewWithTag:4];
                txtOccupation.delegate = self;
            }
            if (assignValues) 
            {
                [self setValueforText:txtNation andField:@"NATNAME"];
                [self setValueforText:txtOccupation andField:@"OCCUPATION"];
            }
            if ([currMode isEqualToString:@"I"] | [currMode isEqualToString:@"U"]) 
                txtOccupation.enabled = YES;
            else
                txtOccupation.enabled = NO;
            txtNation.enabled = NO;
            btnNationSelect =(UIButton*) [cell.contentView viewWithTag:11];
            if (!btnNationSelect) 
            {
                btnNationSelect = [[UIButton alloc] initWithFrame:CGRectMake(txtNation.frame.origin.x+txtWidth-25, 5, 25, cellHeight-5)];
                btnNationSelect.titleLabel.text=@"";
                [btnNationSelect setImage:[UIImage imageNamed:@"s.png"] forState:UIControlStateNormal];
                [btnNationSelect addTarget:self action:@selector(getNationality:) forControlEvents:UIControlEventTouchDown];
                btnNationSelect.tag = 11;
                [cell.contentView addSubview:btnNationSelect]; 
            }
            [txtNation setFrame:CGRectMake(txtNation.frame.origin.x, txtNation.frame.origin.y, txtWidth-25, txtNation.frame.size.height)];
            btnNationSelect.hidden = NO;
            break;
        case 11:
            lbl1.text = [[NSString stringWithFormat:@"%@ ",@"Employer"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
            lbl2.text = [[NSString stringWithFormat:@"%@ ",@"Billing Name"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
            if (!txtEmployer) 
            {
                txtEmployer = (UITextField*) [cell.contentView viewWithTag:2];
                txtEmployer.delegate = self;
            }
            if (!txtBillName)
            {
                txtBillName = (UITextField*) [cell.contentView viewWithTag:4];
                txtBillName.delegate = self;
            }
            if (assignValues) 
            {
                [self setValueforText:txtEmployer andField:@"EMPLOYER"];
                [self setValueforText:txtBillName andField:@"BILLINGNAME"];
            }
            if ([currMode isEqualToString:@"I"] | [currMode isEqualToString:@"U"]) 
            {
                txtEmployer.enabled = YES;
                txtBillName.enabled = YES;
            }
            else
            {
                txtEmployer.enabled = NO;
                txtBillName.enabled = NO;
            }
            break;
        default:
            break;
    }
    return cell;
}

- (UITableViewCell*) getCellFor2L2T1BLforSection:(int) p_section andRow:(int) p_rowno
{
    static NSString *cellid=@"Cell2L2T1BL";
    UITableViewCell  *cell = [entryTV dequeueReusableCellWithIdentifier:cellid];
    BOOL assignValues = NO;
    UILabel *lbl1, *lbl2;
    UIButton *btnNationSelect;
    UITextField *txt1, *txt2;
    int   lblWidth, txtWidth, cellHeight ;
    lblWidth = 116; txtWidth =232; cellHeight = 40;
    
    UIFont *txtfont = [UIFont systemFontOfSize:14.0f];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[entryTV backgroundColor];
        
        lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(lblPosition, 0, lblWidth-lblPosition, cellHeight-1)];
        lbl1.font = txtfont;
        lbl1.textAlignment = UITextAlignmentRight;
        lbl1.tag = 1;
        lbl1.backgroundColor = [entryTV backgroundColor];
        lbl1.textColor = lblTextColor;
        [cell.contentView addSubview:lbl1];
        
        txt1 = [[UITextField alloc] initWithFrame:CGRectMake(lblWidth, 5, txtWidth, cellHeight-5)];
        txt1.font = txtfont;
        txt1.textAlignment = UITextAlignmentLeft;
        txt1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txt1.tag = 2;
        txt1.backgroundColor = lblTextColor;
        txt1.borderStyle = UITextBorderStyleRoundedRect;
        [cell.contentView addSubview:txt1];
        
        lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(lblWidth+txtWidth+lblPosition, 0,lblWidth-lblPosition , cellHeight-1)];
        lbl2.font = txtfont;
        lbl2.tag = 3;
        lbl2.textAlignment = UITextAlignmentRight;
        lbl2.backgroundColor = [entryTV backgroundColor];
        lbl2.textColor = lblTextColor;
        [cell.contentView addSubview:lbl2];
        
        
        txt2 = [[UITextField alloc] initWithFrame:CGRectMake(2*lblWidth+txtWidth, 5, txtWidth, cellHeight-5)];
        txt2.font = txtfont;
        txt2.tag = 4;
        txt2.textAlignment = UITextAlignmentLeft;
        txt2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txt2.backgroundColor = lblTextColor;
        txt2.borderStyle = UITextBorderStyleRoundedRect;
        [cell.contentView addSubview:txt2];
        assignValues = YES;
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    lbl1 = (UILabel*) [cell.contentView viewWithTag:1];
    
    lbl2 = (UILabel*) [cell.contentView viewWithTag:3];
    switch (p_rowno) {
        case 10:
            lbl1.text = [[NSString stringWithFormat:@"%@ ",@"Nationality"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
            lbl2.text = [[NSString stringWithFormat:@"%@ ",@"Occupation"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
            
            if (!txtNation) 
                txtNation = (UITextField*) [cell.contentView viewWithTag:2];
            
            if (!txtOccupation)
            {
                txtOccupation = (UITextField*) [cell.contentView viewWithTag:4];
                txtOccupation.delegate = self;
            }
            if (assignValues) 
            {
                [self setValueforText:txtNation andField:@"NATNAME"];
                [self setValueforText:txtOccupation andField:@"OCCUPATION"];
            }
            if ([currMode isEqualToString:@"I"] | [currMode isEqualToString:@"U"]) 
                txtOccupation.enabled = YES;
            else
                txtOccupation.enabled = NO;
            txtNation.enabled = NO;
            btnNationSelect =(UIButton*) [cell.contentView viewWithTag:11];
            if (!btnNationSelect) 
            {
                btnNationSelect = [[UIButton alloc] initWithFrame:CGRectMake(txtNation.frame.origin.x+txtWidth-25, 5, 25, cellHeight-5)];
                btnNationSelect.titleLabel.text=@"";
                [btnNationSelect setImage:[UIImage imageNamed:@"s.png"] forState:UIControlStateNormal];
                [btnNationSelect addTarget:self action:@selector(getNationality:) forControlEvents:UIControlEventTouchDown];
                btnNationSelect.tag = 11;
                [cell.contentView addSubview:btnNationSelect]; 
            }
            [txtNation setFrame:CGRectMake(txtNation.frame.origin.x, txtNation.frame.origin.y, txtWidth-25, txtNation.frame.size.height)];
            btnNationSelect.hidden = NO;
            break;
        default:
            break;
    }
    return cell;
}

- (UITableViewCell*) getCellFor3L3T1BforSection:(int) p_section andRow:(int) p_rowno
{
    static NSString *cellid=@"Cell3L3T";
    UITableViewCell  *cell = [entryTV dequeueReusableCellWithIdentifier:cellid];
    UILabel *lbl1, *lbl2, *lbl3;
    UITextField *txt1, *txt2, *txt3;
    BOOL assignValues = NO;
    UIButton *btnEmirateSelect;
    int   lblWidth, txtWidth, cellHeight, txt2Width, lbl3Width ;
    int xPosition, xWidth;
    lblWidth = 116; txtWidth =232;cellHeight = 40;
    
    UIFont *txtfont = [UIFont systemFontOfSize:14.0f];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[entryTV backgroundColor];
        
        
        xPosition = 0; xWidth =lblWidth;
        lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(xPosition+lblPosition, 0, xWidth-lblPosition, cellHeight-1)];
        lbl1.font = txtfont;
        lbl1.textAlignment = UITextAlignmentRight;
        lbl1.tag = 1;
        lbl1.backgroundColor = [entryTV backgroundColor];
        lbl1.textColor = lblTextColor;
        [cell.contentView addSubview:lbl1];
        
        xPosition = lblWidth; xWidth =txtWidth;
        txt1 = [[UITextField alloc] initWithFrame:CGRectMake(xPosition, 5, xWidth, cellHeight-5)];
        txt1.font = txtfont;
        txt1.textAlignment = UITextAlignmentLeft;
        txt1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txt1.tag = 2;
        txt1.backgroundColor = lblTextColor;
        txt1.borderStyle = UITextBorderStyleRoundedRect;
        [cell.contentView addSubview:txt1];
        
        xPosition = lblWidth+txtWidth; xWidth = lblWidth;
        lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(xPosition+lblPosition, 0,xWidth-lblPosition , cellHeight-1)];
        lbl2.font = txtfont;
        lbl2.tag = 3;
        lbl2.textAlignment = UITextAlignmentRight;
        lbl2.backgroundColor = [entryTV backgroundColor];
        lbl2.textColor = lblTextColor;
        [cell.contentView addSubview:lbl2];
        
        switch (p_rowno) {
            case 1:
                txt2Width = txtWidth/5;
                txt2Width = 4* txt2Width;
                break;
            case 3:
                txt2Width = txtWidth/2;
                break;
            case 4:
                txt2Width = txtWidth/2;
                break;
            default:
                break;
        }
        xPosition = xPosition+xWidth; 
        xWidth = txt2Width;
        txt2 = [[UITextField alloc] initWithFrame:CGRectMake(xPosition, 5, xWidth, cellHeight-5)];
        txt2.font = txtfont;
        txt2.tag = 4;
        txt2.textAlignment = UITextAlignmentLeft;
        txt2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txt2.backgroundColor = lblTextColor;
        txt2.borderStyle = UITextBorderStyleRoundedRect;
        [cell.contentView addSubview:txt2];
        
        switch (p_rowno) {
            case 1:
                lbl3Width = txt2Width/8;
                break;
            case 3:
                lbl3Width = txt2Width/2-20;
                break;
            case 4:
                lbl3Width = txt2Width/2-20;
                break;
            default:
                break;
        }
        xPosition = xPosition+xWidth; 
        xWidth = lbl3Width;
        lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 0,xWidth , cellHeight-1)];
        lbl3.font = txtfont;
        lbl3.tag = 5;
        lbl3.textAlignment = UITextAlignmentRight;
        lbl3.backgroundColor = [entryTV backgroundColor];
        lbl3.textColor = lblTextColor;
        [cell.contentView addSubview:lbl3];
        
        xPosition = xPosition+xWidth; xWidth = lbl3Width+40;
        txt3 = [[UITextField alloc] initWithFrame:CGRectMake(xPosition, 5, xWidth, cellHeight-5)];
        txt3.font = txtfont;
        txt3.tag = 6;
        txt3.textAlignment = UITextAlignmentLeft;
        txt3.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txt3.backgroundColor = lblTextColor;
        txt3.borderStyle = UITextBorderStyleRoundedRect;
        [cell.contentView addSubview:txt3];
        assignValues=YES;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    lbl1 = (UILabel*) [cell.contentView viewWithTag:1];
    lbl2 = (UILabel*) [cell.contentView viewWithTag:3];
    lbl3 = (UILabel*) [cell.contentView viewWithTag:5];
    btnEmirateSelect =(UIButton*) [cell.contentView viewWithTag:11];
    
    switch (p_rowno) {
        case 3:
            lbl1.text = [[NSString stringWithFormat:@"%@ ",@"City"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
            lbl2.text = [[NSString stringWithFormat:@"%@ ",@"Emirate"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
            lbl3.text = [[NSString stringWithFormat:@"%@ ",@"PIN"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
            if (!txtTown)
            {
                txtTown = (UITextField*) [cell.contentView viewWithTag:2];
                txtTown.delegate = self;
            }
            if (!txtCounty)
            {
                txtCounty = (UITextField*) [cell.contentView viewWithTag:4];
                txtCounty.delegate =self;
            }
            if (!txtPostcode) 
            {
                txtPostcode = (UITextField*) [cell.contentView viewWithTag:6];
                txtPostcode.delegate = self;
            }
            if (assignValues) 
            {
                [self setValueforText:txtTown andField:@"CITY"];
                [self setValueforText:txtCounty andField:@"EMIRATES"];
                [self setValueforText:txtPostcode andField:@"POSTCODE"];
            }
            if ([currMode isEqualToString:@"I"] | [currMode isEqualToString:@"U"]) 
            {
                txtTown.enabled = YES;
                //txtCounty.enabled = YES;
                txtPostcode.enabled = YES;
            }
            else
            {
                txtTown.enabled = NO;
                //txtCounty.enabled = NO;
                txtPostcode.enabled = NO;
            }
            txtCounty.enabled = NO;
            if (!btnEmirateSelect) 
            {
                btnEmirateSelect = [[UIButton alloc] initWithFrame:CGRectMake(txtCounty.frame.origin.x+txtCounty.frame.size.width-25, 5, 25, cellHeight-5)];
                btnEmirateSelect.titleLabel.text=@"";
                [btnEmirateSelect setImage:[UIImage imageNamed:@"s.png"] forState:UIControlStateNormal];
                [btnEmirateSelect addTarget:self action:@selector(getEmirates:) forControlEvents:UIControlEventTouchDown];
                btnEmirateSelect.tag = 11;
                [cell.contentView addSubview:btnEmirateSelect]; 
                [txtCounty setFrame:CGRectMake(txtCounty.frame.origin.x, txtCounty.frame.origin.y, txtCounty.frame.size.width-25, txtCounty.frame.size.height)];
            }
            btnEmirateSelect.hidden = NO;
            break;
        default:
            break;
    }
    return cell;
}



- (UITableViewCell*) getCellFor3L3TforSection:(int) p_section andRow:(int) p_rowno
{
    static NSString *cellid=@"Cell3L3T";
    UITableViewCell  *cell = [entryTV dequeueReusableCellWithIdentifier:cellid];
    UILabel *lbl1, *lbl2, *lbl3;
    UITextField *txt1, *txt2, *txt3;
    BOOL assignValues = NO;
    //UIButton *btnEmirateSelect;
    int   lblWidth, txtWidth, cellHeight, txt2Width, lbl3Width ;
    int xPosition, xWidth;
    lblWidth = 116; txtWidth =232;cellHeight = 40;
    
    UIFont *txtfont = [UIFont systemFontOfSize:14.0f];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[entryTV backgroundColor];
        
        
        xPosition = 0; xWidth =lblWidth;
        lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(xPosition+lblPosition, 0, xWidth-lblPosition, cellHeight-1)];
        lbl1.font = txtfont;
        lbl1.textAlignment = UITextAlignmentRight;
        lbl1.tag = 1;
        lbl1.backgroundColor = [entryTV backgroundColor];
        lbl1.textColor = lblTextColor;
        [cell.contentView addSubview:lbl1];
        
        xPosition = lblWidth; xWidth =txtWidth;
        txt1 = [[UITextField alloc] initWithFrame:CGRectMake(xPosition, 5, xWidth, cellHeight-5)];
        txt1.font = txtfont;
        txt1.textAlignment = UITextAlignmentLeft;
        txt1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txt1.tag = 2;
        txt1.backgroundColor = lblTextColor;
        txt1.borderStyle = UITextBorderStyleRoundedRect;
        [cell.contentView addSubview:txt1];
        
        xPosition = lblWidth+txtWidth; xWidth = lblWidth;
        lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(xPosition+lblPosition, 0,xWidth-lblPosition , cellHeight-1)];
        lbl2.font = txtfont;
        lbl2.tag = 3;
        lbl2.textAlignment = UITextAlignmentRight;
        lbl2.backgroundColor = [entryTV backgroundColor];
        lbl2.textColor = lblTextColor;
        [cell.contentView addSubview:lbl2];
        
        switch (p_rowno) {
            case 1:
                txt2Width = txtWidth/5;
                txt2Width = 4* txt2Width;
                break;
            case 3:
                txt2Width = txtWidth/2;
                break;
            case 4:
                txt2Width = txtWidth/2;
                break;
            default:
                break;
        }
        xPosition = xPosition+xWidth; 
        xWidth = txt2Width;
        txt2 = [[UITextField alloc] initWithFrame:CGRectMake(xPosition, 5, xWidth, cellHeight-5)];
        txt2.font = txtfont;
        txt2.tag = 4;
        txt2.textAlignment = UITextAlignmentLeft;
        txt2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txt2.backgroundColor = lblTextColor;
        txt2.borderStyle = UITextBorderStyleRoundedRect;
        [cell.contentView addSubview:txt2];
        
        switch (p_rowno) {
            case 1:
                lbl3Width = txt2Width/8;
                break;
            case 3:
                lbl3Width = txt2Width/2-20;
                break;
            case 4:
                lbl3Width = txt2Width/2-20;
                break;
            default:
                break;
        }
        xPosition = xPosition+xWidth; 
        xWidth = lbl3Width;
        lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 0,xWidth , cellHeight-1)];
        lbl3.font = txtfont;
        lbl3.tag = 5;
        lbl3.textAlignment = UITextAlignmentRight;
        lbl3.backgroundColor = [entryTV backgroundColor];
        lbl3.textColor = lblTextColor;
        [cell.contentView addSubview:lbl3];
        
        xPosition = xPosition+xWidth; xWidth = lbl3Width+40;
        txt3 = [[UITextField alloc] initWithFrame:CGRectMake(xPosition, 5, xWidth, cellHeight-5)];
        txt3.font = txtfont;
        txt3.tag = 6;
        txt3.textAlignment = UITextAlignmentLeft;
        txt3.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txt3.backgroundColor = lblTextColor;
        txt3.borderStyle = UITextBorderStyleRoundedRect;
        [cell.contentView addSubview:txt3];
        assignValues=YES;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    lbl1 = (UILabel*) [cell.contentView viewWithTag:1];
    lbl2 = (UILabel*) [cell.contentView viewWithTag:3];
    lbl3 = (UILabel*) [cell.contentView viewWithTag:5];
    
    switch (p_rowno) {
        case 4:
            lbl1.text = [[NSString stringWithFormat:@"%@ ",@"Home Ph."] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
            lbl2.text = [[NSString stringWithFormat:@"%@ ",@"Work Ph."] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
            lbl3.text = [[NSString stringWithFormat:@"%@ ",@"Extn."] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
            if (!txtHomePh)
            {
                txtHomePh = (UITextField*) [cell.contentView viewWithTag:2];
                txtHomePh.delegate = self;
            }
            if (!txtWorkPh)
            {
                txtWorkPh = (UITextField*) [cell.contentView viewWithTag:4];
                txtWorkPh.delegate = self;
            }
            if (!txtExtn) 
            {
                txtExtn = (UITextField*) [cell.contentView viewWithTag:6];
                txtExtn.delegate = self;
            }
            if (assignValues) 
            {
                [self setValueforText:txtHomePh andField:@"HOMEPHONE"];
                [self setValueforText:txtWorkPh andField:@"WORKPHONE"];
                [self setValueforText:txtExtn andField:@"WPEXTEN"];
            }
            if ([currMode isEqualToString:@"I"] | [currMode isEqualToString:@"U"]) 
            {
                txtHomePh.enabled = YES;
                txtWorkPh.enabled = YES;
                txtExtn.enabled = YES;
            }
            else
            {
                txtHomePh.enabled = NO;
                txtWorkPh.enabled = NO;
                txtExtn.enabled = NO;
            }
            break;
        default:
            break;
    }
    
    return cell;
}

- (UITableViewCell*) getCellFor3L2TforSection:(int) p_section andRow:(int) p_rowno
{
    static NSString *cellid=@"Cell3L2T";
    UITableViewCell  *cell = [entryTV dequeueReusableCellWithIdentifier:cellid];
    BOOL assignValues = NO;
    UILabel *lbl1,*lbl11, *lbl2;
    UITextField *txt1, *txt2;
    int   lblWidth, txtWidth, cellHeight, bcWidth, btnWidth, xPosition, xWidth ;
    lblWidth = 116; btnWidth = 48;txtWidth =232;bcWidth =184;cellHeight = 40;
    
    UIFont *txtfont = [UIFont systemFontOfSize:14.0f];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[entryTV backgroundColor];
        
        xPosition = 0; xWidth = lblWidth;
        lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(xPosition+lblPosition, 0, xWidth-lblPosition, cellHeight-1)];
        lbl1.font = txtfont;
        lbl1.textAlignment = UITextAlignmentRight;
        lbl1.tag = 1;
        lbl1.backgroundColor = [entryTV backgroundColor];
        lbl1.textColor = lblTextColor;
        [cell.contentView addSubview:lbl1];
        
        xPosition = xPosition+xWidth; xWidth = txtWidth/2;
        txt1 = [[UITextField alloc] initWithFrame:CGRectMake(xPosition, 5, xWidth-10, cellHeight-5)];
        txt1.font = txtfont;
        txt1.textAlignment = UITextAlignmentLeft;
        txt1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txt1.tag = 2;
        txt1.backgroundColor = lblTextColor;
        txt1.borderStyle = UITextBorderStyleRoundedRect;
        [cell.contentView addSubview:txt1];

        UIButton *btncalender = [[UIButton alloc] initWithFrame:CGRectMake(xPosition+xWidth-10, 5, 25, cellHeight-5)];
        btncalender.titleLabel.text=@"";
        [btncalender setImage:[UIImage imageNamed:@"s.png"] forState:UIControlStateNormal];
        [btncalender addTarget:self action:@selector(displayCalendar:) forControlEvents:UIControlEventTouchDown];
        [cell.contentView addSubview:btncalender];
        
        xPosition = xPosition+xWidth; xWidth = txtWidth/2;
        lbl11 = [[UILabel alloc] initWithFrame:CGRectMake(xPosition+15, 0, xWidth-25, cellHeight-1)];
        lbl11.font = txtfont;
        lbl11.textAlignment = UITextAlignmentRight;
        lbl11.tag = 1;
        lbl11.backgroundColor = [entryTV backgroundColor];
        lbl11.textColor = lblTextColor;
        lbl11.text = [[NSString stringWithFormat:@"%@",@"DD/MM/YYYY"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        [cell.contentView addSubview:lbl11];
        
        lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(lblWidth+txtWidth+lblPosition, 0,lblWidth-lblPosition , cellHeight-1)];
        lbl2.font = txtfont;
        lbl2.tag = 3;
        lbl2.textAlignment = UITextAlignmentRight;
        lbl2.backgroundColor = [entryTV backgroundColor];
        lbl2.textColor = lblTextColor;
        [cell.contentView addSubview:lbl2];
        
        txt2 = [[UITextField alloc] initWithFrame:CGRectMake(2*lblWidth+txtWidth, 5, txtWidth, cellHeight-5)];
        txt2.font = txtfont;
        txt2.tag = 4;
        txt2.textAlignment = UITextAlignmentLeft;
        txt2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txt2.backgroundColor = lblTextColor;
        txt2.borderStyle = UITextBorderStyleRoundedRect;
        [cell.contentView addSubview:txt2];
        assignValues = YES;
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    lbl1 = (UILabel*) [cell.contentView viewWithTag:1];
    
    lbl2 = (UILabel*) [cell.contentView viewWithTag:3];
    
    lbl1.text = [[NSString stringWithFormat:@"%@ ",@"Date of birth"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    lbl2.text = [[NSString stringWithFormat:@"%@ ",@"Password"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    if (!txtDOB) 
    {
        txtDOB = (UITextField*) [cell.contentView viewWithTag:2];
        txtDOB.enabled = NO;
    }
    if (!txtPWd)
    {
        txtPWd = (UITextField*) [cell.contentView viewWithTag:4];
        txtPWd.delegate = self;
    }
    
    if (assignValues) 
    {
        [self setValueforText:txtDOB andField:@"BIRTHDATE"];
        [self setValueforText:txtPWd andField:@"MBRSVCPWD"];
    }
    
    if ([currMode isEqualToString:@"I"] | [currMode isEqualToString:@"U"]) 
        txtPWd.enabled = YES;
    else
        txtPWd.enabled = NO;
    txtDOB.enabled = NO;
    return cell;
}


- (UITableViewCell*) getCellFor2L2T1BRforSection:(int) p_section andRow:(int) p_rowno
{
    static NSString *cellid=@"Cell2L2T1B";
    UITableViewCell  *cell = [entryTV dequeueReusableCellWithIdentifier:cellid];
    BOOL assignValues = NO;
    UILabel *lbl1, *lbl2;
    UITextField *txt1, *txt2;
    UIButton *btn1;
    int   lblWidth, txtWidth, cellHeight, bcWidth, btnWidth ;
    lblWidth = 116; btnWidth = 39;txtWidth =232;bcWidth =193;cellHeight = 40;
     
    UIFont *txtfont = [UIFont systemFontOfSize:14.0f];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] 
                 initWithStyle:UITableViewCellStyleSubtitle
                 reuseIdentifier:cellid];
        cell.backgroundColor=[entryTV backgroundColor];
        
        lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(lblPosition, 0, lblWidth-lblPosition, cellHeight-1)];
        lbl1.font = txtfont;
        lbl1.textAlignment = UITextAlignmentRight;
        lbl1.tag = 1;
        lbl1.backgroundColor = [entryTV backgroundColor];
        lbl1.textColor = lblTextColor;
        [cell.contentView addSubview:lbl1];
        
        txt1 = [[UITextField alloc] initWithFrame:CGRectMake(lblWidth, 5, bcWidth, cellHeight-5)];
        txt1.font = txtfont;
        txt1.textAlignment = UITextAlignmentLeft;
        txt1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txt1.tag = 2;
        txt1.backgroundColor = [UIColor whiteColor];
        txt1.borderStyle = UITextBorderStyleRoundedRect;
        [cell.contentView addSubview:txt1];
        
        UIImage *addImage = [UIImage imageNamed:@"Add.png"];
        btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn1 setFrame:CGRectMake(lblWidth+bcWidth, 5, btnWidth, cellHeight-5)];
        //[btn1 setTitle:@"New" forState:UIControlStateNormal];
        [btn1 setImage:addImage forState:UIControlStateNormal];
        [btn1 setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:89.0/255.0f alpha:1.0f]];
        [btn1 addTarget:self action:@selector(generateNewBarCode:) forControlEvents:UIControlEventTouchDown];
        [cell.contentView addSubview:btn1];
        
        lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(lblWidth+txtWidth+lblPosition, 0,lblWidth-lblPosition , cellHeight-1)];
        lbl2.font = txtfont;
        lbl2.tag = 3;
        lbl2.textAlignment = UITextAlignmentRight;
        lbl2.backgroundColor = [entryTV backgroundColor];
        lbl2.textColor = lblTextColor;
        [cell.contentView addSubview:lbl2];
        
        
        txt2 = [[UITextField alloc] initWithFrame:CGRectMake(2*lblWidth+txtWidth, 5, txtWidth, cellHeight-5)];
        txt2.font = txtfont;
        txt2.tag = 4;
        txt2.textAlignment = UITextAlignmentLeft;
        txt2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txt2.backgroundColor = [UIColor whiteColor];
        txt2.borderStyle = UITextBorderStyleRoundedRect;
        [cell.contentView addSubview:txt2];
        assignValues = YES;

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    lbl1 = (UILabel*) [cell.contentView viewWithTag:1];
    lbl1.text = [[NSString stringWithFormat:@"%@ ",@"Bar Code"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    if (!txtBarcode) 
    {
        txtBarcode = (UITextField*) [cell.contentView viewWithTag:2];
        txtBarcode.delegate = self;
    }
        
    
    lbl2 = (UILabel*) [cell.contentView viewWithTag:3];
    lbl2.text = [[NSString stringWithFormat:@"%@ ",@"Agreement Ref"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    
    if (!txtLocation)
    {
        txtLocation = (UITextField*) [cell.contentView viewWithTag:4];
        txtLocation.delegate = self;
    }
    
    if (assignValues) 
    {
        [self setValueforText:txtBarcode andField:@"BARCODE"];
        [self setValueforText:txtLocation andField:@"AGREEMENTREF"];
    }
    
    if ([currMode isEqualToString:@"I"] | [currMode isEqualToString:@"U"]) 
    {
        txtBarcode.enabled = YES;
        txtLocation.enabled = YES;
    }
    else
    {
        txtBarcode.enabled = NO;
        txtLocation.enabled = NO;
    }
    return cell;
}


- (IBAction)generateNewBarCode:(id)sender
{
    /*if ([currMode isEqualToString:@"I"] | [currMode isEqualToString:@"U"]) 
            gymProxy = [[gymWSProxy alloc] initWithReportType:@"NEWBARCODE" andInputParams:nil andNotificatioName:@"barCodeGenNotify"];        */
}

- (IBAction) displayCalendar:(id) sender
{
    if ([currMode isEqualToString:@"I"] | [currMode isEqualToString:@"U"]) 
    {

        dobPicker = [[UIDatePicker alloc] init];
        dobPicker.frame=CGRectMake(20, 25.0, 240.0, 150.0);
        dobPicker.datePickerMode = UIDatePickerModeDate;
        
        [dobPicker setDate:[NSDate date]];
        
        dAlert = [[UIAlertView alloc] initWithTitle:@"Pick a date" message:@"\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Select", nil];
        dAlert.cancelButtonIndex = 0;
        dAlert.delegate = self;
        [dAlert addSubview:dobPicker];
        [dAlert show];
    }
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=0) 
    {
        NSDate *date = [dobPicker date];
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init] ;
        [dateFormatter setDateFormat:(NSString*) @"dd/MM/yyyy"];
        txtDOB.text = [dateFormatter stringFromDate:date];
        //_dob = [[NSString alloc] initWithFormat:@"%@", txtDOB.text];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    shouldScroll = true;
    [_parentScroll setContentOffset:scrollOffset animated:NO]; 
    /*if ([textField isEqual:txtBarcode]) 
        [txtLocation becomeFirstResponder];
    else if ([textField isEqual:txtLocation])
		[txtFirstname becomeFirstResponder];
    else */if([textField isEqual:txtFirstname])
        [txtSurname becomeFirstResponder];
    else if([textField isEqual:txtSurname])
        /*[txtLocation becomeFirstResponder];
    else if([textField isEqual:txtLocation])*/
        [txtAddress1 becomeFirstResponder];
    else if([textField isEqual:txtAddress1])
        [txtAddress2 becomeFirstResponder];
    else if([textField isEqual:txtAddress2])
        [txtTown becomeFirstResponder];
    else if([textField isEqual:txtTown])
        [txtTown resignFirstResponder];
        /*[txtCounty becomeFirstResponder];
    else if([textField isEqual:txtCounty])
		[txtPostcode becomeFirstResponder];*/
    else if ([textField isEqual:txtPostcode])
		[txtHomePh becomeFirstResponder];
    else if([textField isEqual:txtHomePh])
        [txtWorkPh becomeFirstResponder];
    else if([textField isEqual:txtWorkPh])
        [txtExtn becomeFirstResponder];
    else if([textField isEqual:txtExtn])
        [txtMobile becomeFirstResponder];
    else if([textField isEqual:txtMobile])
        [txtMobile resignFirstResponder];
    else if([textField isEqual:txtEmerContact])
        [txtEmerPh becomeFirstResponder];
    else if([textField isEqual:txtEmerPh])
        [txtEmail becomeFirstResponder];
    else if([textField isEqual:txtEmail])
        [txtMbrLogin becomeFirstResponder];
    else if([textField isEqual:txtMbrLogin])
        [txtMbrLogin resignFirstResponder];
    else if([textField isEqual:txtPWd])
        [txtCarRegnNo becomeFirstResponder];
    else if([textField isEqual:txtCarRegnNo])
        [txtAgreement becomeFirstResponder];
    else if([textField isEqual:txtAgreement])
        [txtAgreement resignFirstResponder];
    /*else if([textField isEqual:txtNatIns])
        [txtOccupation becomeFirstResponder];*/
    else if([textField isEqual:txtOccupation])
        [txtEmployer becomeFirstResponder];
    else if([textField isEqual:txtEmployer])
        [txtBillName becomeFirstResponder];
    else if([textField isEqual:txtBillName])
        [txtBillName resignFirstResponder];
    [self setCaseProper:textField];
	return NO;
}

- (void) setCaseProper:(UITextField*) p_passField
{
    NSString *oldVal = [NSString stringWithString:p_passField.text];

    if ([p_passField isEqual:txtFirstname] | [p_passField isEqual:txtSurname]) 
    {
        if ([oldVal length]>0)
            p_passField.text = [p_passField.text uppercaseString];
    }
    else if ([p_passField isEqual:txtEmail]==NO)
    {
        if ([oldVal length]>0)
            p_passField.text =[NSString stringWithFormat:@"%@%@", [[oldVal substringToIndex:1] uppercaseString] , [[oldVal substringFromIndex:1] lowercaseString]] ;
    }
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    //NSLog(@"text field did begin editing starts");
    if (shouldScroll) {
        scrollOffset = _parentScroll.contentOffset;
        CGPoint scrollPoint;
        CGRect inputFieldBounds = [textField bounds];
        inputFieldBounds = [textField convertRect:inputFieldBounds toView:_parentScroll];
        scrollPoint =  _parentScroll.bounds.origin; 
        scrollPoint.x = 0;
        if (UIInterfaceOrientationIsLandscape(currOrientation)) 
        {
            if ([textField isEqual:txtMobile]) 
                scrollPoint.y = 45;
            else if ([textField isEqual:txtEmerContact] | [textField isEqual:txtEmerPh]) 
                scrollPoint.y = 90;
            else if ([textField isEqual:txtEmail] | [textField isEqual:txtMbrLogin]) 
                scrollPoint.y = 135;
            else if ([textField isEqual:txtPWd])
                scrollPoint.y = 180;
            else if ([textField isEqual:txtCarRegnNo] | [textField isEqual:txtAgreement])
                scrollPoint.y = 215;
            else if ([textField isEqual:txtOccupation])
                scrollPoint.y = 260;
            else if ([textField isEqual:txtEmployer] | [textField isEqual:txtBillName])
                scrollPoint.y = 305;
            else
                scrollPoint.y=0;
        }
        [_parentScroll setContentOffset:scrollPoint animated:NO];  
        shouldScroll = false;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string 
{
        return YES;
}

- (void) setEmptyMode
{
    currMode = [[NSString alloc] initWithFormat:@"%@",@""];
    if (!entryTV) 
        [self generateTableView];
    [self clearScreen];
    [self setFieldsEntryStatus:NO];
}

- (void) clearScreen
{
    if (txtBarcode) txtBarcode.text = @"";
    if (txtLocation) txtLocation.text = @"";
    if (txtSurname) txtSurname.text = @"";
    if (txtFirstname) txtFirstname.text = @"";
    //if (txtMiddle) txtMiddle.text = @"";
    if (txtAddress1) txtAddress1.text = @"";
    if (txtAddress2) txtAddress2.text = @"";
    if (txtTown) txtTown.text = @"";
    if (txtCounty) txtCounty.text = @"";
    if (txtPostcode) txtPostcode.text = @"";
    if (txtHomePh) txtHomePh.text = @"";
    if (txtWorkPh) txtWorkPh.text = @"";
    if (txtExtn) txtExtn.text = @"";
    if (txtMobile) txtMobile.text = @"";
    if (txtEmerContact) txtEmerContact.text = @"";
    if (txtEmerPh) txtEmerPh.text = @"";
    if (txtEmail) txtEmail.text = @"";
    if (txtMbrLogin) txtMbrLogin.text = @"";
    if (txtDOB) txtDOB.text = @"";
    if (txtPWd) txtPWd.text = @"";
    if (txtCarRegnNo) txtCarRegnNo.text = @"";
    if (txtAgreement) txtAgreement.text = @"";
    if (txtNation) txtNation.text = @"";
    if (txtOccupation) txtOccupation.text = @"";
    if (txtEmployer) txtEmployer.text = @"";
    if (txtBillName) txtBillName.text = @"";
    if (scGender) scGender.selectedSegmentIndex = 0;
}

- (void) setFieldsEntryStatus:(BOOL) p_Status
{
    //if (txtBarcode) txtBarcode.enabled = p_Status;
    //if (txtLocation) txtLocation.enabled = p_Status;
    if (txtSurname) txtSurname.enabled = p_Status;
    if (txtFirstname) txtFirstname.enabled = p_Status;
    //if (txtMiddle) txtMiddle.text = @"";
    if (txtAddress1) txtAddress1.enabled = p_Status;
    if (txtAddress2) txtAddress2.enabled = p_Status;
    if (txtTown) txtTown.enabled = p_Status;
    //if (txtCounty) txtCounty.enabled = p_Status;
    if (txtPostcode) txtPostcode.enabled = p_Status;
    if (txtHomePh) txtHomePh.enabled = p_Status;
    if (txtWorkPh) txtWorkPh.enabled = p_Status;
    if (txtExtn) txtExtn.enabled = p_Status;
    if (txtMobile) txtMobile.enabled = p_Status;
    if (txtEmerContact) txtEmerContact.enabled = p_Status;
    if (txtEmerPh) txtEmerPh.enabled = p_Status;
    if (txtEmail) txtEmail.enabled = p_Status;
    if (txtMbrLogin) txtMbrLogin.enabled = p_Status;
    //if (txtDOB) txtDOB.enabled = p_Status;
    if (txtPWd) txtPWd.enabled = p_Status;
    if (txtCarRegnNo) txtCarRegnNo.enabled = p_Status;
    if (txtAgreement) txtAgreement.enabled = p_Status;
    //if (txtNatIns) txtNatIns.enabled = p_Status;
    if (txtOccupation) txtOccupation.enabled = p_Status;
    if (txtEmployer) txtEmployer.enabled = p_Status;
    if (txtBillName) txtBillName.enabled = p_Status;
    if (scGender) scGender.enabled = p_Status;
    if (btnTakePhoto) btnTakePhoto.enabled = p_Status;
}


- (void) setInsertMode
{
    currMode = [[NSString alloc] initWithFormat:@"%@",@"I"];
    [self clearScreen];
    [self setFieldsEntryStatus:YES];
    //[self displayDictDataForMode:currMode];
    _initDict = nil;
    txtBarcode.text = @"(Auto)";
    //NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
    NSString* noPictPath = [[NSBundle mainBundle] pathForResource:@"NoPhoto2" ofType:@"png"];
    NSURL* noPictURL = [NSURL URLWithString:noPictPath];
    [stdDefaults setValue:[NSData dataWithContentsOfURL:noPictURL] forKey:@"currimage"];
    if (memberPhoto) 
        memberPhoto.image = [UIImage imageNamed:@"NoPhoto2.png"];
    //[self generateNewBarCode:nil];
}

/*- (void) newBarCodeGenerated :(NSNotification*) barCodeInfo
{
    NSDictionary *recdData = [barCodeInfo userInfo];
   // NSLog(@"received dat ais %@", recdData);
    NSArray *barCodeData = [[NSArray alloc] initWithArray:[recdData valueForKey:@"data"] copyItems:YES];
    NSDictionary *firstCode = [barCodeData objectAtIndex:0];
    txtBarcode.text = [[NSString alloc] initWithFormat:@"%@", [firstCode valueForKey:@"BarCode"]];
    firstCode = nil;
    barCodeData = nil;
    recdData = nil;
}
*/
- (IBAction)getEmirates:(id)sender
{
    if ([currMode isEqualToString:@"I"] | [currMode isEqualToString:@"U"]) 
    {
        NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
        [returnInfo setValue:[NSString stringWithString:@"SelectEmirate"] forKey:@"notify"];
        _emirateNotifyMethod(returnInfo);
    }
}

- (void) setEmirates:(NSDictionary*) p_passedDict
{
    //_county = ;
    if (txtCounty) 
        txtCounty.text = [p_passedDict valueForKey:@"data"];
}
- (IBAction)getLocation:(id)sender
{
    if ([currMode isEqualToString:@"I"] | [currMode isEqualToString:@"U"]) 
    {
        NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
        [returnInfo setValue:[NSString stringWithString:@"SelectLocation"] forKey:@"notify"];
        _locationNotifyMethod(returnInfo);
    }
}

- (IBAction)getNationality:(id)sender
{
    if ([currMode isEqualToString:@"I"] | [currMode isEqualToString:@"U"]) 
    {
        NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
        [returnInfo setValue:[NSString stringWithString:@"SelectNation"] forKey:@"notify"];
        _nationNotifyMethod(returnInfo);
    }
}

- (void) setNationality:(NSDictionary*) p_passedDict
{
    NSDictionary *recdData = [p_passedDict valueForKey:@"data"];
    if (txtNation) 
    {
        txtNation.text = [recdData valueForKey:@"NATNAME"];
        _nationid = [[recdData valueForKey:@"NATIONALITYID"] intValue];
    }
}

- (void) setLocation:(NSDictionary*) p_passedDict
{
    NSDictionary *recdData = [p_passedDict valueForKey:@"data"];
    if (txtLocation) 
    {
        txtLocation.text = [recdData valueForKey:@"GYMNAME"];
        _locationid = [[recdData valueForKey:@"GYMLOCATIONID"] intValue];
    }
}

- (NSString*) getXMLDataForSave
{
    NSString *returnXML;
    NSUserDefaults *standardUserDefaults=[NSUserDefaults standardUserDefaults];

    if ([currMode isEqualToString:@"I"])
        returnXML = [[NSString alloc] initWithFormat:MEMBERDATA_XML, @"0", @"", txtFirstname.text, txtSurname.text, txtLocation.text, txtAddress1.text, txtAddress2.text, txtTown.text, txtCounty.text, txtPostcode.text, txtHomePh.text,txtMobile.text, txtEmerContact.text, txtEmail.text, txtDOB.text, txtCarRegnNo.text, txtOccupation.text, txtEmployer.text, txtBillName.text, txtWorkPh.text, txtExtn.text, scGender.selectedSegmentIndex, txtEmerPh.text, txtMbrLogin.text, txtPWd.text, _nationid, [standardUserDefaults valueForKey:@"USERCODE"], _locationid];
    else
        returnXML = [[NSString alloc] initWithFormat:MEMBERDATA_XML, [_initDict valueForKey:@"MEMBERID"]   , txtBarcode.text, txtFirstname.text, txtSurname.text, txtLocation.text, txtAddress1.text, txtAddress2.text, txtTown.text, txtCounty.text, txtPostcode.text, txtHomePh.text, txtMobile.text, txtEmerContact.text, txtEmail.text, txtDOB.text, txtCarRegnNo.text, txtOccupation.text, txtEmployer.text, txtBillName.text, txtWorkPh.text, txtExtn.text, scGender.selectedSegmentIndex, txtEmerPh.text, txtMbrLogin.text, txtPWd.text, _nationid, [standardUserDefaults valueForKey:@"USERCODE"], _locationid];
        
    returnXML = [self htmlEntitycode:returnXML];
                  
    return returnXML;
}

- (BOOL) validateEntries
{
    BOOL l_resultVal;
    //[self storeDispValues];
    l_resultVal = [self emptyCheckResult:txtLocation andMessage:@"Location should be selected"];

    
    if (l_resultVal==NO) 
        return l_resultVal;
    else
        l_resultVal = [self emptyCheckResult:txtFirstname andMessage:@"First Name should be entered"];

    if (l_resultVal==NO) 
        return l_resultVal;
    else
        l_resultVal = [self emptyCheckResult:txtSurname andMessage:@"Last Name should be entered"] ;
        
    if (l_resultVal==NO) 
        return l_resultVal;
    else
        l_resultVal = [self emptyCheckResult:txtTown andMessage:@"City should be entered"];
    
    if (l_resultVal==NO) 
        return l_resultVal;
    else
        l_resultVal = [self emptyCheckResult:txtCounty andMessage:@"Emirate should be selected"];

    if (l_resultVal==NO) 
        return l_resultVal;
    else
        l_resultVal = [self emptyCheckResult:txtNation andMessage:@"Nationality should be selected"];

    if (l_resultVal==NO) 
        return l_resultVal;
    else
        l_resultVal = [self emptyCheckResult:txtEmail andMessage:@"E-Mail should be entered"];

    if (l_resultVal==NO) 
        return l_resultVal;
    else
        l_resultVal = [self emptyCheckResult:txtDOB andMessage:@"Birth date should be entered"];

    if (l_resultVal==NO) 
        return l_resultVal;
    else
        l_resultVal = [self emptyCheckResult:txtMbrLogin andMessage:@"Login should be entered"];

    if (l_resultVal==NO) 
        return l_resultVal;
    else
        l_resultVal = [self emptyCheckResult:txtPWd andMessage:@"Password should be entered"];

    
    /*if (l_resultVal==NO) 
        return l_resultVal;
    else
    {
        if ([txtPWd.text isEqualToString:txtAgreement.text]==NO) 
        {
            [self showAlertMessage:@"Password confirmation failed"];
            return  NO;
        }
    }*/
    
    return  YES;
}

- (BOOL) emptyCheckResult:(UITextField*) p_passField andMessage:(NSString*) p_errMsg
{
    if (p_passField) 
    {
        if ([p_passField.text isEqualToString:@""]) 
        {
            [self showAlertMessage:p_errMsg];
            return  NO;
        }
    }
    else
    {
        [self showAlertMessage:p_errMsg];
        return  NO;
    }
    return YES;
}

- (void) storeDispValues
{

}

- (void) initializeVariables
{
    lblPosition=0;    
}

- (void) showAlertMessage:(NSString *) dispMessage
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:dispMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

- (void) setListMode:(NSDictionary*) p_dictData
{
    currMode = @"L";
    //NSLog(@"received dictionary info %@", p_dictData);
    if (p_dictData) 
    {
        _initDict = [[NSDictionary alloc] initWithDictionary:p_dictData copyItems:YES];
        [self displayDictDataForMode:currMode];
    }
    else
        _initDict = nil;
    [self setFieldsEntryStatus:NO];
    //pictureChanged = NO;
    /*if (memView)
        [memView setListMode:p_dictData];*/
}

- (void) displayDictDataForMode:(NSString*) p_dispmode
{
    NSURL *urlPath;
    
    [self setValueforText:txtBarcode andField:@"BARCODE"];
    [self setValueforText:txtLocation andField:@"GYMNAME"];
    [self setValueforText:txtFirstname andField:@"FIRSTNAME"];
    [self setValueforText:txtSurname andField:@"LASTNAME"];
    [self setValueforText:txtAddress1 andField:@"ADDRESS1"];
    [self setValueforText:txtAddress2 andField:@"ADDRESS2"];
    [self setValueforText:txtTown andField:@"CITY"];
    [self setValueforText:txtCounty andField:@"EMIRATES"];
    [self setValueforText:txtPostcode andField:@"POSTCODE"];
    [self setValueforText:txtMobile andField:@"MOBILEPHONE"];
    [self setValueforText:txtNation andField:@"NATNAME"];
    [self setValueforText:txtHomePh andField:@"HOMEPHONE"];
    [self setValueforText:txtEmerContact andField:@"EMERCONTACT"];
    [self setValueforText:txtEmail andField:@"EMAIL"];
    [self setValueforText:txtDOB andField:@"BIRTHDATE"];
    [self setValueforText:txtCarRegnNo andField:@"CARREGNO"];
    [self setValueforText:txtOccupation andField:@"OCCUPATION"];
    [self setValueforText:txtEmployer andField:@"EMPLOYER"];
    [self setValueforText:txtBillName andField:@"BILLINGNAME"];
    [self setValueforText:txtWorkPh andField:@"WORKPHONE"];
    [self setValueforText:txtExtn andField:@"WPEXTEN"];
    if (scGender) 
        if ([_initDict valueForKey:@"GENDER"]) 
            scGender.selectedSegmentIndex = [[_initDict valueForKey:@"GENDER"] intValue];
    [self setValueforText:txtEmerPh andField:@"EMERPHONE"];
    [self setValueforText:txtMbrLogin andField:@"MBRSVCLOGIN"];
    [self setValueforText:txtPWd andField:@"MBRSVCPWD"];
    [self setValueforText:txtAgreement andField:@"AGREEMENTREF"];
    urlPath = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@//Images//m%d.jpeg",MAIN_URL, WS_ENV, [[_initDict valueForKey:@"MEMBERID"]intValue]]];
    NSString *imgName = [[NSString alloc] initWithFormat:@"Image%d",[_initDict valueForKey:@"MEMBERID"]];
    if (![stdDefaults valueForKey:imgName]) 
        [stdDefaults setValue:[NSData dataWithContentsOfURL:urlPath] forKey:imgName];
    
    if (memberPhoto) 
        memberPhoto.image = [UIImage imageWithData:[stdDefaults valueForKey:imgName]];
    
}

- (void) setValueforText:(UITextField*) p_passField andField:(NSString*) p_fieldName
{
    if (p_passField) 
        if ([_initDict valueForKey:p_fieldName]) 
            p_passField.text = [_initDict valueForKey:p_fieldName];
        else
            p_passField.text = @"";
    
    if ([p_fieldName isEqualToString:@"NATNAME"]) 
    {
        _nationid = [[_initDict valueForKey:@"NATIONALITYID"] intValue];
    }
    
    if ([p_fieldName isEqualToString:@"GYMNAME"]) 
    {
        _locationid = [[_initDict valueForKey:@"LOCATIONID"] intValue];
    }
}

- (IBAction)grabPhoto:(id)sender
{
    if ([currMode isEqualToString:@"I"] | [currMode isEqualToString:@"U"]) 
    {
        _photoNotifyMethod(nil);
    }
}

- (void) newPhotoTaken:(NSDictionary*) photoInfo
{
    memberPhoto.image = (UIImage*) [photoInfo valueForKey:@"photo"];
}

- (NSString*) getImageString
{
    UIImageWriteToSavedPhotosAlbum(memberPhoto.image, nil, nil, nil);
    //dataObj = UIImageJPEGRepresentation(memberPhoto.image,1.0);
    dataObj = UIImagePNGRepresentation(memberPhoto.image);
    Base64 *bb = [[Base64 alloc] init];
    NSString * actualString= [bb encode:dataObj];
    //NSLog(@"the image string value is %@",actualString);
    return  actualString;
}

-(NSString *)htmlEntitycode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"];
    string = [string stringByReplacingOccurrencesOfString:@"'" withString:@"&apos;"];
    string = [string stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    string = [string stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    string = [string stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    return string;
}

- (void) setBarCode:(NSString*) p_barCode
{
    txtBarcode.text = p_barCode;
}


- (void) setEditMode
{
    currMode = @"U";
    //NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
    NSString *imgName = [[NSString alloc] initWithFormat:@"Image%d",[_initDict valueForKey:@"MEMBERID"]];
    [stdDefaults setValue:[stdDefaults valueForKey:imgName] forKey:@"currimage"];
    //[stdDefaults setValue:nil forKey:imgName];
    [self setFieldsEntryStatus:YES];
}

- (void) performAfterSave:(NSDictionary *)p_savedInfo
{
    currMode = @"L";
    [self setFieldsEntryStatus:NO];
}

- (void) saveImagetoCache:(NSString*) p_newMemberId
{
    //NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
    NSString *imgName = [[NSString alloc] initWithFormat:@"Image%d",p_newMemberId];
    [stdDefaults setValue:dataObj forKey:imgName];
}

- (void) keyboardDidHide:(NSNotification*) keyboardInfo
{
    //NSLog(@"received keyboard info %@", keyboardInfo);
    //if (shouldScroll) {
        scrollOffset = _parentScroll.contentOffset;
        CGPoint scrollPoint;
        scrollPoint =  _parentScroll.bounds.origin; 
        scrollPoint.x = 0;
        scrollPoint.y=0;
        [_parentScroll setContentOffset:scrollPoint animated:NO];  
        shouldScroll = true;
    //}
}

@end
