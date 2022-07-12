-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_grupos_pck.obter_procs_estrutura ( cd_procedimento_p procedimento.cd_procedimento%type, ie_origem_proced_p procedimento.ie_origem_proced%type, nr_seq_grupo_servico_p pls_preco_grupo_servico.nr_sequencia%type, cd_grupo_proc_p grupo_proc.cd_grupo_proc%type, cd_especialidade_p especialidade_proc.cd_especialidade%type, cd_area_p area_procedimento.cd_area_procedimento%type, ie_origem_proc_comp_p procedimento.ie_origem_proced%type default null, cd_procedimento_comp_p procedimento.cd_procedimento%type default null) RETURNS SETOF T_PROCEDIMENTO_DATA AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Retornar os procedimentos para a estrutura passada por parâmetro, será respeitada
	a ordem de acesso aos parãmetros conforme a ordem de apresentação dos mesmos,
	ou seja se for passado um procedimento e uma  especialidade, só será retornado o
	procedimento, não será verificada a especialidade, pois o procedimento é a estrutura
	é a mais restritiva.
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
t_procedimento_row_w	pls_grupos_pck.t_procedimento_row;
bulk_procedimento_w	pls_grupos_pck.t_bulk_procedimento;
ds_sql_w		varchar(4000);


-- Obter os procedimentos cadastrados para o grupo de serviço.
C01 CURSOR(	nr_seq_grupo_servico_pc		pls_preco_grupo_servico.nr_sequencia%type,
		cd_procedimento_p		procedimento.cd_procedimento%type,
		ie_origem_proced_p		procedimento.ie_origem_proced%type) FOR
	SELECT	a.cd_procedimento,
		a.ie_origem_proced
	from	table(pls_grupos_pck.obter_procs_grupo_servico(nr_seq_grupo_servico_pc, ie_origem_proced_p, cd_procedimento_p)) a;
  rw_proc_w RECORD;

BEGIN

