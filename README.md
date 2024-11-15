# daily_verse
//home widget
await HomeWidget.saveWidgetData('appWidgetText', "New App Widget Text");
await HomeWidget.updateWidget(
    qualifiedAndroidName: "dev.abeni.daily_verse.HomeScreenWidget",
    androidName: "HomeScreenWidget",
);