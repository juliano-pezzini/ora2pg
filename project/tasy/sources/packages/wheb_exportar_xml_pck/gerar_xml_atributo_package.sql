-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE wheb_exportar_xml_pck.gerar_xml_atributo (ar_xml_elemento_w xmlElemento,ar_result_query_sup_p myArray,nm_tabela_def_banco_p text) AS $body$
DECLARE

	nr_seq_atrib_elem_w	bigint;
	ie_criar_atributo_w 	varchar(1);
	ie_criar_nulo_w	  	varchar(1);
	nm_atributo_xml_w  	varchar(90);
	nm_atributo_w	  	varchar(60);
	ds_cabecalho_w	  	varchar(2000);
	ds_mascara_w		varchar(30);
	ds_mascara_aux_w	varchar(20);
	ie_tipo_atributo_w	varchar(10);
	ie_obrigatorio_w	varchar(1);
	ie_controle_pb_w	varchar(1);
	nr_sequencia_w		bigint;
	ie_remover_espaco_branco_w varchar(1);
	ie_mascara_tiss_w	boolean	:= false;
	/*Variaveis de controle interno*/


	contadow_w		bigint;
	i_w				bigint			:= 0;
	ie_fechar_w		boolean				:= true;
	nr_seq_atrib_elem_ant_w	bigint	:= 0;
	atributo_w		varchar(32000)		:= '';
	ds_valor_w		text				:= '';
	ds_valor_aux_w	text				:= '';
	nr_seq_apresentacao_w	bigint;
	nm_tabela_def_banco_w 	varchar(30);
	ie_atrib_cdata_w	varchar(1);
	c003	integer;
	ds_comando_w varchar(4000);
	retorno_w		numeric(20);
	l_date_w      timestamp;
	ar_nm_param_cabecalho_w	myArray;
	ds_param_w	varchar(4000);
	ds_valor_long_w		DBMS_SQL.VARCHAR2A;
	
