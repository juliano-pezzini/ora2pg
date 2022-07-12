-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_proc_semelhante ( nr_seq_regra_semelhante_p pls_regra_item_semelhante.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, ie_origem_proced_ref_p procedimento.ie_origem_proced%type, cd_procedimento_ref_p procedimento.cd_procedimento%type, ie_origem_proced_semel_p procedimento.ie_origem_proced%type, cd_procedimento_semel_p procedimento.cd_procedimento%type) RETURNS varchar AS $body$
DECLARE


qt_semelhantes_w	integer;
ds_retorno_w		varchar(1);

BEGIN

-- Quando for informado o nr_seq_regra_semelhante_p, olha diretamente a regra,
--  Senão procura por todas as regras dentro da vigencia
if (nr_seq_regra_semelhante_p IS NOT NULL AND nr_seq_regra_semelhante_p::text <> '') then
	select	count(a.nr_sequencia)
	into STRICT	qt_semelhantes_w
	from	pls_regra_item_semelhante	a,
		pls_regra_item_semel_proc	b
	where	b.nr_seq_regra_semelhante	= a.nr_sequencia
	and	trunc(clock_timestamp(), 'dd') between a.dt_inicio_vigencia and coalesce(a.dt_fim_vigencia, trunc(clock_timestamp(), 'dd'))
	and	b.ie_origem_proced		= ie_origem_proced_ref_p
	and	b.cd_procedimento		= cd_procedimento_ref_p
	and	b.ie_item_referencia		= 'S'
	and	a.nr_sequencia			= nr_seq_regra_semelhante_p
	and	((a.cd_estabelecimento		= cd_estabelecimento_p) or (coalesce(a.cd_estabelecimento::text, '') = '') or (coalesce(cd_estabelecimento_p::text, '') = ''))
	and	exists (	SELECT	x.nr_sequencia
				from	pls_regra_item_semelhante	x,
					pls_regra_item_semel_proc	y
				where	y.nr_seq_regra_semelhante	= x.nr_sequencia
				and	x.nr_sequencia			= a.nr_sequencia
				and	y.ie_origem_proced		= ie_origem_proced_semel_p
				and	y.cd_procedimento		= cd_procedimento_semel_p
				and	y.ie_item_referencia		= 'N');
else
	select	count(a.nr_sequencia)
	into STRICT	qt_semelhantes_w
	from	pls_regra_item_semelhante	a,
		pls_regra_item_semel_proc	b
	where	b.nr_seq_regra_semelhante	= a.nr_sequencia
	and	trunc(clock_timestamp(), 'dd') between a.dt_inicio_vigencia and coalesce(a.dt_fim_vigencia, trunc(clock_timestamp(), 'dd'))
	and	b.ie_origem_proced		= ie_origem_proced_ref_p
	and	b.cd_procedimento		= cd_procedimento_ref_p
	and	b.ie_item_referencia		= 'S'
	and	((a.cd_estabelecimento		= cd_estabelecimento_p) or (coalesce(a.cd_estabelecimento::text, '') = '') or (coalesce(cd_estabelecimento_p::text, '') = ''))
	and	exists (	SELECT	x.nr_sequencia
				from	pls_regra_item_semelhante	x,
					pls_regra_item_semel_proc	y
				where	y.nr_seq_regra_semelhante	= x.nr_sequencia
				and	x.nr_sequencia			= a.nr_sequencia
				and	y.ie_origem_proced		= ie_origem_proced_semel_p
				and	y.cd_procedimento		= cd_procedimento_semel_p
				and	y.ie_item_referencia		= 'N');
end if;


if (qt_semelhantes_w > 0) then
	ds_retorno_w := 'S';
else
	ds_retorno_w := 'N';
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_proc_semelhante ( nr_seq_regra_semelhante_p pls_regra_item_semelhante.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, ie_origem_proced_ref_p procedimento.ie_origem_proced%type, cd_procedimento_ref_p procedimento.cd_procedimento%type, ie_origem_proced_semel_p procedimento.ie_origem_proced%type, cd_procedimento_semel_p procedimento.cd_procedimento%type) FROM PUBLIC;
