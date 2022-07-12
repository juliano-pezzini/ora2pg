-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE wheb_exportar_xml_pck.exportar ( nr_seq_projeto_p bigint, nr_seq_log_p bigint, ie_tipo_p text, ds_parametros_p text, ie_status_p text default null) AS $body$
DECLARE

	nr_sequencia_w  bigint;
	ar_vazio_w	myArray;
	/*Contem os parametros do SQL*/


	ds_projetos_carac_w	varchar(255);
	ds_proj_verificar_w	varchar(100);
	ds_cabecalho_projeto_w varchar(2000);	
	
	c01 CURSOR FOR
		SELECT	NR_SEQUENCIA
		FROM    xml_elemento a
		WHERE   nr_seq_projeto = nr_seq_projeto_p
		AND		dt_atualizacao_nrec < current_setting('wheb_exportar_xml_pck.dt_assinatura_digital_w')::timestamp
		AND     NOT EXISTS (	SELECT	 1
					FROM     xml_atributo z, xml_elemento x
					WHERE    x.nr_sequencia 	= z.nr_seq_elemento
					AND      x.nr_seq_projeto 	= a.nr_seq_projeto
					AND      z.nr_seq_atrib_elem 	= a.nr_sequencia)
					ORDER BY a.nr_seq_apresentacao;
	