-- Se tiver informado o procedimento então já adiciona ao retorno o procedimento informado e somente ele.
if (cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') then

	-- Já adiciona este procedimento ao retorno.
	t_procedimento_row_w.cd_procedimento	:= cd_procedimento_p;
	t_procedimento_row_w.ie_origem_proced	:= ie_origem_proced_p;

	RETURN NEXT t_procedimento_row_w;

	return;
-- se não, se o grupo de servico for informado busca todos os proceidmentos liberados para o grupo de servico.
elsif (nr_seq_grupo_servico_p IS NOT NULL AND nr_seq_grupo_servico_p::text <> '') then

	-- Buscar os procedimentos do grupo de servico e adicionando cada um ao retorno.
	for	r_C01_w in C01(nr_seq_grupo_servico_p, cd_procedimento_comp_p, ie_origem_proc_comp_p)  loop

		t_procedimento_row_w.cd_procedimento	:= r_C01_w.cd_procedimento;
		t_procedimento_row_w.ie_origem_proced	:= r_C01_w.ie_origem_proced;

		RETURN NEXT t_procedimento_row_w;
	end loop; -- C01
	return;
-- se não, se o grupo de procedimento for informado busca todos os proceidmentos do grupo.
elsif (cd_grupo_proc_p IS NOT NULL AND cd_grupo_proc_p::text <> '') then

	-- Buscar os procedimentos do grupo de procedimentos e adiciona cada um ao retorno.
	-- Se não for para comparar busca todos
	if (coalesce(cd_procedimento_comp_p::text, '') = '' and coalesce(ie_origem_proc_comp_p::text, '') = '') then

		for	rw_proc_w in (	SELECT	a.cd_procedimento,
						a.ie_origem_proced
					from	estrutura_procedimento_v	a
					where	a.cd_grupo_proc		= cd_grupo_proc_p) loop

			t_procedimento_row_w.cd_procedimento	:= rw_proc_w.cd_procedimento;
			t_procedimento_row_w.ie_origem_proced	:= rw_proc_w.ie_origem_proced;

			RETURN NEXT t_procedimento_row_w;
		end loop;
	-- se não busca somente o informado;
	else
		for	rw_proc_w in (	SELECT	a.cd_procedimento,
						a.ie_origem_proced
					from	estrutura_procedimento_v	a
					where	a.cd_grupo_proc		= cd_grupo_proc_p
					and	a.ie_origem_proced	= ie_origem_proc_comp_p
					and	a.cd_procedimento	= cd_procedimento_comp_p) loop

			t_procedimento_row_w.cd_procedimento	:= rw_proc_w.cd_procedimento;
			t_procedimento_row_w.ie_origem_proced	:= rw_proc_w.ie_origem_proced;

			RETURN NEXT t_procedimento_row_w;
		end loop;
	end if;

	return;
-- se não, se a especialidade for informada busca todos os procedimentos da especialidade.
elsif (cd_especialidade_p IS NOT NULL AND cd_especialidade_p::text <> '') then

	-- buscar os procedimentos da especialidade e adicionar cada um ao retorno.
	-- Se não for para comparar busca todos
	if (coalesce(cd_procedimento_comp_p::text, '') = '' and coalesce(ie_origem_proc_comp_p::text, '') = '') then

		for	rw_proc_w in (	SELECT	a.cd_procedimento,
						a.ie_origem_proced
					from	estrutura_procedimento_v	a
					where	a.cd_especialidade	= cd_especialidade_p) loop

			t_procedimento_row_w.cd_procedimento	:= rw_proc_w.cd_procedimento;
			t_procedimento_row_w.ie_origem_proced	:= rw_proc_w.ie_origem_proced;

			RETURN NEXT t_procedimento_row_w;
		end loop;
	-- se não busca somente o informado;
	else
		for	rw_proc_w in (	SELECT	a.cd_procedimento,
						a.ie_origem_proced
					from	estrutura_procedimento_v	a
					where	a.cd_especialidade	= cd_especialidade_p
					and	a.ie_origem_proced	= ie_origem_proc_comp_p
					and	a.cd_procedimento	= cd_procedimento_comp_p) loop

			t_procedimento_row_w.cd_procedimento	:= rw_proc_w.cd_procedimento;
			t_procedimento_row_w.ie_origem_proced	:= rw_proc_w.ie_origem_proced;

			RETURN NEXT t_procedimento_row_w;
		end loop;
	end if;

	return;
-- se não, se a area for informada busca todos os procedimentos da area.
elsif (cd_area_p IS NOT NULL AND cd_area_p::text <> '') then

	-- buscar os procedimentos da area e adicionar cada um ao retorno.
	-- Se não for para comparar busca todos
	if (coalesce(cd_procedimento_comp_p::text, '') = '' and coalesce(ie_origem_proc_comp_p::text, '') = '') then

		for	rw_proc_w in (	SELECT	a.cd_procedimento,
						a.ie_origem_proced
					from	estrutura_procedimento_v	a
					where	a.cd_area_procedimento	= cd_area_p) loop

			t_procedimento_row_w.cd_procedimento	:= rw_proc_w.cd_procedimento;
			t_procedimento_row_w.ie_origem_proced	:= rw_proc_w.ie_origem_proced;

			RETURN NEXT t_procedimento_row_w;
		end loop;
	-- se não busca somente o informado;
	else
		for	rw_proc_w in (	SELECT	a.cd_procedimento,
						a.ie_origem_proced
					from	estrutura_procedimento_v	a
					where	a.cd_area_procedimento	= cd_area_p
					and	a.ie_origem_proced	= ie_origem_proc_comp_p
					and	a.cd_procedimento	= cd_procedimento_comp_p) loop

			t_procedimento_row_w.cd_procedimento	:= rw_proc_w.cd_procedimento;
			t_procedimento_row_w.ie_origem_proced	:= rw_proc_w.ie_origem_proced;

			RETURN NEXT t_procedimento_row_w;
		end loop;
	end if;

	return;
end if;

-- Se chegar até aqui e não entrar em nenhuma estrutura nada será retornado.
return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_grupos_pck.obter_procs_estrutura ( cd_procedimento_p procedimento.cd_procedimento%type, ie_origem_proced_p procedimento.ie_origem_proced%type, nr_seq_grupo_servico_p pls_preco_grupo_servico.nr_sequencia%type, cd_grupo_proc_p grupo_proc.cd_grupo_proc%type, cd_especialidade_p especialidade_proc.cd_especialidade%type, cd_area_p area_procedimento.cd_area_procedimento%type, ie_origem_proc_comp_p procedimento.ie_origem_proced%type default null, cd_procedimento_comp_p procedimento.cd_procedimento%type default null) FROM PUBLIC;
