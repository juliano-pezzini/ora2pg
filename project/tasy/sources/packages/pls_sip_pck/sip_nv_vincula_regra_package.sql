-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_sip_pck.sip_nv_vincula_regra ( nr_seq_item_p sip_item_assistencial.nr_sequencia%type, cd_classif_item_p sip_item_assistencial.cd_classificacao%type, nr_seq_lote_p pls_lote_sip.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


rc_cursor_w		sql_pck.t_cursor;

ie_busca_internacao_w	boolean;
ie_tipo_atend_w		sip_nv_dados.ie_tipo_atendimento%type;

tb_dados_w		pls_util_cta_pck.t_number_table;
tb_casamento_w		pls_util_cta_pck.t_varchar2_table_2;

-- Leitura do resultado da regra.

cs_vinc_regra_aux CURSOR FOR
	SELECT	nr_seq_nv_dados,
		min(ie_tipo_casamento)
	from	sip_nv_vinc_regra_aux
	group by nr_seq_nv_dados;

BEGIN
-- So processa se a informacao e correta.

if (nr_seq_item_p IS NOT NULL AND nr_seq_item_p::text <> '') then

	for r_regra_item in c_regra_item(nr_seq_item_p, current_setting('pls_sip_pck.ie_sip_w')::pls_controle_estab.ie_sip%type, cd_estabelecimento_p) loop
		
		rc_cursor_w := null;
		
		-- jjung OS 558830 01/03/2013 tratamento para tipo de atendimento de cada item assistencial, quando for atendimento 

		-- odontologico por enquanto nao sera filtrado pelo tipo de atendimento.

		ie_tipo_atend_w := pls_sip_pck.obter_tipo_atend_item(cd_classif_item_p);
		
		-- verifica se e para buscar das internacoes

		ie_busca_internacao_w := pls_sip_pck.sip_nv_obter_se_busca_inter(r_regra_item.sequ_item);
		
		-- Montar o comando e abrir o cursor para a regra.

		rc_cursor_w := pls_sip_pck.obter_cursor_dados_regra(	nr_seq_lote_p, r_regra_item, ie_busca_internacao_w, ie_tipo_atend_w, rc_cursor_w, nm_usuario_p);
						
		-- Limpeza da tabela auxiliar.

		EXECUTE 'truncate table sip_nv_vinc_regra_aux';
		
		if (rc_cursor_w%isopen) then
			
			-- se for internacao armazena na tabela temporaria para fazer o distinct

			-- senao manda direto para a tabela de vinculo

			if (r_regra_item.sequ_item between 64 and 108) then
		
				loop
					-- limpar os arrays.

					tb_dados_w.delete;
					tb_casamento_w.delete;
					
					fetch rc_cursor_w
					bulk collect into
					tb_dados_w, tb_casamento_w
					limit current_setting('pls_sip_pck.qt_registro_transacao_w')::integer;
					
					exit when tb_dados_w.count = 0;
								
					-- Grava os registros na tabela auxiliar.

					-- Esta sendo utilizada esta estrutura por que identificamos que o agrupamento que era feito em cima

					-- da sip_nv_dados era muito custoso, gravamos e retorno nesta tabela e agrupamos os registros depois.

					CALL pls_sip_pck.grava_vinc_aux(tb_dados_w, tb_casamento_w);
				end loop;
				close rc_cursor_w;
				
				-- Ler os dados gerados na tabela auxiliar agrupados para definir se o item foi vinculado a uma regra ou foi "puxado" por outro item.

				tb_dados_w.delete;
				tb_casamento_w.delete;
				
				open cs_vinc_regra_aux;
				loop
					tb_dados_w.delete;
					tb_casamento_w.delete;
					
					fetch cs_vinc_regra_aux
					bulk collect into tb_dados_w, tb_casamento_w
					limit current_setting('pls_sip_pck.qt_registro_transacao_w')::integer;
					
					exit when tb_dados_w.count = 0;
					
					-- Grava o vinculo do item a regra.

					CALL pls_sip_pck.p_grava_vinculo_regra(r_regra_item.sequ_item, r_regra_item.sequ_regra, tb_dados_w, tb_casamento_w, nm_usuario_p);
				end loop;
				close cs_vinc_regra_aux;
			else
				
				loop
					-- limpar os arrays.

					tb_dados_w.delete;
					tb_casamento_w.delete;
					
					fetch rc_cursor_w
					bulk collect into
					tb_dados_w, tb_casamento_w
					limit current_setting('pls_sip_pck.qt_registro_transacao_w')::integer;
					
					exit when tb_dados_w.count = 0;
								
					-- Grava o vinculo do item a regra.

					CALL pls_sip_pck.p_grava_vinculo_regra(r_regra_item.sequ_item, r_regra_item.sequ_regra, tb_dados_w, tb_casamento_w, nm_usuario_p);
				end loop;
				close rc_cursor_w;
			end if;
		end if;
		
		CALL pls_sip_pck.gravar_tempo_regra(nr_seq_lote_p, r_regra_item.sequ_regra, 'FIM', null, nm_usuario_p);
	end loop;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_sip_pck.sip_nv_vincula_regra ( nr_seq_item_p sip_item_assistencial.nr_sequencia%type, cd_classif_item_p sip_item_assistencial.cd_classificacao%type, nr_seq_lote_p pls_lote_sip.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
