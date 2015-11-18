# Description 
vim-QandA is a Vim plugin that includes two separated parts: one for crawling transcript and panellist information from the website of the Australia talk show Q&A; another for showing these information in my favorite editor Vim.

# Prerequisites   
Make sure that Python and MySQL is installed.   

# Installation   
Copy plugin/vim-QandA to ~/.vim/bundle   
Or add a GitHub repository entry if you are using a Plugin Manager such as Vundle:  
```Plugin 'eduOS/vim-QandA'```  

# Configuration   
Change the database and password to your own.   
Add this line to your ~/.bashrc or ~/.zshrc if zsh is installed:
```alias qanda='cd ~/.vim/plugin/vim-QandA/autoload/QandA/ && python QandA.py yourpassword && cd -'```

# Functions
0. Crawling
    Open a command prompt and navigate to ~/.vim/plugin/vim-QandA/autoload/QandA/, then input python qanda. You'll see a message warning that the database is updated xx days ago and asking if you want to update the homepage or not. For instance:     
    ```You updated the database 17 days ago. y for update homepage and n for using old homepage?[y/n]```    
    After configuring the alias you can enter ```qanda``` under any directory to update the database.    
    All episodes from the first one in 2008 to the last one broadcasted in the last Monday will be downloaded into the folder named soupfiles. Each soup file will be named the episode's short code. By the same time all needed information in the HTML files will be extracted and saved into MySQL database.   
    The crawler will first search the soupfile directory for the file, and if the file doesn't exist then it will download it.    

1. Viewing the subtitile 
    Press ```:QandA``` in any Vim under any directory, and then a list will show you ten lastest episodes with the respective time and topic as titiles.    
    Hit Enter for the transcript.  

2. Reading the introduction of panellists    
    Pressing ```<leader>p``` will trigger a side window which shows the panel information of the episode.   

# Screenshots
![list](https://cloud.githubusercontent.com/assets/5717031/11239207/5ee52e0c-8e25-11e5-8ac1-8163c172657a.png)    
![details](https://cloud.githubusercontent.com/assets/5717031/11239711/a3276370-8e28-11e5-8579-e8188e55d4ee.png)

# Todo
- [ ] vim interface design and completion    
- [x] dump all transcript to database    
- [x] modify the dump_to_tatabase function through str mangement and line-by-line absorb    
- [x] optimize the refresh function allowing per episode refreshment.    
- [ ] alter database for every line    
- [ ] alter database for panellist    
    
# License     
MIT    

