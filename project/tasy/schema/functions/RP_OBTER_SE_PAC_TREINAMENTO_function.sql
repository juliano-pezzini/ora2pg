-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rp_obter_se_pac_treinamento (nr_seq_pac_reab_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w	varchar(1);


BEGIN

if (nr_seq_pac_reab_p IS NOT NULL AND nr_seq_pac_reab_p::text <> '') then

	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_retorno_w
	from	rp_tipo_pac_reab a,
		rp_tipo_paciente b
	where	a.nr_tipo_pac_reab = b.nr_sequencia
	and	coalesce(ie_tipo_treinamento,'N') = 'S'
	and	clock_timestamp() between a.dt_inicio_tipo and coalesce(dt_fim_tipo,clock_timestamp())
	and	a.nr_seq_pac_reab = nr_seq_pac_reab_p;
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rp_obter_se_pac_treinamento (nr_seq_pac_reab_p bigint) FROM PUBLIC;
