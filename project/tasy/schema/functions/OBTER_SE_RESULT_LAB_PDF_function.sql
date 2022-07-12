-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_result_lab_pdf (nr_seq_resultado_p bigint) RETURNS varchar AS $body$
DECLARE


ie_existe_pdf_w varchar(1) := 'N';


BEGIN

if (nr_seq_resultado_p IS NOT NULL AND nr_seq_resultado_p::text <> '') then
	select CASE WHEN count(1)=0 THEN  'N'  ELSE 'S' END
	into STRICT ie_existe_pdf_w
	from result_laboratorio_pdf
	where nr_seq_resultado = nr_seq_resultado_p
	and (ds_pdf_serial IS NOT NULL AND ds_pdf_serial::text <> '');
end if;

return ie_existe_pdf_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_result_lab_pdf (nr_seq_resultado_p bigint) FROM PUBLIC;

