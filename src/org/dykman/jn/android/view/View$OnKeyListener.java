package org.dykman.jn.android.view;
public class View$OnKeyListener implements android.view.View.OnKeyListener{
protected org.dykman.j.JInterface jInterface = null;
protected java.lang.String jlocale = null;
protected java.lang.String jchildid = null;
protected java.lang.String jchildidx = null;
protected void jparseargs (java.lang.String jlocale, java.lang.String jchildid ) { this.jlocale = jlocale; this.jchildid = jchildid; if (jchildid != null && jchildid.length() > 0) jchildidx = jchildid + "_"; else jchildidx = ""; }
public View$OnKeyListener (java.lang.String jlocale,java.lang.String jchildid,java.lang.String dummy ){ jparseargs( jlocale, jchildid ); jInterface = org.dykman.j.android.JConsoleApp.theApp.jInterface; }
@Override public boolean onKey(android.view.View arg1,int arg2,android.view.KeyEvent arg3) { return (java.lang.Boolean) jInterface.Jnido( this, jchildidx + "onKey_" + jlocale + "_", new java.lang.Object[]{ arg1, arg2, arg3 } ); }
}
