-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hem_gerar_manometria_js ( ie_manometria_p text, nr_seq_cat_p bigint, qt_psve_p bigint, qt_psao_p bigint, qt_pdao_p bigint, qt_psvd_p bigint, qt_psap_p bigint, qt_pmcp_p bigint, qt_resultado_p INOUT bigint) AS $body$
DECLARE


qt_pd2ve_w	real;


BEGIN

if (ie_manometria_p = 'GVECP') then
	begin
	select	coalesce(max(qt_pd2ve), 0)
	into STRICT	qt_pd2ve_w
	from	hem_cat_ventric
	where	nr_seq_cat = nr_seq_cat_p;
	end;
end if;

qt_resultado_p := hem_gerar_manometria(
	ie_manometria_p, qt_psve_p, qt_psao_p, qt_pdao_p, qt_psvd_p, qt_psap_p, qt_pd2ve_w, qt_pmcp_p, qt_resultado_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hem_gerar_manometria_js ( ie_manometria_p text, nr_seq_cat_p bigint, qt_psve_p bigint, qt_psao_p bigint, qt_pdao_p bigint, qt_psvd_p bigint, qt_psap_p bigint, qt_pmcp_p bigint, qt_resultado_p INOUT bigint) FROM PUBLIC;
