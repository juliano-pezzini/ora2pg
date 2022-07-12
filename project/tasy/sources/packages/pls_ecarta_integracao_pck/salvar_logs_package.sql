-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_ecarta_integracao_pck.salvar_logs () AS $body$
DECLARE

	ds_assunto_w	varchar(255) := null;
	ds_mensagem_w	text := null;
	ds_info_w	varchar(1024);
	file_w		utl_file.file_type;
BEGIN
	-- Insere todos os logs em um único comando
	if (current_setting('pls_ecarta_integracao_pck.pls_log_t')::pls_log_row.count > 0) then
		-- Cria o arquivo físico de log
		if (current_setting('pls_ecarta_integracao_pck.ie_erro_w')::boolean) then
			begin
				file_w := utl_file.fopen(current_setting('pls_ecarta_integracao_pck.pls_parametro_t')::pls_parametro_r.ds_dir_erros_comp,	'e-Carta_' ||
												to_char(clock_timestamp(), 'DDMMYYYYHH24MISS') || '_' ||
												current_setting('pls_ecarta_integracao_pck.cd_estabelecimento_w')::estabelecimento.cd_estabelecimento%type || '_' ||
												current_setting('pls_ecarta_integracao_pck.nr_seq_ecarta_parametro_w')::pls_ecarta_parametro.nr_sequencia%type || '.log', 'w', 32767);
			exception
				when others then
					file_w := null;
			end;
		end if;

		for i in current_setting('pls_ecarta_integracao_pck.pls_log_t')::pls_log_row.first..pls_log_t.last loop
			-- Insere o log
			insert into pls_ecarta_log_integracao(
				nr_sequencia,
				cd_estabelecimento,
				nr_seq_ecarta_parametro,
				nr_seq_ecarta_matriz,
				nr_seq_ecarta_lote,
				nr_seq_ecarta_solicitacao,
				nr_seq_ecarta_arquivo_solic,
				dt_log,
				ie_tipo_log,
				ds_log,
				ds_extra,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				dt_atualizacao,
				nm_usuario
			) values (
				nextval('pls_ecarta_log_integracao_seq'),		-- nr_sequencia
				current_setting('pls_ecarta_integracao_pck.pls_log_t')::pls_log_row[i].cd_estabelecimento,		-- cd_estabelecimento
				current_setting('pls_ecarta_integracao_pck.pls_log_t')::pls_log_row[i].nr_seq_ecarta_parametro,		-- nr_seq_ecarta_parametro
				current_setting('pls_ecarta_integracao_pck.pls_log_t')::pls_log_row[i].nr_seq_ecarta_matriz,		-- nr_seq_ecarta_matriz
				current_setting('pls_ecarta_integracao_pck.pls_log_t')::pls_log_row[i].nr_seq_ecarta_lote,		-- nr_seq_ecarta_lote
				current_setting('pls_ecarta_integracao_pck.pls_log_t')::pls_log_row[i].nr_seq_ecarta_solicitacao,		-- nr_seq_ecarta_solicitacao
				current_setting('pls_ecarta_integracao_pck.pls_log_t')::pls_log_row[i].nr_seq_ecarta_arquivo_solic,	-- nr_seq_ecarta_arquivo_solic
				current_setting('pls_ecarta_integracao_pck.pls_log_t')::pls_log_row[i].dt_log,				-- dt_log
				current_setting('pls_ecarta_integracao_pck.pls_log_t')::pls_log_row[i].ie_tipo_log,			-- ie_tipo_log
				current_setting('pls_ecarta_integracao_pck.pls_log_t')::pls_log_row[i].ds_log, 				-- ds_log
				current_setting('pls_ecarta_integracao_pck.pls_log_t')::pls_log_row[i].ds_extra,				-- ds_extra
				clock_timestamp(),					-- dt_atualizacao_nrec
				current_setting('pls_ecarta_integracao_pck.nm_usuario_w')::usuario.nm_usuario%type,					-- nm_usuario_nrec
				clock_timestamp(),					-- dt_atualizacao
				current_setting('pls_ecarta_integracao_pck.nm_usuario_w')::usuario.nm_usuario%type					-- nm_usuario
			);

			-- Salva o log em arquivo .log
			if (current_setting('pls_ecarta_integracao_pck.ie_erro_w')::boolean) then
				if (utl_file.is_open(file_w)) then
					-- Data do log
					ds_mensagem_w := to_char(current_setting('pls_ecarta_integracao_pck.pls_log_t')::pls_log_row[i].dt_log, 'yyyy-mm-dd hh24:mi:ss') || ' ';

					-- Adiciona o tipo de log
					if (current_setting('pls_ecarta_integracao_pck.pls_log_t')::pls_log_row[i].ie_tipo_log = 'I') then
						ds_mensagem_w := ds_mensagem_w || 'INFO ';
					elsif (current_setting('pls_ecarta_integracao_pck.pls_log_t')::pls_log_row[i].ie_tipo_log = 'A') then
						ds_mensagem_w := ds_mensagem_w || 'ALERTA ';
					elsif (current_setting('pls_ecarta_integracao_pck.pls_log_t')::pls_log_row[i].ie_tipo_log = 'E') then
						ds_mensagem_w := ds_mensagem_w || 'ERRO ';
					elsif (current_setting('pls_ecarta_integracao_pck.pls_log_t')::pls_log_row[i].ie_tipo_log = 'D') then
						ds_mensagem_w := ds_mensagem_w || 'DEBUG ';
					end if;

					-- Concatena o método
					if (coalesce(current_setting('pls_ecarta_integracao_pck.pls_log_t')::pls_log_row[i].ie_tipo_log, '') != 'E') then
						if (current_setting('pls_ecarta_integracao_pck.pls_log_t')::pls_log_row[i](.nr_linha IS NOT NULL AND .nr_linha::text <> '')) then
							ds_mensagem_w := ds_mensagem_w || '[' || current_setting('pls_ecarta_integracao_pck.pls_log_t')::pls_log_row[i].nm_procedimento || ':' || current_setting('pls_ecarta_integracao_pck.pls_log_t')::pls_log_row[i].nr_linha || '] ';
						else
							ds_mensagem_w := ds_mensagem_w || '[' || current_setting('pls_ecarta_integracao_pck.pls_log_t')::pls_log_row[i].nm_procedimento || '] ';
						end if;
					end if;

					-- Concatena o log
					ds_mensagem_w := ds_mensagem_w || current_setting('pls_ecarta_integracao_pck.pls_log_t')::pls_log_row[i].ds_log;

					-- Se for erro, concatena conteúdo extra
					if (current_setting('pls_ecarta_integracao_pck.pls_log_t')::pls_log_row[i].ie_tipo_log = 'E') then
						-- Incluído o ds_extra
						ds_mensagem_w := ds_mensagem_w || chr(13) || current_setting('pls_ecarta_integracao_pck.pls_log_t')::pls_log_row[i].ds_extra;

						-- Informações adicionais (chaves estrangeiras)
						ds_info_w := '-- Informações: ' || chr(13);
						ds_info_w := ds_info_w || 'cd_estabelecimento          = ' || current_setting('pls_ecarta_integracao_pck.cd_estabelecimento_w')::estabelecimento.cd_estabelecimento%type			|| chr(13);
						ds_info_w := ds_info_w || 'nr_seq_ecarta_parametro     = ' || current_setting('pls_ecarta_integracao_pck.nr_seq_ecarta_parametro_w')::pls_ecarta_parametro.nr_sequencia%type			|| chr(13);
						ds_info_w := ds_info_w || 'nr_seq_ecarta_matriz        = ' || current_setting('pls_ecarta_integracao_pck.nr_seq_ecarta_matriz_w')::pls_ecarta_matriz.nr_sequencia%type			|| chr(13);
						ds_info_w := ds_info_w || 'nr_seq_ecarta_lote          = ' || current_setting('pls_ecarta_integracao_pck.nr_seq_ecarta_lote_w')::pls_ecarta_lote.nr_sequencia%type			|| chr(13);
						ds_info_w := ds_info_w || 'nr_seq_ecarta_solicitacao   = ' || current_setting('pls_ecarta_integracao_pck.nr_seq_ecarta_solicitacao_w')::pls_ecarta_solicitacao.nr_sequencia%type		|| chr(13);
						ds_info_w := ds_info_w || 'nr_seq_ecarta_arquivo_solic = ' || current_setting('pls_ecarta_integracao_pck.nr_seq_ecarta_arquivo_solic_w')::pls_ecarta_arquivo_solic.nr_sequencia%type		|| chr(13);
						ds_info_w := ds_info_w || 'dt_atualizacao              = ' || to_char(clock_timestamp(), 'dd/mm/rrrr hh24:mi:ss')	|| chr(13);
						ds_info_w := ds_info_w || 'nm_usuario                  = ' || current_setting('pls_ecarta_integracao_pck.nm_usuario_w')::usuario.nm_usuario%type				|| chr(13);
						ds_mensagem_w := ds_mensagem_w || ds_info_w || chr(13);
					end if;

					-- Escreve linha no arquivo
					utl_file.put_line(file_w, ds_mensagem_w, true);
				end if;
			end if;

			-- Envia e-mail em caso de erros e alertas
			if (current_setting('pls_ecarta_integracao_pck.pls_log_t')::pls_log_row[i].ie_tipo_log = 'E' or current_setting('pls_ecarta_integracao_pck.pls_log_t')::pls_log_row[i].ie_tipo_log = 'A') and (current_setting('pls_ecarta_integracao_pck.pls_parametro_t')::pls_parametro_r.ie_envia_email = 'S') then
				-- Monta e-Mail
				if (current_setting('pls_ecarta_integracao_pck.pls_log_t')::pls_log_row[i].ie_tipo_log = 'E') then
					ds_assunto_w := '[Philips Tasy] Erro de Integração com e-Carta';
				elsif (current_setting('pls_ecarta_integracao_pck.pls_log_t')::pls_log_row[i].ie_tipo_log = 'A') then
					ds_assunto_w := '[Philips Tasy] Alerta de Integração com e-Carta';
				end if;
				ds_mensagem_w := current_setting('pls_ecarta_integracao_pck.pls_log_t')::pls_log_row[i].ds_log || chr(13) || chr(13);
				ds_mensagem_w := ds_mensagem_w || ds_info_w;
				ds_mensagem_w := ds_mensagem_w || '' || chr(13);

				ds_mensagem_w := ds_mensagem_w || current_setting('pls_ecarta_integracao_pck.pls_log_t')::pls_log_row[i].ds_extra;

				-- Insere o e-Mail
				insert into pls_email(
					 nr_sequencia
					,nr_seq_mensalidade
					,cd_estabelecimento
					,nm_usuario_nrec
					,dt_atualizacao_nrec
					,nm_usuario
					,dt_atualizacao
					,ie_tipo_mensagem
					,ie_tipo_documento
					,ie_status
					,ie_origem
					,ds_remetente
					,ds_mensagem
					,ds_destinatario
					,ds_assunto
					,cd_prioridade
				) values (
					nextval('pls_email_seq')			-- nr_sequencia
					,null					-- nr_seq_mensalidade
					,current_setting('pls_ecarta_integracao_pck.cd_estabelecimento_w')::estabelecimento.cd_estabelecimento%type			-- cd_estabelecimento
					,current_setting('pls_ecarta_integracao_pck.nm_usuario_w')::usuario.nm_usuario%type				-- nm_usuario_nrec
					,clock_timestamp()				-- dt_atualizacao_nrec
					,current_setting('pls_ecarta_integracao_pck.nm_usuario_w')::usuario.nm_usuario%type				-- nm_usuario
					,clock_timestamp()				-- dt_atualizacao
					,3					-- ie_tipo_mensagem	-- Envio de log e-Carta (8201)
					,2					-- ie_tipo_documento	-- Log e-Carta (8194)
					,'P'					-- ie_status		-- Pendente
					,3					-- ie_origem		-- OPS - Controle de Correspondência Digital (8196)
					,current_setting('pls_ecarta_integracao_pck.pls_parametro_t')::pls_parametro_r.ds_remetente_email	-- ds_remetente
					,ds_mensagem_w				-- ds_mensagem
					,current_setting('pls_ecarta_integracao_pck.pls_parametro_t')::pls_parametro_r.ds_destinatario_email	-- ds_destinatario
					,ds_assunto_w				-- ds_assunto
					,1					-- cd_prioridade
				);
			end if;
		end loop;

		-- Seta variáveis globais
		PERFORM set_config('pls_ecarta_integracao_pck.qt_log_w', 0, false);
		current_setting('pls_ecarta_integracao_pck.pls_log_t')::pls_log_row.delete;

		-- Fecha o arquivo físico de log
		if (current_setting('pls_ecarta_integracao_pck.ie_erro_w')::boolean) then
			if (utl_file.is_open(file_w)) then
				utl_file.fclose(file_w);
			end if;
		end if;
	end if;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ecarta_integracao_pck.salvar_logs () FROM PUBLIC;
