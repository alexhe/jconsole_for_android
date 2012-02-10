NB. utilities for J GPL source release test
NB. assumes J GPL source folder is current directory
NB. see test/tsu.ijs for additional info

NB. testpath=: jpath '~test/'
testpath =: jpath (1!:43''),'/test/' NB. 1!:43 current directory
load testpath,'tsu.ijs'

9!:21[1e8       NB. limit error rather than long memory thrash (g400)
threshold=: 0.1 NB. timer threshold failures less likely
libtsdll=: jpath ' ',~(1!:43''),'/libtsdll.',>(UNAME-:'Darwin'){'so';'dylib'

LOGFILE=: 2     NB. log to console (2) or file (jpath'~temp\log.log')

basetestname =: 3 : '(#testpath) }. >y'
LOGIT=: 3 : 'y[(basetestname y)1!:2<LOGFILE'
NB. LOGIT=: 3 : 'y[(>y)1!:2<LOGFILE'
SNS=: 3 : '(<testpath),each(;:y),each<''.ijs''' NB. script names
BAD=: 3 : '>(-.bad)#y'

TEST=:   (13 : '0!:3  LOGIT y')"0
TESTX=:  (13 : '0!:2 LOGIT y')"0

NB. bad=: TEST ddall
NB. BAD ddall

NB. TESTX SNS 'g120' NB. see g120 details

NB. TESTX SNS 'g120 gintovfl' NB. see g120 gintovfl details

CRASHERS =. 'g031 g120 g421c g8x gintovfl gstack'
TOOLONG=. 'g410'

 ddt=: ddall -. SNS CRASHERS,' ',TOOLONG NB. remove crashers
 
 NB. smaller grouping for testing on android
 tg1=:50 {. ddt
 tg2=:50 {. 50 }. ddt
 tg3=:50 {. 100 }. ddt
 tg4=:50 {. 150 }. ddt
 tg5=:50 {. 200 }. ddt
 tg6=:50 {. 250 }. ddt
 tg7=:50 {. 300 }. ddt
 tg8=: 350 }. ddt
 
NB. bad=: TEST ddt
NB. BAD ddt
