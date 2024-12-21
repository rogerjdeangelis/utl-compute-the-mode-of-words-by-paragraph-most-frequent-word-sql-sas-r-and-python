%let pgm=utl-compute-the-mode-of-words-by-paragraph-most-frequent-word-sql-sas-r-and-python;

Compute the mode of words in nine paragraphs most frequent word sql sas r and python

 SOLUTIONS

    1 SAS SQL
    2 R SQL
    3 PYHTON SQL


SOAPBOX ON

Not as slow as you might think, depends on the compiler, also easy to parallelize?
Fat datasets tend to be slow? Teradata sql tends to be fast?
Compilers tend to like repetitive code?

Python SQL looks like the exception?

SOAPBOX OFF

github
https://tinyurl.com/4rxc8khr
https://github.com/rogerjdeangelis/utl-compute-the-mode-of-words-by-paragraph-most-frequent-word-sql-sas-r-and-python

sas community
https://tinyurl.com/5fr9r68d
https://communities.sas.com/t5/SAS-Programming/Getting-most-frequent-value-across-columns/m-p/953772#M372565

/*               _     _
 _ __  _ __ ___ | |__ | | ___ _ __ ___
| `_ \| `__/ _ \| `_ \| |/ _ \ `_ ` _ \
| |_) | | | (_) | |_) | |  __/ | | | | |
| .__/|_|  \___/|_.__/|_|\___|_| |_| |_|
|_|
*/

/**************************************************************************************************************************/
/*                                                      |                                             |                   */
/*         INPUT                                        |              PROCESS                        |     OUTPUT        */
/*         =====                                        |              =======                        |                   */
/*                                                      |                                             |                   */
/*   options validvarname=upcase;                       |  1 SAS SQL (SAME CODE IN R AND PYTHON)      | ID    HPS  COUNT  */
/*   libname sd1 "d:/sd1";                              |  =====================================      |                   */
/*   data sd1.have;                                     |                                             |  1    PPO     9   */
/*   input id 1                                         |  FIRST TRANSPOSE                            |  2    PDP    10   */
/*      hp_01 $ 3-5   hp_02 $ 7-9   hp_03 $ 11-13       |                                             |  3    EDP     6   */
/*      hp_04 $ 15-17 hp_05 $ 19-21 hp_06 $ 23-25       |  select id, hp_01 as hps from have union all|  4    MCO     9   */
/*      hp_07 $ 27-29 hp_08 $ 31-33 hp_09 $ 35-37       |  select id, hp_02 as hps from have union all|  5    EDP     6   */
/*      hp_10 $ 39-41 hp_11 $ 43-45 hp_12 $ 47-49;      |  select id, hp_03 as hps from have union all|  6    MCO     5   */
/*   cards4;               9 PPOs                       |  select id, hp_04 as hps from have union all|  7    NET     5   */
/*                 -----------------------------------  |  select id, hp_05 as hps from have union all|  8    PPO     5   */
/*   1 MCO MCO MCO PPO PPO PPO PPO PPO PPO PPO PPO PPO  |  select id, hp_06 as hps from have union all|  9    PPO     8   */
/*   2 PDP PDP PDP PDP PDP PDP PDP PDP PDP PDP MCO MCO  |  select id, hp_07 as hps from have union all|                   */
/*   3 EDP EDP EDP EDP EDP EDP PPO PPO PPO PPO PPO PPO  |  select id, hp_08 as hps from have union all|                   */
/*   4 MCO MCO MCO MCO MCO MCO MCO MCO MCO EDP EDP EDP  |  select id, hp_09 as hps from have union all|                   */
/*   5 EDP EDP EDP EDP MCO MCO PPO PPO PPO PPO EDP EDP  |  select id, hp_10 as hps from have union all|                   */
/*   6 MCO NET NET NET EDP EDP NET NET MCO MCO MCO MCO  |  select id, hp_11 as hps from have union all|                   */
/*   7 PPO PPO PPO NET NET NET NET NET PPO PPO MCO MCO  |  select id, hp_12 as hps from have          |                   */
/*   8 EDP MCO MCO MCO PPO PPO PPO PPO PPO NET NET NET  |                                             |                   */
/*   9 NET NET NET NET PPO PPO PPO PPO PPO PPO PPO PPO  |  Then FIND MODE (Most FREQUENT WORD         |                   */
/*                                                      |                                             |                   */
/*   ;;;;                                               |                                             |                   */
/*   run;quit;                                          |  select                                     |                   */
/*                                                      |    id                                       |                   */
/*                                                      |   ,hps                                      |                   */
/*                                                      |   ,count                                    |                   */
/*                                                      |  from (                                     |                   */
/*                                                      |    select                                   |                   */
/*                                                      |      id                                     |                   */
/*                                                      |     ,hps                                    |                   */
/*                                                      |     ,count(*) as count                      |                   */
/*                                                      |    from                                     |                   */
/*                                                      |      havXpo                                 |                   */
/*                                                      |    group                                    |                   */
/*                                                      |      by id, hps)                            |                   */
/*                                                      |  group                                      |                   */
/*                                                      |    by id                                    |                   */
/*                                                      |  having                                     |                   */
/*                                                      |    count=max(count)                         |                   */
/*                                                      |                                             |                   */
/*                                                      |                                             |                   */
/*                                                      |                                             |                   */
/*                                                      |                                             |                   */
/*                                                      |                                             |                   */
/*                                                      |                                             |                   */
/*                                                      |                                             |                   */
/*                                                      |                                             |                   */
/*                                                      |                                             |                   */
/*                                                      |                                             |                   */
/*                                                      |                                             |                   */
/*                                                      |                                             |                   */
/************************************************************************** ***********************************************/

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/


