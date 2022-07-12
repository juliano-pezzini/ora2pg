-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--
-- dblink wrapper to call function flowsheet_history_pck.get_history() as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE FUNCTION flowsheet_history_pck.get_history ( nr_seq_linha_p w_apap_pac_informacao.nr_sequencia%type, dt_start_p timestamp, dt_end_p timestamp) RETURNS SETOF T_HISTORY_TABLE AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

	v_ret	T_HISTORY_TABLE;
BEGIN
	v_query := 'SELECT * FROM flowsheet_history_pck.get_history_atx ( ' || quote_nullable(nr_seq_linha_p) || ',' || quote_nullable(dt_start_p) || ',' || quote_nullable(dt_end_p) || ' )';
	SELECT * INTO v_ret FROM dblink(v_conn_str, v_query) AS p (ret T_HISTORY_TABLE);
	RETURN v_ret;

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE FUNCTION flowsheet_history_pck.get_history_atx ( nr_seq_linha_p w_apap_pac_informacao.nr_sequencia%type, dt_start_p timestamp, dt_end_p timestamp) RETURNS SETOF T_HISTORY_TABLE AS $body$
DECLARE

	row_w			t_history_row;
	ie_componente_w	tabela_visao_atributo.ie_componente%type;
	ie_status_w		integer;
	cursor_id		integer;
	cursor_ret      integer;
	ds_type_w       varchar(255)   := NULL;
	ie_type_w       varchar(15)   := NULL;
	dt_action_w     timestamp            := NULL;
	dt_reference_w  timestamp            := NULL;
	nm_usuario_w    varchar(255)   := NULL;
	ds_action_w     varchar(4000)  := NULL;
	w_query_client_w   	text;
	w_ie_replace_sql   boolean := false;
	nr_atendimento_w 	w_apap_pac.nr_atendimento%type;
	cd_pessoa_fisica_w	w_apap_pac.cd_pessoa_fisica%type;
	sql_errm_w			varchar(4000);
	dt_end_w		timestamp;

	
	c_history CURSOR FOR
		SELECT  obter_valor_dominio(10769,'L') DS_TYPE,
				'L' IE_TYPE,
				flowsheet_history_pck.get_date(nm_tabela,'DT_LIBERACAO',nr_seq_origem) DT_ACTION,
				Obter_Descricao_Padrao(flowsheet_history_pck.get_tabela(nm_tabela),'NM_USUARIO',nr_seq_origem) NM_USUARIO,
				ds_informacao DS_INFORMATION,
				DS_RESULT_DESC DS_ACTION,
				NULL DS_COMENT,
				DT_REGISTRO DT_REFERENCE,
				dt_resultado,
				vl_resultado,
				ds_resultado,
				coalesce(ie_resumo,'N') ie_resumo,
				ds_unid_med
		from 	TABLE(apap_dinamico_pck.get_valor_linha(nr_seq_linha_p,'A'))
		where	dt_registro	between dt_start_p and dt_end_w
		and		(nr_seq_origem IS NOT NULL AND nr_seq_origem::text <> '')
		
union

		SELECT  obter_valor_dominio(10769,'L') DS_TYPE,
				'L' IE_TYPE,
				flowsheet_history_pck.get_date(nm_tabela,'DT_LIBERACAO',nr_seq_origem) DT_ACTION,
				Obter_Descricao_Padrao(flowsheet_history_pck.get_tabela(nm_tabela),'NM_USUARIO',nr_seq_origem) NM_USUARIO,
				ds_informacao DS_INFORMATION,
				DS_RESULT_DESC DS_ACTION,
				NULL DS_COMENT,
				DT_REGISTRO DT_REFERENCE,
				dt_resultado,
				vl_resultado,
				ds_resultado,
				coalesce(ie_resumo,'N') ie_resumo,
				ds_unid_med
		from 	TABLE(apap_dinamico_pck.get_valor_linha(nr_seq_linha_p,'I'))
		where	dt_registro	between dt_start_p and dt_end_w
		and		(nr_seq_origem IS NOT NULL AND nr_seq_origem::text <> '')
		
