/*
   LCD TV LABORATORY, LG ELECTRONICS INC., SEOUL, KOREA
   
   Developer : Sungsik Kim (sungsik74.kim@lge.com)
          Yejeong Park (yejeong.park@lge.com)
*/

/**
 * current page number  
 */



var currentCaretIdx = 0;
var downPosition  = 'wkk_key_305';

//set label
function toggleKeyChange()
{
  setInnerHtml("wkk_key_lang_toggle", lgKb.currentLang.title.toUpperCase());  // Lang Toggle
  setInnerHtml("wkk_key_char_sel", lgKb.nextChar);          // Character
  
  toggleShiftKey();
}

function setKeyName()
{
  setInnerHtml("wkk_key_clear", lgKb.clearKeyStr);

}


function toggleShiftKey()
{
    if(lgKb.selectedCaps == 'shift'){
        $("#wkk_key_shift_toggle").addClass("shift");
    }else{
        $("#wkk_key_shift_toggle").removeClass("shift");

    }
}

function selectKey(keyId){
//   $(".selected", lgKb.vKeyboard).removeClass("selected");

  selectedKey = document.getElementById(lgKb.mouseOverKeyId);
  selectedKey.className = selectedKey.className.replace(/[ ]*selected/,"");
  document.getElementById(keyId).className +=" selected";

//    $("#"+keyId, lgKb.vKeyboard).addClass("selected");


}

function doHighlight(event) {
  var keyId = event.target.id;
  
  if(keyId.search(/wkk_key/)>=0)
  {
    if(event.type == 'mouseover')
    {
//      if((event.target.firstChild == null) || (event.target.firstChild.nodeValue != " "))
//      {
                selectKey(keyId);
        lgKb.mouseOverKeyId = keyId;
//      }
    }
  }
}

function keyStroke(keyId)
{
  if(keyId.search(/wkk_key/)>=0)
  {
    switch(keyId)
    {
      case 'wkk_key_kb_up' :
        return lgKb.moveKeboard("up");
      case 'wkk_key_kb_down' :
        return lgKb.moveKeboard("down");
      case 'wkk_key_lang_sel' :
        return;
      case 'wkk_key_clear' :
        clearText();
        break;
      case 'wkk_key_lang_toggle' :
        return lgKb.changeLang();
      case 'wkk_key_shift_toggle' :
        return toggleShift();
      case 'wkk_key_enter' :
        enterInputField();
        break;
      case 'wkk_key_backspace' :
        lgKb.currentLang.backspaceText();
        break;
      case 'wkk_key_left' :
        return inputBoxControl('left');
      case 'wkk_key_right' :
        return inputBoxControl('right');
      case 'wkk_key_char_sel' :
        lgKb.currentLang.changeKeyValue("12;)");
        return;
      case 'wkk_key_spacebar' :
        lgKb.currentLang.addSpaceText();
        break;
      case 'wkk_key_hide' :
        return lgKb.focusOut();
      default :
//        lgKb.currentLang.appendText(document.getElementById(keyId));
//        lgKb.currentLang.appendText(keyId);
        var keyVal = lgKb.currentLang.getText(keyId);
        addStrIntoFld(keyVal, true);

        break;
    }
  }
}

function toggleShift()
{
  lgKb.currentLang.changeKeyValue(lgKb.nextCaps);
  toggleShiftKey();
}

/**
 * return Textbar's content
 * @return
 */
function getTextContent() {
  if( lgKb.targetElement != null) {
    return lgKb.targetElement.value;
  }
  return null;
}

/**
 * set Textbar's content
 * @param value
 * @return
 */
function setTextContent(value) {
  var textItem = lgKb.targetElement;
  if( textItem != null) {    
    textItem.value = value;
  }
}

function clearText()
{
  lgKb.targetElement.value = "";
    //TODO REMOVE THIS CALL
  lgKb.clearCaretInfo();
}



function getTextFromKeyCode(keyCode)
{
  
  var keyName = "keyCode_" + keyCode;
    //Return keyItem
  return document.getElementsByName(keyName)[0];
}

