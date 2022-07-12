-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_grupos_pck.obter_procs_limitacao ( nr_seq_tipo_limitacao_p pls_tipo_limitacao.nr_sequencia%type) RETURNS SETOF T_PLS_LIMITACAO_PROC_DATA AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Retornar os procedimentos para cada uma das regras do tipo de limitação. Será retornado
	apenas procedimento, origem, tipo de guia, e cid para verificar as contas e ou procedimentos
	que foram executados em determinada característica.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:

Alterações:
------------------------------------------------------------------------------------------------------------------
jjung OS 596834 01/08/2013 -	Criação da function
------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
t_pls_limitacao_proc_row_w	pls_grupos_pck.t_pls_limitacao_proc_row;

-- Buscar as regras cadastradas para o tipo de limitação para que seja buscado os procedimentos que devem ser verificados para a regra.
C01 CURSOR(	nr_seq_tipo_limitacao_pc	pls_tipo_limitacao.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia,
		a.ie_tipo_guia,
		a.cd_doenca_cid,
		a.cd_area_procedimento,
		a.cd_especialidade,
		a.cd_grupo_proc,
		a.nr_seq_grupo_servico,
		a.cd_procedimento,
		a.ie_origem_proced,
		a.ie_limitacao
	from	pls_limitacao_proc	a
	where	a.nr_seq_tipo_limitacao	= nr_seq_tipo_limitacao_pc;

C02 CURSOR(	cd_procedimento_pc		procedimento.cd_procedimento%type,
		ie_origem_proced_pc		procedimento.ie_origem_proced%type,
		nr_seq_grupo_servico_pc		pls_preco_grupo_servico.nr_sequencia%type,
		cd_grupo_proc_pc		grupo_proc.cd_grupo_proc%type,
		cd_especialidade_pc		especialidade_proc.cd_especialidade%type,
		cd_area_pc			area_procedimento.cd_area_procedimento%type) FOR
	SELECT	a.cd_procedimento,
		a.ie_origem_proced
	from	table(pls_grupos_pck.obter_procs_estrutura(
					cd_procedimento_pc,
					ie_origem_proced_pc,
					nr_seq_grupo_servico_pc,
					cd_grupo_proc_pc,
					cd_especialidade_pc,
					cd_area_pc
					)) a;
BEGIN
-- Se não houver o tipo de limitação então não retorna nada.
if (nr_seq_tipo_limitacao_p IS NOT NULL AND nr_seq_tipo_limitacao_p::text <> '') then

	-- Obter as regras de procedimento cadastradas para este tipo de limitação.
	for	r_C01_w in C01(nr_seq_tipo_limitacao_p) loop

		--Limpar os dados da regra anterior.
		t_pls_limitacao_proc_row_w.cd_procedimento	:= null;
		t_pls_limitacao_proc_row_w.ie_origem_proced	:= null;
		t_pls_limitacao_proc_row_w.cd_doenca_cid	:= null;
		t_pls_limitacao_proc_row_w.ie_tipo_guia		:= null;
		t_pls_limitacao_proc_row_w.ie_liberado		:= null;

		-- Gravar se o procedimento está ou não liberado para a estrutura.
		if (r_C01_w.ie_limitacao IS NOT NULL AND r_C01_w.ie_limitacao::text <> '') then

			t_pls_limitacao_proc_row_w.ie_liberado	:= r_C01_w.ie_limitacao;
		end if;

		-- Verifica se tem tipo de guia informado. Se for informado então será gravado em todas as linhas que forem retornadas para esta regra.
		if (r_C01_w.ie_tipo_guia IS NOT NULL AND r_C01_w.ie_tipo_guia::text <> '') then

			t_pls_limitacao_proc_row_w.ie_tipo_guia := r_C01_w.ie_tipo_guia;
		end if;

		-- Verifica se tem o CID informado.  Se for informado então será gravado em todas as linhas que forem retornadas para esta regra.
		if (r_C01_w.cd_doenca_cid IS NOT NULL AND r_C01_w.cd_doenca_cid::text <> '') then

			t_pls_limitacao_proc_row_w.cd_doenca_cid := r_C01_w.cd_doenca_cid;
		end if;

		-- Se tiver uma estrutura de procedimento informada então corre atrás de todos os procedimentos da estrutra, se não
		-- já adiciona ao retorno as informações atuais e passa para a próxima regra.
		if ((r_C01_w.cd_procedimento IS NOT NULL AND r_C01_w.cd_procedimento::text <> '') or
			(r_C01_w.nr_seq_grupo_servico IS NOT NULL AND r_C01_w.nr_seq_grupo_servico::text <> '') or
			(r_C01_w.cd_grupo_proc IS NOT NULL AND r_C01_w.cd_grupo_proc::text <> '') or
			(r_C01_w.cd_especialidade IS NOT NULL AND r_C01_w.cd_especialidade::text <> '') or
			(r_C01_w.cd_area_procedimento IS NOT NULL AND r_C01_w.cd_area_procedimento::text <> '')) then

			-- Buscar os procedimentos conforme a estrutura cadastrada na regra. Sempre será gravado as informações de tipo de guia
			-- e cid junto com cada procedimento, pois a regra é uma combinação de informações da conta com a estrutura de procedimento.
			-- será verificado sempre do menor nível da estrutura para o maior e retornado os procedimentos que atenderem ao primeiro que não for nulo,
			-- portanto se for informado uma área e uma especialidade, então será retornado apenas os procedimentos que atendem a especialidade e a área será
			-- ignorada.
			for	r_C02_w in C02(r_C01_w.cd_procedimento, r_C01_w.ie_origem_proced,
						r_C01_w.nr_seq_grupo_servico, r_C01_w.cd_grupo_proc,
						r_C01_w.cd_especialidade, r_C01_w.cd_area_procedimento) loop

				t_pls_limitacao_proc_row_w.cd_procedimento	:= r_C02_w.cd_procedimento;
				t_pls_limitacao_proc_row_w.ie_origem_proced	:= r_C02_w.ie_origem_proced;
				RETURN NEXT t_pls_limitacao_proc_row_w;
			end loop; -- C02
		-- Se não tiver informação de procedimentos informada então já adiciona ao retorno as infromações de tipo de guia e CID se tiver.
		else
			RETURN NEXT t_pls_limitacao_proc_row_w;
		end if;
	end loop; -- C01
	-- Aqui retorna todas as linhas gravadas pelo pipe row
	return;
end if;

-- Não retorna nada.
return;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_grupos_pck.obter_procs_limitacao ( nr_seq_tipo_limitacao_p pls_tipo_limitacao.nr_sequencia%type) FROM PUBLIC;
