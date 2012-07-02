/*
   LCD TV LABORATORY, LG ELECTRONICS INC., SEOUL, KOREA

   Developer : Sungsik Kim (sungsik74.kim@lge.com)
          Yejeong Park (yejeong.park@lge.com)
          
   Library version : 1.2
   The latest modification date : May 25, 2012 
*/


//Usando xhtml, la entidad html &nbsp; produce el error: INVALID_STATE_ERR: DOM Exception 11
//esto es debido a que el estandar xhtml tiene limitado  el set de nombres para entidades,
//sin embargo, funciona con el codigo numerico (&#160;)


(function(){

  var  bTopKb = true;

  function OnWindowFocusIn(event)
  {
    lgKb.WindowFocusIn(event);
  }

  function OnWindowFocusOut(event)
  {
    lgKb.WindowFocusOut(event);
  }

  function onKbclick(event)
  {
    lgKb.kbClick(event);
  }

  function onMouseOver(event)
  {
    lgKb.keyMouseOver(event);
  }

  function onMouseDown(event)
  {
    lgKb.keyMouseDown(event);
  }
  
  function onMouseUp(event)
  {
    lgKb.keyMouseDown(event);
  }
  
  function OnMouseOn()
  {
    lgKb.lgMouseOn(true);
  }
  
  function OnMouseOff()
  {
    lgKb.lgMouseOn(false);
  }
  
  function OnRemoteKeyDown(event)
  {
    lgKb.onRemoteKeyDown(event);
  }

  function OnRemoteKeyUp(event)
  {
    lgKb.onRemoteKeyUp(event);
  }

//  function onClearCaretInfo()
//  {
//    lgKb.clearCaretInfo();
//  }
//
  function initKeyboard()
  {
    try
    {
      if(bTopKb)
      {
        lgKb.initKeyboard();
      }
      
//      window.addEventListener("DOMFocusIn", OnWindowFocusIn, false);
//      window.addEventListener("DOMFocusOut", OnWindowFocusOut, false);
    }
    catch(err)
    {
      console.log("Hubo un error!");
            console.log(err);
    }
  }

  function cleanKeyboard(event)
  {
    lgKb.cleanKeyboard(event);
  }
    
  if(top.lgKb)
  {
    bTopKb = false;
    window.lgKb = top.window.lgKb;
  }
  else
  {
    window.lgKb = {
      nUpperPos : "0px",
      nLowerPos : "408px",
      bKeyMouseOver : false,
      bShowVKeyboard : false,
      bMouseOn : true,
      bShift : false,
      targetElement : "",
      mouseOverKeyId : "wkk_key_206",
      vKeyboard : null,
      category : "unshift",
      selectedCaps : "unshift",
      selectedChar : "",
      currentLang: "",
      nextCaps : "shift",
      selectedLang : "",
      nextChar : "",
      langList: [],
      clearKeyStr: "Clear",
    onKeyDown :        //   user's keydown event handler
        function (event)
        {
        },
      onKeyUp :        //   user's keyup event handler
        function (event)
        {
        },
      keyMouseOver : 
        function (event)
        {
          lgKb.bKeyMouseOver = true;
          doHighlight(event);  
        },
//      keyMouseOut :
//        function (event)
//        {
//          lgKb.bKeyMouseOver = false;
//          doHighlight(event);
//        },
      keyMouseDown : 
        function (event)
        {
          //  add your codes
        },
//      keyMouseUp :
//        function (event)
//        {
//          //  add your codes
//        },
      lgMouseOn :
        function (bOn)
        {
          lgKb.bMouseOn = bOn;
          if (lgKb.bShowVKeyboard) return;
          if(bOn)
          {
//          lgKb.fireMouseOut(lgKb.mouseOverKeyId);
          }
          else{
            lgKb.fireMouseOver(lgKb.mouseOverKeyId);
          }
        },
      onRemoteKeyDown :
        function (event)
        {
          remoteKeyDown(event);
        },
      onRemoteKeyUp :
        function (event)
        {
          remoteKeyUp(event);
        },
      fireMouseOver :
        function (keyId)
        {
          var event = document.createEvent("MouseEvent");
          event.initEvent("mouseover", true, true);
          document.getElementById(keyId).dispatchEvent(event);
        },
//      fireMouseOut :
//        function (keyId)
//        {
//          var event = document.createEvent("MouseEvent");
//          event.initEvent("mouseout", true, true);
//          document.getElementById(keyId).dispatchEvent(event);
//        },
      fireMouseClick :
        function (keyId)
        {
//          var event = document.createEvent("MouseEvent");
//          event.initEvent("click", true, true);
//          document.getElementById(keyId).dispatchEvent(event);
            document.getElementById(keyId).click();
        },
      WindowFocusIn : 
        function (event)
        {
          if(lgKb.targetElement)
          {
            //  add your codes
          }
          else if( (event.target.tagName=="textarea")
              || ( (event.target.tagName=="input") && ( (event.target.type=="text") || (event.target.type=="password") ) ) )
          {
            lgKb.focusIn(event);
          }
        },
      WindowFocusOut :
        function (event)
        {
          if(lgKb.bKeyMouseOver)
          {
            currentCaretIdx = lgKb.targetElement.selectionStart;
            lgKb.setPreviousFocus();
          }
          else
          {
            lgKb.focusOut();
          }          
        },
      kbClick :
        function (event)
        {
//          keyStroke(event);
                    keyStroke(event.target.id);
//          lgKb.refreshFocus();
        },
      clearCaretInfo :
        function ()
        {
          lgKb.currentLang.setNewMode(0);
          isCaretActive = false;

            setCaretPosition(lgKb.targetElement.selectionEnd, 0);
        },
      insertKeyFromInputDevice :
        function (keyCode)
        {
          var keyElement = getTextFromKeyCode(keyCode);
          if(keyElement)
          {
            var bKeyMouseOver = lgKb.bKeyMouseOver;
            
            lgKb.fireMouseOver(keyElement.id);
            lgKb.fireMouseClick(keyElement.id);
            
            lgKb.bKeyMouseOver = bKeyMouseOver;
          }
        },
      isLgBrowser :
        function ()
        {   
          var userAgent = new String(navigator.userAgent);
          var nLgBrowser = userAgent.search(/LG Browser/i);
          return (nLgBrowser != -1);

        },
      initKeyboard :
        function ()
        {
          if(!lgKb.isLgBrowser())
          {
//            return;    //  Virtual Keyboard works well on LG Smart TV
          }
          
          if(!lgKb.vKeyboard)
          {

                        var body = document.getElementsByTagName( 'body' )[ 0 ];
                        lgKb.vKeyboard = body.appendChild( lgKb.generateMarkup() );
                        lgKb.setEmptyKey();
          }
                    lgKb.initKeyboardLayout();
        },
      getAbsOffsetTop :
        function (event)
        {
          var offset = event.target.offsetTop;
          var objParent = event.view || {};
          
          while(objParent.frameElement)
          {
            offset += objParent.frameElement.offsetTop;
            objParent = objParent.parent;
          }
          return offset;
        },
      moveKeboard :
        function (position)
        {
          if(position == "up")
          {
            lgKb.vKeyboard.style.top = lgKb.nUpperPos;
          }
          else
          {
            lgKb.vKeyboard.style.top = lgKb.nLowerPos;
          }
        },
      focusIn :
        function (event)
          {
            var absOffsetTop = lgKb.getAbsOffsetTop(event);

            lgKb.targetElement = event.target;

            event.target.style.backgroundColor = "blue";
              event.target.style.color = "white";
            
            if(absOffsetTop > 360)
            {
              lgKb.moveKeboard("up");
            }
            else
            {
              lgKb.moveKeboard("down");
              
            }
            
            if(!lgKb.bMouseOn)
            {
              lgKb.fireMouseOver(lgKb.mouseOverKeyId);
            }
            
            lgKb.vKeyboard.style.display = 'block';
            lgKb.bShowVKeyboard = true;

//            lgKb.targetElement.addEventListener("click", onClearCaretInfo, false);

//            lgKb.clearCaretInfo();
          },
      focusOut :
        function ()
        {
          if(lgKb.targetElement)
          {
                        lgKb.targetElement.style.backgroundColor = null;
                        lgKb.targetElement.style.color = null;

            lgKb.targetElement = "";
            lgKb.vKeyboard.style.display = 'none';
            lgKb.bShowVKeyboard = false;

          }
        },
      setEmptyKey :
        function ()
        {
//          document.getElementById('wkk_key_empty_000').firstChild.nodeValue = " ";  //  Set non-used key
        },
      generateMarkup :
        function ()
        {
          var newNode = document.createElement( 'div' );
          newNode.id = "VirtualKeyboard";
          newNode.onclick = function(event) { onKbclick(event); };
          newNode.onmouseover = function(event) { onMouseOver(event); };
          newNode.onmousedown = function(event) { onMouseDown(event); };
          newNode.onmouseup = function(event) { onMouseUp(event); };
          newNode.className = 'keyboardArea';

          newNode.innerHTML = [
            '<!-- Level 1 Start -->',
            '<div class="horBtnLayer">',
              '<button id="wkk_key_kb_up" class="btnHorNormalImgMiddle"></button>',
              '<button id="wkk_key_001" name="keyCode_192" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_002" name="keyCode_49" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_003" name="keyCode_50" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_004" name="keyCode_51" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_005" name="keyCode_52" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_006" name="keyCode_53" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_007" name="keyCode_54" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_008" name="keyCode_55" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_009" name="keyCode_56" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_010" name="keyCode_57" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_011" name="keyCode_48" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_012" name="keyCode_189" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_013" name="keyCode_187" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_014" name="keyCode_" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_clear" class="btnHorNormalMiddle" >Clear</button>',
            '</div>',
            '<!-- Level 1 End -->',
            '<!-- Level 2 Start -->',
            '<div class="horBtnLayer">',
              '<!-- Lang Select -->',
              '<button id="wkk_key_lang_sel" class="btnHorNormalImgMiddle" disabled="disabled" style ="background:transparent"></button>',
              '<button id="wkk_key_101" name="keyCode_81" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_102" name="keyCode_87" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_103" name="keyCode_69" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_104" name="keyCode_82" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_105" name="keyCode_84" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_106" name="keyCode_89" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_107" name="keyCode_85" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_108" name="keyCode_73" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_109" name="keyCode_79" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_110" name="keyCode_80" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_111" name="keyCode_219" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_112" name="keyCode_221" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_113" name="keyCode_220" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_114" name="keyCode_" class="horBtnNormal">&#160;</button>',
              '<!--Back space -->',
              '<button id="wkk_key_backspace" name="keyCode_8" class="btnHorNormalMiddle"></button>',
            '</div>',
            '<!-- Level 2 End -->',

            '<!-- Level 3 Start -->',
            '<div class="horBtnLayer">',
              '<!-- Lang Toggle -->',
              '<button id="wkk_key_lang_toggle" name="keyCode_229" class="horBtnNormal"></button>',
              '<!-- Shift Toggle -->',
              '<button id="wkk_key_shift_toggle" name="keyCode_20" class="horBtnNormal"></button>',
              '<button id="wkk_key_201" name="keyCode_" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_202" name="keyCode_65" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_203" name="keyCode_83" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_204" name="keyCode_68" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_205" name="keyCode_70" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_206" name="keyCode_71" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_207" name="keyCode_72" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_208" name="keyCode_74" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_209" name="keyCode_75" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_210" name="keyCode_76" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_211" name="keyCode_186" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_212" name="keyCode_222" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_213" name="keyCode_" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_214" name="keyCode_" class="horBtnNormal">&#160;</button>',
              '<!-- Enter -->',
              '<button id="wkk_key_enter" name="keyCode_13" class="btnHorNormalMiddle"></button>',
            '</div>',
            '<!-- Level 3 End -->',
            '<!-- Level 4 Start -->',
            '<div class="horBtnLayer">',
              '<!-- Char Select -->',
              '<button id="wkk_key_char_sel" class="btnHorNormalMiddle"></button>',
              '<button id="wkk_key_301" name="keyCode_" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_302" name="keyCode_" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_303" name="keyCode_90" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_304" name="keyCode_88" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_305" name="keyCode_67" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_306" name="keyCode_86" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_307" name="keyCode_66" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_308" name="keyCode_78" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_309" name="keyCode_77" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_310" name="keyCode_188" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_311" name="keyCode_190" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_312" name="keyCode_191" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_313" name="keyCode_" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_314" name="keyCode_" class="horBtnNormal">&#160;</button>',
              '<!-- Left arrow -->',
              '<button id="wkk_key_left" name="keyCode_" class="horBtnNormal"></button>',
              '<!-- Right arrow -->',
              '<button id="wkk_key_right" name="keyCode_" class="horBtnNormal"></button>',
            '</div>',
            '<!-- Level 4 End -->',

            '<!-- Level 5 Start -->',
            '<div class="horBtnLayer">',
              '<button id="wkk_key_kb_down" class="btnHorNormalImgMiddle"></button>',
              '<button id="wkk_key_401" class="horBtnSmall">&#160;</button>',
              '<button id="wkk_key_402" class="horBtnSmall">&#160;</button>',
              '<button id="wkk_key_403" class="horBtnSmall">&#160;</button>',
              '<button id="wkk_key_404" name="keyCode_" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_spacebar" name="keyCode_32" class="btnHorNormalLong">&#160;</button>',
              '<button id="wkk_key_411" name="keyCode_" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_412" name="keyCode_" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_413" name="keyCode_" class="horBtnNormal">&#160;</button>',
              '<button id="wkk_key_414" name="keyCode_" class="horBtnNormal">&#160;</button>',
              '<!-- Hidden -->',
              '<button id="wkk_key_hide" class="btnHorNormalMiddle"></button>',
            '</div>',
            '<!-- Level 3 End -->'
          ].join( '' );
          return newNode;
        },
            addLang:
                function(lang){
                    lgKb.langList.push(lang);
                    lgKb.changeLang();

                },
            changeLang:
                function (){
                    var index = lgKb.langList.indexOf(lgKb.currentLang);
                    lgKb.currentLang = lgKb.langList[(index + 1) % lgKb.langList.length];
                    lgKb.initKeyboardLayout()

                },
      cleanKeyboard :
        function (event)
        {
          if((lgKb.targetElement) && (lgKb.targetElement.ownerDocument == event.target))
          {
            lgKb.focusOut();
          }
        },
      setPreviousFocus :
        function ()
        {
          if(lgKb.targetElement)
          {
            lgKb.targetElement.focus();
          }
        },
      refreshFocus :
        function ()
        {
          if(lgKb.targetElement)
          {
            lgKb.targetElement.blur();
            lgKb.targetElement.focus();
          }
        },
      initKeyboardLayout :
        function ()
        {
          var curLang = lgKb.currentLang;
          if(lgKb.vKeyboard == null) return;
//          curLang.changeKeyValue(lgKb.category);
          curLang.changeKeyValue("unshift");
          curLang.setNewMode(0);
          toggleKeyChange();
          setKeyName();
//          initialize();
          if(!lgKb.bShowVKeyboard)
          {
            lgKb.vKeyboard.style.display = 'none';
          }
        }
    };
  }

  window.addEventListener("load", initKeyboard, false);
  window.addEventListener("unload", cleanKeyboard, false);
  
//  if(lgKb.isLgBrowser())
//  {
    window.addEventListener("keydown", OnRemoteKeyDown, true);
    window.addEventListener("keyup", OnRemoteKeyUp, true);
    window.addEventListener("mouseon", OnMouseOn, true);
    window.addEventListener("mouseoff", OnMouseOff, true);
//  }
})();
