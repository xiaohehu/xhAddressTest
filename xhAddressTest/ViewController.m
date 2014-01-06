//
//  ViewController.m
//  xhAddressTest
//
//  Created by Xiaohe Hu on 1/2/14.
//  Copyright (c) 2014 Xiaohe Hu. All rights reserved.
//

#import "ViewController.h"

#define kRecipient @"INFO@NEOSCAPE.COM"
#define kSUBJECT @"Contact From App"
#define kMAILBODY @"This email was sent from *app*"
#define kDefaultMailBody @"This is the default mail body from *app*"

@interface ViewController ()
@property (nonatomic, strong)NSData *vCardData;
@property (nonatomic, strong)NSData *default_Vcard;
@end

@implementation ViewController
@synthesize uil_firstName, uil_phoneNum;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showPicker:(id)sender {
    ABPeoplePickerNavigationController *picker =
    [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)sendContact:(id)sender {
    
//    NSArray *arr_recipients = [[NSArray alloc] initWithObjects:kRecipient, nil];
//    if ([MFMailComposeViewController canSendMail] == YES) {
//        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
//        picker.mailComposeDelegate = self; // &lt;- very important step if you want feedbacks on what the user did with your email sheet
//        [picker addAttachmentData:_vCardData mimeType:@"text/vcard" fileName:@"vcard.vcf"];
//        [picker setToRecipients:arr_recipients];
//        [picker setSubject:kSUBJECT];
//        [picker setMessageBody:kMAILBODY isHTML:NO];// depends. Mostly YES, unless you want to send it as plain text (boring)
//        
//        //        picker.navigationBar.barStyle = UIBarStyleBlack; // choose your style, unfortunately, Translucent colors behave quirky.
//        [self presentViewController:picker animated:YES completion:nil];
//    } else {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Status" message:[NSString stringWithFormat:@"Email needs to be configured before this device can send email. \n\n Use nsq@neoscape.com on a device capable of sending email."]
//                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
//    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Email" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Default Email", @"Send Vcard", @"Blank Email", nil];
    [actionSheet showInView:self.view];
}
-(void)generateEmailByIndex:(int)index
{
    NSArray *arr_recipients = [[NSArray alloc] initWithObjects:kRecipient, nil];
    if ([MFMailComposeViewController canSendMail] == YES) {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self; // &lt;- very important step if you want feedbacks on what the user did with your email sheet
        if (index == 0) {
            [picker setToRecipients:arr_recipients];
            [picker setSubject:kSUBJECT];
            [picker setMessageBody:kDefaultMailBody isHTML:NO];
        }
        else if (index == 1){
            if (_vCardData == nil) {
                [self generateDefaultVcard];
                [picker addAttachmentData:_default_Vcard mimeType:@"text/vcard" fileName:@"default_vcard.vcf"];
            }
            else{
                [picker addAttachmentData:_vCardData mimeType:@"text/vcard" fileName:@"vcard.vcf"];
            }
            [picker setToRecipients:arr_recipients];
            [picker setSubject:kSUBJECT];
            [picker setMessageBody:kMAILBODY isHTML:NO];
        }
        else if (index == 2){
            [picker setToRecipients:nil];
            [picker setSubject:nil];
            [picker setMessageBody:nil isHTML:NO];
        }
        
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Status" message:[NSString stringWithFormat:@"Email needs to be configured before this device can send email. \n\n Use nsq@neoscape.com on a device capable of sending email."]
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}
#pragma mark - ActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
        case 1:
        case 2:
            [self generateEmailByIndex:buttonIndex];
            break;
        case 3:
            break;
        default:
            break;
    }
}
#pragma mark - Generate Default Vcard
-(void)generateDefaultVcard
{
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    
    [mutableArray addObject:@"BEGIN:VCARD"];
    
    [mutableArray addObject:@"VERSION:3.0"];
    
    [mutableArray addObject:@"N:Buxton;Evan;;;"];
    
    [mutableArray addObject:@"FN:Evan Buxton"];
    
    [mutableArray addObject:@"ORG:Neoscape"];
    
    [mutableArray addObject:@"ADR:23 Drydock Ave"];
    
    [mutableArray addObject:@"TEL:617-121-1212"];
    
    [mutableArray addObject:@"EMAIL:evan.buxton@neoscape.com"];
    
    [mutableArray addObject:@"END:VCARD"];
    
    NSString *string = [mutableArray componentsJoinedByString:@"\n"];
    
    self.default_Vcard = [string dataUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark - Delegate of ABPeoplePicker
- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    [self displayPerson:person];
    [self dismissViewControllerAnimated:YES completion:nil];

    return NO;
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}
- (void)displayPerson:(ABRecordRef)person
{
    NSString* name = (__bridge_transfer NSString*)ABRecordCopyValue(person,
                                                                    kABPersonFirstNameProperty);
    self.uil_firstName.text = name;
    
    NSString* phone = nil;
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,
                                                     kABPersonPhoneProperty);
    if (ABMultiValueGetCount(phoneNumbers) > 0) {
        phone = (__bridge_transfer NSString*)
        ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
    } else {
        phone = @"[None]";
    }
    self.uil_phoneNum.text = phone;
    CFRelease(phoneNumbers);
    // Put ABRecordRef into a CFArray 
    CFArrayRef peopleArray = CFArrayCreate(NULL, (void *)&person, 1, &kCFTypeArrayCallBacks);
    _vCardData = CFBridgingRelease(ABPersonCreateVCardRepresentationWithPeople(peopleArray));
    NSString *vCard = [[NSString alloc] initWithData:_vCardData encoding:NSUTF8StringEncoding];
    NSLog(@"vCard > %@", vCard);
}

#pragma mark - Mail Composer
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thank you!" message:@"Email Sent Successfully"
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
            break;
        case MFMailComposeResultFailed:
            break;
            
        default:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Status" message:@"Sending Failed - Unknown Error"
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{  }
@end
