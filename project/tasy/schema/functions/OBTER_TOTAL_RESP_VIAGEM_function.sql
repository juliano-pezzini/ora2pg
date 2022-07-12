-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_total_resp_viagem ( ie_responsavel_p text, nr_seq_viagem_p bigint, dt_referencia_p timestamp) RETURNS bigint AS $body$
DECLARE


vl_total_w 	double precision;


BEGIN

select	sum(d.vl_despesa)
into STRICT	vl_total_w
from	via_viagem v,
	via_relat_desp r,
	via_despesa d
where	d.nr_seq_relat = r.nr_sequencia
and	r.nr_seq_viagem = v.nr_sequencia
and	v.nr_sequencia = CASE WHEN nr_seq_viagem_p='0' THEN v.nr_sequencia  ELSE nr_seq_viagem_p END
and	d.ie_responsavel_custo = ie_responsavel_p
and	trunc(d.dt_despesa,'mm') = trunc(dt_referencia_p,'mm');

return	coalesce(vl_total_w,0);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_total_resp_viagem ( ie_responsavel_p text, nr_seq_viagem_p bigint, dt_referencia_p timestamp) FROM PUBLIC;

