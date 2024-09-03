codeunit 50352 "Default Dimension Subscription"
{
    /*
    //C+ ET - Dimension Integration
    */
    [EventSubscriber(ObjectType::Table, Database::"Default Dimension", 'OnAfterUpdateGlobalDimCode', '', false, false)]
    local procedure ProcessingOnUpdateGlobalDimCode(GlobalDimCodeNo: Integer; TableID: Integer; AccNo: Code[20]; NewDimValue: Code[20])
    var
        Students: Record Students;
        Class: Record Class;
        UsersFamily: Record "Users Family";
        ClassID: Integer;
        Services: Record "Services ET";
    begin
        //C+ - ET.03.0005 - Dimension Integration
        case TableID of
            DATABASE::Students:
                BEGIN
                    IF Students.GET(AccNo) THEN BEGIN
                        CASE GlobalDimCodeNo OF
                            1:
                                Students."Global Dimension 1 Code" := NewDimValue;
                            2:
                                Students."Global Dimension 2 Code" := NewDimValue;
                        END;
                        Students.MODIFY(TRUE);
                    END;
                END;
            DATABASE::Class:
                BEGIN
                    Class.RESET;
                    EVALUATE(ClassID, AccNo);
                    Class.SETRANGE("Dimension ID", ClassID);
                    IF Class.FINDSET(TRUE, TRUE) THEN BEGIN
                        CASE GlobalDimCodeNo OF
                            1:
                                Students."Global Dimension 1 Code" := NewDimValue;
                            2:
                                Students."Global Dimension 2 Code" := NewDimValue;
                        END;
                        Class.MODIFY(TRUE);
                    END;
                END;
            DATABASE::"Users Family":
                BEGIN
                    IF UsersFamily.GET(AccNo) THEN BEGIN
                        CASE GlobalDimCodeNo OF
                            1:
                                UsersFamily."Global Dimension 1 Code" := NewDimValue;
                            2:
                                UsersFamily."Global Dimension 2 Code" := NewDimValue;
                        END;
                        UsersFamily.MODIFY(TRUE);
                    END;
                END;
            DATABASE::"Services ET":
                BEGIN
                    IF Services.GET(AccNo) THEN BEGIN
                        CASE GlobalDimCodeNo OF
                            1:
                                Services."Global Dimension 1 Code" := NewDimValue;
                            2:
                                Services."Global Dimension 2 Code" := NewDimValue;
                        END;
                        Services.MODIFY(TRUE);
                    END;
                END;
        //
        end;
    end;
}