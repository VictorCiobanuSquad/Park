#pragma implicitwith disable
page 52760 School
{
    // IT001-CPA Específicos
    //      - Disponibilização campos:
    //       - "ENES Export Path"
    //       - "ENES Import Path"
    //       - "ENEB Export Path"
    //       - "ENEB Import Path"
    //       - "PFEB Export Path4"
    //       - "PFEB Import Path4"
    //       - "PFEB Export Path6"
    //       - "PFEB Import Path6"

    Caption = 'School';
    PageType = Card;
    SourceTable = School;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("School Code"; Rec."School Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("School Name"; Rec."School Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("School Guardianship Name"; Rec."School Guardianship Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("School Guardianship Code"; Rec."School Guardianship Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Parish/Council/District Code"; Rec."Parish/Council/District Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Town; Rec.Town)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(County; Rec.County)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(District; Rec.District)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Prefix; Rec.Prefix)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Prefix Fax"; Rec."Prefix Fax")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Fax No."; Rec."Fax No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("E-mail"; Rec."E-mail")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Home Page"; Rec."Home Page")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Logo School"; Rec."Logo School")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Logo School';
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(NISS; Rec.NISS)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(NCGA; Rec.NCGA)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Head of Services"; Rec."Head of Services")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Head of Services Name"; Rec."Head of Services Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Educational Director"; Rec."Educational Director")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Educational Director Name"; Rec."Educational Director Name")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(Export)
            {
                Caption = 'Export';
                field("Financial Year"; Rec."Financial Year")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("School Year"; Rec."School Year")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Moment; Rec.Moment)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Export Misi Responsible Name"; Rec."Export Misi Responsible Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Export Misi Responsible E-Mail"; Rec."Export Misi Responsible E-Mail")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Export Misi Responsible Phone"; Rec."Export Misi Responsible Phone")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Export Misi Responsible Fax"; Rec."Export Misi Responsible Fax")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(NIB; Rec.NIB)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Autonomy Pedagogical"; Rec."Autonomy Pedagogical")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Pedagogical Autonomy';
                }
                field("Education Level AP"; Rec."Education Level AP")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Autonomy Date"; Rec."Autonomy Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Autonomy Pedagogical2"; Rec."Autonomy Pedagogical2")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Education Level AP2"; Rec."Education Level AP2")
                {
                    ApplicationArea = Basic, Suite;
                    OptionCaption = 'Basic,Secondary';
                }
                field("Autonomy Date2"; Rec."Autonomy Date2")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Parallel Pedagogical"; Rec."Parallel Pedagogical")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Education Level PP"; Rec."Education Level PP")
                {
                    ApplicationArea = Basic, Suite;
                    OptionCaption = 'Basic,Secondary';
                }
                field("Parallel Date"; Rec."Parallel Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Parallel Pedagogical2"; Rec."Parallel Pedagogical2")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Education Level PP2"; Rec."Education Level PP2")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Parallel Date2"; Rec."Parallel Date2")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Contract1; Rec.Contract1)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Contract2; Rec.Contract2)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Contract3; Rec.Contract3)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Contract4; Rec.Contract4)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Entity Guardianship - Type"; Rec."Entity Guardianship - Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Entity Guardianship - Desc."; Rec."Entity Guardianship - Desc.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Entity Guardianship - Description';
                }
                field("Entity Guardianship -Elements1"; Rec."Entity Guardianship -Elements1")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Entity Guardianship -Elements2"; Rec."Entity Guardianship -Elements2")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Entity Guardianship -Elements3"; Rec."Entity Guardianship -Elements3")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Entity Guardianship -Elements4"; Rec."Entity Guardianship -Elements4")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Date 1A Authorization Proof"; Rec."Date 1A Authorization Proof")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Provisional authorization 1st date';
                }
                field("No. of Licence"; Rec."No. of Licence")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Date of Licence"; Rec."Date of Licence")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("No. of Approval"; Rec."No. of Approval")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Date of Approval"; Rec."Date of Approval")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Authorized Capacity"; Rec."Authorized Capacity")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Application Path WinRAR"; Rec."Application Path WinRAR")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Application Version"; Rec."Application Version")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group("Association Contract")
            {
                Caption = 'Association Contract';
                field(Cantina; Rec.Cantina)
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    begin
                        CantineEditable;
                    end;
                }
                field("Cantina - Price per Meal"; Rec."Cantina - Price per Meal")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = CantinaPriceperMealEditable;
                }
                field("Cantina - Num. of Meals"; Rec."Cantina - Num. of Meals")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = CantinaNumofMealsEditable;
                }
                field("Cantina-Num of Meals Echelon A"; Rec."Cantina-Num of Meals Echelon A")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = CantinaNumofMealsEchelonAEdita;
                }
                field("Cantina-Num of Meals Echelon B"; Rec."Cantina-Num of Meals Echelon B")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = CantinaNumofMealsEchelonBEdita;
                }
                group("Covered Classes")
                {
                    Caption = 'Covered Classes';
                    field("Basic Covered Classes"; Rec."Basic Covered Classes")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Secundary Covered Classes"; Rec."Secundary Covered Classes")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Recurrent Covered Classes"; Rec."Recurrent Covered Classes")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
            }
            group("ENES/ENEB")
            {
                Caption = 'ENES/ENEB';
                group(ENES)
                {
                    Caption = 'ENES';
                    field("ENES Export Path"; Rec."ENES Export Path")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("ENES Import Path"; Rec."ENES Import Path")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("ENES Exam Schooling Year1"; Rec."ENES Exam Schooling Year1")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("ENES Exam Schooling Year2"; Rec."ENES Exam Schooling Year2")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("ENES Exam Schooling Year3"; Rec."ENES Exam Schooling Year3")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                group(ENEB)
                {
                    Caption = 'ENEB';
                    field("ENEB Export Path"; Rec."ENEB Export Path")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("ENEB Import Path"; Rec."ENEB Import Path")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("ENEB Exam Schooling Year"; Rec."ENEB Exam Schooling Year")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("ENEB Student Type"; Rec."ENEB Student Type")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Sup. Curricular Activities")
            {
                ApplicationArea = All;
                Caption = 'Sup. Curricular Activities';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Comment Sheet";
                RunPageView = WHERE("Table Name" = CONST(MISI));
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec."Application Version" := Text003; //MISI
    end;

    trigger OnInit()
    begin
        CantinaNumofMealsEchelonBEdita := true;
        CantinaNumofMealsEchelonAEdita := true;
        CantinaPriceperMealEditable := true;
        CantinaNumofMealsEditable := true;
    end;

    trigger OnOpenPage()
    begin
        CantineEditable;
    end;

    var
        [InDataSet]
        CantinaNumofMealsEditable: Boolean;
        [InDataSet]
        CantinaPriceperMealEditable: Boolean;
        [InDataSet]
        CantinaNumofMealsEchelonAEdita: Boolean;
        [InDataSet]
        CantinaNumofMealsEchelonBEdita: Boolean;
        Text003: Label '5.1';

    //[Scope('OnPrem')]
    procedure CantineEditable()
    begin
        if Rec.Cantina = Rec.Cantina::Concessionada then begin
            CantinaNumofMealsEditable := true;
            CantinaPriceperMealEditable := true;
            CantinaNumofMealsEchelonAEdita := true;
            CantinaNumofMealsEchelonBEdita := true;
        end else begin
            CantinaNumofMealsEditable := false;
            CantinaPriceperMealEditable := false;
            CantinaNumofMealsEchelonAEdita := false;
            CantinaNumofMealsEchelonBEdita := false;

        end;
    end;
}

#pragma implicitwith restore

