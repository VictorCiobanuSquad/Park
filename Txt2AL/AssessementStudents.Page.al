#pragma implicitwith disable
page 31009804 "Assessement Students"
{
    Caption = 'Assessement Students';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Assessement Students";

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                ShowCaption = false;
                field("Criterion 1"; Rec."Criterion 1")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Criterion 2"; Rec."Criterion 2")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Criterion 3"; Rec."Criterion 3")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(cvarGrade; varGrade)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Grade';
                    Editable = cvarGradeEditable;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        varGrade := fLookupFunction;

                        InsertGrade(varGrade);
                    end;

                    trigger OnValidate()
                    begin
                        if rRankGroup.Get(rAssessementStudents."Assessment Code") then begin
                            if rRankGroup."Evaluation Type" = rRankGroup."Evaluation Type"::Qualitative then
                                varGrade := ValidateAssessmentQualitative(varGrade);
                        end;

                        if rRankGroup.Get(Rec."Assessment Code") then begin
                            if rRankGroup."Evaluation Type" = rRankGroup."Evaluation Type"::Quantitative then
                                varGrade := Format(ValidateAssessmentQuant(varGrade));
                        end;

                        if rRankGroup.Get(Rec."Assessment Code") then begin
                            if (rRankGroup."Evaluation Type" = rRankGroup."Evaluation Type"::"Mixed-Qualification") then
                                varGrade := ValidateAssessmentMixed(varGrade);
                        end;

                        InsertGrade(varGrade);
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        GetGrade;

        fEditable;
    end;

    trigger OnInit()
    begin
        cvarGradeEditable := true;
    end;

    var
        varGrade: Text[20];
        varMixed: Boolean;
        rRankGroup: Record "Rank Group";
        rAssessementStudents: Record "Assessement Students";
        varClassification: Text[30];
        text003: Label 'Grade should be a number.';
        text004: Label 'Grade should be between %1 and %2.';
        text005: Label 'There is no code inserted.';
        rMomentsAssessment: Record "Moments Assessment";
        [InDataSet]
        cvarGradeEditable: Boolean;

    //[Scope('OnPrem')]
    procedure FormUpdate()
    begin
        CurrPage.Update(false);
    end;

    //[Scope('OnPrem')]
    procedure GetGrade()
    begin
        rAssessementStudents.Reset;
        rAssessementStudents.SetRange("Moment Code", Rec."Moment Code");
        rAssessementStudents.SetRange("School Year", Rec."School Year");
        rAssessementStudents.SetRange("Schooling Year", Rec."Schooling Year");
        rAssessementStudents.SetRange("Subject Code", Rec."Subject Code");
        rAssessementStudents.SetRange("Student Code No.", Rec."Student Code No.");
        rAssessementStudents.SetRange("Line No.", Rec."Line No.");
        if rAssessementStudents.Find('-') then begin
            repeat
                if rRankGroup.Get(rAssessementStudents."Assessment Code") then begin
                    if rRankGroup."Evaluation Type" = rRankGroup."Evaluation Type"::Qualitative then
                        varGrade := rAssessementStudents."Qualitative Grade";
                    if rRankGroup."Evaluation Type" = rRankGroup."Evaluation Type"::Quantitative then
                        varGrade := Format(rAssessementStudents.Grade);
                    if rRankGroup."Evaluation Type" = rRankGroup."Evaluation Type"::"Mixed-Qualification" then
                        if varMixed then
                            varGrade := Format(rAssessementStudents.Grade)
                        else
                            varGrade := rAssessementStudents."Qualitative Grade";
                end;

            until rAssessementStudents.Next = 0;
        end;
    end;

    //[Scope('OnPrem')]
    procedure MixedGrade(pMixed: Boolean)
    begin
        varMixed := pMixed;
    end;

    //[Scope('OnPrem')]
    procedure fLookupFunction() Out: Code[20]
    var
        rClassificationLevel: Record "Classification Level";
    begin
        if rRankGroup.Get(rAssessementStudents."Assessment Code") then begin
            if rRankGroup."Evaluation Type" = rRankGroup."Evaluation Type"::Qualitative then begin

                rClassificationLevel.Reset;
                rClassificationLevel.SetRange("Classification Group Code", Rec."Assessment Code");
                if rClassificationLevel.Find('-') then begin
                    if PAGE.RunModal(PAGE::"List Grades", rClassificationLevel) = ACTION::LookupOK then
                        exit(rClassificationLevel."Classification Level Code");
                end else
                    exit(varGrade);

            end;


            if (rRankGroup."Evaluation Type" = rRankGroup."Evaluation Type"::"Mixed-Qualification") then begin
                rClassificationLevel.Reset;
                rClassificationLevel.SetRange("Classification Group Code", Rec."Assessment Code");
                if rClassificationLevel.Find('-') then begin
                    if PAGE.RunModal(PAGE::"List Grades", rClassificationLevel) = ACTION::LookupOK then begin
                        if varMixed then begin
                            varClassification := rClassificationLevel."Classification Level Code";
                            exit(Format(rClassificationLevel.Value))
                        end else begin
                            varClassification := Format(rClassificationLevel.Value);
                            exit(rClassificationLevel."Classification Level Code");
                        end;

                    end else
                        exit(varGrade);
                end;
            end;
        end;

        exit(varGrade);
    end;

    //[Scope('OnPrem')]
    procedure ValidateAssessmentQuant(InClassification: Text[20]) Out: Decimal
    var
        varClasificationLocal: Decimal;
        rClassificationLevel: Record "Classification Level";
    begin
        if rRankGroup.Get(Rec."Assessment Code") then begin
            if rRankGroup."Evaluation Type" = rRankGroup."Evaluation Type"::Quantitative then begin

                if InClassification <> '' then begin
                    if not Evaluate(varClasificationLocal, InClassification) then
                        Error(text003);
                    rClassificationLevel.Reset;
                    rClassificationLevel.SetRange("Classification Group Code", Rec."Assessment Code");
                    if rClassificationLevel.FindFirst then begin
                        if (rClassificationLevel."Min Value" <= varClasificationLocal) and
                           (rClassificationLevel."Max Value" >= varClasificationLocal) then
                            exit(varClasificationLocal)
                        else
                            Error(text004, rClassificationLevel."Min Value", rClassificationLevel."Max Value");
                    end;
                end;
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure ValidateAssessmentQualitative(inText: Text[20]) Out: Code[20]
    var
        rClassificationLevel: Record "Classification Level";
    begin
        if rRankGroup.Get(Rec."Assessment Code") then begin
            if rRankGroup."Evaluation Type" = rRankGroup."Evaluation Type"::Qualitative then begin

                rClassificationLevel.Reset;
                rClassificationLevel.SetRange("Classification Group Code", Rec."Assessment Code");
                rClassificationLevel.SetFilter("Classification Level Code", inText);
                if rClassificationLevel.FindFirst then
                    exit(rClassificationLevel."Classification Level Code")
                else
                    Error(text005);
            end else
                exit(inText);
        end;
    end;

    //[Scope('OnPrem')]
    procedure ValidateAssessmentMixed(InClassification: Text[20]) Out: Text[30]
    var
        varLocalClasification: Decimal;
        rClassificationLevelMin: Record "Classification Level";
        rClassificationLevelMax: Record "Classification Level";
        VarMinValue: Decimal;
        VarMaxValue: Decimal;
        rClassificationLevel: Record "Classification Level";
    begin
        if rRankGroup.Get(Rec."Assessment Code") then begin
            if (rRankGroup."Evaluation Type" = rRankGroup."Evaluation Type"::"Mixed-Qualification") then begin
                Clear(varClassification);
                if InClassification <> '' then begin
                    if Evaluate(varLocalClasification, InClassification) then begin
                        rClassificationLevelMin.Reset;
                        rClassificationLevelMin.SetCurrentKey("Id Ordination");
                        rClassificationLevelMin.Ascending(true);
                        rClassificationLevelMin.SetRange("Classification Group Code", Rec."Assessment Code");
                        if rClassificationLevelMin.FindFirst then
                            VarMinValue := rClassificationLevelMin."Min Value";

                        rClassificationLevelMax.Reset;
                        rClassificationLevelMax.SetCurrentKey("Id Ordination");
                        rClassificationLevelMax.Ascending(false);
                        rClassificationLevelMax.SetRange("Classification Group Code", Rec."Assessment Code");
                        if rClassificationLevelMax.FindFirst then
                            VarMaxValue := rClassificationLevelMax."Max Value";

                        if (VarMinValue <= varLocalClasification) and
                           (VarMaxValue >= varLocalClasification) then begin
                            rClassificationLevel.Reset;
                            rClassificationLevel.SetRange("Classification Group Code", Rec."Assessment Code");
                            rClassificationLevel.SetRange(Value, varLocalClasification);
                            if rClassificationLevel.FindFirst then begin
                                varClassification := Format(varLocalClasification);
                                exit(rClassificationLevel."Classification Level Code");
                            end;

                            rClassificationLevel.Reset;
                            rClassificationLevel.SetRange("Classification Group Code", Rec."Assessment Code");
                            if rClassificationLevel.Find('-') then begin
                                repeat
                                    if (rClassificationLevel."Min Value" <= varLocalClasification) and
                                       (rClassificationLevel."Max Value" >= varLocalClasification) then begin
                                        if varMixed then begin
                                            varClassification := rClassificationLevel."Classification Level Code";
                                            exit(Format(varLocalClasification));
                                        end else begin
                                            varClassification := Format(varLocalClasification);
                                            exit(rClassificationLevel."Classification Level Code");
                                        end;
                                    end;
                                until rClassificationLevel.Next = 0
                            end;

                        end else
                            Error(text004, VarMinValue, VarMaxValue);
                    end;
                    rClassificationLevel.Reset;
                    rClassificationLevel.SetRange("Classification Group Code", Rec."Assessment Code");
                    rClassificationLevel.SetRange("Classification Level Code", InClassification);
                    if rClassificationLevel.FindFirst then begin
                        if varMixed then begin
                            varClassification := rClassificationLevel."Classification Level Code";
                            exit(Format(rClassificationLevel.Value));

                        end else begin
                            varClassification := Format(rClassificationLevel.Value);
                            exit(rClassificationLevel."Classification Level Code");
                        end;
                    end else
                        Error(text005);

                end;
            end;

        end;
    end;

    //[Scope('OnPrem')]
    procedure InsertGrade(inText: Text[20])
    begin



        if rRankGroup.Get(Rec."Assessment Code") then begin
            if (rRankGroup."Evaluation Type" = rRankGroup."Evaluation Type"::"Mixed-Qualification") then begin
                if varMixed then begin
                    Rec."Qualitative Grade" := varClassification;
                    if not Evaluate(Rec.Grade, inText) then
                        Rec.Grade := 0;
                end else begin
                    Rec."Qualitative Grade" := inText;

                    if Evaluate(Rec.Grade, varClassification) then;
                end;


            end;
            if rRankGroup."Evaluation Type" = rRankGroup."Evaluation Type"::Qualitative then
                Rec."Qualitative Grade" := inText;
            if rRankGroup."Evaluation Type" = rRankGroup."Evaluation Type"::Quantitative then begin
                Evaluate(Rec.Grade, inText);

            end;

            Rec.Modify;
        end;

        if (rRankGroup."Evaluation Type" = rRankGroup."Evaluation Type"::"Mixed-Qualification") or
            (rRankGroup."Evaluation Type" = rRankGroup."Evaluation Type"::Quantitative) then
            Rec.InsertAssessment;
    end;

    //[Scope('OnPrem')]
    procedure fEditable()
    begin
        rMomentsAssessment.Reset;
        rMomentsAssessment.SetRange("Moment Code", Rec."Moment Code");
        rMomentsAssessment.SetRange("School Year", Rec."School Year");
        rMomentsAssessment.SetRange("Schooling Year", Rec."Schooling Year");
        rMomentsAssessment.SetRange(Active, true);
        if rMomentsAssessment.FindFirst then
            cvarGradeEditable := true
        else
            cvarGradeEditable := false
    end;
}

#pragma implicitwith restore

