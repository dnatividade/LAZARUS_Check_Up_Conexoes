unit uPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, IdTCPClient, IdIcmpClient, LCLIntf,
  IdIOHandlerStack, IdHTTP, IdDNSResolver, IdIPWatch, IdWhois, Forms, Controls,
  Graphics, Dialogs, StdCtrls, Buttons, ActnList, Menus, ExtCtrls,
  {winsock2,} pingsend,
  ssl_openssl, https_get;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    Bevel1: TBevel;
    btTestar: TBitBtn;
    GetGatewayDNS: TAction;
    GetRealIP: TAction;
    IdDNSResolver1: TIdDNSResolver;
    IdHTTP1: TIdHTTP;
    IdIcmpClient1: TIdIcmpClient;
    IdIOHandlerStack1: TIdIOHandlerStack;
    IdIPWatch1: TIdIPWatch;
    IdWhois1: TIdWhois;
    CONNECTIVA: TImage;
    Label1: TLabel;
    Label2: TLabel;
    lbResolver: TLabel;
    lbPoweredBy: TLabel;
    lbRealIP: TLabel;
    lbResolverDNS: TLabel;
    lbStatus13: TLabel;
    LimpaCampos: TAction;
    ActionList1: TActionList;
    IdTCPClient1: TIdTCPClient;
    lbGw01: TLabel;
    lbSMTPS12: TLabel;
    lbIMAP09: TLabel;
    lbIMAPS10: TLabel;
    lbDNS02: TLabel;
    lbDNS04: TLabel;
    lbHTTP05: TLabel;
    lbHTTPS06: TLabel;
    lbPOP307: TLabel;
    lbPOP3S08: TLabel;
    lbSMTP11: TLabel;
    lbStatus01: TLabel;
    lbStatus02: TLabel;
    lbStatus11: TLabel;
    lbStatus12: TLabel;
    lbStatus04: TLabel;
    lbStatus05: TLabel;
    lbStatus06: TLabel;
    lbStatus07: TLabel;
    lbStatus10: TLabel;
    lbStatus09: TLabel;
    lbStatus08: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    Panel1: TPanel;
    procedure btTestarClick(Sender: TObject);
    procedure CONNECTIVAClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GetGatewayDNSExecute(Sender: TObject);
    procedure GetRealIPExecute(Sender: TObject);
    procedure LimpaCamposExecute(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    function TestaPortaTCP(Host: String; Port: Word; Timeout: Integer): Boolean;
    function PingaHost(Host1: String): boolean;
    function DNSResolver: boolean;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses uConfig, uConstantes, utestaportas;

{$R *.lfm}

{ TfrmMain }

function TfrmMain.TestaPortaTCP(Host: String; Port: Word; Timeout: Integer): Boolean;
var
 IdTCPClient: TIdTCPClient;
begin
 try
   result:= false;
   IdTCPClient:= TIdTCPClient.Create(Nil);
   IdTCPClient.ReadTimeout:= Timeout;
   IdTCPClient.Host:= Host;
   IdTCPClient.Port:= Port;
   try
     IdTCPClient.Connect;
   except
     IdTCPClient.Disconnect;
     result:= false;
     exit;
   end;
   IdTCPClient.Disconnect;
   result:= true;
 finally
   FreeAndNil(IdTCPClient);
 end;
end;

////////////////////////////////////////////////////////////////////////////////
function TfrmMain.PingaHost(Host1: String): boolean;
var PingSend: TPINGSend;
    resultado: boolean;
begin
 PingSend := TPINGSend.Create;
 try
   PingSend.Timeout:= 1000;
   if PingSend.Ping(Host1) = true then
     resultado:= true
     else
       resultado:= false;
  finally
    PingSend.Free;
  end;
  result:= resultado;
end;

function TfrmMain.DNSResolver: boolean;
var qrA: TARecord;
    res: boolean;
begin
 try
  IdDNSResolver1.Host:= SRV_DNS;
  IdDNSResolver1.QueryType:= [qtA];
  IdDNSResolver1.Resolve(HOST_EXTERNO);
  qrA:= TARecord(IdDNSResolver1.QueryResult[0]);
  lbResolver.Caption:= qrA.IPAddress;
  res:= true;
 except
   lbResolver.Caption:= '0.0.0.0';
   res:= false
 end;
 result:= res;
end;
////////////////////////////////////////////////////////////////////////////////

procedure TfrmMain.btTestarClick(Sender: TObject);
begin
 btTestar.Enabled:= false;
 LimpaCampos.Execute;
 GetRealIP.Execute;
 //http://blog.atlabs.com.br/2012/10/teste-de-conexao-tcp-port-indy-10.html
 //
 //Testa conexão com a Internet: ping 8.8.4.4
 Application.ProcessMessages;
 lbResolverDNS.Caption:= 'Resolver DNS: '+HOST_EXTERNO;

 if PingaHost(IP_EXTERNO) then
 begin
   lbStatus01.Font.Color:= clGreen;
   lbStatus01.Caption:= 'PASSOU';
   lbGw01.Enabled:= true;
   Application.ProcessMessages;
 end
   else
   begin
     lbStatus01.Font.Color:= clRed;
     lbStatus01.Caption:= 'FALHOU';
     lbGw01.Enabled:= true;
     Application.ProcessMessages;
   end;

 //Testa conexão com a Internet: ping google.com
 Application.ProcessMessages;
 if PingaHost(HOST_EXTERNO) then
 begin
   lbStatus02.Font.Color:= clGreen;
   lbStatus02.Caption:= 'PASSOU';
   lbDNS02.Enabled:= true;
   Application.ProcessMessages;
 end
   else
   begin
     lbStatus02.Font.Color:= clRed;
     lbStatus02.Caption:= 'FALHOU';
     lbDNS02.Enabled:= true;
     Application.ProcessMessages;
   end;

 //Testa conexão com um servidor DNS na porta 53/tcp
 Application.ProcessMessages;
 if TestaPortaTCP(SRV_DNS, 53, 1000) then
 begin
   lbStatus04.Font.Color:= clGreen;
   lbStatus04.Caption:= 'PASSOU';
   lbDNS04.Enabled:= true;
   Application.ProcessMessages;
 end
   else
   begin
     lbStatus04.Font.Color:= clRed;
     lbStatus04.Caption:= 'FALHOU';
     lbDNS04.Enabled:= true;
     Application.ProcessMessages;
   end;

  //Testa conexão com um servidor HTTP na porta 80/tcp
  Application.ProcessMessages;
  if TestaPortaTCP(SRV_HTTP, 80, 1000) then
  begin
    lbStatus05.Font.Color:= clGreen;
    lbStatus05.Caption:= 'PASSOU';
    lbHTTP05.Enabled:= true;
    Application.ProcessMessages;
  end
    else
    begin
      lbStatus05.Font.Color:= clRed;
      lbStatus05.Caption:= 'FALHOU';
      lbHTTP05.Enabled:= true;
      Application.ProcessMessages;
    end;

  //Testa conexão com um servidor HTTPS na porta 443/tcp
  Application.ProcessMessages;
  if TestaPortaTCP(SRV_HTTPS, 443, 1000) then
  begin
    lbStatus06.Font.Color:= clGreen;
    lbStatus06.Caption:= 'PASSOU';
    lbHTTPS06.Enabled:= true;
    Application.ProcessMessages;
  end
    else
    begin
      lbStatus06.Font.Color:= clRed;
      lbStatus06.Caption:= 'FALHOU';
      lbHTTPS06.Enabled:= true;
      Application.ProcessMessages;
    end;

  //Testa conexão com um servidor POP3 na porta 110/tcp
  Application.ProcessMessages;
  if TestaPortaTCP(SRV_POP3, 110, 1000) then
  begin
    lbStatus07.Font.Color:= clGreen;
    lbStatus07.Caption:= 'PASSOU';
    lbPOP307.Enabled:= true;
    Application.ProcessMessages;
  end
    else
    begin
      lbStatus07.Font.Color:= clRed;
      lbStatus07.Caption:= 'FALHOU';
      lbPOP307.Enabled:= true;
      Application.ProcessMessages;
    end;

  //Testa conexão com um servidor POP3S na porta 995/tcp
  Application.ProcessMessages;
  if TestaPortaTCP(SRV_POP3S, 995, 1000) then
  begin
    lbStatus08.Font.Color:= clGreen;
    lbStatus08.Caption:= 'PASSOU';
    lbPOP3S08.Enabled:= true;
    Application.ProcessMessages;
  end
    else
    begin
      lbStatus08.Font.Color:= clRed;
      lbStatus08.Caption:= 'FALHOU';
      lbPOP3S08.Enabled:= true;
      Application.ProcessMessages;
    end;

  //Testa conexão com um servidor IMAP na porta 143/tcp
  Application.ProcessMessages;
  if TestaPortaTCP(SRV_IMAP, 143, 1000) then
  begin
    lbStatus09.Font.Color:= clGreen;
    lbStatus09.Caption:= 'PASSOU';
    lbIMAP09.Enabled:= true;
    Application.ProcessMessages;
  end
    else
    begin
      lbStatus09.Font.Color:= clRed;
      lbStatus09.Caption:= 'FALHOU';
      lbIMAP09.Enabled:= true;
      Application.ProcessMessages;
    end;

  //Testa conexão com um servidor IMAPS na porta 993/tcp
  Application.ProcessMessages;
  if TestaPortaTCP(SRV_IMAPS, 993, 1000) then
  begin
    lbStatus10.Font.Color:= clGreen;
    lbStatus10.Caption:= 'PASSOU';
    lbIMAPS10.Enabled:= true;
    Application.ProcessMessages;
  end
    else
    begin
      lbStatus10.Font.Color:= clRed;
      lbStatus10.Caption:= 'FALHOU';
      lbIMAPS10.Enabled:= true;
      Application.ProcessMessages;
    end;

  //Testa conexão com um servidor SMTP na porta 587/tcp
  Application.ProcessMessages;
  if TestaPortaTCP(SRV_SMTP, 587, 1000) then
  begin
    lbStatus11.Font.Color:= clGreen;
    lbStatus11.Caption:= 'PASSOU';
    lbSMTP11.Enabled:= true;
    Application.ProcessMessages;
  end
    else
    begin
      lbStatus11.Font.Color:= clRed;
      lbStatus11.Caption:= 'FALHOU';
      lbSMTP11.Enabled:= true;
      Application.ProcessMessages;
    end;

  //Testa conexão com um servidor SMTPS na porta 465/tcp
  Application.ProcessMessages;
  if TestaPortaTCP(SRV_SMTPS, 465, 1000) then
  begin
    lbStatus12.Font.Color:= clGreen;
    lbStatus12.Caption:= 'PASSOU';
    lbSMTPS12.Enabled:= true;
    Application.ProcessMessages;
  end
    else
    begin
      lbStatus12.Font.Color:= clRed;
      lbStatus12.Caption:= 'FALHOU';
      lbSMTPS12.Enabled:= true;
      Application.ProcessMessages;
    end;

    //TESTE DE DNS RESOLVER
    if DNSResolver then
    begin
      lbStatus13.Font.Color:= clGreen;
      lbStatus13.Caption:= 'PASSOU';
    end
    else
    begin
      lbStatus13.Font.Color:= clRed;
      lbStatus13.Caption:= 'FALHOU';
    end;
    //
    btTestar.Enabled:= true;
end;

procedure TfrmMain.CONNECTIVAClick(Sender: TObject);
begin
  OpenURL(WEBSITE);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  LimpaCampos.Execute;
end;

procedure TfrmMain.GetGatewayDNSExecute(Sender: TObject);
begin
  ShowMessage(IdIPWatch1.LocalIP);
end;

procedure TfrmMain.GetRealIPExecute(Sender: TObject);
var
  g: THTTPS;
  url : string = 'https://ifconfig.me/';
  r, err : string;

begin
  g:= THTTPS.Create(nil);
  g.HTTP_Get(url, r, err);
  FreeAndNil(g);
  lbRealIP.Caption:= r;
  lbPoweredBy.Caption:= '(by: '+url+')';
end;

procedure TfrmMain.LimpaCamposExecute(Sender: TObject);
begin
 frmMain.Caption:= Application.Title + ' - v:' + VERSION;
 //
 lbGw01.Enabled:= false;
 lbDNS02.Enabled:= false;
 //lbDNS03.Enabled:= false;
 lbDNS04.Enabled:= false;
 lbHTTP05.Enabled:= false;
 lbHTTPS06.Enabled:= false;
 lbPOP307.Enabled:= false;
 lbPOP3S08.Enabled:= false;
 lbIMAP09.Enabled:= false;
 lbIMAPS10.Enabled:= false;
 lbSMTP11.Enabled:= false;
 lbSMTPS12.Enabled:= false;
 //
 lbRealIP.Caption:= '0.0.0.0';
 lbPoweredBy.Caption:= '-';
 lbStatus01.Caption:= '__________';
 lbStatus01.Font.Color:= clDefault;
 lbStatus02.Caption:= '__________';
 lbStatus02.Font.Color:= clDefault;
 lbStatus04.Caption:= '__________';
 lbStatus04.Font.Color:= clDefault;
 lbStatus05.Caption:= '__________';
 lbStatus05.Font.Color:= clDefault;
 lbStatus06.Caption:= '__________';
 lbStatus06.Font.Color:= clDefault;
 lbStatus07.Caption:= '__________';
 lbStatus07.Font.Color:= clDefault;
 lbStatus08.Caption:= '__________';
 lbStatus08.Font.Color:= clDefault;
 lbStatus09.Caption:= '__________';
 lbStatus09.Font.Color:= clDefault;
 lbStatus10.Caption:= '__________';
 lbStatus10.Font.Color:= clDefault;
 lbStatus11.Caption:= '__________';
 lbStatus11.Font.Color:= clDefault;
 lbStatus12.Caption:= '__________';
 lbStatus12.Font.Color:= clDefault;
end;

procedure TfrmMain.MenuItem2Click(Sender: TObject);
begin
  frmConfig.ShowModal;
end;

procedure TfrmMain.MenuItem4Click(Sender: TObject);
begin
  frmTestaPortas.ShowModal;
end;

procedure TfrmMain.MenuItem5Click(Sender: TObject);
begin
  ShowMessage(Application.Title + ' - v:' + VERSION+#13+
              'Desenvolvido e distribuido sob licença MIT por:'+#13+
              AUTHOR+#13+
              PHONE+#13+
              EMAIL+#13+
              WEBSITE);
end;

end.