function remoteKeyDown(event)
{
  var rtnVal = false;

    if(lgKb.bShowVKeyboard)
  {
    var keyCode = event.keyCode;
    
    //  change keycode of number pad key to keycode of number key
    if((keyCode >= VK_NUMPAD_0) && (keyCode <= VK_NUMPAD_9))
    {
      keyCode -= 48;
    }
    
    var keyId = "";
    switch(keyCode) {
      case VK_HID_ESC :
        lgKb.focusOut();
        break;
      case VK_UP :
        keyId = moveUp();
        break;
        
      case VK_DOWN :
        keyId = moveDown();
        break;
        
      case VK_LEFT :
        keyId = moveLeft();
        break;
        
      case VK_RIGHT :
        keyId = moveRight();
        break;
        
      case VK_ENTER :
        lgKb.fireMouseClick(lgKb.mouseOverKeyId);
        break;
        
      case VK_SHIFT :
        if(!lgKb.bShift)
        {
          keyCode = VK_CAPS_LOCK;
          lgKb.insertKeyFromInputDevice(keyCode);
          lgKb.bShift = true;
        }
        break;
      default :
        lgKb.insertKeyFromInputDevice(keyCode);
        break;
    }
    
    if(keyId != "")
    {
//      lgKb.fireMouseOut(lgKb.mouseOverKeyId);
      lgKb.fireMouseOver(keyId);
    }
    
    event.returnValue = rtnVal;
  }
  else
  {
    lgKb.onKeyDown(event);
  }
  

}

function remoteKeyUp(event)
{
  if(lgKb.bShowVKeyboard)
  {
    var keyCode = event.keyCode;
        switch(keyCode) {
      case VK_SHIFT :
        keyCode = VK_CAPS_LOCK;
        lgKb.insertKeyFromInputDevice(keyCode);
        lgKb.bShift = false;
        break;
        
      default :
        break;
    }
    event.returnValue = false;
  }
  else
  {
    lgKb.onKeyUp(event);
  }
  
}

function moveUp()
{
  var keyId = "";
  var nextkeyId = lgKb.mouseOverKeyId;
  
  switch(lgKb.mouseOverKeyId)
  {
    case 'wkk_key_kb_up' :
      return keyId;
      
    case 'wkk_key_lang_sel' :
      return 'wkk_key_kb_up';
      
    case 'wkk_key_lang_toggle' :
    case 'wkk_key_shift_toggle' :
//      return 'wkk_key_lang_sel';
      return 'wkk_key_kb_up';
    case 'wkk_key_char_sel' :
      return 'wkk_key_shift_toggle';
      
    case 'wkk_key_kb_down' :
      return 'wkk_key_char_sel';
      
    case 'wkk_key_clear' :
      return keyId;
      
    case 'wkk_key_backspace' : 
      return 'wkk_key_clear';
      
    case 'wkk_key_enter' :
      return 'wkk_key_backspace';
      
    case 'wkk_key_left' :
    case 'wkk_key_right' :
      return 'wkk_key_enter';
      
    case 'wkk_key_hide' :
      return 'wkk_key_left';
      
    case 'wkk_key_spacebar' :
      return downPosition;
    }
  
  if(keyId == "")
  {
    var y = nextkeyId.charAt(8);
    var x = nextkeyId.substr(9,2);
    
    
    if(new Number(y)>0)
    {

      do
      {
        y = new Number(y)-1;
        keyId = 'wkk_key_' + y + x;
      } while((y >= 0) && (document.getElementById(keyId).firstChild.nodeValue == " "));
      
      if(y < 0)
      {
        keyId = "";
      }

    }
  }
  return keyId;
}

