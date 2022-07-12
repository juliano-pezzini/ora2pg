-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lic_obter_dt_fechamento_lance ( nr_seq_licitacao_p bigint, nr_seq_lic_item_p bigint) RETURNS timestamp AS $body$
DECLARE


dt_fechamento_rodada_w		timestamp;
nr_seq_lance_w			bigint;
qt_existe_w			bigint;


BEGIN

select	coalesce(max(nr_seq_lance), 0)
into STRICT	nr_seq_lance_w
from	reg_lic_fornec_lance
where	nr_seq_licitacao	= nr_seq_licitacao_p
and	nr_seq_lic_item	= nr_seq_lic_item_p;

if (nr_seq_lance_w > 0) then

	select	count(*)
	into STRICT	qt_existe_w
	from	reg_lic_fornec_lance
	where	nr_seq_licitacao	= nr_seq_licitacao_p
	and	nr_seq_lic_item	= nr_seq_lic_item_p
	and	nr_seq_lance	= nr_seq_lance_w;

	if (qt_existe_w > 0) then

		select	max(dt_fechamento_rodada)
		into STRICT	dt_fechamento_rodada_w
		from	reg_lic_fornec_lance
		where	nr_seq_licitacao	= nr_seq_licitacao_p
		and	nr_seq_lic_item	= nr_seq_lic_item_p
		and	nr_seq_lance	= nr_seq_lance_w;
	end if;
end if;

return	dt_fechamento_rodada_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lic_obter_dt_fechamento_lance ( nr_seq_licitacao_p bigint, nr_seq_lic_item_p bigint) FROM PUBLIC;
