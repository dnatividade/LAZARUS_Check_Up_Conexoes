unit uConfig;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ExtCtrls;

type

  { TfrmConfig }

  TfrmConfig = class(TForm)
    btSalvar: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    edIPExterno: TEdit;
    edSrvSMTPS: TEdit;
    edSrvHTTPS: TEdit;
    edHostExterno: TEdit;
    edSrvDNS: TEdit;
    edSrvHTTP: TEdit;
    edSrvPOP3: TEdit;
    edSrvPOP3S: TEdit;
    edSrvIMAP: TEdit;
    edSrvIMAPS: TEdit;
    edSrvSMTP: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    procedure btSalvarClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  frmConfig: TfrmConfig;

implementation

uses uPrincipal, uConstantes;

{$R *.lfm}

{ TfrmConfig }

procedure TfrmConfig.BitBtn3Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmConfig.btSalvarClick(Sender: TObject);
begin
    IP_EXTERNO:=   edIPExterno.Text;
    HOST_EXTERNO:= edHostExterno.Text;
    SRV_DNS:=      edSrvDNS.Text;
    SRV_HTTP:=     edSrvHTTP.Text;
    SRV_HTTPS:=    edSrvHTTPS.Text;
    SRV_POP3:=     edSrvPOP3.Text;
    SRV_POP3S:=    edSrvPOP3S.Text;
    SRV_IMAP:=     edSrvIMAP.Text;
    SRV_IMAPS:=    edSrvIMAPS.Text;
    SRV_SMTP:=     edSrvSMTP.Text;
    SRV_SMTPS:=    edSrvSMTPS.Text;
    //
    Close;
end;

procedure TfrmConfig.BitBtn2Click(Sender: TObject);
begin
  with frmMain do
  begin
    edIPExterno.Text:= IP_EXTERNO;
    edHostExterno.Text:= HOST_EXTERNO;
    edSrvDNS.Text:= SRV_DNS;
    edSrvHTTP.Text:= SRV_HTTP;
    edSrvHTTPS.Text:= SRV_HTTPS;
    edSrvPOP3.Text:= SRV_POP3;
    edSrvPOP3S.Text:= SRV_POP3S;
    edSrvIMAP.Text:= SRV_IMAP;
    edSrvIMAPS.Text:= SRV_IMAPS;
    edSrvSMTP.Text:= SRV_SMTP;
    edSrvSMTPS.Text:= SRV_SMTPS;
  end;
  //Close;
end;

procedure TfrmConfig.FormCreate(Sender: TObject);
begin
  edIPExterno.Text:=   IP_EXTERNO;
  edHostExterno.Text:= HOST_EXTERNO;
  edSrvDNS.Text:=      SRV_DNS;
  edSrvHTTP.Text:=     SRV_HTTP;
  edSrvHTTPS.Text:=    SRV_HTTPS;
  edSrvPOP3.Text:=     SRV_POP3;
  edSrvPOP3S.Text:=    SRV_POP3S;
  edSrvIMAP.Text:=     SRV_IMAP;
  edSrvIMAPS.Text:=    SRV_IMAPS;
  edSrvSMTP.Text:=     SRV_SMTP;
  edSrvSMTPS.Text:=    SRV_SMTPS;
end;

end.

