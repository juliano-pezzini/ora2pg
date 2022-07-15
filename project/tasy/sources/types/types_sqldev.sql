--------------------------------------------------------
--  File created - Tuesday-July-12-2022   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Type CCD_MANAGEMENT_RC
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."CCD_MANAGEMENT_RC" force as object (
  CD NUMBER,
  DS VARCHAR2(250),
  IE_SITUACAO VARCHAR2(2),
  NR_SUP NUMBER
);

/
--------------------------------------------------------
--  DDL for Type CCD_MANAGEMENT_TB
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."CCD_MANAGEMENT_TB" is table of CCD_MANAGEMENT_RC;

/
--------------------------------------------------------
--  DDL for Type CCD_VALIDATE_DATA
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."CCD_VALIDATE_DATA" as object (
 NM_PROCEDURE		VARCHAR2(255),
 STATIC_BASE    CLOB,
 USER_NAME      VARCHAR2(120),
 CHANGE_DATE    DATE,
 DS_APPLICATION VARCHAR2(120),
 CD_MANAGEMENT  NUMBER,
 IE_TYPE_OBJECT VARCHAR2(120)
);

/
--------------------------------------------------------
--  DDL for Type GET_CHART_ROW
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."GET_CHART_ROW" as object(
	code_group			varchar2(15),
	ie_union 				number(10),
	name				varchar2(255),
	comercial_name			varchar2(255),
	ie_medic_nao_inform		varchar2(15),
	description			varchar2(255),
	color				varchar2(15),
	style 				varchar2(30),
	shape 				varchar2(30),
	qt_size 				number(5),
	fill_color 				varchar2(15),
	shaded 				varchar2(15),
	fixed_scale 			number(2),
	init_date 				date,
	end_date 			date,
	CODE_CHART 			number(10),
	seq_apresentacao 			number(10),
	nr_cirurgia 			number(10),
	nr_seq_pepo 			number(10),
	nm_usuario 			varchar2(15),
	nm_tabela			varchar2(50),
	nm_atributo 			varchar2(50),
	ie_sinal_vital 			varchar2(15),
	nr_seq_superior 			number(10),
	end_of_administration 		varchar2(15),
	cd_material 			number(6),
	cd_unid_medida_adm 		varchar2(30),
	ie_modo_adm 			varchar2(15),
	nr_seq_agente 			number(10),
	ds_dosagem 			varchar2(15),
	ie_tipo				varchar2(15)
);

/
--------------------------------------------------------
--  DDL for Type GET_CHART_TABLE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."GET_CHART_TABLE" as table of get_chart_row;

/
--------------------------------------------------------
--  DDL for Type GET_CHART_TUBES_LINES_ROW
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."GET_CHART_TUBES_LINES_ROW" as object(
name						varchar2(80),
color						varchar2(30),
dt_instalacao			date,
end_date					date,
code_group				varchar2(15),
code_chart				number(10),
nr_seq_apres			number(10),
dt_fim					date,
ie_sucesso				varchar(15),
nr_atendimento			number(10),
nr_cirurgia				number(10),
nr_seq_pepo				number(10),
ie_permite_disp_alta	varchar(15),
description				varchar(255),
max_scale				number(10),
min_scale				number(10),
style						varchar(30),
shape						varchar2(30),
qt_size					number(5),
shaded					varchar2(15),
fixed_scale				number(2),
fill_position			varchar(15),
point_shape				varchar(15)
);

/
--------------------------------------------------------
--  DDL for Type GET_CHART_TUBES_LINES_TABLE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."GET_CHART_TUBES_LINES_TABLE" as table of get_chart_tubes_lines_row;

/
--------------------------------------------------------
--  DDL for Type GET_CHART_VALUES_ROW
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."GET_CHART_VALUES_ROW" force as object(
	nr_cirurgia 		number(10),
	nr_seq_pepo			number(10),
	dt_registro			date,
	dt_start				date,
	dt_end				date,
	qt_valor				number(15,4),
	y_min					number(15,4),
	y_max					number(15,4),
	code_group			varchar2(15),
	nm_tabela			varchar2(50),
	nm_atributo			varchar2(50),
	vl_dominio			varchar2(15),
	ie_bolus				varchar2(15),
	nr_seq_superior	number(10),
	nm_usuario			varchar2(15),
	nr_sequencia		number(10),
	values_group		number(10)
);

/
--------------------------------------------------------
--  DDL for Type GET_CHART_VALUES_TABLE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."GET_CHART_VALUES_TABLE" as table of get_chart_values_row;

/
--------------------------------------------------------
--  DDL for Type LOG_SETTINGS_ROW
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."LOG_SETTINGS_ROW" force as object(
		ie_storage_access varchar2(1),
		ie_storage_repeated_access varchar2(1),
		ie_storage_filter varchar2(1),
		nr_sequence_record number(10));

/
--------------------------------------------------------
--  DDL for Type LOG_SETTINGS_TABLE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."LOG_SETTINGS_TABLE" as table of log_settings_row;

/
--------------------------------------------------------
--  DDL for Type LT_ANALISE_INCONSIST
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."LT_ANALISE_INCONSIST" FORCE AS OBJECT (
  DS_ANALISE_PARA_USUARIO VARCHAR2(255),
  IE_TIPO_ACOMPANHAMENTO  VARCHAR2(1),
  IE_TIPO_AJUSTE          VARCHAR2(1)
);

/
--------------------------------------------------------
--  DDL for Type LT_ANALISE_INCONSIST_TABLE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."LT_ANALISE_INCONSIST_TABLE" AS TABLE OF LT_Analise_Inconsist;

/
--------------------------------------------------------
--  DDL for Type LT_ATRIBUTO_LOOKUP
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."LT_ATRIBUTO_LOOKUP" FORCE AS OBJECT (
  nm_tabela_p            varchar2(255),
  nm_atributo_p          varchar2(255),
  nm_atributo_cd_p       varchar2(255),
  nm_atributo_ds_p       varchar2(255),
  nm_tabela_ref_p        varchar2(50),
  ds_sql_p               varchar2(4000),
  ie_restringe_estab_p   varchar2(01),
  ie_restringe_empresa_p varchar2(01),
  ds_complemento_p       varchar2(255)
);

/
--------------------------------------------------------
--  DDL for Type LT_ATRIBUTO_LOOKUP_TABLE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."LT_ATRIBUTO_LOOKUP_TABLE" AS TABLE OF LT_Atributo_Lookup;

/
--------------------------------------------------------
--  DDL for Type LT_DATE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."LT_DATE" AS TABLE OF DATE

/
--------------------------------------------------------
--  DDL for Type LT_MENSAGEM_SMS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."LT_MENSAGEM_SMS" force as object(
	nr_celular  varchar2(50),
	dt_resposta  varchar2(50),
	ds_mensagem  varchar2(4000)
);

/
--------------------------------------------------------
--  DDL for Type LT_MENSAGENS_SMS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."LT_MENSAGENS_SMS" as object(
	mensagens t_mensagens_sms
);

/
--------------------------------------------------------
--  DDL for Type LT_NUMBER
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."LT_NUMBER" AS TABLE OF NUMBER

/
--------------------------------------------------------
--  DDL for Type LT_PARAMETROS_SMS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."LT_PARAMETROS_SMS" as object(
	ds_operacao varchar2(15),
	cd_empresa varchar2(255),
	nm_usuario varchar2(255),
	ds_senha varchar2(255),
	ds_url_sms varchar2(255),
	ds_destinatario varchar(255),
	ds_remetente varchar2(255),
	ds_mensagem varchar2(4000),
	id_sms varchar2(255),
	cd_sms_provider number(10),
	ip_servidor_proxy varchar2(255),
	ds_endereco_rmi varchar2(255),
	ds_porta_rmi varchar2(255),
	ds_dominio_servidor varchar2(255),
	dt_envio date,
	cd_status varchar2(255),
	nm_usuario_proxy varchar2(255),
	ds_senha_proxy varchar2(255),
	ie_consistir_destinatario varchar2(1)
);