options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have;
input id 1
   hp_01 $ 3-5   hp_02 $ 7-9   hp_03 $ 11-13
   hp_04 $ 15-17 hp_05 $ 19-21 hp_06 $ 23-25
   hp_07 $ 27-29 hp_08 $ 31-33 hp_09 $ 35-37
   hp_10 $ 39-41 hp_11 $ 43-45 hp_12 $ 47-49;
cards4;

1 MCO MCO MCO PPO PPO PPO PPO PPO PPO PPO PPO PPO
2 PDP PDP PDP PDP PDP PDP PDP PDP PDP PDP MCO MCO
3 EDP EDP EDP EDP EDP EDP PPO PPO PPO PPO PPO PPO
4 MCO MCO MCO MCO MCO MCO MCO MCO MCO EDP EDP EDP
5 EDP EDP EDP EDP MCO MCO PPO PPO PPO PPO EDP EDP
6 MCO NET NET NET EDP EDP NET NET MCO MCO MCO MCO
7 PPO PPO PPO NET NET NET NET NET PPO PPO MCO MCO
8 EDP MCO MCO MCO PPO PPO PPO PPO PPO NET NET NET
9 NET NET NET NET PPO PPO PPO PPO PPO PPO PPO PPO

;;;;
run;quit;

/*                             _
/ |  ___  __ _ ___   ___  __ _| |
| | / __|/ _` / __| / __|/ _` | |
| | \__ \ (_| \__ \ \__ \ (_| | |
|_| |___/\__,_|___/ |___/\__, |_|
                            |_|
*/

%array(_vs,values=hp_01-hp_12);

%put &=_vs1;  /*--- VS_1  = hp_01 ---*/
%put &=_vs12; /*--- VS_12 = hp_12 ---*/
%put &=_vsn;  /*--- VSN   = 12    ---*/

/*---- generate the code ----*/

data _null_;
 put %do_over(_vs,phrase=%str("select id, ? as hps from have union all" /));
run;quit;

/*---- paste from the log                 ----*/
.*--- for a dynamic result embed do_over  ----*/
proc sql;

  create
     view havXpo as
  select id, hp_01 as hps from have union all
  select id, hp_02 as hps from have union all
  select id, hp_03 as hps from have union all
  select id, hp_04 as hps from have union all
  select id, hp_05 as hps from have union all
  select id, hp_06 as hps from have union all
  select id, hp_07 as hps from have union all
  select id, hp_08 as hps from have union all
  select id, hp_09 as hps from have union all
  select id, hp_10 as hps from have union all
  select id, hp_11 as hps from have union all
  select id, hp_12 as hps from have
;

/*---- the inner select just gets counts for each ----*/

  create
    table want as
  select
    id
   ,hps
   ,count
  from (
    select
      id
     ,hps
     ,count(*) as count
    from
      havXpo
    group
      by id, hps)
  group
    by id
  having
    count=max(count)

;quit;

/*___                     _
|___ \   _ __   ___  __ _| |
  __) | | `__| / __|/ _` | |
 / __/  | |    \__ \ (_| | |
|_____| |_|    |___/\__, |_|
                       |_|
*/

proc datasets lib=sd1 nolist nodetails;
 delete want;
run;quit;


