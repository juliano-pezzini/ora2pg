-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_estrut_ocor_todos ( nr_seq_estrutura_p bigint, nr_seq_guia_p bigint, nr_seq_conta_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_proc_conta_p bigint, ie_origem_proc_conta_p bigint, nr_seq_material_p bigint ) RETURNS varchar AS $body$
DECLARE


ie_retorno_w			varchar(1);
nr_seq_segurado_w		bigint;
cd_guia_w			varchar(20);
qt_itens_estrutura_w		bigint	:= 0;
qt_proc_w			bigint	:= 0;
qt_proc_ww			bigint	:= 0;
qt_mat_w			bigint	:= 0;
qt_estrutura_conta_w		bigint	:= 0;


BEGIN

/* Definição; Todos
     --------------------------------------------------------------------------------------------
    Deve gerar ocorrência caso no atendimento não existe todos os procedimentos da estrutura.

    Caso seja de ocorrência de conta =>  o sistema gera a ocorrência caso falte algum item

    Caso seja de ocorrência de item =>  o sistema gera a ocorrência caso falte algum item e o item é parte do grupo

     Retorna :	'S' se necessita gerar ocorrência
	'N' se não necessita

     Obs: O procedimento da regra (cd_procedimento_p) funciona como uma adendo da estrutura ou seja
              Caso exista funciona como se fosse parte da estrutura
*/
/*Fazer tratamento de guia*/

select	count(1)
into STRICT	qt_itens_estrutura_w
from	pls_ocorrencia_estrut_item
where	((cd_procedimento IS NOT NULL AND cd_procedimento::text <> '') or (nr_seq_material IS NOT NULL AND nr_seq_material::text <> ''))
and	nr_seq_estrutura = nr_seq_estrutura_p
and	ie_estrutura = 'S';

