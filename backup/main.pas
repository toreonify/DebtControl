unit Main;

{$mode objfpc}{$H+}

interface

uses
  Database, LazLoggerBase, baseunix, Classes, SysUtils, Forms, Controls, LCLType,
  Graphics, Dialogs, DBGrids, Menus, ComCtrls, DefaultTranslator, LCLTranslator,
  DBCtrls, sqlite3conn, sqldb, sqldblib, db, BufDataset, addDebtModal;

type

  { TMainForm }

  TMainForm = class(TForm)
    ClientsGrid: TDBGrid;
    DebtsDataSource: TDataSource;
    DebtsGrid: TDBGrid;
    SQLDBLibraryLoader: TSQLDBLibraryLoader;
    SQLiteConnection: TSQLite3Connection;
    DebtsQuery: TSQLQuery;
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
    procedure AddDebtorClick(Sender: TObject);
    procedure DebtsGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DebtsQueryAfterPost(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure RemoveDebtorClick(Sender: TObject);
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
          SQLDBLibraryLoader.LibraryName := 'libsqlite3.so';
        {$ENDIF}
        {$IFDEF DARWIN}
          SQLDBLibraryLoader.LibraryName := '/usr/lib/libsqlite3.dylib';
        {$ENDIF}
     {$ENDIF}

     {$IFDEF WINDOWS} // Windows
       SQLDBLibraryLoader.LibraryName := 'sqlite3.dll';
     {$ENDIF}

     SQLDBLibraryLoader.Enabled := true;
     SQLDBLibraryLoader.LoadLibrary;

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

     if FileExists(SQLiteConnection.DatabaseName) then
       if fpAccess(ConfigDirectory + 'db.sqlite', W_OK) <> 0 then
       begin
          ShowMessage('Cannot write to database file: ' + ConfigDirectory + 'db.sqlite');
          exit;
       end;

     // Open existing database or automatically create new
     SQLiteConnection.DatabaseName := ConfigDirectory + 'db.sqlite';
     OpenDatabase(SQLiteConnection);

     // Load data
     DebtsQuery.Active := true;

     //DebtsGrid.Columns.Items[1].PickList.Clear;
     //DebtsGrid.Columns.Items[1].PickList.AddStrings(SList);
end;

procedure TMainForm.RemoveDebtorClick(Sender: TObject);
begin
   DebtsQuery.Delete;
end;

procedure TMainForm.AddDebtorClick(Sender: TObject);
begin
   if AddDebtModalForm.ShowModal = 0 then
   begin
      //DebtsQuery.Append;
   end
   else
       ShowMessage('Modal returned error');
end;

procedure TMainForm.DebtsGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
     if DebtsQuery.State in [TDatasetState.dsEdit, TDatasetState.dsInsert] then
         DebtsQuery.Post;
end;

procedure TMainForm.DebtsQueryAfterPost(DataSet: TDataSet);
begin
  DebtsQuery.ApplyUpdates;
  SQLTransaction.CommitRetaining;
end;

procedure TMainForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  DebtsQuery.Close;
  SQLTransaction.Active:= False;
  SQLiteConnection.Connected:= False;
end;

end.

