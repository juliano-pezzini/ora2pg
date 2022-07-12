-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_proc_tab_interno_hemo (nr_seq_producao_p bigint) RETURNS bigint AS $body$
DECLARE


vl_proc_interno_w	bigint := null;
cd_procedimento_w	bigint;
nr_seq_proc_interno_w	bigint;

BEGIN
if (nr_seq_producao_p IS NOT NULL AND nr_seq_producao_p::text <> '') then

	select	max(x.cd_procedimento),
		max(x.nr_seq_proc_interno)
	into STRICT	cd_procedimento_w,
		nr_seq_proc_interno_w
	from	san_derivado b,
		san_producao a,
		san_derivado_convenio x
	where	1 = 1
	and	a.nr_seq_derivado 		= b.nr_sequencia
	and	x.nr_seq_derivado		= b.nr_sequencia
	and	coalesce(x.ie_irradiado,'N')		= coalesce(a.ie_irradiado,'N')
	and	coalesce(x.ie_lavado,'N')		= coalesce(a.ie_lavado,'N')
	and	coalesce(x.ie_filtrado,'N')		= coalesce(a.ie_filtrado,'N')
	and	coalesce(x.ie_aliquotado,'N')	= coalesce(a.ie_aliquotado,'N')
	and	coalesce(x.ie_aferese,'N')		= coalesce(a.ie_aferese,'N')
	and	coalesce(x.dt_inicio_vigencia,clock_timestamp())		<= clock_timestamp()
	and	a.nr_sequencia					= nr_seq_producao_p;

	vl_proc_interno_w	:= coalesce(nr_seq_proc_interno_w, cd_procedimento_w);
end if;

return	vl_proc_interno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_proc_tab_interno_hemo (nr_seq_producao_p bigint) FROM PUBLIC;

