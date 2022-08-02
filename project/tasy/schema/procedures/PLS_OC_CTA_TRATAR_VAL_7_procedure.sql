-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_cta_tratar_val_7 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  Aplicar a validação de item que foi autorizado porém não foi utilizado na conta médica
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:

Alterações:
 ------------------------------------------------------------------------------------------------------------------
jjung OS 602057 - 18/06/2013

 Alteração:	Retirado o campo dados_filtro_w.ieececao e substituido pelo ie_gera_ocorrencia.

 Motivo:	Foi identificado que a lógica do campo ie_excecao era muito confusa e poderia
	trazer problemas.
 ------------------------------------------------------------------------------------------------------------------
 jjung 29/06/2013

Alteração:	Adicionado parametro nos métodos de atualização dos campos IE_VALIDO e IE_VALIDO_TEMP
	da PLS_TIPOS_OCOR_PCK

Motivo:	Se tornou necessário diferenciar os filtros das validações na hora de realizar esta operação
	para que os filtros de exceção funcionem corretamente.
------------------------------------------------------------------------------------------------------------------
jjung OS 602086 03/07/2013

Alteração:	Alterado select dinâmico para acessar a  view da tabela de seleção ao invés de filtrar
	a view da conta  com os registros que estão na tabela de seleção.

------------------------------------------------------------------------------------------------------------------
jjung 29/08/2013 -

Alteração:	Incluído o tratamento do begin/exception na execução do select dinâmico.

Motivo:	Foi identificado que não era possível identificar o problema quando ocorriam na execução
	do select desta procedure.
------------------------------------------------------------------------------------------------------------------
jjung 31/01/2014 -

Alteração:	Organização do fonte.
------------------------------------------------------------------------------------------------------------------
dlehmkuhl OS 688483 - 14/04/2014 -

Alteração:	Modificada a forma de trabalho em relação a atualização dos campos de controle
	que basicamente decidem se a ocorrência será ou não gerada. Foi feita também a
	substituição da rotina obter_se_gera.

Motivo:	Necessário realizar essas alterações para corrigir bugs principalmente no que se
	refere a questão de aplicação de filtros (passo anterior ao da validação). Também
	tivemos um foco especial em performance, visto que a mesma precisou ser melhorada
	para não inviabilizar a nova solicitação que diz que a exceção deve verificar todo
	o atendimento.
------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_registro_valido_w	pls_oc_cta_selecao_ocor_v.ie_valido%type;
nr_seq_selecao_w	dbms_sql.number_table;
ds_observacao_w		dbms_sql.varchar2_table;
ie_valido_w		dbms_sql.varchar2_table;
qt_iteracoes_w		integer;

-- Este select busca os itens das contas que estão na seleção e foram autorizados porém não foram utilizados.
-- Estes procedimentos podem ser obtidos na pls_item_aut_nao_util_v, o retorno desta view está sendo colocado em uma function que agrupa as linhas e retorna os resultados
-- em uma mesma linha, utilizando um separador que for passado no segundo parâmetro.
C01 CURSOR(	nr_id_transacao_pc pls_oc_cta_selecao_ocor_v.nr_id_transacao%type,
		ie_registro_valido_pc	text) FOR
	SELECT	x.nr_sequencia nr_seq_selecao,
		ie_registro_valido_pc ie_valido,
		('Os seguintes itens foram autorizados mas não foram utilizados: ' || pls_tipos_ocor_pck.enter_w ||
			x.ds_itens) ds_observacao
	from (
		SELECT	sel.nr_sequencia,
			pls_admin_cursor.obter_desc_cursor(cursor(select	itens.ds_tipo || ': ' || itens.ds_item
								  from		pls_item_aut_nao_util_v itens
								  where		itens.nr_seq_conta = sel.nr_seq_conta
								  order by	itens.ds_tipo), chr(13) || chr(10) ) ds_itens
		from	pls_oc_cta_selecao_ocor_v sel
		where	sel.nr_id_transacao = nr_id_transacao_pc
		and	sel.ie_valido = 'S') x
	where 	(x.ds_itens IS NOT NULL AND x.ds_itens::text <> '');