BEGIN
		if (coalesce(nm_tabela_def_banco_p::text, '') = '' ) then
			ds_comando_w :=
				'SELECT	nr_seq_atrib_elem,'||
				'	ie_criar_atributo,'||
				'	ie_criar_nulo,'||
				'	decode(ds_namespace,'''','''',ds_namespace || '':'') || replace(nm_atributo_xml,''@ns@'','''||current_setting('wheb_exportar_xml_pck.ds_namespace_w')::varchar(255)||'''),'||
				'	nm_atributo,'||
				'	replace(nvl(ds_cabecalho,''''),''@ns@'','''||current_setting('wheb_exportar_xml_pck.ds_namespace_w')::varchar(255)||'''),'||
				'	ds_mascara,'||
				'	ie_tipo_atributo,'||
				'	ie_obrigatorio ,'||
				'	nr_sequencia,'||
				'	ie_controle_pb,'||
				'	nvl(ie_remover_espaco_branco,''S''),'||
				'	nm_tabela_def_banco,'||
				'   nvl(ie_atrib_cdata,''S'')'||
				' FROM 	 xml_atributo'||
				' WHERE	 nr_seq_elemento = :nr_sequencia'||
				' AND	 dt_atualizacao_nrec < :dt_assinatura_digital'||
				' order by nr_seq_apresentacao';
		else
			ds_comando_w :=
				' select null nr_seq_atrib_elem,'||
				'	''S'' ie_criar_atributo,'||
				'	''N'' ie_criar_nulo,'|| 
				'	b.column_name ds_namespace,'||
				'	b.column_name nm_atributo,'||
				'	null ds_cabecalho,'|| 
				'	null ds_mascara,'|| 
				'	decode(b.data_type,''VARCHAR2'',''LONG'',b.data_type) ie_tipo_atributo,'|| 
				'	''N'','|| 
				'	b.column_id,'|| 
				'	''N'' ie_controle_pb,'|| 
				'	''N'' ie_remover_espaco_branco,'|| 
				'	null nm_tabela_def_banco,'|| 
				'   ''S'' ie_atrib_cdata'||
				' from	user_tab_columns b'|| 
				' where	b.table_name = :nm_tabela'|| 
				' and	not exists ('|| 
				'	select	1'||
				' 	FROM 	xml_atributo c'||
				'	WHERE 	c.nr_seq_elemento = :nr_sequencia'||
				' 	AND	dt_atualizacao_nrec < :dt_assinatura_digital'||
				'	and	c.nm_atributo_xml = b.column_name)'||
				' order by b.column_id';
		end if;	

		C003 := DBMS_SQL.OPEN_CURSOR;
		DBMS_SQL.PARSE(C003, ds_comando_w, dbms_sql.Native);
		DBMS_SQL.DEFINE_COLUMN(c003,1,nr_seq_atrib_elem_w);
		DBMS_SQL.DEFINE_COLUMN(c003,2,ie_criar_atributo_w,1);
		DBMS_SQL.DEFINE_COLUMN(c003,3,ie_criar_nulo_w,1);
		DBMS_SQL.DEFINE_COLUMN(c003,4,nm_atributo_xml_w,90);
		DBMS_SQL.DEFINE_COLUMN(c003,5,nm_atributo_w,60);
		DBMS_SQL.DEFINE_COLUMN(c003,6,ds_cabecalho_w,255);
		DBMS_SQL.DEFINE_COLUMN(c003,7,ds_mascara_w,30);
		DBMS_SQL.DEFINE_COLUMN(c003,8,ie_tipo_atributo_w,10);
		DBMS_SQL.DEFINE_COLUMN(c003,9,ie_obrigatorio_w,1);
		DBMS_SQL.DEFINE_COLUMN(c003,10,nr_sequencia_w);
		DBMS_SQL.DEFINE_COLUMN(c003,11,ie_controle_pb_w,1);
		DBMS_SQL.DEFINE_COLUMN(c003,12,ie_remover_espaco_branco_w,1);
		DBMS_SQL.DEFINE_COLUMN(c003,13,nm_tabela_def_banco_w,30);
		DBMS_SQL.DEFINE_COLUMN(c003,14,ie_atrib_cdata_w,1);
		
		if (nm_tabela_def_banco_p IS NOT NULL AND nm_tabela_def_banco_p::text <> '') then
			DBMS_SQL.BIND_VARIABLE(c003,'NM_TABELA', nm_tabela_def_banco_p,30);
		end if;
		DBMS_SQL.BIND_VARIABLE(c003,'NR_SEQUENCIA', ar_xml_elemento_w[1].NR_SEQUENCIA);
		DBMS_SQL.BIND_VARIABLE(c003,'DT_ASSINATURA_DIGITAL', current_setting('wheb_exportar_xml_pck.dt_assinatura_digital_w')::timestamp);
		
		retorno_w := DBMS_SQL.execute(c003);
		
		while( DBMS_SQL.FETCH_ROWS(C003) > 0 ) loop
			
			DBMS_SQL.COLUMN_VALUE(c003,1,nr_seq_atrib_elem_w);
			DBMS_SQL.COLUMN_VALUE(c003,2,ie_criar_atributo_w);
			DBMS_SQL.COLUMN_VALUE(c003,3,ie_criar_nulo_w);
			DBMS_SQL.COLUMN_VALUE(c003,4,nm_atributo_xml_w);
			DBMS_SQL.COLUMN_VALUE(c003,5,nm_atributo_w);
			DBMS_SQL.COLUMN_VALUE(c003,6,ds_cabecalho_w);
			DBMS_SQL.COLUMN_VALUE(c003,7,ds_mascara_w);
			DBMS_SQL.COLUMN_VALUE(c003,8,ie_tipo_atributo_w);
			DBMS_SQL.COLUMN_VALUE(c003,9,ie_obrigatorio_w);
			DBMS_SQL.COLUMN_VALUE(c003,10,nr_sequencia_w);
			DBMS_SQL.COLUMN_VALUE(c003,11,ie_controle_pb_w);
			DBMS_SQL.COLUMN_VALUE(c003,12,ie_remover_espaco_branco_w);
			DBMS_SQL.COLUMN_VALUE(c003,13,nm_tabela_def_banco_w);
			DBMS_SQL.COLUMN_VALUE(c003,14,ie_atrib_cdata_w);
		
		
			/*Tratamento para BIND_VARIABLE NO CABECALHO */


			ar_nm_param_cabecalho_w := wheb_exportar_xml_pck.armazena_parametros_sql(ds_cabecalho_w, ar_nm_param_cabecalho_w, false);
			for contador_w in 1..ar_nm_param_cabecalho_w.count loop
				/*Verifica se existe valor para o parametro na Query Superior*/


				ds_param_w := wheb_exportar_xml_pck.obter_valor_parametro(ar_nm_param_cabecalho_w[contador_w].nm,ar_result_query_sup_p);
				/*Verificar se existe valor para o parametro nos parametros do projeto*/


				if ( coalesce(ds_param_w::text, '') = '' ) then
					ds_param_w := wheb_exportar_xml_pck.obter_valor_parametro(ar_nm_param_cabecalho_w[contador_w].nm,current_setting('wheb_exportar_xml_pck.ar_parametros_w')::myArray);
				end if;
				if ( coalesce(ds_param_w::text, '') = '' ) then
					ds_param_w := wheb_exportar_xml_pck.obter_valor_parametro(ar_nm_param_cabecalho_w[contador_w].nm,current_setting('wheb_exportar_xml_pck.ar_result_todos_sql_p')::myArray);
				end if;		
				ds_cabecalho_w := replace(ds_cabecalho_w,':'||ar_nm_param_cabecalho_w[contador_w].nm,ds_param_w);
			end loop;
		
		
			if (nm_tabela_def_banco_w IS NOT NULL AND nm_tabela_def_banco_w::text <> '') then
				CALL wheb_exportar_xml_pck.gerar_xml_atributo(ar_xml_elemento_w,ar_result_query_sup_p, nm_tabela_def_banco_w);
			else
				i_w 	   := i_w + 1;

				if ( ie_controle_pb_w = 'S' ) then
					CALL GRAVAR_PROCESSO_LONGO('','WHEB_EXPORTAR_XML',-1);
				end if;
				if (nr_seq_atrib_elem_w IS NOT NULL AND nr_seq_atrib_elem_w::text <> '') then
					if ( i_w > 1 ) and ( nr_seq_atrib_elem_ant_w = 0) and ( ar_xml_elemento_w[1].IE_TIPO_ELEMENTO = 'A' ) then
						CALL wheb_exportar_xml_pck.addxml('>');
						ie_fechar_w 	:= false;
					end if;
					CALL wheb_exportar_xml_pck.gerar_xml_elemento(nr_seq_atrib_elem_w, ar_result_query_sup_p, nr_sequencia_w);
				else
					atributo_w := '';

					if ( ar_xml_elemento_w[1].IE_TIPO_ELEMENTO = 'E' ) then
						if ( ie_criar_atributo_w = 'S') and
							(( trim(both wheb_exportar_xml_pck.obter_valor_parametro(nm_atributo_w,ar_result_query_sup_p)) is not null) or ( ie_criar_nulo_w = 'S')) then
								if (ds_cabecalho_w IS NOT NULL AND ds_cabecalho_w::text <> '') then
									ds_cabecalho_w := ' ' || ds_cabecalho_w;
								end if;
								atributo_w := atributo_w || chr(13) || chr(10) ||'<' || nm_atributo_xml_w ||ds_cabecalho_w || '>';
						end if;
					elsif ( ie_criar_atributo_w = 'S') and
						  ((trim(both wheb_exportar_xml_pck.obter_valor_parametro(nm_atributo_w,ar_result_query_sup_p)) is not null) or (ie_criar_nulo_w = 'S')) then
						atributo_w := atributo_w || ' ' || nm_atributo_xml_w || '=';
					end if;

					/*Verifica o valor do atributo nos parametro do projeto*/


					ds_valor_w := wheb_exportar_xml_pck.obter_valor_parametro(nm_atributo_w,current_setting('wheb_exportar_xml_pck.ar_parametros_w')::myArray);
					ds_valor_aux_w := null;
					if ( coalesce(ds_valor_w::text, '') = '') or (current_setting('wheb_exportar_xml_pck.ie_tipo_w')::varchar(60) = 'INTEGRACAO') /*temporario pegar valor da query superior ao inves do projeto*/
 then
						/*Verifica o valor do atributo na query superior*/


						ds_valor_aux_w := wheb_exportar_xml_pck.obter_valor_parametro(nm_atributo_w,ar_result_query_sup_p);
						if (ds_valor_aux_w IS NOT NULL AND ds_valor_aux_w::text <> '') then
							ds_valor_w := ds_valor_aux_w;
						end if;
					end if;
					
					if (ds_valor_w IS NOT NULL AND ds_valor_w::text <> '') then
						if ( ie_tipo_atributo_w = 'DATE' ) then

							if (ds_mascara_w IS NOT NULL AND ds_mascara_w::text <> '') then
								begin
									/*Tratamento para mascara do Tiss no formato yyyy-mm-ddThh:mm:ss*/


									if ( position('ddThh' in ds_mascara_w) > 0 ) then
										ds_mascara_w := replace(ds_mascara_w,'ddThh','dd*hh');
										ie_mascara_tiss_w := true;
									end if;
									if ( position('HH' in upper(ds_mascara_w)) > 0 ) then
										ds_mascara_w := replace(ds_mascara_w,'hh','hh24');
										ds_mascara_w := replace(ds_mascara_w,'HH','hh24');
										ds_mascara_w := replace(ds_mascara_w,':MM',':mi');
										ds_mascara_w := replace(ds_mascara_w,':mm',':mi');
										ds_mascara_w := replace(ds_mascara_w,'SS','ss');
									end if;
									if (substr(nm_atributo_w,1,3) = 'HR_') then
										ds_valor_w := to_char(to_date(ds_valor_w,'hh24:mi:ss'),ds_mascara_w);
									else
										ds_valor_w := to_char(to_date(ds_valor_w,'dd/mm/yyyy hh24:mi:ss'),ds_mascara_w);
									end if;
									if ( ie_mascara_tiss_w ) then
										ds_valor_w := replace(ds_valor_w,'*','T');
										ie_mascara_tiss_w := false;
									end if;
								exception
									when OTHERS then
									ds_mascara_w := ds_mascara_w;
								end;
							end if;
						elsif ( ie_tipo_atributo_w = 'NUMBER' ) then
							if (ds_mascara_w IS NOT NULL AND ds_mascara_w::text <> '') then
								if (ds_mascara_w = 'DIOPS') then
									ds_valor_w := formata_numero_diops(ds_valor_w);
								else
									ds_mascara_aux_w := substr(ds_mascara_w,position('.' in ds_mascara_w)+1,length(ds_mascara_w));
									ds_mascara_w := '999999990.';
									for contador_w in 1..length(ds_mascara_aux_w) loop
										ds_mascara_w := ds_mascara_w || '9';
									end loop;
									ds_valor_w := to_char((ds_valor_w)::numeric ,ds_mascara_w);
								end if;
							end if;
						end if;
					/*elsif	( ie_tipo_atributo_w = 'NUMBER' ) and
						( ds_mascara_w is not null ) then
						while( instr(ds_mascara_w,'#') > 0 ) loop
							ds_mascara_w := replace(ds_mascara_w,'#','');
						end loop;
						ds_valor_w := (ds_mascara_w);*/

					end if;
					/*OS258181 - Coelho*/


					if (ie_remover_espaco_branco_w = 'S') then
						ds_valor_w := trim(both ds_valor_w);
					end if;

					ds_valor_long_w.delete;
					if (coalesce(ds_valor_w::text, '') = '') AND (ie_tipo_atributo_w = 'LONG') then
						ds_valor_long_w := wheb_exportar_xml_pck.obter_valor_parametro_long(nm_atributo_w,current_setting('wheb_exportar_xml_pck.ar_parametros_w')::myArray);
						if	not(ds_valor_long_w.count > 0)	then
							ds_valor_long_w := wheb_exportar_xml_pck.obter_valor_parametro_long(nm_atributo_w,ar_result_query_sup_p);
						end if;
						if	not( ds_valor_long_w.count > 0)	then
							ds_valor_long_w := wheb_exportar_xml_pck.obter_valor_parametro_long(nm_atributo_w,current_setting('wheb_exportar_xml_pck.ar_result_todos_sql_p')::myArray);
						end if;
					end if;

					if (ie_tipo_atributo_w = 'LONG')	and (ds_valor_long_w.count > 0)	then    
						for p in 1..ds_valor_long_w.count loop
							
							ds_valor_w := ds_valor_long_w(p);
							if (ar_xml_elemento_w[1].nr_sequencia not in (541,18779,18780,18835,66698,67286)) then /* Elemento da Ordem de Servico */

								ds_valor_w := wheb_exportar_xml_pck.tratar_tab_enter(ds_valor_w);
							end if;					

							if ( current_setting('wheb_exportar_xml_pck.ie_proj_carac_esp_w')::varchar(1) = 'S' ) then						
								ds_valor_w := wheb_exportar_xml_pck.tratar_carac_especiais(ds_valor_w);
							end if;

							CALL wheb_exportar_xml_pck.addvalorxml(ds_valor_w);
              		
							if (p = 1) then
							    IF ie_atrib_cdata_w = 'S' THEN
									ds_valor_w := '<![CDATA[' || ds_valor_w;
								END IF;
								if ( ar_xml_elemento_w[1].IE_TIPO_ELEMENTO = 'E' ) then
									ds_valor_w := atributo_w || ds_valor_w;
									
								else
									ds_valor_w := atributo_w || '"' || ds_valor_w;
								end if;
							end if;

							if (p = ds_valor_long_w.count) then
								IF ie_atrib_cdata_w = 'S' THEN
									ds_valor_w := ds_valor_w || ']]>';
								END IF;
								if ( ar_xml_elemento_w[1].IE_TIPO_ELEMENTO = 'E' ) then
									ds_valor_w := ds_valor_w || '</' || nm_atributo_xml_w ||'>';
								else
									ds_valor_w := ds_valor_w || '" ';
								end if;
							end if;
						
							CALL wheb_exportar_xml_pck.addxml(ds_valor_w);
						end loop;
					else
						/*INICIO TRATAMENTO CHR13 e CHR10 no valor do XML*/



						if (ar_xml_elemento_w[1].nr_sequencia not in (541,18779,18780,18835,66698,67286)) then /* Elemento da Ordem de Servico */

							ds_valor_w := wheb_exportar_xml_pck.tratar_tab_enter(ds_valor_w);
						end if;					
						/*FIM TRATAMENTO CHR13 e CHR10 no valor do XML*/

						if ( current_setting('wheb_exportar_xml_pck.ie_proj_carac_esp_w')::varchar(1) = 'S' ) then						
							ds_valor_w := wheb_exportar_xml_pck.tratar_carac_especiais(ds_valor_w);
						end if;
						if (ie_criar_atributo_w = 'S' ) and
							((ds_valor_w IS NOT NULL AND ds_valor_w::text <> '') or (ie_criar_nulo_w = 'S')) then
							CALL wheb_exportar_xml_pck.addvalorxml(ds_valor_w);
					
							if (ie_tipo_atributo_w = 'LONG') and (ds_valor_w IS NOT NULL AND ds_valor_w::text <> '') and (ie_atrib_cdata_w = 'S') then
								ds_valor_w := '<![CDATA[' || ds_valor_w || ']]>';
							end if;
							if ( ar_xml_elemento_w[1].IE_TIPO_ELEMENTO = 'E' ) then
								atributo_w := atributo_w || ds_valor_w;
							else
								atributo_w := atributo_w || '"' || ds_valor_w || '" ';
							end if;
							if ( ar_xml_elemento_w[1].IE_TIPO_ELEMENTO = 'E' ) then
								if ( ie_criar_atributo_w = 'S') and
									(( trim(both wheb_exportar_xml_pck.obter_valor_parametro(nm_atributo_w,ar_result_query_sup_p)) is not null) or ( ie_criar_nulo_w = 'S')) then
									atributo_w := atributo_w || '</' || nm_atributo_xml_w ||'>';
								end if;
							end if;
						end if;
						CALL wheb_exportar_xml_pck.addxml(atributo_w);
					end if;
				end if;
				nr_seq_atrib_elem_ant_w := coalesce(nr_seq_atrib_elem_w,0);
			end if;
		end loop;
		DBMS_SQL.CLOSE_CURSOR(C003);
		if ( ar_xml_elemento_w[1].IE_TIPO_ELEMENTO = 'A' ) and ( ie_fechar_w ) then
			CALL wheb_exportar_xml_pck.addxml('>');
		end if;
	end;

$body$
LANGUAGE PLPGSQL
;
-- REVOKE ALL ON PROCEDURE wheb_exportar_xml_pck.gerar_xml_atributo (ar_xml_elemento_w xmlElemento,ar_result_query_sup_p myArray,nm_tabela_def_banco_p text) FROM PUBLIC;
