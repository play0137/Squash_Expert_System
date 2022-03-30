;第一次聽到壁球的:規則(比賽場地、計分方式、球(幾顆點，打久會發熱)、發球規則...)
;已經打過球的(1.我想變強 a.打到側牆及地板的夾角處 b.打完球迅速回到T點 c.觀察對手動向 d.球回彈時貼著側牆 
;                     e.回彈球在貼近後牆及側牆時可利用擊打側牆或後牆救球 
;           問使用者一些問題(例如:常常追不到球嗎)給一些答案(返回T點)
;           2.我想一個人打，可以進行什麼樣的訓練)



(deffacts header (header))

;|---------------------------------|
;|ask question and answer checking |
;|---------------------------------|
(deffunction question-answer-checking (?question $?valid-response)
    (printout t crlf crlf ?question crlf)
    (bind ?response (read))

    ;if the response isn't correct, enter again!
    (while (not (member$ ?response ?valid-response)) do
        (printout t crlf crlf "Please enter again!" crlf 
                              "Allowed response are " $?valid-response crlf)
        (printout t crlf crlf ?question crlf)
        (bind ?response (read)))
    ?response)

;|-----------------------------|
;|yes-no question is yes or no |
;|-----------------------------|
(deffunction yes-or-no (?response)
    (if (or (eq ?response yes) (eq ?response y))
        then TRUE
        else FALSE))

