table 31009825 "Students Non Lective Hours"
{
    Caption = 'Students Non Scholar hours';

    fields
    {
        field(1;"School Year";Code[9])
        {
            Caption = 'School Year';
            TableRelation = "School Year"."School Year";
        }
        field(2;"Student Code No.";Code[20])
        {
            Caption = 'Student Code No.';
            TableRelation = Students."No.";
        }
        field(3;"Responsibility Center";Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";

            trigger OnValidate()
            var
                RespCenter: Record "Responsibility Center";
            begin
                if not cUserEducation.CheckRespCenterEducation("Responsibility Center") then
                  Error(
                    Text0004,
                    RespCenter.TableCaption,cUserEducation.GetEducationFilter(UserId));
            end;
        }
        field(4;"Week Day";Option)
        {
            Caption = 'Week Day';
            OptionCaption = 'Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday';
            OptionMembers = Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday;
        }
        field(5;Lunch;Boolean)
        {
            Caption = 'Lunch';
        }
        field(6;"Collect Transport";Code[20])
        {
            Caption = 'Collect Transport';
            TableRelation = Transport."Transport No." WHERE ("Responsibility Center"=FIELD("Responsibility Center"));

            trigger OnValidate()
            begin
                if not ("Collect Transport" <> '') then begin
                  "Estimated Colect Hour" := 0T;
                  "Collect Stop Address" := '';
                  "Collect Stop Address 2" := '';
                  "Collect Post Code" := '';
                  "Collect Location" := '';
                  "Collect County" := '';
                end;
            end;
        }
        field(8;"Estimated Colect Hour";Time)
        {
            Caption = 'Collect Hour';

            trigger OnLookup()
            var
                rVehicle: Record Transport;
            begin
                rVehicle.Reset;
                rVehicle.SetRange(Type,rVehicle.Type::Lines);
                rVehicle.SetRange("Transport No.","Collect Transport");
                rVehicle.SetRange("Responsibility Center","Responsibility Center");
                if rVehicle.Find('-') then
                  if PAGE.RunModal(PAGE::"Transport Lines List",rVehicle) = ACTION::LookupOK then begin
                    "Estimated Colect Hour" := rVehicle."Estimated Hour";
                    "Collect Stop Address" := rVehicle."Stop Address";
                    "Collect Stop Address 2" := rVehicle."Stop Address 2";
                    "Collect Post Code" := rVehicle."Post Code";
                    "Collect Location" := rVehicle.Location;
                    "Collect County" := rVehicle.County;
                  end;
            end;

            trigger OnValidate()
            var
                rVehicle: Record Transport;
            begin
                if "Estimated Colect Hour" <> 0T then begin
                  rVehicle.Reset;
                  rVehicle.SetRange(Type,rVehicle.Type::Lines);
                  rVehicle.SetRange("Transport No.","Collect Transport");
                  rVehicle.SetRange("Responsibility Center","Responsibility Center");
                  rVehicle.SetRange("Estimated Hour","Estimated Colect Hour");
                  if rVehicle.Find('-') then begin
                    "Collect Stop Address" := rVehicle."Stop Address";
                    "Collect Stop Address 2" := rVehicle."Stop Address 2";
                    "Collect Post Code" := rVehicle."Post Code";
                    "Collect Location" := rVehicle.Location;
                    "Collect County" := rVehicle.County;
                  end else
                    Error(Text0005)

                end else begin
                  "Collect Stop Address" := '';
                  "Collect Stop Address 2" := '';
                  "Collect Post Code" := '';
                  "Collect Location" := '';
                  "Collect County" := '';
                end;
            end;
        }
        field(9;"Deliver Transport";Code[20])
        {
            Caption = 'Deliver Transport';
            TableRelation = Transport."Transport No." WHERE ("Responsibility Center"=FIELD("Responsibility Center"));

            trigger OnValidate()
            begin
                if not ("Deliver Transport" <> '') then begin
                  "Estimated Deliver Hour" := 0T;
                  "Deliver Stop Address" := '';
                  "Deliver Stop Address 2" := '';
                  "Deliver Post Code" := '';
                  "Deliver Location" := '';
                  "Deliver County" := '';
                end;
            end;
        }
        field(11;"Estimated Deliver Hour";Time)
        {
            Caption = 'Deliver Hour';

            trigger OnLookup()
            var
                rVehicle: Record Transport;
            begin
                rVehicle.Reset;
                rVehicle.SetRange(Type,rVehicle.Type::Lines);
                rVehicle.SetRange("Transport No.","Deliver Transport");
                rVehicle.SetRange("Responsibility Center","Responsibility Center");
                if rVehicle.Find('-') then
                  if PAGE.RunModal(PAGE::"Transport Lines List",rVehicle) = ACTION::LookupOK then begin
                    "Estimated Deliver Hour" := rVehicle."Estimated Hour";
                    "Deliver Stop Address" := rVehicle."Stop Address";
                    "Deliver Stop Address 2" := rVehicle."Stop Address 2";
                    "Deliver Post Code" := rVehicle."Post Code";
                    "Deliver Location" := rVehicle.Location;
                    "Deliver County" := rVehicle.County;
                  end;
            end;

            trigger OnValidate()
            var
                rVehicle: Record Transport;
            begin
                if "Estimated Deliver Hour" <> 0T then begin
                  rVehicle.Reset;
                  rVehicle.SetRange(Type,rVehicle.Type::Lines);
                  rVehicle.SetRange("Transport No.","Collect Transport");
                  rVehicle.SetRange("Responsibility Center","Responsibility Center");
                  rVehicle.SetRange("Estimated Hour","Estimated Deliver Hour");
                  if rVehicle.Find('-') then begin
                    "Deliver Stop Address" := rVehicle."Stop Address";
                    "Deliver Stop Address 2" := rVehicle."Stop Address 2";
                    "Deliver Post Code" := rVehicle."Post Code";
                    "Deliver Location" := rVehicle.Location;
                    "Deliver County" := rVehicle.County;
                  end else
                    Error(Text0005);

                end else begin
                  "Deliver Stop Address" := '';
                  "Deliver Stop Address 2" := '';
                  "Deliver Post Code" := '';
                  "Deliver Location" := '';
                  "Deliver County" := '';
                end;
            end;
        }
        field(12;"Collect Stop Address";Text[50])
        {
            Caption = 'Collect Stop Address';
            Editable = false;
        }
        field(13;"Collect Stop Address 2";Text[50])
        {
            Caption = 'Collect Stop Address 2';
            Editable = false;
        }
        field(14;"Collect Post Code";Code[20])
        {
            Caption = 'Collect Post Code';
            Editable = false;
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                tempCounty: Code[20];
            begin
                //PostCode.LookUpPostCode("Collect Location","Collect Post Code",TRUE);
            end;

            trigger OnValidate()
            begin
                //PostCode.ValidatePostCode("Collect Location","Collect Post Code");
            end;
        }
        field(15;"Collect Location";Text[30])
        {
            Caption = 'Collect Location';
            Editable = false;

            trigger OnLookup()
            begin
                //PostCode.LookUpCity("Collect Location","Collect Post Code",TRUE);
            end;

            trigger OnValidate()
            begin
                //PostCode.ValidateCity("Collect Location","Collect Post Code");
            end;
        }
        field(16;"Collect County";Text[100])
        {
            Caption = 'Collect County';
            Editable = false;
        }
        field(17;"Deliver Stop Address";Text[50])
        {
            Caption = 'Deliver Stop Address';
            Editable = false;
        }
        field(18;"Deliver Stop Address 2";Text[50])
        {
            Caption = 'Deliver Stop Address 2';
            Editable = false;
        }
        field(19;"Deliver Post Code";Code[20])
        {
            Caption = 'Deliver Post Code';
            Editable = false;
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                tempCounty: Code[20];
            begin
                //PostCode.LookUpPostCode("Deliver Location","Deliver Post Code",TRUE);
            end;

            trigger OnValidate()
            begin
                //PostCode.ValidatePostCode("Deliver Location","Deliver Post Code");
            end;
        }
        field(20;"Deliver Location";Text[30])
        {
            Caption = 'Deliver Location';
            Editable = false;

            trigger OnLookup()
            begin
                //PostCode.LookUpCity("Deliver Location","Deliver Post Code",TRUE);
            end;

            trigger OnValidate()
            begin
                //PostCode.ValidateCity("Deliver Location","Deliver Post Code");
            end;
        }
        field(21;"Deliver County";Text[100])
        {
            Caption = 'Deliver County';
            Editable = false;
        }
    }

    keys
    {
        key(Key1;"Student Code No.","School Year","Week Day","Responsibility Center")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if rUserSetup.Get(UserId) then
           if rUserSetup."Education Resp. Ctr. Filter" <> '' then
              "Responsibility Center" := rUserSetup."Education Resp. Ctr. Filter"
           else begin
              if rStudents.Get("Student Code No.") then
               "Responsibility Center" := rStudents."Responsibility Center";
           end;
    end;

    var
        cUserEducation: Codeunit "User Education";
        Text0004: Label 'Your identification is set up to process from %1 %2 only.';
        rUserSetup: Record "User Setup";
        PostCode: Record "Post Code";
        Text0005: Label 'The hour selected does not exist for the selected vehicle.';
        rStudents: Record Students;
}

