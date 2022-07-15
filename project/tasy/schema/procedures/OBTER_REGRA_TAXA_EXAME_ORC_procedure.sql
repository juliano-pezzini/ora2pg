-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_regra_taxa_exame_orc ( cd_estabelecimento_p bigint, cd_convenio_p bigint, cd_categoria_p text, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_orc_item_p bigint, nr_seq_proc_interno_p bigint, ie_criterio_taxa_p INOUT bigint, tx_proc_resultante_p INOUT bigint, ie_regra_filme_p INOUT text) AS $body$
BEGIN
Begin
select
	coalesce(a.tx_procedimento,1),
	coalesce(a.ie_criterio_taxa, 1),
	coalesce(ie_regra_filme,'P')
into STRICT 	tx_proc_resultante_p,
	ie_criterio_taxa_p,
	ie_regra_filme_p
from	orcamento_paciente_proc b,
     	convenio_taxa_exame a
where	a.cd_estabelecimento	= cd_estabelecimento_p
and 	a.cd_convenio		= cd_convenio_p
and 	a.cd_categoria		= cd_categoria_p
and	a.cd_taxa_exame		= cd_procedimento_p
and	a.ie_origem_proced	= ie_origem_proced_p
and   	a.cd_procedimento	= b.cd_procedimento
and   	a.ie_origem_proced	= b.ie_origem_proced
and   	b.nr_sequencia		= nr_seq_orc_item_p
and 	coalesce(a.nr_seq_proc_interno, coalesce(nr_seq_proc_interno_p,0)) = coalesce(nr_seq_proc_interno_p,0)
and     nr_seq_orc_item_p	<> 0
and	coalesce(a.ie_situacao, 'A') = 'A';
exception
	when others then
	begin
	select
		coalesce(max(a.tx_procedimento),1),
		coalesce(max(a.ie_criterio_taxa), 0),
		coalesce(max(a.ie_regra_filme),'P')
	into STRICT 	tx_proc_resultante_p,
		ie_criterio_taxa_p,
		ie_regra_filme_p
	from	convenio_taxa_exame a
	where	a.cd_estabelecimento	= cd_estabelecimento_p
	and 	a.cd_convenio		= cd_convenio_p
	and 	a.cd_categoria		= cd_categoria_p
	and	a.cd_taxa_exame		= cd_procedimento_p
	and	a.ie_origem_proced	= ie_origem_proced_p
	and   	a.cd_procedimento	= cd_procedimento_p
	and   	a.ie_origem_proced	= ie_origem_proced_p
	and 	coalesce(a.nr_seq_proc_interno, coalesce(nr_seq_proc_interno_p,0)) = coalesce(nr_seq_proc_interno_p,0)
	and   	nr_seq_orc_item_p	<> 0
	and	coalesce(a.ie_situacao, 'A') = 'A';
	end;
end;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_regra_taxa_exame_orc ( cd_estabelecimento_p bigint, cd_convenio_p bigint, cd_categoria_p text, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_orc_item_p bigint, nr_seq_proc_interno_p bigint, ie_criterio_taxa_p INOUT bigint, tx_proc_resultante_p INOUT bigint, ie_regra_filme_p INOUT text) FROM PUBLIC;

