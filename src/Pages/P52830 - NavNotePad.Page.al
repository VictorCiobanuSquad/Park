page 52830 "Nav NotePad"
{
    Editable = false;
    PageType = CardPart;

    layout
    {
        area(content)
        {
            field(LongDescription; LongDescription)
            {
                ApplicationArea = Basic, Suite;
                MultiLine = true;
                ShowCaption = false;
            }
        }
    }

    actions
    {
    }

    trigger OnClosePage()
    begin
        /*
        IF LongDescription <> xLongDescription THEN
          IF CONFIRM(Text01,TRUE) THEN
              RegisterObservation();
              //SetCommentLine();
        */

    end;

    trigger OnInit()
    begin
        char13 := 13;
        char10 := 10;
    end;

    trigger OnOpenPage()
    begin
        //For demo using the first record from item table
        //Item.FINDFIRST;

        //LongDescription := GetCommentLine();

        //xLongDescription := LongDescription;
    end;

    var
        LongDescription: Text;
        xLongDescription: Text;
        Item: Record Item;
        Useblobfield: Boolean;
        Text01: Label 'Do You want to save the data?';
        char13: Char;
        char10: Char;
        recRemarks: Record Remarks;
        pStudentCodeNo: Code[20];
        pSchoolYear: Code[9];
        pClass: Code[20];
        pSubjects: Code[20];
        pSubSubjects: Code[20];
        pSchoolingYear: Code[10];
        pStudyPlanCode: Code[20];
        pMomentCode: Code[10];
        pClassNumber: Integer;
        lineNum: Integer;
        rClass: Record Class;

    //[Scope('OnPrem')]
    procedure GetCommentLine() returnvalue: Text
    var
        CommentLine: Record "Comment Line";
    begin
        CommentLine.SetRange("Table Name", CommentLine."Table Name"::Item);
        CommentLine.SetRange("No.", Item."No.");
        if CommentLine.FindSet then
            repeat
                returnvalue += CommentLine.Comment;
            until CommentLine.Next = 0;
    end;

    //[Scope('OnPrem')]
    procedure SetCommentLine()
    var
        TempLargeText: Text;
        CommentLine: Record "Comment Line";
        LineNo: Integer;
    begin
        TempLargeText := LongDescription;

        CommentLine.SetRange("Table Name", CommentLine."Table Name"::Item);
        CommentLine.SetRange("No.", Item."No.");
        CommentLine.DeleteAll;

        while StrLen(TempLargeText) > 0 do begin
            LineNo += 100;
            CommentLine."Line No." := LineNo;
            CommentLine."Table Name" := CommentLine."Table Name"::Item;
            CommentLine."No." := Item."No.";
            CommentLine.Comment := CopyStr(TempLargeText, 1, 80);
            CommentLine.Insert;
            TempLargeText := CopyStr(TempLargeText, 81);
        end;
    end;

    //[Scope('OnPrem')]
    procedure SendObservation(StudentCodeNo: Code[20]; SchoolYear: Code[9]; Class: Code[20]; SchoolingYear: Code[10]; StudyPlanCode: Code[20]; SubjectCode: Code[10]; SubSubjectCode: Code[10]; ClassNo: Integer; Type: Option; MomentCode: Code[10])
    var
        loc_MomentCode: Code[10];
    begin
        LongDescription := '';
        pStudentCodeNo := StudentCodeNo;
        pSchoolYear := SchoolYear;
        pClass := Class;
        pSubjects := SubjectCode;
        pSubSubjects := SubSubjectCode;
        pSchoolingYear := SchoolingYear;
        pStudyPlanCode := StudyPlanCode;
        pMomentCode := MomentCode;
        pClassNumber := ClassNo;
        Clear(recRemarks);
        recRemarks.SetRange(Class, Class);
        recRemarks.SetRange("School Year", SchoolYear);
        recRemarks.SetRange("Schooling Year", SchoolingYear);
        recRemarks.SetRange(Subject, SubjectCode);
        recRemarks.SetRange("Sub-subject", SubSubjectCode);
        recRemarks.SetRange("Study Plan Code", StudyPlanCode);
        recRemarks.SetRange("Student/Teacher Code No.", StudentCodeNo);
        recRemarks.SetRange(recRemarks."Original Line No.", 0);
        recRemarks.SetRange("Type Remark", recRemarks."Type Remark"::Assessment);
        recRemarks."Responsibility Center" := GetRespCenter(Class, SchoolYear);
        loc_MomentCode := '';
        if recRemarks.FindSet then begin
            repeat
                if loc_MomentCode = '' then begin
                    LongDescription := LongDescription + recRemarks."Moment Code" + (Format(char13) + Format(char10));
                    loc_MomentCode := recRemarks."Moment Code";
                end;
                if loc_MomentCode <> recRemarks."Moment Code" then begin
                    LongDescription := LongDescription + (Format(char13) + Format(char10)) + (Format(char13) + Format(char10)) + recRemarks."Moment Code" + (Format(char13) + Format(char10));
                    loc_MomentCode := recRemarks."Moment Code";
                end;
                LongDescription := LongDescription + recRemarks.Textline;
                case recRemarks.Seperator of
                    recRemarks.Seperator::Space:
                        LongDescription := LongDescription + ' ';
                    recRemarks.Seperator::"Carriage Return":
                        LongDescription := LongDescription + (Format(char13) + Format(char10));
                end;
            until recRemarks.Next = 0;
        end;
    end;

    //[Scope('OnPrem')]
    procedure RegisterObservation()
    var
        DescriptionSplit: Text;
        close: Boolean;
        poschr13: Integer;
        lenDesc: Integer;
    begin
        if LongDescription <> xLongDescription then
            recRemarks.DeleteAll; // remover registos antigos
        begin
            DescriptionSplit := LongDescription;
            Clear(recRemarks);
            recRemarks.SetRange(Class, pClass);
            recRemarks.SetRange("School Year", pSchoolYear);
            recRemarks.SetRange("Schooling Year", pSchoolingYear);
            recRemarks.SetRange(Subject, pSubjects);
            recRemarks.SetRange("Sub-subject", pSubSubjects);
            recRemarks.SetRange("Study Plan Code", pStudyPlanCode);
            recRemarks.SetRange("Student/Teacher Code No.", pStudentCodeNo);
            recRemarks.SetRange("Moment Code", pMomentCode);
            recRemarks.SetRange("Type Remark", recRemarks."Type Remark"::Assessment);
            recRemarks.SetRange("Responsibility Center", GetRespCenter(pClass, pSchoolYear));
            lineNum := 10000;
            repeat
                poschr13 := StrPos(LongDescription, Format(char13));
                lenDesc := StrLen(DescriptionSplit);

                recRemarks.Init;
                recRemarks.Class := pClass;
                recRemarks."School Year" := pSchoolYear;
                recRemarks."Schooling Year" := pSchoolingYear;
                recRemarks.Subject := pSubjects;
                recRemarks."Sub-subject" := pSubSubjects;
                recRemarks."Study Plan Code" := pStudyPlanCode;
                recRemarks."Student/Teacher Code No." := pStudentCodeNo;
                recRemarks."Moment Code" := pMomentCode;
                recRemarks."Type Remark" := recRemarks."Type Remark"::Assessment;
                recRemarks."Line No." := lineNum;

                if poschr13 <> 0 then begin
                    if poschr13 < 251 then begin
                        // inserir directamente na tabela remarks colocar Carriage Return como separador
                        recRemarks.Textline := CopyStr(DescriptionSplit, 1, 250);
                        recRemarks.Seperator := recRemarks.Seperator::"Carriage Return";
                        DescriptionSplit := CopyStr(DescriptionSplit, 250);
                    end
                    else begin
                        // colocar o Space por cada linha.
                        recRemarks.Textline := CopyStr(DescriptionSplit, 1, 250);
                        recRemarks.Seperator := recRemarks.Seperator::Space;
                        DescriptionSplit := CopyStr(DescriptionSplit, 250);
                    end;
                end
                else begin
                    // colocar o Space por cada linha.
                    recRemarks.Textline := CopyStr(DescriptionSplit, 1, 250);
                    recRemarks.Seperator := recRemarks.Seperator::Space;
                    DescriptionSplit := CopyStr(DescriptionSplit, 250);
                end;
                recRemarks."Entry No." := GetLastEntryNo();
                if rClass.Get(pClass, pSchoolYear) then
                    recRemarks."Type Education" := rClass.Type;
                recRemarks."Class No." := pClassNumber;
                recRemarks."Responsibility Center" := GetRespCenter(pClass, pSchoolYear);
                recRemarks."Creation Date" := Today;
                recRemarks."Creation User" := UserId;
                recRemarks.Insert(true);
                lineNum := lineNum + 10000;
            until (StrLen(DescriptionSplit) = 0);
        end;
    end;

    //[Scope('OnPrem')]
    procedure GetRespCenter(pClass: Code[20]; pSchoolYear: Code[9]): Code[10]
    var
        l_Class: Record Class;
    begin
        l_Class.Reset;
        l_Class.SetRange(Class, pClass);
        l_Class.SetRange("School Year", pSchoolYear);
        if l_Class.FindFirst then
            exit(l_Class."Responsibility Center")
        else
            exit('');
    end;

    //[Scope('OnPrem')]
    procedure GetLastEntryNo(): Integer
    var
        rRemarks: Record Remarks;
    begin
        rRemarks.Reset;
        if rRemarks.Find('+') then
            exit(rRemarks."Entry No." + 1)
        else
            exit(1);
    end;
}