/
--------------------------------------------------------
--  DDL for Type LT_PARAM_INTEGRACAO
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."LT_PARAM_INTEGRACAO" as table of T_PARAM_INTEGRACAO;

/
--------------------------------------------------------
--  DDL for Type LT_RETORNO
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."LT_RETORNO" as object (
	valor varchar2(255)
);

/
--------------------------------------------------------
--  DDL for Type PERSON_NAME_DEV_ROW
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."PERSON_NAME_DEV_ROW" force as object(
	cd_pessoa_fisica varchar2(10),
	nm_pessoa_fisica varchar2(200)
);

/
--------------------------------------------------------
--  DDL for Type PERSON_NAME_DEV_TABLE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."PERSON_NAME_DEV_TABLE" as table of person_name_dev_row;

/
--------------------------------------------------------
--  DDL for Type PERSON_NAME_ROW
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."PERSON_NAME_ROW" as object(	nr_sequencia number(10), ds_given_name varchar2(128), ds_component_name_1 varchar2(128), ds_component_name_2 varchar2(128), ds_component_name_3 varchar2(128), ds_family_name varchar2(128), ds_type varchar2(15))

/
--------------------------------------------------------
--  DDL for Type PERSON_NAME_ROW_SCORE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."PERSON_NAME_ROW_SCORE" as object(nr_sequencia number(10), ds_given_name varchar2(128), ds_component_name_1 varchar2(128), ds_component_name_2 varchar2(128),   ds_component_name_3 varchar2(128),   ds_family_name varchar2(128),   ds_type varchar2(15),   nr_score number(5))

/
--------------------------------------------------------
--  DDL for Type PERSON_NAME_TABLE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."PERSON_NAME_TABLE" as table of person_name_row_score

