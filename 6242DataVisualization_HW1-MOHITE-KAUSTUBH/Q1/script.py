import csv
import json
import time
import tweepy

# Python version: 3.5.2


def loadKeys(key_file):
    # TODO: put in your keys and tokens in the keys.json file,
    #       then implement this method for loading access keys and token from keys.json
    # rtype: str <api_key>, str <api_secret>, str <token>, str <token_secret>

    with open('keys.json') as json_data:
        d = json.load(json_data)
    return (d['api_key'], d['api_secret'], d['token'], d['token_secret'])
    
  


	
	
# Q1.b - 5 Marks
def getFollowers(api, root_user, no_of_followers):
    # TODO: implement the method for fetching 'no_of_followers' followers of 'root_user'
    # rtype: list containing entries in the form of a tuple (follower, root_user)

    return([(user.screen_name, root_user) for user in tweepy.Cursor(api.followers, screen_name=root_user).items(no_of_followers)])
    

# Q1.b - 7 Marks
def getSecondaryFollowers(api, followers_list, no_of_followers):
    # TODO: implement the method for fetching 'no_of_followers' followers of 'root_user'
    # rtype: list containing entries in the form of a tuple (follower, root_user)
    
    listSecFoll = []
    for i in range(0,len(followers_list)):
        for user in tweepy.Cursor(api.followers, screen_name=followers_list[i][0]).items(no_of_followers):
            listSecFoll.append((user.screen_name, followers_list[i][0]))
    
    
    return(listSecFoll)

# Q1.c - 5 Marks
def getFriends(api, root_user, no_of_friends):
    # TODO: implement the method for fetching 'no_of_followers' followers of 'root_user'
    # rtype: list containing entries in the form of a tuple (follower, root_user)
    
    return([(root_user, user.screen_name) for user in tweepy.Cursor(api.friends, screen_name=root_user).items(no_of_friends)])
    

# Q1.c - 7 Marks
def getSecondaryFriends(api, friends_list, no_of_friends):
    # TODO: implement the method for fetching 'no_of_followers' followers of 'root_user'
    # rtype: list containing entries in the form of a tuple (follower, root_user)
    
    listSecFrnd = []
    for i in range(0,len(friends_list)):
        for user in tweepy.Cursor(api.friends, screen_name=friends_list[i][1]).items(no_of_friends):
            listSecFrnd.append((friends_list[i][1], user.screen_name) )
    return(listSecFrnd)

# Q1.b, Q1.c - 6 Marks
def writeToFile(data, output_file):
    # write data to output file
    # rtype: None
    
    temp_list = []
    
    temp_list = [list(data[k]) for k in range(0,len(data)) ]
    
    with open(output_file, 'a', newline = '') as csvfile:
        fileWriter = csv.writer(csvfile)
        fileWriter.writerows(temp_list)




"""
NOTE ON GRADING:

We will import the above functions
and use testSubmission() as below
to automatically grade your code.

You may modify testSubmission()
for your testing purposes
but it will not be graded.

It is highly recommended that
you DO NOT put any code outside testSubmission()
as it will break the auto-grader.

Note that your code should work as expected
for any value of ROOT_USER.
"""

def testSubmission():
    KEY_FILE = 'keys.json'
    OUTPUT_FILE_FOLLOWERS = 'followers.csv'
    OUTPUT_FILE_FRIENDS = 'friends.csv'

    ROOT_USER = 'PoloChau'
    NO_OF_FOLLOWERS = 10
    NO_OF_FRIENDS = 10


    api_key, api_secret, token, token_secret = loadKeys(KEY_FILE)

    auth = tweepy.OAuthHandler(api_key, api_secret)
    auth.set_access_token(token, token_secret)
    api = tweepy.API(auth, wait_on_rate_limit=True, wait_on_rate_limit_notify=True)
	
	


    primary_followers = getFollowers(api, ROOT_USER, NO_OF_FOLLOWERS)
    secondary_followers = getSecondaryFollowers(api, primary_followers, NO_OF_FOLLOWERS)
    followers = primary_followers + secondary_followers

    primary_friends = getFriends(api, ROOT_USER, NO_OF_FRIENDS)
    secondary_friends = getSecondaryFriends(api, primary_friends, NO_OF_FRIENDS)
    friends = primary_friends + secondary_friends

    writeToFile(followers, OUTPUT_FILE_FOLLOWERS)
    writeToFile(friends, OUTPUT_FILE_FRIENDS)


if __name__ == '__main__':
    testSubmission()
