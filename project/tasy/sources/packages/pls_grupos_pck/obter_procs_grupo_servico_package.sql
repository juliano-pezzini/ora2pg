-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


CREATE TYPE l_row_w AS (
	ie_origem_proced_w	procedimento.ie_origem_proced%type,
	cd_procedimento_w	procedimento.cd_procedimento%type,
	nr_prioridade_w		smallint
);


CREATE OR REPLACE FUNCTION pls_grupos_pck.obter_procs_grupo_servico ( nr_seq_grupo_p pls_preco_grupo_servico.nr_sequencia%type, ie_origem_proced_p procedimento.ie_origem_proced%type default null, cd_procedimento_p procedimento.cd_procedimento%type default null) RETURNS SETOF T_PLS_PROC_GRUPO_SERVICO_DATA AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  Retornar os itens que estão liberados  para determinado grupo.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:

Alterações:
------------------------------------------------------------------------------------------------------------------
jjung OS 601993 12/06/2013 -	Criação da function
------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
t_pls_proc_grupo_servico_row_w	pls_grupos_pck.t_pls_proc_grupo_servico_row;
type l_data_w is table of l_row_w;
l_data_cursor 		l_data_w;
ds_sql_w		varchar(1000);
ds_filtro_w		varchar(300);

C02 CURSOR(	nr_seq_grupo_pc		pls_preco_grupo_servico.nr_sequencia%type,
		cd_procedimento_pc	procedimento.cd_procedimento%type,
		ie_origem_proced_pc	procedimento.ie_origem_proced%type) FOR
	SELECT	max(a.nr_prioridade) nr_prioridade
	from	pls_preco_grupo_servico_v a
	where	a.nr_seq_grupo = nr_seq_grupo_pc
	and	a.ie_origem_proced = ie_origem_proced_pc
	and	a.cd_procedimento = cd_procedimento_pc
	and	a.ie_estrutura = 'N';
BEGIN

-- deve ter a informação do grupo para que seja verificado
if (nr_seq_grupo_p IS NOT NULL AND nr_seq_grupo_p::text <> '') then

	ds_filtro_w := '';
	-- se foi informado o procedimento filtra
	if (ie_origem_proced_p IS NOT NULL AND ie_origem_proced_p::text <> '' AND cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') then
		ds_filtro_w := ds_filtro_w || 'and	a.ie_origem_proced = :ie_origem_proced_pc ' || pls_util_pck.enter_w;
		ds_filtro_w := ds_filtro_w || 'and	a.cd_procedimento = :cd_procedimento_pc ';
	end if;

	ds_sql_w :=	'select	a.ie_origem_proced, ' || pls_util_pck.enter_w ||
			'	a.cd_procedimento, ' || pls_util_pck.enter_w ||
			'	a.nr_prioridade ' || pls_util_pck.enter_w ||
			'from	pls_preco_grupo_servico_v a ' || pls_util_pck.enter_w ||
			'where	a.nr_seq_grupo = :nr_seq_grupo_pc ' || pls_util_pck.enter_w ||
			'and	a.ie_estrutura = ''S'' ' || ds_filtro_w;

	-- faz a busca dos dados e armazena em memória para depois percorrer
	if (ie_origem_proced_p IS NOT NULL AND ie_origem_proced_p::text <> '' AND cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') then
		EXECUTE ds_sql_w
		bulk collect into STRICT l_data_cursor
		using nr_seq_grupo_p, ie_origem_proced_p, cd_procedimento_p;
	else
		EXECUTE ds_sql_w
		bulk collect into STRICT l_data_cursor
		using nr_seq_grupo_p;
	end if;

	-- Percorre todos os itens da estrutura.
	if (l_data_cursor.count > 0) then
		for i in l_data_cursor.first..l_data_cursor.last loop

			-- será buscado a maior prioridade que não estiver liberada para este procedimento
			for	r_C02_w in C02(	nr_seq_grupo_p, l_data_cursor[i].cd_procedimento_w,
							l_data_cursor[i].ie_origem_proced_w) loop

				-- só será inserido o item no retorno se a prioridade do item liberado for maior do que a maior prioridade do item que não estiver liberado
				-- ou se não tiver registro como Não liberado
				if (l_data_cursor[i].nr_prioridade_w > r_C02_w.nr_prioridade) or (coalesce(r_C02_w.nr_prioridade::text, '') = '') then

					-- grava os dados para que o registro seja retornado posteriormente.
					t_pls_proc_grupo_servico_row_w.cd_procedimento := l_data_cursor[i].cd_procedimento_w;
					t_pls_proc_grupo_servico_row_w.ie_origem_proced := l_data_cursor[i].ie_origem_proced_w;

					RETURN NEXT t_pls_proc_grupo_servico_row_w;
				end if;
			end loop; --C02
		end loop; -- C01
	end if;
	-- return apenas para não ficar acusando que a rotina não retorna valores
	return;
end if;
-- Não retorna nada;
return;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_grupos_pck.obter_procs_grupo_servico ( nr_seq_grupo_p pls_preco_grupo_servico.nr_sequencia%type, ie_origem_proced_p procedimento.ie_origem_proced%type default null, cd_procedimento_p procedimento.cd_procedimento%type default null) FROM PUBLIC;