-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_ecarta_integracao_pck.incluir_log ( ie_tipo_log_p pls_ecarta_log_integracao.ie_tipo_log%type, ds_log_p pls_ecarta_log_integracao.ds_log%type, ds_extra_p pls_ecarta_log_integracao.ds_extra%type default null, nr_linha_p bigint default null) AS $body$
DECLARE

	/*
	ie_tipo_log_p:
	I - Informação
	A - Alerta
	E - Erro
	D - Debug
	*/
	ds_extra_w text := null;

BEGIN
	-- Verifica se o debug está configurado para o estabelecimento
	if (coalesce(current_setting('pls_ecarta_integracao_pck.pls_parametro_t')::pls_parametro_r.ie_log_debug, '') != 'S' and ie_tipo_log_p = 'D') then
		return;
	end if;

	-- Inclui a linha em que ocorreu o log nas informações extras
	if (nr_linha_p IS NOT NULL AND nr_linha_p::text <> '') then
		ds_extra_w := ds_extra_w || '-- Linha: ' || nr_linha_p;

		-- Inclui nome do procedimento nas informações extras
		if (current_setting('pls_ecarta_integracao_pck.nm_procedimento_w')::(varchar(128) IS NOT NULL AND (varchar(128))::text <> '')) then
			ds_extra_w := ds_extra_w || ' (' || current_setting('pls_ecarta_integracao_pck.nm_procedimento_w')::varchar(128) || ')';
		end if;

		ds_extra_w := ds_extra_w || chr(13) || chr(13);
	end if;

	-- Inclui a informação extra recebida como parâmetro
	if (ds_extra_p IS NOT NULL AND ds_extra_p::text <> '') then
		ds_extra_w := ds_extra_w || '-- Extras: ' || chr(13);
		ds_extra_w := ds_extra_w || ds_extra_p || chr(13);
	end if;

	-- Inclui parâmetros nas informações extras
	if (current_setting('pls_ecarta_integracao_pck.pls_parametro_t')::(pls_parametro_r.nr_sequencia IS NOT NULL AND pls_parametro_r.nr_sequencia::text <> '')) then
		ds_extra_w := ds_extra_w || '-- Parâmetros: ' || chr(13);
		ds_extra_w := ds_extra_w || 'ie_origem                    = '	|| current_setting('pls_ecarta_integracao_pck.pls_parametro_t')::pls_parametro_r.ie_origem || ' - '
										|| obter_valor_dominio(8699, current_setting('pls_ecarta_integracao_pck.pls_parametro_t')::pls_parametro_r.ie_origem)	|| chr(13);
		ds_extra_w := ds_extra_w || 'nr_contrato_correios         = ' 	|| current_setting('pls_ecarta_integracao_pck.pls_parametro_t')::pls_parametro_r.nr_contrato_correios			|| chr(13);
		ds_extra_w := ds_extra_w || 'ds_diretorio_funcao          = ' 	|| current_setting('pls_ecarta_integracao_pck.pls_parametro_t')::pls_parametro_r.ds_diretorio_funcao			|| chr(13);
		ds_extra_w := ds_extra_w || 'ds_diretorio_funcao_windows  = ' 	|| current_setting('pls_ecarta_integracao_pck.pls_parametro_t')::pls_parametro_r.ds_diretorio_funcao_w		|| chr(13);
		ds_extra_w := ds_extra_w || 'ds_diretorio_enviados        = ' 	|| current_setting('pls_ecarta_integracao_pck.pls_parametro_t')::pls_parametro_r.ds_dir_enviados_comp			|| chr(13);
		ds_extra_w := ds_extra_w || 'ds_diretorio_recebidos       = ' 	|| current_setting('pls_ecarta_integracao_pck.pls_parametro_t')::pls_parametro_r.ds_dir_recebidos_comp		|| chr(13);
		ds_extra_w := ds_extra_w || 'ds_diretorio_inconsistencias = ' 	|| current_setting('pls_ecarta_integracao_pck.pls_parametro_t')::pls_parametro_r.ds_dir_inconsistencias_comp		|| chr(13);
		ds_extra_w := ds_extra_w || 'ds_diretorio_erros           = ' 	|| current_setting('pls_ecarta_integracao_pck.pls_parametro_t')::pls_parametro_r.ds_dir_erros_comp			|| chr(13);
		ds_extra_w := ds_extra_w || 'ds_diretorio_temp            = ' 	|| current_setting('pls_ecarta_integracao_pck.pls_parametro_t')::pls_parametro_r.ds_dir_temp_comp			|| chr(13);
		ds_extra_w := ds_extra_w || 'ie_envia_email               = ' 	|| current_setting('pls_ecarta_integracao_pck.pls_parametro_t')::pls_parametro_r.ie_envia_email			|| chr(13);
		ds_extra_w := ds_extra_w || 'ds_remetente_email           = ' 	|| current_setting('pls_ecarta_integracao_pck.pls_parametro_t')::pls_parametro_r.ds_remetente_email			|| chr(13);
		ds_extra_w := ds_extra_w || 'ds_destinatario_email        = ' 	|| current_setting('pls_ecarta_integracao_pck.pls_parametro_t')::pls_parametro_r.ds_destinatario_email		|| chr(13);
		ds_extra_w := ds_extra_w || 'ds_servidor_ftp              = ' 	|| current_setting('pls_ecarta_integracao_pck.pls_parametro_t')::pls_parametro_r.ds_servidor_ftp			|| chr(13);
		ds_extra_w := ds_extra_w || 'nr_porta_ftp                 = ' 	|| current_setting('pls_ecarta_integracao_pck.pls_parametro_t')::pls_parametro_r.nr_porta_ftp				|| chr(13);
		ds_extra_w := ds_extra_w || 'nm_usuario_ftp               = ' 	|| current_setting('pls_ecarta_integracao_pck.pls_parametro_t')::pls_parametro_r.nm_usuario_ftp			|| chr(13);
