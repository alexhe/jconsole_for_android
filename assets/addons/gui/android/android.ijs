require 'jni api/expat'

coclass 'ja'
coinsert 'jni jaresu'
GetJNIENV''

jniImport (0 : 0)
android.app.AlertDialog
android.app.AlertDialog$Builder
android.app.Activity
android.content.Context
android.content.DialogInterface$OnClickListener
android.content.Intent
android.graphics.Bitmap
android.graphics.BitmapFactory
android.graphics.Typeface
android.graphics.drawable.BitmapDrawable
android.graphics.drawable.Drawable
android.util.DisplayMetrics
android.view.Display
android.view.WindowManager
android.widget.Toast
org.dykman.j.android.AbstractActivity
org.dykman.j.android.JConsoleApp
org.dykman.jn.android.app.Activity
)
3 : 0''
APILEVEL=: 3
if. 'Android'-:UNAME do.
  try.
    jniCheck APILEVEL=: ('SDK_INT I' jniStaticField) 'android.os.Build$VERSION'
  catch.
    ExceptionClear''
  end.
end.
)

OR=: 23 b./
NOTALPHA=: 16bffffff
ALPHA=: 0 (26 b.) NOTALPHA
readimg=: 3 : 0

jniCheck bm=. 'android.graphics.BitmapFactory' ('decodeFile (LString;)LBitmap;' jniStaticMethod)~ <y
if. 0=bm do. 0 0$0 return. end.
jniCheck w=. bm ('getWidth ()I' jniMethod)~ ''
jniCheck h=. bm ('getHeight ()I' jniMethod)~ ''
d=. (w*h)#2-2

jniCheck colors=. NewIntArray <#d
jniCheck bm ('getPixels ([IIIIIII)V' jniMethod)~ colors;0;w;0;0;w;h
jniCheck GetIntArrayRegion colors;0;(#d);d
jniCheck DeleteLocalRef"0 colors;bm

d=. fliprgb^:(-.RGBSEQ_j_) d (17 b.) NOTALPHA
(h,w)$d
)
getimg=: 3 : 0
ba=. jniCheck NewByteArray <#y
jniCheck SetByteArrayRegion ba;0;(#y);y
bm=. jniCheck 'android.graphics.BitmapFactory' ('decodeByteArray ([BII)LBitmap;' jniStaticMethod)~ ba;0;#y
jniCheck DeleteLocalRef <ba
if. 0=bm do. 0 0$0 return. end.

jniCheck bm=. 'android.graphics.BitmapFactory' ('decodeFile (LString;)LBitmap;' jniStaticMethod)~ <y
if. 0=bm do. 0 0$0 return. end.
jniCheck w=. bm ('getWidth ()I' jniMethod)~ ''
jniCheck h=. bm ('getHeight ()I' jniMethod)~ ''
d=. (w*h)#2-2

jniCheck colors=. NewIntArray <#d
jniCheck bm ('getPixels ([IIIIIII)V' jniMethod)~ colors;0;w;0;0;w;h
jniCheck GetIntArrayRegion colors;0;(#d);d
jniCheck DeleteLocalRef"0 colors;bm

d=. fliprgb^:(-.RGBSEQ_j_) d (17 b.) NOTALPHA
(h,w)$d
)
writeimg=: 4 : 0
'h w'=. $x
d=. ,x
if. 2> #y=. boxopen y do.
  f=. >@{.y
  type=. tolower }. (}.~ i:&'.') f
  opt=. ''
