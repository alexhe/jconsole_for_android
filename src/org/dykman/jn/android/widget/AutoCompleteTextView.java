package org.dykman.jn.android.widget;
public class AutoCompleteTextView extends android.widget.AutoCompleteTextView{
protected org.dykman.j.JInterface jInterface = null;
protected java.lang.String jlocale = null;
protected java.lang.String jchildid = null;
protected java.lang.String jchildidx = null;
protected java.util.ArrayList jnOverrideList = null;
protected void jparseargs (java.lang.String jlocale, java.lang.String jchildid, java.lang.String joverride ) { this.jlocale = jlocale; this.jchildid = jchildid; if (jchildid != null && jchildid.length() > 0) jchildidx = jchildid + "_"; else jchildidx = ""; if (joverride != null && joverride.length() > 0) { java.lang.String[] ss = joverride.split(" "); for (int i = 0; i < ss.length; i++) setjnOverride(ss[i]); } }
public void clearjnOverride () { jnOverrideList.clear (); }
public void setjnOverride (java.lang.String arg1 ) { if (!testjnOverride (arg1)) jnOverrideList.add (arg1); }
public void setjnOverride (java.lang.String arg1, boolean arg2 ) { if (arg2) { if (!testjnOverride (arg1)) jnOverrideList.add (arg1); } else jnOverrideList.remove (arg1); }
public boolean testjnOverride (java.lang.String arg1 ) { return jnOverrideList.contains (arg1); }
public AutoCompleteTextView(android.content.Context arg1, java.lang.String jlocale,String jchildid,String joverride ) { super( arg1); jnOverrideList = new java.util.ArrayList(); jparseargs( jlocale, jchildid, joverride ); jInterface = org.dykman.j.android.JConsoleApp.theApp.jInterface; if (testjnOverride( "jcreate" )) jInterface.Jnido( this, jchildidx + "jcreate_" + jlocale + "_", new java.lang.Object[]{ arg1 } ); }
public AutoCompleteTextView(android.content.Context arg1,android.util.AttributeSet arg2, java.lang.String jlocale,String jchildid,String joverride ) { super( arg1, arg2); jnOverrideList = new java.util.ArrayList(); jparseargs( jlocale, jchildid, joverride ); jInterface = org.dykman.j.android.JConsoleApp.theApp.jInterface; if (testjnOverride( "jcreate" )) jInterface.Jnido( this, jchildidx + "jcreate_" + jlocale + "_", new java.lang.Object[]{ arg1, arg2 } ); }
public AutoCompleteTextView(android.content.Context arg1,android.util.AttributeSet arg2,int arg3, java.lang.String jlocale,String jchildid,String joverride ) { super( arg1, arg2, arg3); jnOverrideList = new java.util.ArrayList(); jparseargs( jlocale, jchildid, joverride ); jInterface = org.dykman.j.android.JConsoleApp.theApp.jInterface; if (testjnOverride( "jcreate" )) jInterface.Jnido( this, jchildidx + "jcreate_" + jlocale + "_", new java.lang.Object[]{ arg1, arg2, arg3 } ); }
@Override public void setThreshold(int arg1) { if (!testjnOverride( "setThreshold" )) { super.setThreshold( arg1); return; } jInterface.Jnido( this, jchildidx + "setThreshold_" + jlocale + "_", new java.lang.Object[]{ arg1 } ); }
@Override public void setOnClickListener(android.view.View.OnClickListener arg1) { if (!testjnOverride( "setOnClickListener" )) { super.setOnClickListener( arg1); return; } jInterface.Jnido( this, jchildidx + "setOnClickListener_" + jlocale + "_", new java.lang.Object[]{ arg1 } ); }
@Override public void setCompletionHint(java.lang.CharSequence arg1) { if (!testjnOverride( "setCompletionHint" )) { super.setCompletionHint( arg1); return; } jInterface.Jnido( this, jchildidx + "setCompletionHint_" + jlocale + "_", new java.lang.Object[]{ arg1 } ); }
@Override public int getDropDownWidth(){ if (!testjnOverride( "getDropDownWidth" )) return super.getDropDownWidth(); return (java.lang.Integer) jInterface.Jnido( this, jchildidx + "getDropDownWidth_" + jlocale + "_", null ); }
@Override public void setDropDownWidth(int arg1) { if (!testjnOverride( "setDropDownWidth" )) { super.setDropDownWidth( arg1); return; } jInterface.Jnido( this, jchildidx + "setDropDownWidth_" + jlocale + "_", new java.lang.Object[]{ arg1 } ); }
@Override public int getDropDownHeight(){ if (!testjnOverride( "getDropDownHeight" )) return super.getDropDownHeight(); return (java.lang.Integer) jInterface.Jnido( this, jchildidx + "getDropDownHeight_" + jlocale + "_", null ); }
@Override public void setDropDownHeight(int arg1) { if (!testjnOverride( "setDropDownHeight" )) { super.setDropDownHeight( arg1); return; } jInterface.Jnido( this, jchildidx + "setDropDownHeight_" + jlocale + "_", new java.lang.Object[]{ arg1 } ); }
@Override public int getDropDownAnchor(){ if (!testjnOverride( "getDropDownAnchor" )) return super.getDropDownAnchor(); return (java.lang.Integer) jInterface.Jnido( this, jchildidx + "getDropDownAnchor_" + jlocale + "_", null ); }
@Override public void setDropDownAnchor(int arg1) { if (!testjnOverride( "setDropDownAnchor" )) { super.setDropDownAnchor( arg1); return; } jInterface.Jnido( this, jchildidx + "setDropDownAnchor_" + jlocale + "_", new java.lang.Object[]{ arg1 } ); }
@Override public android.graphics.drawable.Drawable getDropDownBackground(){ if (!testjnOverride( "getDropDownBackground" )) return super.getDropDownBackground(); return (android.graphics.drawable.Drawable) jInterface.Jnido( this, jchildidx + "getDropDownBackground_" + jlocale + "_", null ); }
@Override public void setDropDownBackgroundDrawable(android.graphics.drawable.Drawable arg1) { if (!testjnOverride( "setDropDownBackgroundDrawable" )) { super.setDropDownBackgroundDrawable( arg1); return; } jInterface.Jnido( this, jchildidx + "setDropDownBackgroundDrawable_" + jlocale + "_", new java.lang.Object[]{ arg1 } ); }
@Override public void setDropDownBackgroundResource(int arg1) { if (!testjnOverride( "setDropDownBackgroundResource" )) { super.setDropDownBackgroundResource( arg1); return; } jInterface.Jnido( this, jchildidx + "setDropDownBackgroundResource_" + jlocale + "_", new java.lang.Object[]{ arg1 } ); }
@Override public void setDropDownVerticalOffset(int arg1) { if (!testjnOverride( "setDropDownVerticalOffset" )) { super.setDropDownVerticalOffset( arg1); return; } jInterface.Jnido( this, jchildidx + "setDropDownVerticalOffset_" + jlocale + "_", new java.lang.Object[]{ arg1 } ); }
@Override public int getDropDownVerticalOffset(){ if (!testjnOverride( "getDropDownVerticalOffset" )) return super.getDropDownVerticalOffset(); return (java.lang.Integer) jInterface.Jnido( this, jchildidx + "getDropDownVerticalOffset_" + jlocale + "_", null ); }
@Override public void setDropDownHorizontalOffset(int arg1) { if (!testjnOverride( "setDropDownHorizontalOffset" )) { super.setDropDownHorizontalOffset( arg1); return; } jInterface.Jnido( this, jchildidx + "setDropDownHorizontalOffset_" + jlocale + "_", new java.lang.Object[]{ arg1 } ); }
@Override public int getDropDownHorizontalOffset(){ if (!testjnOverride( "getDropDownHorizontalOffset" )) return super.getDropDownHorizontalOffset(); return (java.lang.Integer) jInterface.Jnido( this, jchildidx + "getDropDownHorizontalOffset_" + jlocale + "_", null ); }
@Override public int getThreshold(){ if (!testjnOverride( "getThreshold" )) return super.getThreshold(); return (java.lang.Integer) jInterface.Jnido( this, jchildidx + "getThreshold_" + jlocale + "_", null ); }
@Override public void setOnItemClickListener(android.widget.AdapterView.OnItemClickListener arg1) { if (!testjnOverride( "setOnItemClickListener" )) { super.setOnItemClickListener( arg1); return; } jInterface.Jnido( this, jchildidx + "setOnItemClickListener_" + jlocale + "_", new java.lang.Object[]{ arg1 } ); }
@Override public void setOnItemSelectedListener(android.widget.AdapterView.OnItemSelectedListener arg1) { if (!testjnOverride( "setOnItemSelectedListener" )) { super.setOnItemSelectedListener( arg1); return; } jInterface.Jnido( this, jchildidx + "setOnItemSelectedListener_" + jlocale + "_", new java.lang.Object[]{ arg1 } ); }
@Override public android.widget.ListAdapter getAdapter(){ if (!testjnOverride( "getAdapter" )) return super.getAdapter(); return (android.widget.ListAdapter) jInterface.Jnido( this, jchildidx + "getAdapter_" + jlocale + "_", null ); }
@Override public boolean onKeyPreIme(int arg1,android.view.KeyEvent arg2) { if (!testjnOverride( "onKeyPreIme" )) return super.onKeyPreIme( arg1, arg2); return (java.lang.Boolean) jInterface.Jnido( this, jchildidx + "onKeyPreIme_" + jlocale + "_", new java.lang.Object[]{ arg1, arg2 } ); }
@Override public boolean onKeyUp(int arg1,android.view.KeyEvent arg2) { if (!testjnOverride( "onKeyUp" )) return super.onKeyUp( arg1, arg2); return (java.lang.Boolean) jInterface.Jnido( this, jchildidx + "onKeyUp_" + jlocale + "_", new java.lang.Object[]{ arg1, arg2 } ); }
@Override public boolean onKeyDown(int arg1,android.view.KeyEvent arg2) { if (!testjnOverride( "onKeyDown" )) return super.onKeyDown( arg1, arg2); return (java.lang.Boolean) jInterface.Jnido( this, jchildidx + "onKeyDown_" + jlocale + "_", new java.lang.Object[]{ arg1, arg2 } ); }
@Override public boolean enoughToFilter(){ if (!testjnOverride( "enoughToFilter" )) return super.enoughToFilter(); return (java.lang.Boolean) jInterface.Jnido( this, jchildidx + "enoughToFilter_" + jlocale + "_", null ); }
@Override public boolean isPopupShowing(){ if (!testjnOverride( "isPopupShowing" )) return super.isPopupShowing(); return (java.lang.Boolean) jInterface.Jnido( this, jchildidx + "isPopupShowing_" + jlocale + "_", null ); }
@Override protected java.lang.CharSequence convertSelectionToString(java.lang.Object arg1) { if (!testjnOverride( "convertSelectionToString" )) return super.convertSelectionToString( arg1); return (java.lang.CharSequence) jInterface.Jnido( this, jchildidx + "convertSelectionToString_" + jlocale + "_", new java.lang.Object[]{ arg1 } ); }
@Override public void clearListSelection(){ if (!testjnOverride( "clearListSelection" )) { super.clearListSelection(); return; } jInterface.Jnido( this, jchildidx + "clearListSelection_" + jlocale + "_", null ); }
@Override public void setListSelection(int arg1) { if (!testjnOverride( "setListSelection" )) { super.setListSelection( arg1); return; } jInterface.Jnido( this, jchildidx + "setListSelection_" + jlocale + "_", new java.lang.Object[]{ arg1 } ); }
@Override public int getListSelection(){ if (!testjnOverride( "getListSelection" )) return super.getListSelection(); return (java.lang.Integer) jInterface.Jnido( this, jchildidx + "getListSelection_" + jlocale + "_", null ); }
@Override protected void performFiltering(java.lang.CharSequence arg1,int arg2) { if (!testjnOverride( "performFiltering" )) { super.performFiltering( arg1, arg2); return; } jInterface.Jnido( this, jchildidx + "performFiltering_" + jlocale + "_", new java.lang.Object[]{ arg1, arg2 } ); }
@Override public void performCompletion(){ if (!testjnOverride( "performCompletion" )) { super.performCompletion(); return; } jInterface.Jnido( this, jchildidx + "performCompletion_" + jlocale + "_", null ); }
@Override public void onCommitCompletion(android.view.inputmethod.CompletionInfo arg1) { if (!testjnOverride( "onCommitCompletion" )) { super.onCommitCompletion( arg1); return; } jInterface.Jnido( this, jchildidx + "onCommitCompletion_" + jlocale + "_", new java.lang.Object[]{ arg1 } ); }
@Override public boolean isPerformingCompletion(){ if (!testjnOverride( "isPerformingCompletion" )) return super.isPerformingCompletion(); return (java.lang.Boolean) jInterface.Jnido( this, jchildidx + "isPerformingCompletion_" + jlocale + "_", null ); }
@Override protected void replaceText(java.lang.CharSequence arg1) { if (!testjnOverride( "replaceText" )) { super.replaceText( arg1); return; } jInterface.Jnido( this, jchildidx + "replaceText_" + jlocale + "_", new java.lang.Object[]{ arg1 } ); }
@Override public void onFilterComplete(int arg1) { if (!testjnOverride( "onFilterComplete" )) { super.onFilterComplete( arg1); return; } jInterface.Jnido( this, jchildidx + "onFilterComplete_" + jlocale + "_", new java.lang.Object[]{ arg1 } ); }
@Override public void onWindowFocusChanged(boolean arg1) { if (!testjnOverride( "onWindowFocusChanged" )) { super.onWindowFocusChanged( arg1); return; } jInterface.Jnido( this, jchildidx + "onWindowFocusChanged_" + jlocale + "_", new java.lang.Object[]{ arg1 } ); }
@Override protected void onFocusChanged(boolean arg1,int arg2,android.graphics.Rect arg3) { if (!testjnOverride( "onFocusChanged" )) { super.onFocusChanged( arg1, arg2, arg3); return; } jInterface.Jnido( this, jchildidx + "onFocusChanged_" + jlocale + "_", new java.lang.Object[]{ arg1, arg2, arg3 } ); }
@Override protected void onAttachedToWindow(){ if (!testjnOverride( "onAttachedToWindow" )) { super.onAttachedToWindow(); return; } jInterface.Jnido( this, jchildidx + "onAttachedToWindow_" + jlocale + "_", null ); }
@Override protected void onDetachedFromWindow(){ if (!testjnOverride( "onDetachedFromWindow" )) { super.onDetachedFromWindow(); return; } jInterface.Jnido( this, jchildidx + "onDetachedFromWindow_" + jlocale + "_", null ); }
@Override public void dismissDropDown(){ if (!testjnOverride( "dismissDropDown" )) { super.dismissDropDown(); return; } jInterface.Jnido( this, jchildidx + "dismissDropDown_" + jlocale + "_", null ); }
@Override protected boolean setFrame(int arg1,int arg2,int arg3,int arg4) { if (!testjnOverride( "setFrame" )) return super.setFrame( arg1, arg2, arg3, arg4); return (java.lang.Boolean) jInterface.Jnido( this, jchildidx + "setFrame_" + jlocale + "_", new java.lang.Object[]{ arg1, arg2, arg3, arg4 } ); }
@Override public void showDropDown(){ if (!testjnOverride( "showDropDown" )) { super.showDropDown(); return; } jInterface.Jnido( this, jchildidx + "showDropDown_" + jlocale + "_", null ); }
@Override public void setValidator(android.widget.AutoCompleteTextView.Validator arg1) { if (!testjnOverride( "setValidator" )) { super.setValidator( arg1); return; } jInterface.Jnido( this, jchildidx + "setValidator_" + jlocale + "_", new java.lang.Object[]{ arg1 } ); }
@Override public void performValidation(){ if (!testjnOverride( "performValidation" )) { super.performValidation(); return; } jInterface.Jnido( this, jchildidx + "performValidation_" + jlocale + "_", null ); }
@Override protected android.widget.Filter getFilter(){ if (!testjnOverride( "getFilter" )) return super.getFilter(); return (android.widget.Filter) jInterface.Jnido( this, jchildidx + "getFilter_" + jlocale + "_", null ); }
}