union

		select  obter_valor_dominio(10769,'I') DS_TYPE,
				'I' IE_TYPE,
				flowsheet_history_pck.get_date(nm_tabela,'DT_INATIVACAO',nr_seq_origem) - 5/86400 DT_ACTION,
				Obter_Descricao_Padrao(flowsheet_history_pck.get_tabela(nm_tabela),'NM_USUARIO_INATIVACAO',nr_seq_origem) NM_USUARIO,
				ds_informacao DS_INFORMATION,
				DS_RESULT_DESC DS_ACTION,
				NULL DS_COMENT,
				DT_REGISTRO DT_REFERENCE,
				dt_resultado,
				vl_resultado,
				ds_resultado,
				coalesce(ie_resumo,'N') ie_resumo,
				ds_unid_med
		from 	TABLE(apap_dinamico_pck.get_valor_linha(nr_seq_linha_p,'I'))
		where	dt_registro	between dt_start_p and dt_end_w
		and		(nr_seq_origem IS NOT NULL AND nr_seq_origem::text <> '')
		
union

		select	obter_valor_dominio(10769,'C') DS_TYPE,
				'C' IE_TYPE,
				b.DT_ATUALIZACAO_NREC DT_ACTION,
				b.NM_USUARIO,
				a.ds_informacao DS_INFORMATION,
				a.ds_result_desc DS_ACTION,
				': '||b.DS_COMENTARIO DS_COMENT,
				a.DT_REGISTRO DT_REFERENCE,
				a.dt_resultado,
				a.vl_resultado,
				a.ds_resultado,
				coalesce(a.ie_resumo,'N') ie_resumo,
				a.ds_unid_med
		from 	TABLE(apap_dinamico_pck.get_valor_linha(nr_seq_linha_p,'A')) a,
				w_apap_pac_registro_hist b
		where	a.nm_atributo_unico 	= b.nm_atributo
		and		a.nm_tabela 			= b.nm_tabela		
		and		a.nr_seq_documento		= b.nr_seq_documento
		and		a.nr_atendimento		= b.nr_atendimento
		and   	a.dt_registro         	= b.dt_apap
		and		a.dt_registro			between dt_start_p and dt_end_w
		and		coalesce(b.ie_tipo,'C')		= 'C'
		
union

		select	obter_valor_dominio(10769,'D') DS_TYPE,
				'D' IE_TYPE,
				b.DT_ATUALIZACAO_NREC DT_ACTION,
				b.NM_USUARIO,
				a.ds_informacao DS_INFORMATION,
				a.ds_result_desc DS_ACTION,
				': '||coalesce((	select	max(x.ds_descricao) 
						from 	apap_destaque_celula x 
						where	x.nr_sequencia = b.nr_seq_destaque),obter_desc_expressao(10652714)) DS_COMENT,
				a.DT_REGISTRO DT_REFERENCE,
				a.dt_resultado,
				a.vl_resultado,
				a.ds_resultado,
				coalesce(a.ie_resumo,'N') ie_resumo,
				a.ds_unid_med
		from 	TABLE(apap_dinamico_pck.get_valor_linha(nr_seq_linha_p,'A')) a,
				w_apap_pac_registro_hist b
		where	a.nm_atributo_unico		= b.nm_atributo
		and		a.nm_tabela 			= b.nm_tabela		
		and		a.nr_seq_documento		= b.nr_seq_documento
		and		a.nr_atendimento		= b.nr_atendimento
		and   	a.dt_registro         	= b.dt_apap
		and		coalesce(b.ie_tipo,'C')		= 'D'
		and		a.dt_registro			between dt_start_p and dt_end_w;
		
	c_history_client CURSOR FOR
		SELECT	a.*,
				d.nr_atendimento,
				d.cd_pessoa_fisica
		from 	linked_data_historico a,
				w_apap_pac_informacao b,
				w_apap_pac_grupo c,
				w_apap_pac d
		where	a.nr_seq_linked_data 	= b.nr_seq_linked_data
		and		a.nr_seq_visao 			= b.nr_seq_visao
		and		b.nr_seq_apap_grupo		= c.nr_sequencia
		and		c.nr_seq_mod_apap		= d.nr_sequencia
		and		b.nr_sequencia			= nr_seq_linha_p
		and		(trim(both a.ds_sql) IS NOT NULL AND (trim(both a.ds_sql))::text <> '');