-- Informações da validação de não-utilização de item autorizado
C02 CURSOR(	nr_seq_oc_cta_comb_p	dados_regra_p.nr_sequencia%type) FOR
SELECT	a.nr_sequencia	nr_seq_validacao,
		a.ie_aut_utilizacao,
		coalesce(a.ie_valida_aut_periodo,'N') ie_valida_aut_periodo
from	pls_oc_cta_val_util_autor a
where	a.nr_seq_oc_cta_comb	= nr_seq_oc_cta_comb_p;

--Levanta contas que não tem autorização encontrada
C03 CURSOR(	nr_id_transacao_pc pls_oc_cta_selecao_ocor_v.nr_id_transacao%type,
				ie_registro_valido_pc	text) FOR
	SELECT	sel.nr_sequencia nr_seq_selecao,
			ie_registro_valido_pc ie_valido,
			cta.nr_seq_segurado,
			cta.nr_sequencia nr_seq_conta,
			cta.dt_atendimento_referencia dt_atendimento
	from 	pls_oc_cta_selecao_ocor_v sel,
			pls_conta cta
	where	sel.nr_id_transacao = nr_id_transacao_pc
	and		sel.nr_seq_conta = cta.nr_sequencia
	 and (  SELECT   count(1)
            from   pls_item_autor_v
            where   nr_seq_conta = cta.nr_sequencia) = 0;

--Encontra	 guias compatíveis com a conta, considerando mesmo beneficiário e período de 30 dias anterior a data de atendimento_referência da conta
--que não estejam vinculadas a nenhuma conta até o momento.
C04 CURSOR(	nr_seq_conta_pc		pls_conta.nr_sequencia%type,
				nr_seq_segurado_pc	pls_segurado.nr_sequencia%type,
				dt_referencia_pc	pls_conta.dt_atendimento_referencia%type
				) FOR
	SELECT 	nr_sequencia
	from   	pls_guia_plano a
	where  	dt_autorizacao between dt_referencia_pc - 30 and dt_referencia_pc
	and    	nr_seq_segurado = nr_seq_segurado_pc
	and (	SELECT count(1) from pls_conta where nr_seq_guia = a.nr_sequencia)	= 0
	and    	exists (select cd_procedimento,
							  ie_origem_proced
						from   pls_conta_proc x
						where  x.nr_seq_conta = nr_seq_conta_pc
						intersect
						select cd_procedimento,
							   ie_origem_Proced
						from   pls_guia_plano_proc
						where  nr_seq_guia = a.nr_sequencia
						)
	
union

	select nr_sequencia
	from   pls_guia_plano a
	where  dt_autorizacao between dt_referencia_pc - 30 and dt_referencia_pc
	and    nr_seq_segurado = nr_seq_segurado_pc
	and (	select count(1) from pls_conta where cd_guia_ok = a.cd_guia)	= 0
	and    exists (select         nr_seq_material
						from   pls_conta_mat x
						where  x.nr_seq_conta = nr_seq_conta_pc
						intersect
						select nr_seq_material
						from   pls_guia_plano_mat
						where  nr_seq_guia = a.nr_sequencia
						);
BEGIN