if (cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') then
	qt_itens_estrutura_w := qt_itens_estrutura_w + 1;
end if;

if (coalesce(nr_seq_conta_p,0) > 0) then

	select	nr_seq_segurado,
		coalesce(cd_guia_referencia, cd_guia)
	into STRICT	nr_seq_segurado_w,
		cd_guia_w
	from	pls_conta
	where	nr_sequencia = nr_seq_conta_p;

	/*Obter quantos procedimentos da estrutura existe na conta*/

	select	count(1)
	into STRICT    qt_proc_w
	from	(
		SELECT 	b.cd_procedimento,
			b.ie_origem_proced
		from    pls_conta_proc b,
			pls_conta c,
			pls_ocorrencia_estrut_item a
		where   c.nr_sequencia		= b.nr_seq_conta
		and	((c.nr_seq_segurado	= nr_seq_segurado_w and	coalesce(c.cd_guia_referencia, c.cd_guia) = cd_guia_w) or (c.nr_sequencia = nr_seq_conta_p))
		and	a.nr_seq_estrutura      = nr_seq_estrutura_p
		and     a.cd_procedimento	= b.cd_procedimento
		and     a.ie_origem_proced	= b.ie_origem_proced
		and     coalesce(a.ie_estrutura,'S') = 'S'
		group by b.cd_procedimento,
			 b.ie_origem_proced	) alias6;

	/*Obter quantos materiais da estrutura existe na conta*/

	select	count(1)
	into STRICT    qt_mat_w
	from	(
		SELECT 	b.nr_seq_material
		from    pls_conta_mat b,
			pls_conta c,
			pls_ocorrencia_estrut_item a
		where   c.nr_sequencia		= b.nr_seq_conta
		and	((c.nr_seq_segurado	= nr_seq_segurado_w and	coalesce(c.cd_guia_referencia, c.cd_guia) = cd_guia_w) or (c.nr_sequencia = nr_seq_conta_p))
		and	a.nr_seq_estrutura      = nr_seq_estrutura_p
		and     a.nr_seq_material	= b.nr_seq_material
		and     coalesce(a.ie_estrutura,'S') = 'S'
		group by b.nr_seq_material	) alias6;

	/*Obter se existe o procedimento adendo a estrutura (campo procedimento) na conta*/

	select	count(1)
	into STRICT    qt_proc_ww
	from	(
		SELECT  b.cd_procedimento,
			b.ie_origem_proced
		from    pls_conta_proc b,
			pls_conta c
		where   c.nr_sequencia		= b.nr_seq_conta
		and	((c.nr_seq_segurado	= nr_seq_segurado_w and	coalesce(c.cd_guia_referencia, c.cd_guia) = cd_guia_w) or (c.nr_sequencia = nr_seq_conta_p))
		and     b.cd_procedimento	= cd_procedimento_p
		and     b.ie_origem_proced	= ie_origem_proced_p
		group by b.cd_procedimento,
			 b.ie_origem_proced	) alias5;

elsif (coalesce(nr_seq_guia_p,0) > 0) then

	select	nr_seq_segurado
	into STRICT	nr_seq_segurado_w
	from	pls_guia_plano
	where	nr_sequencia = nr_seq_guia_p;

	select	count(1)
	into STRICT    qt_proc_w
	from (
		SELECT  count(1)
		from    pls_guia_plano_proc b,
			pls_guia_plano c,
			pls_ocorrencia_estrut_item a
		where   c.nr_sequencia				= b.nr_seq_guia
		and	c.nr_seq_segurado			= nr_seq_segurado_w
		and	c.nr_sequencia 				= nr_seq_guia_p
		and	a.nr_seq_estrutura      		= nr_seq_estrutura_p
		and     a.cd_procedimento			= b.cd_procedimento
		and     a.ie_origem_proced			= b.ie_origem_proced
		and     coalesce(a.ie_estrutura,'S') 		= 'S'
		group by b.cd_procedimento,
			 b.ie_origem_proced) alias3;

	select	count(1)
	into STRICT    qt_mat_w
	from (
		SELECT  count(1)
		from    pls_guia_plano_mat b,
			pls_guia_plano c,
			pls_ocorrencia_estrut_item a
		where   c.nr_sequencia				= b.nr_seq_guia
		and	c.nr_seq_segurado			= nr_seq_segurado_w
		and	c.nr_sequencia 				= nr_seq_guia_p
		and	a.nr_seq_estrutura      		= nr_seq_estrutura_p
		and     a.nr_seq_material			= b.nr_seq_material
		and     coalesce(a.ie_estrutura,'S') 		= 'S'
		group by b.nr_seq_material	) alias3;

	select	count(1)
	into STRICT    qt_proc_ww
	from (
		SELECT  count(1)
		from    pls_guia_plano_proc b,
			pls_guia_plano c
		where   c.nr_sequencia				= b.nr_seq_guia
		and	c.nr_seq_segurado			= nr_seq_segurado_w
		and	c.nr_sequencia 				= nr_seq_guia_p
		and     b.cd_procedimento			= cd_procedimento_p
		and     b.ie_origem_proced			= ie_origem_proced_p
		group by b.cd_procedimento,
			 b.ie_origem_proced) alias2;

end if;

qt_estrutura_conta_w := qt_proc_w + qt_proc_ww + qt_mat_w;


/*Se existe pelo menos um procedimento da conta que se encaixa na estrutura e
existe menos procedimentos da conta que se encaixa na estrutura na conta que no todo da estrutura*/
if (qt_estrutura_conta_w > 0) and (qt_estrutura_conta_w < qt_itens_estrutura_w) then
	ie_retorno_w := 'S';
else
	ie_retorno_w := 'N';
end if;

/*Caso seja uma ocorrência do tipo item é verificado se o procedimento faz parte da estrutura.*/

if (ie_retorno_w = 'S') then

	if (coalesce(cd_proc_conta_p,0) > 0) then

		select  count(1)
		into STRICT    qt_estrutura_conta_w
		from    pls_ocorrencia_estrut_item a
		where   nr_seq_estrutura        = nr_seq_estrutura_p
		and     a.cd_procedimento	= cd_proc_conta_p
		and     a.ie_origem_proced	= ie_origem_proc_conta_p
		and     coalesce(ie_estrutura,'S') = 'S';

		if (ie_origem_proced_p = ie_origem_proc_conta_p) and (cd_procedimento_p = cd_proc_conta_p) then
			qt_estrutura_conta_w := 1;
		end if;

		/*Se o procedimento se encaixar na estrutura gera ocorrência*/

		if (qt_estrutura_conta_w > 0) then
			ie_retorno_w := 'S';
		else
			ie_retorno_w := 'N';
		end if;

	elsif (coalesce(nr_seq_material_p,0) > 0) then

		select  count(1)
		into STRICT    qt_estrutura_conta_w
		from    pls_ocorrencia_estrut_item a
		where   nr_seq_estrutura        = nr_seq_estrutura_p
		and     a.nr_seq_material	= nr_seq_material_p
		and     coalesce(ie_estrutura,'S') = 'S';

		/*Se o material se encaixar na estrutura gera ocorrência*/

		if (qt_estrutura_conta_w > 0) then
			ie_retorno_w := 'S';
		else
			ie_retorno_w := 'N';
		end if;

	end if;
end if;

return  ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_estrut_ocor_todos ( nr_seq_estrutura_p bigint, nr_seq_guia_p bigint, nr_seq_conta_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_proc_conta_p bigint, ie_origem_proc_conta_p bigint, nr_seq_material_p bigint ) FROM PUBLIC;

