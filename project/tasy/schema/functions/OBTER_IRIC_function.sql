-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_iric ( ie_asa_p text, cd_tipo_cirurgia_p bigint, nr_seq_proc_interno_p bigint, qt_min_cirurgia_p bigint, nr_seq_proced_niss_p bigint) RETURNS bigint AS $body$
DECLARE


qt_iric_w	smallint;


BEGIN

if (ie_asa_p IS NOT NULL AND ie_asa_p::text <> '') and (cd_tipo_cirurgia_p IS NOT NULL AND cd_tipo_cirurgia_p::text <> '')  and ((nr_seq_proc_interno_p IS NOT NULL AND nr_seq_proc_interno_p::text <> '') or (nr_seq_proced_niss_p IS NOT NULL AND nr_seq_proced_niss_p::text <> '')) and (qt_min_cirurgia_p IS NOT NULL AND qt_min_cirurgia_p::text <> '') then
	begin
	select	CASE WHEN ie_asa_p='I' THEN 0 WHEN ie_asa_p='II' THEN 0  ELSE 1 END  + CASE WHEN cd_tipo_cirurgia_p=3 THEN 1 WHEN cd_tipo_cirurgia_p=4 THEN 1  ELSE 0 END  +
		obter_indice_cut_point(qt_min_cirurgia_p,nr_seq_proc_interno_p, nr_seq_proced_niss_p)
	into STRICT	qt_iric_w
	;
	exception
	when others then
		qt_iric_w	:= null;
	end;
else
	qt_iric_w	:= null;
end if;

return	qt_iric_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_iric ( ie_asa_p text, cd_tipo_cirurgia_p bigint, nr_seq_proc_interno_p bigint, qt_min_cirurgia_p bigint, nr_seq_proced_niss_p bigint) FROM PUBLIC;
