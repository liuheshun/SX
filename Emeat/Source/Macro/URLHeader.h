//
//  URLHeader.h
//  LessonProject
//

#ifndef URLHeader_h
#define URLHeader_h

//http://192.168.0.200:8080/m
//beta.cyberfresh.cn
//admin.cyberfresh.cn


//URL:
#define baseUrl @"http://admin.cyberfresh.cn/m"
#define loginBaseUrl @"http://admin.cyberfresh.cn/cas"
///设置的
#define setbaseUrl @"http://admin.cyberfresh.cn"


//
////URL:本地
//#define baseUrl @"http://192.168.0.141/m"
//#define loginBaseUrl @"http://192.168.0.141/cas"

////URL:本地
//#define baseUrl @"http://192.168.0.194/m"
//#define loginBaseUrl @"http://192.168.0.194/cas"


///获取版本号
///http://192.168.0.200:8080/m/appversion/index.jhtml?appType=1






//#define zp @"http://beta.cyberfresh.cn"


//
/////本地测试
//
//#define loginKN @"http://192.168.0.120:7070"
//
//#define knL @"http://192.168.0.120/m"
//
//#define guiguan @"http://192.168.0.171:8080"
//
//#define baseUrl11 @"http://192.168.0.200:8080/m"
//
//
//






#define jiangHuDetailsOfUrl(baseUrl,actId ,shareParameter) [NSString stringWithFormat:@"%@/weixinPreview.action?actId=%lu_%@",baseUrl,actId ,shareParameter]



#define daXiaDeatailsOfUrl(baseUrl,expertId)    [NSString stringWithFormat:@"%@/ExpertInvitation/invitationExpertDetail.action?expertId=%ld",baseUrl,expertId]    


#define JueZhaoDetailsOfUrl(baseUrl,expertId,kid)  [NSString stringWithFormat:@"%@/ExpertInvitation/invitationExpertDetailfx.action?expertId=%ld&kid=%ld",baseUrl,expertId,kid]







#endif /* URLHeader_h */
