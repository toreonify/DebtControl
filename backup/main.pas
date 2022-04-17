unit Main;

{$mode objfpc}{$H+}

interface

uses
  Database,
  LazLogger,
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, DBGrids, Menus,
  ComCtrls, DefaultTranslator, LCLTranslator, sqlite3conn;

type

  { TMainForm }

  TMainForm = class(TForm)
    ClientsGrid: TDBGrid;
    DebtsGrid: TDBGrid;
    SQLiteConnection: TSQLite3Connection;
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
begin
     // Open existing database or automatically create new
     OpenDatabase;
end;

end.

