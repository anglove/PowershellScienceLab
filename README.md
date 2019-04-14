# PowershellScienceLab
Testing various powershell interactions and observing the results.

## WebScience
### File Download Speed Test
This is going to be mostly continuing/retesting the work found in this article:
https://blog.jourdant.me/post/3-ways-to-download-files-with-powershell

I am going to make a few changes to the above experiment. 
1. I will be measuring time with Measure-Command.
2. I will do tests with additional file sizes.
3. I will be testing a claim from a user in the comments

#### Question:
Which powershell command downloads files fastest?

#### Research:
Background research led me to the article linked above. I learned of four
different means of downloading files via powershell:
1. Invoke Web-Request
2. System.Net.WebClient
3. Start-BitsTransfer 
4. Invoke-RestMethod

#### Hypothesis:
Start-BitsTranser will be the fastest means of downloading a file, followed
closesly by System.Net.Webclient. 

#### Experiment:
I will have each download method tested by downloading a 1MB, 10MB, and 100MB donwload.
I will do this 10 times each and average the results. The 100MB download will come from two locations.

#### Results:

|        Method       |     1MB     |     10MB    |     100MB     |
|---------------------|-------------|-------------|---------------|
| Invoke-WebRequest   | 0.84630257s | 6.07315706s | 44.7749884s   |
| Invoke-RestMethod   | 0.27129601s | 1.98364696s | 9.48843012s   |
| WebClient           | 0.17871964s | 1.93642482s | 8.65252152s   |
| Start-BitsTransfer  | 0.99309196s | 1.93479778s | 10.27461431s  |

I didn't end up using two different 100MB links because the other one I picked out didn't work.
        
After getting these results, I did the same test exclusively for Invoke-WebRequest along with the optimization suggestion from the comments of the above posted article.

|           Method             |     1MB     |     10MB    |     100MB    |
|------------------------------|-------------|-------------|--------------|
|     Invoke-WebRequest        | 0.75642668s | 5.06790195s | 44.35093985s |
| Invoke-WebRequest(Optimized) | 0.30137399s | 1.76070239s | 9.61301057s  |

Much to my surprise, the suggested changes **dramatically** improved the performance of Invoke-WebRequest.
