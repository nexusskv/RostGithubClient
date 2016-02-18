//
//  Constants.h
//  RostGithubTest
//
//  Created by rost on 13.02.16.
//  Copyright © 2016 Rost. All rights reserved.
//

#ifndef Constants_h
#define Constants_h


// GITHUB ID FOR APP
#define CLIENT_ID           @"37598b40f21ca8ad12d1"


// API CONNECTOR URLS AND PARAMS
#define GITHUB_REPO_URL     @"https://api.github.com/search/repositories"
#define SEARCH_PARAMS       @"sort=stars&order=desc&page"
#define TOP_CONTRIB_SORT    @"sort=stars&order=desc"
#define TOP_ISSUES_SORT     @"sort=created_at&order=desc"


// USER DEFAULTS KEYS
#define TOTAL_COUNT         @"TotalCount"
#define ENTERED_LANGUAGE    @"EnteredLangauge"


// UI TAGS
#define GITHUB_REQUEST_BUTTON_TAG   100


// ENUMS
typedef NSInteger requestTypesEnum;
enum _requestTypesEnum {
    kCheckConnection,
    kLoadRepoType,
    kLoadContributorsType,
    kLoadIssuesType
};

typedef NSInteger cellTypesEnum;
enum _cellTypesEnum {
    kContributorsCellType = 1,
    kIssueCellType,
    kDescriptionCellType
};

typedef NSInteger customTitlesTypesEnum;
enum _customTitlesTypesEnum {
    kTitleType,
    kSubtitleType,
    kDateType
};


#endif /* Constants_h */
