<#
    This is going to be mostly continuing/retesting the work found in this article:
    https://blog.jourdant.me/post/3-ways-to-download-files-with-powershell

    I am going to make a few changes to the above experiment. 
        1. I will be measuring time with Measure-Command.
        2. I will do tests with additional file sizes.
        3. I will be testing a claim from a user in the comments

    Question:
        Which powershell command downloads files fastest?

    Research:
        Background research led me to the article linked above. I learned of four
        different means of downloading files via powershell:
            1. Invoke Web-Request
            2. System.Net.WebClient
            3. Start-BitsTransfer 
            4. Invoke-RestMethod
        
    Hypothesis:
        Start-BitsTranser will be the fastest means of downloading a file, followed
        closesly by System.Net.Webclient. 

    Experiment:
        I will have each download method tested by downloading a 1MB, 10MB, and 100MB donwload.
        I will do this 10 times each and average the results. The 100MB download will come from two locations.
#>

$oneMbLink = "http://speedtest.tele2.net/1MB.zip"
$tenMbLink = "http://speedtest.tele2.net/10MB.zip"
$hundredMbLink = "http://speedtest.tele2.net/100MB.zip"
$hundredMbLinkAzure = "http://astsouthcentralus.blob.core.windows.net/private/100MB.bin?sv=2018-03-28&sr=b&sig=r%2FcElnQ6Bnq6LtjaI2Wr%2FOqmkFSfKK7pi%2FRGvP1IV5g%3D&se=2019-04-14T04%3A17%3A34Z&sp=r"

Function Average($array)
{
    $RunningTotal = 0;
    foreach($i in $array){
        $RunningTotal += $i
    }
    ([decimal]($RunningTotal) / [decimal]($array.Length));
}

function Invoke-Web-Request-Tests($link){
    $times = for ($i=1; $i -le 10; $i++)
    {
        (Measure-Command {
            Invoke-WebRequest $link
        }).TotalSeconds
    }
    $times
    "Average: $(Average($times))"
}

function Invoke-RestMethod-Tests($link){
    $times = for ($i=1; $i -le 10; $i++)
    {
        (Measure-Command {
            Invoke-RestMethod $link
        }).TotalSeconds
    }
    $times
    "Average: $(Average($times))"
}

function WebClient-Tests($link){
    $times = for ($i=1; $i -le 10; $i++)
    {
        (Measure-Command {
            $wc = New-Object System.Net.WebClient
            $wc.DownloadFile($link, ".\download.txt")
        }).TotalSeconds
    }
    $times
    "Average: $(Average($times))"
}

function Start-BitsTransfer-Tests($link){
    $times = for ($i=1; $i -le 10; $i++)
    {
        (Measure-Command {
            Import-Module BitsTransfer
            Start-BitsTransfer -Source $link -Destination ".\download.txt"
        }).TotalSeconds
    }
    $times
    "Average: $(Average($times))"
}

