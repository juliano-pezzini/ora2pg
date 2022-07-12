-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_movto_banco_pend ( nr_seq_movto_trans_financ_p bigint) RETURNS bigint AS $body$
DECLARE


nr_seq_movto_bco_pend_w		bigint;


BEGIN

if (nr_seq_movto_trans_financ_p IS NOT NULL AND nr_seq_movto_trans_financ_p::text <> '') then

	select	max(nr_seq_movto_pend)
	into STRICT	nr_seq_movto_bco_pend_w
	from	movto_banco_pend_baixa
	where	nr_seq_movto_trans_fin	= nr_seq_movto_trans_financ_p;

end if;

return	nr_seq_movto_bco_pend_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_movto_banco_pend ( nr_seq_movto_trans_financ_p bigint) FROM PUBLIC;

