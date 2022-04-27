unit Main;

{$mode objfpc}{$H+}

interface

uses
  Database, LazLoggerBase, baseunix,
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, DBGrids, Menus,
  ComCtrls, DefaultTranslator, LCLTranslator, sqlite3conn, sqldb;

type

  { TMainForm }

  TMainForm = class(TForm)
    ClientsGrid: TDBGrid;
    DebtsGrid: TDBGrid;
    SQLiteConnection: TSQLite3Connection;
    SQLTransaction: TSQLTransaction;
    Tables: TPageControl;
    Debts: TTabSheet;
    Clients: TTabSheet;
    ToolbarImages: TImageList;
    MainMenu: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    StatusBar: TStatusBar;
    ToolBar: TToolBar;
    AddDebtor: TToolButton;
    RemoveDebtor: TToolButton;
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
var
  ConfigDirectory : string;
begin
     DebugLn('Started');

     // Find SQLite library
     {$IFDEF UNIX}  // Linux
        {$IFNDEF DARWIN}
          SQLiteDefaultLibrary := 'libsqlite3.so';
        {$ENDIF}
        {$IFDEF DARWIN}
          SQLiteLibraryName := '/usr/lib/libsqlite3.dylib';
        {$ENDIF}
     {$ENDIF}

     {$IFDEF WINDOWS} // Windows
       SQLiteDefaultLibrary := 'sqlite3.dll';
     {$ENDIF}

     // Check database file
     ConfigDirectory := GetAppConfigDir(false);
     DebugLn(ConfigDirectory);

     if not DirectoryExists(ConfigDirectory) then
     begin
        try
           MkDir(ConfigDirectory);
        except
           ShowMessage('Cannot create configuration directory: ' + ConfigDirectory);
           exit;
        end;
     end;

     if FileExists(Connection.DatabaseName) then
       if fpAccess(ConfigDirectory + 'db.sqlite', W_OK) <> 0 then
       begin
          ShowMessage('Cannot write to database file: ' + ConfigDirectory + 'db.sqlite');
          exit;
       end;

     // Open existing database or automatically create new
     SQLiteConnection.DatabaseName := ConfigDirectory + 'db.sqlite';
     OpenDatabase(SQLiteConnection);
end;

end.

