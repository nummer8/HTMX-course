program webserver;

{$mode objfpc}{$H+}

uses
  SysUtils,
  Classes,
  fpwebfile,
  fpmimetypes,
  fphttpapp,
  httproute,
  httpdefs,
  fpjson,
  jsonparser;

const
  MyMime = 'mime.types';
  UploadDir = 'upfiles/';


var
  aDir: string;

  //In real applications, CopyFile should be used from unit FileUtil of the LCL
  function CopyTheFile(const SrcFilename, DestFilename: string): boolean;
  var
    SrcFS, DestFS: TFileStream;
  begin
    Result := False;
    SrcFS := TFileStream.Create(SrcFilename, fmOpenRead or fmShareDenyWrite);
    try
      DestFS := TFileStream.Create(DestFilename, fmCreate);
      try
        DestFS.CopyFrom(SrcFS, SrcFS.Size);
      finally
        DestFS.Free;
      end;
    finally
      SrcFS.Free;
    end;
    Result := True;
  end;



  procedure messageEndpoint(aRequest: TRequest; aResponse: TResponse);
  begin
    aResponse.content := '<div><h3>Hello World</h3></div>';
    aResponse.Code := 200;
    aResponse.ContentType := 'text/html; charset=utf-8';
    aResponse.ContentLength := length(aResponse.Content);
    aResponse.SendContent;
  end;

  procedure progressmessageEndpoint(aRequest: TRequest; aResponse: TResponse);
  begin
    sleep(7000);
    aResponse.content := '<div><h3>Hello World</h3></div>';
    aResponse.Code := 200;
    aResponse.ContentType := 'text/html; charset=utf-8';
    aResponse.ContentLength := length(aResponse.Content);
    aResponse.SendContent;
  end;

  procedure echopayloadEndpoint(aRequest: TRequest; aResponse: TResponse);
  var
    email, pass: string;
  begin
    email := aRequest.ContentFields.Values['email'];
    pass := aRequest.ContentFields.Values['pass'];
    aResponse.content := '<div><b>Email:</b>' + email +
      ', <b>Password:</b> ' + pass + '</div>';
    aResponse.Code := 200;
    aResponse.ContentType := 'text/html; charset=utf-8';
    aResponse.ContentLength := length(aResponse.Content);
    aResponse.SendContent;
  end;

  procedure echoEndpoint(aRequest: TRequest; aResponse: TResponse);
  begin
    aResponse.content := '<div><h3>Hello World</h3></div>';
    aResponse.Code := 200;
    aResponse.ContentType := 'text/html; charset=utf-8';
    aResponse.ContentLength := length(aResponse.Content);
    aResponse.SendContent;
  end;


  procedure uploadEndpoint(aRequest: TRequest; aResponse: TResponse);
  var
    FN: string;
    i: integer;
  begin
    for i := 0 to aRequest.Files.Count - 1 do
    begin
      FN := aRequest.Files[i].FileName;
      if (FN <> '') and (aRequest.Files[i].Size > 0) then
      begin
        CopyTheFile(aRequest.Files[i].LocalFileName, UploadDir + FN);
        //copy (or overwrite) the file to the upload dir
      end;
    end;

    aResponse.content := '<div><h3>Upload succesfull</h3></div>';
    aResponse.Code := 200;
    aResponse.ContentType := 'text/html; charset=utf-8';
    aResponse.ContentLength := length(aResponse.Content);
    aResponse.SendContent;
  end;


  procedure bigboxEndpoint(aRequest: TRequest; aResponse: TResponse);
  begin
    aResponse.content :=
      '<div id="growing-box" class="grow" style="height: 300px; width: 300px; background-color: blue;">Big Box </div>';
    aResponse.Code := 200;
    aResponse.ContentType := 'text/html; charset=utf-8';
    aResponse.ContentLength := length(aResponse.Content);
    aResponse.SendContent;
  end;

  procedure oobEndpoint(aRequest: TRequest; aResponse: TResponse);
  begin
    aResponse.content :=
      '<div> <h3 id="target2">Hello World</h3>This goes into the main target     </div>';
    aResponse.Code := 200;
    aResponse.ContentType := 'text/html; charset=utf-8';
    aResponse.ContentLength := length(aResponse.Content);
    aResponse.SendContent;
  end;

  procedure scriptEndpoint(aRequest: TRequest; aResponse: TResponse);
  begin
    aResponse.content :=
      '<div> <h3>I am loading a script</h3> <script> console.log("Hey"); </script>  </div>';
    aResponse.Code := 200;
    aResponse.ContentType := 'text/html; charset=utf-8';
    aResponse.ContentLength := length(aResponse.Content);
    aResponse.SendContent;
  end;

  procedure usersEndpoint(aRequest: TRequest; aResponse: TResponse);
  begin
    aResponse.content :=
      '[{"id": 1,"name": "Steph Curry"},{"id": 2, "name": "Lebron James"},{"id": 3, "name": "Kevin Durant" },{"id": 4, "name" : "Giannis Antetokounmpo" }]';
    aResponse.Code := 200;
    aResponse.ContentType := 'application/json; charset=utf-8';
    aResponse.ContentLength := length(aResponse.Content);
    aResponse.SendContent;
  end;

  procedure rootEndpoint(aRequest: TRequest; aResponse: TResponse);
  begin
    aResponse.content := '<div><h3>Hello World!</h3></div>';
    aResponse.Code := 200;
    aResponse.ContentType := 'text/html; charset=utf-8';
    aResponse.ContentLength := length(aResponse.Content);
    aResponse.SendContent;
  end;

