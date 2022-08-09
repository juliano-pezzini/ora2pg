-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_cta_aplicar_filtros ( dados_consistencia_p pls_tipos_ocor_pck.dados_consistencia, dados_regra_p pls_tipos_ocor_pck.dados_regra, dados_forma_geracao_ocor_p pls_tipos_ocor_pck.dados_forma_geracao_ocor, nr_id_transacao_p pls_selecao_ocor_cta.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, qt_registro_p INOUT integer) AS $body$
DECLARE

 
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: Gravar em uma tabela as contas que se apliquem nos combinações de filtros 
de ocorrências. (Filtros relacionados diretamente com a conta médica) 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ X ] Objetos do dicionário [ ] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção: 
Cuidar com os ALIAS... Dar nome padronizado, para facilitar identificação e não repetir.. 
 
Alterações: 
 ------------------------------------------------------------------------------------------------------------------ 
 jjung OS 601441 06/06/2013 - 	 
 Alteração:	Adicionado chamada para filtro de profissional. Linha 170. 
Motivo:	Inclusão de opção de filtro para profissional nos filtros da ocorrência de conta regra combinada. 
 ------------------------------------------------------------------------------------------------------------------ 
 jjung OS 709376 - 03/03/2014 
 
Alteração:	Adicionado parâmetro dados_forma_geracao_p para passar até na pls_oc_cta_obter_restr_padrao 
 
Motivo:	Como no campo Consistência web na regra pode ser informado Ambos o mais correto é tratar 
	pelo evento sendo executado e não pelo evento informado na regra. 
 ------------------------------------------------------------------------------------------------------------------ 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
 
qt_registro_w		integer;
qt_filtro_processado_w	integer;

dados_filtro_w		pls_tipos_ocor_pck.dados_filtro;
ie_incidencia_regra_w	pls_oc_cta_tipo_validacao.ie_aplicacao_ocorrencia%type;
ie_processa_regra_w	varchar(1);
ie_restringe_filtro_w	varchar(1);

-- Dados da PLS_OC_CTA_FILTRO, responsável por armazenar os dados dos filtros criados pelo usuário. 
c_comb_filtro CURSOR(nr_seq_regra_pc	pls_oc_cta_combinada.nr_sequencia%type) FOR 
	SELECT	a.nr_sequencia, 
		a.nm_filtro, 
		a.ie_filtro_conta, 
		a.ie_filtro_proc, 
		a.ie_filtro_mat, 
		a.ie_filtro_benef, 
		a.ie_filtro_prest, 
		a.ie_filtro_interc, 
		a.ie_filtro_contrato, 
		a.ie_filtro_produto, 
		a.ie_filtro_prof, 
		a.ie_excecao, 
		a.ie_filtro_protocolo 
	from	pls_oc_cta_filtro a 
	where	a.nr_seq_oc_cta_comb	= nr_seq_regra_pc 
	and	a.ie_situacao	= 'A' 
	order by 
		/* Passar as exceções no final */
 
		a.ie_excecao;