BEGIN

	--aaschlote 05/01/2015 - Tratamento para a geracao do processo longo nao afetar a chamada da rotina PLS_GERAR_ARQ_MONIT_ANS_UTF

	if (ie_tipo_p <> 'MANS') then
		CALL GRAVAR_PROCESSO_LONGO('','WHEB_EXPORTAR_XML',0);
	end if;

	if (ie_tipo_p = 'INTCOM') or (ie_tipo_p = 'INTDISPMH') or (current_setting('wheb_exportar_xml_pck.ie_tipo_w')::varchar(60) = 'INTDISPAP') then
		
		PERFORM set_config('wheb_exportar_xml_pck.ie_limpar_param_w', True, false);
		dbms_lob.createtemporary(current_setting('wheb_exportar_xml_pck.ds_xml_clob_w')::text, TRUE);
		dbms_lob.open(current_setting('wheb_exportar_xml_pck.ds_xml_clob_w')::text, dbms_lob.lob_readwrite);
		
	-- XSIP

	elsif (ie_tipo_p = 'SIP') then
	
		PERFORM set_config('wheb_exportar_xml_pck.ie_limpar_param_w', true, false);
	end if;
	
	if (current_setting('wheb_exportar_xml_pck.ie_limpar_param_w')::boolean ) then
	
		CALL CALL wheb_exportar_xml_pck.limpa_parametros();
	end if;

	PERFORM set_config('wheb_exportar_xml_pck.qt_valor_xml_w', 0, false);
	PERFORM set_config('wheb_exportar_xml_pck.nr_seq_log_w', nr_seq_log_p, false);
	PERFORM set_config('wheb_exportar_xml_pck.nr_seq_projeto_w', nr_seq_projeto_p, false);
	PERFORM set_config('wheb_exportar_xml_pck.ie_tipo_w', ie_tipo_p, false);
	PERFORM set_config('wheb_exportar_xml_pck.ie_status_w', coalesce(ie_status_p, 'E'), false);
	PERFORM set_config('wheb_exportar_xml_pck.nr_seq_geracao_w', 1, false);
	PERFORM set_config('wheb_exportar_xml_pck.ds_ocorrencias_w', '', false);
	PERFORM set_config('wheb_exportar_xml_pck.ds_xml_w', '', false);
	PERFORM set_config('wheb_exportar_xml_pck.ie_proj_carac_esp_w', 'N', false);
	
	if (current_setting('wheb_exportar_xml_pck.ie_tipo_w')::varchar(60) = 'INTCOM') or (current_setting('wheb_exportar_xml_pck.ie_tipo_w')::varchar(60) = 'INTDISPMH') or (current_setting('wheb_exportar_xml_pck.ie_tipo_w')::varchar(60) = 'INTDISPAP') then
	
		dbms_lob.createtemporary(current_setting('wheb_exportar_xml_pck.ds_xml_clob_w')::text, TRUE);
		dbms_lob.open(current_setting('wheb_exportar_xml_pck.ds_xml_clob_w')::text, dbms_lob.lob_readwrite);
	
	-- Para o SIP define que o CLOB ficara aberto apenas para a sessao atual.

	elsif (ie_tipo_p = 'SIP') then
	
		dbms_lob.createtemporary(current_setting('wheb_exportar_xml_pck.ds_xml_clob_w')::text, true, dbms_lob.session);
		dbms_lob.open(current_setting('wheb_exportar_xml_pck.ds_xml_clob_w')::text, dbms_lob.lob_readwrite);
	end if;
	
	/* Felipe - OS 245498 - Para o SIP deve ser da forma abaixo */


	if (current_setting('wheb_exportar_xml_pck.ie_tipo_w')::varchar(60)	= 'SIP') then
	
		CALL wheb_exportar_xml_pck.addxml('<?xml version="1.0" encoding="iso-8859-1"?>');
	/*aaschlote 11/10/2013  OS 633300 - Para o RPS, deve gerar outro cabecalho*/


	elsif (current_setting('wheb_exportar_xml_pck.ie_tipo_w')::varchar(60)	= 'RPS') then
	
		CALL wheb_exportar_xml_pck.addxml('<?xml version="1.0" encoding="UTF-8"?>');
	else		
		/*Cabecalho do XML*/


		begin
			select ds_cabecalho
			into STRICT ds_cabecalho_projeto_w
			from xml_projeto
			where nr_sequencia = current_setting('wheb_exportar_xml_pck.nr_seq_projeto_w')::bigint;
		exception
			when others then
				ds_cabecalho_projeto_w := null;
		end;
		
		if (ds_cabecalho_projeto_w IS NOT NULL AND ds_cabecalho_projeto_w::text <> '') then
			CALL wheb_exportar_xml_pck.addxml(ds_cabecalho_projeto_w);
		else
			CALL wheb_exportar_xml_pck.addxml('<?xml version="1.0" encoding="ISO-8859-1"?>');
		end if;
	end if;

	PERFORM set_config('wheb_exportar_xml_pck.ds_xml_valor_w', '', false);
	PERFORM set_config('wheb_exportar_xml_pck.ds_hash_w', '', false);
	PERFORM set_config('wheb_exportar_xml_pck.ar_result_todos_sql_p', ar_vazio_w, false);
	/*Armazena em um Array os parametros do projeto*/


	CALL CALL wheb_exportar_xml_pck.armazena_parametros(ds_parametros_p);

	PERFORM set_config('wheb_exportar_xml_pck.ds_namespace_w', wheb_exportar_xml_pck.obter_valor_parametro('DS_NAMESPACE',current_setting('wheb_exportar_xml_pck.ar_parametros_w')::myArray), false);
	
	begin
		PERFORM set_config('wheb_exportar_xml_pck.dt_assinatura_digital_w', coalesce(to_date(trim(both wheb_exportar_xml_pck.obter_valor_parametro('DT_ASSINATURA_DIGITAL',current_setting('wheb_exportar_xml_pck.ar_parametros_w')::myArray)),'dd/mm/yyyy hh24:mi:ss'),clock_timestamp()), false);
	exception
	when others then
		PERFORM set_config('wheb_exportar_xml_pck.dt_assinatura_digital_w', clock_timestamp(), false);
	end;
	
	PERFORM set_config('wheb_exportar_xml_pck.ds_carac_espec_conv_w', null, false);
	if (current_setting('wheb_exportar_xml_pck.ie_tipo_w')::varchar(60) = 'TISS') then
		PERFORM set_config('wheb_exportar_xml_pck.ds_carac_espec_conv_w', substr(wheb_exportar_xml_pck.obter_valor_parametro('DS_CARACTERES_XML',current_setting('wheb_exportar_xml_pck.ar_parametros_w')::myArray), 1, 255), false);
	end if;

	Obter_Param_Usuario(	1111,
				2,
				wheb_usuario_pck.get_cd_perfil,
				wheb_usuario_pck.get_nm_usuario,
				wheb_usuario_pck.get_cd_estabelecimento,
				ds_projetos_carac_w
				);
					
	Obter_Param_Usuario(	1111,
				1,
				wheb_usuario_pck.get_cd_perfil,
				wheb_usuario_pck.get_nm_usuario,
				wheb_usuario_pck.get_cd_estabelecimento,
				current_setting('wheb_exportar_xml_pck.ds_carac_espec_w')::varchar(255)
				);
	Obter_Param_Usuario(	1111,
				3,
				wheb_usuario_pck.get_cd_perfil,
				wheb_usuario_pck.get_nm_usuario,
				wheb_usuario_pck.get_cd_estabelecimento,
				current_setting('wheb_exportar_xml_pck.ds_proj_acent_w')::varchar(255)
				);

	PERFORM set_config('wheb_exportar_xml_pck.ie_proj_carac_esp_w', 'N', false);
	while	length(ds_projetos_carac_w) > 0 loop
		if (position(',' in ds_projetos_carac_w) > 0) then
			ds_proj_verificar_w :=	substr(ds_projetos_carac_w, 1, position(',' in ds_projetos_carac_w)-1);
			ds_projetos_carac_w :=	substr(ds_projetos_carac_w, position(',' in ds_projetos_carac_w)+1, length(ds_projetos_carac_w));
		else
			ds_proj_verificar_w := ds_projetos_carac_w;
			ds_projetos_carac_w := '';
		end	if;
	
		if ( ds_proj_verificar_w = current_setting('wheb_exportar_xml_pck.nr_seq_projeto_w')::bigint ) then
			PERFORM set_config('wheb_exportar_xml_pck.ie_proj_carac_esp_w', 'S', false);
			exit;
		end	if;
	end	loop;
	
	PERFORM set_config('wheb_exportar_xml_pck.ie_consist_acent', 'N', false);
	while	length(current_setting('wheb_exportar_xml_pck.ds_proj_acent_w')::varchar(255)) > 0 loop
		if (position(',' in current_setting('wheb_exportar_xml_pck.ds_proj_acent_w')::varchar(255)) > 0) then
			ds_proj_verificar_w :=	substr(current_setting('wheb_exportar_xml_pck.ds_proj_acent_w')::varchar(255), 1, position(',' in current_setting('wheb_exportar_xml_pck.ds_proj_acent_w')::varchar(255))-1);
			PERFORM set_config('wheb_exportar_xml_pck.ds_proj_acent_w', substr(current_setting('wheb_exportar_xml_pck.ds_proj_acent_w')::varchar(255), position(',' in current_setting('wheb_exportar_xml_pck.ds_proj_acent_w')::varchar(255))+1, length(current_setting('wheb_exportar_xml_pck.ds_proj_acent_w')::varchar(255))), false);
		else
			ds_proj_verificar_w := current_setting('wheb_exportar_xml_pck.ds_proj_acent_w')::varchar(255);
			PERFORM set_config('wheb_exportar_xml_pck.ds_proj_acent_w', '', false);
		end	if;
	
		if ( ds_proj_verificar_w = current_setting('wheb_exportar_xml_pck.nr_seq_projeto_w')::bigint ) then
			PERFORM set_config('wheb_exportar_xml_pck.ie_consist_acent', 'S', false);
			exit;
		end	if;
	end	loop;

	OPEN c01;
	LOOP
		FETCH c01 INTO
			nr_sequencia_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
		CALL wheb_exportar_xml_pck.gerar_xml_elemento(nr_sequencia_w,ar_vazio_w,null);
	END LOOP;
	CLOSE c01;

	CALL wheb_exportar_xml_pck.salvarxmlbanco();
	CALL wheb_exportar_xml_pck.salvarvalorxmlbanco();
	CALL wheb_exportar_xml_pck.salvarminmaxocorrencias();
	
	if (current_setting('wheb_exportar_xml_pck.ie_tipo_w')::varchar(60) = 'INTCOM') or (current_setting('wheb_exportar_xml_pck.ie_tipo_w')::varchar(60) = 'INTDISPMH') or (current_setting('wheb_exportar_xml_pck.ie_tipo_w')::varchar(60) = 'INTDISPAP') then
	
		dbms_lob.close(current_setting('wheb_exportar_xml_pck.ds_xml_clob_w')::text);
		
	-- Para a geracao do XSIP

	elsif (current_setting('wheb_exportar_xml_pck.ie_tipo_w')::varchar(60) = 'SIP') then
		
		-- Verifica se ainda esta aberto antes de fechar.

		if (dbms_lob.isopen(current_setting('wheb_exportar_xml_pck.ds_xml_clob_w')::text) > 0) then
		
			dbms_lob.close(current_setting('wheb_exportar_xml_pck.ds_xml_clob_w')::text);
		end if;
		
		-- Limpa o arquivo temporario da sessao.

		dbms_lob.freetemporary(current_setting('wheb_exportar_xml_pck.ds_xml_clob_w')::text);
	end if;
	
	END;

$body$
LANGUAGE PLPGSQL
;
-- REVOKE ALL ON PROCEDURE wheb_exportar_xml_pck.exportar ( nr_seq_projeto_p bigint, nr_seq_log_p bigint, ie_tipo_p text, ds_parametros_p text, ie_status_p text default null) FROM PUBLIC;
