unit Database;

{$mode objfpc}{$H+}

interface

uses
  LazLoggerBase, sqlite3conn,
  Classes, SysUtils;

procedure CreateNewDatabase(Connection : TSQLite3Connection);
procedure OpenDatabase(Connection : TSQLite3Connection);

implementation

procedure CreateNewDatabase(Connection : TSQLite3Connection);
begin
  try
    Connection.Open;
    Connection.Transaction.Active := true;

    Connection.ExecuteDirect('CREATE TABLE "clients"('+
                ' "id" Integer NOT NULL PRIMARY KEY AUTOINCREMENT,'+
                ' "firstName" varchar(256) NOT NULL,'+
                ' "lastName" varchar(256) NOT NULL,'+
                ' "middleName" varchar(256) NOT NULL,'+
                ' "limit" INTEGER NOT NULL);');

    Connection.ExecuteDirect('CREATE UNIQUE INDEX "clients_id_idx" ON "clients"( "id" );');

    Connection.ExecuteDirect('CREATE TABLE "debts"('+
                ' "id" Integer NOT NULL PRIMARY KEY AUTOINCREMENT,'+
                ' "clientId" Integer NOT NULL,'+
                ' "debt" Integer NOT NULL,'+
                ' "deadline" text NOT NULL,'+
                ' "limit" INTEGER NOT NULL,'+
                ' FOREIGN KEY(clientId) REFERENCES clients(id));');

    Connection.ExecuteDirect('CREATE UNIQUE INDEX "debts_id_idx" ON "debts"( "id" );');

    Connection.Transaction.Commit;

    DebugLn('Succesfully created database.');
  except
    DebugLn('Unable to Create new Database');
  end;
end;

procedure OpenDatabase(Connection : TSQLite3Connection);
begin
  Connection.Close;
  try
    if not FileExists(Connection.DatabaseName) then
        CreateNewDatabase(Connection);

    Connection.Open;
  except
    DebugLn('Unable to check if database file exists');
  end;
 end;

end.

