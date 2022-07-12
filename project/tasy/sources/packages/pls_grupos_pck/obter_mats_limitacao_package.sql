-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_grupos_pck.obter_mats_limitacao ( nr_seq_tipo_limitacao_p pls_tipo_limitacao.nr_sequencia%type) RETURNS SETOF T_PLS_LIMITACAO_MAT_DATA AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Retornar os materiais para cada uma das regras do tipo de limitação. Será retornado
	apenas material, origem, tipo de guia, e cid para verificar as contas e ou materiais
	que foram utilizados em determinada característica.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:

Alterações:
------------------------------------------------------------------------------------------------------------------
jjung OS 596834 14/08/2013 -	Criação da function
------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
t_pls_limitacao_mat_row_w	t_pls_limitacao_mat_row;

-- Obter as regras para os materiais cadastrados na limitação.
C01 CURSOR(	nr_seq_tipo_limitacao_pc	pls_tipo_limitacao.nr_sequencia%type) FOR
	SELECT	a.nr_seq_material,
		a.nr_seq_estrut_mat,
		a.ie_tipo_guia,
		a.cd_doenca_cid,
		a.ie_limitacao
	from	pls_limitacao_mat	a
	where	a.nr_seq_tipo_limitacao		= nr_seq_tipo_limitacao_pc;

-- Retorna todos os materiais da estrutura e das estruturas filhas também
C02 CURSOR(	nr_seq_estrut_mat_pc	pls_material.nr_seq_estrut_mat%type) FOR
	SELECT	a.nr_seq_material
	from	pls_estrutura_material_v	a
	where	a.nr_seq_estrutura	= nr_seq_estrut_mat_pc;
BEGIN

if (nr_seq_tipo_limitacao_p IS NOT NULL AND nr_seq_tipo_limitacao_p::text <> '') then

	-- Obter as regras de procedimento cadastradas para este tipo de limitação.
	for	r_C01_w in C01(nr_seq_tipo_limitacao_p) loop

		-- Inicializar os dados do registro para que não haja o risco de ficar algum lixo gravado do registro anterior.
		t_pls_limitacao_mat_row_w.cd_doenca_cid		:= null;
		t_pls_limitacao_mat_row_w.ie_tipo_guia		:= null;
		t_pls_limitacao_mat_row_w.nr_seq_material	:= null;
		t_pls_limitacao_mat_row_w.ie_liberado		:= null;

		-- Gravar a informação para verificar se o material está ou não liberado para o tipo de limitação.
		if (r_C01_w.ie_limitacao IS NOT NULL AND r_C01_w.ie_limitacao::text <> '') then

			t_pls_limitacao_mat_row_w.ie_liberado := r_C01_w.ie_limitacao;
		end if;

		-- Gravar a informação cadastrada na regra para o campo CD_DOENCA_CID.
		if (r_C01_w.cd_doenca_cid IS NOT NULL AND r_C01_w.cd_doenca_cid::text <> '') then

			t_pls_limitacao_mat_row_w.cd_doenca_cid := r_C01_w.cd_doenca_cid;
		end if;

		-- Gravar a informação do campo IE_TIPO_GUIA da regra para o retorno.
		if (r_C01_w.ie_tipo_guia IS NOT NULL AND r_C01_w.ie_tipo_guia::text <> '') then

			t_pls_limitacao_mat_row_w.ie_tipo_guia := r_C01_w.ie_tipo_guia;
		end if;

		-- Se tiver informado o campo material já retorna o registro, sem se preocupar com a estrutura, pois o campo material tem
		-- prioridade sobre o campo estrutura e só pode ser informado um dos dois ao mesmo tempo.
		if (r_C01_w.nr_seq_material IS NOT NULL AND r_C01_w.nr_seq_material::text <> '') then

			t_pls_limitacao_mat_row_w.nr_seq_material := r_C01_w.nr_seq_material;
			RETURN NEXT t_pls_limitacao_mat_row_w;
		-- Se tiver informada a estrutura e não tiver informado o material então busca todos os materiais cadastrados para a estrutura em questão.
		elsif (r_C01_w.nr_seq_estrut_mat IS NOT NULL AND r_C01_w.nr_seq_estrut_mat::text <> '') then

			-- Busca todos os materiais cadastrado para a estrutura, inclusive para as estruturas filhas.
			for	r_C02_w in C02(r_C01_w.nr_seq_estrut_mat) loop

				t_pls_limitacao_mat_row_w.nr_seq_material := r_C02_w.nr_seq_material;
				RETURN NEXT t_pls_limitacao_mat_row_w;
			end loop; -- C02
		-- Se não for informado campos de material então adiciona ao retorno apenas as informações de CID e tipo de guia.
		else
			RETURN NEXT t_pls_limitacao_mat_row_w;
		end if;
	end loop; --C01
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
-- REVOKE ALL ON FUNCTION pls_grupos_pck.obter_mats_limitacao ( nr_seq_tipo_limitacao_p pls_tipo_limitacao.nr_sequencia%type) FROM PUBLIC;
