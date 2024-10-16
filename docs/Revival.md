# Summary of the problems

Real time active visitors were broken because UA.
Authentication is flawed: usign a personal OAuth2 token for the API to query GA4.


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


Also:
No testing
No CI
No smoke tests to ensure it's still running


# What we've done to look into them

We need to:
- Translate the UA to GA4
- Refactor the auth to use a service account. Separate it from user auth to the app.

Tweaks needed to the existing design


# What's next

- Better user auth: OAuth2? Or Intranet (no auth, as long as it's running on the office wifi).
- Refactor Frontend: the way it's engineered is outdated, vanilla, and a bit unorthodox, which could throw off people.
At least refactoring the code in to modules and functions that get bundled would be great.
