-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qtd_entregue_opme ( cd_material_p bigint, nr_seq_pac_opme_p bigint, nr_seq_agenda_p bigint) RETURNS bigint AS $body$
DECLARE


ie_regra_integracao_w		varchar(1);
qt_mat_entregue_w		bigint;



BEGIN
ie_regra_integracao_w	:= obter_regra_int_opme_material(cd_material_p,'01');

if (ie_regra_integracao_w = 'S') then

	select	sum(n.qt_item_nf)
	into STRICT	qt_mat_entregue_w
	from	nota_fiscal_item n
	where	n.nr_seq_ag_pac_opme = nr_seq_pac_opme_p
	and	obter_se_nota_entrada_saida(n.nr_sequencia) = 'E'
	and	n.nr_seq_agenda_pac  = nr_seq_agenda_p;

end if;

return	coalesce(qt_mat_entregue_w,0);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qtd_entregue_opme ( cd_material_p bigint, nr_seq_pac_opme_p bigint, nr_seq_agenda_p bigint) FROM PUBLIC;

