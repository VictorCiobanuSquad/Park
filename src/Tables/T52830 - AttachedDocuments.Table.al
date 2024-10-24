table 52830 "Attached Documents"
{
    Caption = 'Attached Documents';

    fields
    {
        field(1; "Table"; Option)
        {
            Caption = 'Table';
            OptionCaption = 'Candidate,Students,Users Family,Teacher,Class';
            OptionMembers = Candidate,Students,"Users Family",Teacher,Class;
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
            Editable = false;
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(5; Attach; BLOB)
        {
            Caption = 'Attach';
        }
        field(6; "File Name"; Text[250])
        {
            Caption = 'File Name';
        }
        field(7; Extension; Text[4])
        {
            Caption = 'Extension';
        }
    }

    keys
    {
        key(Key1; "Table", "No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Text006: Label 'Import Attachment';
        Text007: Label 'All Files (*.*)|*.*';
        Text005: Label 'Export Attachment';
        Path: Text[250];
        PathFile: Text[250];


    procedure ExportAttachment(ExportToFile: Record "Attached Documents"): Boolean
    var
        InStrm: InStream;
    begin
        Rec := ExportToFile;
        CalcFields(Attach);

        //Path := Format(Environ('temp')) + '\';
        //PathFile := Path + "File Name" + '.' + Extension;
        PathFile := "File Name" + '.' + Extension;

        //Attach.Export(PathFile);

        Attach.CreateInStream(InStrm);
        DownloadFromStream(InStrm, '', '', '', PathFile);

        /*CREATE(ShellExt);
        ShellExt.Open(PathFile);
        CLEAR(ShellExt);*/

    end;


    procedure ImportAttachment(ImportFromFile: Text[260]; IsTemporary: Boolean): Boolean
    var
        InStrm: InStream;
        OutStrm: OutStream;
        FileName: Text[260];
    begin

        //if ImportFromFile = '' then
        //FileName := CommonDialogMgt.OpenFile(Text006,ImportFromFile,4,Text007,0)
        FileName := ImportFromFile;
        UploadIntoStream('', '', Text007, FileName, InStrm);
        //else
        //FileName := ImportFromFile;
        if FileName <> '' then begin
            //Attach.Import(FileName);
            attach.CreateOutStream(OutStrm);
            CopyStream(OutStrm, InStrm);
            modify();
            exit(true)
        end else
            exit(false);
    end;
}