elseif. 2= #y do.
  f=. >@{.y
  type=. >1{y
  opt=. ''
elseif. do.
  f=. utf8 >@{.y
  type=. >1{y
  opt=. 2{.2}.y
  opt=. (":&.>1{opt) 1}opt
end.
if. 'jpg'-:type do. type=. 'jpeg'
elseif. 'tif'-:type do. type=. 'tiff'
end.
d=. fliprgb^:(RGBSEQ_j_) d
d=. d OR ALPHA
if. IF64 do. d=. 2 ic d end.
buf=. gdk_pixbuf_new_from_data (15!:14<'d'),GDK_COLORSPACE_RGB,1,8,w,h,(4*w),0,0
    jniCheck colors=. NewIntArray <#d
    jniCheck SetIntArrayRegion colors;0;(#d);d
    jniCheck bm=. ('createBitmap ([IIIIILBitmap$Config;)LBitmap;' jniStaticMethod)~ colors;0;w;w;h;0
    jniCheck DeleteLocalRef"0 ba;bm
if. buf do.
  if. ''-:opt do.
    gdk_pixbuf_save buf;f;type;0;0
  else.
    gdk_pixbuf_save_2 buf;f;type;0;opt,<0
  end.
  g_object_unref buf
end.
EMPTY
)
putimg=: 4 : 0
'h w'=. $x
d=. ,x
if. 2> #y=. boxopen y do.
  type=. >@{.y
  opt=. ''
elseif. do.
  type=. >@{.y
  opt=. 2{.}.y
  opt=. (":&.>1{opt) 1}opt
end.
if. 'jpg'-:type do. type=. 'jpeg'
elseif. 'tif'-:type do. type=. 'tiff'
end.
d=. fliprgb^:(RGBSEQ_j_) d
d=. d OR ALPHA
if. IF64 do. d=. 2 ic d end.
buf=. gdk_pixbuf_new_from_data (15!:14<'d'),GDK_COLORSPACE_RGB,1,8,w,h,(4*w),0,0
rc=. 0
if. buf do.
  if. ''-:opt do.
    rc=. gdk_pixbuf_save_to_buffer buf;(m=. ,_1);(s=. ,_1);type;0;0
  else.
    rc=. gdk_pixbuf_save_to_buffer_2 buf;(m=. ,_1);(s=. ,_1);type;0;opt,<0
  end.
  g_object_unref buf
end.
if. rc do.
  assert. 0~:m
  z=. memr m,0,s,2
  z [ g_free {.m
else.
  ''
end.
)
clipreadimg=: 3 : 0
cb=. gtk_clipboard_get gdk_atom_intern 'CLIPBOARD';0
if. 0= buf=. gtk_clipboard_wait_for_image cb do. 0 0$0 return. end.
img=. gdk_pixbuf_add_alpha buf;0;0;0;0
assert. 0~:img
g_object_unref buf
ad=. gdk_pixbuf_get_pixels img
w=. gdk_pixbuf_get_width img
h=. gdk_pixbuf_get_height img
s=. gdk_pixbuf_get_rowstride img
assert. s=4*w
assert. 0~:ad
if. IF64 do.
  r=. _2 ic memr ad,0,(w*h*4),JCHAR
else.
  r=. memr ad,0,(w*h),JINT
end.
g_object_unref img
r=. fliprgb^:(RGBSEQ_j_) r (17 b.) NOTALPHA
(h,w)$r
)
clipwriteimg=: 3 : 0
'h w'=. $y
d=. ,y
d=. fliprgb^:(RGBSEQ_j_) d
d=. d OR ALPHA
if. IF64 do. d=. 2 ic d end.
buf=. gdk_pixbuf_new_from_data (15!:14<'d'),GDK_COLORSPACE_RGB,1,8,w,h,(4*w),0,0
cb=. gtk_clipboard_get gdk_atom_intern 'CLIPBOARD';0
gtk_clipboard_set_image cb,buf
gtk_clipboard_store cb
g_object_unref buf
h,w
)

pixbufpx_setpixels=: 4 : 0
gtkpx=. x
'a b w h'=. 4{.y
d=. 4}.y
d=. fliprgb^:(RGBSEQ_j_) d
d=. d OR ALPHA
if. IF64 do. d=. 2 ic d end.
buf=. gdk_pixbuf_new_from_data (15!:14<'d'),GDK_COLORSPACE_RGB,1,8,w,h,(4*w),0,0
if. buf do.
  gdk_draw_pixbuf gtkpx,0,buf,0,0,a,b,w,h,0,0,0
end.
g_object_unref buf
EMPTY
)
pixbufcr_setpixels=: 4 : 0
cr=. x
'a b w h'=. 4{.y
d=. 4}.y
d=. fliprgb^:(RGBSEQ_j_) d
d=. d OR ALPHA
if. IF64 do. d=. 2 ic d end.
buf=. gdk_pixbuf_new_from_data (15!:14<'d'),GDK_COLORSPACE_RGB,1,8,w,h,(4*w),0,0
if. buf do.
  gdk_cairo_set_source_pixbuf cr; buf; a; b
  cairo_paint cr
end.
g_object_unref buf
EMPTY
)
evtloop_z_=: empty
evthandler_z_=: 3 : 0
evtdata=: y
evt_val=. {:"1 evtdata
({."1 evtdata)=: evt_val
if. 3=4!:0<'evthandler_debug' do.
  try. evthandler_debug'' catch. end.
end.
evt_ndx=. 1 i.~ 3 = 4!:0 [ 3 {. evt_val
if. 3 > evt_ndx do.
  evt_fn=. > evt_ndx { evt_val
  if. 13!:17'' do.
    evt_fn~''
  else.
    try. evt_fn~''
    catch.
      evt_err=. 13!:12''
      if. 0=4!:0 <'ERM_j_' do.
        evt_erm=. ERM_j_
        ERM_j_=: ''
        if. evt_erm -: evt_err do. i.0 0 return. end.
      end.
      evt_err=. LF,,LF,.}.;._2 evt_err
      sminfo 'evthandler';'error in: ',evt_fn,evt_err
    end.
  end.
end.
i.0 0
)
ANDROID_LOG_UNKNOWN=: 0
ANDROID_LOG_DEFAULT=: 1
ANDROID_LOG_VERBOSE=: 2
ANDROID_LOG_DEBUG=: 3
ANDROID_LOG_INFO=: 4
ANDROID_LOG_WARN=: 5
ANDROID_LOG_ERROR=: 6
ANDROID_LOG_FATAL=: 7
ANDROID_LOG_SILENT=: 8

log_v=: 'liblog.so __android_log_print > i i *c *c'&(15!:0) @: (ANDROID_LOG_VERBOSE&;)
log_d=: 'liblog.so __android_log_print > i i *c *c'&(15!:0) @: (ANDROID_LOG_DEBUG&;)
log_i=: 'liblog.so __android_log_print > i i *c *c'&(15!:0) @: (ANDROID_LOG_INFO&;)
log_w=: 'liblog.so __android_log_print > i i *c *c'&(15!:0) @: (ANDROID_LOG_WARN&;)
log_e=: 'liblog.so __android_log_print > i i *c *c'&(15!:0) @: (ANDROID_LOG_ERROR&;)
log_f=: 'liblog.so __android_log_print > i i *c *c'&(15!:0) @: (ANDROID_LOG_FATAL&;)
StartActivity=: 0&$: : (4 : 0)
'intent act ctx'=. 3{.x
'locale override japparg'=. 3{. boxopen y
locale=. >^:_ locale
assert. (0~:intent) +. *#locale
app=. ('theApp LJConsoleApp;' jniStaticField) 'JConsoleApp'
if. 0= act do.
  cact=. ('activity LAbstractActivity;' jniField) app
else.
  cact=. act
end.
if. 0=ctx do. cctx=. app ('getApplicationContext ()LContext;' jniMethod)~ '' else. cctx=. ctx end.
if. 0=intent do.
  cintent=. 'android.content.Intent' jniNewObject~ ''
  jniCheck jnact=. FindClass <'org/dykman/jn/android/app/Activity'
  cintent ('setClass (LContext;LClass;)LIntent;' jniMethod)~ cctx;jnact
  cintent ('putExtra (LString;LString;)LIntent;' jniMethod)~ 'locale';locale
  cintent ('putExtra (LString;LString;)LIntent;' jniMethod)~ 'override';override
  cintent ('putExtra (LString;LString;)LIntent;' jniMethod)~ 'japparg';japparg
  cact ('startActivity (LIntent;)V' jniMethod)~ cintent
  jniCheck DeleteLocalRef"0 cintent;jnact
else.
  cact ('startActivity (LIntent;)V' jniMethod)~ intent
end.
if. 0=act do. jniCheck DeleteLocalRef <cact end.
if. 0=ctx do. jniCheck DeleteLocalRef <cctx end.
jniCheck DeleteLocalRef <app
0
)
mbinfo=: 0&$: : (4 : 0)
ctx=. x
'title text'=. 2{.(boxopen y), <''
if. 0=#text do. title=. '' [ text=. title end.
cctx=. getjactivity ctx
jniCheck builder=. cctx jniNewObject 'AlertDialog$Builder LContext;'
jniCheck builder ('setTitle (LCharSequence;)LAlertDialog$Builder;' jniMethod)~ <title
jniCheck builder ('setMessage (LCharSequence;)LAlertDialog$Builder;' jniMethod)~ <text
jniCheck builder ('setNeutralButton (LCharSequence;LDialogInterface$OnClickListener;)LAlertDialog$Builder;' jniMethod)~ 'Ok' ; 0
jniCheck builder ('show ()LAlertDialog;' jniMethod)~ ''
if. 0=ctx do. jniCheck DeleteLocalRef <cctx end.
EMPTY
)
MakeToast=: 0&$: : (4 : 0)
ctx=. x
'text duration'=. 2{.(boxopen y), <0
cctx=. getjactivity ctx
jniCheck toast=. 'android.widget.Toast' ('makeText (LContext;LCharSequence;I)LToast;' jniStaticMethod)~ cctx;text;duration
jniCheck toast ('show ()V' jniMethod)~ ''
jniCheck DeleteLocalRef< toast
if. 0=ctx do. jniCheck DeleteLocalRef <cctx end.
EMPTY
)
getjactivity=: 3 : 0
if. 0=y do.
  jniCheck app=. ('theApp LJConsoleApp;' jniStaticField) 'JConsoleApp'
  jniCheck act=. ('activity Lorg/dykman/j/android/AbstractActivity;' jniField) app
  jniCheck DeleteLocalRef <app
  act
else.
  y
end.
)
getdisplaymetrics=: 3 : 0
act=. getjactivity y
jniCheck wm=. act ('getWindowManager ()LWindowManager;' jniMethod)~ ''
jniCheck ds=. wm ('getDefaultDisplay ()LDisplay;' jniMethod)~ ''
jniCheck dm=. '' jniNewObject 'DisplayMetrics'
jniCheck ds ('getMetrics (LDisplayMetrics;)V' jniMethod)~ dm
jniCheck density=. ('density F' jniField) dm
jniCheck densityDpi=. ('densityDpi I' jniField) dm
jniCheck heightPixels=. ('heightPixels I' jniField) dm
jniCheck scaledDensity=. ('scaledDensity F' jniField) dm
jniCheck widthPixels=. ('widthPixels I' jniField) dm
jniCheck xdpi=. ('xdpi F' jniField) dm
jniCheck ydpi=. ('ydpi F' jniField) dm
if. APILEVEL_ja_ < 8 do.
  jniCheck rotation=. ds ('getOrientation ()I' jniMethod)~ ''
else.
  jniCheck rotation=. ds ('getRotation ()I' jniMethod)~ ''
end.
if. 0=y do.
  jniCheck DeleteLocalRef"0 act;wm;ds;dm
else.
  jniCheck DeleteLocalRef"0 wm;ds;dm
end.
rotation, density, densityDpi, heightPixels, scaledDensity, widthPixels, xdpi, ydpi
)

3 : 0''
if. 'Android'-:UNAME do.
  'DM_density DM_densityDpi DM_scaledDensity'=: 1 2 4{ getdisplaymetrics 0
end.
EMPTY
)

coclass 'jadrawable'
coinsert 'jni jaresu'

jniImport ::0: (0 : 0)
android.graphics.Bitmap
android.graphics.BitmapFactory
)
crunch=: 3 : 0
path=. }:^:('/'={:) y
rs=. 0 0$<''
for_dw. 1!:0 path, '/drawable*' do.
  dpi=. 8}. d=. 0{::dw
  dw1=. path, '/', d
  for_fn. 1!:0 dw1, '/*' do.
    dw2=. dw1, '/', d=. 0{::fn
    if. '.xml'-: (}.~ i:&'.') d do. continue. end.
    id=. dpi,~ ({.~ i:&'.') d
    try.
      jniCheck bm=. 'android.graphics.BitmapFactory' ('decodeFile (LString;)LBitmap;' jniStaticMethod)~ <dw2
      rs=. rs, id;NewGlobalRef <bm
      jniCheck DeleteLocalRef <bm
    catch.
      ExceptionClear''
    end.
  end.
end.
rs
)
coclass 'jalayout'
coinsert 'jexpat'
expat_initx=: 3 : 0
id_offset=: y
elements=: 0 0$''
idnames=: 0$<''
parents=: 0$0
)

expat_start_elementx=: 4 : 0
'elm att val'=. x
if. 0=#parents do. cparent=. _1 else. cparent=. {:parents end.
id=. _1 [ idname=. ''
if. (#att) > i=. (att i. <'id')<.(att i. <'android:id') do.
  if. '@' = {.va=. i{::val do.
    id=. _1 [ idname=. va
  else.
    id=. {.0".va
  end.
end.
idnames=: idnames, <idname
parents=: parents, #elements
elements=: elements , cparent;elm;id; (att,.val);''
)

expat_end_elementx=: 3 : 0
if. #expat_characterData do.
  elements=: (<expat_characterData) (<_1,~ {:parents)}elements
end.
parents=: }:parents
)

expat_parse_xmlx=: 3 : 0
if. #i=. I. (<'') ~: idnames do.
  idnames=: idnames -. <''
  id=. (id_offset+i.#i) i} >2{|:elements
  elements=: |: (<"0 id) 2}|:elements
end.
0;elements;< }.@(}.~ i.&'/')&.> idnames
)
coclass 'jamenu'
coinsert 'jexpat'
expat_initx=: 3 : 0
'id_offset group_offset'=: y
elements=: 0 0$''
idnames=: 0$<''
parents=: 0$0
menus=: 0$0
groups=: 0$0
gid=: 0
)

expat_start_elementx=: 4 : 0
'elm att val'=. x
if. 0=#parents do. cparent=. _1 else. cparent=. {:parents end.
if. 0=#menus do. cmenu=. 0 else. cmenu=. {:menus end.
if. 0=#groups do. cgroup=. 0 else. cgroup=. {:groups end.
id=. 0 [ idname=. ''
if. (0~:#parents) *. 'menu'-:elm do.
  for_i. i.-# elements do.
    'cp el dummy cm'=. 4{.i{elements
    if. 'item'-:el do.
      elements=: (<'submenu') (<1,~i)} elements
      menus=: menus, i break.
    end.
  end.
  return.
end.
if. (#att) > i=. (att i. <'id')<.(att i. <'android:id') do.
  if. '@' = {.va=. i{::val do.
    id=. 0 [ idname=. va
  else.
    id=. {.0".va
  end.
end.
idnames=: idnames, <idname
parents=: parents, #elements
if. 'group' -: elm do.
  groups=: groups, group_offset+gid
  gid=: gid+1
end.
elements=: elements , cparent;elm;id;cmenu;cgroup; (att,.val);''
)

expat_end_elementx=: 3 : 0
if. #expat_characterData do.
  elements=: (<expat_characterData) (<_1,~ {:parents)}elements
end.
if. 'menu' -: elm=. 1{::({:parents){elements do.
  menus=: }:menus
elseif. (<elm) e. <'menu' do.
  groups=: }:groups
  parents=: }:parents
elseif. do.
  parents=: }:parents
end.
)

expat_parse_xmlx=: 3 : 0
if. #i=. I. (<'') ~: idnames do.
  idnames=: idnames -. <''
  id=. (id_offset+i.#i) i}((#elements)#0)
  elements=: |: (<"0 id) 2}|:elements
end.
0;elements;(}.@(}.~ i.&'/')&.>idnames);group_offset+i.gid
)
coclass 'javalues'
coinsert 'jexpat'
expat_initx=: 3 : 0
elements=: 0 0$''
tag=: 0
)

expat_start_elementx=: 4 : 0
'elm att val'=. x
if. 'resources'-: elm do. tag=: >:tag return. end.
if. 1=tag do.
  if. (#att) > i=. att i. <'name' do.
    name=. i{::val
    elements=: elements , elm;name;''
  end.
end.
)

expat_end_elementx=: 3 : 0
if. (1~:tag) +. 0=#elements do. return. end.
elm=. (<_1 0){::elements
if. 'resources'-: elm do. tag=: <:tag return. end.
if. #expat_characterData do.
  elements=: (<expat_characterData) (<_1 _1)}elements
end.
)

expat_parse_xmlx=: 3 : 0
0;elements;''
)
coclass 'jaresu'
coinsert 'jni'
3 : 0''
if. 'Android'-:UNAME do.
  jniCheck FILL=: ('FILL Landroid/graphics/Paint$Style;' jniStaticField) 'android/graphics/Paint$Style'
  jniCheck FILL_AND_STROKE=: ('FILL_AND_STROKE Landroid/graphics/Paint$Style;' jniStaticField) 'android/graphics/Paint$Style'
  jniCheck STROKE=: ('STROKE Landroid/graphics/Paint$Style;' jniStaticField) 'android/graphics/Paint$Style'

  jniCheck Typeface_DEFAULT=: ('DEFAULT Landroid/graphics/Typeface;' jniStaticField) 'android/graphics/Typeface'
  jniCheck Typeface_DEFAULT_BOLD=: ('DEFAULT_BOLD Landroid/graphics/Typeface;' jniStaticField) 'android/graphics/Typeface'
  jniCheck Typeface_MONOSPACE=: ('MONOSPACE Landroid/graphics/Typeface;' jniStaticField) 'android/graphics/Typeface'
  jniCheck Typeface_SANS_SERIF=: ('SANS_SERIF Landroid/graphics/Typeface;' jniStaticField) 'android/graphics/Typeface'
  jniCheck Typeface_SERIF=: ('SERIF Landroid/graphics/Typeface;' jniStaticField) 'android/graphics/Typeface'
  jniCheck ARGB_8888=: NewGlobalRef < a1=. ('ARGB_8888 Landroid/graphics/Bitmap$Config;' jniStaticField) 'android/graphics/Bitmap$Config'
  jniCheck DeleteLocalRef <a1
end.
''
)

Typeface_BOLD=: 1
Typeface_BOLD_ITALIC=: 3
Typeface_ITALIC=: 2
Typeface_NORMAL=: 0

FILL_PARENT=: _1
MATCH_PARENT=: _1
WRAP_CONTENT=: _2

BUTTON_NEGATIVE=: _2
BUTTON_NEUTRAL=: _3
BUTTON_POSITIVE=: _1
gravityres=: 3 : 0
a=. <;._1 '|', y-.' '
+/ gravityconst #~ gravityattr e. a
)

scaletyperes=: 3 : 0
(<;._1 ' matrix fitXY fitStart fitCenter fitEnd center centerCrop centerInside') e. <y
)

androidcolorattr=: <;._1 ' black blue cyan darkgray gray green lightgray magenta red transparent white yellow'
colorres=: 1 : 0
res=. m
if. '@android:color/'-:15{.y do. androidcolorconst {~ androidcolorattr i. <tolower 15}.y return. end.
z=. y
if. '@color/'-:7{.y do.
  f0=. ({."1 res) = <'color'
  f1=. (1{"1 res) = <7}.y
  if. #f=. I. f0*.f1 do.
    z=. (2,~{.f){::res
  else.
    z=. 7}.y
  end.
end.
if. '#'={.z do.
  z=. tolower }.z
  if. 8=#z do.
    if. (({.z) e. '89abcdef') do.
      <. 4294967296 -~ {. 0". '16b', z
    else.
      <. {. 0". '16b', z
    end.
  elseif. 6=#z do.
    <. 4294967296 -~ {. 0". '16bff', z
  elseif. 4=#z do.
    if. (({.z) e. '89abcdef') do.
      <. 4294967296 -~ {. 0". '16b', 2#z
    else.
      <. {. 0". '16b', 2#z
    end.
  elseif. 3=#z do.
    <. 4294967296 -~ {. 0". '16bff', 2#z
  elseif. do. 0
  end.
else.
  <. {. 0". z
end.
)

stringres=: 1 : 0
res=. m
z=. y
if. '@string/'-:8{.y do.
  f0=. ({."1 res) = <'string'
  f1=. (1{"1 res) = <8}.y
  if. #f=. I. f0*.f1 do.
    z=. (2,~{.f){::res
  else.
    z=. 8}.y
  end.
end.
z
)

numberres=: 2 : 0
res=. m
idnames=. n
if. y-:'true' do.
  1
elseif. y-:'false' do.
  0
elseif. ('?android:attr/'-:14{.y) +. '@android:attr/'-:14{.y do.
  {. 0+". 'R_attr_',(14}.y)
elseif. ('?android:id/'-:12{.y) +. '@android:id/'-:12{.y do.
  {. 0+". 'R_id_',(12}.y)
elseif. '@attr/'-:6{.y do.
  f0=. ({."1 res) = <'attr'
  f1=. (1{"1 res) = <6}.y
  if. #f=. I. f0*.f1 do.
    {. 0 ". z=. (2,~{.f){::res
  else.
    {. 0 ". 6}.y
  end.
elseif. ('@id/'-:4{.y) +. '@+id/'-:5{.y do.
  (0,1+i) {~ (#idnames) > i=. idnames i. < }.@(}.~ i.&'/')y
elseif. do.
  unit=. y-.'-.0123456789'
  num=. {. 0". y-.unit
  if. (<unit) e. 'fill_parent';'match_parent' do.
    num=. MATCH_PARENT
  elseif. unit-:'wrap_content' do.
    num=. WRAP_CONTENT
  end.
  if. #unit do.
    select. <unit
    case. 'px' do.
    case. 'dp';'dip' do. num=. <. 0.5+num*DM_density_ja_
    case. 'sp' do. num=. <. 0.5+num*DM_scaledDensity_ja_
    end.
  end.
  num
end.
)
drawres=: 1 : 0
res=. m
if. ('#'={.y) +. ('@color/'-:7{.y) +. '@android:color/'-:15{.y do. < (res colorres) y return. end.
if. '@drawable/' -.@-: 10{.y do. '' return. end.
if. (#res) = i=. ({."1 res) i. < 10}.y do. '' return. end.
i{::{:"1 res
)
id4name=: 4 : 0
idnames=. x
(0,1+i) {~ (#idnames) > i=. idnames i. < y
)
id2name=: 4 : 0
idnames=. x
(<:y){::idnames
)
pt2sp=: 3 : 0"0
y*160%72
)
pt2px=: 3 : 0"0
y*DM_scaledDensity_ja_*160%72
)
dp2px=: 3 : 0"0
if. y>0 do.
  <. 0.5+y*DM_density_ja_
else.
  y
end.
)
px2dp=: 3 : 0"0
if. y>0 do.
  <. 0.5+y%DM_density_ja_
else.
  y
end.
)
dpw2px=: 3 : 0"0
if. y>0 do.
  <. 0.5+y*DM_density_ja_*4
else.
  y
end.
)
px2dpw=: 3 : 0"0
if. y>0 do.
  <. 0.5+y%DM_density_ja_*4
else.
  y
end.
)
FEATURE_ACTION_BAR=: 8
FEATURE_ACTION_BAR_OVERLAY=: 9
FEATURE_ACTION_MODE_OVERLAY=: 10
FEATURE_CONTEXT_MENU=: 6
FEATURE_CUSTOM_TITLE=: 7
FEATURE_INDETERMINATE_PROGRESS=: 5
FEATURE_LEFT_ICON=: 3
FEATURE_NO_TITLE=: 1
FEATURE_OPTIONS_PANEL=: 0
FEATURE_PROGRESS=: 2
FEATURE_RIGHT_ICON=: 4
FLAG_ALLOW_LOCK_WHILE_SCREEN_ON=: 1
FLAG_ALT_FOCUSABLE_IM=: 131072
FLAG_BLUR_BEHIND=: 4
FLAG_DIM_BEHIND=: 2
FLAG_DISMISS_KEYGUARD=: 4194304
FLAG_DITHER=: 4096
FLAG_FORCE_NOT_FULLSCREEN=: 2048
FLAG_FULLSCREEN=: 1024
FLAG_HARDWARE_ACCELERATED=: 16777216
FLAG_IGNORE_CHEEK_PRESSES=: 32768
FLAG_KEEP_SCREEN_ON=: 128
FLAG_LAYOUT_INSET_DECOR=: 65536
FLAG_LAYOUT_IN_SCREEN=: 256
FLAG_LAYOUT_NO_LIMITS=: 512
FLAG_NOT_FOCUSABLE=: 8
FLAG_NOT_TOUCHABLE=: 16
FLAG_NOT_TOUCH_MODAL=: 32
FLAG_SCALED=: 16384
FLAG_SECURE=: 8192
FLAG_SHOW_WALLPAPER=: 1048576
FLAG_SHOW_WHEN_LOCKED=: 524288
FLAG_SPLIT_TOUCH=: 8388608
FLAG_TOUCHABLE_WHEN_WAKING=: 64
FLAG_TURN_SCREEN_ON=: 2097152
FLAG_WATCH_OUTSIDE_TOUCH=: 262144
HORIZONTAL=: 0
SHOW_DIVIDER_BEGINNING=: 1
SHOW_DIVIDER_END=: 4
SHOW_DIVIDER_MIDDLE=: 2
SHOW_DIVIDER_NONE=: 0
VERTICAL=: 1
ABOVE=: 2
ALIGN_BASELINE=: 4
ALIGN_BOTTOM=: 8
ALIGN_LEFT=: 5
ALIGN_PARENT_BOTTOM=: 12
ALIGN_PARENT_LEFT=: 9
ALIGN_PARENT_RIGHT=: 11
ALIGN_PARENT_TOP=: 10
ALIGN_RIGHT=: 7
ALIGN_TOP=: 6
BELOW=: 3
CENTER_HORIZONTAL=: 14
CENTER_IN_PARENT=: 13
CENTER_VERTICAL=: 15
LEFT_OF=: 0
RIGHT_OF=: 1
TRUE=: _1

R_amin_accelerate_decelerate_interpolator=: 17432580
R_amin_accelerate_interpolator=: 17432581
R_amin_anticipate_interpolator=: 17432583
R_amin_anticipate_overshoot_interpolator=: 17432585
R_amin_bounce_interpolator=: 17432586
R_amin_cycle_interpolator=: 17432588
R_amin_decelerate_interpolator=: 17432582
R_amin_fade_in=: 17432576
R_amin_fade_out=: 17432577
R_amin_linear_interpolator=: 17432587
R_amin_overshoot_interpolator=: 17432584
R_amin_slide_in_left=: 17432578
R_amin_slide_out_right=: 17432579

R_animator_fade_in=: 17498112
R_animator_fade_out=: 17498113

R_array_emailAddressTypes=: 17235968
R_array_imProtocols=: 17235969
R_array_organizationTypes=: 17235970
R_array_phoneTypes=: 17235971
R_array_postalAddressTypes=: 17235972

R_attr_absListViewStyle=: 16842858
R_attr_accessibilityEventTypes=: 16843648
R_attr_accessibilityFeedbackType=: 16843650
R_attr_accessibilityFlags=: 16843652
R_attr_accountPreferences=: 16843423
R_attr_accountType=: 16843407
R_attr_action=: 16842797
R_attr_actionBarDivider=: 16843675
R_attr_actionBarItemBackground=: 16843676
R_attr_actionBarSize=: 16843499
R_attr_actionBarSplitStyle=: 16843656
R_attr_actionBarStyle=: 16843470
R_attr_actionBarTabBarStyle=: 16843508
R_attr_actionBarTabStyle=: 16843507
R_attr_actionBarTabTextStyle=: 16843509
R_attr_actionBarWidgetTheme=: 16843671
R_attr_actionButtonStyle=: 16843480
R_attr_actionDropDownStyle=: 16843479
R_attr_actionLayout=: 16843515
R_attr_actionMenuTextAppearance=: 16843616
R_attr_actionMenuTextColor=: 16843617
R_attr_actionModeBackground=: 16843483
R_attr_actionModeCloseButtonStyle=: 16843511
R_attr_actionModeCloseDrawable=: 16843484
R_attr_actionModeCopyDrawable=: 16843538
R_attr_actionModeCutDrawable=: 16843537
R_attr_actionModePasteDrawable=: 16843539
R_attr_actionModeSelectAllDrawable=: 16843646
R_attr_actionModeSplitBackground=: 16843677
R_attr_actionModeStyle=: 16843668
R_attr_actionOverflowButtonStyle=: 16843510
R_attr_actionProviderClass=: 16843657
R_attr_actionViewClass=: 16843516
R_attr_activatedBackgroundIndicator=: 16843517
R_attr_activityCloseEnterAnimation=: 16842938
R_attr_activityCloseExitAnimation=: 16842939
R_attr_activityOpenEnterAnimation=: 16842936
R_attr_activityOpenExitAnimation=: 16842937
R_attr_addStatesFromChildren=: 16842992
R_attr_adjustViewBounds=: 16843038
R_attr_alertDialogIcon=: 16843605
R_attr_alertDialogStyle=: 16842845
R_attr_alertDialogTheme=: 16843529
R_attr_alignmentMode=: 16843642
R_attr_allContactsName=: 16843468
R_attr_allowBackup=: 16843392
R_attr_allowClearUserData=: 16842757
R_attr_allowParallelSyncs=: 16843570
R_attr_allowSingleTap=: 16843353
R_attr_allowTaskReparenting=: 16843268
R_attr_alpha=: 16843551
R_attr_alphabeticShortcut=: 16843235
R_attr_alwaysDrawnWithCache=: 16842991
R_attr_alwaysRetainTaskState=: 16843267
R_attr_angle=: 16843168
R_attr_animateFirstView=: 16843477
R_attr_animateLayoutChanges=: 16843506
R_attr_animateOnClick=: 16843356
R_attr_animation=: 16843213
R_attr_animationCache=: 16842989
R_attr_animationDuration=: 16843026
R_attr_animationOrder=: 16843214
R_attr_animationResolution=: 16843546
R_attr_antialias=: 16843034
R_attr_anyDensity=: 16843372
R_attr_apiKey=: 16843281
R_attr_author=: 16843444
R_attr_authorities=: 16842776
R_attr_autoAdvanceViewId=: 16843535
R_attr_autoCompleteTextViewStyle=: 16842859
R_attr_autoLink=: 16842928
R_attr_autoStart=: 16843445
R_attr_autoText=: 16843114
R_attr_autoUrlDetect=: 16843404
R_attr_background=: 16842964
R_attr_backgroundDimAmount=: 16842802
R_attr_backgroundDimEnabled=: 16843295
R_attr_backgroundSplit=: 16843659
R_attr_backgroundStacked=: 16843658
R_attr_backupAgent=: 16843391
R_attr_baseline=: 16843548
R_attr_baselineAlignBottom=: 16843042
R_attr_baselineAligned=: 16843046
R_attr_baselineAlignedChildIndex=: 16843047
R_attr_borderlessButtonStyle=: 16843563
R_attr_bottom=: 16843184
R_attr_bottomBright=: 16842957
R_attr_bottomDark=: 16842953
R_attr_bottomLeftRadius=: 16843179
R_attr_bottomMedium=: 16842958
R_attr_bottomOffset=: 16843351
R_attr_bottomRightRadius=: 16843180
R_attr_breadCrumbShortTitle=: 16843524
R_attr_breadCrumbTitle=: 16843523
R_attr_bufferType=: 16843086
R_attr_button=: 16843015
R_attr_buttonBarButtonStyle=: 16843567
R_attr_buttonBarStyle=: 16843566
R_attr_buttonStyle=: 16842824
R_attr_buttonStyleInset=: 16842826
R_attr_buttonStyleSmall=: 16842825
R_attr_buttonStyleToggle=: 16842827
R_attr_cacheColorHint=: 16843009
R_attr_calendarViewShown=: 16843596
R_attr_calendarViewStyle=: 16843613
R_attr_canRetrieveWindowContent=: 16843653
R_attr_candidatesTextStyleSpans=: 16843312
R_attr_capitalize=: 16843113
R_attr_centerBright=: 16842956
R_attr_centerColor=: 16843275
R_attr_centerDark=: 16842952
R_attr_centerMedium=: 16842959
R_attr_centerX=: 16843170
R_attr_centerY=: 16843171
R_attr_checkBoxPreferenceStyle=: 16842895
R_attr_checkMark=: 16843016
R_attr_checkable=: 16843237
R_attr_checkableBehavior=: 16843232
R_attr_checkboxStyle=: 16842860
R_attr_checked=: 16843014
R_attr_checkedButton=: 16843080
R_attr_childDivider=: 16843025
R_attr_childIndicator=: 16843020
R_attr_childIndicatorLeft=: 16843023
R_attr_childIndicatorRight=: 16843024
R_attr_choiceMode=: 16843051
R_attr_clearTaskOnLaunch=: 16842773
R_attr_clickable=: 16842981
R_attr_clipChildren=: 16842986
R_attr_clipOrientation=: 16843274
R_attr_clipToPadding=: 16842987
R_attr_codes=: 16843330
R_attr_collapseColumns=: 16843083
R_attr_color=: 16843173
R_attr_colorActivatedHighlight=: 16843664
R_attr_colorBackground=: 16842801
R_attr_colorBackgroundCacheHint=: 16843435
R_attr_colorFocusedHighlight=: 16843663
R_attr_colorForeground=: 16842800
R_attr_colorForegroundInverse=: 16843270
R_attr_colorLongPressedHighlight=: 16843662
R_attr_colorMultiSelectHighlight=: 16843665
R_attr_colorPressedHighlight=: 16843661
R_attr_columnCount=: 16843639
R_attr_columnDelay=: 16843215
R_attr_columnOrderPreserved=: 16843640
R_attr_columnWidth=: 16843031
R_attr_compatibleWidthLimitDp=: 16843621
R_attr_completionHint=: 16843122
R_attr_completionHintView=: 16843123
R_attr_completionThreshold=: 16843124
R_attr_configChanges=: 16842783
R_attr_configure=: 16843357
R_attr_constantSize=: 16843158
R_attr_content=: 16843355
R_attr_contentAuthority=: 16843408
R_attr_contentDescription=: 16843379
R_attr_cropToPadding=: 16843043
R_attr_cursorVisible=: 16843090
R_attr_customNavigationLayout=: 16843474
R_attr_customTokens=: 16843579
R_attr_cycles=: 16843220
R_attr_dashGap=: 16843175
R_attr_dashWidth=: 16843174
R_attr_data=: 16842798
R_attr_datePickerStyle=: 16843612
R_attr_dateTextAppearance=: 16843593
R_attr_debuggable=: 16842767
R_attr_defaultValue=: 16843245
R_attr_delay=: 16843212
R_attr_dependency=: 16843244
R_attr_descendantFocusability=: 16842993
R_attr_description=: 16842784
R_attr_detachWallpaper=: 16843430
R_attr_detailColumn=: 16843427
R_attr_detailSocialSummary=: 16843428
R_attr_detailsElementBackground=: 16843598
R_attr_dial=: 16843010
R_attr_dialogIcon=: 16843252
R_attr_dialogLayout=: 16843255
R_attr_dialogMessage=: 16843251
R_attr_dialogPreferenceStyle=: 16842897
R_attr_dialogTheme=: 16843528
R_attr_dialogTitle=: 16843250
R_attr_digits=: 16843110
R_attr_direction=: 16843217
R_attr_directionDescriptions=: 16843681
R_attr_directionPriority=: 16843218
R_attr_disableDependentsState=: 16843249
R_attr_disabledAlpha=: 16842803
R_attr_displayOptions=: 16843472
R_attr_dither=: 16843036
R_attr_divider=: 16843049
R_attr_dividerHeight=: 16843050
R_attr_dividerHorizontal=: 16843564
R_attr_dividerPadding=: 16843562
R_attr_dividerVertical=: 16843530
R_attr_drawSelectorOnTop=: 16843004
R_attr_drawable=: 16843161
R_attr_drawableBottom=: 16843118
R_attr_drawableEnd=: 16843667
R_attr_drawableLeft=: 16843119
R_attr_drawablePadding=: 16843121
R_attr_drawableRight=: 16843120
R_attr_drawableStart=: 16843666
R_attr_drawableTop=: 16843117
R_attr_drawingCacheQuality=: 16842984
R_attr_dropDownAnchor=: 16843363
R_attr_dropDownHeight=: 16843395
R_attr_dropDownHintAppearance=: 16842888
R_attr_dropDownHorizontalOffset=: 16843436
R_attr_dropDownItemStyle=: 16842886
R_attr_dropDownListViewStyle=: 16842861
R_attr_dropDownSelector=: 16843125
R_attr_dropDownSpinnerStyle=: 16843478
R_attr_dropDownVerticalOffset=: 16843437
R_attr_dropDownWidth=: 16843362
R_attr_duplicateParentState=: 16842985
R_attr_duration=: 16843160
R_attr_editTextBackground=: 16843602
R_attr_editTextColor=: 16843601
R_attr_editTextPreferenceStyle=: 16842898
R_attr_editTextStyle=: 16842862
R_attr_editable=: 16843115
R_attr_editorExtras=: 16843300
R_attr_ellipsize=: 16842923
R_attr_ems=: 16843096
R_attr_enabled=: 16842766
R_attr_endColor=: 16843166
R_attr_endYear=: 16843133
R_attr_enterFadeDuration=: 16843532
R_attr_entries=: 16842930
R_attr_entryValues=: 16843256
R_attr_eventsInterceptionEnabled=: 16843389
R_attr_excludeFromRecents=: 16842775
R_attr_exitFadeDuration=: 16843533
R_attr_expandableListPreferredChildIndicatorLeft=: 16842834
R_attr_expandableListPreferredChildIndicatorRight=: 16842835
R_attr_expandableListPreferredChildPaddingLeft=: 16842831
R_attr_expandableListPreferredItemIndicatorLeft=: 16842832
R_attr_expandableListPreferredItemIndicatorRight=: 16842833
R_attr_expandableListPreferredItemPaddingLeft=: 16842830
R_attr_expandableListViewStyle=: 16842863
R_attr_expandableListViewWhiteStyle=: 16843446
R_attr_exported=: 16842768
R_attr_extraTension=: 16843371
R_attr_factor=: 16843219
R_attr_fadeDuration=: 16843384
R_attr_fadeEnabled=: 16843390
R_attr_fadeOffset=: 16843383
R_attr_fadeScrollbars=: 16843434
R_attr_fadingEdge=: 16842975
R_attr_fadingEdgeLength=: 16842976
R_attr_fastScrollAlwaysVisible=: 16843573
R_attr_fastScrollEnabled=: 16843302
R_attr_fastScrollOverlayPosition=: 16843578
R_attr_fastScrollPreviewBackgroundLeft=: 16843575
R_attr_fastScrollPreviewBackgroundRight=: 16843576
R_attr_fastScrollTextColor=: 16843609
R_attr_fastScrollThumbDrawable=: 16843574
R_attr_fastScrollTrackDrawable=: 16843577
R_attr_fillAfter=: 16843197
R_attr_fillBefore=: 16843196
R_attr_fillEnabled=: 16843343
R_attr_fillViewport=: 16843130
R_attr_filter=: 16843035
R_attr_filterTouchesWhenObscured=: 16843460
R_attr_finishOnCloseSystemDialogs=: 16843431
R_attr_finishOnTaskLaunch=: 16842772
R_attr_firstDayOfWeek=: 16843581
R_attr_fitsSystemWindows=: 16842973
R_attr_flipInterval=: 16843129
R_attr_focusable=: 16842970
R_attr_focusableInTouchMode=: 16842971
R_attr_focusedMonthDateColor=: 16843587
R_attr_fontFamily=: 16843692
R_attr_footerDividersEnabled=: 16843311
R_attr_foreground=: 16843017
R_attr_foregroundGravity=: 16843264
R_attr_format=: 16843013
R_attr_fragment=: 16843491
R_attr_fragmentCloseEnterAnimation=: 16843495
R_attr_fragmentCloseExitAnimation=: 16843496
R_attr_fragmentFadeEnterAnimation=: 16843497
R_attr_fragmentFadeExitAnimation=: 16843498
R_attr_fragmentOpenEnterAnimation=: 16843493
R_attr_fragmentOpenExitAnimation=: 16843494
R_attr_freezesText=: 16843116
R_attr_fromAlpha=: 16843210
R_attr_fromDegrees=: 16843187
R_attr_fromXDelta=: 16843206
R_attr_fromXScale=: 16843202
R_attr_fromYDelta=: 16843208
R_attr_fromYScale=: 16843204
R_attr_fullBright=: 16842954
R_attr_fullDark=: 16842950
R_attr_functionalTest=: 16842787
R_attr_galleryItemBackground=: 16842828
R_attr_galleryStyle=: 16842864
R_attr_gestureColor=: 16843381
R_attr_gestureStrokeAngleThreshold=: 16843388
R_attr_gestureStrokeLengthThreshold=: 16843386
R_attr_gestureStrokeSquarenessThreshold=: 16843387
R_attr_gestureStrokeType=: 16843385
R_attr_gestureStrokeWidth=: 16843380
R_attr_glEsVersion=: 16843393
R_attr_gradientRadius=: 16843172
R_attr_grantUriPermissions=: 16842779
R_attr_gravity=: 16842927
R_attr_gridViewStyle=: 16842865
R_attr_groupIndicator=: 16843019
R_attr_hand_hour=: 16843011
R_attr_hand_minute=: 16843012
R_attr_handle=: 16843354
R_attr_handleProfiling=: 16842786
R_attr_hapticFeedbackEnabled=: 16843358
R_attr_hardwareAccelerated=: 16843475
R_attr_hasCode=: 16842764
R_attr_headerBackground=: 16843055
R_attr_headerDividersEnabled=: 16843310
R_attr_height=: 16843093
R_attr_hint=: 16843088
R_attr_homeAsUpIndicator=: 16843531
R_attr_homeLayout=: 16843549
R_attr_horizontalDivider=: 16843053
R_attr_horizontalGap=: 16843327
R_attr_horizontalScrollViewStyle=: 16843603
R_attr_horizontalSpacing=: 16843028
R_attr_host=: 16842792
R_attr_icon=: 16842754
R_attr_iconPreview=: 16843337
R_attr_iconifiedByDefault=: 16843514
R_attr_id=: 16842960
R_attr_ignoreGravity=: 16843263
R_attr_imageButtonStyle=: 16842866
R_attr_imageWellStyle=: 16842867
R_attr_imeActionId=: 16843366
R_attr_imeActionLabel=: 16843365
R_attr_imeExtractEnterAnimation=: 16843368
R_attr_imeExtractExitAnimation=: 16843369
R_attr_imeFullscreenBackground=: 16843308
R_attr_imeOptions=: 16843364
R_attr_imeSubtypeExtraValue=: 16843502
R_attr_imeSubtypeLocale=: 16843500
R_attr_imeSubtypeMode=: 16843501
R_attr_immersive=: 16843456
R_attr_importantForAccessibility=: 16843690
R_attr_inAnimation=: 16843127
R_attr_includeFontPadding=: 16843103
R_attr_includeInGlobalSearch=: 16843374
R_attr_indeterminate=: 16843065
R_attr_indeterminateBehavior=: 16843070
R_attr_indeterminateDrawable=: 16843067
R_attr_indeterminateDuration=: 16843069
R_attr_indeterminateOnly=: 16843066
R_attr_indeterminateProgressStyle=: 16843544
R_attr_indicatorLeft=: 16843021
R_attr_indicatorRight=: 16843022
R_attr_inflatedId=: 16842995
R_attr_initOrder=: 16842778
R_attr_initialLayout=: 16843345
R_attr_innerRadius=: 16843359
R_attr_innerRadiusRatio=: 16843163
R_attr_inputMethod=: 16843112
R_attr_inputType=: 16843296
R_attr_insetBottom=: 16843194
R_attr_insetLeft=: 16843191
R_attr_insetRight=: 16843192
R_attr_insetTop=: 16843193
R_attr_installLocation=: 16843447
R_attr_interpolator=: 16843073
R_attr_isAlwaysSyncable=: 16843571
R_attr_isAuxiliary=: 16843647
R_attr_isDefault=: 16843297
R_attr_isIndicator=: 16843079
R_attr_isModifier=: 16843334
R_attr_isRepeatable=: 16843336
R_attr_isScrollContainer=: 16843342
R_attr_isSticky=: 16843335
R_attr_isolatedProcess=: 16843689
R_attr_itemBackground=: 16843056
R_attr_itemIconDisabledAlpha=: 16843057
R_attr_itemPadding=: 16843565
R_attr_itemTextAppearance=: 16843052
R_attr_keepScreenOn=: 16843286
R_attr_key=: 16843240
R_attr_keyBackground=: 16843315
R_attr_keyEdgeFlags=: 16843333
R_attr_keyHeight=: 16843326
R_attr_keyIcon=: 16843340
R_attr_keyLabel=: 16843339
R_attr_keyOutputText=: 16843338
R_attr_keyPreviewHeight=: 16843321
R_attr_keyPreviewLayout=: 16843319
R_attr_keyPreviewOffset=: 16843320
R_attr_keyTextColor=: 16843318
R_attr_keyTextSize=: 16843316
R_attr_keyWidth=: 16843325
R_attr_keyboardLayout=: 16843691
R_attr_keyboardMode=: 16843341
R_attr_keycode=: 16842949
R_attr_killAfterRestore=: 16843420
R_attr_label=: 16842753
R_attr_labelTextSize=: 16843317
R_attr_largeHeap=: 16843610
R_attr_largeScreens=: 16843398
R_attr_largestWidthLimitDp=: 16843622
R_attr_launchMode=: 16842781
R_attr_layerType=: 16843604
R_attr_layout=: 16842994
R_attr_layoutAnimation=: 16842988
R_attr_layout_above=: 16843140
R_attr_layout_alignBaseline=: 16843142
R_attr_layout_alignBottom=: 16843146
R_attr_layout_alignLeft=: 16843143
R_attr_layout_alignParentBottom=: 16843150
R_attr_layout_alignParentLeft=: 16843147
R_attr_layout_alignParentRight=: 16843149
R_attr_layout_alignParentTop=: 16843148
R_attr_layout_alignRight=: 16843145
R_attr_layout_alignTop=: 16843144
R_attr_layout_alignWithParentIfMissing=: 16843154
R_attr_layout_below=: 16843141
R_attr_layout_centerHorizontal=: 16843152
R_attr_layout_centerInParent=: 16843151
R_attr_layout_centerVertical=: 16843153
R_attr_layout_column=: 16843084
R_attr_layout_columnSpan=: 16843645
R_attr_layout_gravity=: 16842931
R_attr_layout_height=: 16842997
R_attr_layout_margin=: 16842998
R_attr_layout_marginBottom=: 16843002
R_attr_layout_marginLeft=: 16842999
R_attr_layout_marginRight=: 16843001
R_attr_layout_marginTop=: 16843000
R_attr_layout_row=: 16843643
R_attr_layout_rowSpan=: 16843644
R_attr_layout_scale=: 16843155
R_attr_layout_span=: 16843085
R_attr_layout_toLeftOf=: 16843138
R_attr_layout_toRightOf=: 16843139
R_attr_layout_weight=: 16843137
R_attr_layout_width=: 16842996
R_attr_layout_x=: 16843135
R_attr_layout_y=: 16843136
R_attr_left=: 16843181
R_attr_lineSpacingExtra=: 16843287
R_attr_lineSpacingMultiplier=: 16843288
R_attr_lines=: 16843092
R_attr_linksClickable=: 16842929
R_attr_listChoiceBackgroundIndicator=: 16843504
R_attr_listChoiceIndicatorMultiple=: 16843290
R_attr_listChoiceIndicatorSingle=: 16843289
R_attr_listDivider=: 16843284
R_attr_listDividerAlertDialog=: 16843525
R_attr_listPopupWindowStyle=: 16843519
R_attr_listPreferredItemHeight=: 16842829
R_attr_listPreferredItemHeightLarge=: 16843654
R_attr_listPreferredItemHeightSmall=: 16843655
R_attr_listPreferredItemPaddingLeft=: 16843683
R_attr_listPreferredItemPaddingRight=: 16843684
R_attr_listSelector=: 16843003
R_attr_listSeparatorTextViewStyle=: 16843272
R_attr_listViewStyle=: 16842868
R_attr_listViewWhiteStyle=: 16842869
R_attr_logo=: 16843454
R_attr_longClickable=: 16842982
R_attr_loopViews=: 16843527
R_attr_manageSpaceActivity=: 16842756
R_attr_mapViewStyle=: 16842890
R_attr_marqueeRepeatLimit=: 16843293
R_attr_max=: 16843062
R_attr_maxDate=: 16843584
R_attr_maxEms=: 16843095
R_attr_maxHeight=: 16843040
R_attr_maxItemsPerRow=: 16843060
R_attr_maxLength=: 16843104
R_attr_maxLevel=: 16843186
R_attr_maxLines=: 16843091
R_attr_maxRows=: 16843059
R_attr_maxSdkVersion=: 16843377
R_attr_maxWidth=: 16843039
R_attr_measureAllChildren=: 16843018
R_attr_measureWithLargestChild=: 16843476
R_attr_mediaRouteButtonStyle=: 16843693
R_attr_mediaRouteTypes=: 16843694
R_attr_menuCategory=: 16843230
R_attr_mimeType=: 16842790
R_attr_minDate=: 16843583
R_attr_minEms=: 16843098
R_attr_minHeight=: 16843072
R_attr_minLevel=: 16843185
R_attr_minLines=: 16843094
R_attr_minResizeHeight=: 16843670
R_attr_minResizeWidth=: 16843669
R_attr_minSdkVersion=: 16843276
R_attr_minWidth=: 16843071
R_attr_mode=: 16843134
R_attr_moreIcon=: 16843061
R_attr_multiprocess=: 16842771
R_attr_name=: 16842755
R_attr_navigationMode=: 16843471
R_attr_negativeButtonText=: 16843254
R_attr_nextFocusDown=: 16842980
R_attr_nextFocusForward=: 16843580
R_attr_nextFocusLeft=: 16842977
R_attr_nextFocusRight=: 16842978
R_attr_nextFocusUp=: 16842979
R_attr_noHistory=: 16843309
R_attr_normalScreens=: 16843397
R_attr_notificationTimeout=: 16843651
R_attr_numColumns=: 16843032
R_attr_numStars=: 16843076
R_attr_numeric=: 16843109
R_attr_numericShortcut=: 16843236
R_attr_onClick=: 16843375
R_attr_oneshot=: 16843159
R_attr_opacity=: 16843550
R_attr_order=: 16843242
R_attr_orderInCategory=: 16843231
R_attr_ordering=: 16843490
R_attr_orderingFromXml=: 16843239
R_attr_orientation=: 16842948
R_attr_outAnimation=: 16843128
R_attr_overScrollFooter=: 16843459
R_attr_overScrollHeader=: 16843458
R_attr_overScrollMode=: 16843457
R_attr_overridesImplicitlyEnabledSubtype=: 16843682
R_attr_packageNames=: 16843649
R_attr_padding=: 16842965
R_attr_paddingBottom=: 16842969
R_attr_paddingLeft=: 16842966
R_attr_paddingRight=: 16842968
R_attr_paddingTop=: 16842967
R_attr_panelBackground=: 16842846
R_attr_panelColorBackground=: 16842849
R_attr_panelColorForeground=: 16842848
R_attr_panelFullBackground=: 16842847
R_attr_panelTextAppearance=: 16842850
R_attr_parentActivityName=: 16843687
R_attr_password=: 16843100
R_attr_path=: 16842794
R_attr_pathPattern=: 16842796
R_attr_pathPrefix=: 16842795
R_attr_permission=: 16842758
R_attr_permissionGroup=: 16842762
R_attr_persistent=: 16842765
R_attr_persistentDrawingCache=: 16842990
R_attr_phoneNumber=: 16843111
R_attr_pivotX=: 16843189
R_attr_pivotY=: 16843190
R_attr_popupAnimationStyle=: 16843465
R_attr_popupBackground=: 16843126
R_attr_popupCharacters=: 16843332
R_attr_popupKeyboard=: 16843331
R_attr_popupLayout=: 16843323
R_attr_popupMenuStyle=: 16843520
R_attr_popupWindowStyle=: 16842870
R_attr_port=: 16842793
R_attr_positiveButtonText=: 16843253
R_attr_preferenceCategoryStyle=: 16842892
R_attr_preferenceInformationStyle=: 16842893
R_attr_preferenceLayoutChild=: 16842900
R_attr_preferenceScreenStyle=: 16842891
R_attr_preferenceStyle=: 16842894
R_attr_previewImage=: 16843482
R_attr_priority=: 16842780
R_attr_privateImeOptions=: 16843299
R_attr_process=: 16842769
R_attr_progress=: 16843063
R_attr_progressBarPadding=: 16843545
R_attr_progressBarStyle=: 16842871
R_attr_progressBarStyleHorizontal=: 16842872
R_attr_progressBarStyleInverse=: 16843399
R_attr_progressBarStyleLarge=: 16842874
R_attr_progressBarStyleLargeInverse=: 16843401
R_attr_progressBarStyleSmall=: 16842873
R_attr_progressBarStyleSmallInverse=: 16843400
R_attr_progressBarStyleSmallTitle=: 16843279
R_attr_progressDrawable=: 16843068
R_attr_prompt=: 16843131
R_attr_propertyName=: 16843489
R_attr_protectionLevel=: 16842761
R_attr_publicKey=: 16843686
R_attr_queryActionMsg=: 16843227
R_attr_queryAfterZeroResults=: 16843394
R_attr_queryHint=: 16843608
R_attr_quickContactBadgeStyleSmallWindowLarge=: 16843443
R_attr_quickContactBadgeStyleSmallWindowMedium=: 16843442
R_attr_quickContactBadgeStyleSmallWindowSmall=: 16843441
R_attr_quickContactBadgeStyleWindowLarge=: 16843440
R_attr_quickContactBadgeStyleWindowMedium=: 16843439
R_attr_quickContactBadgeStyleWindowSmall=: 16843438
R_attr_radioButtonStyle=: 16842878
R_attr_radius=: 16843176
R_attr_rating=: 16843077
R_attr_ratingBarStyle=: 16842876
R_attr_ratingBarStyleIndicator=: 16843280
R_attr_ratingBarStyleSmall=: 16842877
R_attr_readPermission=: 16842759
R_attr_repeatCount=: 16843199
R_attr_repeatMode=: 16843200
R_attr_reqFiveWayNav=: 16843314
R_attr_reqHardKeyboard=: 16843305
R_attr_reqKeyboardType=: 16843304
R_attr_reqNavigation=: 16843306
R_attr_reqTouchScreen=: 16843303
R_attr_required=: 16843406
R_attr_requiresFadingEdge=: 16843685
R_attr_requiresSmallestWidthDp=: 16843620
R_attr_resizeMode=: 16843619
R_attr_resizeable=: 16843405
R_attr_resource=: 16842789
R_attr_restoreAnyVersion=: 16843450
R_attr_restoreNeedsApplication=: 16843421
R_attr_right=: 16843183
R_attr_ringtonePreferenceStyle=: 16842899
R_attr_ringtoneType=: 16843257
R_attr_rotation=: 16843558
R_attr_rotationX=: 16843559
R_attr_rotationY=: 16843560
R_attr_rowCount=: 16843637
R_attr_rowDelay=: 16843216
R_attr_rowEdgeFlags=: 16843329
R_attr_rowHeight=: 16843058
R_attr_rowOrderPreserved=: 16843638
R_attr_saveEnabled=: 16842983
R_attr_scaleGravity=: 16843262
R_attr_scaleHeight=: 16843261
R_attr_scaleType=: 16843037
R_attr_scaleWidth=: 16843260
R_attr_scaleX=: 16843556
R_attr_scaleY=: 16843557
R_attr_scheme=: 16842791
R_attr_screenDensity=: 16843467
R_attr_screenOrientation=: 16842782
R_attr_screenSize=: 16843466
R_attr_scrollHorizontally=: 16843099
R_attr_scrollViewStyle=: 16842880
R_attr_scrollX=: 16842962
R_attr_scrollY=: 16842963
R_attr_scrollbarAlwaysDrawHorizontalTrack=: 16842856
R_attr_scrollbarAlwaysDrawVerticalTrack=: 16842857
R_attr_scrollbarDefaultDelayBeforeFade=: 16843433
R_attr_scrollbarFadeDuration=: 16843432
R_attr_scrollbarSize=: 16842851
R_attr_scrollbarStyle=: 16842879
R_attr_scrollbarThumbHorizontal=: 16842852
R_attr_scrollbarThumbVertical=: 16842853
R_attr_scrollbarTrackHorizontal=: 16842854
R_attr_scrollbarTrackVertical=: 16842855
R_attr_scrollbars=: 16842974
R_attr_scrollingCache=: 16843006
R_attr_searchButtonText=: 16843269
R_attr_searchMode=: 16843221
R_attr_searchSettingsDescription=: 16843402
R_attr_searchSuggestAuthority=: 16843222
R_attr_searchSuggestIntentAction=: 16843225
R_attr_searchSuggestIntentData=: 16843226
R_attr_searchSuggestPath=: 16843223
R_attr_searchSuggestSelection=: 16843224
R_attr_searchSuggestThreshold=: 16843373
R_attr_secondaryProgress=: 16843064
R_attr_seekBarStyle=: 16842875
R_attr_segmentedButtonStyle=: 16843568
R_attr_selectAllOnFocus=: 16843102
R_attr_selectable=: 16843238
R_attr_selectableItemBackground=: 16843534
R_attr_selectedDateVerticalBar=: 16843591
R_attr_selectedWeekBackgroundColor=: 16843586
R_attr_settingsActivity=: 16843301
R_attr_shadowColor=: 16843105
R_attr_shadowDx=: 16843106
R_attr_shadowDy=: 16843107
R_attr_shadowRadius=: 16843108
R_attr_shape=: 16843162
R_attr_shareInterpolator=: 16843195
R_attr_sharedUserId=: 16842763
R_attr_sharedUserLabel=: 16843361
R_attr_shouldDisableView=: 16843246
R_attr_showAsAction=: 16843481
R_attr_showDefault=: 16843258
R_attr_showDividers=: 16843561
R_attr_showSilent=: 16843259
R_attr_showWeekNumber=: 16843582
R_attr_shownWeekCount=: 16843585
R_attr_shrinkColumns=: 16843082
R_attr_singleLine=: 16843101
R_attr_smallIcon=: 16843422
R_attr_smallScreens=: 16843396
R_attr_smoothScrollbar=: 16843313
R_attr_soundEffectsEnabled=: 16843285
R_attr_spacing=: 16843027
R_attr_spinnerDropDownItemStyle=: 16842887
R_attr_spinnerItemStyle=: 16842889
R_attr_spinnerMode=: 16843505
R_attr_spinnerStyle=: 16842881
R_attr_spinnersShown=: 16843595
R_attr_splitMotionEvents=: 16843503
R_attr_src=: 16843033
R_attr_stackFromBottom=: 16843005
R_attr_starStyle=: 16842882
R_attr_startColor=: 16843165
R_attr_startOffset=: 16843198
R_attr_startYear=: 16843132
R_attr_stateNotNeeded=: 16842774
R_attr_state_above_anchor=: 16842922
R_attr_state_accelerated=: 16843547
R_attr_state_activated=: 16843518
R_attr_state_active=: 16842914
R_attr_state_checkable=: 16842911
R_attr_state_checked=: 16842912
R_attr_state_drag_can_accept=: 16843624
R_attr_state_drag_hovered=: 16843625
R_attr_state_empty=: 16842921
R_attr_state_enabled=: 16842910
R_attr_state_expanded=: 16842920
R_attr_state_first=: 16842916
R_attr_state_focused=: 16842908
R_attr_state_hovered=: 16843623
R_attr_state_last=: 16842918
R_attr_state_long_pressable=: 16843324
R_attr_state_middle=: 16842917
R_attr_state_multiline=: 16843597
R_attr_state_pressed=: 16842919
R_attr_state_selected=: 16842913
R_attr_state_single=: 16842915
R_attr_state_window_focused=: 16842909
R_attr_staticWallpaperPreview=: 16843569
R_attr_stepSize=: 16843078
R_attr_stopWithTask=: 16843626
R_attr_streamType=: 16843273
R_attr_stretchColumns=: 16843081
R_attr_stretchMode=: 16843030
R_attr_subtitle=: 16843473
R_attr_subtitleTextStyle=: 16843513
R_attr_subtypeExtraValue=: 16843674
R_attr_subtypeLocale=: 16843673
R_attr_suggestActionMsg=: 16843228
R_attr_suggestActionMsgColumn=: 16843229
R_attr_summary=: 16843241
R_attr_summaryColumn=: 16843426
R_attr_summaryOff=: 16843248
R_attr_summaryOn=: 16843247
R_attr_supportsUploading=: 16843419
R_attr_switchMinWidth=: 16843632
R_attr_switchPadding=: 16843633
R_attr_switchPreferenceStyle=: 16843629
R_attr_switchTextAppearance=: 16843630
R_attr_switchTextOff=: 16843628
R_attr_switchTextOn=: 16843627
R_attr_syncable=: 16842777
R_attr_tabStripEnabled=: 16843453
R_attr_tabStripLeft=: 16843451
R_attr_tabStripRight=: 16843452
R_attr_tabWidgetStyle=: 16842883
R_attr_tag=: 16842961
R_attr_targetActivity=: 16843266
R_attr_targetClass=: 16842799
R_attr_targetDescriptions=: 16843680
R_attr_targetPackage=: 16842785
R_attr_targetSdkVersion=: 16843376
R_attr_taskAffinity=: 16842770
R_attr_taskCloseEnterAnimation=: 16842942
R_attr_taskCloseExitAnimation=: 16842943
R_attr_taskOpenEnterAnimation=: 16842940
R_attr_taskOpenExitAnimation=: 16842941
R_attr_taskToBackEnterAnimation=: 16842946
R_attr_taskToBackExitAnimation=: 16842947
R_attr_taskToFrontEnterAnimation=: 16842944
R_attr_taskToFrontExitAnimation=: 16842945
R_attr_tension=: 16843370
R_attr_testOnly=: 16843378
R_attr_text=: 16843087
R_attr_textAllCaps=: 16843660
R_attr_textAppearance=: 16842804
R_attr_textAppearanceButton=: 16843271
R_attr_textAppearanceInverse=: 16842805
R_attr_textAppearanceLarge=: 16842816
R_attr_textAppearanceLargeInverse=: 16842819
R_attr_textAppearanceLargePopupMenu=: 16843521
R_attr_textAppearanceListItem=: 16843678
R_attr_textAppearanceListItemSmall=: 16843679
R_attr_textAppearanceMedium=: 16842817
R_attr_textAppearanceMediumInverse=: 16842820
R_attr_textAppearanceSearchResultSubtitle=: 16843424
R_attr_textAppearanceSearchResultTitle=: 16843425
R_attr_textAppearanceSmall=: 16842818
R_attr_textAppearanceSmallInverse=: 16842821
R_attr_textAppearanceSmallPopupMenu=: 16843522
R_attr_textCheckMark=: 16842822
R_attr_textCheckMarkInverse=: 16842823
R_attr_textColor=: 16842904
R_attr_textColorAlertDialogListItem=: 16843526
R_attr_textColorHighlight=: 16842905
R_attr_textColorHighlightInverse=: 16843599
R_attr_textColorHint=: 16842906
R_attr_textColorHintInverse=: 16842815
R_attr_textColorLink=: 16842907
R_attr_textColorLinkInverse=: 16843600
R_attr_textColorPrimary=: 16842806
R_attr_textColorPrimaryDisableOnly=: 16842807
R_attr_textColorPrimaryInverse=: 16842809
R_attr_textColorPrimaryInverseDisableOnly=: 16843403
R_attr_textColorPrimaryInverseNoDisable=: 16842813
R_attr_textColorPrimaryNoDisable=: 16842811
R_attr_textColorSecondary=: 16842808
R_attr_textColorSecondaryInverse=: 16842810
R_attr_textColorSecondaryInverseNoDisable=: 16842814
R_attr_textColorSecondaryNoDisable=: 16842812
R_attr_textColorTertiary=: 16843282
R_attr_textColorTertiaryInverse=: 16843283
R_attr_textCursorDrawable=: 16843618
R_attr_textEditNoPasteWindowLayout=: 16843541
R_attr_textEditPasteWindowLayout=: 16843540
R_attr_textEditSideNoPasteWindowLayout=: 16843615
R_attr_textEditSidePasteWindowLayout=: 16843614
R_attr_textEditSuggestionItemLayout=: 16843636
R_attr_textFilterEnabled=: 16843007
R_attr_textIsSelectable=: 16843542
R_attr_textOff=: 16843045
R_attr_textOn=: 16843044
R_attr_textScaleX=: 16843089
R_attr_textSelectHandle=: 16843463
R_attr_textSelectHandleLeft=: 16843461
R_attr_textSelectHandleRight=: 16843462
R_attr_textSelectHandleWindowStyle=: 16843464
R_attr_textSize=: 16842901
R_attr_textStyle=: 16842903
R_attr_textSuggestionsWindowStyle=: 16843635
R_attr_textViewStyle=: 16842884
R_attr_theme=: 16842752
R_attr_thickness=: 16843360
R_attr_thicknessRatio=: 16843164
R_attr_thumb=: 16843074
R_attr_thumbOffset=: 16843075
R_attr_thumbTextPadding=: 16843634
R_attr_thumbnail=: 16843429
R_attr_tileMode=: 16843265
R_attr_tint=: 16843041
R_attr_title=: 16843233
R_attr_titleCondensed=: 16843234
R_attr_titleTextStyle=: 16843512
R_attr_toAlpha=: 16843211
R_attr_toDegrees=: 16843188
R_attr_toXDelta=: 16843207
R_attr_toXScale=: 16843203
R_attr_toYDelta=: 16843209
R_attr_toYScale=: 16843205
R_attr_top=: 16843182
R_attr_topBright=: 16842955
R_attr_topDark=: 16842951
R_attr_topLeftRadius=: 16843177
R_attr_topOffset=: 16843352
R_attr_topRightRadius=: 16843178
R_attr_track=: 16843631
R_attr_transcriptMode=: 16843008
R_attr_transformPivotX=: 16843552
R_attr_transformPivotY=: 16843553
R_attr_translationX=: 16843554
R_attr_translationY=: 16843555
R_attr_type=: 16843169
R_attr_typeface=: 16842902
R_attr_uiOptions=: 16843672
R_attr_uncertainGestureColor=: 16843382
R_attr_unfocusedMonthDateColor=: 16843588
R_attr_unselectedAlpha=: 16843278
R_attr_updatePeriodMillis=: 16843344
R_attr_useDefaultMargins=: 16843641
R_attr_useIntrinsicSizeAsMinimum=: 16843536
R_attr_useLevel=: 16843167
R_attr_userVisible=: 16843409
R_attr_value=: 16842788
R_attr_valueFrom=: 16843486
R_attr_valueTo=: 16843487
R_attr_valueType=: 16843488
R_attr_variablePadding=: 16843157
R_attr_versionCode=: 16843291
R_attr_versionName=: 16843292
R_attr_verticalCorrection=: 16843322
R_attr_verticalDivider=: 16843054
R_attr_verticalGap=: 16843328
R_attr_verticalScrollbarPosition=: 16843572
R_attr_verticalSpacing=: 16843029
R_attr_visibility=: 16842972
R_attr_visible=: 16843156
R_attr_vmSafeMode=: 16843448
R_attr_voiceLanguage=: 16843349
R_attr_voiceLanguageModel=: 16843347
R_attr_voiceMaxResults=: 16843350
R_attr_voicePromptText=: 16843348
R_attr_voiceSearchMode=: 16843346
R_attr_wallpaperCloseEnterAnimation=: 16843413
R_attr_wallpaperCloseExitAnimation=: 16843414
R_attr_wallpaperIntraCloseEnterAnimation=: 16843417
R_attr_wallpaperIntraCloseExitAnimation=: 16843418
R_attr_wallpaperIntraOpenEnterAnimation=: 16843415
R_attr_wallpaperIntraOpenExitAnimation=: 16843416
R_attr_wallpaperOpenEnterAnimation=: 16843411
R_attr_wallpaperOpenExitAnimation=: 16843412
R_attr_webTextViewStyle=: 16843449
R_attr_webViewStyle=: 16842885
R_attr_weekDayTextAppearance=: 16843592
R_attr_weekNumberColor=: 16843589
R_attr_weekSeparatorLineColor=: 16843590
R_attr_weightSum=: 16843048
R_attr_widgetLayout=: 16843243
R_attr_width=: 16843097
R_attr_windowActionBar=: 16843469
R_attr_windowActionBarOverlay=: 16843492
R_attr_windowActionModeOverlay=: 16843485
R_attr_windowAnimationStyle=: 16842926
R_attr_windowBackground=: 16842836
R_attr_windowCloseOnTouchOutside=: 16843611
R_attr_windowContentOverlay=: 16842841
R_attr_windowDisablePreview=: 16843298
R_attr_windowEnableSplitTouch=: 16843543
R_attr_windowEnterAnimation=: 16842932
R_attr_windowExitAnimation=: 16842933
R_attr_windowFrame=: 16842837
R_attr_windowFullscreen=: 16843277
R_attr_windowHideAnimation=: 16842935
R_attr_windowIsFloating=: 16842839
R_attr_windowIsTranslucent=: 16842840
R_attr_windowMinWidthMajor=: 16843606
R_attr_windowMinWidthMinor=: 16843607
R_attr_windowNoDisplay=: 16843294
R_attr_windowNoTitle=: 16842838
R_attr_windowShowAnimation=: 16842934
R_attr_windowShowWallpaper=: 16843410
R_attr_windowSoftInputMode=: 16843307
R_attr_windowTitleBackgroundStyle=: 16842844
R_attr_windowTitleSize=: 16842842
R_attr_windowTitleStyle=: 16842843
R_attr_writePermission=: 16842760
R_attr_x=: 16842924
R_attr_xlargeScreens=: 16843455
R_attr_y=: 16842925
R_attr_yesNoPreferenceStyle=: 16842896
R_attr_zAdjustment=: 16843201

R_color_background_dark=: 17170446
R_color_background_light=: 17170447
R_color_black=: 17170444
R_color_darker_gray=: 17170432
R_color_holo_blue_bright=: 17170459
R_color_holo_blue_dark=: 17170451
R_color_holo_blue_light=: 17170450
R_color_holo_green_dark=: 17170453
R_color_holo_green_light=: 17170452
R_color_holo_orange_dark=: 17170457
R_color_holo_orange_light=: 17170456
R_color_holo_purple=: 17170458
R_color_holo_red_dark=: 17170455
R_color_holo_red_light=: 17170454
R_color_primary_text_dark=: 17170433
R_color_primary_text_dark_nodisable=: 17170434
R_color_primary_text_light=: 17170435
R_color_primary_text_light_nodisable=: 17170436
R_color_secondary_text_dark=: 17170437
R_color_secondary_text_dark_nodisable=: 17170438
R_color_secondary_text_light=: 17170439
R_color_secondary_text_light_nodisable=: 17170440
R_color_tab_indicator_text=: 17170441
R_color_tertiary_text_dark=: 17170448
R_color_tertiary_text_light=: 17170449
R_color_transparent=: 17170445
R_color_white=: 17170443
R_color_widget_edittext_dark=: 17170442

R_dimenapp_icon_size=: 17104896
R_dimendialog_min_width_major=: 17104899
R_dimendialog_min_width_minor=: 17104900
R_dimennotification_large_icon_height=: 17104902
R_dimennotification_large_icon_width=: 17104901
R_dimenthumbnail_height=: 17104897
R_dimenthumbnail_width=: 17104898

R_drawable_alert_dark_frame=: 17301504
R_drawable_alert_light_frame=: 17301505
R_drawable_arrow_down_float=: 17301506
R_drawable_arrow_up_float=: 17301507
R_drawable_bottom_bar=: 17301658
R_drawable_btn_default=: 17301508
R_drawable_btn_default_small=: 17301509
R_drawable_btn_dialog=: 17301527
R_drawable_btn_dropdown=: 17301510
R_drawable_btn_minus=: 17301511
R_drawable_btn_plus=: 17301512
R_drawable_btn_radio=: 17301513
R_drawable_btn_star=: 17301514
R_drawable_btn_star_big_off=: 17301515
R_drawable_btn_star_big_on=: 17301516
R_drawable_button_onoff_indicator_off=: 17301518
R_drawable_button_onoff_indicator_on=: 17301517
R_drawable_checkbox_off_background=: 17301519
R_drawable_checkbox_on_background=: 17301520
R_drawable_dark_header=: 17301669
R_drawable_dialog_frame=: 17301521
R_drawable_dialog_holo_dark_frame=: 17301682
R_drawable_dialog_holo_light_frame=: 17301683
R_drawable_divider_horizontal_bright=: 17301522
R_drawable_divider_horizontal_dark=: 17301524
R_drawable_divider_horizontal_dim_dark=: 17301525
R_drawable_divider_horizontal_textfield=: 17301523
R_drawable_edit_text=: 17301526
R_drawable_editbox_background=: 17301528
R_drawable_editbox_background_normal=: 17301529
R_drawable_editbox_dropdown_dark_frame=: 17301530
R_drawable_editbox_dropdown_light_frame=: 17301531
R_drawable_gallery_thumb=: 17301532
R_drawable_ic_btn_speak_now=: 17301668
R_drawable_ic_delete=: 17301533
R_drawable_ic_dialog_alert=: 17301543
R_drawable_ic_dialog_dialer=: 17301544
R_drawable_ic_dialog_email=: 17301545
R_drawable_ic_dialog_info=: 17301659
R_drawable_ic_dialog_map=: 17301546
R_drawable_ic_input_add=: 17301547
R_drawable_ic_input_delete=: 17301548
R_drawable_ic_input_get=: 17301549
R_drawable_ic_lock_idle_alarm=: 17301550
R_drawable_ic_lock_idle_charging=: 17301534
R_drawable_ic_lock_idle_lock=: 17301535
R_drawable_ic_lock_idle_low_battery=: 17301536
R_drawable_ic_lock_lock=: 17301551
R_drawable_ic_lock_power_off=: 17301552
R_drawable_ic_lock_silent_mode=: 17301553
R_drawable_ic_lock_silent_mode_off=: 17301554
R_drawable_ic_media_ff=: 17301537
R_drawable_ic_media_next=: 17301538
R_drawable_ic_media_pause=: 17301539
R_drawable_ic_media_play=: 17301540
R_drawable_ic_media_previous=: 17301541
R_drawable_ic_media_rew=: 17301542
R_drawable_ic_menu_add=: 17301555
R_drawable_ic_menu_agenda=: 17301556
R_drawable_ic_menu_always_landscape_portrait=: 17301557
R_drawable_ic_menu_call=: 17301558
R_drawable_ic_menu_camera=: 17301559
R_drawable_ic_menu_close_clear_cancel=: 17301560
R_drawable_ic_menu_compass=: 17301561
R_drawable_ic_menu_crop=: 17301562
R_drawable_ic_menu_day=: 17301563
R_drawable_ic_menu_delete=: 17301564
R_drawable_ic_menu_directions=: 17301565
R_drawable_ic_menu_edit=: 17301566
R_drawable_ic_menu_gallery=: 17301567
R_drawable_ic_menu_help=: 17301568
R_drawable_ic_menu_info_details=: 17301569
R_drawable_ic_menu_manage=: 17301570
R_drawable_ic_menu_mapmode=: 17301571
R_drawable_ic_menu_month=: 17301572
R_drawable_ic_menu_more=: 17301573
R_drawable_ic_menu_my_calendar=: 17301574
R_drawable_ic_menu_mylocation=: 17301575
R_drawable_ic_menu_myplaces=: 17301576
R_drawable_ic_menu_preferences=: 17301577
R_drawable_ic_menu_recent_history=: 17301578
R_drawable_ic_menu_report_image=: 17301579
R_drawable_ic_menu_revert=: 17301580
R_drawable_ic_menu_rotate=: 17301581
R_drawable_ic_menu_save=: 17301582
R_drawable_ic_menu_search=: 17301583
R_drawable_ic_menu_send=: 17301584
R_drawable_ic_menu_set_as=: 17301585
R_drawable_ic_menu_share=: 17301586
R_drawable_ic_menu_slideshow=: 17301587
R_drawable_ic_menu_sort_alphabetically=: 17301660
R_drawable_ic_menu_sort_by_size=: 17301661
R_drawable_ic_menu_today=: 17301588
R_drawable_ic_menu_upload=: 17301589
R_drawable_ic_menu_upload_you_tube=: 17301590
R_drawable_ic_menu_view=: 17301591
R_drawable_ic_menu_week=: 17301592
R_drawable_ic_menu_zoom=: 17301593
R_drawable_ic_notification_clear_all=: 17301594
R_drawable_ic_notification_overlay=: 17301595
R_drawable_ic_partial_secure=: 17301596
R_drawable_ic_popup_disk_full=: 17301597
R_drawable_ic_popup_reminder=: 17301598
R_drawable_ic_popup_sync=: 17301599
R_drawable_ic_search_category_default=: 17301600
R_drawable_ic_secure=: 17301601
R_drawable_list_selector_background=: 17301602
R_drawable_menu_frame=: 17301603
R_drawable_menu_full_frame=: 17301604
R_drawable_menuitem_background=: 17301605
R_drawable_picture_frame=: 17301606
R_drawable_presence_audio_away=: 17301679
R_drawable_presence_audio_busy=: 17301680
R_drawable_presence_audio_online=: 17301681
R_drawable_presence_away=: 17301607
R_drawable_presence_busy=: 17301608
R_drawable_presence_invisible=: 17301609
R_drawable_presence_offline=: 17301610
R_drawable_presence_online=: 17301611
R_drawable_presence_video_away=: 17301676
R_drawable_presence_video_busy=: 17301677
R_drawable_presence_video_online=: 17301678
R_drawable_progress_horizontal=: 17301612
R_drawable_progress_indeterminate_horizontal=: 17301613
R_drawable_radiobutton_off_background=: 17301614
R_drawable_radiobutton_on_background=: 17301615
R_drawable_screen_background_dark=: 17301656
R_drawable_screen_background_dark_transparent=: 17301673
R_drawable_screen_background_light=: 17301657
R_drawable_screen_background_light_transparent=: 17301674
R_drawable_spinner_background=: 17301616
R_drawable_spinner_dropdown_background=: 17301617
R_drawable_star_big_off=: 17301619
R_drawable_star_big_on=: 17301618
R_drawable_star_off=: 17301621
R_drawable_star_on=: 17301620
R_drawable_stat_notify_call_mute=: 17301622
R_drawable_stat_notify_chat=: 17301623
R_drawable_stat_notify_error=: 17301624
R_drawable_stat_notify_missed_call=: 17301631
R_drawable_stat_notify_more=: 17301625
R_drawable_stat_notify_sdcard=: 17301626
R_drawable_stat_notify_sdcard_prepare=: 17301675
R_drawable_stat_notify_sdcard_usb=: 17301627
R_drawable_stat_notify_sync=: 17301628
R_drawable_stat_notify_sync_noanim=: 17301629
R_drawable_stat_notify_voicemail=: 17301630
R_drawable_stat_sys_data_bluetooth=: 17301632
R_drawable_stat_sys_download=: 17301633
R_drawable_stat_sys_download_done=: 17301634
R_drawable_stat_sys_headset=: 17301635
R_drawable_stat_sys_phone_call=: 17301636
R_drawable_stat_sys_phone_call_forward=: 17301637
R_drawable_stat_sys_phone_call_on_hold=: 17301638
R_drawable_stat_sys_speakerphone=: 17301639
R_drawable_stat_sys_upload=: 17301640
R_drawable_stat_sys_upload_done=: 17301641
R_drawable_stat_sys_vp_phone_call=: 17301671
R_drawable_stat_sys_vp_phone_call_on_hold=: 17301672
R_drawable_stat_sys_warning=: 17301642
R_drawable_status_bar_item_app_background=: 17301643
R_drawable_status_bar_item_background=: 17301644
R_drawable_sym_action_call=: 17301645
R_drawable_sym_action_chat=: 17301646
R_drawable_sym_action_email=: 17301647
R_drawable_sym_call_incoming=: 17301648
R_drawable_sym_call_missed=: 17301649
R_drawable_sym_call_outgoing=: 17301650
R_drawable_sym_contact_card=: 17301652
R_drawable_sym_def_app_icon=: 17301651
R_drawable_title_bar=: 17301653
R_drawable_title_bar_tall=: 17301670
R_drawable_toast_frame=: 17301654
R_drawable_zoom_plate=: 17301655

R_id_addToDictionary=: 16908330
R_id_background=: 16908288
R_id_button1=: 16908313
R_id_button2=: 16908314
R_id_button3=: 16908315
R_id_candidatesArea=: 16908317
R_id_checkbox=: 16908289
R_id_closeButton=: 16908327
R_id_content=: 16908290
R_id_copy=: 16908321
R_id_copyUrl=: 16908323
R_id_custom=: 16908331
R_id_cut=: 16908320
R_id_edit=: 16908291
R_id_empty=: 16908292
R_id_extractArea=: 16908316
R_id_hint=: 16908293
R_id_home=: 16908332
R_id_icon=: 16908294
R_id_icon1=: 16908295
R_id_icon2=: 16908296
R_id_input=: 16908297
R_id_inputArea=: 16908318
R_id_inputExtractEditText=: 16908325
R_id_keyboardView=: 16908326
R_id_list=: 16908298
R_id_message=: 16908299
R_id_paste=: 16908322
R_id_primary=: 16908300
R_id_progress=: 16908301
R_id_secondaryProgress=: 16908303
R_id_selectAll=: 16908319
R_id_selectTextMode=: 16908333
R_id_selectedIcon=: 16908302
R_id_startSelectingText=: 16908328
R_id_stopSelectingText=: 16908329
R_id_summary=: 16908304
R_id_switchInputMethod=: 16908324
R_id_tabcontent=: 16908305
R_id_tabhost=: 16908306
R_id_tabs=: 16908307
R_id_text1=: 16908308
R_id_text2=: 16908309
R_id_title=: 16908310
R_id_toggle=: 16908311
R_id_widget_frame=: 16908312

R_integerconfig_longAnimTime=: 17694722
R_integerconfig_mediumAnimTime=: 17694721
R_integerconfig_shortAnimTime=: 17694720
R_integerstatus_bar_notification_info_maxnum=: 17694723

R_interpolatoraccelerate_cubic=: 17563650
R_interpolatoraccelerate_decelerate=: 17563654
R_interpolatoraccelerate_quad=: 17563648
R_interpolatoraccelerate_quint=: 17563652
R_interpolatoranticipate=: 17563655
R_interpolatoranticipate_overshoot=: 17563657
R_interpolatorbounce=: 17563658
R_interpolatorcycle=: 17563660
R_interpolatordecelerate_cubic=: 17563651
R_interpolatordecelerate_quad=: 17563649
R_interpolatordecelerate_quint=: 17563653
R_interpolatorlinear=: 17563659
R_interpolatorovershoot=: 17563656

R_layout_activity_list_item=: 17367040
R_layout_browser_link_context_header=: 17367054
R_layout_expandable_list_content=: 17367041
R_layout_list_content=: 17367060
R_layout_preference_category=: 17367042
R_layout_select_dialog_item=: 17367057
R_layout_select_dialog_multichoice=: 17367059
R_layout_select_dialog_singlechoice=: 17367058
R_layout_simple_dropdown_item_1line=: 17367050
R_layout_simple_expandable_list_item_1=: 17367046
R_layout_simple_expandable_list_item_2=: 17367047
R_layout_simple_gallery_item=: 17367051
R_layout_simple_list_item_1=: 17367043
R_layout_simple_list_item_2=: 17367044
R_layout_simple_list_item_activated_1=: 17367062
R_layout_simple_list_item_activated_2=: 17367063
R_layout_simple_list_item_checked=: 17367045
R_layout_simple_list_item_multiple_choice=: 17367056
R_layout_simple_list_item_single_choice=: 17367055
R_layout_simple_selectable_list_item=: 17367061
R_layout_simple_spinner_dropdown_item=: 17367049
R_layout_simple_spinner_item=: 17367048
R_layout_test_list_item=: 17367052
R_layout_two_line_list_item=: 17367053

R_mipmap_sym_def_app_icon=: 17629184

R_string_VideoView_error_button=: 17039376
R_string_VideoView_error_text_invalid_progressive_playback=: 17039381
R_string_VideoView_error_text_unknown=: 17039377
R_string_VideoView_error_title=: 17039378
R_string_cancel=: 17039360
R_string_copy=: 17039361
R_string_copyUrl=: 17039362
R_string_cut=: 17039363
R_string_defaultMsisdnAlphaTag=: 17039365
R_string_defaultVoiceMailAlphaTag=: 17039364
R_string_dialog_alert_title=: 17039380
R_string_emptyPhoneNumber=: 17039366
R_string_httpErrorBadUrl=: 17039367
R_string_httpErrorUnsupportedScheme=: 17039368
R_string_no=: 17039369
R_string_ok=: 17039370
R_string_paste=: 17039371
R_string_search_go=: 17039372
R_string_selectAll=: 17039373
R_string_selectTextMode=: 17039382
R_string_status_bar_notification_info_overflow=: 17039383
R_string_unknownName=: 17039374
R_string_untitled=: 17039375
R_string_yes=: 17039379

R_style_Animation=: 16973824
R_style_Animation_Activity=: 16973825
R_style_Animation_Dialog=: 16973826
R_style_Animation_InputMethod=: 16973910
R_style_Animation_Toast=: 16973828
R_style_Animation_Translucent=: 16973827
R_style_DeviceDefault_ButtonBar=: 16974287
R_style_DeviceDefault_ButtonBar_AlertDialog=: 16974288
R_style_DeviceDefault_Light_ButtonBar=: 16974290
R_style_DeviceDefault_Light_ButtonBar_AlertDialog=: 16974291
R_style_DeviceDefault_Light_SegmentedButton=: 16974292
R_style_DeviceDefault_SegmentedButton=: 16974289
R_style_Holo_ButtonBar=: 16974053
R_style_Holo_ButtonBar_AlertDialog=: 16974055
R_style_Holo_Light_ButtonBar=: 16974054
R_style_Holo_Light_ButtonBar_AlertDialog=: 16974056
R_style_Holo_Light_SegmentedButton=: 16974058
R_style_Holo_SegmentedButton=: 16974057
R_style_MediaButton=: 16973879
R_style_MediaButton_Ffwd=: 16973883
R_style_MediaButton_Next=: 16973881
R_style_MediaButton_Pause=: 16973885
R_style_MediaButton_Play=: 16973882
R_style_MediaButton_Previous=: 16973880
R_style_MediaButton_Rew=: 16973884
R_style_TextAppearance=: 16973886
R_style_TextAppearance_DeviceDefault=: 16974253
R_style_TextAppearance_DeviceDefault_DialogWindowTitle=: 16974264
R_style_TextAppearance_DeviceDefault_Inverse=: 16974254
R_style_TextAppearance_DeviceDefault_Large=: 16974255
R_style_TextAppearance_DeviceDefault_Large_Inverse=: 16974256
R_style_TextAppearance_DeviceDefault_Medium=: 16974257
R_style_TextAppearance_DeviceDefault_Medium_Inverse=: 16974258
R_style_TextAppearance_DeviceDefault_SearchResult_Subtitle=: 16974262
R_style_TextAppearance_DeviceDefault_SearchResult_Title=: 16974261
R_style_TextAppearance_DeviceDefault_Small=: 16974259
R_style_TextAppearance_DeviceDefault_Small_Inverse=: 16974260
R_style_TextAppearance_DeviceDefault_Widget=: 16974265
R_style_TextAppearance_DeviceDefault_Widget_ActionBar_Menu=: 16974286
R_style_TextAppearance_DeviceDefault_Widget_ActionBar_Subtitle=: 16974279
R_style_TextAppearance_DeviceDefault_Widget_ActionBar_Subtitle_Inverse=: 16974283
R_style_TextAppearance_DeviceDefault_Widget_ActionBar_Title=: 16974278
R_style_TextAppearance_DeviceDefault_Widget_ActionBar_Title_Inverse=: 16974282
R_style_TextAppearance_DeviceDefault_Widget_ActionMode_Subtitle=: 16974281
R_style_TextAppearance_DeviceDefault_Widget_ActionMode_Subtitle_Inverse=: 16974285
R_style_TextAppearance_DeviceDefault_Widget_ActionMode_Title=: 16974280
R_style_TextAppearance_DeviceDefault_Widget_ActionMode_Title_Inverse=: 16974284
R_style_TextAppearance_DeviceDefault_Widget_Button=: 16974266
R_style_TextAppearance_DeviceDefault_Widget_DropDownHint=: 16974271
R_style_TextAppearance_DeviceDefault_Widget_DropDownItem=: 16974272
R_style_TextAppearance_DeviceDefault_Widget_EditText=: 16974274
R_style_TextAppearance_DeviceDefault_Widget_IconMenu_Item=: 16974267
R_style_TextAppearance_DeviceDefault_Widget_PopupMenu=: 16974275
R_style_TextAppearance_DeviceDefault_Widget_PopupMenu_Large=: 16974276
R_style_TextAppearance_DeviceDefault_Widget_PopupMenu_Small=: 16974277
R_style_TextAppearance_DeviceDefault_Widget_TabWidget=: 16974268
R_style_TextAppearance_DeviceDefault_Widget_TextView=: 16974269
R_style_TextAppearance_DeviceDefault_Widget_TextView_PopupMenu=: 16974270
R_style_TextAppearance_DeviceDefault_Widget_TextView_SpinnerItem=: 16974273
R_style_TextAppearance_DeviceDefault_WindowTitle=: 16974263
R_style_TextAppearance_DialogWindowTitle=: 16973889
R_style_TextAppearance_Holo=: 16974075
R_style_TextAppearance_Holo_DialogWindowTitle=: 16974103
R_style_TextAppearance_Holo_Inverse=: 16974076
R_style_TextAppearance_Holo_Large=: 16974077
R_style_TextAppearance_Holo_Large_Inverse=: 16974078
R_style_TextAppearance_Holo_Medium=: 16974079
R_style_TextAppearance_Holo_Medium_Inverse=: 16974080
R_style_TextAppearance_Holo_SearchResult_Subtitle=: 16974084
R_style_TextAppearance_Holo_SearchResult_Title=: 16974083
R_style_TextAppearance_Holo_Small=: 16974081
R_style_TextAppearance_Holo_Small_Inverse=: 16974082
R_style_TextAppearance_Holo_Widget=: 16974085
R_style_TextAppearance_Holo_Widget_ActionBar_Menu=: 16974112
R_style_TextAppearance_Holo_Widget_ActionBar_Subtitle=: 16974099
R_style_TextAppearance_Holo_Widget_ActionBar_Subtitle_Inverse=: 16974109
R_style_TextAppearance_Holo_Widget_ActionBar_Title=: 16974098
R_style_TextAppearance_Holo_Widget_ActionBar_Title_Inverse=: 16974108
R_style_TextAppearance_Holo_Widget_ActionMode_Subtitle=: 16974101
R_style_TextAppearance_Holo_Widget_ActionMode_Subtitle_Inverse=: 16974111
R_style_TextAppearance_Holo_Widget_ActionMode_Title=: 16974100
R_style_TextAppearance_Holo_Widget_ActionMode_Title_Inverse=: 16974110
R_style_TextAppearance_Holo_Widget_Button=: 16974086
R_style_TextAppearance_Holo_Widget_DropDownHint=: 16974091
R_style_TextAppearance_Holo_Widget_DropDownItem=: 16974092
R_style_TextAppearance_Holo_Widget_EditText=: 16974094
R_style_TextAppearance_Holo_Widget_IconMenu_Item=: 16974087
R_style_TextAppearance_Holo_Widget_PopupMenu=: 16974095
R_style_TextAppearance_Holo_Widget_PopupMenu_Large=: 16974096
R_style_TextAppearance_Holo_Widget_PopupMenu_Small=: 16974097
R_style_TextAppearance_Holo_Widget_TabWidget=: 16974088
R_style_TextAppearance_Holo_Widget_TextView=: 16974089
R_style_TextAppearance_Holo_Widget_TextView_PopupMenu=: 16974090
R_style_TextAppearance_Holo_Widget_TextView_SpinnerItem=: 16974093
R_style_TextAppearance_Holo_WindowTitle=: 16974102
R_style_TextAppearance_Inverse=: 16973887
R_style_TextAppearance_Large=: 16973890
R_style_TextAppearance_Large_Inverse=: 16973891
R_style_TextAppearance_Medium=: 16973892
R_style_TextAppearance_Medium_Inverse=: 16973893
R_style_TextAppearance_Small=: 16973894
R_style_TextAppearance_Small_Inverse=: 16973895
R_style_TextAppearance_StatusBar_EventContent=: 16973927
R_style_TextAppearance_StatusBar_EventContent_Title=: 16973928
R_style_TextAppearance_StatusBar_Icon=: 16973926
R_style_TextAppearance_StatusBar_Title=: 16973925
R_style_TextAppearance_SuggestionHighlight=: 16974104
R_style_TextAppearance_Theme=: 16973888
R_style_TextAppearance_Theme_Dialog=: 16973896
R_style_TextAppearance_Widget=: 16973897
R_style_TextAppearance_Widget_Button=: 16973898
R_style_TextAppearance_Widget_DropDownHint=: 16973904
R_style_TextAppearance_Widget_DropDownItem=: 16973905
R_style_TextAppearance_Widget_EditText=: 16973900
R_style_TextAppearance_Widget_IconMenu_Item=: 16973899
R_style_TextAppearance_Widget_PopupMenu_Large=: 16973952
R_style_TextAppearance_Widget_PopupMenu_Small=: 16973953
R_style_TextAppearance_Widget_TabWidget=: 16973901
R_style_TextAppearance_Widget_TextView=: 16973902
R_style_TextAppearance_Widget_TextView_PopupMenu=: 16973903
R_style_TextAppearance_Widget_TextView_SpinnerItem=: 16973906
R_style_TextAppearance_WindowTitle=: 16973907
R_style_Theme=: 16973829
R_style_Theme_Black=: 16973832
R_style_Theme_Black_NoTitleBar=: 16973833
R_style_Theme_Black_NoTitleBar_Fullscreen=: 16973834
R_style_Theme_DeviceDefault=: 16974120
R_style_Theme_DeviceDefault_Dialog=: 16974126
R_style_Theme_DeviceDefault_DialogWhenLarge=: 16974134
R_style_Theme_DeviceDefault_DialogWhenLarge_NoActionBar=: 16974135
R_style_Theme_DeviceDefault_Dialog_MinWidth=: 16974127
R_style_Theme_DeviceDefault_Dialog_NoActionBar=: 16974128
R_style_Theme_DeviceDefault_Dialog_NoActionBar_MinWidth=: 16974129
R_style_Theme_DeviceDefault_InputMethod=: 16974142
R_style_Theme_DeviceDefault_Light=: 16974123
R_style_Theme_DeviceDefault_Light_DarkActionBar=: 16974143
R_style_Theme_DeviceDefault_Light_Dialog=: 16974130
R_style_Theme_DeviceDefault_Light_DialogWhenLarge=: 16974136
R_style_Theme_DeviceDefault_Light_DialogWhenLarge_NoActionBar=: 16974137
R_style_Theme_DeviceDefault_Light_Dialog_MinWidth=: 16974131
R_style_Theme_DeviceDefault_Light_Dialog_NoActionBar=: 16974132
R_style_Theme_DeviceDefault_Light_Dialog_NoActionBar_MinWidth=: 16974133
R_style_Theme_DeviceDefault_Light_NoActionBar=: 16974124
R_style_Theme_DeviceDefault_Light_NoActionBar_Fullscreen=: 16974125
R_style_Theme_DeviceDefault_Light_Panel=: 16974139
R_style_Theme_DeviceDefault_NoActionBar=: 16974121
R_style_Theme_DeviceDefault_NoActionBar_Fullscreen=: 16974122
R_style_Theme_DeviceDefault_Panel=: 16974138
R_style_Theme_DeviceDefault_Wallpaper=: 16974140
R_style_Theme_DeviceDefault_Wallpaper_NoTitleBar=: 16974141
R_style_Theme_Dialog=: 16973835
R_style_Theme_Holo=: 16973931
R_style_Theme_Holo_Dialog=: 16973935
R_style_Theme_Holo_DialogWhenLarge=: 16973943
R_style_Theme_Holo_DialogWhenLarge_NoActionBar=: 16973944
R_style_Theme_Holo_Dialog_MinWidth=: 16973936
R_style_Theme_Holo_Dialog_NoActionBar=: 16973937
R_style_Theme_Holo_Dialog_NoActionBar_MinWidth=: 16973938
R_style_Theme_Holo_InputMethod=: 16973951
R_style_Theme_Holo_Light=: 16973934
R_style_Theme_Holo_Light_DarkActionBar=: 16974105
R_style_Theme_Holo_Light_Dialog=: 16973939
R_style_Theme_Holo_Light_DialogWhenLarge=: 16973945
R_style_Theme_Holo_Light_DialogWhenLarge_NoActionBar=: 16973946
R_style_Theme_Holo_Light_Dialog_MinWidth=: 16973940
R_style_Theme_Holo_Light_Dialog_NoActionBar=: 16973941
R_style_Theme_Holo_Light_Dialog_NoActionBar_MinWidth=: 16973942
R_style_Theme_Holo_Light_NoActionBar=: 16974064
R_style_Theme_Holo_Light_NoActionBar_Fullscreen=: 16974065
R_style_Theme_Holo_Light_Panel=: 16973948
R_style_Theme_Holo_NoActionBar=: 16973932
R_style_Theme_Holo_NoActionBar_Fullscreen=: 16973933
R_style_Theme_Holo_Panel=: 16973947
R_style_Theme_Holo_Wallpaper=: 16973949
R_style_Theme_Holo_Wallpaper_NoTitleBar=: 16973950
R_style_Theme_InputMethod=: 16973908
R_style_Theme_Light=: 16973836
R_style_Theme_Light_NoTitleBar=: 16973837
R_style_Theme_Light_NoTitleBar_Fullscreen=: 16973838
R_style_Theme_Light_Panel=: 16973914
R_style_Theme_Light_WallpaperSettings=: 16973922
R_style_Theme_NoDisplay=: 16973909
R_style_Theme_NoTitleBar=: 16973830
R_style_Theme_NoTitleBar_Fullscreen=: 16973831
R_style_Theme_NoTitleBar_OverlayActionModes=: 16973930
R_style_Theme_Panel=: 16973913
R_style_Theme_Translucent=: 16973839
R_style_Theme_Translucent_NoTitleBar=: 16973840
R_style_Theme_Translucent_NoTitleBar_Fullscreen=: 16973841
R_style_Theme_Wallpaper=: 16973918
R_style_Theme_WallpaperSettings=: 16973921
R_style_Theme_Wallpaper_NoTitleBar=: 16973919
R_style_Theme_Wallpaper_NoTitleBar_Fullscreen=: 16973920
R_style_Theme_WithActionBar=: 16973929
R_style_Widget=: 16973842
R_style_Widget_AbsListView=: 16973843
R_style_Widget_ActionBar=: 16973954
R_style_Widget_ActionBar_TabBar=: 16974068
R_style_Widget_ActionBar_TabText=: 16974067
R_style_Widget_ActionBar_TabView=: 16974066
R_style_Widget_ActionButton=: 16973956
R_style_Widget_ActionButton_CloseMode=: 16973960
R_style_Widget_ActionButton_Overflow=: 16973959
R_style_Widget_AutoCompleteTextView=: 16973863
R_style_Widget_Button=: 16973844
R_style_Widget_Button_Inset=: 16973845
R_style_Widget_Button_Small=: 16973846
R_style_Widget_Button_Toggle=: 16973847
R_style_Widget_CalendarView=: 16974059
R_style_Widget_CompoundButton=: 16973848
R_style_Widget_CompoundButton_CheckBox=: 16973849
R_style_Widget_CompoundButton_RadioButton=: 16973850
R_style_Widget_CompoundButton_Star=: 16973851
R_style_Widget_DatePicker=: 16974062
R_style_Widget_DeviceDefault=: 16974144
R_style_Widget_DeviceDefault_ActionBar=: 16974187
R_style_Widget_DeviceDefault_ActionBar_Solid=: 16974195
R_style_Widget_DeviceDefault_ActionBar_TabBar=: 16974194
R_style_Widget_DeviceDefault_ActionBar_TabText=: 16974193
R_style_Widget_DeviceDefault_ActionBar_TabView=: 16974192
R_style_Widget_DeviceDefault_ActionButton=: 16974182
R_style_Widget_DeviceDefault_ActionButton_CloseMode=: 16974186
R_style_Widget_DeviceDefault_ActionButton_Overflow=: 16974183
R_style_Widget_DeviceDefault_ActionButton_TextButton=: 16974184
R_style_Widget_DeviceDefault_ActionMode=: 16974185
R_style_Widget_DeviceDefault_AutoCompleteTextView=: 16974151
R_style_Widget_DeviceDefault_Button=: 16974145
R_style_Widget_DeviceDefault_Button_Borderless=: 16974188
R_style_Widget_DeviceDefault_Button_Borderless_Small=: 16974149
R_style_Widget_DeviceDefault_Button_Inset=: 16974147
R_style_Widget_DeviceDefault_Button_Small=: 16974146
R_style_Widget_DeviceDefault_Button_Toggle=: 16974148
R_style_Widget_DeviceDefault_CalendarView=: 16974190
R_style_Widget_DeviceDefault_CompoundButton_CheckBox=: 16974152
R_style_Widget_DeviceDefault_CompoundButton_RadioButton=: 16974169
R_style_Widget_DeviceDefault_CompoundButton_Star=: 16974173
R_style_Widget_DeviceDefault_DatePicker=: 16974191
R_style_Widget_DeviceDefault_DropDownItem=: 16974177
R_style_Widget_DeviceDefault_DropDownItem_Spinner=: 16974178
R_style_Widget_DeviceDefault_EditText=: 16974154
R_style_Widget_DeviceDefault_ExpandableListView=: 16974155
R_style_Widget_DeviceDefault_GridView=: 16974156
R_style_Widget_DeviceDefault_HorizontalScrollView=: 16974171
R_style_Widget_DeviceDefault_ImageButton=: 16974157
R_style_Widget_DeviceDefault_Light=: 16974196
R_style_Widget_DeviceDefault_Light_ActionBar=: 16974243
R_style_Widget_DeviceDefault_Light_ActionBar_Solid=: 16974247
R_style_Widget_DeviceDefault_Light_ActionBar_Solid_Inverse=: 16974248
R_style_Widget_DeviceDefault_Light_ActionBar_TabBar=: 16974246
R_style_Widget_DeviceDefault_Light_ActionBar_TabBar_Inverse=: 16974249
R_style_Widget_DeviceDefault_Light_ActionBar_TabText=: 16974245
R_style_Widget_DeviceDefault_Light_ActionBar_TabText_Inverse=: 16974251
R_style_Widget_DeviceDefault_Light_ActionBar_TabView=: 16974244
R_style_Widget_DeviceDefault_Light_ActionBar_TabView_Inverse=: 16974250
R_style_Widget_DeviceDefault_Light_ActionButton=: 16974239
R_style_Widget_DeviceDefault_Light_ActionButton_CloseMode=: 16974242
R_style_Widget_DeviceDefault_Light_ActionButton_Overflow=: 16974240
R_style_Widget_DeviceDefault_Light_ActionMode=: 16974241
R_style_Widget_DeviceDefault_Light_ActionMode_Inverse=: 16974252
R_style_Widget_DeviceDefault_Light_AutoCompleteTextView=: 16974203
R_style_Widget_DeviceDefault_Light_Button=: 16974197
R_style_Widget_DeviceDefault_Light_Button_Borderless_Small=: 16974201
R_style_Widget_DeviceDefault_Light_Button_Inset=: 16974199
R_style_Widget_DeviceDefault_Light_Button_Small=: 16974198
R_style_Widget_DeviceDefault_Light_Button_Toggle=: 16974200
R_style_Widget_DeviceDefault_Light_CalendarView=: 16974238
R_style_Widget_DeviceDefault_Light_CompoundButton_CheckBox=: 16974204
R_style_Widget_DeviceDefault_Light_CompoundButton_RadioButton=: 16974224
R_style_Widget_DeviceDefault_Light_CompoundButton_Star=: 16974228
R_style_Widget_DeviceDefault_Light_DropDownItem=: 16974232
R_style_Widget_DeviceDefault_Light_DropDownItem_Spinner=: 16974233
R_style_Widget_DeviceDefault_Light_EditText=: 16974206
R_style_Widget_DeviceDefault_Light_ExpandableListView=: 16974207
R_style_Widget_DeviceDefault_Light_GridView=: 16974208
R_style_Widget_DeviceDefault_Light_HorizontalScrollView=: 16974226
R_style_Widget_DeviceDefault_Light_ImageButton=: 16974209
R_style_Widget_DeviceDefault_Light_ListPopupWindow=: 16974235
R_style_Widget_DeviceDefault_Light_ListView=: 16974210
R_style_Widget_DeviceDefault_Light_ListView_DropDown=: 16974205
R_style_Widget_DeviceDefault_Light_MediaRouteButton=: 16974296
R_style_Widget_DeviceDefault_Light_PopupMenu=: 16974236
R_style_Widget_DeviceDefault_Light_PopupWindow=: 16974211
R_style_Widget_DeviceDefault_Light_ProgressBar=: 16974212
R_style_Widget_DeviceDefault_Light_ProgressBar_Horizontal=: 16974213
R_style_Widget_DeviceDefault_Light_ProgressBar_Inverse=: 16974217
R_style_Widget_DeviceDefault_Light_ProgressBar_Large=: 16974216
R_style_Widget_DeviceDefault_Light_ProgressBar_Large_Inverse=: 16974219
R_style_Widget_DeviceDefault_Light_ProgressBar_Small=: 16974214
R_style_Widget_DeviceDefault_Light_ProgressBar_Small_Inverse=: 16974218
R_style_Widget_DeviceDefault_Light_ProgressBar_Small_Title=: 16974215
R_style_Widget_DeviceDefault_Light_RatingBar=: 16974221
R_style_Widget_DeviceDefault_Light_RatingBar_Indicator=: 16974222
R_style_Widget_DeviceDefault_Light_RatingBar_Small=: 16974223
R_style_Widget_DeviceDefault_Light_ScrollView=: 16974225
R_style_Widget_DeviceDefault_Light_SeekBar=: 16974220
R_style_Widget_DeviceDefault_Light_Spinner=: 16974227
R_style_Widget_DeviceDefault_Light_Tab=: 16974237
R_style_Widget_DeviceDefault_Light_TabWidget=: 16974229
R_style_Widget_DeviceDefault_Light_TextView=: 16974202
R_style_Widget_DeviceDefault_Light_TextView_SpinnerItem=: 16974234
R_style_Widget_DeviceDefault_Light_WebTextView=: 16974230
R_style_Widget_DeviceDefault_Light_WebView=: 16974231
R_style_Widget_DeviceDefault_ListPopupWindow=: 16974180
R_style_Widget_DeviceDefault_ListView=: 16974158
R_style_Widget_DeviceDefault_ListView_DropDown=: 16974153
R_style_Widget_DeviceDefault_MediaRouteButton=: 16974295
R_style_Widget_DeviceDefault_PopupMenu=: 16974181
R_style_Widget_DeviceDefault_PopupWindow=: 16974159
R_style_Widget_DeviceDefault_ProgressBar=: 16974160
R_style_Widget_DeviceDefault_ProgressBar_Horizontal=: 16974161
R_style_Widget_DeviceDefault_ProgressBar_Large=: 16974164
R_style_Widget_DeviceDefault_ProgressBar_Small=: 16974162
R_style_Widget_DeviceDefault_ProgressBar_Small_Title=: 16974163
R_style_Widget_DeviceDefault_RatingBar=: 16974166
R_style_Widget_DeviceDefault_RatingBar_Indicator=: 16974167
R_style_Widget_DeviceDefault_RatingBar_Small=: 16974168
R_style_Widget_DeviceDefault_ScrollView=: 16974170
R_style_Widget_DeviceDefault_SeekBar=: 16974165
R_style_Widget_DeviceDefault_Spinner=: 16974172
R_style_Widget_DeviceDefault_Tab=: 16974189
R_style_Widget_DeviceDefault_TabWidget=: 16974174
R_style_Widget_DeviceDefault_TextView=: 16974150
R_style_Widget_DeviceDefault_TextView_SpinnerItem=: 16974179
R_style_Widget_DeviceDefault_WebTextView=: 16974175
R_style_Widget_DeviceDefault_WebView=: 16974176
R_style_Widget_DropDownItem=: 16973867
R_style_Widget_DropDownItem_Spinner=: 16973868
R_style_Widget_EditText=: 16973859
R_style_Widget_ExpandableListView=: 16973860
R_style_Widget_FragmentBreadCrumbs=: 16973961
R_style_Widget_Gallery=: 16973877
R_style_Widget_GridView=: 16973874
R_style_Widget_Holo=: 16973962
R_style_Widget_Holo_ActionBar=: 16974004
R_style_Widget_Holo_ActionBar_Solid=: 16974113
R_style_Widget_Holo_ActionBar_TabBar=: 16974071
R_style_Widget_Holo_ActionBar_TabText=: 16974070
R_style_Widget_Holo_ActionBar_TabView=: 16974069
R_style_Widget_Holo_ActionButton=: 16973999
R_style_Widget_Holo_ActionButton_CloseMode=: 16974003
R_style_Widget_Holo_ActionButton_Overflow=: 16974000
R_style_Widget_Holo_ActionButton_TextButton=: 16974001
R_style_Widget_Holo_ActionMode=: 16974002
R_style_Widget_Holo_AutoCompleteTextView=: 16973968
R_style_Widget_Holo_Button=: 16973963
R_style_Widget_Holo_Button_Borderless=: 16974050
R_style_Widget_Holo_Button_Borderless_Small=: 16974106
R_style_Widget_Holo_Button_Inset=: 16973965
R_style_Widget_Holo_Button_Small=: 16973964
R_style_Widget_Holo_Button_Toggle=: 16973966
R_style_Widget_Holo_CalendarView=: 16974060
R_style_Widget_Holo_CompoundButton_CheckBox=: 16973969
R_style_Widget_Holo_CompoundButton_RadioButton=: 16973986
R_style_Widget_Holo_CompoundButton_Star=: 16973990
R_style_Widget_Holo_DatePicker=: 16974063
R_style_Widget_Holo_DropDownItem=: 16973994
R_style_Widget_Holo_DropDownItem_Spinner=: 16973995
R_style_Widget_Holo_EditText=: 16973971
R_style_Widget_Holo_ExpandableListView=: 16973972
R_style_Widget_Holo_GridView=: 16973973
R_style_Widget_Holo_HorizontalScrollView=: 16973988
R_style_Widget_Holo_ImageButton=: 16973974
R_style_Widget_Holo_Light=: 16974005
R_style_Widget_Holo_Light_ActionBar=: 16974049
R_style_Widget_Holo_Light_ActionBar_Solid=: 16974114
R_style_Widget_Holo_Light_ActionBar_Solid_Inverse=: 16974115
R_style_Widget_Holo_Light_ActionBar_TabBar=: 16974074
R_style_Widget_Holo_Light_ActionBar_TabBar_Inverse=: 16974116
R_style_Widget_Holo_Light_ActionBar_TabText=: 16974073
R_style_Widget_Holo_Light_ActionBar_TabText_Inverse=: 16974118
R_style_Widget_Holo_Light_ActionBar_TabView=: 16974072
R_style_Widget_Holo_Light_ActionBar_TabView_Inverse=: 16974117
R_style_Widget_Holo_Light_ActionButton=: 16974045
R_style_Widget_Holo_Light_ActionButton_CloseMode=: 16974048
R_style_Widget_Holo_Light_ActionButton_Overflow=: 16974046
R_style_Widget_Holo_Light_ActionMode=: 16974047
R_style_Widget_Holo_Light_ActionMode_Inverse=: 16974119
R_style_Widget_Holo_Light_AutoCompleteTextView=: 16974011
R_style_Widget_Holo_Light_Button=: 16974006
R_style_Widget_Holo_Light_Button_Borderless_Small=: 16974107
R_style_Widget_Holo_Light_Button_Inset=: 16974008
R_style_Widget_Holo_Light_Button_Small=: 16974007
R_style_Widget_Holo_Light_Button_Toggle=: 16974009
R_style_Widget_Holo_Light_CalendarView=: 16974061
R_style_Widget_Holo_Light_CompoundButton_CheckBox=: 16974012
R_style_Widget_Holo_Light_CompoundButton_RadioButton=: 16974032
R_style_Widget_Holo_Light_CompoundButton_Star=: 16974036
R_style_Widget_Holo_Light_DropDownItem=: 16974040
R_style_Widget_Holo_Light_DropDownItem_Spinner=: 16974041
R_style_Widget_Holo_Light_EditText=: 16974014
R_style_Widget_Holo_Light_ExpandableListView=: 16974015
R_style_Widget_Holo_Light_GridView=: 16974016
R_style_Widget_Holo_Light_HorizontalScrollView=: 16974034
R_style_Widget_Holo_Light_ImageButton=: 16974017
R_style_Widget_Holo_Light_ListPopupWindow=: 16974043
R_style_Widget_Holo_Light_ListView=: 16974018
R_style_Widget_Holo_Light_ListView_DropDown=: 16974013
R_style_Widget_Holo_Light_MediaRouteButton=: 16974294
R_style_Widget_Holo_Light_PopupMenu=: 16974044
R_style_Widget_Holo_Light_PopupWindow=: 16974019
R_style_Widget_Holo_Light_ProgressBar=: 16974020
R_style_Widget_Holo_Light_ProgressBar_Horizontal=: 16974021
R_style_Widget_Holo_Light_ProgressBar_Inverse=: 16974025
R_style_Widget_Holo_Light_ProgressBar_Large=: 16974024
R_style_Widget_Holo_Light_ProgressBar_Large_Inverse=: 16974027
R_style_Widget_Holo_Light_ProgressBar_Small=: 16974022
R_style_Widget_Holo_Light_ProgressBar_Small_Inverse=: 16974026
R_style_Widget_Holo_Light_ProgressBar_Small_Title=: 16974023
R_style_Widget_Holo_Light_RatingBar=: 16974029
R_style_Widget_Holo_Light_RatingBar_Indicator=: 16974030
R_style_Widget_Holo_Light_RatingBar_Small=: 16974031
R_style_Widget_Holo_Light_ScrollView=: 16974033
R_style_Widget_Holo_Light_SeekBar=: 16974028
R_style_Widget_Holo_Light_Spinner=: 16974035
R_style_Widget_Holo_Light_Tab=: 16974052
R_style_Widget_Holo_Light_TabWidget=: 16974037
R_style_Widget_Holo_Light_TextView=: 16974010
R_style_Widget_Holo_Light_TextView_SpinnerItem=: 16974042
R_style_Widget_Holo_Light_WebTextView=: 16974038
R_style_Widget_Holo_Light_WebView=: 16974039
R_style_Widget_Holo_ListPopupWindow=: 16973997
R_style_Widget_Holo_ListView=: 16973975
R_style_Widget_Holo_ListView_DropDown=: 16973970
R_style_Widget_Holo_MediaRouteButton=: 16974293
R_style_Widget_Holo_PopupMenu=: 16973998
R_style_Widget_Holo_PopupWindow=: 16973976
R_style_Widget_Holo_ProgressBar=: 16973977
R_style_Widget_Holo_ProgressBar_Horizontal=: 16973978
R_style_Widget_Holo_ProgressBar_Large=: 16973981
R_style_Widget_Holo_ProgressBar_Small=: 16973979
R_style_Widget_Holo_ProgressBar_Small_Title=: 16973980
R_style_Widget_Holo_RatingBar=: 16973983
R_style_Widget_Holo_RatingBar_Indicator=: 16973984
R_style_Widget_Holo_RatingBar_Small=: 16973985
R_style_Widget_Holo_ScrollView=: 16973987
R_style_Widget_Holo_SeekBar=: 16973982
R_style_Widget_Holo_Spinner=: 16973989
R_style_Widget_Holo_Tab=: 16974051
R_style_Widget_Holo_TabWidget=: 16973991
R_style_Widget_Holo_TextView=: 16973967
R_style_Widget_Holo_TextView_SpinnerItem=: 16973996
R_style_Widget_Holo_WebTextView=: 16973992
R_style_Widget_Holo_WebView=: 16973993
R_style_Widget_ImageButton=: 16973862
R_style_Widget_ImageWell=: 16973861
R_style_Widget_KeyboardView=: 16973911
R_style_Widget_ListPopupWindow=: 16973957
R_style_Widget_ListView=: 16973870
R_style_Widget_ListView_DropDown=: 16973872
R_style_Widget_ListView_Menu=: 16973873
R_style_Widget_ListView_White=: 16973871
R_style_Widget_PopupMenu=: 16973958
R_style_Widget_PopupWindow=: 16973878
R_style_Widget_ProgressBar=: 16973852
R_style_Widget_ProgressBar_Horizontal=: 16973855
R_style_Widget_ProgressBar_Inverse=: 16973915
R_style_Widget_ProgressBar_Large=: 16973853
R_style_Widget_ProgressBar_Large_Inverse=: 16973916
R_style_Widget_ProgressBar_Small=: 16973854
R_style_Widget_ProgressBar_Small_Inverse=: 16973917
R_style_Widget_RatingBar=: 16973857
R_style_Widget_ScrollView=: 16973869
R_style_Widget_SeekBar=: 16973856
R_style_Widget_Spinner=: 16973864
R_style_Widget_Spinner_DropDown=: 16973955
R_style_Widget_TabWidget=: 16973876
R_style_Widget_TextView=: 16973858
R_style_Widget_TextView_PopupMenu=: 16973865
R_style_Widget_TextView_SpinnerItem=: 16973866
R_style_Widget_WebView=: 16973875
coclass 'jamkview'
coinsert 'jni jaresu'

jniImport ::0: (0 : 0)
android.content.Context
android.graphics.Bitmap
android.graphics.BitmapFactory
android.graphics.Typeface
android.graphics.drawable.BitmapDrawable
android.graphics.drawable.Drawable
android.view.View
android.view.View$OnClickListener
android.view.ViewGroup
android.view.WindowManager
android.widget.AbsListView
android.widget.AbsoluteLayout
android.widget.AdapterView$OnItemClickListener
android.widget.AdapterView$OnItemSelectedListener
android.widget.AnalogClock
android.widget.ArrayAdapter
android.widget.Button
android.widget.CheckBox
android.widget.DatePicker
android.widget.DigitalClock
android.widget.EditText
android.widget.FrameLayout
android.widget.Gallery
android.widget.HorizontalScrollView
android.widget.ImageButton
android.widget.ImageView
android.widget.LinearLayout
android.widget.ListAdapter
android.widget.ListView
android.widget.ProgressBar
android.widget.RadioButton
android.widget.RadioGroup
android.widget.RelativeLayout
android.widget.ScrollView
android.widget.Spinner
android.widget.SpinnerAdapter
android.widget.TableLayout
android.widget.TableRow
android.widget.TextView
android.widget.TimePicker
)

inputTypes=: (;:@deb);._2 (0 : 0)
none                16b00000000
text                16b00000001
textCapCharacters   16b00001001
textCapWords        16b00002001
textCapSentences    16b00004001
textAutoCorrect     16b00008001
textAutoComplete    16b00010001
textMultiLine       16b00020001
textImeMultiLine    16b00040001
textNoSuggestions   16b00080001
textUri             16b00000011
textEmailAddress    16b00000021
textEmailSubject    16b00000031
textShortMessage    16b00000041
textLongMessage     16b00000051
textPersonName      16b00000061
textPostalAddress   16b00000071
textPassword        16b00000081
textVisiblePassword 16b00000091
textWebEditText     16b000000a1
textFilter          16b000000b1
textPhonetic        16b000000c1
textWebEmailAddress 16b000000d1
textWebPassword     16b000000e1
number              16b00000002
numberSigned        16b00001002
numberDecimal       16b00002002
numberPassword      16b00000012
phone               16b00000003
datetime            16b00000004
date                16b00000014
time                16b00000024
)

inputType0=: {."1 inputTypes
inputType1=: 0". >1{"1 inputTypes
mkview=: 4 : 0
'context locale'=. x
locale=. >locale
'elements idnames res draws'=: y

objs=. 0$2-2
onClicks=. 0 0$<''

for_i. i.#elements do.
  'cparent elm id attval data'=. i{elements
  if. (*#attval) +. (<elm) e. <;._1 ' AbsoluteLayout AnalogClock Button CheckBox DatePicker DigitalClock EditText FrameLayout Gallery ImageButton ImageView LinearLayout ListView ProgressBar RadioButton RadioGroup RelativeLayout ScrollView Spinner TableLayout TableRow TextView TimePicker' do.
    natt=. #att=. {."1 attval [ val=. {:"1 attval
    wh=. 2#WRAP_CONTENT
    gravity=. 0
    weight=. 1.1-1.1
    column=. _1
    span=. 1
    rule=. rule2=. 0$<''
    typeface=. textStyle=. inputType=. ''
    style=. '' [ stylen=. 0
    attr=. '' [ attrn=. 0
    att0=. <;._1 ' android:paddingLeft android:paddingTop android:paddingRight android:paddingBottom android:padding android:background android:textColor android:text android:textSize android:textAppearance android:maxWith android:maxHeight android:scaleType android:adjustViewBounds android:orientation android:gravity android:stretchColumns android:layout_gravity android:layout_weight android:layout_column android:layout_span android:layout_marginLeft android:layout_marginTop android:layout_marginRight android:layout_marginBottom android:layout_width android:layout_height'
    att0=. att0, <;._1 ' android:layout_toLefTOf android:layout_toRightOf android:layout_above android:layout_below android:layout_alignBaseline android:layout_alignLeft android:layout_alignTop android:layout_alignRight android:layout_alignBottom android:layout_alignParentLeft android:layout_alignParentTop android:layout_alignParentRight android:layout_alignParentBottom android:layout_centerInParent android:layout_centerHorizontal android:layout_centerVertical android:onClick'
    att0=. att0, <;._1 ' android:checked android:drawSelectorOnTop android:typeface android:textStyle android:password android:phoneNumber android:inputType android:src android:style'
    if. natt > j=. att i. <'android:style' do. style=. (res stringres) j{::val end.

    if. #style do.
      if. elm-:'ProgressBar' do.
        if. '@android:style/'-:15{.style do.
          stylen=. {. 0,~ ". 'R_attr_', ('Widget.ProgressBar.';'progressBarStyle') stringreplace 15}.style, '_jaresu_'
        end.
      end.
    end.

    if. *./ 0=attrn,stylen do.
      objs=. objs, e=. jniCheck (elm,' LContext;') jniNewObject~ context
    else.
      objs=. objs, e=. jniCheck (elm, ' LContext;Landroid/util/AttributeSet;I') jniNewObject~ context;attrn;stylen
    end.
    margin=. padding=. 4#0
    if. _1~:id do. jniCheck e ('setId (I)V' jniMethod)~ id end.
    if. natt > j=. att i. <'android:paddingLeft' do. padding=. (<.@(res numberres idnames) j{::val) 0 }padding end.
    if. natt > j=. att i. <'android:paddingTop' do. padding=. (<.@(res numberres idnames) j{::val) 1 }padding end.
    if. natt > j=. att i. <'android:paddingRight' do. padding=. (<.@(res numberres idnames) j{::val) 2 }padding end.
    if. natt > j=. att i. <'android:paddingBottom' do. padding=. (<.@(res numberres idnames) j{::val) 3 }padding end.
    if. natt > j=. att i. <'android:padding' do. padding=. 4# <.@(res numberres idnames) j{::val end.
    if. 0 e. 0=padding do. jniCheck e ('setPadding (IIII)V' jniMethod)~ <"0 padding end.
    if. natt > j=. att i. <'android:background' do.
      if. L. a=. (draws drawres) j{::val do.
        jniCheck e ('setBackgroundColor (I)V' jniMethod)~ >a
      else.
        f=. (APILEVEL_ja_<16){::'setBackground';'setBackgroundDrawable'
        if. ''-:a do.
          jniCheck e ((f,' (LDrawable;)V') jniMethod)~ 0
        else.
          jniCheck e ((f,' (LDrawable;)V') jniMethod)~ bd=. jniCheck 'BitmapDrawable LBitmap;' jniNewObject~ a
          jniCheck DeleteLocalRef <bd
        end.
      end.
    end.
    if. natt > j=. att i. <'android:src' do.
      if. L. a=. (draws drawres) j{::val do.
        jniCheck e ('setBackgroundColor (I)V' jniMethod)~ >a
      else.
        if. ''-:a do.
          jniCheck e ('setImageBitmap (LBitmap;)V' jniMethod)~ 0
        else.
          jniCheck e ('setImageBitmap (LBitmap;)V' jniMethod)~ a
        end.
      end.
    end.
    if. natt > j=. att i. <'android:text' do. jniCheck e ('setText (LCharSequence;)V' jniMethod)~ <(res stringres) j{::val end.
    if. natt > j=. att i. <'android:textSize' do. jniCheck e ('setTextSize (I)V' jniMethod)~ <.@(res numberres idnames) j{::val end.
    if. natt > j=. att i. <'android:textColor' do. jniCheck e ('setTextColor (I)V' jniMethod)~ (res colorres) j{::val end.
    if. natt > j=. att i. <'android:textAppearance' do. jniCheck e ('setTextAppearance (LContext;I)V' jniMethod)~ context;<.@(res numberres idnames) j{::val end.
    if. natt > j=. att i. <'android:typeface' do. typeface=. (res stringres) j{::val end.
    if. natt > j=. att i. <'android:textStyle' do. textStyle=. (res stringres) j{::val end.
    if. #typeface,textStyle do.
      ff=. fonts {::~ 5|(fonts=. ;:'default default_bold monospace san_serif serif') i. <typeface
      tf=. jniCheck (((toupper ff),' LTypeface;') jniStaticField) 'android.graphics.Typeface'
      st=. 4|(;:'normal bold italic bold_italic') i. <textStyle
      jniCheck e ('setTypeface (LTypeface;I)V' jniMethod)~ tf;st
    end.
    if. natt > j=. att i. <'android:inputType' do. inputType=. '|', (res stringres) j{::val end.
    if. natt > j=. att i. <'android:password' do. inputType=. inputType, '|', 'textPassword' end.
    if. natt > j=. att i. <'android:phoneNumber' do. inputType=. inputType, '|', 'phone' end.
    if. #inputType do.
      jniCheck e ('setInputType (I)V' jniMethod)~ (23 b.)/ inputType1 {~ inputType0 i. ~. <;._1 inputType
    end.
    if. natt > j=. att i. <'android:checked' do. jniCheck e ('setChecked (Z)V' jniMethod)~ <.@(res numberres idnames) j{::val end.
    if. natt > j=. att i. <'android:maxWith' do. jniCheck e ('setMaxWith (I)V' jniMethod)~ <.@(res numberres idnames) j{::val end.
    if. natt > j=. att i. <'android:maxHeight' do. jniCheck e ('setMaxHeight (I)V' jniMethod)~ <.@(res numberres idnames) j{::val end.
    if. natt > j=. att i. <'android:scaleType' do. jniCheck e ('setScaleType (I)V' jniMethod)~ scaletyperes j{::val end.
    if. natt > j=. att i. <'android:adjustViewBounds' do. jniCheck e ('setadjustViewBounds (Z)V' jniMethod)~ <.@(res numberres idnames) j{::val end.
    if. natt > j=. att i. <'android:onClick' do.
      onClick=. j{::val
      if. (<onClick) -.@e. {."1 onClicks do.
        jniCheck listener=. '' jniOverride 'org.dykman.jn.android.view.View$OnClickListener2' ; locale ; onClick
        onClicks=. onClicks, onClick;listener
      else.
        listener=. 1{:: (({."1 onClicks) i. <onClick){onClicks
      end.
      jniCheck e ('setOnClickListener (LView$OnClickListener;)V' jniMethod)~ listener
    end.
    if. natt > j=. att i. <'android:orientation' do. jniCheck e ('setOrientation (I)V' jniMethod)~ 'vertical'-:j{::val end.
    if. natt > j=. att i. <'android:gravity' do. jniCheck e ('setGravity (I)V' jniMethod)~ gravityres j{::val end.
    if. natt > j=. att i. <'android:stretchColumns' do. stretchcolumns j{::val end.
    if. natt > j=. att i. <'android:layout_gravity' do. gravity=. gravityres j{::val end.
    if. natt > j=. att i. <'android:layout_weight' do. weight=. (res numberres idnames) j{::val end.
    if. natt > j=. att i. <'android:layout_column' do. column=. <.@(res numberres idnames) j{::val end.
    if. natt > j=. att i. <'android:layout_span' do. span=. <.@(res numberres idnames) j{::val end.
    if. natt > j=. att i. <'android:layout_marginLeft' do. margin=. (<.@(res numberres idnames) j{::val) 0 }margin end.
    if. natt > j=. att i. <'android:layout_marginTop' do. margin=. (<.@(res numberres idnames) j{::val) 1 }margin end.
    if. natt > j=. att i. <'android:layout_marginRight' do. margin=. (<.@(res numberres idnames) j{::val) 2 }margin end.
    if. natt > j=. att i. <'android:layout_marginBottom' do. margin=. (<.@(res numberres idnames) j{::val) 3 }margin end.
    if. natt > j=. att i. <'android:layout_width' do. wh=. (<.@(res numberres idnames) j{::val) 0 }wh end.
    if. natt > j=. att i. <'android:layout_height' do. wh=. (<.@(res numberres idnames) j{::val) 1 }wh end.
    if. #r=. att ([-.-.) addrule do. rule=. j{att [ rulenum=. (j=. att i. r){val end.
    if. #r=. att ([-.-.) addrule2 do. rule2=. j{att [ anchor=. (j=. att i. r){val end.
    if. (*#rule,rule2) +. (0 e. 0=margin) +. (0 e. WRAP_CONTENT=wh) +. (0~:gravity) +. (0~:weight) +. (_1~:column) +. (1~:span) do.
      lpclass=. 'android.view.ViewGroup$LayoutParams'
      if. _1~:cparent do.
        cl=. '$LayoutParams',~ 1{::cparent{elements
        if. #r=. I. (1&e.)@(cl&E.)&> layoutparams do.
          lpclass=. ({.r){::layoutparams
        end.
      end.
      jniCheck lp=. (lpclass, ' II') jniNewObject~ <"0 wh
      if. 0~:gravity do. jniCheck lp ('gravity I' jniField)~ gravity end.
      if. 0~:weight do. jniCheck lp ('weight F' jniField)~ <weight end.
      if. 1~:span do. jniCheck lp ('span I' jniField)~ <span end.
      if. _1~:column do. jniCheck lp ('column I' jniField)~ <column end.
      if. 0 e. 0=margin do. jniCheck lp ('setMargins (IIII)V' jniMethod)~ <"0 margin end.
      for_j. i.#rule do.
        if. 1= r=. <.@(res numberres idnames) j{::rulenum do.
          jniCheck lp ('addRule (I)V' jniMethod)~ ralativelayoutrule i. 15&}.&.> j{rule
        end.
      end.
      for_j. i.#rule2 do.
        r=. <.@(res numberres idnames) j{::anchor
        jniCheck lp ('addRule (II)V' jniMethod)~ r;~ ralativelayoutrule i. 15&}.&.> j{rule2
      end.
      jniCheck e ('setLayoutParams (Landroid/view/ViewGroup$LayoutParams;)V' jniMethod)~ lp
      jniCheck DeleteLocalRef <lp
    end.
    if. _1~:cparent do.
      jniCheck (cparent{objs) ('addView (LView;)V' jniMethod)~ e
    end.
    att1=. (att-.'id';'android:id';'xmlns:android') -. att0
    if. #att1 do.
      smoutput 'unknown attributes:', ; (<' ') ,&.> att1
    end.
  else.
    objs=. objs, 0
    if. 'requestFocus'-:elm do. jniCheck ({:objs) ('requestFocus ()Z' jniMethod)~ ''
    else.
      smoutput 'unknown element: ', elm
    end.
  end.
end.
if. #ob=. }. objs-.0 do. jniCheck DeleteLocalRef"0 <"0 ob end.
if. #onClicks do. jniCheck DeleteLocalRef"0 {:"1 onClicks end.
{.objs
)
trim1=: {.~ i.&' '
stretchcolumns=: [
ralativelayoutrule=: <;._2 (0 : 0)
toLefTOf
toRightOf
above
below
alignBaseline
alignLeft
alignTop
alignRight
alignBottom
alignParentLeft
alignParentTop
alignParentRight
alignParentBottom
centerInParent
centerHorizontal
centerVertical
)

layoutparams=: <;._2 (0 : 0)
android:layout_above
android:layout_alignBaseline
android:layout_alignBottom
android:layout_alignLeft
android:layout_alignParentBottom
android:layout_alignParentLeft
android:layout_alignParentRight
android:layout_alignParentTop
android:layout_alignRight
android:layout_alignTop
android:layout_alignWithParentIfMissing
android:layout_below
android:layout_centerHorizontal
android:layout_centerInParent
android:layout_centerVertical
android:layout_column
android:layout_columnSpan
android:layout_gravity
android:layout_height
android:layout_margin
android:layout_marginBottom
android:layout_marginLeft
android:layout_marginRight
android:layout_marginTop
android:layout_row
android:layout_rowSpan
android:layout_scale
android:layout_span
android:layout_toLeftOf
android:layout_toRightOf
android:layout_weight
android:layout_width
android:layout_x
android:layout_y
)

addrule=: <;._2 (0 : 0)
android:layout_alignBaseline
android:layout_alignParentBottom
android:layout_alignParentLeft
android:layout_alignParentRight
android:layout_alignParentTop
android:layout_alignWithParentIfMissing
android:layout_centerHorizontal
android:layout_centerInParent
android:layout_centerVertical
)

addrule2=: <;._2 (0 : 0)
android:layout_above
android:layout_alignBottom
android:layout_alignLeft
android:layout_alignRight
android:layout_alignTop
android:layout_below
android:layout_toLeftOf
android:layout_toRightOf
)

viewgroupatt=: (<@trim1;._1);._2 (0 : 0)
%android:addStatesFromChildren  %
%android:alwaysDrawnWithCache   %
%android:animateLayoutChanges   %setLayoutTransition
%android:animationCache         %
%android:clipChildren           %setClipChildren
%android:clipToPadding          %setClipToPadding
%android:descendantFocusability %
%android:layoutAnimation        %
%android:persistentDrawingCache %
)

viewatt=: (<@trim1;._1);._2 (0 : 0)
%android:alpha                              %setAlpha(float)
%android:background                         %setBackgroundResource(int)
%android:clickable                          %setClickable(boolean)
%android:contentDescription                 %setContentDescription
%android:drawingCacheQuality                %setDrawingCacheQuality(int)
%android:duplicateParentState               %
%android:fadeScrollbars                     %setScrollbarFadingEnabled(boolean)
%android:fadingEdgeLength                   %setVerticalFadingEdgeLength()
%android:filterTouchesWhenObscured          %setFilterTouchesWhenObscured
%android:fitsSystemWindows                  %setFitsSystemWindows(boolean)
%android:focusable                          %setFocusable(boolean)
%android:focusableInTouchMode               %setFocusableInTouchMode(boolean)
%android:hapticFeedbackEnabled              %setHapticFeedbackEnabled(boolean)
%android:id                                 %setId(int)
%android:importantForAccessibility          %setImportantForAccessibility(int)
%android:isScrollContainer                  %setScrollContainer(boolean)
%android:keepScreenOn                       %setKeepScreenOn(boolean)
%android:layerType                          %setLayerType(int,Paint)
%android:longClickable                      %setLongClickable(boolean)
%android:minHeight                          %setMinimumHeight(int)
%android:minWidth                           %setMinimumWidth(int)
%android:nextFocusDown                      %setNextFocusDownId(int)
%android:nextFocusForward                   %setNextFocusForwardId(int)
%android:nextFocusLeft                      %setNextFocusLeftId(int)
%android:nextFocusRight                     %setNextFocusRightId(int)
%android:nextFocusUp                        %setNextFocusUpId(int)
%android:onClick                            %
%android:padding                            %setPadding(int,int,int,int)
%android:paddingBottom                      %setPadding(int,int,int,int)
%android:paddingLeft                        %setPadding(int,int,int,int)
%android:paddingRight                       %setPadding(int,int,int,int)
%android:paddingTop                         %setPadding(int,int,int,int)
%android:requiresFadingEdge                 %setVerticalFadingEdgeEnabled
%android:rotation                           %setRotation(float)
%android:rotationX                          %setRotationX(float)
%android:rotationY                          %setRotationY(float)
%android:saveEnabled                        %setSaveEnabled(boolean)
%android:scaleX                             %setScaleX(float)
%android:scaleY                             %setScaleY(float)
%android:scrollX                            %
%android:scrollY                            %
%android:scrollbarAlwaysDrawHorizontalTrack %
%android:scrollbarAlwaysDrawVerticalTrack   %
%android:scrollbarDefaultDelayBeforeFade    %setScrollBarDefaultDelayBeforeFade
%android:scrollbarFadeDuration              %setScrollBarFadeDuration(int)
%android:scrollbarSize                      %setScrollBarSize(int)
%android:scrollbarStyle                     %setScrollBarStyle(int)
%android:scrollbarThumbHorizontal           %
%android:scrollbarThumbVertical             %
%android:scrollbarTrackHorizontal           %
%android:scrollbarTrackVertical             %
%android:scrollbars                         %
%android:soundEffectsEnabled                %setSoundEffectsEnabled(boolean)
%android:tag                                %
%android:transformPivotX                    %setPivotX(float)
%android:transformPivotY                    %setPivotY(float)
%android:translationX                       %setTranslationX(float)
%android:translationY                       %setTranslationY(float)
%android:visibility                         %setVisibility(int)
)

layoutparams=: <;._2 (0 : 0)
android.view.ViewGroup$LayoutParams
android.view.ViewGroup$MarginLayoutParams
android.view.WindowManager$LayoutParams
android.widget.AbsListView$LayoutParams
android.widget.AbsoluteLayout$LayoutParams
android.widget.FrameLayout$LayoutParams
android.widget.Gallery$LayoutParams
android.widget.LinearLayout$LayoutParams
android.widget.RadioGroup$LayoutParams
android.widget.RelativeLayout$LayoutParams
android.widget.TableLayout$LayoutParams
android.widget.TableRow$LayoutParams
)
coclass 'jamkmenu'
coinsert 'jni jaresu'

jniImport ::0: (0 : 0)
android.content.Context
android.view.Menu
android.view.MenuItem
android.view.MenuItem$OnMenuItemClickListener
android.view.ContextMenu
android.view.SubMenu
)

mkmenu=: 4 : 0
'context rootmenu locale'=. x
locale=. >locale
'elements idnames res'=. y

objs=. 0$0
groups=. 0$0
onClicks=. 0 0$<''

for_i. i.#elements do.
  'cparent elm id cmenu cgroup attval data'=. i{elements
  natt=. #att=. {."1 attval [ val=. {:"1 attval
  if. (<elm) e. <;._1 ' menu submenu item' do.
    title=. titleCondensed=. menuCategory=. onClick=. '' [ alphabeticShortcutcut=. numericShortcut=. ' '
    orderInCategory=. checkable=. checked=. 0 [ enabled=. visible=. 1
    e=. 0
    att0=. <;._1 ' android:title android:titleCondensed android:alphabeticShortcut android:numericShortcut android:checkable android:checked android:visible android:enabled android:orderInCategory android:menuCategory android:onClick'
    id=. id>.0
    if. natt > j=. att i. <'android:title' do. title=. (res stringres) j{::val end.
    if. natt > j=. att i. <'android:titleCondensed' do. titleCondensed=. (res stringres) j{::val end.
    if. natt > j=. att i. <'android:alphabeticShortcut' do. alphabeticShortcutcut=. {.(res stringres) j{::val end.
    if. natt > j=. att i. <'android:numericShortcut' do. numericShortcut=. {.(res stringres) j{::val end.
    if. natt > j=. att i. <'android:checkable' do. checkable=. <.@(res numberres idnames) j{::val end.
    if. natt > j=. att i. <'android:checked' do. checked=. <.@(res numberres idnames) j{::val end.
    if. natt > j=. att i. <'android:enabled' do. enabled=. <.@(res numberres idnames) j{::val end.
    if. natt > j=. att i. <'android:visible' do. visible=. <.@(res numberres idnames) j{::val end.
    if. natt > j=. att i. <'android:orderInCategory' do. orderInCategory=. <.@(res numberres idnames) j{::val end.
    if. natt > j=. att i. <'android:menuCategory' do. menuCategory=. j{::val end.
    if. natt > j=. att i. <'android:onClick' do. onClick=. j{::val end.
    select. <elm
    case. 'menu' do.
      objs=. objs, rootmenu
    case. 'submenu' do.
      objs=. objs, e=. jniCheck (cmenu{objs) ('addSubMenu (IIILCharSequence;)LSubMenu;' jniMethod)~ cgroup;id;orderInCategory;title
    case. 'item' do.
      objs=. objs, e=. jniCheck (cmenu{objs) ('add (IIILCharSequence;)LMenuItem;' jniMethod)~ cgroup;id;orderInCategory;title
    end.
    if. e do.
      if. #titleCondensed do. jniCheck e ('setTitleCondensed (LCharSequence;)LMenuItem;' jniMethod)~ <titleCondensed end.
      if. 0 e. ' '= alphabeticShortcutcut,numericShortcut do. jniCheck e ('setShortcut (CC)LMenuItem;' jniMethod)~ numericShortcut;alphabeticShortcutcut end.
      if. checkable do. jniCheck e ('setCheckable (Z)LMenuItem;' jniMethod)~ checkable end.
      if. checked do. jniCheck e ('setChecked (Z)LMenuItem;' jniMethod)~ checked end.
      if. 0=enabled do. jniCheck e ('setEnabled (Z)LMenuItem;' jniMethod)~ enabled end.
      if. 0=visible do. jniCheck e ('setVisible (Z)LMenuItem;' jniMethod)~ visible end.
      if. #onClick do.
        if. (<onClick) -.@e. {."1 onClicks do.
          jniCheck listener=. '' jniOverride 'org.dykman.jn.android.view.MenuItem$OnMenuItemClickListener2' ; locale ; onClick
          onClicks=. onClicks, onClick;listener
        else.
          listener=. 1{:: (({."1 onClicks) i. <onClick){onClicks
        end.
        jniCheck e ('setOnMenuItemClickListener (LMenuItem$OnMenuItemClickListener;)LMenuItem;' jniMethod)~ listener
      end.
    end.
    att1=. (att-.'id';'android:id';'xmlns:android') -. att0
    if. #att1 do.
      smoutput 'unknown attributes:', ; (<' ') ,&.> att1
    end.
  else.
    objs=. objs, 0
    if. elm-.@-:'group' do.
      smoutput 'unknown element: ', elm
    end.
  end.
end.
if. #ob=. }. objs-.0 do. jniCheck DeleteLocalRef"0 <"0 ob end.
if. #onClicks do. jniCheck DeleteLocalRef"0 {:"1 onClicks end.
0
)
