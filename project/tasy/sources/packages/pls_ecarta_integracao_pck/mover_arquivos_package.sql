-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_ecarta_integracao_pck.mover_arquivos ( ds_destino_p pls_ecarta_parametro.ds_diretorio_enviados%type) AS $body$
BEGIN
	-- Seta variáveis globais
	PERFORM set_config('pls_ecarta_integracao_pck.nm_procedimento_w', 'mover arquivos da solicitação', false);

	-- Le os arquivos processados
	if (current_setting('pls_ecarta_integracao_pck.pls_arquivo_t')::pls_arquivo_row.count > 0) then
		for i in current_setting('pls_ecarta_integracao_pck.pls_arquivo_t')::pls_arquivo_row.first..pls_arquivo_t.last loop
			if (coalesce(current_setting('pls_ecarta_integracao_pck.pls_arquivo_t')::pls_arquivo_row[i].ie_excluir, '') != 'S') then
				-- Copia o arquivo para o destino
				utl_file.fcopy(current_setting('pls_ecarta_integracao_pck.pls_arquivo_t')::pls_arquivo_row[i].ds_caminho, current_setting('pls_ecarta_integracao_pck.pls_arquivo_t')::pls_arquivo_row[i].nm_arquivo, ds_destino_p, current_setting('pls_ecarta_integracao_pck.pls_arquivo_t')::pls_arquivo_row[i].nm_arquivo);

				-- Remove o arquivo de origem
				utl_file.fremove(current_setting('pls_ecarta_integracao_pck.pls_arquivo_t')::pls_arquivo_row[i].ds_caminho, current_setting('pls_ecarta_integracao_pck.pls_arquivo_t')::pls_arquivo_row[i].nm_arquivo);

				-- Atualiza diretório do arquivo
				current_setting('pls_ecarta_integracao_pck.pls_arquivo_t')::pls_arquivo_row[i].ds_caminho := ds_destino_p;
			end if;

			-- Verifica se o arquivo existe na base
			if (current_setting('pls_ecarta_integracao_pck.pls_arquivo_t')::pls_arquivo_row[i](.nr_sequencia IS NOT NULL AND .nr_sequencia::text <> '')) then
				-- Atualiza o arquivo da solicitação
				CALL CALL pls_ecarta_integracao_pck.incluir_log('D', 'Mover arquivos: Atualiza arquivo da solicitação', null, $$plsql_line);
				CALL pls_ecarta_integracao_pck.atualizar_arquivo(current_setting('pls_ecarta_integracao_pck.pls_arquivo_t')::pls_arquivo_row(i));

				-- Seta variáveis globais
				PERFORM set_config('pls_ecarta_integracao_pck.nm_procedimento_w', 'mover arquivos da solicitação', false);
			end if;
		end loop;

		-- Seta variáveis globais
		PERFORM set_config('pls_ecarta_integracao_pck.nr_seq_ecarta_arquivo_solic_w', null, false);
		current_setting('pls_ecarta_integracao_pck.pls_arquivo_t')::pls_arquivo_row.delete;
		PERFORM set_config('pls_ecarta_integracao_pck.qt_arq_w', 0, false);
	end if;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ecarta_integracao_pck.mover_arquivos ( ds_destino_p pls_ecarta_parametro.ds_diretorio_enviados%type) FROM PUBLIC;