BEGIN 
-- Inicialização dos contadores 
qt_registro_w	:= 0;
if (dados_regra_p.nr_sequencia IS NOT NULL AND dados_regra_p.nr_sequencia::text <> '') then	 
 
	/* Se não tiver nenhum filtro na regra ou se ela não for de somente filtros, então inclui na seleção todas as contas ou todos os itens */
 
	if (dados_regra_p.ie_utiliza_filtro = 'N' and dados_regra_p.ie_validacao <> 1) then 
	 
		-- Obter a incidência da regra 
		ie_incidencia_regra_w	:= pls_oc_cta_obter_incid_regra(dados_regra_p, dados_filtro_w);
		 
		-- Inserir todas as contas na tabela de seleção com o campo ie_valido como 'S' para validar quando existe mais de um filtro na regra. 
		CALL pls_oc_cta_aplic_fil_pad( 
				dados_consistencia_p, dados_regra_p, dados_forma_geracao_ocor_p, 
				ie_incidencia_regra_w, nr_id_transacao_p, cd_estabelecimento_p, nm_usuario_p);
				 
		qt_registro_w := pls_tipos_ocor_pck.obter_qtde_reg_valido_filtro(nr_id_transacao_p, null);
	else 
		qt_registro_w := 0;
		qt_filtro_processado_w := 0;
		for r_c_comb_filtro in c_comb_filtro(dados_regra_p.nr_sequencia) loop 
			 
			-- Atualizar os dados do filtro na variável para passar todos os dados as outras rotinas 
			dados_filtro_w.nr_sequencia		:= r_c_comb_filtro.nr_sequencia;
			dados_filtro_w.nm_filtro		:= r_c_comb_filtro.nm_filtro;
			dados_filtro_w.ie_filtro_conta		:= r_c_comb_filtro.ie_filtro_conta;
			dados_filtro_w.ie_filtro_proc		:= r_c_comb_filtro.ie_filtro_proc;
			dados_filtro_w.ie_filtro_mat		:= r_c_comb_filtro.ie_filtro_mat;
			dados_filtro_w.ie_filtro_benef		:= r_c_comb_filtro.ie_filtro_benef;
			dados_filtro_w.ie_filtro_prest		:= r_c_comb_filtro.ie_filtro_prest;
			dados_filtro_w.ie_filtro_interc		:= r_c_comb_filtro.ie_filtro_interc;
			dados_filtro_w.ie_filtro_contrato	:= r_c_comb_filtro.ie_filtro_contrato;
			dados_filtro_w.ie_filtro_produto	:= r_c_comb_filtro.ie_filtro_produto;
			dados_filtro_w.ie_filtro_prof		:= r_c_comb_filtro.ie_filtro_prof;
			dados_filtro_w.ie_excecao		:= r_c_comb_filtro.ie_excecao;
			dados_filtro_w.ie_filtro_protocolo	:= r_c_comb_filtro.ie_filtro_protocolo;
			 
			ie_incidencia_regra_w	:= pls_oc_cta_obter_incid_regra(dados_regra_p, dados_filtro_w);
			 
			-- verifica se as regras precisam ser processadas (performance) 
			ie_processa_regra_w := pls_tipos_ocor_pck.obter_se_processa_regra_filtro(	 
							dados_consistencia_p, dados_regra_p, dados_forma_geracao_ocor_p, 
							ie_incidencia_regra_w, nr_id_transacao_p, dados_filtro_w, qt_registro_w, 
							qt_filtro_processado_w, cd_estabelecimento_p, nm_usuario_p);
			-- para de validar os filtros 
			if (ie_processa_regra_w = 'Z') then 
				exit;
			-- se for necessário processar a regra então processa 
			elsif (ie_processa_regra_w = 'S') then 
			 
				-- feito esse tratamento de inicializar com -1 porque se retornar zero significa que 
				-- não tem registros no filtro aplicado e portanto deverá parar de executar, pois tudo 
				-- é do tipo E 
				qt_registro_w := -1;
				 
				-- Se forem filtros de exceção começa o processo de execção e atualiza o campo IE_EXCECAO para S 
				-- e sempre será baseado neste campo para decidir se o registro da pls_selecao_ocor_cta é ou não exceção. 
				if (dados_regra_p.ie_excecao = 'N') then 
					 
					if (dados_filtro_w.ie_excecao = 'S') then 
					 
						CALL pls_tipos_ocor_pck.atualiza_sel_excecao_start(nr_id_transacao_p, 
									dados_regra_p, nm_usuario_p);
						 
						ie_restringe_filtro_w := 'N';
					else 
						ie_restringe_filtro_w := 'S';
					end if;	
					 
				-- Se é regra de exceção e o filtro for de excecao também então começa o processo de verificar se é excecao da excecao e 
				-- atualiza o campo IE_EXCECAO_EXCECAO_TEMP. 
				elsif (dados_regra_p.ie_excecao = 'S') then 
					 
					ie_restringe_filtro_w := 'N';
					 
					if (dados_filtro_w.ie_excecao = 'S') then 
					 
						CALL pls_tipos_ocor_pck.atualiza_sel_exc_exc_start(nr_id_transacao_p);
					end if;
				end if;
				 
				/* Verificar cada checkbox da combinação de filtros, para filtrar cada tipo */
 
				 
				-- Para executar a verificação dos filtros deve ser respeitada a ordem de aplicação dos mesmos, passando do nível mais alto 
				-- Para o nível mais baixo, começando do Protocolo para as contas, das contas para os itens, para que os filtros 
				-- respeitem os outros filtros cadastrados. Isto evita casos em que a conta não atende aos filtros e a ocorrência é lançada para os itens. 
				-- Além disto este conceito ajuda no quesito de performance da aplicação de filtros, por exemplo, o filtro por protocolo deve ser aplicado 
				-- primeiro, pois se o protocolo não atender ao cadastro do filtro então nem busca as contas do mesmo, assim para as contas, os itens, 
				-- pariticipantes e assim por diante. 
				 
				-- filtro de Protocolo 
				if (dados_filtro_w.ie_filtro_protocolo = 'S' and (qt_registro_w = -1 or qt_registro_w > 0)) then 
				 
					qt_registro_w := pls_tipos_ocor_pck.obter_qtde_reg_valido_filtro(nr_id_transacao_p, dados_filtro_w, 'S', ie_restringe_filtro_w);
					 
					CALL pls_oc_cta_aplicar_fil_prot(	 
							dados_regra_p, dados_filtro_w, dados_consistencia_p, dados_forma_geracao_ocor_p, 
							ie_incidencia_regra_w, nr_id_transacao_p, cd_estabelecimento_p, nm_usuario_p, qt_registro_w);
					commit;
					qt_registro_w := pls_tipos_ocor_pck.obter_qtde_reg_valido_filtro(nr_id_transacao_p, dados_filtro_w, 'S', ie_restringe_filtro_w);
				end if;
				 
				-- filtro de conta 
				if (dados_filtro_w.ie_filtro_conta = 'S' and (qt_registro_w = -1 or qt_registro_w > 0)) then 
				 
					qt_registro_w := pls_tipos_ocor_pck.obter_qtde_reg_valido_filtro(nr_id_transacao_p, dados_filtro_w, 'S', ie_restringe_filtro_w);
					 
					CALL pls_oc_cta_aplicar_fil_conta(	 
							dados_regra_p, dados_filtro_w, dados_consistencia_p, dados_forma_geracao_ocor_p, 
							ie_incidencia_regra_w, nr_id_transacao_p, cd_estabelecimento_p, nm_usuario_p, qt_registro_w);
					commit;
					qt_registro_w := pls_tipos_ocor_pck.obter_qtde_reg_valido_filtro(nr_id_transacao_p, dados_filtro_w, 'S', ie_restringe_filtro_w);
				end if;
				 
				-- Prestador 
				if (dados_filtro_w.ie_filtro_prest = 'S' and (qt_registro_w = -1 or qt_registro_w > 0)) then 
				 
					qt_registro_w := pls_tipos_ocor_pck.obter_qtde_reg_valido_filtro(nr_id_transacao_p, dados_filtro_w, 'S', ie_restringe_filtro_w);
					 
					CALL pls_oc_cta_aplicar_fil_pres(		 
							dados_regra_p, dados_filtro_w, dados_consistencia_p, dados_forma_geracao_ocor_p, 
							ie_incidencia_regra_w, nr_id_transacao_p, cd_estabelecimento_p, nm_usuario_p, qt_registro_w);
					commit;
					qt_registro_w := pls_tipos_ocor_pck.obter_qtde_reg_valido_filtro(nr_id_transacao_p, dados_filtro_w, 'S', ie_restringe_filtro_w);
				end if;
				 
				-- Profissional 
				if (dados_filtro_w.ie_filtro_prof = 'S' and (qt_registro_w = -1 or qt_registro_w > 0)) then 
				 
					qt_registro_w := pls_tipos_ocor_pck.obter_qtde_reg_valido_filtro(nr_id_transacao_p, dados_filtro_w, 'S', ie_restringe_filtro_w);
					 
					CALL pls_oc_cta_aplicar_fil_prof(		 
							dados_regra_p, dados_filtro_w, dados_consistencia_p, dados_forma_geracao_ocor_p, 
							ie_incidencia_regra_w, nr_id_transacao_p, cd_estabelecimento_p, nm_usuario_p, qt_registro_w);
					commit;
					qt_registro_w := pls_tipos_ocor_pck.obter_qtde_reg_valido_filtro(nr_id_transacao_p, dados_filtro_w, 'S', ie_restringe_filtro_w);
				end if;
				 
				-- contrato 
				if (dados_filtro_w.ie_filtro_contrato = 'S' and (qt_registro_w = -1 or qt_registro_w > 0)) then 
				 
					qt_registro_w := pls_tipos_ocor_pck.obter_qtde_reg_valido_filtro(nr_id_transacao_p, dados_filtro_w, 'S', ie_restringe_filtro_w);
					 
					CALL pls_oc_cta_aplicar_fil_contr(	 
							dados_regra_p, dados_filtro_w, dados_consistencia_p, dados_forma_geracao_ocor_p, 
							ie_incidencia_regra_w, nr_id_transacao_p, cd_estabelecimento_p, nm_usuario_p, qt_registro_w);
					commit;
					qt_registro_w := pls_tipos_ocor_pck.obter_qtde_reg_valido_filtro(nr_id_transacao_p, dados_filtro_w, 'S', ie_restringe_filtro_w);
				end if;
				 
				-- produto 
				if (dados_filtro_w.ie_filtro_produto = 'S' and (qt_registro_w = -1 or qt_registro_w > 0)) then 
				 
					qt_registro_w := pls_tipos_ocor_pck.obter_qtde_reg_valido_filtro(nr_id_transacao_p, dados_filtro_w, 'S', ie_restringe_filtro_w);
					 
					CALL pls_oc_cta_aplicar_fil_prod(	 
							dados_regra_p, dados_filtro_w, dados_consistencia_p, dados_forma_geracao_ocor_p, 
							ie_incidencia_regra_w, nr_id_transacao_p, cd_estabelecimento_p, nm_usuario_p, qt_registro_w);
					commit;
					qt_registro_w := pls_tipos_ocor_pck.obter_qtde_reg_valido_filtro(nr_id_transacao_p, dados_filtro_w, 'S', ie_restringe_filtro_w);
				end if;
				 
				-- Intercâmbio 
				if (dados_filtro_w.ie_filtro_interc = 'S' and (qt_registro_w = -1 or qt_registro_w > 0)) then 
				 
					qt_registro_w := pls_tipos_ocor_pck.obter_qtde_reg_valido_filtro(nr_id_transacao_p, dados_filtro_w, 'S', ie_restringe_filtro_w);
					 
					CALL pls_oc_cta_aplicar_fil_inter(		 
							dados_regra_p, dados_filtro_w, dados_consistencia_p, dados_forma_geracao_ocor_p, 
							ie_incidencia_regra_w, nr_id_transacao_p, cd_estabelecimento_p, nm_usuario_p, qt_registro_w);
					commit;
					qt_registro_w := pls_tipos_ocor_pck.obter_qtde_reg_valido_filtro(nr_id_transacao_p, dados_filtro_w, 'S', ie_restringe_filtro_w);
				end if;
 
				-- beneficiário 
				if (dados_filtro_w.ie_filtro_benef = 'S' and (qt_registro_w = -1 or qt_registro_w > 0)) then 
				 
					qt_registro_w := pls_tipos_ocor_pck.obter_qtde_reg_valido_filtro(nr_id_transacao_p, dados_filtro_w, 'S', ie_restringe_filtro_w);
					 
					CALL pls_oc_cta_aplicar_fil_ben(	 
							dados_regra_p, dados_filtro_w, dados_consistencia_p, dados_forma_geracao_ocor_p, 
							ie_incidencia_regra_w, nr_id_transacao_p, cd_estabelecimento_p, nm_usuario_p, qt_registro_w);
					commit;				
					qt_registro_w := pls_tipos_ocor_pck.obter_qtde_reg_valido_filtro(nr_id_transacao_p, dados_filtro_w, 'S', ie_restringe_filtro_w);
				end if;
				 
				-- procedimento 
				if (dados_filtro_w.ie_filtro_proc = 'S' and (qt_registro_w = -1 or qt_registro_w > 0)) then 
				 
					qt_registro_w := pls_tipos_ocor_pck.obter_qtde_reg_valido_filtro(nr_id_transacao_p, dados_filtro_w, 'S', ie_restringe_filtro_w);
					 
					CALL pls_oc_cta_aplicar_fil_proc(	 
							dados_regra_p, dados_filtro_w, dados_consistencia_p, dados_forma_geracao_ocor_p, 
							ie_incidencia_regra_w, nr_id_transacao_p, cd_estabelecimento_p, nm_usuario_p, qt_registro_w);
					commit;
					qt_registro_w := pls_tipos_ocor_pck.obter_qtde_reg_valido_filtro(nr_id_transacao_p, dados_filtro_w, 'S', ie_restringe_filtro_w);
				end if;
 
				-- material 
				if (dados_filtro_w.ie_filtro_mat = 'S' and (qt_registro_w = -1 or qt_registro_w > 0)) then 
				 
					qt_registro_w := pls_tipos_ocor_pck.obter_qtde_reg_valido_filtro(nr_id_transacao_p, dados_filtro_w, 'S', ie_restringe_filtro_w);
					 
					CALL pls_oc_cta_aplicar_fil_mat(	 
							dados_regra_p, dados_filtro_w, dados_consistencia_p, dados_forma_geracao_ocor_p, 
							ie_incidencia_regra_w, nr_id_transacao_p, cd_estabelecimento_p, nm_usuario_p, qt_registro_w);
					commit;			
					qt_registro_w := pls_tipos_ocor_pck.obter_qtde_reg_valido_filtro(nr_id_transacao_p, dados_filtro_w, 'S', ie_restringe_filtro_w);
				end if;
				 
				-- Assim como começa também termina quando for filtro de exceção. Ao terminar o processo é definido se o registro continua 
				-- ou não válido para a regra. Se for exceção não é mais válido. 
				if (dados_regra_p.ie_excecao = 'N') then 
					 
					if (dados_filtro_w.ie_excecao = 'S') then 
					 
						CALL pls_tipos_ocor_pck.atualiza_sel_excecao_end(nr_id_transacao_p);
					end if;
				-- Mesmo acontece para a exceção da regra de exceção, porém é definido se o registro é ou não exceção e gravado no campo IE_EXCECAO como N onde o 
				-- campo IE_EXCECAO_EXCECAO for N. 
				elsif (dados_regra_p.ie_excecao = 'S') then 
					 
					if (dados_filtro_w.ie_excecao = 'S') then 
					 
						CALL pls_tipos_ocor_pck.atualiza_sel_exc_exc_end(nr_id_transacao_p);
					end if;
				end if;
			end if;
			 
			qt_filtro_processado_w := qt_filtro_processado_w + 1;
		end loop; -- loop combinações 
		
		qt_registro_w := pls_tipos_ocor_pck.obter_qtde_reg_valido_filtro(nr_id_transacao_p, dados_filtro_w, 'S', 'N');
	end if;
end if;
 
qt_registro_p	:= qt_registro_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_cta_aplicar_filtros ( dados_consistencia_p pls_tipos_ocor_pck.dados_consistencia, dados_regra_p pls_tipos_ocor_pck.dados_regra, dados_forma_geracao_ocor_p pls_tipos_ocor_pck.dados_forma_geracao_ocor, nr_id_transacao_p pls_selecao_ocor_cta.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, qt_registro_p INOUT integer) FROM PUBLIC;