function moveDown()
{
  var keyId = "";
  
  switch(lgKb.mouseOverKeyId)
  {
    case 'wkk_key_kb_up' :
//      return 'wkk_key_lang_sel';
    
    case 'wkk_key_lang_sel' :
      return 'wkk_key_lang_toggle';

    case 'wkk_key_lang_toggle' :
    case 'wkk_key_shift_toggle' :
      return 'wkk_key_char_sel';

    case 'wkk_key_char_sel' :
      return 'wkk_key_kb_down';
      
    case 'wkk_key_kb_down' :
      return keyId;
      
    case 'wkk_key_clear' :
      return 'wkk_key_backspace';

    case 'wkk_key_backspace' : 
      return 'wkk_key_enter';

    case 'wkk_key_enter' :
      return 'wkk_key_left';

    case 'wkk_key_left' :
    case 'wkk_key_right' :
      return 'wkk_key_hide';

    case 'wkk_key_hide' :
      return keyId;
      
    case 'wkk_key_spacebar' :
      return keyId;  
  }
  

  if(keyId == "")
  {
    var y = lgKb.mouseOverKeyId.charAt(8);
    var x = lgKb.mouseOverKeyId.substr(9,2);
    
    
    if(new Number(y)<4)
    {
      if(Number(y) == 3 && (Number(x) == 5 || Number(x) == 6 || Number(x) == 7 || Number(x) == 8 || Number(x) == 9 || Number(x) == 10 ))
      {  
        downPosition  ='wkk_key_' + y + x;
        keyId = 'wkk_key_spacebar';
        return keyId
      }

      do{
        y = new Number(y)+1;
        keyId = 'wkk_key_' + y + x;
      
      }while((y <= 4) && (document.getElementById(keyId).firstChild.nodeValue == " "));
      
      if(y > 4)
      {
        keyId = "";
      }

    }
  }
  return keyId;
  
}

function moveLeft()
{
  var keyId = "";
  var nextkeyId = lgKb.mouseOverKeyId;
  
  switch(lgKb.mouseOverKeyId)
  {
    case 'wkk_key_kb_up' :
      return 'wkk_key_clear';
  
    case 'wkk_key_lang_sel' :
      return 'wkk_key_backspace';

    case 'wkk_key_lang_toggle' : 
      return 'wkk_key_enter';

    case 'wkk_key_shift_toggle' :
      return 'wkk_key_lang_toggle';

    case 'wkk_key_char_sel' :
      return 'wkk_key_right';
      
    case 'wkk_key_kb_down' :
      return 'wkk_key_hide';
      
    case 'wkk_key_clear' :
      nextkeyId = 'wkk_key_015';
      break;
      
    case 'wkk_key_backspace' : 
      nextkeyId = 'wkk_key_115';
      break;
      
    case 'wkk_key_enter' :
      nextkeyId = 'wkk_key_215';
      break;
      
    case 'wkk_key_left' :
      nextkeyId = 'wkk_key_315';
      break;
      
    case 'wkk_key_right' :
      return 'wkk_key_left';

    case 'wkk_key_hide' :
      nextkeyId = 'wkk_key_415';
      break;
      
    case 'wkk_key_spacebar' :
      nextkeyId = 'wkk_key_405';
      break;
  }
  

  if(keyId == "")
  {
    var y = nextkeyId.charAt(8);
    var x = nextkeyId.substr(9,2);
    
    if(x > 0)
    {
     do{
        x = new Number(x)-1;
        keyId = getKeyIdfromXY(x,y);
        
        if( keyId == 'wkk_key_411')
        {
          return 'wkk_key_spacebar';
        }
      }while( (x > 0) && (document.getElementById(keyId).firstChild.nodeValue == " "));
      if( x == 0 )
      {
        switch(y)
        {
          case '0' :
            keyId = 'wkk_key_kb_up';
            break;
          case '1' :
//            keyId = 'wkk_key_lang_sel';
                        keyId = 'wkk_key_backspace';
                        break;
          case '2' :
            keyId = 'wkk_key_shift_toggle';
            break;
          case '3' :
            keyId = 'wkk_key_char_sel';
            break;
          case '4' :
            keyId = 'wkk_key_kb_down';
            break;  
        }
      }
    }
  }
  return keyId;
}

