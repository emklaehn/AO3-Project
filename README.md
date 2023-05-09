# AO3-Project

---

This is a project where I scrape and analyze data from AO3 (Archive of Our Own). AO3 is a popular website containing tons of fanfiction data. More of the data is discussed in the R Markdown code or HTML, called "AO3-final.Rmd" or "AO3-final.html".

### Web Scraping the Data

If you are needing to scrape the AO3 data, use "WebScraping.ipynb" to do that. There are instructions in the Jupyter notebook that tells you how to do that. To use the code, one will need to install the pandas and bs4 Python libraries. Use the following code below in your terminal or environment to do so:

```
pip install bs4
pip install pandas
```

### Use My Dataset

If you would rather not use the webscraper, you can use my dataset [here](https://drive.google.com/file/d/1zj4q_QqtkZpz7U5FeNxYR9D7rOPG4JkE/view?usp=share_link) (this is a link to my CSV file in Google Drive). I could not upload the dataset to GitHub since it was too large of a file.

### What is the Project?

Physical book data can be hard to gather, especially trying to find accurate numbers since books can be bought or borrowed, but with AO3, since everything is digital, it is very easy to find the number of views a certain piece of fiction has or how well received it was (through likes). Although it is a fan site filled with fan-made works, it can still provide a lot of information for writers and companies for these different movies, TV series, and books by finding what the fans and audience tends to like and enjoy on this website. Along with AO3 being capable of tracking the number of views and likes on the fanfiction, the website also has a comprehensive tagging system that the fanfiction authors can use. This tagging system can help to find the main aspects of the work that draws readers to it with tags, such as ‘angst’, ‘fluff’, and ‘alternate universe’.

By using the AO3 data, different popular media companies and independent writers may be able to determine what ideas and concepts may aid in the process of determining how to increase or maximize the number of likes. One can look at the general rating (general audiences, teens and up, mature audiences, etc.), number of comments (to determine engagement), length (with the number of chapters or word count), and several other variables to determine how a book or movie can gain more views. Additionally, this can be beneficial to fanfiction authors and readers if they wish to find out what variables aid most in gaining the most views generally (across all movies, books, and TV shows) or specifically for one book or movie.

### Using the R Shiny Application
 
To use this application, one will need to download [this](https://drive.google.com/file/d/1fo9bNmBmMJeZ9AUkP2ZQ0rbMCB05czkn/view?usp=share_link) data set into the "R-shiny" folder.
 
Additionally, this application would not compile on my R-Studio, so I do not know if it actually workd presently. This is something that will be fix in the future, but for the moment, it is just code.
