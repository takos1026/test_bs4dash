# TabItems > TabItem
# 

body = bs4DashBody(
  bs4TabItems(
    bs4TabItem(tabName = "item1",
               fluidPage(
                 fluidRow(
                   column(width = 12,uiOutput("accordion"))
                 ),
                 fluidRow(
                   column(width = 12, uiOutput("listgroup"))
                 ),
                 br(),
                 fluidRow(
                   column(width = 12, uiOutput("stars"))
                 ),
                 fluidRow(
                   column(width = 12, uiOutput("quotes"))
                 ),
                 fluidRow(
                   column(width = 12, uiOutput("social"))
                 ),
                 br(),
                 fluidRow(
                   cardPad(
                     color = "info",
                     descriptionBlock(
                       header = "8390",
                       text = "VISITS",
                       rightBorder = FALSE,
                       marginBottom = TRUE
                     ),
                     descriptionBlock(
                       header = "30%",
                       text = "REFERRALS",
                       rightBorder = FALSE,
                       marginBottom = TRUE
                     ),
                     descriptionBlock(
                       header = "70%",
                       text = "ORGANIC",
                       rightBorder = FALSE,
                       marginBottom = FALSE
                     )
                   )
                 ),
                 br(),
                 fluidRow(
                   bs4PopoverUI(
                     actionButton("goButton", "Click me to see the popover!"),
                     title = "My popover",
                     placement = "right",
                     content = "dfdf"
                   )
                 )
               )
    ),
    
    bs4TabItem(tabName = "item2",
               fluidRow(
                 column(width = 7,
                   bs4Callout(width = 12,
                     title = "2020년 9월 15일 출품우 리스트",
                     elevation = 2,
                     status = "danger",
                      HTML(paste0("1. 출품우 개체식별 번호를 확인하세요.", br(), 
                                  "2. 유전능력(EPD)는 색깔로 등급을 구분합니다.", br(),
                                  "* A: 녹색, B: 파랑색, C: 노란색, D: 빨강색"))
                   )
                 ),
                 column(width = 5,
                        bs4Callout(width = 12,
                                   title = "데이터 원천",
                                   elevation = 2,
                                   status = "success",
                                   HTML(paste0("1. 개체정보: 종축개량협회", br(),
                                              "2. 도체성적: 축산물품질평가원", br(),
                                              "3. 정액(KPN): 한우개량사업소")
                                        )
                                   )
                        )
               ),
               uiOutput("cards")),
    bs4TabItem(tabName = "about",
               fluidRow(
                 column(width = 6,
                        fluidRow(
                          column(width = 6, uiOutput("member1")),
                          column(width = 6, uiOutput("member2"))
                        ),
                        fluidRow(
                          column(width = 12, uiOutput("map"))
                        )),
                 column(width = 6,
                        fluidRow(
                          column(width = 12, uiOutput("timeline"))
                        ))
               ))


  )
)

