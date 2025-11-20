library(git2r)
library(rstudioapi) # This helps with the password popup

# 1. Re-load your repo connection
repo <- repository("~/Project_Solution")

# 2. Push to GitHub
# This will open a popup box asking for your Password/Token.
# username: zoranic1005
push(repo, name = "origin", refspec = "refs/heads/master", 
     credentials = cred_user_pass("zoranic1005", askForPassword("Enter GitHub PAT (Token)")))