@FontName: GillSans;
@FontNameBold: GillSans-Bold;
@primaryFontColor: #000000;
@reversePrimaryFontColor: #ffffff;
@secondaryFontColor: #555555;
@tertiaryFontColor: #888888;
@primaryBackgroundColor: #F0F0F0;
@secondaryBackgroundColor: #FFFFFF;


TableCell {
    background-color-selected: #f8f8f8;
}

TableCell:SettingsCell {
    font-name: @FontName;
    font-color: @primaryFontColor;
    font-color-highlighted: @primaryFontColor;
}

Table:SettingsTable {
    background-color: #ff0000;
}


NavigationBar {
    background-tint-color: @primaryBackgroundColor;
    font-name: @FontName;
    font-size: 21;
    font-color: @secondaryFontColor;
    text-shadow-color: #222222;
    text-shadow-offset: 0.5,0;
}

BarButton {
    font-color: #000000;
    text-shadow-offset: 0,0;
    font-name: @FontName;
    font-color: @secondaryFontColor;
}

Button:IconButton {
    font-color: @secondaryFontColor;
    font-name: icomoon;
    font-color-selected: @tertiaryFontColor;
    font-color-highlighted: @tertiaryFontColor;
}

Button:NavIconButton {
    font-size: 22;
    width: 30;
    text-align: center;
}

Button:BigIconButton {
    font-size: 36;
    text-align: right;
}

Label:SensorTypeIconLabel {
    font-color: @secondaryFontColor;
    font-name: icomoon;
    font-size: 22;
    text-align: center;
}

Button {
    font-color: @reversePrimaryFontColor;
    font-name: @FontName;
    font-size: 18;
}

Label {
    font-name: @FontName;
}

Label:sensorLegendLabel {
    font-color: @secondaryFontColor;
    font-name: @FontName;
}

Label:sensorValueLabel {
    font-color: @primaryFontColor;
    font-size: 150;
    text-align: center;
    font-name: @FontName;
}

Label:unitSubtitleLabel {
    font-color: @secondaryFontColor;
    font-size: 16;
    text-align: center;
    font-name: @FontName;
}

Label:sensorCellLocation {
    font-color: @primaryFontColor;
    font-size: 16;
    font-name: @FontName;
}

Label:sensorCellName {
    font-color: @secondaryFontColor;
    font-size: 12;
    font-name: @FontName;
}

Label:BigLoadLabel {
    font-color: @primaryFontColor;
    font-name: icomoon;
    font-size: 64;
    text-align: center;
}

Button:LoginButton {
    background-color: #44dd33;
    font-name: @FontName;
    font-size: 20;
    text-shadow-color: transparent;
}

TextField:LoginTextField {
    corner-radius: 0;
    border-style: line;
    border-color: #dddddd;
    border-width: 1;
    padding: 5;
    background-color: @secondaryBackgroundColor;
    font-name: @FontName;
    font-color: @primaryFontColor;
    font-size: 15;
    height: 36;
}

Label:LoginTitleLabel {
    font-name: @FontName;
    font-color: @primaryFontColor;
    font-size: 30;
}

View:LoginView {
    background-color: @primaryBackgroundColor;
}


Label:AccountSettingsLabel {
    font-name: @FontName;
    font-color: @primaryFontColor;
}

Button:AccountSettingsButton {
    background-color: #3333ff;
    font-name: @FontName;
    font-size: 11;
    text-align: center;
    text-shadow-color: transparent;
    height: 28;
    font-color: @reversePrimaryFontColor;
}

TextField:AccountSettingsTextField {
    corner-radius: 0;
    border-style: line;
    border-color: #dddddd;
    border-width: 1;
    padding: 5;
    background-color: @secondaryBackgroundColor;
    font-name: @FontName;
    font-color: @primaryFontColor;
    font-size: 15;
}