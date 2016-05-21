App.info({
  id: 'com.findashindig.app',
  name: 'Shindig',
  description: 'An event discovery app, powered by Facebook.',
  version: '0.2.1',
  author: 'Chet Corcos',
  email: 'ccorcos@gmail.com',
  website: 'http://findashindig.com'
});

App.accessRule('*');

App.setPreference('BackgroundColor', '0x000000ff', 'ios');
App.setPreference('DisallowOverscroll', 'true');

// using mobile-status-bar package that uses the cordova packages
App.setPreference('StatusBarOverlaysWebView', 'true');
App.setPreference('StatusBarBackgroundColor', '#000000');
App.setPreference('StatusBarStyle', 'lightcontent');

App.icons({
  // iOS
  'iphone': 'public/icons/icon60.png',
  'iphone_2x': 'public/icons/icon120.png',
  'iphone_3x': 'public/icons/icon180.png',
  'ipad': 'public/icons/icon76.png',
  'ipad_2x': 'public/icons/icon152.png',

  // Android
  'android_ldpi': 'public/icons/icon36.png',
  'android_mdpi': 'public/icons/icon48.png',
  'android_hdpi': 'public/icons/icon72.png',
  'android_xhdpi': 'public/icons/icon96.png'
});

App.launchScreens({
  // iOS
  'iphone': 'resources/splash/splash320x480.png',
  'iphone_2x': 'resources/splash/splash320x480@2x.png',
  'iphone5': 'resources/splash/splash320x568@2x.png',
  'iphone6': 'resources/splash/splash375x667@2x.png',
  'iphone6p_portrait': 'resources/splash/splash414x736@3x.png',
  'iphone6p_landscape': 'resources/splash/splash736x414@3x.png',

  'ipad_portrait': 'resources/splash/splash768x1024.png',
  'ipad_portrait_2x': 'resources/splash/splash768x1024@2x.png',
  'ipad_landscape': 'resources/splash/splash1024x768.png',
  'ipad_landscape_2x': 'resources/splash/splash1024x768@2x.png',

  // Android
  'android_ldpi_portrait': 'resources/splash/splash200x320.png',
  'android_ldpi_landscape': 'resources/splash/splash320x200.png',
  'android_mdpi_portrait': 'resources/splash/splash320x480.png',
  'android_mdpi_landscape': 'resources/splash/splash480x320.png',
  'android_hdpi_portrait': 'resources/splash/splash480x800.png',
  'android_hdpi_landscape': 'resources/splash/splash800x480.png',
  'android_xhdpi_portrait': 'resources/splash/splash720x1280.png',
  'android_xhdpi_landscape': 'resources/splash/splash1280x720.png'
});
