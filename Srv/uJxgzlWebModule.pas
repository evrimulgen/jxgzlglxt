unit uJxgzlWebModule;

interface

uses
  SysUtils, Classes, HTTPApp, InvokeRegistry, WSDLIntf, TypInfo, WebServExp,
  WSDLBind, XMLSchema, WSDLPub, SOAPPasInv, SOAPHTTPPasInv, SOAPHTTPDisp,
  WebBrokerSOAP;

type
  TjxgzlWebModule = class(TWebModule)
    HTTPSoapDispatcher1: THTTPSoapDispatcher;
    HTTPSoapPascalInvoker1: THTTPSoapPascalInvoker;
    WSDLHTMLPublish1: TWSDLHTMLPublish;
    procedure WebModule3DefaultHandlerAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  jxgzlWebModule: TjxgzlWebModule;

implementation

uses WebReq;

{$R *.dfm}

procedure TjxgzlWebModule.WebModule3DefaultHandlerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  WSDLHTMLPublish1.ServiceInfo(Sender, Request, Response, Handled);
end;

initialization
  WebRequestHandler.WebModuleClass := TjxgzlWebModule;

end.
