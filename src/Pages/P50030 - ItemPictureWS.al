#pragma implicitwith disable
page 50030 ItemPictureWS
{
    PageType = API;
    Caption = 'Item Picture Web Service';
    APIPublisher = 'EthanSorenson';
    APIGroup = 'SCWS';
    APIVersion = 'v1.0';
    EntityName = 'SCWS';
    EntitySetName = 'SCWS';
    SourceTable = Item;
    DelayedInsert = true;
    InsertAllowed = false;
    ModifyAllowed = True;
    //SourceTableView = where("No." = filter(= '1896-S'));

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(No; Rec."No.")
                {
                    Caption = 'No';
                    ApplicationArea = All;
                }
                field(ItemDescription; Rec.Description)
                {
                    Caption = 'Item Description';
                    ApplicationArea = All;
                }
                field(Mime; Mime)
                {
                    Caption = 'Mime';
                    ApplicationArea = All;
                }
                field(FileName; FileName)
                {
                    Caption = 'File Name';
                    ApplicationArea = All;
                }
                field(PictureURL; PictureURL)
                {
                    Caption = 'Picture URL';
                    ApplicationArea = All;
                }
                field(Base64Image; output)
                {
                    Caption = 'Base64 Image';
                    ApplicationArea = All;
                }

            }
        }
    }
    var
        Output: Text;
        Mime: Text;
        FileName: Text;
        PictureURL: Text;

    trigger OnAfterGetCurrRecord()
    begin
        ExporItemPicture()
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if Text.StrLen(PictureURL) > 0 then
            UploadItemPictureUrl()
        else
            if Text.StrLen(Output) < 1 then
                error('You must either provide a Picture URL or a Base64 Encoded Image')
            else
                ImportItemPicture();
    end;

    local procedure ExporItemPicture()
    var
        index: Integer;
        Media: Record "Tenant Media";
        InStream: InStream;
        Base64: Codeunit "Base64 Convert";

    begin
        if Rec.Picture.count = 0 then begin
            output := 'No Content';
            Mime := '';
            FileName := '';
        end
        else
            for index := 1 to Rec.Picture.COUNT do begin
                if Media.Get(Rec.Picture.Item(index)) then begin
                    Media.CalcFields(Content);
                    if Media.Content.HasValue() then begin
                        Media.Content.CreateInStream(InStream, TextEncoding::WINDOWS);
                        output := Base64.ToBase64(InStream);
                        Mime := Media."Mime Type";
                        FileName := Rec."No." + ' ' + Rec.Description + GetImgFileExtension(Mime);
                    end;
                end;
            end;
    end;

    local procedure ImportItemPicture()
    var
        TempBlob: Codeunit "Temp Blob";
        outstream: OutStream;
        instream: InStream;
        Base64: Codeunit "Base64 Convert";
    begin
        if Text.StrLen(output) > 0 then begin
            if Rec.Picture.COUNT > 0 then
                Clear(Rec.Picture);
            TempBlob.CreateOutStream(outstream);
            Base64.FromBase64(output, outstream);
            TempBlob.CreateInStream(InStream);
            Rec.Picture.ImportStream(InStream, FileName, Mime);
            rec.Modify();
        end;
    end;

    local procedure GetImgFileExtension(Mime: Text): Text
    begin
        case Mime of
            'image/jpeg':
                exit('.jpg');
            'image/png':
                exit('.png');
            'image/bmp':
                exit('.bmp');
            'image/gif':
                exit('.gif');
            'image/tiff':
                exit('.tiff');
            'image/wmf':
                exit('.wmf');
        end;
    end;

    procedure UploadItemPictureUrl()
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        InStr: InStream;
    begin
        if Rec.Picture.COUNT > 0 then
            Clear(Rec.Picture);
        Client.Get(PictureURL, Response);
        Response.Content().ReadAs(InStr);
        Rec.Picture.ImportStream(InStr, FileName, Mime);
        rec.Modify();
    end;

}
#pragma implicitwith restore
