-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tiss_obter_xml_projeto2 (cd_convenio_p bigint, cd_estabelecimento_p bigint, ie_tipo_tiss_p text, dt_referencia_p timestamp default null) RETURNS bigint AS $body$
DECLARE


nr_seq_xml_projeto_w	bigint;
ie_tipo_convenio_w	bigint;
dt_inicio_vigencia_w	timestamp;


c01 CURSOR FOR
SELECT	nr_seq_xml_projeto
from	tiss_convenio a
where	coalesce(a.cd_convenio, cd_convenio_p)		= cd_convenio_p
and	a.cd_estabelecimento				= cd_estabelecimento_p
and	a.ie_tipo_tiss					= ie_tipo_tiss_p
and	coalesce(a.ie_tipo_convenio,ie_tipo_convenio_w)	= ie_tipo_convenio_w
and	coalesce(a.nr_seq_outorgante::text, '') = ''
and 	coalesce(a.dt_inicio_vigencia,clock_timestamp()) = dt_inicio_vigencia_w
order 	by coalesce(cd_convenio, 0),
	dt_inicio_vigencia,
	coalesce(a.ie_tipo_convenio,0);


BEGIN

select	max(ie_tipo_convenio)
into STRICT	ie_tipo_convenio_w
from	convenio
where	cd_convenio	= cd_convenio_p;

begin
select	coalesce(max(x.dt_inicio_vigencia),clock_timestamp())
into STRICT	dt_inicio_vigencia_w
from	tiss_convenio x
where	coalesce(x.cd_convenio,cd_convenio_p)		= cd_convenio_p
and	x.cd_estabelecimento				= cd_estabelecimento_p
and	x.ie_tipo_tiss					= ie_tipo_tiss_p
and	coalesce(x.ie_tipo_convenio,ie_tipo_convenio_w)	= ie_tipo_convenio_w
and	coalesce(x.nr_seq_outorgante::text, '') = ''
and	coalesce(x.dt_inicio_vigencia,coalesce(dt_referencia_p,clock_timestamp())) <= coalesce(dt_referencia_p,clock_timestamp());
exception
when others then
	dt_inicio_vigencia_w := clock_timestamp();
end;

open c01;
loop
fetch c01 into
	nr_seq_xml_projeto_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
end loop;
close c01;

return	nr_seq_xml_projeto_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tiss_obter_xml_projeto2 (cd_convenio_p bigint, cd_estabelecimento_p bigint, ie_tipo_tiss_p text, dt_referencia_p timestamp default null) FROM PUBLIC;

