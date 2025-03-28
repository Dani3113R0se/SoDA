
******************************************************************************
Readme for The Politics of Rejection: Explaining Chinese Import Refusals

Sung Eun Kim, Rebecca L. Perlman, and Grace Zeng

American Journal of Political Science
******************************************************************************

**************
In this README file, we provide a brief description of the files required to reproduce all analytic results of the article, "The Politics of Rejection: Explaining Chinese Import Refusals."


All analysis was conducted using Stata/MP 16.0 and R version 4.2.3 on macOS Sonoma version 14.2.1.

*************
List of files
*************

1. Readme.txt: this Readme file.
2. sps_main.dta: Stata dataset used for all the analyses presented in the main manuscript and the supplementary information.
3. sps_korea_port.data: Stata dataset used for calculating the share of entry ports that rejected Korean cosmetic and food products during the time of conflicts.
4. sps_table.do: State do-file that reproduces all tables in the main manuscript and the supplementary information. It also includes a note about the Stata modules needed to be installed to run the analyses (estout and twopm).
5. sps_figure.R: R script that reproduces all figures in the main manuscript and the supplementary information. 
6. sps_table_log.log: Log file for running sps_table.do.
7. sps_table_log.pdf: PDF version of log file that highlights the statistical results reported in the manuscript.
8. sps_figure_log.log: Log file for running sps_figure.R.
9. sps_codebook.pdf: Codebook for sps_main.dta and sps_korea_port.dta

*******************
Required R Packages 
*******************

1. haven (Version 2.5.4)
2. ggplot2 (Version 3.5.1)
3. dplyr (Version 1.1.4)

*************************
Required Stata ado files
*************************

1. estout (Version 3.31)
2. twopm (Version 1.2.3)

*************
Data Sources
*************

1. China's Import refusal:

1) Government (or government-affiliated) entities: customs.gov.cn/spj, cqn.com.cn
2) China's state media: xinhuanet.com, jjckb.xinhuanet.com, politics.people.com.cn, news.cctv.com
3) Private entities: cccfna.org.cn, antion.net, reach24h.com, cirs-group.com, m.shagarova.com, inews.ifeng.com, hn.rednet.cn/c, m.antpedia.com, m.thepaper.cn, ppfocus.com, kknews.cc, cocukyurdu.com, thepaper.cn, anytesting.com, finance.ce.cn

2. GDELT Data: https://www.gdeltproject.org/data.html

Leetaru, Kalev, and Philip A Schrodt. 2013. Gdelt: Global data on events, location, and tone, 1979–2012. In ISA annual convention. Vol. 2 pp. 1–49. 

3. World Organization for Animal Health (formerly OIE): http://wahis.woah.org/#/dashboards/qd-dashboard

4. UN Comtrade database: https://comtradeplus.un.org

