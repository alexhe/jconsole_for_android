package org.dykman.j.android;

import java.io.File;
import java.io.FilenameFilter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.dykman.j.JInterface;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.text.Editable;
import android.text.InputType;
import android.util.Log;
import android.view.Gravity;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

public abstract class AbstractActivity extends Activity {

	public static final String EMPTY = " -- empty -- ";
	JConsoleApp theApp;
	public static final String CONSOLE_NAME = "J Console";
//	static final String tempDir = "user/temp";
//	Console console;


	protected File root;
	
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		theApp = (JConsoleApp) this.getApplication();
		root = theApp.getRoot();
//		console = theApp.getConsole();


	}

	public void alert(String message) {
		AlertDialog.Builder builder = new AlertDialog.Builder(this);
		builder.setMessage(message);
		builder.setPositiveButton("OK", new AlertDialog.OnClickListener() {
			public void onClick(DialogInterface dialog, int which) {
				dialog.dismiss();
			}
		});
		
	}
	public void runFile() {
		alert("You cannot run this object");
	}
	@Override
	public boolean onMenuItemSelected(int featureId, MenuItem item) {
		boolean result = true;
		int itemId = item.getItemId();
		Log.d(JConsoleApp.LogTag,"selection " + itemId + ", " + getClass().getName());
		switch(itemId) {
			case R.id.newf:    theApp.newFile(this);                     break;
//			case R.id.open:    requestFileOpen(); 	          break;
			case R.id.open:    {
				requestFileOpen(); 	          
				break;
			}
			case R.id.window:  requestWindowSelect();     	  break;
			case R.id.jbreak:  callBreak();                   break;
			case R.id.exit:    testQuit();					  break;
			case R.id.log:     showHistoryDialog();			  break;
			case R.id.runl:    runCurrentLine();              break;
			case R.id.runf:    requestFileRun();              break;
			case R.id.runc:    runFile();               break;
			case R.id.vocab:   showHelp(R.string.help_start); break;
			case R.id.jhs:		theApp.launchJHS(this);		  break;
			case R.id.learning: showHelp(R.string.learning);  break;
			case R.id.readme:  showTextFile(R.string.readme); break;
			case R.id.aboutj:  showTextFile(R.string.aboutj); break;
			default: result = false;
		}
		return result;
	}
	protected abstract FileEdit getEditor();
	
	protected void runCurrentLine() {
		final FileEdit editor = getEditor();

		int n = editor.getSelectionStart();
		String line = editor.getLineForPosition(n);
		theApp.consoleOutput(JInterface.MTYOFM, line + "\n");
		theApp.callJ(line);
	}
	
	public void requestWindowSelect() {
		
		AlertDialog.Builder builder = new AlertDialog.Builder(this);
		ArrayAdapter<String> add = new ArrayAdapter<String>(this,
				R.layout.list_item, theApp.getWindowsAsArray());
		final ListView lv = new ListView(this);
		lv.setAdapter(add);
		builder.setView(lv);
		final AlertDialog ad = builder.create();

		lv.setOnItemClickListener(new AdapterView.OnItemClickListener() {

			public void onItemClick(AdapterView<?> arg0, View vv, int index,
					long id) {
				TextView ttv = ((TextView) vv);
				String ss = new StringBuilder(ttv.getText()).toString();
				
				theApp.setWindow(AbstractActivity.this,ss);
				ad.dismiss();
			}
		});
		
		ad.show();
		
	}

	protected void showHistoryDialog() {
		AlertDialog.Builder builder = new AlertDialog.Builder(this);
		
		String [] his = theApp.getHistoryAsArray();
		AlertDialog myadd;
		if(his.length > 0) {
			ArrayAdapter<String> add = new ArrayAdapter<String>(this, R.layout.list_item, his);
			final ListView lv = new ListView(this);
			
			lv.setAdapter(add);
			builder.setView(lv);
			
			final FileEdit editor = getEditor();
			
			final AlertDialog ad = myadd = builder.create();
			lv.setOnItemClickListener(new AdapterView.OnItemClickListener() {
				public void onItemClick(AdapterView<?> v, View vv, int index,
						long id) {
					TextView tv = (TextView) vv;
					String text = new StringBuilder(tv.getText()).toString();
					if(editor instanceof Console) {
						theApp.consoleOutput(JInterface.MTYOFM, text);
					} else {
						Editable ed = editor.getEditableText();
						int n = editor.getSelectionStart();
						ed.insert(n, text);
						editor.setSelection(n+text.length());
					}
					ad.dismiss();
				}
			});
		} else {
			builder.setView(emptyView());
			myadd = builder.create();
		}
		myadd.show();
	}
	
	protected View emptyView() {
		TextView view = new TextView(this);
		view.setPadding(4, 4, 4, 4);
		view.setBackgroundColor(0xff000000);
		view.setTextColor(0xffffffff);
		view.setText(EMPTY);
		return view;
	}
	

	protected String[] filterFilelist(File dir, List<String> files, int nfiles) {
		List<String> res = files;
		if(nfiles == 0) {
			files.add(EMPTY);
		}
		res = new ArrayList<String>(files.size());
		for (String s : files) {
			Log.d(JConsoleApp.LogTag,"testing " + s);
			File f = new File(dir, s);
			if (s.startsWith("..") || f.isDirectory()) {
				Log.d(JConsoleApp.LogTag,f.getAbsolutePath() + " is a directory");
				res.add(s + "/");
			} else {
				Log.d(JConsoleApp.LogTag,f.getAbsolutePath() + " is a file");
				res.add(s);
			}
		}

		String[] r = res.toArray(new String[res.size()]);
		if(nfiles > 0) Arrays.sort(r, new FileComparator(dir));
		return r;
}


	
	protected AlertDialog fileListDialog(File dir,ListView lv,boolean dirsOnly) {
		AlertDialog.Builder builder = new AlertDialog.Builder(this);
		try {
			if(dir.exists()) {
				ArrayAdapter<String> add = createDirAdapter(dir,dirsOnly);
				lv.setAdapter(add);
				String title =  filePath(dir.getCanonicalPath());
				if(title == null || title.length() == 0 || title.equals("/mnt/sdcard") || title.equals("/sdcard")) {
					title = "/";
				}
				builder.setTitle(title);
				builder.setView(lv);
			} else {
				theApp.setLocalFile(true);
				theApp.setCurrentDirectory(root);
				builder.setMessage(dir.getAbsolutePath() + " does not exist.");
			}
			return builder.create();
		} catch(IOException e) {
			Log.e(JConsoleApp.LogTag,"error creating file list",e);
		}
		return null;
	}
	
	public void requestFileOpen() {
		
		File f = theApp.getCurrentDirectory();
		FileAction fs = new OpenEditorAction(); 
		requestFileSelect(f,fs);
	}
	
	
	

	public void requestFileRun() {
		
		File f = theApp.getCurrentDirectory();
		
		FileAction fs = new RunFileAction(); 
		requestFileSelect(f,fs);
	}
	
	interface  FileAction {
		public void useFile(File f);
	}
	
	class OpenEditorAction implements FileAction {
		public void useFile(File f) {
Log.d(JConsoleApp.LogTag,"OpenEditorAction.useFile()");
			Intent intent = new Intent();
			intent.setClass(getApplicationContext(), EditActivity.class);

			intent.putExtra("file", f.getAbsolutePath());
			theApp.setCurrentDirectory(f.getParentFile());
			
			
			startActivity(intent);
		}
	}
	
	protected void runFile(File f) {
		StringBuilder sb = new StringBuilder("load '");
		sb.append(f.getAbsolutePath()).append("'");
		theApp.consoleOutput(JInterface.MTYOFM, sb.toString() + "\n");
		theApp.callJ(sb.toString());
	}

	class RunFileAction implements FileAction {
		public void useFile(File f) {
			runFile(f);
		}
		
	}

	class SaveAsAction implements FileAction {
		
		EditText et;
		public SaveAsAction(EditText et) {
			this.et = et;
		}
		
		public void useFile(File f) {
			et.setText(f.getName());
		}
		
	}
	public void requestFileSaveAs(File ff) {
		final EditText et = new EditText(AbstractActivity.this);
		et.setLayoutParams(new ViewGroup.LayoutParams(
			ViewGroup.LayoutParams.FILL_PARENT, 
			ViewGroup.LayoutParams.WRAP_CONTENT));
		et.setSingleLine();
		et.setText(ff.getName());
		et.setInputType(InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
		
		FileAction fs = new SaveAsAction(et); 
		File dir = ff.getParentFile();
		theApp.setCurrentDirectory(dir);
		requestFileSelect(dir,fs,et);
	}
	
	public void requestFileSelect(File dir, final FileAction ffa) {
		requestFileSelect(dir, ffa, null);
	}
	

	@Override
	public boolean onSearchRequested() {
		showHistoryDialog();
		return true;
	}
	public void showHelp(int resId) {
		Intent myIntent = new Intent(Intent.ACTION_VIEW,
			Uri.parse(getResources().getString(resId)));
		startActivity(myIntent);	
	}
	public void showTextFile(int resId) {
		Intent intent = new Intent();
		intent.setClass(this.getApplicationContext(), HelpActivity.class);
		
		intent.putExtra("file", getResources().getString(resId));
		intent.putExtra("base", root.getAbsolutePath());
		this.startActivity(intent);

	}
	protected void callBreak() {
		theApp.getjInterface().callSuperJ(new String[]{"break_z_ ''"});
	}

	public void quit() {
		super.finish();
		theApp.stop();		int pid = android.os.Process.myPid();
		android.os.Process.killProcess(pid);
	}

	public void testQuit() {
		AlertDialog.Builder builder = new AlertDialog.Builder(this);
		builder.setMessage("Are you sure you want to exit J?")
			.setCancelable(false)
			.setPositiveButton("Yes",
				new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int id) {
						quit();
					}
				})
			.setNegativeButton("No", new DialogInterface.OnClickListener() {
				public void onClick(DialogInterface dialog, int id) {
					dialog.cancel();
				}
			});
		AlertDialog dialog = builder.create();
		dialog.show();
		
	}

	protected FileEdit openFileEditor(File f) {
		FileEdit ef = new FileEdit(this);
		try {
			ef.setName(f.getName());
			ef.open(f);
		} catch(IOException e) {
			Log.e(JConsoleApp.LogTag,"error opening file",e);
		}
		return ef;
	}


	protected String filePath(String path) {
		String rp = root.getAbsolutePath();
		if (path.startsWith(rp)) {
			path = path.substring(rp.length());
		}
		return path;
	}
	public String buildTitle(File f)  throws IOException {
		String title =  filePath(f.getCanonicalPath());
		if(title == null || title.length() == 0 || title.equals("/mnt/sdcard") || title.equals("/sdcard")) {
			title = "/";
		}
		return (theApp.isLocalFile() ? "local: " : "sdcard: ") + title;
	}

