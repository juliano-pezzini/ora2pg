-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lic_obter_porcent_dif_lance (nr_seq_licitacao_p bigint, nr_seq_lic_item_p bigint, nr_seq_fornec_p bigint, nr_seq_lance_p bigint) RETURNS bigint AS $body$
DECLARE


vl_vencedor_w			double precision;
pr_dif_lance_w			double precision := 0;
vl_item_w				double precision;
nr_seq_lance_w			bigint;

BEGIN

nr_seq_lance_w	:= nr_seq_lance_p;

select	lic_obter_valor_vencedor_item(nr_seq_licitacao_p, nr_seq_lic_item_p)
into STRICT	vl_vencedor_w
;

select	coalesce(max(vl_item),0)
into STRICT	vl_item_w
from	reg_lic_fornec_lance
where	nr_seq_licitacao	= nr_seq_licitacao_p
and	nr_seq_lic_item	= nr_seq_lic_item_p
and	nr_seq_fornec	= nr_seq_fornec_p
and	nr_seq_lance	= nr_seq_lance_w;

while(vl_item_w = 0) and (nr_seq_lance_w >= 1) loop
	begin
	if (nr_seq_lance_w >= 1) then
		select	coalesce(max(vl_item),0)
		into STRICT	vl_item_w
		from	reg_lic_fornec_lance
		where	nr_seq_licitacao	= nr_seq_licitacao_p
		and	nr_seq_lic_item	= nr_seq_lic_item_p
		and	nr_seq_fornec	= nr_seq_fornec_p
		and	nr_seq_lance	= nr_seq_lance_w;
	end if;
	nr_seq_lance_w := nr_seq_lance_w - 1;
	end;
end loop;

if (vl_item_w = 0) then
	select	lic_obter_proposta_inicial(nr_seq_licitacao_p, nr_seq_fornec_p, nr_seq_lic_item_p)
	into STRICT	vl_item_w
	;
end if;

pr_dif_lance_w := (dividir(vl_item_w, vl_vencedor_w) *100) - 100;

return	pr_dif_lance_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lic_obter_porcent_dif_lance (nr_seq_licitacao_p bigint, nr_seq_lic_item_p bigint, nr_seq_fornec_p bigint, nr_seq_lance_p bigint) FROM PUBLIC;

