-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_saldo_banco ( nr_seq_conta_p bigint, dt_referencia_p timestamp) RETURNS bigint AS $body$
DECLARE


vl_saldo_w		double precision;
dt_referencia_w	timestamp;

BEGIN

if (coalesce(dt_referencia_p::text, '') = '') then
	select	max(trunc(dt_referencia,'month'))
	into STRICT	dt_referencia_w
	from	banco_saldo
	where	nr_seq_conta	= nr_seq_conta_p;
else
	dt_referencia_w	:= trunc(dt_referencia_p,'month');
end if;

select	coalesce(max(vl_saldo),0)
into STRICT	vl_saldo_w
from	banco_saldo
where	nr_seq_conta	= nr_seq_conta_p
and	dt_referencia	= dt_referencia_w;

RETURN vl_saldo_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_saldo_banco ( nr_seq_conta_p bigint, dt_referencia_p timestamp) FROM PUBLIC;

