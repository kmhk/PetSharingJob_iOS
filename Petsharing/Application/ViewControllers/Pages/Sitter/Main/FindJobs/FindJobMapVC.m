//
//  FindJobMapVC.m
//  Petsharing
//
//  Created by LandToSky on 8/22/17.
//  Copyright © 2017 LandToSky. All rights reserved.
//

#import "FindJobMapVC.h"
#import "AppDelegate.h"
#import "SitterTbVC.h"
#import <JPSThumbnailAnnotation/JPSThumbnail.h>
#import <JPSThumbnailAnnotation/JPSThumbnailAnnotation.h>
#import "DogJob.h"
#import "FindJobDetailVC.h"


@interface FindJobMapVC ()
{
	IBOutlet MKMapView *mapView;
}

@end

@implementation FindJobMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	mapView.mapType = MKMapTypeStandard;
	mapView.showsUserLocation = YES;
	
	MKCoordinateRegion region = MKCoordinateRegionMake([AppDelegate sharedAppDelegate].currentLocation.coordinate, MKCoordinateSpanMake(100, 100));
	[mapView setRegion:region];
	
	[self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData
{
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	
	[sitterViewModel loadAllJobs:^(NSError *error) {
		[MBProgressHUD hideHUDForView:self.view animated:YES];
		
		if (error) {
			[commonUtils showAlert:@"Warning!" withMessage:error.localizedDescription];
			
			return;
		}
		
		[self showJobAnnotations];
	}];
}

- (void)showJobAnnotations {
	for (DogJob *job in sitterViewModel.allJobs) {
		JPSThumbnail *thumbnail = [[JPSThumbnail alloc] init];
		thumbnail.image = [UIImage imageNamed:@"mylocation"];
		thumbnail.title = job.jobTitle;
		thumbnail.subtitle = job.jobAddress;
		thumbnail.coordinate = job.jobLocation;
		thumbnail.disclosureBlock = ^{
			NSLog(@"selected Empire");
			FindJobDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FindJobDetailVC"];
			vc.job = job;
			[self.navigationController pushViewController:vc animated:YES];
		};
		
		[mapView addAnnotation:[JPSThumbnailAnnotation annotationWithThumbnail:thumbnail]];
	}
}


// MARK: - MKMapView delegate

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
	if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
		[((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didSelectAnnotationViewInMap:mapView];
	}
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
	if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
		[((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didDeselectAnnotationViewInMap:mapView];
	}
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
	if ([annotation conformsToProtocol:@protocol(JPSThumbnailAnnotationProtocol)]) {
		return [((NSObject<JPSThumbnailAnnotationProtocol> *)annotation) annotationViewInMap:mapView];
	}
	return nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