/
--------------------------------------------------------
--  DDL for Type PHILIPS_JSON
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."PHILIPS_JSON" as object (


  json_data p_json_value_array,
  check_for_duplicate number,


  constructor function philips_json return self as result,
  constructor function philips_json(str varchar2) return self as result,
  constructor function philips_json(str in clob) return self as result,
  constructor function philips_json(cast philips_json_value) return self as result,
  constructor function philips_json(l in out nocopy philips_json_list) return self as result,


  member procedure remove(pair_name varchar2),
  member procedure put(self in out nocopy philips_json, pair_name varchar2, pair_value philips_json_value, position pls_integer default null),
  member procedure put(self in out nocopy philips_json, pair_name varchar2, pair_value varchar2, position pls_integer default null),
  member procedure put(self in out nocopy philips_json, pair_name varchar2, pair_value number, position pls_integer default null),
  member procedure put(self in out nocopy philips_json, pair_name varchar2, pair_value boolean, position pls_integer default null),
  member procedure check_duplicate(self in out nocopy philips_json, v_set boolean),
  member procedure remove_duplicates(self in out nocopy philips_json),


  member procedure put(self in out nocopy philips_json, pair_name varchar2, pair_value philips_json, position pls_integer default null),
  member procedure put(self in out nocopy philips_json, pair_name varchar2, pair_value philips_json_list, position pls_integer default null),


  member function count return number,
  member function get(pair_name varchar2) return philips_json_value,
  member function get(position pls_integer) return philips_json_value,
  member function index_of(pair_name varchar2) return number,
  member function exist(pair_name varchar2) return boolean,


  member function to_char(spaces boolean default true, chars_per_line number default 0) return varchar2,
  member procedure to_clob(self in philips_json, buf in out nocopy clob, spaces boolean default false, chars_per_line number default 0, erase_clob boolean default true),
  member procedure print(self in philips_json, spaces boolean default true, chars_per_line number default 8192, jsonp varchar2 default null), --32512 is maximum
  member procedure htp(self in philips_json, spaces boolean default false, chars_per_line number default 0, jsonp varchar2 default null),

  member function to_json_value return philips_json_value,

  member function path(json_path varchar2, base number default 1) return philips_json_value,


  member procedure path_put(self in out nocopy philips_json, json_path varchar2, elem philips_json_value, base number default 1),
  member procedure path_put(self in out nocopy philips_json, json_path varchar2, elem varchar2  , base number default 1),
  member procedure path_put(self in out nocopy philips_json, json_path varchar2, elem number    , base number default 1),
  member procedure path_put(self in out nocopy philips_json, json_path varchar2, elem boolean   , base number default 1),
  member procedure path_put(self in out nocopy philips_json, json_path varchar2, elem philips_json_list , base number default 1),
  member procedure path_put(self in out nocopy philips_json, json_path varchar2, elem philips_json      , base number default 1),


  member procedure path_remove(self in out nocopy philips_json, json_path varchar2, base number default 1),


  member function get_values return philips_json_list,
  member function get_keys return philips_json_list

) not final;
/
CREATE OR REPLACE EDITIONABLE TYPE BODY "COMERCIAL"."PHILIPS_JSON" as


  constructor function philips_json return self as result as
  begin
    self.json_data := p_json_value_array();
    self.check_for_duplicate := 1;
    return;
  end;

  constructor function philips_json(str varchar2) return self as result as
  begin
    self := philips_json_parser.parser(str);
    self.check_for_duplicate := 1;
    return;
  end;

  constructor function philips_json(str in clob) return self as result as
  begin
    self := philips_json_parser.parser(str);
    self.check_for_duplicate := 1;
    return;
  end;

  constructor function philips_json(cast philips_json_value) return self as result as
    x number;
  begin
    x := cast.object_or_array.getobject(self);
    self.check_for_duplicate := 1;
    return;
  end;

  constructor function philips_json(l in out nocopy philips_json_list) return self as result as
  begin
    for i in 1 .. l.list_data.count loop
      if(l.list_data(i).mapname is null or l.list_data(i).mapname like 'row%') then
      l.list_data(i).mapname := 'row'||i;
      end if;
      l.list_data(i).mapindx := i;
    end loop;

    self.json_data := l.list_data;
    self.check_for_duplicate := 1;
    return;
  end;


  member procedure remove(self in out nocopy philips_json, pair_name varchar2) as
    temp philips_json_value;
    indx pls_integer;

    function get_member(pair_name varchar2) return philips_json_value as
      indx pls_integer;
    begin
      indx := json_data.first;
      loop
        exit when indx is null;
        if(pair_name is null and json_data(indx).mapname is null) then return json_data(indx); end if;
        if(json_data(indx).mapname = pair_name) then return json_data(indx); end if;
        indx := json_data.next(indx);
      end loop;
      return null;
    end;
  begin
    temp := get_member(pair_name);
    if(temp is null) then return; end if;

    indx := json_data.next(temp.mapindx);
    loop
      exit when indx is null;
      json_data(indx).mapindx := indx - 1;
      json_data(indx-1) := json_data(indx);
      indx := json_data.next(indx);
    end loop;
    json_data.trim(1);

  end;

  member procedure put(self in out nocopy philips_json, pair_name varchar2, pair_value philips_json_value, position pls_integer default null) as
    insert_value philips_json_value := nvl(pair_value, philips_json_value.makenull);
    indx pls_integer; x number;
    temp philips_json_value;
    function get_member(pair_name varchar2) return philips_json_value as
      indx pls_integer;
    begin
      indx := json_data.first;
      loop
        exit when indx is null;
        if(pair_name is null and json_data(indx).mapname is null) then return json_data(indx); end if;
        if(json_data(indx).mapname = pair_name) then return json_data(indx); end if;
        indx := json_data.next(indx);
      end loop;
      return null;
    end;
  begin
    insert_value.mapname := pair_name;

    if(self.check_for_duplicate = 1) then temp := get_member(pair_name); else temp := null; end if;
    if(temp is not null) then
      insert_value.mapindx := temp.mapindx;
      json_data(temp.mapindx) := insert_value;
      return;
    elsif(position is null or position > self.count) then
      json_data.extend(1);
      json_data(json_data.count) := insert_value;
      json_data(json_data.count).mapindx := json_data.count;
    elsif(position < 2) then
      indx := json_data.last;
      json_data.extend;
      loop
        exit when indx is null;
        temp := json_data(indx);
        temp.mapindx := indx+1;
        json_data(temp.mapindx) := temp;
        indx := json_data.prior(indx);
      end loop;
      json_data(1) := insert_value;
      insert_value.mapindx := 1;
    else
      indx := json_data.last;
      json_data.extend;
      loop
        temp := json_data(indx);
        temp.mapindx := indx + 1;
        json_data(temp.mapindx) := temp;
        exit when indx = position;
        indx := json_data.prior(indx);
      end loop;
      json_data(position) := insert_value;
      json_data(position).mapindx := position;
    end if;
  end;

  member procedure put(self in out nocopy philips_json, pair_name varchar2, pair_value varchar2, position pls_integer default null) as
  begin
    put(pair_name, philips_json_value(pair_value), position);
  end;

  member procedure put(self in out nocopy philips_json, pair_name varchar2, pair_value number, position pls_integer default null) as
  begin
    if(pair_value is null) then
      put(pair_name, philips_json_value(), position);
    else
      put(pair_name, philips_json_value(pair_value), position);
    end if;
  end;

  member procedure put(self in out nocopy philips_json, pair_name varchar2, pair_value boolean, position pls_integer default null) as
  begin
    if(pair_value is null) then
      put(pair_name, philips_json_value(), position);
    else
      put(pair_name, philips_json_value(pair_value), position);
    end if;
  end;

  member procedure check_duplicate(self in out nocopy philips_json, v_set boolean) as
  begin
    if(v_set) then
      check_for_duplicate := 1;
    else
      check_for_duplicate := 0;
    end if;
  end;


  member procedure put(self in out nocopy philips_json, pair_name varchar2, pair_value philips_json, position pls_integer default null) as
  begin
    if(pair_value is null) then
      put(pair_name, philips_json_value(), position);
    else
      put(pair_name, pair_value.to_json_value, position);
    end if;
  end;

  member procedure put(self in out nocopy philips_json, pair_name varchar2, pair_value philips_json_list, position pls_integer default null) as
  begin
    if(pair_value is null) then
      put(pair_name, philips_json_value(), position);
    else
      put(pair_name, pair_value.to_json_value, position);
    end if;
  end;

  member function count return number as
  begin
    return self.json_data.count;
  end;

  member function get(pair_name varchar2) return philips_json_value as
    indx pls_integer;
  begin
    indx := json_data.first;
    loop
      exit when indx is null;
      if(pair_name is null and json_data(indx).mapname is null) then return json_data(indx); end if;
      if(json_data(indx).mapname = pair_name) then return json_data(indx); end if;
      indx := json_data.next(indx);
    end loop;
    return null;
  end;

  member function get(position pls_integer) return philips_json_value as
  begin
    if(self.count >= position and position > 0) then
      return self.json_data(position);
    end if;
    return null;
  end;

  member function index_of(pair_name varchar2) return number as
    indx pls_integer;
  begin
    indx := json_data.first;
    loop
      exit when indx is null;
      if(pair_name is null and json_data(indx).mapname is null) then return indx; end if;
      if(json_data(indx).mapname = pair_name) then return indx; end if;
      indx := json_data.next(indx);
    end loop;
    return -1;
  end;

  member function exist(pair_name varchar2) return boolean as
  begin
    return (self.get(pair_name) is not null);
  end;


  member function to_char(spaces boolean default true, chars_per_line number default 0) return varchar2 as
  begin
    if(spaces is null) then
      return philips_json_printer.pretty_print(self, line_length => chars_per_line);
    else
      return philips_json_printer.pretty_print(self, spaces, line_length => chars_per_line);
    end if;
  end;

  member procedure to_clob(self in philips_json, buf in out nocopy clob, spaces boolean default false, chars_per_line number default 0, erase_clob boolean default true) as
  begin
    if(spaces is null) then
      philips_json_printer.pretty_print(self, false, buf, line_length => chars_per_line, erase_clob => erase_clob);
    else
      philips_json_printer.pretty_print(self, spaces, buf, line_length => chars_per_line, erase_clob => erase_clob);
    end if;
  end;

  member procedure print(self in philips_json, spaces boolean default true, chars_per_line number default 8192, jsonp varchar2 default null) as --32512 is the real maximum in sqldeveloper
    my_clob clob;
  begin
    my_clob := empty_clob();
    dbms_lob.createtemporary(my_clob, true);
    philips_json_printer.pretty_print(self, spaces, my_clob, case when (chars_per_line>32512) then 32512 else chars_per_line end);
    philips_json_printer.dbms_output_clob(my_clob, philips_json_printer.newline_char, jsonp);
    dbms_lob.freetemporary(my_clob);
  end;

  member procedure htp(self in philips_json, spaces boolean default false, chars_per_line number default 0, jsonp varchar2 default null) as
    my_clob clob;
  begin
    my_clob := empty_clob();
    dbms_lob.createtemporary(my_clob, true);
    philips_json_printer.pretty_print(self, spaces, my_clob, chars_per_line);
    philips_json_printer.htp_output_clob(my_clob, jsonp);
    dbms_lob.freetemporary(my_clob);
  end;

  member function to_json_value return philips_json_value as
  begin
    return philips_json_value(sys.anydata.convertobject(self));
  end;


  member function path(json_path varchar2, base number default 1) return philips_json_value as
  begin
    return philips_json_ext.get_json_value(self, json_path, base);
  end path;


  member procedure path_put(self in out nocopy philips_json, json_path varchar2, elem philips_json_value, base number default 1) as
  begin
    philips_json_ext.put(self, json_path, elem, base);
  end path_put;

  member procedure path_put(self in out nocopy philips_json, json_path varchar2, elem varchar2, base number default 1) as
  begin
    philips_json_ext.put(self, json_path, elem, base);
  end path_put;

  member procedure path_put(self in out nocopy philips_json, json_path varchar2, elem number, base number default 1) as
  begin
    if(elem is null) then
      philips_json_ext.put(self, json_path, philips_json_value(), base);
    else
      philips_json_ext.put(self, json_path, elem, base);
    end if;
  end path_put;

  member procedure path_put(self in out nocopy philips_json, json_path varchar2, elem boolean, base number default 1) as
  begin
    if(elem is null) then
      philips_json_ext.put(self, json_path, philips_json_value(), base);
    else
      philips_json_ext.put(self, json_path, elem, base);
    end if;
  end path_put;

  member procedure path_put(self in out nocopy philips_json, json_path varchar2, elem philips_json_list, base number default 1) as
  begin
    if(elem is null) then
      philips_json_ext.put(self, json_path, philips_json_value(), base);
    else
      philips_json_ext.put(self, json_path, elem, base);
    end if;
  end path_put;

  member procedure path_put(self in out nocopy philips_json, json_path varchar2, elem philips_json, base number default 1) as
  begin
    if(elem is null) then
      philips_json_ext.put(self, json_path, philips_json_value(), base);
    else
      philips_json_ext.put(self, json_path, elem, base);
    end if;
  end path_put;

  member procedure path_remove(self in out nocopy philips_json, json_path varchar2, base number default 1) as
  begin
    philips_json_ext.remove(self, json_path, base);
  end path_remove;

  member function get_keys return philips_json_list as
    keys philips_json_list;
    indx pls_integer;
  begin
    keys := philips_json_list();
    indx := json_data.first;
    loop
      exit when indx is null;
      keys.append(json_data(indx).mapname);
      indx := json_data.next(indx);
    end loop;
    return keys;
  end;

  member function get_values return philips_json_list as
    vals philips_json_list := philips_json_list();
  begin
    vals.list_data := self.json_data;
    return vals;
  end;

  member procedure remove_duplicates(self in out nocopy philips_json) as
  begin
    philips_json_parser.remove_duplicates(self);
  end remove_duplicates;


