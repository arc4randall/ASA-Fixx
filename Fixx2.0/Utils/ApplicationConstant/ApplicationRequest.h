//
//  ApplicationRequest.h
//  Trunkey
//
//  Created by vivek soni on 5/12/14.
//  Copyright (c) 2014 Vinfotech. All rights reserved.
//

#ifndef Trunkey_ApplicationRequest_h
#define Trunkey_ApplicationRequest_h

//#define HOST_URL @"https://fixx.saltmoney.org/fixx_dev/api/" //Staging
#define HOST_URL @"https://fixx.saltmoney.org/fixx2/api/"  //Live


#define RequestTimeOutInterval 180
#define URL_Log(url_name,url_string) NSLog(@"%@%@",url_name,url_string);
#define API_KEY @"FFF6F696-92E5-4FBD-86C4-8C31A66E1D88"


#define SignIn_User @"signin?apikey=%@&email=%@&password=%@&device_id=%@&device_type=%@"
#define SignUp_User @"signup?apikey=%@&email=%@&password=%@&device_id=%@&device_type=%@&client_time=%@&year_of_birth=%@"

#define GETDEFAULT_FIXX @"get_default_fixx?apikey=%@&token=%@"
#define GETDEFAULTINCOME_FIXX @"get_default_fixx?apikey=%@&token=%@&is_income=%@"
#define GetUser_FIXX @"get_user_fixx?apikey=%@&token=%@&is_income=%@"
#define DeleteDefault_FIXX @"delete_user_fixx?apikey=%@&token=%@&fixx_id=%@"

#define Subscribe_Default_Fixx @"subscribe_default_fixx?apikey=%@&token=%@&fixx_id=%@"

#define SetPattern @"set_pattern?apikey=%@&token=%@"
#define CreatePattern @"create_fixx?apikey=%@&token=%@&name=%@&type=%@&repeat_freq=%@&repeat_interval=%@&amount=%@&plan_date=%@&is_tip_eligible=%@&is_income=%@"

#define GetCashFlow @"getCashFlow?apikey=%@&token=%@&duration=%@&is_income=%@"
#define GetBigPicture @"getBigPicture?apikey=%@&token=%@&duration=%@"


#define GetHighestPriorityTips @"getTips?apikey=%@&token=%@"
#define SubscribeTips @"subscribeTip?apikey=%@&token=%@&tipId=%@&status=%@"

#define getNotificationSetting @"getUserNotification?apikey=%@&token=%@"
#define getNotificationList @"getMessageList?apikey=%@&token=%@"
#define setNotification @"setUserNotification?apikey=%@&token=%@&notification1=%@&notification2=%@&notification3=%@&notification4=%@"
#define UpdateProfile @"update_profile?apikey=%@&token=%@&email==%@&password=%@&firstname=%@&lastname=%@&year_of_birth=%@"



#define Records_Transaction @"recordTransaction?apikey=%@&token=%@&fixx_id=%@&title=%@&amount=%@&transactionDate=%@"
#define Get_Transaction @"get_transaction?apikey=%@&token=%@&fixx_id=%@&from_date=%@&to_date=%@"

#define Logout_User @"logout?apikey=%@&token=%@"
#endif
