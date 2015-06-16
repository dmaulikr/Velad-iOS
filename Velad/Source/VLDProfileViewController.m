//
//  VLDProfileViewController.m
//  Velad
//
//  Created by Renzo Crisóstomo on 16/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDProfileViewController.h"
#import "VLDProfile.h"
#import <Realm/Realm.h>
#import "VLDErrorPresenter.h"

@interface VLDProfileViewController () <VLDErrorPresenterDataSource>

@property (nonatomic) VLDProfile *profile;
@property (nonatomic) VLDErrorPresenter *errorPresenter;

- (void)setupFormDescriptor;
- (void)setupNavigationItem;
- (void)bind:(VLDProfile *)profile;

@end

static NSString * const kRowDescriptorName = @"VLDRowDescriptorNombre";
static NSString * const kRowDescriptorCircle = @"VLDRowDescriptorCirculo";
static NSString * const kRowDescriptorGroup = @"VLDRowDescriptorGrupo";

@implementation VLDProfileViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupProfile];
        [self setupFormDescriptor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationItem];
}

#pragma mark - Setup methods

- (void)setupProfile {
    _profile = [[VLDProfile allObjects] firstObject];
}

- (void)setupFormDescriptor {
    XLFormDescriptor *formDescriptor;
    XLFormSectionDescriptor *sectionDescriptor;
    XLFormRowDescriptor *rowDescriptor;
    
    formDescriptor = [XLFormDescriptor formDescriptor];
    
    sectionDescriptor = [XLFormSectionDescriptor formSection];
    [formDescriptor addFormSection:sectionDescriptor];
    
    rowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:kRowDescriptorName
                                                          rowType:XLFormRowDescriptorTypeText
                                                            title:@"Nombre"];
    rowDescriptor.value = self.profile ? self.profile.name : @"";
    rowDescriptor.required = YES;
    [rowDescriptor.cellConfigAtConfigure setObject:@(NSTextAlignmentRight)
                                            forKey:@"textField.textAlignment"];
    [sectionDescriptor addFormRow:rowDescriptor];
    
    rowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:kRowDescriptorCircle
                                                          rowType:XLFormRowDescriptorTypeText
                                                            title:@"Círculo"];
    rowDescriptor.value = self.profile ? self.profile.circle : @"";
    rowDescriptor.required = YES;
    [rowDescriptor.cellConfigAtConfigure setObject:@(NSTextAlignmentRight)
                                            forKey:@"textField.textAlignment"];
    [sectionDescriptor addFormRow:rowDescriptor];
    
    rowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:kRowDescriptorGroup
                                                          rowType:XLFormRowDescriptorTypeText
                                                            title:@"Grupo"];
    rowDescriptor.value = self.profile ? self.profile.group : @"";
    rowDescriptor.required = YES;
    [rowDescriptor.cellConfigAtConfigure setObject:@(NSTextAlignmentRight)
                                            forKey:@"textField.textAlignment"];
    [sectionDescriptor addFormRow:rowDescriptor];
    
    self.form = formDescriptor;
}

- (void)setupNavigationItem {
    self.navigationItem.title = @"Perfil";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                           target:self
                                                                                           action:@selector(onTapSaveButton:)];
    if (self.profile) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                              target:self
                                                                                              action:@selector(onTapCancelButton:)];
    }
}

#pragma mark - Private methods

- (VLDErrorPresenter *)errorPresenter {
    if (_errorPresenter == nil) {
        _errorPresenter = [[VLDErrorPresenter alloc] initWithDataSource:self];
    }
    return _errorPresenter;
}

- (void)bind:(VLDProfile *)profile {
    profile.name = self.form.formValues[kRowDescriptorName];
    profile.circle = self.form.formValues[kRowDescriptorCircle];
    profile.group = self.form.formValues[kRowDescriptorGroup];
}

- (void)onTapSaveButton:(id)sender {
    NSError *error = [[self formValidationErrors] firstObject];
    if (error) {
        [self.errorPresenter presentError:error];
        return;
    }
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    if (self.profile) {
        [self bind:self.profile];
    }
    else {
        VLDProfile *profile = [[VLDProfile alloc] init];
        [self bind:profile];
        [realm addObject:profile];
    }
    
    [realm commitWriteTransaction];
    
    if (self.profile) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        if ([self.delegate respondsToSelector:@selector(profileViewControllerDidFinishEditingProfile:)]) {
            [self.delegate profileViewControllerDidFinishEditingProfile:self];
        }
    }
    
}

- (void)onTapCancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - VLDErrorPresenterDataSource

- (UIViewController *)viewControllerForErrorPresenter:(VLDErrorPresenter *)presenter {
    return self;
}

@end
