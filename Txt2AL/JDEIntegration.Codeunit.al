codeunit 50002 "JDE Integration"
{

    trigger OnRun()
    begin
        IF GUIALLOWED THEN
            IF NOT CONFIRM(Text001) THEN
                ERROR(Text002);
        Xmlport.RUN(Xmlport::"Export JDE Int. Temp Files");
        Xmlport.RUN(Xmlport::"Export JDE Int. Posted Files");
        IF GUIALLOWED THEN
            MESSAGE(Text003);
    end;

    var
        Text001: Label 'Are you sure you want to export the files for JDE now ?';
        Text002: Label 'Operation cancelled.';
        Text003: Label 'Integration files created successfully.';
}

