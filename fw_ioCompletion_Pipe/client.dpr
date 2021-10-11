////////////////////////////////////////////////////////////////////////////////
//
//  ****************************************************************************
//  * Unit Name : server
//  * Purpose   : Демонстрационный пример работы клиента
//  * Author    : Александр (Rouse_) Багель
//  * Copyright : © Fangorn Wizards Lab 1998 - 2010.
//  * Version   : 1.00
//  * Home Page : http://rouse.drkb.ru
//  ****************************************************************************
//

// Показан примерный принцип работы с классом TFWPipeClient
// Задача демоклиента отправить серверу некое число, получить результат и проверить,
// равняется ли оно отправленному числу увеличенному на единицу.
// Вывести на экран результат проверки.
// После завершения отправки всех чисел, отправить серверу число -1,
// при получении которого сервер должен завершить свою работу.


program client;

{$APPTYPE CONSOLE}

uses
  Windows,
  FWIOCompletionPipes,
  Classes,
  SysUtils;

var
  I: Integer;
  Data: DWORD;
  PipeClient: TFWPipeClient;
  InStream, OutStream: TMemoryStream;
begin
  try
    PipeClient := TFWPipeClient.Create('.', 'FWIOCompletionPipeServer');
    try
      PipeClient.Active := True;
      InStream := TMemoryStream.Create;
      try
        OutStream := TMemoryStream.Create;
        try
          for I := 0 to 10000 do
          begin
            InStream.Clear;
            InStream.WriteBuffer(I, 4);
            PipeClient.SendData(InStream, OutStream);
            OutStream.ReadBuffer(Data, 4);
            if I + 1 = Integer(Data) then
              Writeln('Send data success ', I)
            else
              Writeln('Send data failed ', I + 1, ' <> ', Data);
          end;
          InStream.Clear;
          I := -1;
          InStream.WriteBuffer(I, 4);
          PipeClient.SendData(InStream, OutStream);
        finally
          OutStream.Free;
        end;
      finally
        InStream.Free;
      end;
    finally
      PipeClient.Free;
    end;
  except
    on E:Exception do
      Writeln(E.Classname, ': ', E.Message);
  end;
  Readln;
end.
