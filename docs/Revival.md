# Context

There used to be this dashboard on the TV displays in the office, showcasing real time metrics such as number of visitors, popular content, live searches etc.
It stopped working, and the people maintainint left, and eventually, it got archived.

Our: to revive

# Summary of the problems

Summary of the problems
What we've done to look into them
Tweaks needed to the existing design
What's next

Application had been abandoned: unsupported, and those who had supported it had left.
Application had been archived
Application could not start / boot on Heroku
Real time live searches were broken because UA.
	- App had to be migrated to GA4 since UA got deprecated. That's one of the reason why the app was archived in the first place.
, and no one was supporting anymore.




# What we've done to look into them

- I don't know Ruby. Although re-writting it in Python was a low hanging fruit, it wouldn't be so wise if the goal is to ensure the app can be supported across gov.uk & GDS teams in the future.


- Had to learn Ruby's fundamental to understand the source code, and be able to modify it and debug it.

- The application needed to connect to GA, and run in Heroku. GA credentials in heroku.
Getting acces to Heroku was difficult:
	- 2FA token is burried somewhere in AWS Secrets Manager
	- My AWS account had to be re-enabled
	- Production permissions had to be granted to me to access Secrets Manager
	- Setting up AWS 2FA had its issues

	Overall, took a few days to gain access, and involved a handful of people from support teams. Not ideal if this process was to be repeated.
	On the good side, I now have access to Heroku if we want do work with it more in this new quarter.


- Authentication was relying on OAuth2.0, which is not ideal for GA4 authentication. A service 

- GA4 Credentials / tokens were not in Heroku, as the app had been deleted all together with its secrets. I did not have access to its GCP project neither
-> I revamped the authentication layer of the application, and enjoyed this opportunity to simplifythe code a little bit, making app maintenance hopefully easier in the future, at least for me who isn't a Senior Ruby dev.
Created a new GCP project with a service account. Kudos to Anne for giving the SA perms in GA4.


- Using a SA in Heroku isn't straightforward and had to come up with a workaraound.


Moving from UA to GA4:
- wrote some new code for it
- Before the UA request was crafted both in the frontend and backend, now backend only, more straightforward and easier to maintain
- Kudos to Anne for looking into this as well and showing me how realtime metrics work

PB: cannot fetch live searches atm in GA4. Explain issue.
-> Displaying page titles with the most live searches instead.

Deployed to Heroku last night.

- Translate the UA to GA4
- Refactor the auth to use a service account. Separate it from user auth to the app.

Credentials:

	1.	I couldn’t test or deploy the app because I didn’t have Heroku access.
	2.	The app relied on secrets stored in Heroku to run locally and fetch third-party data like Google Analytics.
	3.	I got the Heroku credentials, but Heroku required 2FA.
	4.	Setting up 2FA required a TOTP secret stored in AWS, which I couldn’t access.
	5.	The TOTP secret was only accessible through the production AWS account, and I no longer had an AWS account.
	6.	I had to reactivate my AWS account.
	7.	Then I needed access to AWS Secret Manager for the TOTP secret.
	8.	We tried to avoid giving me production AWS access, but it was the only solution.
	9.	After gaining production access through Terraform, I still couldn’t access the secret manager due to 2FA requirements.
	10.	I set up 2FA for AWS and finally accessed the TOTP secret.
	11.	I logged into Heroku but discovered the app and its secrets had been deleted.
	12.	I created a new GCP project with new OAuth 2.0 tokens and will connect it to Google Analytics to run the app.


Auth in Heroku: we can't store credentials as a file for security since with Heroku it would need to be commited.
So had to use a workaround where I store the credentials as a env var, and then at run time I save it to a local file, and then trigger the Google authentication, but this file will never be commited.


Also:
No testing
No CI
No smoke tests to ensure it's still running



# What's next

- Revive an old data stream: "Recent Content"
- Try one more thing for the live searches
- Work on design improvements: @Sumi


There's:
- no tests
- no CI
- no Smoke tests

Depending on how critical the app is, we might want to consider the above to abide by 2nd line's standards.
- Refactor Frontend: the way it's engineered is outdated, vanilla, and a bit unorthodox, which could throw off people.
At least refactoring the code in to modules and functions that get bundled would be great.