BEGIN
	dt_end_w	:= dt_end_p - 1/86400;
	begin
	FOR r_history_client IN c_history_client LOOP
		if (r_history_client.ie_execucao_sql = 'S') THEN
			w_ie_replace_sql := true;
		END IF;
		w_query_client_w := ' SELECT @DS_TYPE@ DS_TYPE, ''R'' IE_TYPE, @DT_ACTION@  DT_ACTION, @NM_USUARIO@ NM_USUARIO,@DS_ACTION@ DS_ACTION,@DT_REFERENCE@ DT_REFERENCE FROM ( ';
		w_query_client_w := REPLACE(w_query_client_w,'@DS_TYPE@',r_history_client.DS_ATRIBUTO_TIPO);
		w_query_client_w := REPLACE(w_query_client_w,'@DT_ACTION@',r_history_client.DS_ATRIBUTO_DT_ACAO);
		w_query_client_w := REPLACE(w_query_client_w,'@NM_USUARIO@',r_history_client.DS_ATRIBUTO_USUARIO);
		w_query_client_w := REPLACE(w_query_client_w,'@DS_ACTION@',r_history_client.DS_ATRIBUTO_DESCRICAO);
		w_query_client_w := REPLACE(w_query_client_w,'@DT_REFERENCE@',r_history_client.DS_ATRIBUTO_DT_REF);
		w_query_client_w := w_query_client_w  || r_history_client.DS_SQL || ')';
		
		nr_atendimento_w 	:= r_history_client.nr_atendimento;
		cd_pessoa_fisica_w 	:= r_history_client.cd_pessoa_fisica;
	END LOOP;
	
	if (w_query_client_w IS NOT NULL AND w_query_client_w::text <> '') then
		cursor_id := dbms_sql.open_cursor;
		dbms_sql.parse(cursor_id, w_query_client_w, dbms_sql.native);
		DBMS_SQL.DEFINE_COLUMN(cursor_id,1,ds_type_w,255);
		DBMS_SQL.DEFINE_COLUMN(cursor_id,2,ie_type_w,15);
		DBMS_SQL.DEFINE_COLUMN(cursor_id,3,dt_action_w);
		DBMS_SQL.DEFINE_COLUMN(cursor_id,4,nm_usuario_w,255);
		DBMS_SQL.DEFINE_COLUMN(cursor_id,5,ds_action_w,4000);
		DBMS_SQL.DEFINE_COLUMN(cursor_id,6,dt_reference_w);
		if (position(':DT_START_P' in w_query_client_w) > 0) then
			dbms_sql.bind_variable(cursor_id, ':DT_START_P', dt_start_p);
		end if;
		if (position(':DT_END_P' in w_query_client_w) > 0) then
			dbms_sql.bind_variable(cursor_id, ':DT_END_P', dt_end_w);
		end if;
		if (position(':NR_ATENDIMENTO_P' in w_query_client_w) > 0) then
			dbms_sql.bind_variable(cursor_id, ':NR_ATENDIMENTO_P', nr_atendimento_w);
		end if;
		if (position(':CD_PESSOA_FISICA_P' in w_query_client_w) > 0) then
			dbms_sql.bind_variable(cursor_id, ':CD_PESSOA_FISICA_P', cd_pessoa_fisica_w);
		end if;
		if (position(':NM_USUARIO_P' in w_query_client_w) > 0) then
			dbms_sql.bind_variable(cursor_id, ':NM_USUARIO_P', wheb_usuario_pck.get_nm_usuario());
		end if;

		cursor_ret := dbms_sql.execute(cursor_id);

		LOOP IF DBMS_SQL.FETCH_ROWS(cursor_id) = 0 THEN EXIT;
		END IF;
			dbms_sql.column_value(cursor_id, 1, ds_type_w);
			dbms_sql.column_value(cursor_id, 2, ie_type_w);
			dbms_sql.column_value(cursor_id, 3, dt_action_w);
			dbms_sql.column_value(cursor_id, 4, nm_usuario_w);
			dbms_sql.column_value(cursor_id, 5, ds_action_w);
			dbms_sql.column_value(cursor_id, 6, dt_reference_w);

			row_w.ds_type             := ds_type_w;
			row_w.ie_type             := ie_type_w;
			row_w.dt_action           := dt_action_w;
			row_w.nm_usuario          := nm_usuario_w;
			row_w.ds_action           := ds_action_w;
			row_w.dt_reference        := dt_reference_w;
			RETURN NEXT row_w;
		END LOOP;
		DBMS_SQL.CLOSE_CURSOR(cursor_id);
	end if;	
	if (not w_ie_replace_sql) then
		<<read_history>>
		for r_history in c_history
			loop
			row_w.DS_TYPE			:= r_history.DS_TYPE;
			row_w.IE_TYPE			:= r_history.IE_TYPE;
			row_w.DT_ACTION			:= r_history.DT_ACTION;
			row_w.NM_USUARIO		:= r_history.NM_USUARIO;
			row_w.DS_INFORMATION	:= r_history.DS_INFORMATION;
			row_w.DS_ACTION			:= r_history.DS_ACTION;
			row_w.DT_REFERENCE		:= r_history.DT_REFERENCE;
			if (coalesce(row_w.DS_ACTION::text, '') = '') then
				if (r_history.dt_resultado IS NOT NULL AND r_history.dt_resultado::text <> '') then
					row_w.DS_ACTION	:= pkg_date_formaters_tz.to_varchar(r_history.dt_resultado,'shortDate',establishment_timezone_utils.gettimezone);
				elsif (r_history.vl_resultado IS NOT NULL AND r_history.vl_resultado::text <> '') then
					row_w.DS_ACTION	:= r_history.vl_resultado ||' '||r_history.ds_unid_med;
				elsif (r_history.ds_resultado IS NOT NULL AND r_history.ds_resultado::text <> '') then
					select	max(coalesce(b.ie_componente,d.ie_componente)),
							--max(instr(trim(nvl(obter_desc_expressao(b.cd_exp_valores),b.ds_valores)),r_history.ds_resultado))
							max(case 	when(a.nr_seq_temp_conteudo IS NOT NULL AND a.nr_seq_temp_conteudo::text <> '') then position(r_history.ds_resultado in '1,0')
										else	position(r_history.ds_resultado in trim(both coalesce(obter_desc_expressao(b.cd_exp_valores),b.ds_valores)))
							end)	 ie_status
					into STRICT	ie_componente_w,
							ie_status_w
					FROM w_apap_pac_informacao a
