-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_motivo_cancel_proc_aprov ( nr_seq_processo_p bigint) RETURNS varchar AS $body$
DECLARE



ds_motivo_w		varchar(255);


BEGIN

select	substr(max(obter_motivo_cancel_oc(b.nr_seq_motivo_cancel)),1,255)
into STRICT	ds_motivo_w
from	ordem_compra b,
	ordem_compra_item a
where	a.nr_ordem_compra		= b.nr_ordem_compra
and	a.nr_seq_aprovacao	= nr_seq_processo_p;

if (coalesce(ds_motivo_w::text, '') = '') then
	select	substr(max(obter_motivo_cancel_oc(b.nr_seq_motivo_cancel)),1,255)
	into STRICT	ds_motivo_w
	from	solic_compra b,
		solic_compra_item a
	where	a.nr_solic_compra		= b.nr_solic_compra
	and	a.nr_seq_aprovacao	= nr_seq_processo_p;
end if;

if (coalesce(ds_motivo_w::text, '') = '') then
	select	substr(max(obter_motivo_cancel_oc(b.nr_seq_motivo_cancel)),1,255)
	into STRICT	ds_motivo_w
	from	cot_compra b,
		cot_compra_item a
	where	a.nr_cot_compra		= b.nr_cot_compra
	and	a.nr_seq_aprovacao	= nr_seq_processo_p;
end if;

return ds_motivo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_motivo_cancel_proc_aprov ( nr_seq_processo_p bigint) FROM PUBLIC;
