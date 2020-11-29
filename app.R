library(shiny)
library(bs4Dash)
library(dplyr)
library(lubridate)
library(stringr)
library(leaflet)
library(reactable)

source("source/01_navbar.R")
source("source/02_sidebar.R")
source("source/03_body.R")
source("source/04_footer.R")

data_path <- "data/200914-순정.Rda"
load(data_path)

#--------------
#---- ui ------
#--------------
ui <- bs4DashPage(
    title = "bs4dash",
    navbar = navbar,
    sidebar = sidebar,
    body = body
)

#---------------
#--- server ----
#---------------
server <- function(input, output, session) {
    
    
    # Accordion
    output$accordion <- renderUI({
        bs4Accordion(id = "qna", 
                     bs4AccordionItem(
                         width = 12,
                         id = "qna1",
                         title = "가입 신청 방법",
                         "Anim pariatur cliche reprehenderit,"
                     ),
                     bs4AccordionItem(
                         width = 12,
                         id = "qna2",
                         title = "아이디, 비밀번호 찾기",
                         "Anim pariatur cliche reprehenderit, "
                     )
        )
    })
    
    # stars
    output$stars <- renderUI({
        bs4Card(
            width = 12,
            title = "Stars",
            fluidRow(
                column(width = 3, bs4Stars(grade = 5)),
                column(width = 3, bs4Stars(grade = 5, status = "success")),
                column(width = 3, bs4Stars(grade = 1, status = "danger")),
                column(width = 3, bs4Stars(grade = 3, status = "info"))
            )
        )
    })
    
    
    # quotes and colors
    colors <- list("indigo", "lightblue", "danger", "teal", "lime", "olive", "orange", "warning",
                   "fuchsia", "purple", "maroon", "pink", "navy")
    
    output$quotes <- renderUI({
        bs4Card(width = 12,
                title = "Quotes",
                fluidRow(
                    column(width = 4,
                           lapply(1:4, function(i) {
                               bs4Quote(colors[[i]], status = colors[[i]])
                           })
                    ),
                    column(width = 4,
                           lapply(5:8, function(i) {
                               bs4Quote(colors[[i]], status = colors[[i]])
                           })
                    ),
                    column(width = 4,
                           lapply(9:length(colors), function(i) {
                               bs4Quote(colors[[i]], status = colors[[i]])
                           }))
                )
                )
    })
    
    # list group
    output$listgroup <- renderUI({
        bs4ListGroup(width = 12,
            bs4ListGroupItem(
                "Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus varius blandit.",
                active = TRUE,
                disabled = FALSE,
                type = "heading",
                title = "List group item heading",
                subtitle = "3 days ago",
                footer = "Donec id elit non mi porta."
            ),
            bs4ListGroupItem(
                active = FALSE,
                disabled = FALSE,
                type = "heading",
                title = "List group item heading",
                subtitle = "3 days ago",
                footer = "Donec id elit non mi porta."
            )
        )
    })
    
    output$social <- renderUI({
        bs4SocialCard(
            width = 12,
            title = "Social Card",
            subtitle = "example-01.05.2018",
            src = "https://adminlte.io/themes/AdminLTE/dist/img/user4-128x128.jpg",
            "Some text here!",
            comments = tagList(
                lapply(X = 1:10, FUN = function(i) {
                    cardComment(
                        src = "https://adminlte.io/themes/AdminLTE/dist/img/user3-128x128.jpg",
                        title = paste("Comment", i),
                        date = "01.05.2018",
                        paste0("The ", i, "-th comment")
                    )
                })
            )
        )
    })
    
    # 우시장플러스 데모 (profile tab)
    temp <- final[sample(1:length(final), 20, replace = FALSE)] # 테스트리스트
    
    epdGrade <- function(i, digit){ # 4자리 코드에서 각 자리수에 해당하는 등급에 따라 다른 색깔 적용
        if(str_sub(temp[[i]]$epd$epd_code,digit,digit) == "A"){
            "success"
        } else if(str_sub(temp[[i]]$epd$epd_code,digit,digit) == "B"){
            "info"
        } else if(str_sub(temp[[i]]$epd$epd_code,digit,digit) == "C"){
            "warning"
        } else {
            "danger"
        }
    }
    
    
    output$cards <- renderUI({
        lapply(X = seq_along(temp), function(i){
            fluidRow(
                column(width = 12,
                       bs4Card(title = temp[[i]]$baseinfo$개체식별번호, width = 12, collapsed = TRUE,
                               cardLabel = bs4CardLabel(
                                   text = temp[[i]]$baseinfo$`성별`,
                                   status = ifelse(temp[[i]]$baseinfo$성별 == "수", "dark", "light")
                               ),
                               fluidRow(
                                   column(width = 1, align = "center", h4(bs4Badge(temp[[i]]$baseinfo$등록구분, status = "primary"))),
                                   column(width = 2, align = "center", h4(bs4Badge(unlist(temp[[i]]$parents %>% filter(구분 == "부") %>% select(2)), status = "primary"))),
                                   column(width = 2, align = "center", h4(bs4Badge(paste0(ymd(temp[[i]]$baseinfo$생년월일) %--% ymd("2020-09-14")  %>% as.period(unit = "month") %>% month(), "개월령"), status = "primary"))),
                               ),
                               br(), 
                               fluidRow( # status: Primary Secondary Success Danger Warning Info Light Dark
                                   bs4InfoBox(width = 3, title = "도체중", value = temp[[i]]$epd$도체, icon = "check", iconElevation = 2, iconStatus = epdGrade(i, 1)),
                                   bs4InfoBox(width = 3, title = "등심단면적", value = temp[[i]]$epd$등단, icon = "check", iconElevation = 2, iconStatus =  epdGrade(i, 2)),
                                   bs4InfoBox(width = 3, title = "등지방", value =  temp[[i]]$epd$등지, icon = "check", iconElevation = 2, iconStatus =   epdGrade(i, 3)),
                                   bs4InfoBox(width = 3, title = "근내지방", value = temp[[i]]$epd$근내, icon = "check", iconElevation = 2, iconStatus =   epdGrade(i, 4))
                               ),
                               # 가족 테이블 구현
                               fluidRow(
                                   bs4Table(width = 12,
                                            headTitles = c(names(temp[[i]]$parents), "개체검색", "도체성적", "정액"),
                                            # 테이블 row 수대로 반복
                                            lapply(1:nrow(temp[[i]]$parents), function(j) {
                                                bs4TableItems(
                                                    # 테이블 값 뿌려주기
                                                    lapply(1:length(temp[[i]]$parents[j,]), function(k) {
                                                        bs4TableItem(
                                                          unlist(temp[[i]]$parents[j,k])
                                                        )
                                                    }),
                                                    # 개체정보 검색 버튼
                                                    bs4TableItem(
                                                        actionButton(inputId = paste0("cattle_", i, j, "1"), label = "", icon = icon("check-circle"),
                                                                     onclick = sprintf("window.open('http://www.aiak.or.kr/ka_hims/ka_s102.jsp?type=barcode&var=%s', '_blank')", unlist(temp[[i]]$parents[j,4]))
                                                                     )
                                                    ),
                                                    # 도체성적 검색 버튼
                                                    bs4TableItem(
                                                        actionButton(inputId = paste0("cattle_", i, j, "2"), label = "", icon = icon("check-circle"),
                                                                     onclick = sprintf("window.open('https://mtrace.go.kr/mtracesearch/cattleNoSearch.do?btsProgNo=0109008401&btsActionMethod=SELECT&cattleNo=%s', '_blank')", unlist(temp[[i]]$parents[j,4]))
                                                                     )
                                                    ),
                                                    # 정액 검색 버튼
                                                    bs4TableItem(
                                                        if(str_starts(unlist(temp[[i]]$parents[j,2]), pattern = "KPN") == 1) {
                                                            actionButton(inputId = paste0("cattle_", i, j, "3"), label = "", icon = icon("eyedropper"),
                                                                         onclick = sprintf("window.open('http://www.limc.co.kr/KpnInfo/KpnDetail.asp?KpnNo=%s', '_blank')", gsub(x = unlist(temp[[i]]$parents[j,2]), pattern = "KPN", replacement = ""))
                                                                        )   
                                                        }
                                                    )
                                                )
                                            })
                                   )
                               )
                               )
                       
                )
            )
        })
    })
    ##################
    
    
    
    # about tab
    output$member1 <- renderUI({
        bs4Card(width = 12,
                status = "primary",
                solidHeader = TRUE,
                cardProfile(
                    src = "profile.png",
                    title = "나영준",
                    subtitle = "Team Leader",
                    fluidRow(
                        column(width = 6, align = "right",
                               actionButton(inputId = "user1_btn1", label = "github", icon = icon("github"), class = "btn btn-app")
                        ),
                        column(width = 6, align = "left",
                               actionButton(inputId = "user1_btn2", label = "gmail", icon = icon("google"), class = "btn btn-app")
                        )
                    )
                ))
    })
    
    output$member2 <- renderUI({
        bs4Card(width = 12,
                status = "primary",
                solidHeader = TRUE,
                cardProfile(
                    src = "profile.png",
                    title = "탁온식",
                    subtitle = "Data Analyst",
                    fluidRow(
                        column(width = 6, align = "right",
                               actionButton(inputId = "user2_btn1", label = "github", icon = icon("github"), class = "btn btn-app")
                        ),
                        column(width = 6, align = "left",
                               actionButton(inputId = "user2_btn2", label = "gmail", icon = icon("google"), class = "btn btn-app")
                        )
                    )
                ))
    })
    
    output$map <- renderUI({
            bs4Card(
                width = 12,
                title = "Contact us",
                status = "secondary",
                fluidRow(
                    column(width = 6,
                           leaflet() %>% addProviderTiles("CartoDB") %>% 
                               setView(lat = 37.54090710051889, lng = 127.07936425566659, zoom = 13) %>% 
                               addMarkers(lat = 37.54090710051889, lng = 127.07936425566659)
                           ),
                    column(width = 6,
                           cardProfileItemList(
                               bordered = FALSE,
                               cardProfileItem(title = "Address", description = "서울특별시 광진구 능동로 120"),
                               cardProfileItem(title = "Email", description = "official@gmail.com"),
                               cardProfileItem(title = "Mobile", description = "010-1234-5678")
                           ))
                )
                
            )
    })
    
    output$timeline <- renderUI({
            bs4Card(
                width = 12,
                title = "우시장플러스 타임라인",
                status = "secondary",
                bs4Timeline(
                    width = 12,
                    reversed = TRUE,
                    bs4TimelineEnd(status = "danger"),
                    bs4TimelineLabel("2020년 11월", status = "info"),
                    bs4TimelineItem(
                        elevation = 4,
                        title = "범정부 대회 대통령상",
                        icon = "gears",
                        status = "success",
                        time = "now",
                        footer = "Here is the footer",
                        "This is the body"
                    ),
                    bs4TimelineItem(
                        title = "기관별 통합예선",
                        border = FALSE
                    ),
                    bs4TimelineLabel("2020년 8월", status = "primary"),
                    bs4TimelineItem(
                        elevation = 2,
                        title = "농림축산식품부 대회 장관상",
                        icon = "flag",
                        status = "warning",
                        bs4TimelineItemMedia(src = "http://placehold.it/150x100"),
                        bs4TimelineItemMedia(src = "http://placehold.it/150x100")
                    ),
                    bs4TimelineLabel("2020년 5월", status = "primary"),
                    bs4TimelineItem(
                        elevation = 2,
                        title = "우시장플러스 개발 시작",
                        icon = "rocket",
                        status = "warning",
                        HTML(paste0("1. 팀명 결정: 투뿔메이커", br(),
                                    "2. 서비스명 결정: 우시장플러스"))
                    ),
                    bs4TimelineStart(status = "danger")
                )
            )
    })
}



#----------------------
#--- end of script ----
#----------------------



shinyApp(ui = ui, server = server)