function moveRight()
{
  var keyId = "";
  var nextkeyId = lgKb.mouseOverKeyId;
  
  switch(lgKb.mouseOverKeyId)
  {
    case 'wkk_key_kb_up' :
      nextkeyId = 'wkk_key_000';
      break;

    case 'wkk_key_lang_sel' :
      nextkeyId = 'wkk_key_100';
      break;
      
    case 'wkk_key_lang_toggle' : 
      return 'wkk_key_shift_toggle';
      
    case 'wkk_key_shift_toggle' :
      nextkeyId = 'wkk_key_200';
      break;
      
    case 'wkk_key_char_sel' :
      nextkeyId = 'wkk_key_300';
      break;
    case 'wkk_key_kb_down' :
      nextkeyId = 'wkk_key_400';
      break;
    case 'wkk_key_clear' :
      return 'wkk_key_kb_up';
    case 'wkk_key_backspace' : 
//    return 'wkk_key_lang_sel';
      nextkeyId = 'wkk_key_100';
      break;
    case 'wkk_key_enter' :
      return 'wkk_key_lang_toggle';

    case 'wkk_key_left' :
      return 'wkk_key_right';
      
    case 'wkk_key_right' :
      return 'wkk_key_char_sel';
      
    case 'wkk_key_hide' :
      return 'wkk_key_kb_down';
      
    case 'wkk_key_spacebar' :
      nextkeyId = 'wkk_key_410';
      break;
  }
  

  if(keyId == "")
  {
    var y = nextkeyId.charAt(8);
    var x = nextkeyId.substr(9,2);
    
    if(x >= 0)
    {
      do
      {        
        x = new Number(x)+1;
        keyId = getKeyIdfromXY(x,y);
        if( keyId == 'wkk_key_405')
        {
          return 'wkk_key_spacebar';
        }
      }while( (x < 14) && (document.getElementById(keyId).getAttribute("disabled") == "disabled"));
      if( x == 14 )
      {
        switch(y)
        {
          case '0' :
            keyId = 'wkk_key_clear';
            break;
          case '1' :
            keyId = 'wkk_key_backspace';
            break;
          case '2' :
            keyId = 'wkk_key_enter';
            break;
          case '3' :
            keyId = 'wkk_key_left';
            break;
          case '4' :
            keyId = 'wkk_key_hide';
            break;  
        }
      }
    }
  }
  return keyId;
}


function getKeyIdfromXY(x,y)
{
  var keyId;
  if(x < 10)
  {
    keyId = 'wkk_key_' + y + '0' + x;
  }
  else 
  {
    keyId = 'wkk_key_' + y + x;  
  }  
  return keyId;
}

function inputBoxControl(direct){
  if(direct=='left'){
    caretPrev();
  }else{
    caretNext();
  }
}

/*start of carot handle*/
//function caretMoved() {
//  setNewMode(0);
//  setCaretPosition(getCaretPosition(), 0);
//}

function caretNext() {
  lgKb.currentLang.setNewMode(0);
  var pos = getCaretPosition();
  setCaretPosition(new Number(pos) + 1, 0);
}

function caretPrev() {

  lgKb.currentLang.setNewMode(0);
  var ctrl = lgKb.targetElement;
  var pos = getCaretPosition();
    
  if(pos>ctrl.value.length){
    pos = ctrl.value.length;
  }  
  setCaretPosition(new Number(pos) -1, 0);
}

function getCaretPosition() {
  return currentCaretIdx;
}

function isCaretActivated() {
  return isCaretActive;
}

isCaretActive = false;

function setCaretPosition(pos, r) {

  if(pos<0){
    pos = 0;
  }
  
  var ctrl = lgKb.targetElement;
  ctrl.focus();

  ctrl.setSelectionRange(pos, new Number(pos+r));

  
  currentCaretIdx = pos;
    isCaretActive = (r > 0 );

}
/*end of carot handle*/

/*start of default text handle*/
var maxLen = 100;

function addStrIntoFld( c , isNew ) {

  var kTxt = getTextContent();
  var kTxtLen = kTxt.length;
  
  if( kTxtLen < maxLen ) {
    var kSelected = isCaretActivated();
    var kIdx = getCaretPosition();
    var kIsEnd = false;
    if(kSelected) {
      kIsEnd = (kIdx >= (new Number(kTxtLen) - 1));
    } else {
      kIsEnd = (kIdx >= kTxtLen);
    }
    if(isNew) { 
      if(kIsEnd) {         
        addCharToEnd(kTxt, c);
      } else {
        if(kSelected) {
          addCharInMiddle(kTxt, c, kIdx+1);
        } else {
          addCharInMiddle(kTxt, c, kIdx);
        }
      }
    } else {      
      if (kIsEnd) {
        overwriteCharToEnd(kTxt, c);
      } else {
        overwriteCharInMiddle(kTxt, c, kIdx);
      }
    }
  }
}

