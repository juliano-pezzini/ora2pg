-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_lotes_interf_sib ( nr_seq_segurado_p bigint, dt_referencia_p timestamp) RETURNS varchar AS $body$
DECLARE


qt_lote_w	bigint;


BEGIN

if (nr_seq_segurado_p IS NOT NULL AND nr_seq_segurado_p::text <> '') and (dt_referencia_p IS NOT NULL AND dt_referencia_p::text <> '') then

	select	count(1)
	into STRICT	qt_lote_w
	from	pls_interf_sib a,
		pls_lote_sib   b
	where	nr_seq_segurado		= nr_seq_segurado_p
	and	a.nr_seq_lote_sib 	= b.nr_sequencia
	and	b.dt_mesano_referencia 	= dt_referencia_p  LIMIT 1;

	if (qt_lote_w > 0) then
		return 'S';
	else
		return 'N';
	end if;

end if;

return 'N';

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_lotes_interf_sib ( nr_seq_segurado_p bigint, dt_referencia_p timestamp) FROM PUBLIC;

