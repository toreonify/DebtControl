unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, DBGrids, Menus,
  ComCtrls, DefaultTranslator;

type

  { TMainForm }

  TMainForm = class(TForm)
    DBGrid: TDBGrid;
    MainMenu: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    StatusBar: TStatusBar;
  private

  public

  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

end.

