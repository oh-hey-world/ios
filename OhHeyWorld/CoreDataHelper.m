#import "CoreDataHelper.h"


@implementation CoreDataHelper


+(NSMutableArray *) searchObjectsInContext: (NSString*) entityName : (NSPredicate *) predicate : (NSString*) sortKey : (BOOL) sortAscending : (NSManagedObjectContext *) managedObjectContext
{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];	
	
	// If a predicate was passed, pass it to the query
	if(predicate != nil)
	{
		[request setPredicate:predicate];
	}
	
	// If a sort key was passed, use it for sorting.
	if(sortKey != nil)
	{
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:sortAscending];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
		[request setSortDescriptors:sortDescriptors];
	}
	
	NSError *error;
	
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	
	return mutableFetchResults;
}


+(NSMutableArray *) getObjectsFromContext: (NSString*) entityName : (NSString*) sortKey : (BOOL) sortAscending : (NSManagedObjectContext *) managedObjectContext
{
	return [self searchObjectsInContext:entityName :nil :sortKey :sortAscending :managedObjectContext];
}


@end
