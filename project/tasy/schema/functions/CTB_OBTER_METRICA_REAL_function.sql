-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ctb_obter_metrica_real ( cd_estabelecimento_p bigint, cd_centro_custo_p bigint, nr_seq_metrica_p bigint, nr_seq_mes_ref_p bigint) RETURNS bigint AS $body$
DECLARE


qt_metrica_real_w			double precision;

BEGIN

if (nr_seq_metrica_p IS NOT NULL AND nr_seq_metrica_p::text <> '') and (nr_seq_mes_ref_p IS NOT NULL AND nr_seq_mes_ref_p::text <> '') then

	select	coalesce(sum(qt_metrica_real),0)
	into STRICT	qt_metrica_real_w
	from	ctb_metrica_real
	where	cd_estabelecimento	= cd_estabelecimento_p
	and	cd_centro_custo	= cd_centro_custo_p
	and	nr_seq_metrica	= nr_seq_metrica_p
	and	nr_seq_mes_ref	= nr_seq_mes_ref_p;

end if;

return coalesce(qt_metrica_real_w,0);

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ctb_obter_metrica_real ( cd_estabelecimento_p bigint, cd_centro_custo_p bigint, nr_seq_metrica_p bigint, nr_seq_mes_ref_p bigint) FROM PUBLIC;