"Running Invoke-WebRequst with 1MB"
Invoke-Web-Request-Tests($oneMbLink)
"Running Invoke-WebRequst with 10MB"
Invoke-Web-Request-Tests($tenMbLink)
"Running Invoke-WebRequst with 100MB"
Invoke-Web-Request-Tests($hundredMbLink)
<#
Running Invoke-WebRequst with 1MB
1.5161971
0.7886524
0.7374395
0.7558564
0.7045402
0.769086
0.7218009
0.692916
0.7240663
0.8156742
Average: 0.8226229
Running Invoke-WebRequst with 10MB
5.7736487
6.6065369
6.0443815
6.0509011
6.0851449
6.2723385
6.2641916
6.0859289
5.9762944
6.1041186
Average: 6.12634851
Running Invoke-WebRequst with 100MB
56.1397095
56.1236164
55.6004959
55.0313427
56.9979355
56.1850399
55.5896057
56.5924552
54.9441001
55.2224092
Average: 55.84267101
#>
<#
"Running Invoke-RestMethod with 1MB"
Invoke-RestMethod-Tests($oneMbLink)
"Running Invoke-RestMethod with 10MB"
Invoke-RestMethod-Tests($tenMbLink)
"Running Invoke-RestMethod with 100MB"
Invoke-RestMethod-Tests($hundredMbLink)
<#
Running Invoke-RestMethod with 1MB
1.5895038
0.313075
0.2760911
0.3122168
0.1653443
0.1737371
0.1698305
0.169769
0.1821569
0.1959771
Average: 0.35477016
Running Invoke-RestMethod with 10MB
0.9774124
1.2459251
3.0853141
0.8154364
3.1008629
1.1380875
1.5616096
1.4570539
1.3533228
1.9577918
Average: 1.66928165
Running Invoke-RestMethod with 100MB
9.9583319
9.0274981
10.211099
11.0222813
9.6016804
7.3501591
11.2223997
6.6810417
6.1284201
7.8534753
Average: 8.90563866
#>
<#
"Running WebClient with 1MB"
WebClient-Tests($oneMbLink)
"Running WebClient with 10MB"
WebClient-Tests($tenMbLink)
"Running WebClient with 100MB"
WebClient-Tests($hundredMbLink)
<#
Running WebClient with 1MB
1.2647589
0.3008209
0.1667061
0.1966074
0.1695686
0.1832384
0.1900556
0.1628481
0.1648236
0.1780684
Average: 0.2977496
Running WebClient with 10MB
1.0538276
1.0767185
0.8753246
1.095031
1.1956791
1.2373001
1.1901512
1.2070169
1.264783
1.1428176
Average: 1.13386496
Running WebClient with 100MB
7.9119967
8.5090727
8.0327779
5.9505821
6.1520082
7.0238255
5.3316884
7.1033619
6.0243061
13.5896698
Average: 7.56292893
#>
<#
"Running Start-BitsTransfer with 1MB"
Start-BitsTransfer-Tests($oneMbLink)
"Running Start-BitsTransfer with 10MB"
Start-BitsTransfer-Tests($tenMbLink)
"Running Start-BitsTransfer with 100MB"
Start-BitsTransfer-Tests($hundredMbLink)
<#
Running Start-BitsTransfer with 1MB
4.5028253
1.0123953
0.5915166
0.5880506
0.5805889
0.5865911
0.575358
0.5578156
0.5824598
0.5835176
Average: 1.01611188
Running Start-BitsTransfer with 10MB
1.5202045
2.8797967
0.9778446
2.1174154
2.1307203
1.506637
1.5019922
3.7254112
2.1271743
1.4950911
Average: 1.99822873
Running Start-BitsTransfer with 100MB
9.2423993
7.8656282
12.1668675
12.2279424
9.2428977
7.9145892
6.6736592
9.2945325
12.2396943
9.2096295
Average: 9.60778398
#>
#>
<#
    Results:
        Invoke-WebRequest:  0.8226229  / 6.12634851 / 55.84267101
        Invoke-RestMethod:  0.35477016 / 1.66928165 / 8.90563866
        WebClient:          0.2977496  / 1.13386496 / 7.56292893
        Start-BitsTransfer: 1.01611188 / 1.99822873 / 9.60778398

    Analysis:
        First, I didn't end up using two different 100MB links because the other one I picked out didn't
        work.

        The results of this were somewhat surprising, but also made me realize I have an error in my test method. 
        I had been writing and running each of these functions one by one. While one was running I was writing the next one. 
        The issue here is that they were all ran about ~1.5 minutes apart. So there could be significant differences in 
        the current internet speed. (I'm currently on wifi, I plan on testing a wired connection as well). 

        So before unpacking the results, I'm going to run them all again at the same time and post the results below:

        Running Invoke-WebRequst with 1MB
        1.4590302
        0.781127
        0.8419818
        0.8148786
        0.7661898
        0.7506612
        0.7181204
        0.7913412
        0.7312735
        0.808422
        Average: 0.84630257
        Running Invoke-WebRequst with 10MB
        5.8024868
        6.017806
        6.1183596
        6.0368373
        6.2269953
        6.0036227
        6.1104488
        6.0527138
        6.2904312
        6.0718691
        Average: 6.07315706
        Running Invoke-WebRequst with 100MB
        52.4944756
        44.1172568
        43.7782259
        43.3651827
        44.2677952
        44.117776
        44.2091928
        43.2354629
        44.1153977
        44.0491184
        Average: 44.7749884
        Running Invoke-RestMethod with 1MB
        0.9547081
        0.1976097
        0.1743575
        0.2068729
        0.1692048
        0.1970084
        0.1947592
        0.2520111
        0.1955888
        0.1708396
        Average: 0.27129601
        Running Invoke-RestMethod with 10MB
        2.8016891
        1.3717726
        1.5247485
        1.7585285
        1.863579
        1.6440584
        4.0641536
        0.781362
        1.9902017
        2.0263762
        Average: 1.98264696
        Running Invoke-RestMethod with 100MB
        10.8476873
        10.3923892
        10.1743812
        7.7793882
        7.8148705
        8.0776949
        6.6788721
        12.5183376
        9.8924617
        10.7082185
        Average: 9.48843012
        Running WebClient with 1MB
        0.1909914
        0.1729925
        0.1660624
        0.1768583
        0.1775747
        0.1813167
        0.1604095
        0.1762549
        0.2057616
        0.1789744
        Average: 0.17871964
        Running WebClient with 10MB
        2.9455296
        1.481995
        3.4995218
        0.926637
        1.3701729
        1.3904663
        1.1890144
        2.999926
        0.64914
        2.9118452
        Average: 1.93642482
        Running WebClient with 100MB
        7.5598053
        9.7442319
        13.6445695
        5.4902219
        5.9523368
        9.9088819
        8.9772493
        7.9076325
        7.0044484
        10.3358377
        Average: 8.65252152
        Running Start-BitsTransfer with 1MB
        4.3460798
        0.9807938
        0.5942814
        0.5764067
        0.5677993
        0.5680081
        0.5731619
        0.5962049
        0.5669676
        0.5612161
        Average: 0.99309196
        Running Start-BitsTransfer with 10MB
        1.5125623
        2.1116868
        1.5030766
        2.8193822
        2.1132664
        1.4864112
        2.1143755
        1.4865156
        2.1004067
        2.1002945
        Average: 1.93479778
        Running Start-BitsTransfer with 100MB
        15.4708883
        13.8299563
        12.1790976
        10.6592147
        9.2013011
        5.5120651
        7.896546
        9.1800047
        6.6616656
        12.1554037
        Average: 10.27461431

        
    Results:
        Invoke-WebRequest:  0.84630257 / 6.07315706 / 44.7749884
        Invoke-RestMethod:  0.27129601 / 1.98264696 / 9.48843012
        WebClient:          0.17871964 / 1.93642482 / 8.65252152
        Start-BitsTransfer: 0.99309196 / 1.93479778 / 10.27461431

    Final Analysis: 
        So all-in-all both sets of results are fairly similar. BitTransfer seems 
        pretty fast, but takes longer to setup than most. WebClient is the fastest option most
        of the time, with RestMethod being the surprising second fastest most of the time. WebRequest
        gets virtually unusable pretty quickly. 

    Final Test:
        One last thing I wanted to test was a claim from the comments of the artile this test
        is based off of. They proposed a way to speed up Invoke-WebRequest.
#>
function Invoke-Web-Request-Optimized-Tests($link){
    $CurrentProgressPref = $ProgressPreference;
    $ProgressPreference = "SilentlyContinue";
    $times = for ($i=1; $i -le 10; $i++)
    {
        (Measure-Command {
            Invoke-WebRequest $link
        }).TotalSeconds
    }
    
    $ProgressPreference = $CurrentProgressPref;
    $times
    "Average: $(Average($times))"
}

"Running Invoke-WebRequst-Optimized with 1MB"
Invoke-Web-Request-Optimized-Tests($oneMbLink)
"Running Invoke-WebRequst-Optimized with 10MB"
Invoke-Web-Request-Optimized-Tests($tenMbLink)
"Running Invoke-WebRequst-Optimized with 100MB"
Invoke-Web-Request-Optimized-Tests($hundredMbLink)

<#
Running Invoke-WebRequst with 1MB
1.7098419
0.9157529
0.6915088
0.5964099
0.6074437
0.496941
0.6687557
0.6420786
0.6333032
0.6022311
Average: 0.75642668
Running Invoke-WebRequst with 10MB
4.6287043
5.2772219
5.3513447
5.3457496
5.0091718
5.0254079
4.981079
5.0445241
5.0801798
4.9356364
Average: 5.06790195
Running Invoke-WebRequst with 100MB
44.3925821
44.1298553
44.6541568
44.998179
43.4603344
43.6377916
44.7825363
44.3160855
44.3173599
44.8205176
Average: 44.35093985
Running Invoke-WebRequst-Optimized with 1MB
1.0460973
0.2165126
0.2260302
0.2162199
0.21613
0.2179644
0.2254777
0.2477142
0.2122217
0.1893719
Average: 0.30137399
Running Invoke-WebRequst-Optimized with 10MB
1.5992171
1.5315838
1.9182052
1.233425
1.5847146
1.608526
2.1745161
1.0230366
1.5349651
3.3988344
Average: 1.76070239
Running Invoke-WebRequst-Optimized with 100MB
8.6550703
8.9407017
10.6219385
8.6456652
9.4719794
9.6547213
10.4584951
12.1410685
9.5373941
8.0030716
Average: 9.61301057

    Results:
        Non-Optmized: 0.75642668 / 5.06790195 / 44.35093985
        Optimized:    0.30137399 / 1.76070239 / 9.61301057

    Analysis:
        I truly wasn't expecting this to have such a large impact, but using this setup with
        Invoke-WebRequest makes it to where it can pretty well keep pace with the other download
        methods. 
#>