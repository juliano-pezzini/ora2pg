-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_ecarta_integracao_pck.atualizar_arquivo ( pls_arquivo_p pls_arquivo_r) AS $body$
DECLARE

	nm_arquivo_w	pls_ecarta_arquivo_solic.nm_arquivo%type;
	ds_caminho_w	pls_ecarta_arquivo_solic.ds_caminho%type;

BEGIN
	-- Seta variáveis globais
	PERFORM set_config('pls_ecarta_integracao_pck.nm_procedimento_w', 'atualizar arquivo da solicitação', false);

	-- Retira barras e contra-barras extras
	nm_arquivo_w := pls_ecarta_integracao_pck.ajustar_barra(pls_arquivo_p.nm_arquivo);
	ds_caminho_w := pls_ecarta_integracao_pck.ajustar_barra(pls_arquivo_p.ds_caminho);

	-- Retira o caminho do contexto da função
	ds_caminho_w := replace(ds_caminho_w, current_setting('pls_ecarta_integracao_pck.pls_parametro_t')::pls_parametro_r.ds_diretorio_funcao, '');

	if (pls_arquivo_p.nr_sequencia IS NOT NULL AND pls_arquivo_p.nr_sequencia::text <> '') then
		if (pls_arquivo_p.ie_excluir = 'S') then
			-- Excluir arquivo da solicitação
			delete from pls_ecarta_arquivo_solic where nr_sequencia	= pls_arquivo_p.nr_sequencia;

			-- Seta variáveis globais
			PERFORM set_config('pls_ecarta_integracao_pck.nr_seq_ecarta_arquivo_solic_w', null, false);
		else
			-- Atualiza arquivo existente
			update	pls_ecarta_arquivo_solic
			set	nm_arquivo		= nm_arquivo_w,
				ds_caminho		= ds_caminho_w,
				qt_tamanho		= pls_arquivo_p.qt_tamanho,
				qt_paginas		= pls_arquivo_p.qt_paginas,
				ie_aviso_recebimento	= coalesce(pls_arquivo_p.ie_aviso_recebimento, 'N'),
				ie_geracao_completa	= coalesce(pls_arquivo_p.ie_geracao_completa, 'S'),
				dt_atualizacao		= clock_timestamp(),
				nm_usuario		= current_setting('pls_ecarta_integracao_pck.nm_usuario_w')::usuario.nm_usuario%type
			where	nr_sequencia	= pls_arquivo_p.nr_sequencia;
		end if;
	elsif (pls_arquivo_p.nr_seq_ecarta_solicitacao IS NOT NULL AND pls_arquivo_p.nr_seq_ecarta_solicitacao::text <> '') then
		-- Insere o arquivo da solicitação
		insert into pls_ecarta_arquivo_solic(
			nr_sequencia,
			nr_seq_ecarta_solicitacao,
			nm_arquivo,
			ds_caminho,
			qt_tamanho,
			qt_paginas,
			ie_aviso_recebimento,
			ie_geracao_completa,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			dt_atualizacao,
			nm_usuario
		) values (
			nextval('pls_ecarta_arquivo_solic_seq'),		-- nr_sequencia
			pls_arquivo_p.nr_seq_ecarta_solicitacao,	-- nr_seq_ecarta_solicitacao
			nm_arquivo_w,					-- nm_arquivo
			ds_caminho_w,					-- ds_caminho
			pls_arquivo_p.qt_tamanho,			-- qt_tamanho
			pls_arquivo_p.qt_paginas,			-- qt_paginas
			coalesce(pls_arquivo_p.ie_aviso_recebimento, 'N'),	-- ie_aviso_recebimento
			coalesce(pls_arquivo_p.ie_geracao_completa, 'S'),	-- ie_geracao_completa
			clock_timestamp(),					-- dt_atualizacao_nrec
			current_setting('pls_ecarta_integracao_pck.nm_usuario_w')::usuario.nm_usuario%type,					-- nm_usuario_nrec
			clock_timestamp(),					-- dt_atualizacao
			current_setting('pls_ecarta_integracao_pck.nm_usuario_w')::usuario.nm_usuario%type					-- nm_usuario
		);
	end if;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ecarta_integracao_pck.atualizar_arquivo ( pls_arquivo_p pls_arquivo_r) FROM PUBLIC;