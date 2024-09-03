page 52951 "Previous Observations"
{
    Caption = 'Observações Anteriores';
    PageType = Card;

    layout
    {
        area(content)
        {
            group("Previous Observations")
            {
                Caption = 'Previous Observations';
                field("txtObs[1] + txtObs[2] + txtObs[3] + txtObs[4] + txtObs[5] "; txtObs[1] + txtObs[2] + txtObs[3] + txtObs[4] + txtObs[5])
                {
                    ApplicationArea = Basic, Suite;
                    MultiLine = true;
                    ShowCaption = false;
                }
            }
        }
    }

    actions
    {
    }

    var
        rRemarks: Record Remarks;
        txtObs: array[5] of Text[1024];
        vMomento: Code[10];
        i: Integer;
        vEnter: Boolean;

    //[Scope('OnPrem')]
    procedure MostraObs(pStudentCodeNo: Code[20]; pSchoolYear: Code[9]; pClass: Code[20]; pSubjects: Code[20]; pSubSubjects: Code[20]; pSchoolingYear: Code[10]; pStudyPlanCode: Code[20]; pMomentCode: Code[10]; pClassNumber: Integer)
    begin

        Clear(vMomento);
        Clear(i);
        rRemarks.Reset;
        rRemarks.SetRange(rRemarks."Type Remark", rRemarks."Type Remark"::Assessment);
        rRemarks.SetRange(rRemarks."School Year", pSchoolYear);
        rRemarks.SetRange(rRemarks."Schooling Year", pSchoolingYear);
        rRemarks.SetRange(rRemarks."Study Plan Code", pStudyPlanCode);
        rRemarks.SetRange(rRemarks.Class, pClass);
        rRemarks.SetRange(rRemarks."Student/Teacher", rRemarks."Student/Teacher"::Student);
        rRemarks.SetRange(rRemarks."Student/Teacher Code No.", pStudentCodeNo);
        rRemarks.SetRange(rRemarks.Subject, pSubjects);
        rRemarks.SetRange(rRemarks."Sub-subject", pSubSubjects);
        rRemarks.SetFilter(rRemarks.Textline, '<>%1', '');
        if rRemarks.FindSet then begin
            repeat
                if vMomento <> rRemarks."Moment Code" then begin
                    vMomento := rRemarks."Moment Code";
                    i := i + 1;
                    txtObs[i] := StrSubstNo('\') + rRemarks."Moment Code" + ':' + StrSubstNo('\') + rRemarks.Textline;
                    if rRemarks.Seperator = rRemarks.Seperator::"Carriage Return" then
                        vEnter := true
                    else
                        vEnter := false;

                end else begin
                    if vEnter then
                        txtObs[i] := txtObs[i] + StrSubstNo('\') + rRemarks.Textline
                    else
                        txtObs[i] := txtObs[i] + ' ' + rRemarks.Textline;

                end;

            until rRemarks.Next = 0;
        end;
    end;
}

