-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_auxiliar_manipulador_dia (cd_manipulador_p text, dt_auxilio_p timestamp) RETURNS varchar AS $body$
DECLARE


cd_auxiliar_w	varchar(10);


BEGIN
if (cd_manipulador_p IS NOT NULL AND cd_manipulador_p::text <> '') and (dt_auxilio_p IS NOT NULL AND dt_auxilio_p::text <> '') then
	select	max(b.cd_auxiliar)
	into STRICT	cd_auxiliar_w
	from	can_ordem_prod b,
		far_etapa_producao a
	where	b.nr_seq_etapa_prod = a.nr_sequencia
	and	b.cd_manipulador = cd_manipulador_p
	and	a.dt_etapa = dt_auxilio_p
	and	(b.cd_auxiliar IS NOT NULL AND b.cd_auxiliar::text <> '');
end if;

return cd_auxiliar_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_auxiliar_manipulador_dia (cd_manipulador_p text, dt_auxilio_p timestamp) FROM PUBLIC;
