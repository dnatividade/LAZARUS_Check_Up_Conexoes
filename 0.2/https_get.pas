unit https_get;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fphttpclient, ssockets, fpopenssl, sslsockets;
  //needs : https://indy.fulgan.com/SSL/openssl-1.0.2l-x64_86-win64.zip

type
  THTTPS = class(TFPHTTPClient)
  private
    _ClientCertificate: string;
    procedure SSLClientCertSetup(Sender: TObject; const UseSSL: boolean; out AHandler: TSocketHandler);
  public
    function HTTP_Get(AURL: string; var AResponse: string; var AError: string; CertifPath: string = ''): boolean;
  end;

implementation

procedure THTTPS.SSLClientCertSetup(Sender: TObject; const UseSSL: boolean; out AHandler: TSocketHandler);
begin
  AHandler := nil;

  if UseSSL and (_ClientCertificate <> '') then
  begin
    AHandler := TSSLSocketHandler.Create;
//    (AHandler as TSSLSocketHandler).SSLType := stTLSv1;

    (AHandler as TSSLSocketHandler).Certificate.FileName := _ClientCertificate;
    (AHandler as TSSLSocketHandler).PrivateKey.FileName := _ClientCertificate;
  end;
end;

function THTTPS.HTTP_Get(AURL: string; var AResponse: string; var AError: string; CertifPath: string = ''): boolean;
begin
  Result := False;
  _ClientCertificate := CertifPath;
  if CertifPath <> '' then
    OnGetSocketHandler := @SSLClientCertSetup;
  try
    AResponse := Get(AURL);
    Result := True;
  except
    on E: Exception do
    begin
      AError := E.ClassName + '/' + E.Message;
    end;
  end;
end;

end.