//	public abstract String buildTitle(File f)  throws IOException;

	public void requestFileSelect(final File dir, final FileAction ffa,
			final TextView textView) {
Log.d(JConsoleApp.LogTag,"in request file select");		
		AlertDialog.Builder builder = new AlertDialog.Builder(this);

		final LinearLayout ll = new LinearLayout(AbstractActivity.this);
		ll.setLayoutParams(new ViewGroup.LayoutParams(
			ViewGroup.LayoutParams.FILL_PARENT, 
			ViewGroup.LayoutParams.FILL_PARENT));
		ll.setOrientation(LinearLayout.VERTICAL);

		final ListView lv = new ListView(this);
		lv.setFastScrollEnabled(true);

		ArrayAdapter<String> add = createDirAdapter(dir,false);
		lv.setAdapter(add);
		
		Button save = null;
		Button cancel = null;
		try {
			ll.addView(lv);

			if(textView != null) {
				LinearLayout hl = new LinearLayout(AbstractActivity.this);
				hl.setLayoutParams(new ViewGroup.LayoutParams(
						ViewGroup.LayoutParams.FILL_PARENT, 
						ViewGroup.LayoutParams.FILL_PARENT));
				hl.setOrientation(LinearLayout.HORIZONTAL);

				save = new Button(this);
				save.setLayoutParams(new LinearLayout.LayoutParams(
						ViewGroup.LayoutParams.FILL_PARENT, 
						ViewGroup.LayoutParams.WRAP_CONTENT,1f));
				save.setGravity(Gravity.CENTER);
				save.setText("Save");
				
				hl.addView(save);

				cancel = new Button(this);
				cancel.setLayoutParams(new LinearLayout.LayoutParams(
						ViewGroup.LayoutParams.FILL_PARENT, 
						ViewGroup.LayoutParams.WRAP_CONTENT,1f));
				cancel.setText("Cancel");
				cancel.setTextAppearance(this, 12);
				
				cancel.setGravity(Gravity.CENTER);
				hl.addView(cancel);
				
				ll.addView(textView);
				ll.addView(hl);
			}
			final Button dev = new Button(this);
			dev.setLayoutParams(new ViewGroup.LayoutParams(
				ViewGroup.LayoutParams.FILL_PARENT, 
				ViewGroup.LayoutParams.FILL_PARENT));
			dev.setText("browse " + (theApp.isLocalFile() ? "sdcard" : "local"));
			ll.addView(dev);

			builder.setTitle(buildTitle(dir));
			builder.setView(ll);
			
			final AlertDialog ad = builder.create();
			
			dev.setOnClickListener(new View.OnClickListener() {
				public void onClick(View vv) {
					theApp.setLocalFile(!theApp.isLocalFile());
					File newfile = theApp.getCurrentDirectory();
					ad.dismiss();
					ll.removeView(textView);
					requestFileSelect(newfile, ffa, textView);
				}
			});

			lv.setOnItemClickListener(new AdapterView.OnItemClickListener() {
				public void onItemClick(AdapterView<?> arg0, View vv,
						int index, long id) {
					TextView ttv = ((TextView) vv);
					File d = theApp.getCurrentDirectory();
					String ss = ttv.getText().toString();
					File newfile = ss.startsWith("..") ? d.getParentFile() : new File(d, ss);
					Log.d(JConsoleApp.LogTag, "file selected: " + newfile.getPath());
					
					if (newfile.isDirectory()) {
						Log.d(JConsoleApp.LogTag, "directory " + newfile.getPath());
						theApp.setCurrentDirectory(newfile);
						ArrayAdapter<String> add = createDirAdapter(newfile,false);
						lv.setAdapter(add);
						try {
							ad.setTitle(buildTitle(newfile));
						} catch(IOException e) {
							Log.e(JConsoleApp.LogTag,"error building title",e);
						}
						lv.setAdapter(add);
					} else {
						Log.d(JConsoleApp.LogTag, "file " + newfile.getPath());
						if(EMPTY.equals(ss)) {
							return;
						}
						ffa.useFile(newfile);
						if(textView == null) ad.dismiss();
					}
				}
			});
			
			if(save != null) save.setOnClickListener(new View.OnClickListener() {
				public void onClick(View v) {
					String name = new StringBuilder(textView.getText()).toString();
					File myfile = new File(theApp.getCurrentDirectory(),name);
					FileEdit fe = getEditor();
					try {
						theApp.saveAs(AbstractActivity.this,fe,myfile);
					} catch(IOException e) {
						Toast.makeText(AbstractActivity.this, "there was an error saving " + myfile.getName(), 
							Toast.LENGTH_LONG);
						Log.e(JConsoleApp.LogTag,"there was an error saving the file " + myfile.getName(),e);
					}
					ad.dismiss();
					
				}
			});
			if(cancel != null) cancel.setOnClickListener(new View.OnClickListener() {
				public void onClick(View v) {
					ad.cancel();
				}
			});
			ad.show();
		} catch(IOException e) {
			Log.e(JConsoleApp.LogTag,"an error occurred opening file dialog.",e);
		}
	}

	protected  List<String> loadFileList(File mPath,final  String ext,final boolean dirsOnly) {
		List<String> result = new ArrayList<String>();
		if (mPath.exists()) {
			FilenameFilter filter = new FilenameFilter() {
				public boolean accept(File dir, String filename) {
					File sel = new File(dir, filename);
					if(dirsOnly) {
						return sel.isDirectory();
					} else {
						return ext == null || filename.endsWith(ext)
							|| sel.isDirectory();
					}
				}
			};
			String[] r = mPath.list(filter);
			for (String ee : r) {
				result.add(ee);
			}
		}
		return result;
	}


	protected ArrayAdapter<String> createDirAdapter(File dir,boolean dirsOnly) {
		List<String> files = loadFileList(dir, null,dirsOnly);
		int nfiles = files.size();
		if(!(dir.equals(root) || dir.getAbsolutePath().equals("/mnt/sdcard") || dir.getAbsolutePath().equals("/sdcard"))) {
			files.add(0, "..");
		}
		String[] fl = filterFilelist(dir, files,nfiles);
		return new ArrayAdapter<String>(this,R.layout.list_item, fl);

	}
}