function addCharToEnd(txt, c) {
  var kJoin = txt + c;
  if(c.length > 1) {
    putStrIntoFld(kJoin, kJoin.length);
  } else {
    putStrIntoFld(kJoin, txt.length);
  }
}

function overwriteCharToEnd(txt, c) {
  var kTxt = txt.substr(0, txt.length -1);
  putStrIntoFld(kTxt+c, kTxt.length);
}

function addCharInMiddle(txt, c, idx) {
  var kTxt_0 = txt.substr(0, idx);
  var kTxt_1 = txt.substr(idx, txt.length);

  var kJoin = kTxt_0 + c + kTxt_1;
  if(c.length > 1) {
    putStrIntoFld(kJoin, new Number(idx) + c.length-1);
  } else {
    putStrIntoFld(kJoin, idx);
  }
//  setCaretPosition(idx + c.length, 0);
}

function overwriteCharInMiddle(txt, c, idx) {
  var kTxt_0 = txt.substr(0,idx);
  var kTxt_1 = txt.substr(new Number(idx)+1, txt.length);
  putStrIntoFld(kTxt_0+ c + kTxt_1, idx);  
}

function putStrIntoFld( str, idx) {
  
  var kStr = "";
  if( str != null && str.length > 0 ) {
    kStr = str;
  }
  setTextContent(kStr);

  if(kStr.length == 0 ) {
    setCaretPosition(0, 0);  
  } else {
    setCaretPosition(new Number(idx)+1, 0);
  }
}

function deletePrevChar() {
  var kTxt = getTextContent();
  var kSelected = isCaretActivated();
  var ctrl = lgKb.targetElement;
  var kIdx = getCaretPosition();
  if(kIdx>ctrl.value.length){
    kIdx = ctrl.value.length;
  }

  if(!kSelected) {
    kIdx = kIdx -1;
  }
  var kResult = "";  
  if( kIdx > -1) {
    kResult = kTxt.substr(0,kIdx) + kTxt.substr(kIdx +1, kTxt.length);
    putStrIntoFld(kResult, kIdx);  
    setCaretPosition(kIdx, 0);
  }
}


/**
 * return has black background.
 * @param keyId
 * @return true/false
 */
function isBlackKey(keyId)
{
  var keyValue = getKeyValue(keyId);
  return keyValue == " ";
}

function enterInputField()
{
  if(lgKb.targetElement.tagName == 'textarea')
  {
    lgKb.clearCaretInfo();  
    addStrIntoFld("\n", true);
  }  
}

/****************************************************************************/
/**************** Lang.js replace keyboard.js functions End ***************/
/****************************************************************************/

//  from common.js

function setKeyText(keyId, value, bCombi)
{
  var keyItem = document.getElementById(keyId);  

  if(keyItem != null)
  {
    keyItem.firstChild.nodeValue = value;
    if(isBlackKey(keyId))
    {      
       disableElement(keyId);
    }else{
       enableElement(keyId);
    }

    if(bCombi)
    {
      keyItem.combination = "true";
    }
    else
    {
      keyItem.combination = "false";
    }
  }
}

function getKeyValue(keyId)
{
    var keyItem = document.getElementById(keyId);
  if(keyItem != null)
  {
    return keyItem.firstChild.nodeValue;
  }
  else
  {
    return null;
  }
}

function setInnerHtml(elementId, html)
{
  var e = document.getElementById(elementId);
  if(e != null)
  {
    e.innerHTML = html;
  }
}


function disableElement(elementId)
{
    var e = document.getElementById(elementId);
    if(e != null)
    {
        e.setAttribute("disabled","disabled");
    }
}

function enableElement(elementId)
{
  var e = document.getElementById(elementId);
  if(e != null)
  {
    e.removeAttribute("disabled");
  }
}
