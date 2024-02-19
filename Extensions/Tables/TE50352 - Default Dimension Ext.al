tableextension 50352 "Default Dimension Ext." extends "Default Dimension"
{
    /*
    //C+ ET - Dimension Integration
    */
    var
        lDefaultDimension: Record "Default Dimension";
        lStudents: Record Students;
        lUsersFamily: Record "Users Family";

    trigger OnInsert()
    begin
        //C+ - ET.03.0005 - Dimension Integration
        //To update the dimension of the client if changes from student/Users Family
        CASE Rec."Table ID" OF
            DATABASE::Students:
                BEGIN
                    IF lStudents.GET(Rec."No.") AND (lStudents."Customer No." <> '') THEN BEGIN
                        lDefaultDimension.INIT;
                        lDefaultDimension.TRANSFERFIELDS(Rec);
                        lDefaultDimension."Table ID" := DATABASE::Customer;
                        lDefaultDimension."No." := lStudents."Customer No.";
                        lDefaultDimension.INSERT;
                    END;
                END;
            DATABASE::"Users Family":
                BEGIN
                    IF lUsersFamily.GET(Rec."No.") AND (lUsersFamily."Customer No." <> '') THEN BEGIN
                        lDefaultDimension.INIT;
                        lDefaultDimension.TRANSFERFIELDS(Rec);
                        lDefaultDimension."Table ID" := DATABASE::Customer;
                        lDefaultDimension."No." := lUsersFamily."Customer No.";
                        lDefaultDimension.INSERT;
                    END;
                END;
        END;
        //
    end;

    trigger OnModify()
    begin
        //C+ - ET.03.0005 - Dimension Integration
        //To update the dimension of the client if changes from student/Users Family
        CASE Rec."Table ID" OF
            DATABASE::Students:
                BEGIN
                    IF lStudents.GET(Rec."No.") AND (lStudents."Customer No." <> '') THEN BEGIN
                        lDefaultDimension.RESET;
                        IF lDefaultDimension.GET(DATABASE::Customer, lStudents."Customer No.", xRec."Dimension Code") THEN
                            lDefaultDimension.DELETE;
                        lDefaultDimension.INIT;
                        lDefaultDimension.TRANSFERFIELDS(Rec);
                        lDefaultDimension."Table ID" := DATABASE::Customer;
                        lDefaultDimension."No." := lStudents."Customer No.";
                        lDefaultDimension.INSERT;
                    END;
                END;
            DATABASE::"Users Family":
                BEGIN
                    IF lUsersFamily.GET(Rec."No.") AND (lUsersFamily."Customer No." <> '') THEN BEGIN
                        lDefaultDimension.RESET;
                        IF lDefaultDimension.GET(DATABASE::Customer, lUsersFamily."Customer No.", xRec."Dimension Code") THEN
                            lDefaultDimension.DELETE;
                        lDefaultDimension.INIT;
                        lDefaultDimension.TRANSFERFIELDS(Rec);
                        lDefaultDimension."Table ID" := DATABASE::Customer;
                        lDefaultDimension."No." := lUsersFamily."Customer No.";
                        lDefaultDimension.INSERT;
                    END;
                END;
        END;
        //
    end;

    trigger OnDelete()
    begin
        //C+ - ET.03.0005 - Dimension Integration
        //To update the dimension of the client if changes from student/Users Family
        CASE Rec."Table ID" OF
            DATABASE::Students:
                BEGIN
                    IF lStudents.GET(Rec."No.") AND (lStudents."Customer No." <> '') THEN BEGIN
                        lDefaultDimension.RESET;
                        IF lDefaultDimension.GET(DATABASE::Customer, lStudents."Customer No.", Rec."Dimension Code") THEN
                            lDefaultDimension.DELETE;
                    END;
                END;
            DATABASE::"Users Family":
                BEGIN
                    IF lUsersFamily.GET(Rec."No.") AND (lUsersFamily."Customer No." <> '') THEN BEGIN
                        lDefaultDimension.RESET;
                        IF lDefaultDimension.GET(DATABASE::Customer, lUsersFamily."Customer No.", Rec."Dimension Code") THEN
                            lDefaultDimension.DELETE;
                    END;
                END;
        END;
        //
    end;
}