-- Deve ter a informação da regra para que seja aplicada a validação.
if (dados_regra_p.nr_sequencia IS NOT NULL AND dados_regra_p.nr_sequencia::text <> '') then

	for	r_C02_w in C02( dados_regra_p.nr_sequencia) loop

		-- Somente aplicar a validação se a regra disse que é para aplicar a validação
		if (r_C02_w.ie_aut_utilizacao = 'S') then

			ie_registro_valido_w := 'S';

			-- tratamento em campo auxiliar para identificar posteriormente os registros que foram alterados
			CALL pls_tipos_ocor_pck.atualiza_campo_auxiliar('V', nr_id_transacao_p, null, dados_regra_p);

			begin
				-- Abertura do cursor e execução do comando.
				open C01(nr_id_transacao_p, ie_registro_valido_w );
				loop
					-- Limapr registro antigos.
					nr_seq_selecao_w	:= pls_util_cta_pck.num_table_vazia_w;
					ie_valido_w		:= pls_util_cta_pck.vchr2_table_vazia_w;
					ds_observacao_w		:= pls_util_cta_pck.vchr2_table_vazia_w;

					-- Gravar novas linhas
					fetch C01 bulk collect into  nr_seq_selecao_w, ie_valido_w, ds_observacao_w
					limit pls_util_cta_pck.qt_registro_transacao_w;

					-- Se terminou aborta
					exit when nr_seq_selecao_w.count = 0;

					-- Processa as linhas.
					CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(
						nr_seq_selecao_w, pls_util_cta_pck.clob_table_vazia_w, 'SEQ',
						ds_observacao_w, ie_valido_w, nm_usuario_p);

					commit;

				end loop;
				close C01;
			exception
			when others then
				--Fecha cursor
				if (C01%isopen) then

					close C01;
				end if;

				-- Insere o log na tabela e aborta a operação
				CALL pls_tipos_ocor_pck.trata_erro_sql_dinamico(dados_regra_p,null,nr_id_transacao_p,nm_usuario_p);
			end;

			-- seta os registros que serão válidos ou inválidos após o processamento
			--pls_tipos_ocor_pck.atualiza_campo_valido ('V', nr_id_transacao_p, null, dados_regra_p);
		end if;

		if (r_C02_w.ie_valida_aut_periodo = 'S') then
			ie_registro_valido_w := 'S';

			-- tratamento em campo auxiliar para identificar posteriormente os registros que foram alterados
			--pls_tipos_ocor_pck.atualiza_campo_auxiliar ('V', nr_id_transacao_p, null, dados_regra_p);
			-- Limapr registro antigos.
			nr_seq_selecao_w	:= pls_util_cta_pck.num_table_vazia_w;
			ie_valido_w			:= pls_util_cta_pck.vchr2_table_vazia_w;
			ds_observacao_w		:= pls_util_cta_pck.vchr2_table_vazia_w;
			qt_iteracoes_w		:= 0;

			--Primeiramente levanta contas que não tenha encontrado autorização encontrada. Se encontrar autorização, então não cairá nessa validação
			for r_c03_w in C03(nr_id_transacao_p, ie_registro_valido_w ) loop

				null;

				--Localiza guias equivalentes a conta que está sendo processada, considerando nr_seq_segurado e período de autorização até 30 dias anterior a atendimento(dt_atendimento_referencia), onde essas guias
				--não estejam vinculadas a nenhuma conta até o momento.
				for r_c04_w in C04( r_c03_w.nr_seq_conta ,r_c03_w.nr_seq_segurado ,r_c03_w.dt_atendimento) loop

					nr_seq_selecao_w(qt_iteracoes_w) := r_c03_w.nr_seq_selecao;
					ie_valido_w(qt_iteracoes_w) := ie_registro_valido_w;
					ds_observacao_w(qt_iteracoes_w) := 'Encontrada guia autorizada e não utilizada, onde a mesma é compatível com a conta. Guia:'||r_c04_w.nr_sequencia;

					if (qt_iteracoes_w > pls_util_cta_pck.qt_registro_transacao_w) then

						-- Processa as linhas.
						CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(
								nr_seq_selecao_w, pls_util_cta_pck.clob_table_vazia_w, 'SEQ',
								ds_observacao_w, ie_valido_w, nm_usuario_p);

						nr_seq_selecao_w	:= pls_util_cta_pck.num_table_vazia_w;
						ie_valido_w			:= pls_util_cta_pck.vchr2_table_vazia_w;
						ds_observacao_w		:= pls_util_cta_pck.vchr2_table_vazia_w;
						qt_iteracoes_w		:= 0;
					else
						qt_iteracoes_w := qt_iteracoes_w + 1;

					end if;
				end loop;
			end loop;

			-- Processa as linhas que ainda não foram processadas.
			CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(
					nr_seq_selecao_w, pls_util_cta_pck.clob_table_vazia_w, 'SEQ',
					ds_observacao_w, ie_valido_w, nm_usuario_p);

			nr_seq_selecao_w	:= pls_util_cta_pck.num_table_vazia_w;
			ie_valido_w			:= pls_util_cta_pck.vchr2_table_vazia_w;
			ds_observacao_w		:= pls_util_cta_pck.vchr2_table_vazia_w;
			qt_iteracoes_w		:= 0;

			-- seta os registros que serão válidos ou inválidos após o processamento
			CALL pls_tipos_ocor_pck.atualiza_campo_valido('V', nr_id_transacao_p, null, dados_regra_p);
		end if;

	end loop; -- C02
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_cta_tratar_val_7 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

