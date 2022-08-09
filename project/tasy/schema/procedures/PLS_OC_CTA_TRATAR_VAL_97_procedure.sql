-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_cta_tratar_val_97 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  Aplicar a comparação entre prestadores. A combinação pode ser entre os prestadores do protocolo,
conta ou procedimento, Para cada  combinação, pode-se selecionar o tipo do prestador a ser comparado.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [ ] Portal [ ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
nr_cont_w    integer;
dados_tb_sel_w    pls_tipos_ocor_pck.dados_table_selecao_ocor;
ie_gera_ocorrencia_w  varchar(1);
qt_registro_w    integer;
nr_seq_prest_w    numeric(20);
nr_seq_prest_comp_w  pls_prestador.nr_sequencia%type;
cd_prestador_w    pls_prestador.cd_prestador%type;
cd_prestador_comp_w  pls_prestador.cd_prestador%type;

-- Informações sobre a Regra
c01 CURSOR(  nr_seq_oc_cta_comb_pc  dados_regra_p.nr_sequencia%type) FOR
  SELECT  ie_valida_prest_info,
    ie_valida_prest_info_comp,
    ie_tipo_prestador,
    ie_tipo_prestador_comp,
    ie_comparacao,
    ie_campo
  from  pls_oc_cta_val_prest_dif
  where  nr_seq_oc_cta_comb = nr_seq_oc_cta_comb_pc;

-- Carrega os dados do prestador
c02 CURSOR(  nr_id_transacao_pc  pls_oc_cta_selecao_ocor_v.nr_id_transacao%type) FOR
  SELECT  a.nr_sequencia nr_seq_selecao,
    c.nr_sequencia nr_seq_protocolo,
    b.nr_seq_prestador_imp_ref nr_seq_prestador_imp,
    pls_obter_cod_prestador(b.nr_seq_prestador_imp_ref, null) cd_prestador_imp,
    b.nr_seq_prestador_exec_imp_ref nr_seq_prestador_exec_imp,
    pls_obter_cod_prestador(b.nr_seq_prestador_exec_imp_ref, null) cd_prestador_exec_imp,
    b.nr_seq_prestador,
    pls_obter_cod_prestador(b.nr_seq_prestador, null) cd_prestador,
    b.nr_seq_prestador_exec,
    pls_obter_cod_prestador(b.nr_seq_prestador_exec, null) cd_prestador_exec,
    c.nr_seq_prestador_imp_ref nr_seq_prest_imp_prot,
    pls_obter_cod_prestador(c.nr_seq_prestador_imp_ref, null) cd_prest_imp_prot,
    c.nr_seq_prestador nr_seq_prest_prot,
    pls_obter_cod_prestador(c.nr_seq_prestador, null) cd_prestador_prot,
    b.nr_seq_prestador_solic_ref,
    pls_obter_cod_prestador(b.nr_seq_prestador_solic_ref, null) cd_prest_solic_ref,
    b.nr_seq_guia,
    b.nr_sequencia nr_seq_conta
  from  pls_oc_cta_selecao_ocor_v a,
    pls_conta b,
    pls_protocolo_conta c
  where  a.nr_id_transacao = nr_id_transacao_pc
  and  a.ie_valido = 'S'
  and  b.nr_sequencia = a.nr_seq_conta
  and  c.nr_sequencia = b.nr_seq_protocolo
  and  b.ie_status  != 'C';
BEGIN

if (dados_regra_p.nr_sequencia IS NOT NULL AND dados_regra_p.nr_sequencia::text <> '') then
	nr_cont_w := 0;
	-- tratamento em campo auxiliar para identificar posteriormente os registros que foram alterados
	CALL pls_tipos_ocor_pck.atualiza_campo_auxiliar('V', nr_id_transacao_p, null, dados_regra_p);
	pls_tipos_ocor_pck.limpar_nested_tables(dados_tb_sel_w);

	-- Carrega as regras
	for r_c01_w in c01(dados_regra_p.nr_sequencia) loop

		-- Só executa a regra se ela não for de tipos de prestadores iguais
		if (r_c01_w.ie_tipo_prestador <> r_c01_w.ie_tipo_prestador_comp) then

			-- abre o cursor com os prestadores a serem comparados
			for 	r_c02_w in c02(nr_id_transacao_p) loop

				-- inicia como não gera ocorrência
				ie_gera_ocorrencia_w := 'N';
				dados_tb_sel_w.ds_observacao(nr_cont_w) := null;

				-- define qual é o prestador que precisa verificar
				case(r_c01_w.ie_tipo_prestador)
					-- atendimento
					when 'A' then
						if (dados_regra_p.ie_evento = 'IMP') then
							nr_seq_prest_w := r_c02_w.nr_seq_prest_imp_prot;
							cd_prestador_w := r_c02_w.cd_prest_imp_prot;
						else
							nr_seq_prest_w := r_c02_w.nr_seq_prest_prot;
							cd_prestador_w := r_c02_w.cd_prestador_prot;
						end if;
					-- solicitante
					when 'S' then
						if (dados_regra_p.ie_evento = 'IMP') then
							nr_seq_prest_w := r_c02_w.nr_seq_prestador_imp;
							cd_prestador_w := r_c02_w.cd_prestador_imp;
						else
							nr_seq_prest_w := r_c02_w.nr_seq_prestador;
							cd_prestador_w := r_c02_w.cd_prestador;
						end if;
					-- executor
					when 'E' then
						if (dados_regra_p.ie_evento = 'IMP') then
							nr_seq_prest_w := r_c02_w.nr_seq_prestador_exec_imp;
							cd_prestador_w := r_c02_w.cd_prestador_exec_imp;
						else
							nr_seq_prest_w := r_c02_w.nr_seq_prestador_exec;
							cd_prestador_w := r_c02_w.cd_prestador_exec;
						end if;
					else
						nr_seq_prest_w := null;
						cd_prestador_w := null;
				end case;

				-- define qual prestador de comparação
				case(r_c01_w.ie_tipo_prestador_comp)
					-- atendimento
					when 'A' then
						if (dados_regra_p.ie_evento = 'IMP') then
							nr_seq_prest_comp_w := r_c02_w.nr_seq_prest_imp_prot;
							cd_prestador_comp_w := r_c02_w.cd_prest_imp_prot;
						else
							nr_seq_prest_comp_w := r_c02_w.nr_seq_prest_prot;
							cd_prestador_comp_w := r_c02_w.cd_prestador_prot;
						end if;
					-- solicitante
					when 'S' then
						if (dados_regra_p.ie_evento = 'IMP') then
							nr_seq_prest_comp_w := r_c02_w.nr_seq_prestador_imp;
							cd_prestador_comp_w := r_c02_w.cd_prestador_imp;
						else
							nr_seq_prest_comp_w := r_c02_w.nr_seq_prestador;
							cd_prestador_comp_w := r_c02_w.cd_prestador;
						end if;
					-- executor
					when 'E' then
						if (dados_regra_p.ie_evento = 'IMP') then
							nr_seq_prest_comp_w := r_c02_w.nr_seq_prestador_exec_imp;
							cd_prestador_comp_w := r_c02_w.cd_prestador_exec_imp;
						else
							nr_seq_prest_comp_w := r_c02_w.nr_seq_prestador_exec;
							cd_prestador_comp_w := r_c02_w.cd_prestador_exec;
						end if;
					-- Requisitante
					when 'R' then
						nr_seq_prest_comp_w := r_c02_w.nr_seq_prestador_solic_ref;
						cd_prestador_comp_w := r_c02_w.cd_prest_solic_ref;
					when 'G' then

						select  max(nr_seq_prestador)
						into STRICT  	nr_seq_prest_comp_w
						from 	pls_guia_plano
						where  	nr_sequencia  = r_c02_w.nr_seq_guia;

						cd_prestador_comp_w := pls_obter_cod_prestador(nr_seq_prest_comp_w, null);

					else
						nr_seq_prest_comp_w := null;
						cd_prestador_comp_w := null;
				end case;

				-- se obriga o prestador, e o mesmo não está informado...
				if (r_c01_w.ie_valida_prest_info = 'S') and (coalesce(nr_seq_prest_w::text, '') = '') then
					ie_gera_ocorrencia_w := 'S';
				end if;

				-- caso seja para validar o participante a validação é feita de uma outra forma
				if (r_c01_w.ie_tipo_prestador_comp = 'P') and (ie_gera_ocorrencia_w = 'N') then

					-- se for para verificar a igualdade
					if (r_c01_w.ie_comparacao = 'I') then

					-- verifica se existe algum participante diferente do prestador que precisa ser verificado
						select  sum(qt)
						into STRICT  qt_registro_w
						from (
							-- aqui retorna os que devem verificar a sequência
							SELECT  count(1) qt
							FROM pls_protocolo_conta e, pls_conta b, pls_selecao_ocor_cta a, pls_conta_proc c
LEFT OUTER JOIN pls_proc_participante d ON (c.nr_sequencia = d.nr_seq_conta_proc)
WHERE r_c01_w.ie_campo = 'S' and a.nr_id_transacao = nr_id_transacao_p and a.ie_valido = 'S' and b.nr_sequencia = a.nr_seq_conta and c.nr_seq_conta = b.nr_sequencia and c.ie_status not in ('D','M')  and e.nr_sequencia = b.nr_seq_protocolo and e.nr_sequencia = r_c02_w.nr_seq_protocolo and d.nr_seq_prestador = nr_seq_prest_w
							
union all

							-- aqui retorna caso tenha que validar nulos
							SELECT  count(1) qt
							FROM pls_protocolo_conta e, pls_conta b, pls_selecao_ocor_cta a, pls_conta_proc c
LEFT OUTER JOIN pls_proc_participante d ON (c.nr_sequencia = d.nr_seq_conta_proc)
WHERE a.nr_id_transacao = nr_id_transacao_p and a.ie_valido = 'S' and b.nr_sequencia = a.nr_seq_conta and c.nr_seq_conta = b.nr_sequencia and c.ie_status not in ('D','M')  and e.nr_sequencia = b.nr_seq_protocolo and e.nr_sequencia = r_c02_w.nr_seq_protocolo and coalesce(d.nr_seq_prestador::text, '') = '' and r_c01_w.ie_valida_prest_info_comp = 'S'
							 
union all

							-- aqui retorna quando deve validar o código do prestador
							select  count(1) qt
							FROM pls_prestador f, pls_protocolo_conta e, pls_conta b, pls_selecao_ocor_cta a, pls_conta_proc c
LEFT OUTER JOIN pls_proc_participante d ON (c.nr_sequencia = d.nr_seq_conta_proc)
WHERE r_c01_w.ie_campo = 'C' and a.nr_id_transacao = nr_id_transacao_p and a.ie_valido = 'S' and b.nr_sequencia = a.nr_seq_conta and c.ie_status not in ('D','M') and c.nr_seq_conta = b.nr_sequencia  and e.nr_sequencia = b.nr_seq_protocolo and e.nr_sequencia = r_c02_w.nr_seq_protocolo and f.nr_sequencia = d.nr_seq_prestador and f.cd_prestador = cd_prestador_w
							 ) alias11;
					else
						-- verifica se existe algum participante diferente do prestador que precisa ser verificado
						select  sum(qt)
						into STRICT  	qt_registro_w
						from (
							-- aqui retorna os que devem verificar a sequência
							SELECT  count(1) qt
							FROM pls_protocolo_conta e, pls_conta b, pls_selecao_ocor_cta a, pls_conta_proc c
LEFT OUTER JOIN pls_proc_participante d ON (c.nr_sequencia = d.nr_seq_conta_proc)
WHERE r_c01_w.ie_campo = 'S' and a.nr_id_transacao = nr_id_transacao_p and a.ie_valido = 'S' and b.nr_sequencia = a.nr_seq_conta and c.nr_seq_conta = b.nr_sequencia and c.ie_status not in ('D','M')  and e.nr_sequencia = b.nr_seq_protocolo and e.nr_sequencia = r_c02_w.nr_seq_protocolo and d.nr_seq_prestador != nr_seq_prest_w
							
union all

							-- aqui retorna caso tenha que validar nulos
							SELECT  count(1) qt
							FROM pls_protocolo_conta e, pls_conta b, pls_selecao_ocor_cta a, pls_conta_proc c
LEFT OUTER JOIN pls_proc_participante d ON (c.nr_sequencia = d.nr_seq_conta_proc)
WHERE a.nr_id_transacao = nr_id_transacao_p and a.ie_valido = 'S' and b.nr_sequencia = a.nr_seq_conta and c.nr_seq_conta = b.nr_sequencia and c.ie_status not in ('D','M')  and e.nr_sequencia = b.nr_seq_protocolo and e.nr_sequencia = r_c02_w.nr_seq_protocolo and coalesce(d.nr_seq_prestador::text, '') = '' and r_c01_w.ie_valida_prest_info_comp = 'S'
							 
union all

							-- aqui retorna quando deve validar o código do prestador
							select  count(1) qt
							FROM pls_prestador f, pls_protocolo_conta e, pls_conta b, pls_selecao_ocor_cta a, pls_conta_proc c
LEFT OUTER JOIN pls_proc_participante d ON (c.nr_sequencia = d.nr_seq_conta_proc)
WHERE r_c01_w.ie_campo = 'C' and a.nr_id_transacao = nr_id_transacao_p and a.ie_valido = 'S' and c.ie_status not in ('D','M') and b.nr_sequencia = a.nr_seq_conta and c.nr_seq_conta = b.nr_sequencia  and e.nr_sequencia = b.nr_seq_protocolo and e.nr_sequencia = r_c02_w.nr_seq_protocolo and f.nr_sequencia = d.nr_seq_prestador and f.cd_prestador != cd_prestador_w
							 ) alias8;
					end if;

					-- se encontrou, registra a ocorrencia
					if (qt_registro_w > 0) then
						ie_gera_ocorrencia_w := 'S';
					end if;

        -- Validação por prestador fornecedor
				elsif (r_c01_w.ie_tipo_prestador_comp = 'F') and (ie_gera_ocorrencia_w = 'N') then

					-- se for para verificar a igualdade
					if (r_c01_w.ie_comparacao = 'I') then
						select  sum(qt)
						into STRICT  	qt_registro_w
						from (
							-- aqui retorna os que devem verificar a sequência
							SELECT  count(1) qt
							from  	pls_selecao_ocor_cta a,
								pls_conta_mat_ocor_v c
							where   r_c01_w.ie_campo   	= 'S'
							and   	a.nr_id_transacao   	= nr_id_transacao_p
							and  	a.ie_valido     	= 'S'
							and  	c.nr_seq_conta     	= a.nr_seq_conta
							and  	c.nr_seq_conta   	= r_c02_w.nr_seq_conta
							and  	c.nr_seq_prest_fornec_mat   = nr_seq_prest_w
							
union all

							-- aqui retorna caso tenha que validar nulos
							SELECT  count(1) qt
							from  	pls_selecao_ocor_cta a,
								pls_conta_mat_ocor_v c
							where  	a.nr_id_transacao   	= nr_id_transacao_p
							and  	a.ie_valido     	= 'S'
							and  	c.nr_seq_conta     	= a.nr_seq_conta
							and  	c.nr_seq_conta   	= r_c02_w.nr_seq_conta
							and  	coalesce(c.nr_seq_prest_fornec_mat::text, '') = ''
							and  	r_c01_w.ie_valida_prest_info_comp = 'S'
							
union all

							-- aqui retorna quando deve validar o código do prestador
							select  count(1) qt
							from  	pls_selecao_ocor_cta    a,
								pls_conta_mat_ocor_v    c,
								pls_prestador     	e
							where  	r_c01_w.ie_campo   	= 'C'
							and  	a.nr_id_transacao   	= nr_id_transacao_p
							and  	a.ie_valido     	= 'S'
							and  	c.nr_seq_conta     	= a.nr_seq_conta
							and  	c.nr_seq_conta   	= r_c02_w.nr_seq_conta
							and  	e.nr_sequencia     	= c.nr_seq_prest_fornec_mat
							and	e.cd_prestador     	= cd_prestador_w
							) alias8;
					else
						select  sum(qt)
						into STRICT  qt_registro_w
						from (
							-- aqui retorna os que devem verificar a sequência
							SELECT  count(1) qt
							from  	pls_selecao_ocor_cta a,
								pls_conta_mat_ocor_v c
							where  	r_c01_w.ie_campo 	 = 'S'
							and  	a.nr_id_transacao 	 = nr_id_transacao_p
							and  	a.ie_valido 		 = 'S'
							and  	c.nr_seq_conta 		 = a.nr_seq_conta
							and  	c.nr_seq_protocolo 	  = r_c02_w.nr_seq_protocolo
							and  	c.nr_seq_prest_fornec_mat != nr_seq_prest_w
							
union all

							-- aqui retorna caso tenha que validar nulos
							SELECT  count(1) qt
							from  	pls_selecao_ocor_cta a,
								pls_conta_mat_ocor_v c
							where  	a.nr_id_transacao 	= nr_id_transacao_p
							and  	a.ie_valido 		= 'S'
							and  	c.nr_seq_conta 		= a.nr_seq_conta
							and  	c.nr_seq_protocolo 	= r_c02_w.nr_seq_protocolo
							and  	coalesce(c.nr_seq_prest_fornec_mat::text, '') = ''
							and  	r_c01_w.ie_valida_prest_info_comp = 'S'
							
union all

							-- aqui retorna quando deve validar o código do prestador
							select  count(1) qt
							from  	pls_selecao_ocor_cta   	a,
								pls_conta_mat_ocor_v  	m,
								pls_prestador    	e
							where  	r_c01_w.ie_campo   	= 'C'
							and  	a.nr_id_transacao   	= nr_id_transacao_p
							and  	a.nr_seq_conta    	= m.nr_seq_conta
							and  	a.ie_valido     	= 'S'
							and  	e.nr_sequencia     	= m.nr_seq_prest_fornec_mat
							and  	m.nr_seq_protocolo  	= r_c02_w.nr_seq_protocolo
							and  	e.cd_prestador     	!= cd_prestador_w
							) alias5;
					end if;

					-- se encontrou, registra a ocorrencia
					if (qt_registro_w > 0) then
						ie_gera_ocorrencia_w := 'S';
					end if;

				elsif (ie_gera_ocorrencia_w = 'N') then
					-- se obriga o prestador, e o mesmo não está informado... Prestador da comparação
					if (r_c01_w.ie_valida_prest_info_comp = 'S') and (coalesce(nr_seq_prest_comp_w::text, '') = '') then

						ie_gera_ocorrencia_w := 'S';
					end if;

					-- se for para validar a sequência
					if (r_c01_w.ie_campo = 'C') then

						-- se for para validar igualdade
						if (r_c01_w.ie_comparacao = 'I') then

							-- se os prestadores forem iguais gera a ocorrência
							-- caso não seja para verificar se o prestador está informado corretamente e algum deles for nulo,
							-- não deve gerar a ocorrência, para tratar os prestadores nulos deve ser marcado algum ou ambos os checkbox
							if (cd_prestador_comp_w = cd_prestador_w) then

							ie_gera_ocorrencia_w := 'S';
							end if;
						else
						-- se os prestadores forem diferentes gera a ocorrência
							if (cd_prestador_comp_w != cd_prestador_w) then
								ie_gera_ocorrencia_w := 'S';
							end if;
						end if;
					else
						-- se for para validar igualdade
						if (r_c01_w.ie_comparacao = 'I') then
							-- se os prestadores forem iguais gera a ocorrência
							-- caso não seja para verificar se o prestador está informado corretamente e algum deles for nulo,
							-- não deve gerar a ocorrência, para tratar os prestadores nulos deve ser marcado algum ou ambos os checkbox
							if (nr_seq_prest_comp_w = nr_seq_prest_w) then

								ie_gera_ocorrencia_w := 'S';
							end if;
						else
							-- se os prestadores forem diferentes gera a ocorrência
							if (nr_seq_prest_comp_w != nr_seq_prest_w) 	then
								ie_gera_ocorrencia_w := 'S';
							end if;
						end if;
					end if;
				end if;

				if (ie_gera_ocorrencia_w = 'S') then

					dados_tb_sel_w.ie_valido(nr_cont_w) := 'S';
					dados_tb_sel_w.nr_seq_selecao(nr_cont_w) := r_C02_w.nr_seq_selecao;

					dados_tb_sel_w.ds_observacao(nr_cont_w) := 'O prestador ' ||
						case   r_c01_w.ie_tipo_prestador
							when 'A' then 'do protocolo '
							when 'S' then 'solicitante '
							when 'E' then 'executor '
							when 'P' then 'participante '
						end
						|| '(' ||
						case 	r_c01_w.ie_campo
							when 'S' then 'seq. ' || nr_seq_prest_w
							when 'C' then 'cód. ' || cd_prestador_w
						end
						|| ') ' ||
						case 	r_c01_w.ie_comparacao
							when 'I' then 'é igual ao prestador '
							when 'D' then 'é diferente do prestador '
						end ||
						case   r_c01_w.ie_tipo_prestador_comp
							when 'A' then 'do protocolo '
							when 'S' then 'solicitante '
							when 'E' then 'executor '
							when 'P' then 'participante '
							when 'R' then 'requisitante '
							when 'F' then 'Fornecedor '
							when 'G' then 'da Guia'
						end
						|| '(' ||
						case r_c01_w.ie_campo
							  when 'S' then 'seq. ' || nr_seq_prest_comp_w
							  when 'C' then 'cód. ' || cd_prestador_comp_w
						end || ')';

					if (nr_cont_w >= pls_util_pck.qt_registro_transacao_w) then

						CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(  dados_tb_sel_w.nr_seq_selecao, pls_util_cta_pck.clob_table_vazia_w,
												'SEQ', dados_tb_sel_w.ds_observacao,
												dados_tb_sel_w.ie_valido, nm_usuario_p,
												nr_id_transacao_p);

						pls_tipos_ocor_pck.limpar_nested_tables(dados_tb_sel_w);

						nr_cont_w := 0;
					else
						nr_cont_w := nr_cont_w + 1;
					end if;
				end if;
			end loop; -- Prestadores a serem comparados por regra
			/*Lança as glosas caso existir registros que não foram gerados*/

			if (nr_cont_w > 0)  then
				CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(  dados_tb_sel_w.nr_seq_selecao, pls_util_cta_pck.clob_table_vazia_w,
									    'SEQ', dados_tb_sel_w.ds_observacao,
									    dados_tb_sel_w.ie_valido, nm_usuario_p,
									    nr_id_transacao_p);
			end if;
		end if; -- fim tipo prestador diferente
	end loop; -- regras
	-- seta os registros que serão válidos ou inválidos após o processamento
	CALL pls_tipos_ocor_pck.atualiza_campo_valido('V', nr_id_transacao_p, null, dados_regra_p);
end if;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_cta_tratar_val_97 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
