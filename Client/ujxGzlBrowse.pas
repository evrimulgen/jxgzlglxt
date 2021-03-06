unit ujxGzlBrowse;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GridsEh, DBGridEh, DB, DBClient, StdCtrls, Buttons,
  ExtCtrls, pngimage, frxpngimage, Mask, DBCtrlsEh, DBFieldComboBox,
  DBGridEhGrouping, dxGDIPlusClasses;

type
  TjxGzlBrowse = class(TForm)
    pnl_Title: TPanel;
    img_Title: TImage;
    img_Hint: TImage;
    lbl_Title: TLabel;
    Panel2: TPanel;
    btn_Exit: TBitBtn;
    DataSource1: TDataSource;
    ClientDataSet1: TClientDataSet;
    DBGridEh1: TDBGridEh;
    grp1: TGroupBox;
    cbb_Xq: TDBComboBoxEh;
    cbb_Field: TDBFieldComboBox;
    edt_Value: TEdit;
    btn_Search: TBitBtn;
    lbl_Len: TLabel;
    grp2: TGroupBox;
    cbb_Xn: TDBComboBoxEh;
    btn_Export: TBitBtn;
    grp3: TGroupBox;
    cbb_Xy: TDBComboBoxEh;
    procedure btn_ExitClick(Sender: TObject);
    procedure btn_RefreshClick(Sender: TObject);
    procedure btn_AddClick(Sender: TObject);
    procedure btn_CancelClick(Sender: TObject);
    procedure btn_ExportClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cbb_XqChange(Sender: TObject);
    procedure btn_SearchClick(Sender: TObject);
    procedure edt_ValueChange(Sender: TObject);
    procedure ClientDataSet1BeforePost(DataSet: TDataSet);
    procedure btn_SaveClick(Sender: TObject);
    procedure ClientDataSet1FilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure ClientDataSet1NewRecord(DataSet: TDataSet);
    procedure rg_PostClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    function  GetWhere:string;
    procedure Open_Table;
    procedure GetbkLbList;
    procedure GetKsKcList;
  public
    { Public declarations }
    procedure SetYxSfKmValue(const Yx,Sf,Km:string);
    procedure SetFieldValue(const iCjIndex:Integer;const sCjField,sCzyField:string);
  end;

implementation
uses uDM;
{$R *.dfm}

procedure TjxGzlBrowse.btn_AddClick(Sender: TObject);
begin
  ClientDataSet1.Append;
  DBGridEh1.SetFocus;
end;

procedure TjxGzlBrowse.btn_CancelClick(Sender: TObject);
begin
  ClientDataSet1.Cancel;
end;

procedure TjxGzlBrowse.btn_ExitClick(Sender: TObject);
begin
  Close;
end;

procedure TjxGzlBrowse.btn_ExportClick(Sender: TObject);
begin
  dm.ExportDBEditEH(DBGridEH1);
end;

procedure TjxGzlBrowse.btn_RefreshClick(Sender: TObject);
begin
  Open_Table;
end;

procedure TjxGzlBrowse.btn_SaveClick(Sender: TObject);
begin
  if DataSetNoSave(ClientDataSet1) then
  begin
    if dm.UpdateData('id','select top 0 * from 工作量总表',ClientDataSet1.Delta,True) then
      ClientDataSet1.MergeChangeLog;
  end;
end;

procedure TjxGzlBrowse.btn_SearchClick(Sender: TObject);
begin
  ClientDataSet1.Filtered := False;
  ClientDataSet1.Filtered := edt_Value.Text<>'';
end;

procedure TjxGzlBrowse.cbb_XqChange(Sender: TObject);
begin
  if Self.Showing then
    Open_Table;
end;

procedure TjxGzlBrowse.ClientDataSet1BeforePost(DataSet: TDataSet);
begin
  DataSet.FieldByName('学年').AsString := cbb_Xn.Value;
  DataSet.FieldByName('学期').AsString := cbb_Xq.Value;
  DataSet.FieldByName('开课学院').AsString := cbb_Xy.Text;
end;

procedure TjxGzlBrowse.ClientDataSet1FilterRecord(DataSet: TDataSet; var Accept:
    Boolean);
begin
  Accept := Pos(edt_Value.Text,DataSet.FieldByName(cbb_Field.Text).AsString)>0;
end;

procedure TjxGzlBrowse.ClientDataSet1NewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('学年').AsString := cbb_Xn.Value;
  DataSet.FieldByName('学期').AsString := cbb_Xq.Value;
  DataSet.FieldByName('开课学院').AsString := cbb_Xy.Text;
end;

procedure TjxGzlBrowse.edt_ValueChange(Sender: TObject);
begin
  lbl_Len.Caption := '('+IntToStr(Length(edt_Value.Text))+')';
  btn_Search.Click;
end;

procedure TjxGzlBrowse.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TjxGzlBrowse.FormCreate(Sender: TObject);
var
  sList:TStrings;
begin
  sList := TStringList.Create;
  try
    cbb_Xn.Items.Clear;
    dm.GetXnList(sList);
    cbb_Xn.Items.Assign(sList);
    cbb_Xn.Text := gb_Cur_Xn;
    cbb_Xq.Value := gb_Cur_Xq;

    cbb_Xy.Items.Clear;
    DM.GetXyList(sList);
    cbb_Xy.Items.Assign(sList);
    cbb_Xy.Items.Insert(0,'==不限==');
    
    if cbb_Xy.Items.Count>0 then
      cbb_Xy.ItemIndex := 0;
      
    Open_Table;
  finally
    sList.Free;
  end;
end;

function TjxGzlBrowse.GetWhere: string;
var
  sWhere:string;
begin
  if cbb_Xy.Text<>'==不限==' then
    sWhere := ' where 开课学院='+quotedstr(cbb_Xy.Text)
  else
    sWhere := ' where 1>0';

  sWhere := sWhere+' and 学年='+quotedstr(cbb_Xn.Text);
  sWhere := sWhere+' and 学期='+quotedstr(cbb_Xq.Value);
  Result := sWhere;
end;

procedure TjxGzlBrowse.GetbkLbList;
begin
end;

procedure TjxGzlBrowse.GetKsKcList;
begin
end;

procedure TjxGzlBrowse.Open_Table;
var
  sqlstr:string;
begin
  Screen.Cursor := crHourGlass;
  try
    sqlstr := 'select * from 工作量总表 '+GetWhere+' order by 学年,学期,教师职工号';
    ClientDataSet1.XMLData := DM.OpenData(sqlstr);
    if Self.Showing then
    begin
      DBGridEh1.SetFocus;
      //DBGridEh1.SelectedIndex := 8;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TjxGzlBrowse.rg_PostClick(Sender: TObject);
begin
  Open_Table;
end;

procedure TjxGzlBrowse.SetFieldValue(const iCjIndex:Integer;const sCjField, sCzyField: string);
begin
end;

procedure TjxGzlBrowse.SetYxSfKmValue(const Yx, Sf, Km: string);
begin
end;

end.
