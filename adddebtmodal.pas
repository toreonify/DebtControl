unit AddDebtModal;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Buttons;

type

  { TAddDebtModalForm }

  TAddDebtModalForm = class(TForm)
    DoneButton: TBitBtn;
    procedure DoneButtonClick(Sender: TObject);
  private

  public

  end;

var
  AddDebtModalForm: TAddDebtModalForm;

implementation

{$R *.lfm}

{ TAddDebtModalForm }

procedure TAddDebtModalForm.DoneButtonClick(Sender: TObject);
begin
  self.ModalResult := 1;
end;

end.

