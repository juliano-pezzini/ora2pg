-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE techone_pck.generate_batch ( nr_lote_contabil_p bigint, ie_exclusao_p text, nm_usuario_p text) AS $body$
DECLARE

	
	cd_tipo_lote_contabil_w		lote_contabil.cd_tipo_lote_contabil%type;
	cd_estabelecimento_w		lote_contabil.cd_estabelecimento%type;
	nm_procedure_w			tipo_lote_contabil.nm_objeto%type;
	ds_comando_w			varchar(4000);
	cursor_id_w			integer;
	ds_retorno_w			varchar(8000);
	dummy_w				integer;
	ds_error_w			varchar(4000);
	qt_reg_w			bigint;
	
	
BEGIN
	
	select	max(cd_tipo_lote_contabil),
		max(cd_estabelecimento)
	into STRICT	cd_tipo_lote_contabil_w,
		cd_estabelecimento_w
	from	lote_contabil
	where	nr_lote_contabil	= nr_lote_contabil_p;
	
	select	max(nm_objeto)
	into STRICT	nm_procedure_w
	from	tipo_lote_contabil
	where	cd_tipo_lote_contabil	= cd_tipo_lote_contabil_w;
	
	if (nm_procedure_w IS NOT NULL AND nm_procedure_w::text <> '') then
	
		CALL ctb_gravar_inicio_lote(	nr_lote_contabil_p,'G');
		CALL ctb_inicializar_lote_contabil(	nr_lote_contabil_p,cd_estabelecimento_w, nm_usuario_p);
		
		ds_comando_w	:= 'begin '||nm_procedure_w||'( NR_LOTE_CONTABIL_P=> :NR_LOTE_CONTABIL_P , NM_USUARIO_P=> :NM_USUARIO_P, IE_EXCLUSAO_P=> :IE_EXCLUSAO_P, DS_RETORNO_P=> :DS_RETORNO_P); end; ';
		
		cursor_id_w	:= dbms_sql.open_cursor;
		dbms_sql.parse(cursor_id_w, ds_comando_w, dbms_sql.native);
		dbms_sql.bind_variable(cursor_id_w, 'NR_LOTE_CONTABIL_P', nr_lote_contabil_p);
		dbms_sql.bind_variable(cursor_id_w, 'NM_USUARIO_P', nm_usuario_p);
		dbms_sql.bind_variable(cursor_id_w, 'IE_EXCLUSAO_P', ie_exclusao_p);
		dbms_sql.bind_variable(cursor_id_w, 'DS_RETORNO_P', ds_retorno_w,4000);

		
		begin
			dummy_w := dbms_sql.execute(cursor_id_w);
			dbms_sql.close_cursor(cursor_id_w);
			
		exception
		when others then
			dbms_sql.close_cursor(cursor_id_w);
			ds_error_w := SQLERRM(SQLSTATE);
			CALL Wheb_mensagem_pck.exibir_mensagem_abort(184107,'DS_ERRO=' || ds_error_w);
		end;
	end if;
	
	select	count(1)
	into STRICT	qt_reg_w
	from	movimento_contabil
	where	nr_lote_contabil	= nr_lote_contabil_p;
	
	
	if (qt_reg_w	= 0) then --remove if the batch is empty
		begin
			delete	FROM lote_contabil
			where	nr_lote_contabil	= nr_lote_contabil_p;
		exception
		when others then
			null;
		end;
	end if;
	
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE techone_pck.generate_batch ( nr_lote_contabil_p bigint, ie_exclusao_p text, nm_usuario_p text) FROM PUBLIC;
