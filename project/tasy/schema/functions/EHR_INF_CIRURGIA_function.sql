-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ehr_inf_cirurgia ( nr_seq_elemento_p bigint, cd_pessoa_fisica_p bigint, nr_atendimento_p bigint, ie_inf_entidade_p text, ie_atendimento_p text, ie_profissional_p text default 'N') RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w			varchar(20000);
ds_retorno_ww			varchar(20000);

NR_CIRURGIA_w			bigint;
nm_atributo_w			varchar(255);
ds_comando_w			varchar(2000);
ds_comando_ww			varchar(2000);
ds_label_w			varchar(60);
ds_quebra_w			varchar(30);
ds_separador_w			varchar(30);
c001				integer;	
qt_cursor_w			bigint;
nm_usuario_w			varchar(15);

c01 CURSOR FOR 
SELECT	NR_CIRURGIA 
from	CIRURGIA a 
where	nr_atendimento	= nr_atendimento_p 
and	ie_atendimento_p = 'S' 
and	ie_profissional_p = 'N' 
and	NR_CIRURGIA in (	SELECT	max(x.NR_CIRURGIA) 
				from	CIRURGIA x 
				where	nr_atendimento		= nr_atendimento_p 
				and	ie_inf_entidade_p	= 'U' 
				
union
	 
				select	x.NR_CIRURGIA 
				from	CIRURGIA x 
				where	nr_atendimento		= nr_atendimento_p 
				and	ie_inf_entidade_p	= 'T') 

union
 
select	NR_CIRURGIA 
from	CIRURGIA a 
where	nr_atendimento	in (	select	b.nr_atendimento 
				from	atendimento_paciente b 
				where	b.cd_pessoa_fisica 	= cd_pessoa_fisica_p) 
and	ie_atendimento_p = 'N' 
and	ie_profissional_p = 'N' 
and	NR_CIRURGIA in (	select	max(x.NR_CIRURGIA) 
				from	CIRURGIA x 
				where	x.nr_atendimento	 in (	select	b.nr_atendimento 
								from	atendimento_paciente b 
								where	b.cd_pessoa_fisica 	= cd_pessoa_fisica_p) 
				and	ie_inf_entidade_p	= 'U' 
				 
				
union
	 
				select	x.NR_CIRURGIA 
				from	CIRURGIA x 
				where	x.nr_atendimento	in (	select	b.nr_atendimento 
									from	atendimento_paciente b 
									where	b.cd_pessoa_fisica 	= cd_pessoa_fisica_p) 
				 
				and	ie_inf_entidade_p	= 'T') 

union
 
select	NR_CIRURGIA 
from	CIRURGIA a 
where	nr_atendimento	= nr_atendimento_p 
and	ie_atendimento_p = 'S' 
and	ie_profissional_p = 'S' 
and	NR_CIRURGIA in (	select	max(x.NR_CIRURGIA) 
				from	CIRURGIA x 
				where	nr_atendimento		= nr_atendimento_p 
				and	ie_inf_entidade_p	= 'U' 
				and	x.nm_usuario = nm_usuario_w 
				
union
	 
				select	x.NR_CIRURGIA 
				from	CIRURGIA x 
				where	nr_atendimento		= nr_atendimento_p 
				and	x.nm_usuario = nm_usuario_w 
				and	ie_inf_entidade_p	= 'T') 

union
 
select	NR_CIRURGIA 
from	CIRURGIA a 
where	nr_atendimento	in (	select	b.nr_atendimento 
				from	atendimento_paciente b 
				where	b.cd_pessoa_fisica 	= cd_pessoa_fisica_p) 
and	ie_atendimento_p = 'N' 
and	ie_profissional_p = 'S' 
and	NR_CIRURGIA in (	select	max(x.NR_CIRURGIA) 
				from	CIRURGIA x 
				where	x.nr_atendimento	 in (	select	b.nr_atendimento 
								from	atendimento_paciente b 
								where	b.cd_pessoa_fisica 	= cd_pessoa_fisica_p) 
				and	ie_inf_entidade_p	= 'U' 
				and	x.nm_usuario = nm_usuario_w 
				
union
	 
				select	x.NR_CIRURGIA 
				from	CIRURGIA x 
				where	x.nr_atendimento	in (	select	b.nr_atendimento 
									from	atendimento_paciente b 
									where	b.cd_pessoa_fisica 	= cd_pessoa_fisica_p) 
				and	x.nm_usuario = nm_usuario_w 
				and	ie_inf_entidade_p	= 'T') 
order by NR_CIRURGIA;			
		 
C02 CURSOR FOR 
SELECT	coalesce(ds_function,nm_atributo), 
	ds_label, 
	CASE WHEN ie_quebra_linha='S' THEN ' chr(13) ||chr(10) ||'  ELSE null END , 
	ds_separador 
from	ehr_template_cont_ret 
where	nr_seq_elemento	= nr_seq_elemento_p 
order by nr_seq_apres;


BEGIN 
 
nm_usuario_w := WHEB_USUARIO_PCK.get_nm_usuario;
 
open C02;
loop 
fetch C02 into	 
	nm_atributo_w, 
	ds_label_w, 
	ds_quebra_w, 
	ds_separador_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin 
	if (ds_comando_w IS NOT NULL AND ds_comando_w::text <> '') then 
		ds_comando_w	:= ds_comando_w ||'||'||chr(13);
	end if;
	ds_comando_w	:= ds_comando_w ||' decode('||nm_atributo_w||',null,null,'||ds_quebra_w ||chr(39) || ds_label_w ||chr(39) ||'|| '|| nm_atributo_w ||'||'|| chr(39) || ds_separador_w ||chr(39) ||')';
	end;
end loop;
close C02;
 
ds_comando_w	:= 'Select '||ds_comando_w ||' ds '||chr(13) ||'From CIRURGIA ';
 
 
open C01;
loop 
fetch C01 into	 
	NR_CIRURGIA_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	ds_comando_ww	:= ds_comando_w || chr(13) || 'where NR_CIRURGIA = '||to_char(NR_CIRURGIA_w);
	 
	c001 := dbms_sql.open_cursor;
	dbms_sql.parse(c001, ds_comando_ww, dbms_sql.native);
	dbms_sql.define_column(c001, 1, ds_retorno_ww, 2000);
	qt_cursor_w	:= dbms_sql.execute(c001);
	qt_cursor_w	:= dbms_sql.fetch_rows(c001);
	dbms_sql.column_value(c001, 1, ds_retorno_ww);
	dbms_sql.close_cursor(c001);
	ds_retorno_w	:= ds_retorno_w ||ds_retorno_ww ||chr(13);
	end;
end loop;
close C01;
 
return substr(ds_retorno_w,1,2000);
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ehr_inf_cirurgia ( nr_seq_elemento_p bigint, cd_pessoa_fisica_p bigint, nr_atendimento_p bigint, ie_inf_entidade_p text, ie_atendimento_p text, ie_profissional_p text default 'N') FROM PUBLIC;