end;

/
--------------------------------------------------------
--  DDL for Type PHILIPS_JSON_LIST
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."PHILIPS_JSON_LIST" as object (

  list_data p_json_value_array,
  constructor function philips_json_list return self as result,
  constructor function philips_json_list(str varchar2) return self as result,
  constructor function philips_json_list(str clob) return self as result,
  constructor function philips_json_list(cast philips_json_value) return self as result,

  member procedure append(self in out nocopy philips_json_list, elem philips_json_value, position pls_integer default null),
  member procedure append(self in out nocopy philips_json_list, elem varchar2, position pls_integer default null),
  member procedure append(self in out nocopy philips_json_list, elem number, position pls_integer default null),
  member procedure append(self in out nocopy philips_json_list, elem boolean, position pls_integer default null),
  member procedure append(self in out nocopy philips_json_list, elem philips_json_list, position pls_integer default null),

  member procedure replace(self in out nocopy philips_json_list, position pls_integer, elem philips_json_value),
  member procedure replace(self in out nocopy philips_json_list, position pls_integer, elem varchar2),
  member procedure replace(self in out nocopy philips_json_list, position pls_integer, elem number),
  member procedure replace(self in out nocopy philips_json_list, position pls_integer, elem boolean),
  member procedure replace(self in out nocopy philips_json_list, position pls_integer, elem philips_json_list),

  member function count return number,
  member procedure remove(self in out nocopy philips_json_list, position pls_integer),
  member procedure remove_first(self in out nocopy philips_json_list),
  member procedure remove_last(self in out nocopy philips_json_list),
  member function get(position pls_integer) return philips_json_value,
  member function head return philips_json_value,
  member function last return philips_json_value,
  member function tail return philips_json_list,


  member function to_char(spaces boolean default true, chars_per_line number default 0) return varchar2,
  member procedure to_clob(self in philips_json_list, buf in out nocopy clob, spaces boolean default false, chars_per_line number default 0, erase_clob boolean default true),
  member procedure print(self in philips_json_list, spaces boolean default true, chars_per_line number default 8192, jsonp varchar2 default null), --32512 is maximum
  member procedure htp(self in philips_json_list, spaces boolean default false, chars_per_line number default 0, jsonp varchar2 default null),


  member function path(json_path varchar2, base number default 1) return philips_json_value,

  member procedure path_put(self in out nocopy philips_json_list, json_path varchar2, elem philips_json_value, base number default 1),
  member procedure path_put(self in out nocopy philips_json_list, json_path varchar2, elem varchar2  , base number default 1),
  member procedure path_put(self in out nocopy philips_json_list, json_path varchar2, elem number    , base number default 1),
  member procedure path_put(self in out nocopy philips_json_list, json_path varchar2, elem boolean   , base number default 1),
  member procedure path_put(self in out nocopy philips_json_list, json_path varchar2, elem philips_json_list , base number default 1),


  member procedure path_remove(self in out nocopy philips_json_list, json_path varchar2, base number default 1),

  member function to_json_value return philips_json_value


) not final;
/
CREATE OR REPLACE EDITIONABLE TYPE BODY "COMERCIAL"."PHILIPS_JSON_LIST" as

  constructor function philips_json_list return self as result as
  begin
    self.list_data := p_json_value_array();
    return;
  end;

  constructor function philips_json_list(str varchar2) return self as result as
  begin
    self := philips_json_parser.parse_list(str);
    return;
  end;

  constructor function philips_json_list(str clob) return self as result as
  begin
    self := philips_json_parser.parse_list(str);
    return;
  end;

  constructor function philips_json_list(cast philips_json_value) return self as result as
    x number;
  begin
    x := cast.object_or_array.getobject(self);
    return;
  end;


  member procedure append(self in out nocopy philips_json_list, elem philips_json_value, position pls_integer default null) as
    indx pls_integer;
    insert_value philips_json_value := NVL(elem, philips_json_value);
  begin
    if(position is null or position > self.count) then --end of list
      indx := self.count + 1;
      self.list_data.extend(1);
      self.list_data(indx) := insert_value;
    elsif(position < 1) then --new first
      indx := self.count;
      self.list_data.extend(1);
      for x in reverse 1 .. indx loop
        self.list_data(x+1) := self.list_data(x);
      end loop;
      self.list_data(1) := insert_value;
    else
      indx := self.count;
      self.list_data.extend(1);
      for x in reverse position .. indx loop
        self.list_data(x+1) := self.list_data(x);
      end loop;
      self.list_data(position) := insert_value;
    end if;

  end;

  member procedure append(self in out nocopy philips_json_list, elem varchar2, position pls_integer default null) as
  begin
    append(philips_json_value(elem), position);
  end;

  member procedure append(self in out nocopy philips_json_list, elem number, position pls_integer default null) as
  begin
    if(elem is null) then
      append(philips_json_value(), position);
    else
      append(philips_json_value(elem), position);
    end if;
  end;

  member procedure append(self in out nocopy philips_json_list, elem boolean, position pls_integer default null) as
  begin
    if(elem is null) then
      append(philips_json_value(), position);
    else
      append(philips_json_value(elem), position);
    end if;
  end;

  member procedure append(self in out nocopy philips_json_list, elem philips_json_list, position pls_integer default null) as
  begin
    if(elem is null) then
      append(philips_json_value(), position);
    else
      append(elem.to_json_value, position);
    end if;
  end;

 member procedure replace(self in out nocopy philips_json_list, position pls_integer, elem philips_json_value) as
    insert_value philips_json_value := NVL(elem, philips_json_value);
    indx number;
  begin
    if(position > self.count) then
      indx := self.count + 1;
      self.list_data.extend(1);
      self.list_data(indx) := insert_value;
    elsif(position < 1) then
      null;
    else
      self.list_data(position) := insert_value;
    end if;
  end;

  member procedure replace(self in out nocopy philips_json_list, position pls_integer, elem varchar2) as
  begin
    replace(position, philips_json_value(elem));
  end;

  member procedure replace(self in out nocopy philips_json_list, position pls_integer, elem number) as
  begin
    if(elem is null) then
      replace(position, philips_json_value());
    else
      replace(position, philips_json_value(elem));
    end if;
  end;

  member procedure replace(self in out nocopy philips_json_list, position pls_integer, elem boolean) as
  begin
    if(elem is null) then
      replace(position, philips_json_value());
    else
      replace(position, philips_json_value(elem));
    end if;
  end;

  member procedure replace(self in out nocopy philips_json_list, position pls_integer, elem philips_json_list) as
  begin
    if(elem is null) then
      replace(position, philips_json_value());
    else
      replace(position, elem.to_json_value);
    end if;
  end;

  member function count return number as
  begin
    return self.list_data.count;
  end;

  member procedure remove(self in out nocopy philips_json_list, position pls_integer) as
  begin
    if(position is null or position < 1 or position > self.count) then return; end if;
    for x in (position+1) .. self.count loop
      self.list_data(x-1) := self.list_data(x);
    end loop;
    self.list_data.trim(1);
  end;

  member procedure remove_first(self in out nocopy philips_json_list) as
  begin
    for x in 2 .. self.count loop
      self.list_data(x-1) := self.list_data(x);
    end loop;
    if(self.count > 0) then
      self.list_data.trim(1);
    end if;
  end;

  member procedure remove_last(self in out nocopy philips_json_list) as
  begin
    if(self.count > 0) then
      self.list_data.trim(1);
    end if;
  end;

  member function get(position pls_integer) return philips_json_value as
  begin
    if(self.count >= position and position > 0) then
      return self.list_data(position);
    end if;
    return null;
  end;

  member function head return philips_json_value as
  begin
    if(self.count > 0) then
      return self.list_data(self.list_data.first);
    end if;
    return null;
  end;

  member function last return philips_json_value as
  begin
    if(self.count > 0) then
      return self.list_data(self.list_data.last);
    end if;
    return null;
  end;

  member function tail return philips_json_list as
    t philips_json_list;
  begin
    if(self.count > 0) then
      t := philips_json_list(self.list_data);
      t.remove(1);
      return t;
    else return philips_json_list(); end if;
  end;

  member function to_char(spaces boolean default true, chars_per_line number default 0) return varchar2 as
  begin
    if(spaces is null) then
      return philips_json_printer.pretty_print_list(self, line_length => chars_per_line);
    else
      return philips_json_printer.pretty_print_list(self, spaces, line_length => chars_per_line);
    end if;
  end;

  member procedure to_clob(self in philips_json_list, buf in out nocopy clob, spaces boolean default false, chars_per_line number default 0, erase_clob boolean default true) as
  begin
    if(spaces is null) then
      philips_json_printer.pretty_print_list(self, false, buf, line_length => chars_per_line, erase_clob => erase_clob);
    else
      philips_json_printer.pretty_print_list(self, spaces, buf, line_length => chars_per_line, erase_clob => erase_clob);
    end if;
  end;

  member procedure print(self in philips_json_list, spaces boolean default true, chars_per_line number default 8192, jsonp varchar2 default null) as --32512 is the real maximum in sqldeveloper
    my_clob clob;
  begin
    my_clob := empty_clob();
    dbms_lob.createtemporary(my_clob, true);
    philips_json_printer.pretty_print_list(self, spaces, my_clob, case when (chars_per_line>32512) then 32512 else chars_per_line end);
    philips_json_printer.dbms_output_clob(my_clob, philips_json_printer.newline_char, jsonp);
    dbms_lob.freetemporary(my_clob);
  end;

  member procedure htp(self in philips_json_list, spaces boolean default false, chars_per_line number default 0, jsonp varchar2 default null) as
    my_clob clob;
  begin
    my_clob := empty_clob();
    dbms_lob.createtemporary(my_clob, true);
    philips_json_printer.pretty_print_list(self, spaces, my_clob, chars_per_line);
    philips_json_printer.htp_output_clob(my_clob, jsonp);
    dbms_lob.freetemporary(my_clob);
  end;

  member function path(json_path varchar2, base number default 1) return philips_json_value as
    cp philips_json_list := self;
  begin
    return philips_json_ext.get_json_value(philips_json(cp), json_path, base);
  end path;



  member procedure path_put(self in out nocopy philips_json_list, json_path varchar2, elem philips_json_value, base number default 1) as
    objlist philips_json;
    jp philips_json_list := philips_json_ext.parsePath(json_path, base);
  begin
    while(jp.head().get_number() > self.count) loop
      self.append(philips_json_value());
    end loop;

    objlist := philips_json(self);
    philips_json_ext.put(objlist, json_path, elem, base);
    self := objlist.get_values;
  end path_put;

  member procedure path_put(self in out nocopy philips_json_list, json_path varchar2, elem varchar2, base number default 1) as
    objlist philips_json;
    jp philips_json_list := philips_json_ext.parsePath(json_path, base);
  begin
    while(jp.head().get_number() > self.count) loop
      self.append(philips_json_value());
    end loop;

    objlist := philips_json(self);
    philips_json_ext.put(objlist, json_path, elem, base);
    self := objlist.get_values;
  end path_put;

  member procedure path_put(self in out nocopy philips_json_list, json_path varchar2, elem number, base number default 1) as
    objlist philips_json;
    jp philips_json_list := philips_json_ext.parsePath(json_path, base);
  begin
    while(jp.head().get_number() > self.count) loop
      self.append(philips_json_value());
    end loop;

    objlist := philips_json(self);

    if(elem is null) then
      philips_json_ext.put(objlist, json_path, philips_json_value, base);
    else
      philips_json_ext.put(objlist, json_path, elem, base);
    end if;
    self := objlist.get_values;
  end path_put;

  member procedure path_put(self in out nocopy philips_json_list, json_path varchar2, elem boolean, base number default 1) as
    objlist philips_json;
    jp philips_json_list := philips_json_ext.parsePath(json_path, base);
  begin
    while(jp.head().get_number() > self.count) loop
      self.append(philips_json_value());
    end loop;

    objlist := philips_json(self);
    if(elem is null) then
      philips_json_ext.put(objlist, json_path, philips_json_value, base);
    else
      philips_json_ext.put(objlist, json_path, elem, base);
    end if;
    self := objlist.get_values;
  end path_put;

  member procedure path_put(self in out nocopy philips_json_list, json_path varchar2, elem philips_json_list, base number default 1) as
    objlist philips_json;
    jp philips_json_list := philips_json_ext.parsePath(json_path, base);
  begin
    while(jp.head().get_number() > self.count) loop
      self.append(philips_json_value());
    end loop;

    objlist := philips_json(self);
    if(elem is null) then
      philips_json_ext.put(objlist, json_path, philips_json_value, base);
    else
      philips_json_ext.put(objlist, json_path, elem, base);
    end if;
    self := objlist.get_values;
  end path_put;

  member procedure path_remove(self in out nocopy philips_json_list, json_path varchar2, base number default 1) as
    objlist philips_json := philips_json(self);
  begin
    philips_json_ext.remove(objlist, json_path, base);
    self := objlist.get_values;
  end path_remove;


  member function to_json_value return philips_json_value as
  begin
    return philips_json_value(sys.anydata.convertobject(self));
  end;


