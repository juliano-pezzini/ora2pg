-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_vol_nut_pac_fase (nr_seq_nut_p bigint, ie_opcao_p bigint) RETURNS bigint AS $body$
DECLARE


qt_volume_w		double precision := 0;
qt_vol_1_fase_w	double precision := 0;
qt_vol_2_fase_w	double precision := 0;
qt_vol_3_fase_w	double precision := 0;


BEGIN
if (nr_seq_nut_p IS NOT NULL AND nr_seq_nut_p::text <> '') and (ie_opcao_p IS NOT NULL AND ie_opcao_p::text <> '') then

	select	sum(coalesce(qt_vol_1_fase,0)),
		sum(coalesce(qt_vol_2_fase,0)),
		sum(coalesce(qt_vol_3_fase,0))
	into STRICT	qt_vol_1_fase_w,
		qt_vol_2_fase_w,
		qt_vol_3_fase_w
	from	nut_paciente_elemento
	where	nr_seq_nut_pac = nr_seq_nut_p;

	if (ie_opcao_p = 0) then
		qt_volume_w := qt_vol_1_fase_w + qt_vol_2_fase_w + qt_vol_3_fase_w;

	elsif (ie_opcao_p = 1) then
		qt_volume_w := qt_vol_1_fase_w;

	elsif (ie_opcao_p = 2) then
		qt_volume_w := qt_vol_2_fase_w;

	elsif (ie_opcao_p = 3) then
		qt_volume_w := qt_vol_3_fase_w;

	end if;
end if;

return qt_volume_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_vol_nut_pac_fase (nr_seq_nut_p bigint, ie_opcao_p bigint) FROM PUBLIC;

