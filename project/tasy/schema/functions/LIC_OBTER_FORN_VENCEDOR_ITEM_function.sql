-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lic_obter_forn_vencedor_item ( nr_seq_licitacao_p bigint, nr_seq_lic_item_p bigint) RETURNS bigint AS $body$
DECLARE


nr_seq_fornec_w			bigint;
nr_lote_compra_w		varchar(80);


BEGIN

select	coalesce(max(nr_seq_fornec),0)
into STRICT	nr_seq_fornec_w
from	reg_lic_vencedor
where	nr_seq_licitacao	= nr_seq_licitacao_p
and	nr_seq_lic_item	= nr_seq_lic_item_p;

if (nr_seq_fornec_w = 0) then

	select	max(nr_lote_compra)
	into STRICT	nr_lote_compra_w
	from	reg_lic_item
	where	nr_seq_licitacao	= nr_seq_licitacao_p
	and	nr_seq_lic_item		= nr_seq_lic_item_p;

	if (nr_lote_compra_w IS NOT NULL AND nr_lote_compra_w::text <> '') then

		select	coalesce(max(nr_seq_fornec),0)
		into STRICT	nr_seq_fornec_w
		from	reg_lic_vencedor
		where	nr_seq_licitacao	= nr_seq_licitacao_p
		and	nr_lote_compra		= nr_lote_compra_w;

	end if;
end if;

return	nr_seq_fornec_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lic_obter_forn_vencedor_item ( nr_seq_licitacao_p bigint, nr_seq_lic_item_p bigint) FROM PUBLIC;