end;

/
--------------------------------------------------------
--  DDL for Type PHILIPS_JSON_VALUE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."PHILIPS_JSON_VALUE" as object
(
  typeval number(1),
  str varchar2(32767),
  num number,
  object_or_array sys.anydata,
  extended_str clob,

  mapname varchar2(4000),
  mapindx number(32),

  constructor function philips_json_value(object_or_array sys.anydata) return self as result,
  constructor function philips_json_value(str varchar2, esc boolean default true) return self as result,
  constructor function philips_json_value(str clob, esc boolean default true) return self as result,
  constructor function philips_json_value(num number) return self as result,
  constructor function philips_json_value(b boolean) return self as result,
  constructor function philips_json_value return self as result,
  static function makenull return philips_json_value,

  member function get_type return varchar2,
  member function get_string(max_byte_size number default null, max_char_size number default null) return varchar2,
  member procedure get_string(self in philips_json_value, buf in out nocopy clob),
  member function get_number return number,
  member function get_bool return boolean,
  member function get_null return varchar2,

  member function is_object return boolean,
  member function is_array return boolean,
  member function is_string return boolean,
  member function is_number return boolean,
  member function is_bool return boolean,
  member function is_null return boolean,


  member function to_char(spaces boolean default true, chars_per_line number default 0) return varchar2,
  member procedure to_clob(self in philips_json_value, buf in out nocopy clob, spaces boolean default false, chars_per_line number default 0, erase_clob boolean default true),
  member procedure print(self in philips_json_value, spaces boolean default true, chars_per_line number default 8192, jsonp varchar2 default null), --32512 is maximum
  member procedure htp(self in philips_json_value, spaces boolean default false, chars_per_line number default 0, jsonp varchar2 default null),

  member function value_of(self in philips_json_value, max_byte_size number default null, max_char_size number default null) return varchar2

) not final;
/
CREATE OR REPLACE EDITIONABLE TYPE BODY "COMERCIAL"."PHILIPS_JSON_VALUE" as

  constructor function philips_json_value(object_or_array sys.anydata) return self as result as
  begin
    case object_or_array.gettypename
      when sys_context('userenv', 'current_schema')||'.PHILIPS_JSON_LIST' then self.typeval := 2;
      when sys_context('userenv', 'current_schema')||'.PHILIPS_JSON' then self.typeval := 1;
      else
	  wheb_mensagem_pck.exibir_mensagem_abort('philips_json_value init error (philips_json or philips_json\_List allowed)');
	  --rase_application_error(-20102, 'philips_json_value init error (philips_json or philips_json\_List allowed)');
    end case;
    self.object_or_array := object_or_array;
    if(self.object_or_array is null) then self.typeval := 6; end if;

    return;
  end philips_json_value;

  constructor function philips_json_value(str varchar2, esc boolean default true) return self as result as
  begin
    self.typeval := 3;
    if(esc) then self.num := 1; else self.num := 0; end if;
    self.str := str;
    return;
  end philips_json_value;

  constructor function philips_json_value(str clob, esc boolean default true) return self as result as
    amount number := 5000;
  begin
    self.typeval := 3;
    if(esc) then self.num := 1; else self.num := 0; end if;
    if(dbms_lob.getlength(str) > amount) then
      extended_str := str;
    end if;
    if dbms_lob.getlength(str) > 0 then
      dbms_lob.read(str, amount, 1, self.str);
    end if;
    return;
  end philips_json_value;

  constructor function philips_json_value(num number) return self as result as
  begin
    self.typeval := 4;
    self.num := num;
    if(self.num is null) then self.typeval := 6; end if;
    return;
  end philips_json_value;

  constructor function philips_json_value(b boolean) return self as result as
  begin
    self.typeval := 5;
    self.num := 0;
    if(b) then self.num := 1; end if;
    if(b is null) then self.typeval := 6; end if;
    return;
  end philips_json_value;

  constructor function philips_json_value return self as result as
  begin
    self.typeval := 6;
    return;
  end philips_json_value;

  static function makenull return philips_json_value as
  begin
    return philips_json_value;
  end makenull;

  member function get_type return varchar2 as
  begin
    case self.typeval
    when 1 then return 'object';
    when 2 then return 'array';
    when 3 then return 'string';
    when 4 then return 'number';
    when 5 then return 'bool';
    when 6 then return 'null';
    end case;

    return 'unknown type';
  end get_type;

  member function get_string(max_byte_size number default null, max_char_size number default null) return varchar2 as
  begin
    if(self.typeval = 3) then
      if(max_byte_size is not null) then
        return substrb(self.str,1,max_byte_size);
      elsif (max_char_size is not null) then
        return substr(self.str,1,max_char_size);
      else
        return self.str;
      end if;
    end if;
    return null;
  end get_string;

  member procedure get_string(self in philips_json_value, buf in out nocopy clob) as
  begin
    if(self.typeval = 3) then
      if(extended_str is not null) then
        dbms_lob.copy(buf, extended_str, dbms_lob.getlength(extended_str));
      else
        dbms_lob.writeappend(buf, length(self.str), self.str);
      end if;
    end if;
  end get_string;


  member function get_number return number as
  begin
    if(self.typeval = 4) then
      return self.num;
    end if;
    return null;
  end get_number;

  member function get_bool return boolean as
  begin
    if(self.typeval = 5) then
      return self.num = 1;
    end if;
    return null;
  end get_bool;

  member function get_null return varchar2 as
  begin
    if(self.typeval = 6) then
      return 'null';
    end if;
    return null;
  end get_null;

  member function is_object return boolean as begin return self.typeval = 1; end;
  member function is_array return boolean as begin return self.typeval = 2; end;
  member function is_string return boolean as begin return self.typeval = 3; end;
  member function is_number return boolean as begin return self.typeval = 4; end;
  member function is_bool return boolean as begin return self.typeval = 5; end;
  member function is_null return boolean as begin return self.typeval = 6; end;

  member function to_char(spaces boolean default true, chars_per_line number default 0) return varchar2 as
  begin
    if(spaces is null) then
      return philips_json_printer.pretty_print_any(self, line_length => chars_per_line);
    else
      return philips_json_printer.pretty_print_any(self, spaces, line_length => chars_per_line);
    end if;
  end;

  member procedure to_clob(self in philips_json_value, buf in out nocopy clob, spaces boolean default false, chars_per_line number default 0, erase_clob boolean default true) as
  begin
    if(spaces is null) then
      philips_json_printer.pretty_print_any(self, false, buf, line_length => chars_per_line, erase_clob => erase_clob);
    else
      philips_json_printer.pretty_print_any(self, spaces, buf, line_length => chars_per_line, erase_clob => erase_clob);
    end if;
  end;

  member procedure print(self in philips_json_value, spaces boolean default true, chars_per_line number default 8192, jsonp varchar2 default null) as --32512 is the real maximum in sqldeveloper
    my_clob clob;
  begin
    my_clob := empty_clob();
    dbms_lob.createtemporary(my_clob, true);
    philips_json_printer.pretty_print_any(self, spaces, my_clob, case when (chars_per_line>32512) then 32512 else chars_per_line end);
    philips_json_printer.dbms_output_clob(my_clob, philips_json_printer.newline_char, jsonp);
    dbms_lob.freetemporary(my_clob);
  end;

  member procedure htp(self in philips_json_value, spaces boolean default false, chars_per_line number default 0, jsonp varchar2 default null) as
    my_clob clob;
  begin
    my_clob := empty_clob();
    dbms_lob.createtemporary(my_clob, true);
    philips_json_printer.pretty_print_any(self, spaces, my_clob, chars_per_line);
    philips_json_printer.htp_output_clob(my_clob, jsonp);
    dbms_lob.freetemporary(my_clob);
  end;

  member function value_of(self in philips_json_value, max_byte_size number default null, max_char_size number default null) return varchar2 as
  begin
    case self.typeval
    when 1 then return 'philips_json object';
    when 2 then return 'philips_json array';
    when 3 then return self.get_string(max_byte_size,max_char_size);
    when 4 then return self.get_number();
    when 5 then if(self.get_bool()) then return 'true'; else return 'false'; end if;
    else return null;
    end case;
  end;

