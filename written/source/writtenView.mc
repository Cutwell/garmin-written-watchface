import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class writtenView extends WatchUi.WatchFace {
  var wordKeys = [
    "It is",
    "half",
    "ten",
    "quarter",
    "twenty",
    "five",
    "minutes",
    "to",
    "past",
    "one",
    "three",
    "two",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
    "ten",
    "eleven",
    "twelve",
    "o'clock",
  ];
  var displayFont = Graphics.FONT_TINY;
  var colorBG = Graphics.COLOR_BLACK;
  var colorMuted = Graphics.COLOR_WHITE;
  var colorProminant = Graphics.COLOR_RED;
  var wordPositions;
  var screenWidth;
  var screenHeight;

  function initialize() {
    WatchFace.initialize();
  }

  // Load your resources here
  function onLayout(dc as Dc) as Void {
    screenWidth = dc.getWidth();
    screenHeight = dc.getHeight();

    var leftX = screenWidth * 0.2;
    var centerX = screenWidth * 0.5;
    var rightX = screenWidth * 0.8;

    // center on screen, accounting for total paragraph height
    var topY =
      screenHeight * 0.5 - (dc.getFontHeight(displayFont) * 0.75 * 8) / 2;
    var lineSpacingY = dc.getFontHeight(displayFont) * 0.75;

    wordPositions = [
      [leftX, topY, Graphics.TEXT_JUSTIFY_LEFT],
      [centerX, topY, Graphics.TEXT_JUSTIFY_CENTER],
      [rightX, topY, Graphics.TEXT_JUSTIFY_RIGHT],
      [leftX, topY + lineSpacingY, Graphics.TEXT_JUSTIFY_LEFT],
      [rightX, topY + lineSpacingY, Graphics.TEXT_JUSTIFY_RIGHT],
      [leftX, topY + lineSpacingY * 2, Graphics.TEXT_JUSTIFY_LEFT],
      [centerX, topY + lineSpacingY * 2, Graphics.TEXT_JUSTIFY_CENTER],
      [rightX, topY + lineSpacingY * 2, Graphics.TEXT_JUSTIFY_RIGHT],
      [leftX, topY + lineSpacingY * 3, Graphics.TEXT_JUSTIFY_LEFT],
      [centerX, topY + lineSpacingY * 3, Graphics.TEXT_JUSTIFY_CENTER],
      [rightX, topY + lineSpacingY * 3, Graphics.TEXT_JUSTIFY_RIGHT],
      [leftX, topY + lineSpacingY * 4, Graphics.TEXT_JUSTIFY_LEFT],
      [centerX, topY + lineSpacingY * 4, Graphics.TEXT_JUSTIFY_CENTER],
      [rightX, topY + lineSpacingY * 4, Graphics.TEXT_JUSTIFY_RIGHT],
      [leftX, topY + lineSpacingY * 5, Graphics.TEXT_JUSTIFY_LEFT],
      [centerX, topY + lineSpacingY * 5, Graphics.TEXT_JUSTIFY_CENTER],
      [rightX, topY + lineSpacingY * 5, Graphics.TEXT_JUSTIFY_RIGHT],
      [leftX, topY + lineSpacingY * 6, Graphics.TEXT_JUSTIFY_LEFT],
      [centerX, topY + lineSpacingY * 6, Graphics.TEXT_JUSTIFY_CENTER],
      [rightX, topY + lineSpacingY * 6, Graphics.TEXT_JUSTIFY_RIGHT],
      [leftX, topY + lineSpacingY * 7, Graphics.TEXT_JUSTIFY_LEFT],
      [rightX, topY + lineSpacingY * 7, Graphics.TEXT_JUSTIFY_RIGHT],
    ];
  }

  // Called when this View is brought to the foreground. Restore
  // the state of this View and prepare it to be shown. This includes
  // loading resources into memory.
  function onShow() as Void {}

  // Update the view
  function onUpdate(dc as Dc) as Void {
    var wordColors = getWordColors();

    dc.setColor(colorBG, colorBG);
    dc.clear();

    for (var i = 0; i < wordKeys.size(); i++) {
      dc.setColor(wordColors[i], Graphics.COLOR_TRANSPARENT);
      dc.drawText(
        wordPositions[i][0],
        wordPositions[i][1],
        displayFont,
        wordKeys[i],
        wordPositions[i][2]
      );
    }
  }

  // Get indexes of word colors from current time
  function getWordColors() {
    var wordColors = [
      colorProminant,
      colorMuted,
      colorMuted,
      colorMuted,
      colorMuted,
      colorMuted,
      colorMuted,
      colorMuted,
      colorMuted,
      colorMuted,
      colorMuted,
      colorMuted,
      colorMuted,
      colorMuted,
      colorMuted,
      colorMuted,
      colorMuted,
      colorMuted,
      colorMuted,
      colorMuted,
      colorMuted,
      colorMuted,
    ];
    var today = Time.Gregorian.info(Time.now(), Time.FORMAT_SHORT);
    var min = today.min;
    var hour = today.hour;

    if (min >= 35) {
      hour += 1;
    }
    if (hour > 24) {
      hour = 1;
    }

    // past/to
    if (min >= 2.5 && min < 35) {
      wordColors[8] = colorProminant;
    } else if (min >= 35 && min < 57.5) {
      wordColors[7] = colorProminant;
    }

    // five/ten/quarter/twenty/half/o'clock
    if (
      (min >= 2.5 && min < 7.5) ||
      (min >= 52.5 && min < 57.5)
    ) {
      // five past/to lasts 5 minutes
      wordColors[5] = colorProminant;
      wordColors[6] = colorProminant;
    } else if (
      (min >= 7.5 && min < 12.5) ||
      (min >= 47.5 && min < 52.5)
    ) {
      // ten past/to lasts 5 minutes
      wordColors[2] = colorProminant;
      wordColors[6] = colorProminant;
    } else if (
      (min >= 12.5 && min < 17.5) ||
      (min >= 42.5 && min < 47.5)
    ) {
      // quarter past/to lasts 5 minutes
      wordColors[3] = colorProminant;
    } else if (
      (min >= 17.5 && min < 25) ||
      (min >= 35 && min < 42.5)
    ) {
      // twenty past/to lasts 7.5 minutes
      wordColors[4] = colorProminant;
      wordColors[6] = colorProminant;
    } else if (min >= 25 && min < 35) {
      // half past lasts 10 minutes
      wordColors[1] = colorProminant;
    } else if (min >= 57.5 || min < 2.5) {
      // o'clock lasts 5 minutes
      wordColors[21] = colorProminant;
    }

    // hour
    if (hour == 0 || hour == 12 || hour == 24) {
      wordColors[20] = colorProminant;
    } else if (hour == 1 || hour == 13) {
      wordColors[9] = colorProminant;
    } else if (hour == 2 || hour == 14) {
      wordColors[11] = colorProminant;
    } else if (hour == 3 || hour == 15) {
      wordColors[10] = colorProminant;
    } else if (hour == 4 || hour == 16) {
      wordColors[12] = colorProminant;
    } else if (hour == 5 || hour == 17) {
      wordColors[13] = colorProminant;
    } else if (hour == 6 || hour == 18) {
      wordColors[14] = colorProminant;
    } else if (hour == 7 || hour == 19) {
      wordColors[15] = colorProminant;
    } else if (hour == 8 || hour == 20) {
      wordColors[16] = colorProminant;
    } else if (hour == 9 || hour == 21) {
      wordColors[17] = colorProminant;
    } else if (hour == 10 || hour == 22) {
      wordColors[18] = colorProminant;
    } else if (hour == 11 || hour == 23) {
      wordColors[19] = colorProminant;
    }

    return wordColors;
  }

  // Called when this View is removed from the screen. Save the
  // state of this View here. This includes freeing resources from
  // memory.
  function onHide() as Void {}

  // The user has just looked at their watch. Timers and animations may be started here.
  function onExitSleep() as Void {}

  // Terminate any active timers and prepare for slow updates.
  function onEnterSleep() as Void {}
}