%utl_rbeginx;
parmcards4;
library(haven)
library(sqldf)
source("c:/oto/fn_tosas9x.R")
have<-read_sas("d:/sd1/have.sas7bdat")
print(have)
want<-sqldf('
   with
     havxpo as
   (
    select id, hp_01 as hps from have union all
    select id, hp_02 as hps from have union all
    select id, hp_03 as hps from have union all
    select id, hp_04 as hps from have union all
    select id, hp_05 as hps from have union all
    select id, hp_06 as hps from have union all
    select id, hp_07 as hps from have union all
    select id, hp_08 as hps from have union all
    select id, hp_09 as hps from have union all
    select id, hp_10 as hps from have union all
    select id, hp_11 as hps from have union all
    select id, hp_12 as hps from have
   )
  select
    id
   ,hps
   ,count
  from (
    select
      id
     ,hps
     ,count(*) as count
    from
      havXpo
    group
      by id, hps)
  group
    by id
  having
    count=max(count)
   ');
want;
fn_tosas9x(
      inp    = want
     ,outlib ="d:/sd1/"
     ,outdsn ="want"
     )
;;;;
%utl_rendx;

proc print data=sd1.want;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*   R                  SAS                                                                                               */
/*                                                                                                                        */
/*     id hps count     ROWNAMES    ID    HPS    COUNT                                                                    */
/*                                                                                                                        */
/*   1  1 PPO     9         1        1    PPO       9                                                                     */
/*   2  2 PDP    10         2        2    PDP      10                                                                     */
/*   3  3 EDP     6         3        3    EDP       6                                                                     */
/*   4  4 MCO     9         4        4    MCO       9                                                                     */
/*   5  5 EDP     6         5        5    EDP       6                                                                     */
/*   6  6 MCO     5         6        6    MCO       5                                                                     */
/*   7  7 NET     5         7        7    NET       5                                                                     */
/*   8  8 PPO     5         8        8    PPO       5                                                                     */
/*   9  9 PPO     8         9        9    PPO       8                                                                     */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*____               _   _                             _
|___ /   _ __  _   _| |_| |__   ___  _ __    ___  __ _| |
  |_ \  | `_ \| | | | __| `_ \ / _ \| `_ \  / __|/ _` | |
 ___) | | |_) | |_| | |_| | | | (_) | | | | \__ \ (_| | |
|____/  | .__/ \__, |\__|_| |_|\___/|_| |_| |___/\__, |_|
        |_|    |___/                                |_|
*/

proc datasets lib=sd1 nolist nodetails;
 delete pywant;
run;quit;

%utl_pybeginx;
parmcards4;
exec(open('c:/oto/fn_python.py').read());
have,meta = ps.read_sas7bdat('d:/sd1/have.sas7bdat');
want=pdsql('''                                     \
    with                                           \
      havxpo as                                    \
    (                                              \
     select id, hp_01 as hps from have union all   \
     select id, hp_02 as hps from have union all   \
     select id, hp_03 as hps from have union all   \
     select id, hp_04 as hps from have union all   \
     select id, hp_05 as hps from have union all   \
     select id, hp_06 as hps from have union all   \
     select id, hp_07 as hps from have union all   \
     select id, hp_08 as hps from have union all
     select id, hp_09 as hps from have union all   \
     select id, hp_10 as hps from have union all   \
     select id, hp_11 as hps from have union all   \
     select id, hp_12 as hps from have             \
    )                                              \
   select                                          \
     id                                            \
    ,hps                                           \
    ,count                                         \
   from (                                          \
     select                                        \
       id                                          \
      ,hps                                         \
      ,count(*) as count                           \
     from                                          \
       havXpo                                      \
     group                                         \
       by id, hps)                                 \
   group                                           \
     by id                                         \
   having                                          \
     count=max(count)                              \
   ''')
print(want);
fn_tosas9x(want,outlib='d:/sd1/',outdsn='pywant',timeest=3);
;;;;
%utl_pyendx;

proc print data=sd1.pywant;
run;quit;


/**************************************************************************************************************************/
/*                                                                                                                        */
/*  PYTHON                   SAS                                                                                          */
/*                                                                                                                        */
/*       id  hps  count      ID    HPS    COUNT                                                                           */
/*                                                                                                                        */
/*   0  1.0  PPO      9       1    PPO       9                                                                            */
/*   1  2.0  PDP     10       2    PDP      10                                                                            */
/*   2  3.0  EDP      6       3    EDP       6                                                                            */
/*   3  4.0  MCO      9       4    MCO       9                                                                            */
/*   4  5.0  EDP      6       5    EDP       6                                                                            */
/*   5  6.0  MCO      5       6    MCO       5                                                                            */
/*   6  7.0  NET      5       7    NET       5                                                                            */
/*   7  8.0  PPO      5       8    PPO       5                                                                            */
/*   8  9.0  PPO      8       9    PPO       8                                                                            */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