end;

/
--------------------------------------------------------
--  DDL for Type P_JSON_VALUE_ARRAY
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."P_JSON_VALUE_ARRAY" as table of philips_json_value;

/
--------------------------------------------------------
--  DDL for Type RECTYPE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."RECTYPE" as object(nm_tabela varchar2(50),nm_campo varchar2(50), ds_valor varchar2(4000), nr_valor number, nr_seq_visao number, dt_liberacao	date, dt_valor date);

/
--------------------------------------------------------
--  DDL for Type RECTYPEFORM
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."RECTYPEFORM" as object(	nm_tabela 				varchar2(50),
																nm_campo 				varchar2(50),
																ds_valor 				varchar2(4000),
																nr_valor 				number,
																nr_seq_visao			number,
																dt_liberacao			date,
																dt_valor 				date,
																ie_obter_resultado 	varchar2(15),
																ds_aux_1 				varchar2(4000),
																ds_aux_2 				varchar2(4000),
																ds_aux_3 				varchar2(4000),
																ds_aux_4 				varchar2(4000),
																nr_aux_1					number,
																nr_aux_2					number,
																nr_aux_3					number,
																nr_aux_4					number,
																dt_aux_1					date,
																dt_aux_2					date,
																dt_aux_3					date,
																dt_aux_4					date);

/
--------------------------------------------------------
--  DDL for Type RECTYPEFORMOFT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."RECTYPEFORMOFT" as object(	nm_tabela 				varchar2(50),
																	nm_campo 				varchar2(50),
																	ds_valor 				varchar2(4000),
																	nr_valor 				number,
																	nr_seq_visao			number,
																	dt_liberacao			date,
																	dt_valor 				date,
																	ie_obter_resultado 	varchar2(15),
																	ie_obrigatorio 		varchar2(15),
																	ds_aux_1 				varchar2(4000),
																	ds_aux_2 				varchar2(4000),
																	ds_aux_3 				varchar2(4000),
																	ds_aux_4 				varchar2(4000),
																	nr_aux_1					number,
																	nr_aux_2					number,
																	nr_aux_3					number,
																	nr_aux_4					number,
																	dt_aux_1					date,
																	dt_aux_2					date,
																	dt_aux_3					date,
																	dt_aux_4					date);