begin
  MimeTypes.LoadKnownTypes;
  Application.Title := 'HTMX demo server';
  Application.Port := 3000;
  MimeTypesFile := MyMime;
  Application.Initialize;
  //access files from chapter 1
  aDir := ExtractFilePath(ParamStr(0)) + '..\chapter1\';
  aDir := ExpandFileName(aDir);
  RegisterFileLocation('chapter1', aDir);
  //access files from chapter 2
  aDir := ExtractFilePath(ParamStr(0)) + '..\chapter2\';
  aDir := ExpandFileName(aDir);
  RegisterFileLocation('chapter2', aDir);
  //access files from chapter 3
  aDir := ExtractFilePath(ParamStr(0)) + '..\chapter3\';
  aDir := ExpandFileName(aDir);
  RegisterFileLocation('chapter3', aDir);

  //access files from chapter 4
  aDir := ExtractFilePath(ParamStr(0)) + '..\chapter4\';
  aDir := ExpandFileName(aDir);
  RegisterFileLocation('chapter4', aDir);

  //access files from chapter 5
  aDir := ExtractFilePath(ParamStr(0)) + '..\chapter5\';
  aDir := ExpandFileName(aDir);
  RegisterFileLocation('chapter5', aDir);

  //access files from chapter 6
  aDir := ExtractFilePath(ParamStr(0)) + '..\chapter6\';
  aDir := ExpandFileName(aDir);
  RegisterFileLocation('chapter6', aDir);



  HTTPRouter.RegisterRoute('/', @rootEndpoint, True);
  HTTPRouter.RegisterRoute('/message', @messageEndpoint, False);
  HTTPRouter.RegisterRoute('/progressmessage', @progressmessageEndpoint, False);
  HTTPRouter.RegisterRoute('/echopayload', @echopayloadEndpoint, False);
  HTTPRouter.RegisterRoute('/upload', @uploadEndpoint, False);
  HTTPRouter.RegisterRoute('/echo', @echoEndpoint, False);
  HTTPRouter.RegisterRoute('/bigbox', @bigboxEndpoint, False);
  HTTPRouter.RegisterRoute('/oob', @oobEndpoint, False);
  HTTPRouter.RegisterRoute('/script', @scriptEndpoint, False);
  HTTPRouter.RegisterRoute('/users', @usersEndpoint, False);




  Writeln('open a webbrowser: ' + Application.HostName + ':' + IntToStr(
    Application.port) + '/chapterxx/hello-world.html');

  Application.Run;

end.
