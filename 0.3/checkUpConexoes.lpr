program checkUpConexoes;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, uPrincipal, opensslsockets, https_get, laz_synapse, indylaz, uConfig,
  uConstantes, utestaportas;

{$R *.res}

begin
  Application.Title:='Check-up de conexão com a Internet';
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmConfig, frmConfig);
  Application.CreateForm(TfrmTestaPortas, frmTestaPortas);
  Application.Run;
end.