/
--------------------------------------------------------
--  DDL for Type SCORING
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."SCORING" AS OBJECT (
     matchRange VARCHAR2(128)
    ,itemScore NUMBER
);

/
--------------------------------------------------------
--  DDL for Type SEARCH_MACROS_ROW
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."SEARCH_MACROS_ROW" force as object(
	ds_macro_philips varchar2(255),
	nr_seq_macro_philips number(10),
	ds_macro_client varchar2(255),
	nr_seq_macro_client number(10),
	ds_locale	varchar2(20)
);

/
--------------------------------------------------------
--  DDL for Type SEARCH_MACROS_TABLE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."SEARCH_MACROS_TABLE" as table of search_macros_row;

/
--------------------------------------------------------
--  DDL for Type STRARRAY
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."STRARRAY" AS TABLE OF VARCHAR2(255);

/
--------------------------------------------------------
--  DDL for Type STRRECTYPE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."STRRECTYPE" AS TABLE OF rectype;

/
--------------------------------------------------------
--  DDL for Type STRRECTYPEFORM
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."STRRECTYPEFORM" AS TABLE OF recTypeForm



/
--------------------------------------------------------
--  DDL for Type STRRECTYPEFORMOFT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."STRRECTYPEFORMOFT" AS TABLE OF recTypeFormOft



/
--------------------------------------------------------
--  DDL for Type TABELA_CUBO
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."TABELA_CUBO" as table of TIPO_CUBO;

/
--------------------------------------------------------
--  DDL for Type TAB_PLS_PARAMETRO
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."TAB_PLS_PARAMETRO" as table of tipo_pls_parametro;

/
--------------------------------------------------------
--  DDL for Type TIPO_CUBO
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."TIPO_CUBO" force as object
(
	ie_tipo_coluna	varchar2(1),
	vl_coluna_1	varchar2(100),
	vl_coluna_2	varchar2(100),
	vl_coluna_3	varchar2(100),
	vl_coluna_4	varchar2(100),
	vl_coluna_5	varchar2(100),
	vl_coluna_6	varchar2(100),
	vl_coluna_7	varchar2(100),
	vl_coluna_8	varchar2(100),
	vl_coluna_9	varchar2(100),
	vl_coluna_10	varchar2(100),
	vl_coluna_11	varchar2(100),
	vl_coluna_12	varchar2(100),
	vl_total		varchar2(100),
	vl_total_geral	varchar2(100),
	nm_usuario	varchar2(100)
);