LEFT OUTER JOIN tabela_visao_atributo b ON (a.nr_seq_visao = b.nr_sequencia AND a.nm_atributo_tabela = b.nm_atributo)
LEFT OUTER JOIN ehr_template_conteudo c ON (a.nr_seq_temp_conteudo = c.nr_sequencia)
LEFT OUTER JOIN ehr_elemento d ON (c.nr_seq_elemento = d.nr_sequencia)
WHERE a.nr_sequencia			= nr_seq_linha_p;
					if (ie_componente_w = 'cb') then
						if (ie_status_w = 1) then
							row_w.DS_ACTION	:= obter_valor_dominio(6, 'S');
						elsif (ie_status_w = 3) then
							row_w.DS_ACTION	:= obter_valor_dominio(6, 'N');
						end if;	
					else
						row_w.DS_ACTION	:= r_history.ds_resultado;
					end if;
				end if;
			elsif (r_history.ie_resumo = 'N') then
				row_w.DS_ACTION	:= r_history.DS_ACTION;
			end if;	
			row_w.DS_ACTION		:= row_w.DS_ACTION ||r_history.DS_COMENT;
			RETURN NEXT row_w;
			end loop read_history;
	end if;		
	RETURN;
	exception
		WHEN unique_violation THEN
			sql_errm_w 		:= sqlerrm;
			DBMS_SQL.CLOSE_CURSOR(cursor_id);
		when others then	
			sql_errm_w 		:= sqlerrm;
			DBMS_SQL.CLOSE_CURSOR(cursor_id);
	end;
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 IMMUTABLE;
-- REVOKE ALL ON FUNCTION flowsheet_history_pck.get_history ( nr_seq_linha_p w_apap_pac_informacao.nr_sequencia%type, dt_start_p timestamp, dt_end_p timestamp) FROM PUBLIC; -- REVOKE ALL ON FUNCTION flowsheet_history_pck.get_history_atx ( nr_seq_linha_p w_apap_pac_informacao.nr_sequencia%type, dt_start_p timestamp, dt_end_p timestamp) FROM PUBLIC;