-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function consiste_regra_agenda as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE PROCEDURE consiste_regra_agenda (( ie_momento_p text, cd_agenda_p bigint, cd_pessoa_fisica_p text, cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_convenio_p bigint, cd_perfil_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, cd_medico_cirurgiao_p text, nr_seq_agenda_p bigint, ie_lado_p text default null ) is nr_sequencia_w bigint) RETURNS varchar AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

	v_ret	varchar;
BEGIN
	v_query := 'SELECT * FROM consiste_regra_agenda_atx ( ' || quote_nullable(ie_momento_p) || ',' || quote_nullable(cd_agenda_p) || ',' || quote_nullable(cd_pessoa_fisica_p) || ',' || quote_nullable(cd_procedimento_p) || ',' || quote_nullable(ie_origem_proced_p) || ',' || quote_nullable(cd_convenio_p) || ',' || quote_nullable(cd_perfil_p) || ',' || quote_nullable(cd_estabelecimento_p) || ',' || quote_nullable(nm_usuario_p) || ',' || quote_nullable(cd_medico_cirurgiao_p) || ',' || quote_nullable(nr_seq_agenda_p) || ',' || quote_nullable(ie_lado_p) || ' )';
	SELECT * INTO v_ret FROM dblink(v_conn_str, v_query) AS p (ret varchar);
	RETURN v_ret;

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE PROCEDURE consiste_regra_agenda_atx (( ie_momento_p text, cd_agenda_p bigint, cd_pessoa_fisica_p text, cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_convenio_p bigint, cd_perfil_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, cd_medico_cirurgiao_p text, nr_seq_agenda_p bigint, ie_lado_p text default null ) is nr_sequencia_w bigint) RETURNS varchar AS $body$
DECLARE


	ds_sql_w				varchar(4000);
	ds_valor_bind_w			sql_pck.t_dado_bind;
	ds_comando_w			sql_pck.t_cursor;
	ds_mensagem_retorno_w	varchar(2550);
	ds_retorno_p 			varchar(2550);
BEGIN
		begin
		ds_sql_w :=	ds_comando_p;

		ds_valor_bind_w := sql_pck.bind_variable(':cd_agenda', cd_agenda_p, ds_valor_bind_w);
		ds_valor_bind_w := sql_pck.bind_variable(':cd_pessoa_fisica', cd_pessoa_fisica_p, ds_valor_bind_w);
		ds_valor_bind_w := sql_pck.bind_variable(':cd_procedimento', cd_procedimento_p, ds_valor_bind_w);
		ds_valor_bind_w := sql_pck.bind_variable(':ie_origem_proced', ie_origem_proced_p, ds_valor_bind_w);
		ds_valor_bind_w := sql_pck.bind_variable(':cd_convenio', cd_convenio_p, ds_valor_bind_w);
		ds_valor_bind_w := sql_pck.bind_variable(':cd_perfil', cd_perfil_p, ds_valor_bind_w);
		ds_valor_bind_w := sql_pck.bind_variable(':cd_estabelecimento', cd_estabelecimento_p, ds_valor_bind_w);
		ds_valor_bind_w := sql_pck.bind_variable(':nm_usuario', nm_usuario_p, ds_valor_bind_w);
		ds_valor_bind_w := sql_pck.bind_variable(':cd_medico_cirurgiao', cd_medico_cirurgiao_p, ds_valor_bind_w);
		ds_valor_bind_w := sql_pck.bind_variable(':nr_sequencia', nr_seq_agenda_p, ds_valor_bind_w);
	
		ds_valor_bind_w := sql_pck.executa_sql_cursor(	ds_sql_w, ds_valor_bind_w);
		
		fetch ds_comando_w into	
			ds_mensagem_retorno_w;
		close ds_comando_w;

		ds_retorno_p := ds_mensagem_retorno_w;

		exception
		when others then
			ds_retorno_p := null;
			end;	
	return ds_retorno_p;
	
	end;

					
begin

delete from consistencia_regra_agenda where nm_usuario = nm_usuario_p;
commit;

