-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_estr_ocor_todos_aut ( nr_seq_estrutura_p pls_ocorrencia_estrutura.nr_sequencia%type, nr_seq_guia_p pls_guia_plano.nr_sequencia%type, nr_seq_requisicao_p pls_requisicao.nr_sequencia%type, nr_seq_execucao_p pls_execucao_requisicao.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Validar se todos os itens da estrutura estão no atendimento
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_retorno_w			varchar(1);
nr_seq_segurado_w		pls_segurado.nr_sequencia%type;
qt_itens_estrutura_w		bigint	:= 0;
qt_total_estrutura_w		bigint	:= 0;


BEGIN

select	count(1)
into STRICT	qt_total_estrutura_w
from	pls_ocorrencia_estrut_item
where	((cd_procedimento IS NOT NULL AND cd_procedimento::text <> '') or (nr_seq_material IS NOT NULL AND nr_seq_material::text <> ''))
and	nr_seq_estrutura = nr_seq_estrutura_p
and	ie_estrutura = 'S';

if (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') then
	select	sum(qt_itens)
	into STRICT	qt_itens_estrutura_w
	from ( 	SELECT	count(1) qt_itens
			from (
					SELECT  count(1)
					from    pls_guia_plano_proc b,
						pls_guia_plano c,
						pls_ocorrencia_estrut_item a
					where   c.nr_sequencia				= b.nr_seq_guia
					and	c.nr_sequencia 				= nr_seq_guia_p
					and	a.nr_seq_estrutura      		= nr_seq_estrutura_p
					and     a.cd_procedimento			= b.cd_procedimento
					and     a.ie_origem_proced			= b.ie_origem_proced
					and     coalesce(a.ie_estrutura,'S') 		= 'S'
					group 	by b.cd_procedimento,
						 b.ie_origem_proced ) alias5
			
union all

			select	count(1) qt_itens
			from (
					select  count(1) qt_itens
					from    pls_guia_plano_mat b,
						pls_guia_plano c,
						pls_ocorrencia_estrut_item a
					where   c.nr_sequencia				= b.nr_seq_guia
					and	c.nr_sequencia 				= nr_seq_guia_p
					and	a.nr_seq_estrutura      		= nr_seq_estrutura_p
					and     a.nr_seq_material			= b.nr_seq_material
					and     coalesce(a.ie_estrutura,'S') 		= 'S'
					group 	by b.nr_seq_material ) alias9) alias10;

elsif (nr_seq_requisicao_p IS NOT NULL AND nr_seq_requisicao_p::text <> '') then
	select	sum(qt_itens)
	into STRICT	qt_itens_estrutura_w
	from ( 	SELECT	count(1) qt_itens
			from (
					SELECT  count(1)
					from    pls_requisicao_proc b,
						pls_requisicao c,
						pls_ocorrencia_estrut_item a
					where   c.nr_sequencia				= b.nr_seq_requisicao
					and	c.nr_sequencia 				= nr_seq_requisicao_p
					and	a.nr_seq_estrutura      		= nr_seq_estrutura_p
					and     a.cd_procedimento			= b.cd_procedimento
					and     a.ie_origem_proced			= b.ie_origem_proced
					and     coalesce(a.ie_estrutura,'S') 		= 'S'
					group 	by b.cd_procedimento,
						 b.ie_origem_proced ) alias5
			
union all

			select	count(1) qt_itens
			from (
					select  count(1) qt_itens
					from    pls_requisicao_mat b,
						pls_requisicao c,
						pls_ocorrencia_estrut_item a
					where   c.nr_sequencia				= b.nr_seq_requisicao
					and	c.nr_sequencia 				= nr_seq_requisicao_p
					and	a.nr_seq_estrutura      		= nr_seq_estrutura_p
					and     a.nr_seq_material			= b.nr_seq_material
					and     coalesce(a.ie_estrutura,'S') 		= 'S'
					group 	by b.nr_seq_material ) alias9) alias10;

elsif (nr_seq_execucao_p IS NOT NULL AND nr_seq_execucao_p::text <> '') then
	select	sum(qt_itens)
	into STRICT	qt_itens_estrutura_w
	from ( 	SELECT	count(1) qt_itens
			from (
					SELECT  count(1)
					from    pls_execucao_req_item b,
						pls_execucao_requisicao c,
						pls_ocorrencia_estrut_item a
					where   c.nr_sequencia				= b.nr_seq_execucao
					and	c.nr_sequencia 				= nr_seq_execucao_p
					and	a.nr_seq_estrutura      		= nr_seq_estrutura_p
					and     a.cd_procedimento			= b.cd_procedimento
					and     a.ie_origem_proced			= b.ie_origem_proced
					and	coalesce(b.nr_seq_material::text, '') = ''
					and     coalesce(a.ie_estrutura,'S') 		= 'S'
					group 	by b.cd_procedimento,
						 b.ie_origem_proced ) alias6
			
union all

			select	count(1) qt_itens
			from (
					select  count(1) qt_itens
					from    pls_execucao_req_item b,
						pls_execucao_requisicao c,
						pls_ocorrencia_estrut_item a
					where   c.nr_sequencia				= b.nr_seq_execucao
					and	c.nr_sequencia 				= nr_seq_execucao_p
					and	a.nr_seq_estrutura      		= nr_seq_estrutura_p
					and     a.nr_seq_material			= b.nr_seq_material
					and	coalesce(b.cd_procedimento::text, '') = ''
					and     coalesce(a.ie_estrutura,'S') 		= 'S'
					group 	by b.nr_seq_material ) alias11) alias12;
end if;

/*Se existe pelo menos um procedimento do atendimento que se encaixa na estrutura e
existe menos procedimentos do atendimento que se encaixe na estrutura do que o total da estrutura*/
if (qt_itens_estrutura_w > 0) and (qt_itens_estrutura_w < qt_total_estrutura_w) then
	ie_retorno_w := 'S';
else
	ie_retorno_w := 'N';
end if;

return  ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_estr_ocor_todos_aut ( nr_seq_estrutura_p pls_ocorrencia_estrutura.nr_sequencia%type, nr_seq_guia_p pls_guia_plano.nr_sequencia%type, nr_seq_requisicao_p pls_requisicao.nr_sequencia%type, nr_seq_execucao_p pls_execucao_requisicao.nr_sequencia%type) FROM PUBLIC;