--		ds_extra_w := ds_extra_w || 'ds_senha_ftp                 = ' 	|| pls_parametro_t.ds_senha_ftp				|| chr(13);
		ds_extra_w := ds_extra_w || 'ds_dir_remoto_enviados       = ' 	|| current_setting('pls_ecarta_integracao_pck.pls_parametro_t')::pls_parametro_r.ds_dir_remoto_enviados		|| chr(13);
		ds_extra_w := ds_extra_w || 'ds_dir_remoto_recebidos      = ' 	|| current_setting('pls_ecarta_integracao_pck.pls_parametro_t')::pls_parametro_r.ds_dir_remoto_recebidos		|| chr(13);
		ds_extra_w := ds_extra_w || 'ie_log_debug                 = ' 	|| current_setting('pls_ecarta_integracao_pck.pls_parametro_t')::pls_parametro_r.ie_log_debug				|| chr(13);
		ds_extra_w := ds_extra_w || 'ds_servico_web_ftps          = ' 	|| current_setting('pls_ecarta_integracao_pck.pls_parametro_t')::pls_parametro_r.ds_servico_web_ftps			|| chr(13);
		ds_extra_w := ds_extra_w || '' || chr(13);
	end if;

	-- Inclui Matriz nas informações extras
	if (current_setting('pls_ecarta_integracao_pck.pls_matriz_t')::(pls_matriz_r.nr_sequencia IS NOT NULL AND pls_matriz_r.nr_sequencia::text <> '')) then
		ds_extra_w := ds_extra_w || '-- Matriz: ' || chr(13);
		ds_extra_w := ds_extra_w || 'cd_identificador             = ' || current_setting('pls_ecarta_integracao_pck.pls_matriz_t')::pls_matriz_r.cd_identificador			|| chr(13);
		ds_extra_w := ds_extra_w || 'ds_matriz                    = ' || current_setting('pls_ecarta_integracao_pck.pls_matriz_t')::pls_matriz_r.ds_matriz				|| chr(13);
		ds_extra_w := ds_extra_w || 'nr_cartao_postagem           = ' || current_setting('pls_ecarta_integracao_pck.pls_matriz_t')::pls_matriz_r.nr_cartao_postagem		|| chr(13);
		ds_extra_w := ds_extra_w || 'qt_limite_diario             = ' || current_setting('pls_ecarta_integracao_pck.pls_matriz_t')::pls_matriz_r.qt_limite_diario			|| chr(13);
		ds_extra_w := ds_extra_w || 'ie_ar_digital                = ' || current_setting('pls_ecarta_integracao_pck.pls_matriz_t')::pls_matriz_r.ie_ar_digital			|| chr(13);
		ds_extra_w := ds_extra_w || 'ie_arquivo_complementar      = ' || current_setting('pls_ecarta_integracao_pck.pls_matriz_t')::pls_matriz_r.ie_arquivo_complementar		|| chr(13);
		ds_extra_w := ds_extra_w || '' || chr(13);
	end if;

	-- Inclui log
	PERFORM set_config('pls_ecarta_integracao_pck.qt_log_w', current_setting('pls_ecarta_integracao_pck.qt_log_w')::numeric(22) + 1, false);
	current_setting('pls_ecarta_integracao_pck.pls_log_t')::pls_log_row(current_setting('pls_ecarta_integracao_pck.qt_log_w')::numeric(22)).cd_estabelecimento		:= current_setting('pls_ecarta_integracao_pck.cd_estabelecimento_w')::estabelecimento.cd_estabelecimento%type;
	current_setting('pls_ecarta_integracao_pck.pls_log_t')::pls_log_row(current_setting('pls_ecarta_integracao_pck.qt_log_w')::numeric(22)).nr_seq_ecarta_parametro	:= current_setting('pls_ecarta_integracao_pck.nr_seq_ecarta_parametro_w')::pls_ecarta_parametro.nr_sequencia%type;
	current_setting('pls_ecarta_integracao_pck.pls_log_t')::pls_log_row(current_setting('pls_ecarta_integracao_pck.qt_log_w')::numeric(22)).nr_seq_ecarta_matriz	:= current_setting('pls_ecarta_integracao_pck.nr_seq_ecarta_matriz_w')::pls_ecarta_matriz.nr_sequencia%type;
	current_setting('pls_ecarta_integracao_pck.pls_log_t')::pls_log_row(current_setting('pls_ecarta_integracao_pck.qt_log_w')::numeric(22)).nr_seq_ecarta_lote		:= current_setting('pls_ecarta_integracao_pck.nr_seq_ecarta_lote_w')::pls_ecarta_lote.nr_sequencia%type;
	current_setting('pls_ecarta_integracao_pck.pls_log_t')::pls_log_row(current_setting('pls_ecarta_integracao_pck.qt_log_w')::numeric(22)).nr_seq_ecarta_solicitacao	:= current_setting('pls_ecarta_integracao_pck.nr_seq_ecarta_solicitacao_w')::pls_ecarta_solicitacao.nr_sequencia%type;
	current_setting('pls_ecarta_integracao_pck.pls_log_t')::pls_log_row(current_setting('pls_ecarta_integracao_pck.qt_log_w')::numeric(22)).nr_seq_ecarta_arquivo_solic	:= current_setting('pls_ecarta_integracao_pck.nr_seq_ecarta_arquivo_solic_w')::pls_ecarta_arquivo_solic.nr_sequencia%type;
	current_setting('pls_ecarta_integracao_pck.pls_log_t')::pls_log_row(current_setting('pls_ecarta_integracao_pck.qt_log_w')::numeric(22)).dt_log			:= CURRENT_TIMESTAMP;
	current_setting('pls_ecarta_integracao_pck.pls_log_t')::pls_log_row(current_setting('pls_ecarta_integracao_pck.qt_log_w')::numeric(22)).ie_tipo_log			:= ie_tipo_log_p;
	current_setting('pls_ecarta_integracao_pck.pls_log_t')::pls_log_row(current_setting('pls_ecarta_integracao_pck.qt_log_w')::numeric(22)).ds_log			:= ds_log_p;
	current_setting('pls_ecarta_integracao_pck.pls_log_t')::pls_log_row(current_setting('pls_ecarta_integracao_pck.qt_log_w')::numeric(22)).ds_extra			:= ds_extra_w;
	current_setting('pls_ecarta_integracao_pck.pls_log_t')::pls_log_row(current_setting('pls_ecarta_integracao_pck.qt_log_w')::numeric(22)).nm_procedimento		:= current_setting('pls_ecarta_integracao_pck.nm_procedimento_w')::varchar(128);
	current_setting('pls_ecarta_integracao_pck.pls_log_t')::pls_log_row(current_setting('pls_ecarta_integracao_pck.qt_log_w')::numeric(22)).nr_linha			:= nr_linha_p;

	-- Seta variáveis globais
	if (ie_tipo_log_p = 'E') then
		PERFORM set_config('pls_ecarta_integracao_pck.ie_erro_w', true, false);
	end if;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ecarta_integracao_pck.incluir_log ( ie_tipo_log_p pls_ecarta_log_integracao.ie_tipo_log%type, ds_log_p pls_ecarta_log_integracao.ds_log%type, ds_extra_p pls_ecarta_log_integracao.ds_extra%type default null, nr_linha_p bigint default null) FROM PUBLIC;
