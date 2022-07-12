-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_tipo_gp_grupo_apap (nr_seq_grupo_gp_p bigint, nr_seq_tipo_gp_p bigint, nr_seq_grupo_apap_p bigint) RETURNS varchar AS $body$
DECLARE


ie_apap_w	varchar(1);


BEGIN
if (nr_seq_grupo_gp_p IS NOT NULL AND nr_seq_grupo_gp_p::text <> '') and (nr_seq_tipo_gp_p IS NOT NULL AND nr_seq_tipo_gp_p::text <> '') and (nr_seq_grupo_apap_p IS NOT NULL AND nr_seq_grupo_apap_p::text <> '') then

	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_apap_w
	from	pep_apap_inf
	where	nr_seq_grupo_apap	= nr_seq_grupo_apap_p
	and	nr_seq_grupo_pg	= nr_seq_grupo_gp_p
	and	nr_seq_tipo_pg	= nr_seq_tipo_gp_p;

end if;

return ie_apap_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_tipo_gp_grupo_apap (nr_seq_grupo_gp_p bigint, nr_seq_tipo_gp_p bigint, nr_seq_grupo_apap_p bigint) FROM PUBLIC;

