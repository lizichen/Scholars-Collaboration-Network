### Regex is a powerful tool when tweaking minor changes.

The reason some HTML files returns zero byte is that the URLs for the request were NOT correctly encoded!  
Some names of the awardees have space in between.  

Thus, in order to replace a single space that appears in an awardee's name, we use Regex with Sublime:  

In sublime, we enable Regex Find, and type in this:   
(?<=[a-z])((\s)(?=[a-z]))  
This expression uses the look-around 'syntax' in Regular Expression.  
It captures any single space (\s) that has a letter in front of it, and a letter behind it.
