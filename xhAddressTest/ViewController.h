//
//  ViewController.h
//  xhAddressTest
//
//  Created by Xiaohe Hu on 1/2/14.
//  Copyright (c) 2014 Xiaohe Hu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import <MessageUI/MessageUI.h>

@interface ViewController : UIViewController <ABPeoplePickerNavigationControllerDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *uil_firstName;
@property (strong, nonatomic) IBOutlet UILabel *uil_phoneNum;


- (IBAction)showPicker:(id)sender;
- (IBAction)sendContact:(id)sender;

@end
