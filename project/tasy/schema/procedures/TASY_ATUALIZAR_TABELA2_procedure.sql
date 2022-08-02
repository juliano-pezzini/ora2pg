-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE lista AS (
	nm varchar(50),
	vl varchar(32764),
	vl_2 bytea);


CREATE OR REPLACE PROCEDURE tasy_atualizar_tabela2 ( nm_owner_origem_p text, nm_tabela_origem_p text, nm_tabela_destino_p text, ds_condicao_p text, ie_excluir_reg_antigo_p text default 'S', ie_constraint_p text default 'S', ie_novo_sql text default 'N') AS $body$
DECLARE


ds_virgula_w		varchar(01);
ds_comando_w		varchar(2000);
vl_retorno_w		varchar(255);
nm_tabela_origem_w	varchar(50);
nm_tabela_destino_w	varchar(50);
nm_atributo_w          	varchar(50);
ds_update_w		varchar(4000);
ds_parametros_w		varchar(32000);
ds_restricao_w		varchar(4000);
ds_restricao_delete_w	varchar(4000);
ds_select_w		varchar(4000);
ds_delete_w		varchar(4000);
nm_owner_origem_w	varchar(15);
c001			integer;
c002			integer;
c003			integer;

ie_exportar_w		varchar(1);
retorno_w			integer;
ds_erro_w		varchar(4000);
type myArray is table of lista index by integer;

/*Contem os parametros do SQL*/

ar_parametros_w   myArray;

/*TIPOS DE COLUNAS*/

dtab_w        dbms_sql.desc_tab;
col_cnt_w     integer;
l_date_w      timestamp;
l_long_raw_w bytea;
vl_parametro_w varchar(32764);

BEGIN

nm_owner_origem_w := nm_owner_origem_p;

if ( coalesce(nm_owner_origem_p::text, '') = '' ) or ( nm_owner_origem_p = '') then
	nm_owner_origem_w := 'TASY_VERSAO';
end if;

CALL gravar_processo_longo('De : ' || nm_owner_origem_p ||'.'|| nm_tabela_origem_p || ' para ' || nm_tabela_destino_p,'TASY_ATUALIZAR_TABELA',null);

nm_tabela_origem_w	:= upper(nm_tabela_origem_p);
nm_tabela_destino_w	:= upper(nm_tabela_destino_p);
ds_virgula_w		:= '';


RAISE EXCEPTION '%', nm_owner_origem_p USING ERRCODE = '45011';

ds_comando_w	:=	' SELECT	nm_atributo ' ||
			' FROM		'|| nm_owner_origem_p ||'.tabela_atributo ' ||
			' WHERE		nm_tabela = :nm_tabela ' ||
			' AND		ie_tipo_atributo <> :ie_tipo_atributo ' ||
			' AND		ie_atualizar_versao = :ie_atualizar_versao ' ||
			' order by nr_sequencia_criacao';

C003 := DBMS_SQL.OPEN_CURSOR;
DBMS_SQL.PARSE(C003, ds_comando_w, dbms_sql.Native);
DBMS_SQL.DEFINE_COLUMN(c003,1,nm_atributo_w,50);
DBMS_SQL.BIND_VARIABLE(c003,'NM_TABELA', nm_tabela_origem_w,50);
DBMS_SQL.BIND_VARIABLE(c003,'IE_TIPO_ATRIBUTO', 'FUNCTION',50);
DBMS_SQL.BIND_VARIABLE(c003,'IE_ATUALIZAR_VERSAO', 'S',50);
retorno_w := DBMS_SQL.execute(c003);


while( DBMS_SQL.FETCH_ROWS(C003) > 0 ) loop

	DBMS_SQL.COLUMN_VALUE(C003, 1, nm_atributo_w);

	if ( obter_se_atrib_constraint(nm_tabela_origem_W,nm_atributo_w,'PK') = 'S')  then
		ds_restricao_w		:= ds_restricao_w || ' AND ' || nm_atributo_w || ' = :' || nm_atributo_w;
		ds_update_w		:= ds_update_w || ds_virgula_w || nm_atributo_w || ' = '|| nm_atributo_w;
		ds_restricao_delete_w	:= ds_restricao_delete_w || ' AND a.' || nm_atributo_w || '= b.' || nm_atributo_w;
	else
		ds_update_w	:= ds_update_w || ds_virgula_w || nm_atributo_w || ' = :'|| nm_atributo_w;
	end if;
	ds_select_w	:= ds_select_w || ds_virgula_w || 'a.' || nm_atributo_w;
	ds_virgula_w	:= ',';
END LOOP;

DBMS_SQL.CLOSE_CURSOR(C003);