open C01;
loop
fetch C01 into	
	nr_sequencia_w,
	ie_prioridade_w, 
	ds_sql_w, 
	ie_tipo_mensagem_w, 
	ds_comando_adic_w,
	ds_mensagem_usuario_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	begin
		
	if (coalesce(ds_comando_adic_w,'XPTO') <> 'XPTO') then
	begin
		begin
		ds_mensagem_aux_w := ds_mensagem_usuario_w;
		ds_mensagem_usuario_w := substr(coalesce(obter_resultado_comando(ds_comando_adic_w), ds_mensagem_usuario_w),1,255);
		exception
		when others then
			ds_mensagem_usuario_w := ds_mensagem_aux_w;
		end;
	end;												
	end if;		
		
	C02 := DBMS_SQL.OPEN_CURSOR;
	DBMS_SQL.PARSE(C02, ds_sql_w, dbms_sql.Native);
	DBMS_SQL.DEFINE_COLUMN(C02,1,qt_registros_w);
	if (position(':CD_AGENDA' in upper(ds_sql_w)) > 0) then
		DBMS_SQL.BIND_VARIABLE(C02,'CD_AGENDA', cd_agenda_p);
	end if;	
	if (position(':CD_PESSOA_FISICA' in upper(ds_sql_w)) > 0) then
		DBMS_SQL.BIND_VARIABLE(C02,'CD_PESSOA_FISICA', cd_pessoa_fisica_p);
	end if;	
	
	if (position(':CD_PROCEDIMENTO' in upper(ds_sql_w)) > 0) then
		DBMS_SQL.BIND_VARIABLE(C02,'CD_PROCEDIMENTO', cd_procedimento_p);
	end if;	
	
	if (position(':IE_ORIGEM_PROCED' in upper(ds_sql_w)) > 0) then
		DBMS_SQL.BIND_VARIABLE(C02,'IE_ORIGEM_PROCED', ie_origem_proced_p);
	end if;	
	
	if (position(':CD_CONVENIO' in upper(ds_sql_w)) > 0) then
		DBMS_SQL.BIND_VARIABLE(C02,'CD_CONVENIO', cd_convenio_p);
	end if;	
	
	if (position(':CD_PERFIL' in upper(ds_sql_w)) > 0) then
		DBMS_SQL.BIND_VARIABLE(C02,'CD_PERFIL', cd_perfil_p);
	end if;	
	
	if (position(':CD_ESTABELECIMENTO' in upper(ds_sql_w)) > 0) then
		DBMS_SQL.BIND_VARIABLE(C02,'CD_ESTABELECIMENTO', cd_estabelecimento_p);
	end if;	
	
	if (position(':NM_USUARIO' in upper(ds_sql_w)) > 0) then
		DBMS_SQL.BIND_VARIABLE(C02,'NM_USUARIO', nm_usuario_p);
	end if;	
	
	if (position(':CD_MEDICO_CIRURGIAO' in upper(ds_sql_w)) > 0) then
		DBMS_SQL.BIND_VARIABLE(C02,'CD_MEDICO_CIRURGIAO', cd_medico_cirurgiao_p);
	end if;

	if (position(':NR_SEQUENCIA' in upper(ds_sql_w)) > 0) then
		DBMS_SQL.BIND_VARIABLE(C02,'NR_SEQUENCIA', nr_seq_agenda_p);
	end if;

  if (position(':IE_LADO' in upper(ds_sql_w)) > 0) then
		DBMS_SQL.BIND_VARIABLE(C02,'IE_LADO', ie_lado_p);
	end if;

	retorno_w := DBMS_SQL.execute(C02);
	
	if (DBMS_SQL.FETCH_ROWS(C02) > 0) then
		DBMS_SQL.COLUMN_VALUE(C02, 1, qt_registros_w);
		if (qt_registros_w > 0) then
			--DBMS_SQL.COLUMN_VALUE(C02,1,qt_registros_w);
			insert	into	consistencia_regra_agenda(	NR_SEQUENCIA,
						DT_ATUALIZACAO, 
						NM_USUARIO, 
						DT_ATUALIZACAO_NREC, 
						NM_USUARIO_NREC, 
						NR_SEQ_REGRA, 
						IE_PRIORIDADE, 
						IE_TIPO_MENSAGEM, 
						DS_MENSAGEM_USUARIO, 
						DS_STACK)
			values (	nextval('consistencia_regra_agenda_seq'),
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						nr_sequencia_w,
						ie_prioridade_w,
						ie_tipo_mensagem_w,
						ds_mensagem_usuario_w,
						substr(dbms_utility.format_call_stack,1,2000));
			commit;
		end if;	
	end if;	
	DBMS_SQL.CLOSE_CURSOR(C02);
	end;
	exception
	when others then
		qt_registros_w := 0;
	end;
end loop;
close C01;
					
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_regra_agenda (( ie_momento_p text, cd_agenda_p bigint, cd_pessoa_fisica_p text, cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_convenio_p bigint, cd_perfil_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, cd_medico_cirurgiao_p text, nr_seq_agenda_p bigint, ie_lado_p text default null ) is nr_sequencia_w bigint) FROM PUBLIC; -- REVOKE ALL ON PROCEDURE consiste_regra_agenda_atx (( ie_momento_p text, cd_agenda_p bigint, cd_pessoa_fisica_p text, cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_convenio_p bigint, cd_perfil_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, cd_medico_cirurgiao_p text, nr_seq_agenda_p bigint, ie_lado_p text default null ) is nr_sequencia_w bigint) FROM PUBLIC;