/
--------------------------------------------------------
--  DDL for Type TIPO_PLS_PARAMETRO
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."TIPO_PLS_PARAMETRO" force as object
(
	nr_sequencia number( 10, 0),
	cd_estabelecimento number( 4, 0),
	ie_exige_lib_bras varchar2( 1),
	ie_fora_linha_simpro varchar2( 1),
	qt_idade_limite number( 3, 0),
	qt_tempo_limite number( 3, 0),
	nr_seq_emissor number( 10, 0),
	qt_dias_protocolo number( 3, 0),
	dt_atualizacao date,
	nm_usuario varchar2( 15),
	dt_atualizacao_nrec date,
	nm_usuario_nrec varchar2( 15),
	cd_centro_custo number( 8, 0),
	nr_seq_trans_fin_inadi number( 10, 0),
	cd_tipo_recebimento number( 5, 0),
	cd_tipo_receb_inadimplencia number( 5, 0),
	cd_operacao_desp_nf number( 4, 0),
	cd_natureza_operacao_desp number( 4, 0),
	nr_seq_sit_trib_desp number( 10, 0),
	cd_serie_desp_nf varchar2( 5),
	ie_material_rede_propria varchar2( 1),
	nr_seq_trans_fin_baixa_conta number( 10, 0),
	nr_seq_trans_fin_baixa_reemb number( 10, 0),
	nr_seq_conta_banco number( 10, 0),
	nr_seq_motivo_inclusao number( 10, 0),
	cd_perfil_comunic_integr number( 5, 0),
	ie_origem_titulo varchar2( 2),
	cd_tipo_taxa_juro number( 10, 0),
	cd_tipo_taxa_multa number( 10, 0),
	pr_juro_padrao number( 7, 4),
	pr_multa_padrao number( 7, 4),
	ie_origem_tit_pagar varchar2( 2),
	cd_natureza_operacao number( 4, 0),
	nr_seq_classif_fiscal number( 10, 0),
	nr_seq_sit_trib number( 10, 0),
	cd_serie_nf varchar2( 5),
	cd_operacao_nf number( 4, 0),
	cd_condicao_pagamento number( 10, 0),
	qt_dias_rescisao_mig number( 5, 0),
	nr_seq_trans_fin_baixa number( 10, 0),
	ie_origem_tit_reembolso varchar2( 2),
	ie_fluxo_caixa varchar2( 2),
	ie_idade_saldo varchar2( 2),
	ie_lucro_prejuizo varchar2( 2),
	ie_solvencia varchar2( 2),
	ie_balancete_ativo varchar2( 2),
	ie_balancete_passivo varchar2( 2),
	ie_balancete_receita varchar2( 2),
	ie_balancete_despesa varchar2( 2),
	ie_gerar_coparticipacao varchar2( 2),
	nr_seq_trans_fin_baixa_vend number( 10, 0),
	cd_conta_financ number( 10, 0),
	nr_seq_tipo_avaliacao number( 10, 0),
	cd_conta_financ_conta number( 10, 0),
	cd_conta_financ_ressarcimento number( 10, 0),
	cd_conta_financ_reembolso number( 10, 0),
	nr_seq_relatorio number( 10, 0),
	nr_seq_relatorio_cat number( 10, 0),
	ie_tela_guia_cm varchar2( 1),
	cd_cgc_ans varchar2( 14),
	ie_origem_tit_taxa_saude varchar2( 2),
	nr_seq_trans_fin_baixa_taxa number( 10, 0),
	cd_conta_financ_taxa number( 10, 0),
	cd_tipo_receb_adiantamento number( 5, 0),
	cd_moeda_adiantamento number( 4, 0),
	cd_portador number( 10, 0),
	cd_tipo_portador number( 5, 0),
	nr_seq_trans_fin_baixa_prov number( 10, 0),
	cd_conta_financ_prov number( 10, 0),
	nr_seq_modelo number( 10, 0),
	nr_seq_agente_motivador number( 10, 0),
	ie_hash_conta varchar2( 1),
	ie_intercambio varchar2( 2),
	ie_pro_rata_dia varchar2( 1),
	ie_geracao_nota_titulo varchar2( 2),
	nr_seq_motivo_rescisao number( 10, 0),
	qt_tempo_ausente number( 10, 0),
	ie_calculo_coparticipacao varchar2( 3),
	cd_banco_desc_folha number( 5, 0),
	nr_seq_conta_banco_desc number( 10, 0),
	ie_esquema_contabil varchar2( 1),
	ie_regra_autogerado varchar2( 1),
	ie_importacao_material varchar2( 1),
	ie_reajuste_faixa_etaria varchar2( 1),
	ie_contab_prov_copartic varchar2( 1),
	dt_base_validade_carteira varchar2( 1),
	ie_gerar_validade_cartao varchar2( 1),
	ie_isentar_carencia_nasc varchar2( 1),
	ie_gerar_usuario_eventual varchar2( 1),
	nr_seq_plano_usu_eventual number( 10, 0),
	ie_obriga_vinc_mat varchar2( 1),
	nr_seq_estrut_mat_rev number( 10, 0),
	nr_seq_emissor_provisorio number( 10, 0),
	dt_base_validade_cart_inter varchar2( 2),
	ie_quebrar_fatura_ptu_tx varchar2( 3),
	ie_utiliza_material_ops varchar2( 1),
	nr_seq_motivo_rescisao_obito number( 10, 0),
	ie_material_ops varchar2( 1),
	qt_dias_ativ_canal_com number( 5, 0),
	ie_corresponsabilidade varchar2( 2),
	ie_utilizar_liberacao_pacote varchar2( 5),
	ie_atualiza_via_acesso varchar2( 1),
	ie_eventos_sinistros varchar2( 2),
	ie_guia_unica varchar2( 3),
	ie_calculo_pacote varchar2( 3),
	ie_versao varchar2( 10),
	cd_interface_importacao_benef number( 5, 0),
	ie_data_base_proporcional varchar2( 1),
	ie_permite_cnes_duplic varchar2( 1),
	nr_seq_trans_fin_con_mens number( 10, 0),
	nr_seq_trans_fin_baixa_mens number( 10, 0),
	ie_libera_item_sem_glosa varchar2( 1),
	ie_mes_cobranca_reaj varchar2( 1),
	ie_cobranca_pos varchar2( 1),
	ie_mes_cobranca_reaj_reg varchar2( 1),
	ie_data_base_coparticipacao varchar2( 2),
	ie_cancela_lib_matmed varchar2( 1),
	ie_arredondar_tps varchar2( 1),
	ie_base_venc_lote_pag varchar2( 3),
	nr_seq_motivo_adaptacao number( 10, 0),
	ie_calculo_pos_estab varchar2( 3),
	ie_material_intercambio varchar2( 3),
	ie_tipo_lote_baixa_mens varchar2( 3),
	ie_data_ref_reaj_adaptado varchar2( 2),
	ie_dt_protocolo_a500 varchar2( 3),
	ie_define_se_gera_analise varchar2( 2),
	qt_min_limite_analise number( 5, 0),
	ie_consiste_prest_envio_a500 varchar2( 1),
	ie_gerar_glosa_valor_zerado varchar2( 1),
	ie_pos_estab_faturamento varchar2( 1),
	ie_fluxo_contest varchar2( 3),
	ie_scpa_contrato varchar2( 1),
	ie_ref_copartic_mens varchar2( 2),
	ie_reajustar_benef_cancelado varchar2( 2),
	nr_seq_motivo_cancel_agenda number( 10, 0),
	ie_via_acesso_regra varchar2( 1),
	ie_gerar_copartic_zerado varchar2( 1),
	ie_bloqueto_deb_auto varchar2( 1),
	ie_calculo_base_glosa varchar2( 1),
	ie_atualizar_valor_apresent varchar2( 1),
	ie_tipo_geracao_a800 varchar2( 2),
	ie_considerar_dt_liq_cancel varchar2( 1),
	ie_preco_prestador_partic varchar2( 1),
	ie_renovacao_cartao_dt_atual varchar2( 1),
	ie_data_referencia_nf varchar2( 2),
	ie_pagador_contrato_princ varchar2( 1),
	ie_reajuste varchar2( 1),
	nr_seq_motivo_via number( 10, 0),
	ie_tipo_feriado varchar2( 1),
	nr_seq_motivo_rescisao_a100 number( 10, 0),
	ds_mascara_cart_padrao varchar2( 30),
	qt_dias_venc_primeira_mens number( 10, 0),
	ie_geracao_nota_titulo_pf varchar2( 2),
	ie_data_base_prot_reap varchar2( 1),
	ie_restringe_conjuge varchar2( 1),
	ie_venc_cart_fim_mes varchar2( 1),
	ie_pessoa_contrato varchar2( 1),
	ie_analise_cm_nova varchar2( 1),
	ie_gerar_usuario_even_repasse varchar2( 1),
	ie_geracao_coparticipacao varchar2( 2),
	ie_geracao_pos_estabelecido varchar2( 1),
	ie_manter_cco_migracao varchar2( 1),
	nr_seq_grupo_pre_analise number( 10, 0),
	ie_carencia_abrangencia_ant varchar2( 1),
	ie_copartic_grau_partic varchar2( 1),
	ie_taxa_grau_partic varchar2( 1),
	ie_fechar_conta_glosa varchar2( 1),
	ie_emissao_cart_repasse_pre varchar2( 1),
	ie_permite_prest_exc_a400 varchar2( 1),
	ie_ocor_glosa_parcial varchar2( 1),
	cd_convenio number( 5, 0),
	ie_vincular_pag_coop_a100 varchar2( 1),
	cd_categoria varchar2( 10),
	ie_copartic_contestacao varchar2( 1),
	nr_seq_trans_fin_contab number( 10, 0),
	ie_consistir_matricula_est varchar2( 1),
	cd_interf_atuarial_produto number( 5, 0),
	cd_interf_atuarial_benef number( 5, 0),
	cd_interf_atuarial_prest number( 5, 0),
	cd_interf_atuarial_mens number( 5, 0),
	cd_interf_atuarial_desp number( 5, 0),
	ie_pos_estab_fat_resc varchar2( 1),
	ie_truncar_valor_reajuste varchar2( 1),
	ie_gerar_contratacao_sca_a100 varchar2( 1),
	ie_exige_declaracao_analise varchar2( 1),
	cd_cgc_emissao_nf varchar2( 14),
	ie_validade_tarja_ultimo_dia varchar2( 1),
	ie_forma_consist_diaria varchar2( 5),
	ie_desfaz_lote_pag_copartic varchar2( 1),
	ie_venc_cartao_rescisao varchar2( 1),
	ie_alt_nova_analise varchar2( 1),
	ie_manter_tabela_benef_adap varchar2( 1),
	ie_preco_interc_congenere varchar2( 1),
	ie_origem_proc_valido varchar2( 1),
	ie_destacar_reajuste_sca varchar2( 1),
	ie_prioridade_tx_item varchar2( 3),
	ie_data_emissao_tit_a560 varchar2( 5),
	ie_controle_coparticipacao varchar2( 2),
	ie_atualizar_grupo_ans varchar2( 1),
	cd_moeda_adiantamento_pago number( 4, 0),
	nr_seq_tipo_adiant_pago number( 10, 0),
	ie_reaj_idade_limite_pre varchar2( 1),
	ie_logradouro_sib varchar2( 2),
	nr_seq_classe_tit_mens number( 10, 0),
	ie_sip_contagem_evento varchar2( 1),
	ds_conteudo_email varchar2( 4000),
	ie_prestador_solic_util varchar2( 1),
	ie_honorario_pos varchar2( 10),
	ie_dt_ref_comissao_equipe varchar2( 2),
	qt_dias_limite_prorrogacao number( 10, 0),
	ie_apropriacao_copartic varchar2( 1),
	ie_gerar_cod_tit varchar2( 1),
	ds_remetente_sms varchar2( 30),
	ie_porte_amb_tuss varchar2( 1),
	ie_vinc_internacao varchar2( 1),
	cd_cgc_ressarc varchar2( 14),
	nr_seq_trans_fin_baixa_ress number( 10, 0),
	ie_cobra_tx_inter_copartic varchar2( 1),
	ie_respeita_cadastro_prof varchar2(1)
);

/
--------------------------------------------------------
--  DDL for Type TIPO_VAL_TAB_AMB
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."TIPO_VAL_TAB_AMB" as object
(
	vl_procedimento		number(15,4),
	vl_custo_operacional	number(15,4),
	vl_medico		number(15,4),
	vl_filme		number(15,4),
	nr_porte_anestesico	number(2),
	vl_anestesista		number(15,2),
	nr_auxiliares		number(2),
	vl_auxiliares_amb	number(15,4),
	qt_filme		number(15,4)
);

/
--------------------------------------------------------
--  DDL for Type T_MENSAGENS_SMS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."T_MENSAGENS_SMS" is table of lt_mensagem_sms;

/
--------------------------------------------------------
--  DDL for Type T_PARAM_INTEGRACAO
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "COMERCIAL"."T_PARAM_INTEGRACAO" FORCE AS OBJECT
(
 nr_sequencia  NUMBER(10),
 ds_parametros VARCHAR2(4000)
);

/