;|------|
;|header|
;|------|
(defrule header
    ?header <- (header)
    =>
    (retract ?header)
    (bind ?response (question-answer-checking 
"
Welcome!
I'm squash expert system.
May I help you? (y/n):" yes y no n))

    (if (yes-or-no ?response)
        then (assert (main-menu))
        else (assert (finish))))

;|------|
;|finish|
;|------|
(defrule finish
    ?finish <- (finish)
    =>
    (retract ?finish)
    (bind ?response (question-answer-checking 
"
The expert system is finished.
Restart? (y/n):" yes y no n))

    (if (yes-or-no ?response)
        then (reset)
        else (printout t crlf crlf "Have a nice day ^^" crlf)
             (clear)))





;|-------------------------------------------------------------------------|
;|main menu,to distinguish the person who hears squah first time and others|
;|-------------------------------------------------------------------------|
(defrule main-menu
    ?main-menu <- (main-menu)
    =>
    (retract ?main-menu)
    (bind ?response (question-answer-checking 
"
1.This is my first time to hear squash. 
2.I heard squash before." 1 2))

    (switch ?response    
        (case 1 then 
            (printout t crlf crlf crlf "Don't worry." crlf 
                                       "I'll teach you step by step." crlf)
            
            (assert (what-is-squash)))
        (case 2 then
            (assert (heard-squash)))
        (default none)))

;|----------------------------------------------------------------------------------------|
;|To know whether the person who hears squash firt time know the basic knowledge of squash|
;|----------------------------------------------------------------------------------------|
(defrule what-is-squash
    ?what-is-squash <- (what-is-squash)
    =>
    (retract ?what-is-squash)
    (bind ?response (question-answer-checking 
"
I guess you don't know the basic knowledge of squash.

1.You gotta be kidding me! I know everyhing.
2.Yes. I even don't know what squash is." 1 2))

    (switch ?response
        (case 1 then 
            (printout t crlf crlf crlf "Don't lie to me! You said you heard squash for the first time." crlf)
            (bind ?response (question-answer-checking 
"
I guess you don't know the basic knowledge of squash.

1.Yes. I'm the beginner.
2.Yes. I'm the very beginner." 1 2))
            (printout t crlf crlf crlf "We'll learn some basic knowledge." crlf)
            (assert (learn-knowledge)))
        (case 2 then
            (printout t crlf crlf crlf "We'll learn some basic knowledge." crlf)
            (assert (learn-knowledge)))
        (default none)))

;learn some basic knowledge
(defrule learn-knowledge
    ?knowledge <- (learn-knowledge)
    (not (player)) 
    (not (rules))
    =>
    (retract ?knowledge)
    (bind ?response (question-answer-checking
"
Which knowledge do you want to know?

1.History
2.Court
3.Equipments
4.Rules
5.Terms
6.NO. I just want to beat everyone who plays squash!" 1 2 3 4 5 6))

    (switch ?response
        (case 1 then
            (assert (history)))
        (case 2 then
            (assert (court)))
        (case 3 then
            (assert (equipments)))
        (case 4 then
            (assert (rules)))
        (case 5 then
            (assert (terms)))
        (case 6 then
            (assert (player)))
        (default none)))

;history of squash
(defrule history
    ?history <- (history)
    =>
    (retract ?history)
    (printout t crlf crlf  
"
壁球歷史:
    19世紀初:英國倫敦的Fleet debtors prisons，當時的犯人為了鍛鍊身體、打發枯燥乏味的囚禁時光，玩一種對著牆面擊打小球的運動，稱為Racquets

    1830年:英國的Harrow school(貴族學校)逐漸流行Racquets，但因為玩Racquets的人太多了，場地不夠，所以學生們就到角落的空間去玩
    但在角落牆壁凹凸不平，又有水管和窗戶，大大的增加控球的難度，為了增加控球的精準度，學生們利用橡膠製作出比Racquets更軟、更慢的小球
    為了減慢速度及減少不可預測的回彈球，在球中扎了一小孔，讓球擊中牆壁時更容易擠壓，降低牆壁不平的影響，為了區別和Racquets的不同
    ，在當時被稱作Squash Rackets(因為擊打牆壁時發生類似squash的聲音)

    1865年:Harrow school建造了好幾個球場，包括Racquets, Eton Fives, Rugby Fives(後兩種類似於Racquets，但是是用手掌打球)
    學生們只喜歡玩Racquets和Eton Fives，於是Rugby Fives的場地就被學生們拿來當作打Racquets squash的球場" crlf)
    (assert (learn-knowledge)))

;boundary, area, court
(defrule court
    ?court <- (court)
    =>
    (retract ?court)
    (printout t crlf crlf  
"
壁球場地平面圖:
---------------------------------------------------------------------
|                                 |                                 |
|                                 |                                 |
|                                 |                                 |
|                                 |                                 |
|                                 |                                 |
|                                 |                                 |
|                                 |                                 |
|                                 |                                 |
|                                 |                                 |
|                                 |                                 |
|                                 |                                 |
|                                 |                                 |
|                                 |                                 |
|                                 |                                 |
|                                 |                                 |
|                                 |                                 |
|                                 |                                 |
|                                 |                                 |
|                                 |                                 |
|                                 |                                 |
|                                 |                                 |
|                                 |                                 |
|----------------------------short line-----------------------------|
|               |                 |                 |               | 
|    service    |                 |                 |    service    |
|               |                 |                 |               |
|      box      |                 |                 |      box      |
|               |                 |                 |               |
|               |                 |                 |               |
|---------------|                 |                 |---------------|
|                                 |                                 |
|                          half court line                          |
|                                 |                                 |
|                                 |                                 |
|                                 |                                 |
|        quarter court            |         quarter court           |
|                                 |                                 |
|                                 |                                 |
|                                 |                                 |
|                                 |                                 |
|                                 |                                 |
---------------------------------------------------------------------

1.場地區域
    a.前牆(front wall)
    b.側牆(side wall)
    c.後牆(back wall)
    d.發球區(service box, 1.6m x 1.6m)
    e.四分之一場(quarter court)
    e.底板(tin)

2.場地界線:
    a.前牆線(front wall line, 4.57m)
    b.側牆線(side wall line)
    c.後牆線(back wall line, 2.13m)
    d.發球線(service line/cut line)
    e.短線(short line, 6.4m)
    f.半場線(half court line, 4.21m)
    g.底界線(board, 距離地面0.48m)

3.在嘉義哪裡有壁球球場?
    a.中正大學
    b.嘉義大學
    c.全台灣壁球地點(http://www.squash.tw/MENU/Court.aspx)" crlf)
    (assert (learn-knowledge))) 

;squash racket, squash ball
(defrule equipments
    ?equipments <- (equipments)
    =>
    (retract ?equipments)
    (printout t crlf crlf 
"
壁球球具:
    1.球拍:壁球拍相對於網球拍窄(壁球拍寬約20cm，網球拍寬約30cm)、輕(壁球拍重約110g~200g，網球拍重約300g)
        
    2.球:由橡膠質料所製成，練習前需將球打熱，球體溫度越高則彈性越佳。依照球上的點的顏色可以分為下列五種
        a.雙黃:極慢(世界壁球總會指定比賽用球)
        b.黃:超慢
        c.綠或白:慢
        d.紅:中
        e.藍:快
        初學者使用的球通常為c,d,e，不太需要熱球且速度較快，速度越快彈性越佳，不會落地後因為彈性差而彈不起來，導致打沒幾球就要重打的狀況發生
購買球拍:
1.一般體育用品店(Wilson, Slazenger, Roxy 為主)
    優點:便宜
    缺點:球拍舊、差、重
2.國內網路商店(Wilson, Slazenger, Roxy, Head, Dunlop)
    優點:購物方便
    缺點:球拍款式新舊無法辨別、諮詢管道不專業
3.國外網路商店(all)
    優點:球拍品牌多、規格標示清楚
    缺點:貴、到貨時間久、品牌多不知道該怎麼選擇
4.教練(Head, Dunlop, Prince, Tecnifibre為主)
    優點:可以試打、專業建議
    缺點:稍貴、要和教練約時間

比較好的品牌有Dunlop, Head, Prince, Tecnifibre, BlackKnight, Harrow
()裡為球拍品牌" crlf)
    (assert (learn-knowledge)))

;壁球規則
(defrule rules
    ?rules <- (rules)
    =>
    (retract ?rules)
    (bind ?response (question-answer-checking
"
Which rule do you want to know?

1.Serve
2.Scoring-system
3.Back to previous page" 1 2 3))

    (switch ?response
        (case 1 then
            (assert (service_rule)))
        (case 2 then
            (assert (scoring-system)))
        (case 3 then
            (retract ?rules)
            (assert (learn-knowledge)))
        (default none)))

;壁球發球相關
(defrule service_rule
    ?service_rule <- (service_rule)
    =>
    (retract ?service_rule)
    (printout t crlf crlf 
"
發球順序:
    第一局發球權由轉拍決定，下一局由上一局贏球者發球

發球位置:
    發球方一開始可以自由選擇左邊或右邊發球，在失分前要一直左右交替發球，直到失分後換對手自由選擇左邊或右邊發球

發球規則:
    1.至少一隻腳站在發球區內，發球後要先打到前牆的service line及front wall line之間(球壓到線判fault)，擊中前牆後service line就不存在了
      而反彈球，需落在對手的quarter court，超過此範圍都判為界外(out)
    2.拋球後沒有擊球意圖，可以重新拋球再發
    3.拋球後未能擊中球，判為死球(not up)
    4.發球後，接球者尚未準備好，可以重發" crlf)
    (assert (rules)))

;壁球計分方式
(defrule scoring-system
    ?scoring-system <- (scoring-system)
    =>
    (retract ?scoring-system)
    (printout t crlf crlf 
"
比賽方式:
    採五局三勝 or 三局兩勝，有DEUCE
    1.傳統英式計分:發球者得分9分制
    2.point-a-rally(PAR)-11:每回合得分11分制
    3.PAR-15:每回合得分制15分制

計分方式:
    1.發球權得分制:發球方贏球，便得一分，接球方贏球後便得發球權，並轉為發球方
    2.每回合得分制:發球方或接球方其中一方贏球，便得一分，並取得下一球的發球權

得失分:
    1.擊球者打出去的每一顆球在擊中前牆之前不能碰觸到地板、雙方球員、對手球拍，且至少擊中前牆的有效區域內(board及front wall line間)一次
      ，回彈球必須落在對手的quarter court內，否則判為失分
    2.接球者需在球落地兩次之前將球擊出，否則判為失分
    3.對打時，球壓到任何一條出界線都算出界，而發球除了出界線，壓到發球線也算出界" crlf)
    (assert (rules)))

;壁球術語
(defrule terms
    ?terms <- (terms)
    =>
    (retract ?terms)
    (printout t crlf crlf 
"
術語:
    死球(Not Up):
        當球員不正確地擊球
        球員在球彈地多於一次後才擊球
        球接觸到擊球者或其衣物等
    低球(Down):球擊中底板時
    對打(Rally):發球後及隨後連續的有效對打，直到成為死球前
    側場球(Boast):球擊中側牆後反彈至前牆
    高吊球(Lob):球擊中前牆後反彈在高空中，以拋物線落在後場死角內
    短球(Drop Shot):球輕輕的擊中前牆，反彈後落在靠近前牆的位置
    截擊球(Volley):球未落地前將球擊出
    死角(Nick):位於牆壁與地板間接縫的位置，球擊中死角後會導致速度驟降或改變方向
    T點(T-position):短線及半場線交界的位置
    和球/得勝球(Let/Stoke):對於對手有沒有妨礙到自己擊球，可以向裁判說Let please
        Let:對手不在擊球者打向前牆的範圍內，但認為對手有可能在返回T點時而進入到打向前牆的範圍，裁判會判Let，此分重打
        No let:對手不在擊球者打向前牆的範圍內，也沒有返回T點的跡象，裁判會判No let，擊球者失分
        Stroke:若球能直接打向前牆有效區(先打側牆或後牆不算)，對手在擊球者打向前牆的範圍內任何一處，裁判會判Storke to someone，擊球者得分" crlf)
    (assert (learn-knowledge)))


;聽過壁球
(defrule heard-squash
    ?heard-squash <- (heard-squash)
    =>
    (retract ?heard-squash)
    (bind ?response (question-answer-checking 
"Do you know the basic knowledge clearly?

1.Yes,I played squash several times.
2.Yes,I know that, but I never played squash.
3.No. Though I heard squash before, I don't know the basic knowledge clearly. " 1 2 3))

     (switch ?response
        (case 1 then 
            (assert (player)))           
        (case 2 then
            (assert (heard-but-non-player)))
        (case 3 then
            (printout t crlf crlf crlf "It's ok. I'll teach you the basic knowledge.")
            (assert (learn-knowledge)))
        (default none)))

;聽過壁球但沒有打過
(defrule heard-but-non-player
    ?heard-but-non-player <- (heard-but-non-player)
    =>
    (retract ?heard-but-non-player)
    (bind ?response (question-answer-checking 
"
Do you want to try to play squash?

1.Yes. I desire to play squash. But...
2.I'm a busy man. Don't waste my time!!!" 1 2))

    (switch ?response
        (case 1 then
            (assert (want-to-play-but)))
        (case 2 then
            (printout t crlf crlf crlf "You shouldn't use this system. ^_^")
            (assert (finish)))))

;想要打壁球但是...
(defrule want-to-play-but
    ?want-to-play-but <- (want-to-play-but)
    =>
    (retract ?want-to-play-but)
    (bind ?response (question-answer-checking 
"
1.Where to play?
2.Where to buy equipments?
3.I think I'm not good at playing squash" 1 2 3))     

    (switch ?response
        (case 1 then
            (printout t crlf crlf crlf "You can check this website.(http://www.squash.tw/MENU/Court.aspx)" crlf)
            (assert (want-to-play-but)))
        (case 2 then
            (assert (where-to-buy-equipments)))
        (case 3 then
            (printout t crlf crlf crlf "Don't worry. I'll let you greater than most people, perhaps." crlf)
            (assert (player)))))

;去哪裡買球具
(defrule where-to-buy-equipments
    ?where-to-buy-equipments <- (where-to-buy-equipments)
    =>
    (retract ?where-to-buy-equipments)
    (printout t crlf crlf
"
1.一般體育用品店(Wilson, Slazenger, Roxy為主)
    優點:便宜
    缺點:球拍舊、差、重
2.國內網路商店(Wilson, Slazenger, Roxy, Head, Dunlop)
    優點:購物方便
    缺點:球拍款式新舊無法辨別、諮詢管道不專業
3.國外網路商店(all)
    優點:球拍品牌多、規格標示清楚
    缺點:貴、到貨時間久、品牌多不知道該怎麼選擇
4.教練(Head, Dunlop, Prince, Tecnifibre為主)
    優點:可以試打、專業建議
    缺點:稍貴、要和教練約時間

比較好的品牌有Dunlop, Head, Prince, Tecnifibre, BlackKnight, Harrow
()裡為球拍品牌" crlf)
    (assert (want-to-play-but)))


;如何練習及變強
(defrule player
    ?player <- (player)
     =>
    (retract ?player)
    (bind ?response (question-answer-checking 
"
1.How to practice
2.How to get stronger
3.Finish" 1 2 3))
    
    (switch ?response
        (case 1 then
            (assert (practice)))
        (case 2 then
            (assert (stronger)))
        (case 3 then
            (assert (finish)))))


;打到側牆及地板的夾角處, 球回彈時貼著側牆
(defrule practice
    ?practice <- (practice)
    =>
    (retract ?practice)
    (bind ?response (question-answer-checking 
"
1.Footwork
2.Rally
3.Back to previous page" 1 2 3))

    (switch ?response
        (case 1 then
            (printout t crlf crlf 
"
---------
| .   . |   
|       |    
|-.-.-.-|
| . | . |       
---------
簡略的示意圖，和實際球場略有不同，最中間那一點是T點，皆以T為出發點
前場步法(左上、右上):往右上三步，返回T點三步
中場步法(左、右):往右兩步，返回T點兩步
後場步法(左下、右下):往右下三步，返回T點三步" crlf)
            (assert (practice)))
        (case 2 then
            (printout t crlf crlf 
"
1.後場正、反拍直線長球：站在發球區後緣與後牆間，面對側牆保持擊球距離，來回作直線長球練習，將球打到service line上端50cm左右處，並反彈落在發球區後端與後牆之間，最好能貼牆來回不斷拉球。並逐漸增加擊球速度及降低擊球的高度，以訓練揮拍的力量，正反拍分別訓練
2.半場正、反拍直線半場球：面對側牆站在發球區前緣的中線處，以tin上方30cm處為目標，快速來回直線半場拉球，訓練快速擊球的準確性與流暢的揮拍準備動作
3.半場正、反拍抽球：站在T點，先以右邊前牆角落為目標，以正拍擊球至側牆約tin上方30cm處，讓球反彈前牆回到T點，再以反拍打到左邊側牆，反彈前牆後回到T點，正反拍交替擊球
4.半場正、反拍截擊球：位置及方式同第3點，但將目標提高至service line與front wall line間，以截擊不讓球落地，正反拍交替擊球" crlf)
            (assert (practice)))
        (case 3 then
            (assert (player)))))

;發球及對打如何變強
(defrule stronger
    ?stronger <- (stronger)
    =>
    (retract ?stronger)
    (bind ?response (question-answer-checking 
"
1.Serve
2.Rally
3.Back to previous page" 1 2 3))
    (switch ?response
        (case 1 then
            (assert (serve)))
        (case 2 then
            (assert (rally)))
        (case 3 then
            (assert (player)))))

;發球如何變強
(defrule serve
    ?serve <- (serve)
    =>
    (retract ?serve)
    (bind ?response (question-answer-checking 
"
1.Serve
2.Receive" 1 2))
    (switch ?response
        (case 1 then
            (printout t crlf crlf 
"
發球時一隻腳站在發球區內，另一腳則盡量靠近T點
1.高吊球
    將球往前牆線下方打，回彈時要盡量落在對手後方，接近角落的位置，避免對手在防守區前方截擊，且應避免先撞到後牆(球會反彈太遠，對手容易處理)
    如此便可逼對手在後場角落位置截擊(如果對手沒有截擊，落地後會因球力量不夠彈不起來，很難回擊)    
2.平飛球
    將球強力打向發球線上方附近，讓球反彈至nick或對手身上" crlf))
        (case 2 then
            (printout t crlf crlf crlf "接發球時站在自己區域的中央位置，進可攻(截擊)退可守(等球碰牆後再打)" crlf)))
    
    (assert (stronger)))

;觀察對手動向, T點, 對手發球時我要如何站位(站在右邊時，站在發球格的左後方，反之), 回彈球在貼近後牆及側牆時可利用擊打側牆或後牆救球
;盡量使用截擊，讓對手沒有時間回到T點
;是否常常(10球內有5,6球)跑不到球的位置?
;    YES->每次打完球有返回T點嗎? (back-to-T)
;        YES->觀察對手動向，並預測球的方向，如果覺得對手會將球打在某區域，以T點為基準點，靠近那個區域站 (assert (opponent-run-to-ball))
;        NO ->每次打完球都要盡量返回T點，T點到球場內的任何位置約只須3大步，所以掌握T點是非常重要的 (assert (opponent-run-to-ball))
;    NO ->我打的球對手都能跑到定點並回擊 (opponent-run-to-ball)
;        YES->1.使用截擊，減少對手反應時間，或將球打到後場，將對手控制在你後面，無法回到T點，此時能選的球路就更多，越能打出刁鑽的球 (assert (turn-racket-slow))
;             2.盡量讓球回彈時貼著側牆，或是球落在nick 
;        NO ->對手左右擊球時，球拍來不及轉向 (turn-racket-slow)
;            YES->嘗試將球拍握短一點，會覺得球拍較輕，讓你的反應更靈敏 (assert (cant-hit-back-near-sidewall-ball))
;            NO ->貼側牆球常常揮空或是打到牆壁? (cant-hit-back-near-sidewall-ball)
;                YES->嘗試不要強力揮拍，放慢擊球節奏，改為用推的，球拍在擊球點位置稍後一點的地方就開始沿著牆壁推球
;                     如果在前場，建議沿著側牆放小球
;                     如果在後場，建議用高吊球，將球打到後牆邊緣 (assert (cant-hit-back-backwall-ball))
;                NO ->非常靠近後牆球不知道該如何處理 (cant-hit-back-backwall-ball)
;                        YES->利用boast技巧
;                        NO ->congratulation! You are greater than most people.


;problem description
(defrule rally
    ?rally <- (rally)
    =>
    (retract ?rally)
    (bind ?response (question-answer-checking "是否常常(10球內有5,6球)跑不到球的位置? (y/n)" yes y no n))
    (if (yes-or-no ?response)
        then (assert (back-to-T))
             (assert (user-run-to-ball-no))
        else (assert (opponent-back-to-T))
             (assert (user-run-to-ball-yes))))

(defrule back-to-T
    ?back-to-T <- (back-to-T)
    =>
    (retract ?back-to-T)
    (bind ?response (question-answer-checking "每次打完球有返回T點嗎? (y/n)" yes y no n))
    (printout t crlf crlf "返回T點" crlf)
    (if (yes-or-no ?response)
        then (printout t "1.觀察對手動向，並預測球的方向，如果覺得對手會將球打在某區域，以T點為基準點，靠近那個區域站" crlf)
             (printout t "2.如果真的沒辦法完全到達球的落點，打高吊球" crlf)            
        else (printout t "每次打完球都要盡量返回T點，T點到球場內的任何位置約只須3大步，所以掌握T點是非常重要的" crlf))
        (bind ?response (question-answer-checking "繼續變強嗎? (y/n)" yes y no n))
            (if (yes-or-no ?response)
                then (assert (opponent-back-to-T))
                else (assert (finish))))

(defrule opponent-back-to-T
    ?opponent-back-to-T <- (opponent-back-to-T)
    =>
    (retract ?opponent-back-to-T)
    (assert (opponent-run-to-ball))
    (bind ?response (question-answer-checking "對手有返回T點的習慣嗎? (y/n)" yes y no n))
    (if (yes-or-no ?response)
        then (assert (opponent-back-to-T-yes))
        else (assert (opponent-back-to-T-no))))

(defrule opponent-run-to-ball
    ?opponent-run-to-ball <- (opponent-run-to-ball)
    =>
    (retract ?opponent-run-to-ball)
    (assert (opponent-position))
    (bind ?response (question-answer-checking "我打的球對手都能跑到定點並回擊 (y/n)" yes y no n))
    (if (yes-or-no ?response)
        then (assert (opponent-run-to-ball-yes))
        else (assert (opponent-run-to-ball-no))))

(defrule opponent-position
    ?opponent-position <- (opponent-position)
    =>
    (retract ?opponent-position)
    (assert (ball-position))
    (bind ?response (question-answer-checking "對手和你的相對位置? 1.並肩或前面 2.後面" 1 2))
    (switch ?response
        (case 1 then
            (assert (opponent-stand-at-front)))
        (case 2 then
            (assert (opponent-stand-at-back)))))

(defrule ball-position
    ?ball-position <- (ball-position)
    =>
    (retract ?ball-position)
    (assert (nearwall-ball))
    (bind ?response (question-answer-checking "對手將球打到 1.前牆 2.後牆 3.後牆且預估球落地後的反彈不高 4.三者皆是" 1 2 3 4))
    (switch ?response
        (case 1 then
            (assert (opponent-hit-to-frontwall)))
        (case 2 then
            (assert (opponent-hit-to-backwall-bounce)))
        (case 3 then
            (assert (opponent-hit-to-backwall-not-bounce)))
        (case 4 then
            (assert (opponent-hit-to-frontwall))
            (assert (opponent-hit-to-backwall-bounce))
            (assert (opponent-hit-to-backwall-not-bounce)))))

(defrule nearwall-ball
    ?nearwall-ball <- (nearwall-ball)
    =>
    (retract ?nearwall-ball)
    (bind ?response (question-answer-checking "貼近牆壁的球不知道該怎麼處理 (y/n)" yes y no n))
    (if (yes-or-no ?response)
        then (printout t crlf crlf "推球" crlf)
             (printout t           "嘗試不要強力揮拍，放慢擊球節奏，改為用推的，球拍在擊球點位置稍後一點的地方就開始沿著牆壁推球" crlf)
             (printout t           "如果在前場，建議沿著側牆放小球" crlf)
             (printout t           "如果在後場，建議用高吊球，將球打到後牆邊緣" crlf)
        else (printout t crlf crlf "抱歉，此系統無法給出有效的意見" crlf))
    (assert (finish)))


;suggestion
(defrule volley
    (user-run-to-ball-yes)
    (opponent-run-to-ball-yes)
    (opponent-hit-to-backwall-not-bounce)
    =>
    (printout t crlf crlf "截擊" crlf)
    (printout t           "1.使用截擊，減少對手反應時間，或將球打到後場，將對手控制在你後面，無法回到T點" crlf)
    (printout t           "  此時能選的球路就更多，越能打出刁鑽的球" crlf)    
    (printout t           "2.盡量讓球回彈時貼著側牆，或是球落在nick" crlf)
    (printout t           "3.如果預測打至後場的球反彈不會太高的話，要在落地前先用截擊處理掉" crlf)
    (assert (finish)))

(defrule hit-ball-powerfully
    (opponent-run-to-ball-no)
    (opponent-back-to-T-no)
    (user-run-to-ball-yes)
    =>
    (printout t crlf crlf "強力擊球" crlf)
    (printout t           "在自己到達球的位置並站穩的狀況下，當對手常常無法及時到達球的位置和沒有返回T點的習慣時" crlf)    
    (printout t           "利用強力擊球，更加壓縮對手的反應時間，讓對手更追不到球，也利用對手沒有返回T點的習慣" crlf)
    (printout t           "將球打至前後牆的四個角落，加倍消耗對手體力" crlf)
    (assert (finish)))

(defrule hit-nearwall-ball-powerfully
    (opponent-hit-to-frontwall)
    (opponent-stand-at-front)
    (user-run-to-ball-yes)
    =>
    (printout t crlf crlf "強力貼牆球" crlf)
    (printout t           "當對手吊小球且站在你前面或旁邊時，可以利用強力擊球打回去，因為對手在你前面" crlf)
    (printout t           "沒有辦法迅速的跑到後場去，而對手後退的速度比球還要慢，就算勉強趕到，回擊球也沒有辦法太刁鑽" crlf)    
    (printout t           "如果可以的話最好打出強力貼牆的球，如果對手迅速的移動到球的位置，也沒有辦法處理好這顆球")
    (assert (finish)))

(defrule drop
    (opponent-run-to-ball-no)
    (opponent-stand-at-back)
    (opponent-back-to-T-yes)
    =>
    (printout t crlf crlf "吊短球" crlf)
    (printout t           "1.當對手腳程不快時且站在你後方，可以利用吊小球的方式，如果對手勉強打到，立刻強力擊球，把球打至後場" crlf)    
    (printout t           "2.如果對手有確實的返回T點，利用吊小球，盡量將對手調離T點，此時便有更多的攻擊點" crlf)
    (assert (finish)))

(defrule boast
    (user-run-to-ball-no)  
    (opponent-stand-at-front)  
    (opponent-hit-to-backwall-bounce)
     =>
    (printout t crlf crlf "側牆球" crlf)
    (printout t           "當球打至後場且判斷可以反彈一定的高度但是又無法及時趕到球的位置" crlf)
    (printout t           "可以等球反彈並撞擊後牆，側身將球利用側牆打至前牆" crlf)    
    (assert (finish)))