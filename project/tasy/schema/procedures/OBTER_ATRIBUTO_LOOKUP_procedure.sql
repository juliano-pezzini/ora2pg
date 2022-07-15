-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_atributo_lookup (nm_tabela_p text, nm_atributo_p text, nm_atributo_cd_p INOUT text, nm_atributo_ds_p INOUT text, nm_tabela_ref_p INOUT text, ds_sql_p INOUT text, ie_restringe_estab_p INOUT text, ie_restringe_empresa_p INOUT text, ds_complemento_p INOUT text) AS $body$
DECLARE


ds_sql_w				varchar(2000)	:= '';
nm_tabela_ref_w			varchar(50)	:= '';
ie_restrige_estab_w		varchar(01);
ie_restrige_empresa_w	varchar(01);
ds_complemento_w		varchar(255);
i						integer;

cursor_w	integer;
col_cnt		integer;
campos_w	dbms_sql.desc_tab;


BEGIN

begin
select 	b.nm_tabela_referencia
into STRICT	nm_tabela_ref_w
from	integridade_referencial b,
		integridade_atributo a
where	a.nm_tabela	= b.nm_tabela
and		a.nm_integridade_referencial	= b.nm_integridade_referencial
and		a.nm_tabela		= nm_tabela_p
and		a.nm_atributo	= nm_atributo_p
and		b.nm_integridade_referencial not in ('PLSPRES_PESJUCP_FK','PRESMAT_MATMARC_FK') /* Francisco - 28/06/2011 - Caso específico / Almir - 22/05/2014 - iOS */
and		0	<
		(SELECT	count(*)
		from	integridade_atributo x
		where	a.nm_integridade_referencial	= x.nm_integridade_referencial
		and		a.nm_tabela	= x.nm_tabela);
exception
	when others then
		nm_tabela_ref_w	:= '';
end;

select	coalesce(max(ie_restringe_estab),'N'),
		coalesce(max(ie_restringe_empresa),'N')
into STRICT	ie_restrige_estab_w,
		ie_restrige_empresa_W
from	tabela_sistema
where	nm_tabela	= nm_tabela_ref_w;

begin
select	ds_sql_lookup
into STRICT	ds_sql_w
from	Tabela_Sistema
where	nm_tabela	= nm_tabela_ref_w;
exception
	when others then
		ds_sql_w	:= '';
end;

begin
	cursor_w	:= DBMS_SQL.OPEN_CURSOR;
	DBMS_SQL.PARSE(cursor_w, ds_sql_w, dbms_sql.native);
	dbms_sql.describe_columns(cursor_w, col_cnt, campos_w);

	for i in 1 .. col_cnt loop
		if (i = 1) then
			nm_atributo_cd_p	:= campos_w[i].col_name;
		elsif (i = 2) then
			nm_atributo_ds_p	:= campos_w[i].col_name;
			exit;
		end if;
	end loop;

	dbms_sql.close_cursor(cursor_w);

	ds_sql_p	:= ds_sql_w;
exception when others then
	dbms_sql.close_cursor(cursor_w);
	ds_sql_p			:= ds_sql_w;
	ds_sql_w			:= UPPER(ds_sql_w);
	ds_sql_w			:= replace(ds_sql_w, 'SELECT','');
	ds_sql_w			:= replace(ds_sql_w, chr(13)||chr(10),'');
	ds_sql_w			:= substr(ds_sql_w, 1, position('FROM' in ds_sql_w) -1);
	ds_sql_w			:= replace(ds_sql_w, ',',' ');
	/*ds_sql_w			:= replace(ds_sql_w, '  ',' ');*/

	ds_sql_w			:= substr(ds_sql_w, 2, length(ds_sql_w) -1);
	i					:= position(' ' in ds_sql_w);
	nm_atributo_cd_p	:= replace(substr(ds_sql_w,1, i-1),' ','');
	nm_atributo_ds_p	:= ltrim(substr(ds_sql_w,i + 1, length(ds_sql_w)));

	if (position(' ' in nm_atributo_ds_p) <> 0) then
		nm_atributo_ds_p	:= replace(substr(nm_atributo_ds_p, 1, position(' ' in nm_atributo_ds_p)),' ','');
	else
		nm_atributo_ds_p	:= replace(substr(nm_atributo_ds_p, 1, length(nm_atributo_ds_p)),' ','');
	end if;
end;

nm_tabela_ref_p			:= nm_tabela_ref_w;
ie_restringe_estab_p	:= ie_restrige_estab_w;
ie_restringe_empresa_p	:= ie_restrige_empresa_w;
ds_complemento_p		:= ds_complemento_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_atributo_lookup (nm_tabela_p text, nm_atributo_p text, nm_atributo_cd_p INOUT text, nm_atributo_ds_p INOUT text, nm_tabela_ref_p INOUT text, ds_sql_p INOUT text, ie_restringe_estab_p INOUT text, ie_restringe_empresa_p INOUT text, ds_complemento_p INOUT text) FROM PUBLIC;

