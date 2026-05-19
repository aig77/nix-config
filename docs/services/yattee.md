# Ad-free YouTube with Yattee and Invidious

Yattee is an open-source YouTube client for iPhone, iPad, and Apple TV. It connects to
a self-hosted Invidious instance and streams video with no ads, no tracking, and no
Google account required (unless you want subscriptions).

## Contents

- [Install Yattee](#install-yattee)
- [Add the Invidious instance](#add-the-invidious-instance)
- [Log in to your account](#log-in-to-your-account)

---

## Install Yattee

### iPhone / iPad / Apple TV

1. Install [TestFlight](https://apps.apple.com/us/app/testflight/id899247664) from the App Store
2. Visit the Yattee TestFlight page from your device and tap **Accept** to join the beta
3. Install Yattee from TestFlight

---

## Add the Invidious instance

Yattee needs to know where your instance is and how to authenticate with the basic auth
protecting it. Embed credentials directly in the instance URL so Yattee sends them automatically.

1. Open Yattee
2. Go to **Settings -> Locations**
3. Tap **+** to add a new location
4. Set the URL 
5. Save and set it as the active location

If using basic auth when setting the URL
```
https://<username>:<password>@<domain>
```
Replace `<username>` and `<password>` with the basic auth credentials from your password manager.

---

## Log in to your account

Logging in gives you access to your subscriptions and watch history.

1. In Yattee, go to **Settings -> Accounts**
2. Tap **+** and select your instance
3. Enter your Invidious username and password
4. Tap **Sign in**

Your subscription feed will appear in the **Subscriptions** tab once logged in.

---

## Crashes

Yattee is in beta and frequently crashes. When this happens, close the application tab and reopen.
