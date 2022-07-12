-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_template_registro ( nr_seq_registro_p bigint, nr_seq_template_p bigint) RETURNS varchar AS $body$
DECLARE


ie_temp_reg_w	varchar(1) := 'N';


BEGIN
if (nr_seq_registro_p IS NOT NULL AND nr_seq_registro_p::text <> '') and (nr_seq_template_p IS NOT NULL AND nr_seq_template_p::text <> '') then

	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_temp_reg_w
	from	ehr_reg_template
	where	nr_seq_reg	= nr_seq_registro_p
	and	nr_seq_template	= nr_seq_template_p;

end if;

return ie_temp_reg_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_template_registro ( nr_seq_registro_p bigint, nr_seq_template_p bigint) FROM PUBLIC;

