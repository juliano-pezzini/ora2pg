-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


CREATE TYPE pls_pagador_r AS (
		nr_sequencia	pls_notificacao_pagador.nr_sequencia%type,
		nm_destinatario	pessoa_juridica.ds_razao_social%type,
		ds_endereco	compl_pessoa_fisica.ds_endereco%type,
		nr_endereco	pessoa_juridica.nr_endereco%type,
		ds_complemento	pessoa_juridica.ds_complemento%type,
		ds_bairro	compl_pessoa_fisica.ds_bairro%type,
		ds_municipio	compl_pessoa_fisica.ds_municipio%type,
		sg_estado	compl_pessoa_fisica.sg_estado%type,
		cd_cep		compl_pessoa_fisica.cd_cep%type,
		nr_seq_pagador	pls_contrato_pagador.nr_sequencia%type
	);


CREATE OR REPLACE PROCEDURE pls_ecarta_gerar_notific_pck.gerar_lote ( nr_seq_lote_p pls_notificacao_lote.nr_sequencia%type, nr_seq_pagador_p pls_notificacao_pagador.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

	-- tipos
	type pls_pagador_row	is table of pls_pagador_r index by integer;
	
	-- variáveis
	pls_pagador_t			pls_pagador_row;
	nr_seq_regra_w			pls_notificacao_lote.nr_seq_regra%type;
	nr_seq_matriz_w			pls_ecarta_matriz.nr_sequencia%type;
	nr_seq_ecarta_parametro_w	pls_ecarta_parametro.nr_sequencia%type;
	ds_diretorio_relatorio_w	pls_ecarta_parametro.ds_diretorio_relatorio%type;
	nr_seq_ecarta_lote_w		pls_ecarta_lote.nr_sequencia%type;
	nr_seq_ecarta_solicitacao_w	pls_ecarta_solicitacao.nr_sequencia%type;
	nr_seq_ecarta_arq_solic_w	pls_ecarta_arquivo_solic.nr_sequencia%type;
	nr_seq_relatorio_w		pls_notificacao_regra.nr_seq_relatorio%type;
	nr_cep_w			pls_ecarta_endereco_solic.cd_cep%type;
	qt_notificacao_recebida_w	integer;
	
	nr_seq_pls_relatorio_w		pls_relatorio.nr_sequencia%type;
	cd_classif_relat_w		relatorio.cd_classif_relat%type;
	cd_relatorio_w			relatorio.cd_relatorio%type;
	ds_local_rede_w			evento_tasy_utl_file.ds_local_rede%type;
	nm_arquivo_w			varchar(255);
	
	-- Parâmetro e matriz da regra do lote
	c01_w CURSOR FOR
		SELECT	b.nr_seq_regra,
			a.nr_seq_ecarta_matriz, 
			c.nr_seq_ecarta_parametro,
			a.nr_seq_relatorio,
			d.ds_diretorio_relatorio
		from	pls_ecarta_parametro	d,
			pls_ecarta_param_matriz	c,
			pls_notificacao_lote	b,
			pls_notificacao_regra	a
		where	d.nr_sequencia		= c.nr_seq_ecarta_parametro
		and	c.nr_seq_ecarta_matriz	= a.nr_seq_ecarta_matriz
		and	b.nr_seq_regra		= a.nr_sequencia
		and	b.nr_sequencia		= nr_seq_lote_p;
	
	-- pagadores
	c02_w CURSOR FOR
		SELECT	a.nr_sequencia,
			obter_nome_pf_pj(b.cd_pessoa_fisica,b.cd_cgc)						nm_destinatario,
			pls_obter_end_pagador(a.nr_seq_pagador, 'E')						ds_endereco,
			pls_obter_end_pagador(a.nr_seq_pagador, 'NR')						nr_endereco,
			substr(trim(both pls_obter_end_pagador(a.nr_seq_pagador, 'CO')), 1, 36)			ds_complemento,
			substr(trim(both pls_obter_end_pagador(a.nr_seq_pagador, 'B')), 1, 72)			ds_bairro,
			pls_obter_end_pagador(a.nr_seq_pagador, 'CI')						ds_municipio,
			substr(trim(both pls_obter_end_pagador(a.nr_seq_pagador, 'UF')), 1, 2)			sg_estado,
			substr(somente_numero(pls_obter_end_pagador(a.nr_seq_pagador, 'CEP')), 1, 8)		cd_cep,
			b.nr_sequencia										nr_seq_pagador
		from	pls_contrato_pagador	b,
			pls_notificacao_pagador	a
		where	b.nr_sequencia		= a.nr_seq_pagador
		and	a.nr_seq_lote		= nr_seq_lote_p
		and	coalesce(nr_seq_pagador_p::text, '') = ''
		
union

		SELECT	a.nr_sequencia,
			obter_nome_pf_pj(b.cd_pessoa_fisica,b.cd_cgc)						nm_destinatario,
			pls_obter_end_pagador(a.nr_seq_pagador, 'E')						ds_endereco,
			pls_obter_end_pagador(a.nr_seq_pagador, 'NR')						nr_endereco,
			substr(trim(both pls_obter_end_pagador(a.nr_seq_pagador, 'CO')), 1, 36)			ds_complemento,
			substr(trim(both pls_obter_end_pagador(a.nr_seq_pagador, 'B')), 1, 72)			ds_bairro,
			pls_obter_end_pagador(a.nr_seq_pagador, 'CI')						ds_municipio,
			substr(trim(both pls_obter_end_pagador(a.nr_seq_pagador, 'UF')), 1, 2)			sg_estado,
			substr(somente_numero(pls_obter_end_pagador(a.nr_seq_pagador, 'CEP')), 1, 8)		cd_cep,
			b.nr_sequencia										nr_seq_pagador
		from	pls_contrato_pagador	b,
			pls_notificacao_pagador	a
		where	b.nr_sequencia		= a.nr_seq_pagador
		and	a.nr_seq_lote		= nr_seq_lote_p
		and	a.nr_sequencia	 	= nr_seq_pagador_p;
	
BEGIN
	-- Valida número do lote
	if (coalesce(nr_seq_lote_p::text, '') = '') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort('O Número do Lote de Notificação é obrigatório!');
	end if;
	
	-- Seleciona a matriz do e-Carta a partir da regra do lote de notificação
	open c01_w;
	fetch c01_w into
		nr_seq_regra_w, 
		nr_seq_matriz_w, 
		nr_seq_ecarta_parametro_w,
		nr_seq_relatorio_w,
		ds_diretorio_relatorio_w;
	close c01_w;
	
	-- Verifica se o lote de notificação possui regra, e se a regra possui matriz do e-Carta
	if (coalesce(nr_seq_regra_w::text, '') = '') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort('O Lote de Notificação (' || nr_seq_lote_p || ') não possui Regra para geração definida!');
	elsif (coalesce(nr_seq_matriz_w::text, '') = '') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort('A Regra para geração (' || nr_seq_regra_w || ') do Lote de Notificação (' || nr_seq_lote_p || ') não possui Matriz e-Carta definida!');
	elsif (coalesce(nr_seq_ecarta_parametro_w::text, '') = '') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort('A Matriz da Regra para geração (' || nr_seq_matriz_w || ') do Lote de Notificação (' || nr_seq_lote_p || ') não possui Parâmetro e-Carta associado!');
	end if;

	-- Carrega pagadores
	open c02_w;
	loop fetch c02_w bulk collect into pls_pagador_t limit pls_util_pck.qt_registro_transacao_w;
		exit when pls_pagador_t.count = 0;
		begin
			-- Cria o lote de solicitações
			select nextval('pls_ecarta_lote_seq') into STRICT nr_seq_ecarta_lote_w;
			insert into pls_ecarta_lote(
				nr_sequencia,
				nr_seq_ecarta_parametro,
				nr_seq_ecarta_matriz,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				dt_atualizacao,
				nm_usuario,
				cd_estabelecimento
			) values (
				nr_seq_ecarta_lote_w,		-- nr_sequencia
				nr_seq_ecarta_parametro_w,	-- nr_seq_ecarta_parametro
				nr_seq_matriz_w,		-- nr_seq_ecarta_matriz
				clock_timestamp(),			-- dt_atualizacao_nrec
				nm_usuario_p,			-- nm_usuario_nrec
				clock_timestamp(),			-- dt_atualizacao
				nm_usuario_p,			-- nm_usuario
				cd_estabelecimento_p
			);
			
			-- Processa pagadores
			for i in pls_pagador_t.first..pls_pagador_t.last loop
				
				--Verificar se o pagador já possui e-Carta recebido
				select	count(1)
				into STRICT	qt_notificacao_recebida_w
				from	pls_ecarta_solicitacao a,
					pls_ecarta_lote b
				where	b.nr_sequencia	= a.nr_seq_ecarta_lote
				and	a.nr_seq_notific_pagador	= pls_pagador_t[i].nr_sequencia
				and	coalesce(b.ie_cancelado,'N')	= 'N'
				and ((a.dt_recebimento_notificacao IS NOT NULL AND a.dt_recebimento_notificacao::text <> '') or coalesce(b.dt_envio::text, '') = '');
				
				if (qt_notificacao_recebida_w = 0) then
					-- Insere a solicitação
					insert into pls_ecarta_solicitacao(
						nr_sequencia,
						nr_seq_ecarta_lote,
						nr_seq_notific_pagador,
						nm_destinatario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						dt_atualizacao,
						nm_usuario
					) values (
						nextval('pls_ecarta_solicitacao_seq'),	-- nr_sequencia
						nr_seq_ecarta_lote_w,			-- nr_seq_ecarta_lote
						pls_pagador_t[i].nr_sequencia,		-- nr_seq_notific_pagador
						pls_pagador_t[i].nm_destinatario,	-- nm_destinatario
						clock_timestamp(),				-- dt_atualizacao_nrec
						nm_usuario_p,				-- nm_usuario_nrec
						clock_timestamp(),				-- dt_atualizacao
						nm_usuario_p				-- nm_usuario
					) returning nr_sequencia into nr_seq_ecarta_solicitacao_w;
					
					-- Converte CEP em números
					nr_cep_w := null;
					begin
						if (pls_pagador_t[i](.cd_cep IS NOT NULL AND .cd_cep::text <> '')) then
							nr_cep_w := (pls_pagador_t[i].cd_cep)::numeric;
						end if;
					exception
						when others then
							nr_cep_w := null;
					end;
					
					if (pls_pagador_t[i]coalesce(.ds_endereco::text, '') = '') then
						CALL wheb_mensagem_pck.exibir_mensagem_abort(1076496, 'DS_PAGADOR='|| pls_pagador_t[i].nr_seq_pagador || ' - ' || pls_pagador_t[i].nm_destinatario);
					elsif (pls_pagador_t[i]coalesce(.nr_endereco::text, '') = '') then
						CALL wheb_mensagem_pck.exibir_mensagem_abort(1076497, 'DS_PAGADOR='|| pls_pagador_t[i].nr_seq_pagador || ' - ' || pls_pagador_t[i].nm_destinatario);
					elsif (pls_pagador_t[i]coalesce(.ds_municipio::text, '') = '') then
						CALL wheb_mensagem_pck.exibir_mensagem_abort(1076498, 'DS_PAGADOR='|| pls_pagador_t[i].nr_seq_pagador || ' - ' || pls_pagador_t[i].nm_destinatario);
					elsif (pls_pagador_t[i]coalesce(.sg_estado::text, '') = '') then
						CALL wheb_mensagem_pck.exibir_mensagem_abort(1076499, 'DS_PAGADOR='|| pls_pagador_t[i].nr_seq_pagador || ' - ' || pls_pagador_t[i].nm_destinatario);
					end if;
					
					-- Insere o endereço (1 por solicitação)
					insert into pls_ecarta_endereco_solic(
						nr_sequencia,
						nr_seq_ecarta_solicitacao,
						ds_endereco,
						nr_endereco,
						ds_complemento,
						ds_bairro,
						ds_municipio,
						sg_estado,
						cd_cep,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						dt_atualizacao,
						nm_usuario
					) values (
						nextval('pls_ecarta_endereco_solic_seq'),	-- nr_sequencia
						nr_seq_ecarta_solicitacao_w,		-- nr_seq_ecarta_solicitacao
						pls_pagador_t[i].ds_endereco,		-- ds_endereco
						pls_pagador_t[i].nr_endereco,		-- nr_endereco
						pls_pagador_t[i].ds_complemento,	-- ds_complemento
						pls_pagador_t[i].ds_bairro,		-- ds_bairro
						pls_pagador_t[i].ds_municipio,		-- ds_municipio
						pls_pagador_t[i].sg_estado,		-- sg_estado
						nr_cep_w,				-- cd_cep
						clock_timestamp(), 				-- dt_atualizacao_nrec
						nm_usuario_p,				-- nm_usuario_nrec
						clock_timestamp(),				-- dt_atualizacao
						nm_usuario_p				-- nm_usuario
					);
					
					
					--//TODO: Verificar como será o comportamento do IE_GERACAO_COMPLETA
					null;
					
					-- Insere o Arquivo da Solicitação
					if (nr_seq_relatorio_w IS NOT NULL AND nr_seq_relatorio_w::text <> '') then
						nm_arquivo_w	:= 'notificacao-' || pls_pagador_t[i].nr_sequencia;
						
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
							nextval('pls_ecarta_arquivo_solic_seq'),			-- nr_sequencia
							nr_seq_ecarta_solicitacao_w,				-- nr_seq_ecarta_solicitacao
							nm_arquivo_w,						-- nm_arquivo
							ds_diretorio_relatorio_w,				-- ds_caminho -- Tem que ser salvo a partir do contexto do diretório da função do e-Carta
							73768,							-- qt_tamanho
							4,							-- qt_paginas
							'N', 							-- ie_aviso_recebimento
							'S',							-- ie_geracao_completa
							clock_timestamp(), 						-- dt_atualizacao_nrec
							nm_usuario_p,						-- nm_usuario_nrec
							clock_timestamp(),						-- dt_atualizacao
							nm_usuario_p						-- nm_usuario
						) returning nr_sequencia into nr_seq_ecarta_arq_solic_w;
						
						select	cd_classif_relat,
							cd_relatorio
						into STRICT	cd_classif_relat_w,
							cd_relatorio_w
						from	relatorio
						where	nr_sequencia	= nr_seq_relatorio_w;
						
						select	max(ds_local_rede)
						into STRICT	ds_local_rede_w
						from	evento_tasy_utl_file
						where	cd_evento = 30;
						
						insert	into	pls_relatorio(	nr_sequencia,
								nr_seq_ecarta_arq_solic,
								cd_estabelecimento,
								cd_classif_relat,
								cd_relatorio,
								dt_atualizacao,
								dt_atualizacao_nrec,
								nm_usuario,
								nm_usuario_nrec,
								ie_origem,
								ie_status,
								ds_arquivo,
								ds_caminho
							)
							values (nextval('pls_relatorio_seq'),
								nr_seq_ecarta_arq_solic_w,
								cd_estabelecimento_p,
								cd_classif_relat_w,
								cd_relatorio_w,
								clock_timestamp(),
								clock_timestamp(),
								nm_usuario_p,
								nm_usuario_p,
								'3',
								'1',
								nm_arquivo_w,
								ds_local_rede_w||ds_diretorio_relatorio_w
								) returning nr_sequencia into nr_seq_pls_relatorio_w;
								
						insert	into	pls_relat_param(	nr_sequencia,
								nr_seq_relat,
								ie_tipo_parametro,
								nm_parametro,
								ds_valor_parametro,
								dt_atualizacao,
								dt_atualizacao_nrec,
								nm_usuario,
								nm_usuario_nrec
								)
							values (	nextval('pls_relat_param_seq'),
								nr_seq_pls_relatorio_w,
								'C',
								'NR_SEQ_PAGADOR',
								pls_pagador_t[i].nr_sequencia,
								clock_timestamp(),
								clock_timestamp(),
								nm_usuario_p,
								nm_usuario_p);
					end if;
				end if;
			end loop;
			
			-- Confirma alterações da transação
			commit;
		exception
			when others then
				-- Defaz alterações
				rollback;
				-- Levanta a excessão ocorrida
				CALL wheb_mensagem_pck.exibir_mensagem_abort(sqlerrm(SQLSTATE));
		end;
	end loop;
	close c02_w;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ecarta_gerar_notific_pck.gerar_lote ( nr_seq_lote_p pls_notificacao_lote.nr_sequencia%type, nr_seq_pagador_p pls_notificacao_pagador.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;