if (ds_select_w IS NOT NULL AND ds_select_w::text <> '') and (ds_restricao_w IS NOT NULL AND ds_restricao_w::text <> '') then


	if 	ie_novo_sql = 'S' then
		ds_select_w	:= 'SELECT ' || ds_select_w || ' FROM ' || nm_owner_origem_p || '.' || nm_tabela_origem_p || ' a, ' || nm_tabela_destino_p || ' b ' || ds_condicao_p;
	else
		ds_select_w	:= 'SELECT ' || ds_select_w || ' FROM ' || nm_owner_origem_p || '.' || nm_tabela_origem_p || ' a ' || ds_condicao_p;
	end	if;

	C001 := DBMS_SQL.OPEN_CURSOR;
	DBMS_SQL.PARSE(C001, ds_select_w, dbms_sql.Native);
	DBMS_SQL.describe_columns(c001,col_cnt_w,dtab_w);

	FOR i IN 1..col_cnt_w LOOP
		if ( dtab_w[i].col_type = 12 ) then
            		dbms_sql.define_column(c001,i,l_date_w);
	        else
			if (dtab_w[i].col_type = 24) then
				dbms_sql.DEFINE_COLUMN_RAW(c001,i,l_long_raw_w,32764);
			else
				dbms_sql.define_column(c001,i,vl_parametro_w,32764);
			end if;
	        end if;
	end loop;

	Retorno_w := DBMS_SQL.execute(c001);
	ds_update_w := 	' UPDATE ' || nm_tabela_destino_w  || ' SET ' || ds_update_w ||
			' WHERE	 1=1 ' || ds_restricao_w;

	if (ie_constraint_p = 'S') /*and (Retorno_w > 0) */
 then
		CALL mudar_integridade_tabela(nm_tabela_destino_w,'DISABLE');
	end if;

	while( DBMS_SQL.FETCH_ROWS(C001) > 0 ) loop
		for i in 1.. col_cnt_w loop
			if ( dtab_w[i].col_type = 12 ) then
				begin
				DBMS_SQL.COLUMN_VALUE(c001, i, l_date_w);
				vl_parametro_w := to_char(l_date_w,'dd/mm/yyyy hh24:mi:ss');
				exception
				when OTHERS then
					DBMS_SQL.COLUMN_VALUE(c001, i, vl_parametro_w);
				end;
			else
				if ( dtab_w[i].col_type = 24 ) then
					DBMS_SQL.COLUMN_VALUE_RAW(c001, i, l_long_raw_w);
				else
					dbms_sql.column_value(c001,i,vl_parametro_w);
				end if;
			end if;
			ar_parametros_w[i].nm := upper(dtab_w[i].col_name);

			if ( dtab_w[i].col_type = 24 ) then
				ar_parametros_w[i].vl_2 := l_long_raw_w;
			else
				ar_parametros_w[i].vl := vl_parametro_w;
			end if;

		END LOOP;

		/*INICIO*/

		c002 := DBMS_SQL.OPEN_CURSOR;
		DBMS_SQL.PARSE(c002, ds_update_w, dbms_sql.Native);
		DBMS_SQL.describe_columns(c001,col_cnt_w,dtab_w);

		for contador_w in 1..ar_parametros_w.count loop
			if (ar_parametros_w[contador_w].nm like 'DT_%') then
				l_date_w := to_date(ar_parametros_w[contador_w].vl,'dd/mm/yyyy hh24:mi:ss');
				DBMS_SQL.BIND_VARIABLE(c002, ar_parametros_w[contador_w].nm, l_date_w);
			else
				if ( dtab_w[contador_w].col_type = 24 ) then
					DBMS_SQL.BIND_VARIABLE_RAW(c002, ar_parametros_w[contador_w].nm, ar_parametros_w[contador_w].vl_2,32767);
				else
					DBMS_SQL.BIND_VARIABLE(c002, ar_parametros_w[contador_w].nm, ar_parametros_w[contador_w].vl,32764);
				end if;
			end if;
		end loop;

		Retorno_w := DBMS_SQL.execute(c002);
		DBMS_SQL.CLOSE_CURSOR(c002);

		/*FIM*/

		commit;
		ds_parametros_w := '';
	end loop;
	DBMS_SQL.CLOSE_CURSOR(C001);
end if;

select	coalesce(max(ie_exportar),'S')
into STRICT	ie_exportar_w
from	tabela_sistema
where	nm_tabela = nm_tabela_origem_p;

if ( ie_exportar_w = 'S') and (ds_restricao_delete_w IS NOT NULL AND ds_restricao_delete_w::text <> '') and (ie_excluir_reg_antigo_p = 'S') then
	ds_delete_w := 	' DELETE FROM  ' || nm_tabela_destino_p || ' a ' ||
			' WHERE	 NOT EXISTS ( SELECT 1 FROM ' || nm_owner_origem_p || '.'|| nm_tabela_origem_p || ' b WHERE 1=1 ' || ds_restricao_delete_w || ')';

	if (ie_constraint_p = 'S') then
		CALL mudar_integridade_tabela(nm_tabela_destino_p,'DISABLE');
	end if;

	CALL gravar_processo_longo(obter_desc_expressao(786545,'Remove registros antigos') || ' (' || nm_tabela_destino_p ||')','TASY_ATUALIZAR_TABELA',null);
	CALL exec_sql_dinamico(obter_desc_expressao(786545,'Remove registros antigos'),ds_delete_w);
end if;

commit;



END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tasy_atualizar_tabela2 ( nm_owner_origem_p text, nm_tabela_origem_p text, nm_tabela_destino_p text, ds_condicao_p text, ie_excluir_reg_antigo_p text default 'S', ie_constraint_p text default 'S', ie_novo_sql text default 'N') FROM PUBLIC;

