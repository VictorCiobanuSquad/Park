tableextension 55714 "Responsibility Center Ext." extends "Responsibility Center"
{
    fields
    {
        field(50000; "Picture Two"; Blob)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; Treasurer; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Treasurer';
            TableRelation = "User Setup"."User ID";

            trigger OnValidate()
            begin
                IF Treasurer = '' THEN TESTFIELD("Automatic Hold", FALSE);
            end;
        }
        field(50002; "Automatic Hold"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Automatic Hold';

            trigger OnValidate()
            begin
                TESTFIELD(Treasurer);
            end;
        }
        field(50003; "P.O. FAX From Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Nome De FAX Transf. Banc.';
        }
        field(50004; "P.O. FAX Signature 1"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Assin. 1 FAX Transf. Banc.';
        }
        field(50005; "P.O. FAX Signature 2"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Assin. 1 FAX Transf. Banc.';
        }
        field(50006; "PS2 Filename"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Ficheiro PS2';
            InitValue = 'C:\';
        }
        field(73105; "Aspects Max"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Aspects Max';
        }
        field(73106; Picture; Blob)
        {
            DataClassification = ToBeClassified;
        }
    }
    var
        rUserSetup: Record "User Setup";
        rMomentsAssessment: Record "Moments Assessment";
        rStudents: Record Students;
        rCandidate: Record Candidate;
        rStudyPlanHeader: Record "Study Plan Header";
        rCourseHeader: Record "Course Header";
        rServicesPlanHead: Record "Services Plan Head";
        rClass: Record Class;
        rUsersFamily: Record "Users Family";
        rAspects: Record Aspects;
        Text73000: Label 'There is a user with the Responsibility Center %1';
        Text73001: Label 'There are Moments using the Responsibility Center %1';
        Text73002: Label 'There are Candidates using the Responsibility Center %1';
        Text73003: Label 'There are Students using the Responsibility Center %1';
        Text73004: Label 'There are Study Plan using the Responsibility Center %1';
        Text73005: Label 'There are Course using the Responsibility Center %1';
        Text73006: Label 'There are Services Plan using the Responsibility Center %1';
        Text73007: Label 'There are Class using the Responsibility Center %1';
        Text73008: Label 'There are User Family using the Responsibility Center %1';
        Text73009: Label 'There are Aspects using the Responsibility Center %1';
        Text73011: Label 'You do not have permission to create Responsibility Centers.';

    trigger OnInsert()
    begin
        IF rUserSetup.GET(USERID) THEN BEGIN

            IF rUserSetup."Sales Resp. Ctr. Filter" <> '' THEN
                ERROR(Text73011);
            IF rUserSetup."Purchase Resp. Ctr. Filter" <> '' THEN
                ERROR(Text73011);
            IF rUserSetup."Service Resp. Ctr. Filter" <> '' THEN
                ERROR(Text73011);
            IF rUserSetup."Education Resp. Ctr. Filter" <> '' THEN
                ERROR(Text73011);
        END;
    end;

    trigger OnDelete()
    begin
        IF Code <> '' THEN BEGIN
            rUserSetup.RESET;
            rUserSetup.SETRANGE("Education Resp. Ctr. Filter", Code);
            IF rUserSetup.FINDFIRST THEN
                ERROR(Text73000, Code);



            rMomentsAssessment.RESET;
            rMomentsAssessment.SETRANGE("Responsibility Center", Code);
            IF rMomentsAssessment.FINDFIRST THEN
                ERROR(Text73001, Code);

            rCandidate.RESET;
            rCandidate.SETRANGE("Responsibility Center", Code);
            IF rCandidate.FINDFIRST THEN
                ERROR(Text73002, Code);

            rStudents.RESET;
            rStudents.SETRANGE("Responsibility Center", Code);
            IF rStudents.FINDFIRST THEN
                ERROR(Text73003, Code);

            rStudyPlanHeader.RESET;
            rStudyPlanHeader.SETRANGE("Responsibility Center", Code);
            IF rStudyPlanHeader.FINDFIRST THEN
                ERROR(Text73004, Code);

            rCourseHeader.RESET;
            rCourseHeader.SETRANGE("Responsibility Center", Code);
            IF rCourseHeader.FINDFIRST THEN
                ERROR(Text73005, Code);

            rServicesPlanHead.RESET;
            rServicesPlanHead.SETRANGE("Responsibility Center", Code);
            IF rServicesPlanHead.FINDFIRST THEN
                ERROR(Text73006, Code);

            rClass.RESET;
            rClass.SETRANGE("Responsibility Center", Code);
            IF rClass.FINDFIRST THEN
                ERROR(Text73007, Code);


            rUsersFamily.RESET;
            rUsersFamily.SETRANGE("Responsibility Center", Code);
            IF rUsersFamily.FINDFIRST THEN
                ERROR(Text73008, Code);

            rAspects.RESET;
            rAspects.SETRANGE("Responsibility Center", Code);
            IF rAspects.FINDFIRST THEN
                ERROR(Text73009);

        END;
    end;
}