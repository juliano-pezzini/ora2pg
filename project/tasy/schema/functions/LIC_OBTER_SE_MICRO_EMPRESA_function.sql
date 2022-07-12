-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lic_obter_se_micro_empresa ( nr_seq_fornec_p bigint) RETURNS varchar AS $body$
DECLARE


cd_cgc_fornec_w			varchar(14);
ie_microempresa_w			varchar(1) := 'N';


BEGIN

select	cd_cgc_fornec
into STRICT	cd_cgc_fornec_w
from	reg_lic_fornec
where	nr_sequencia = nr_seq_fornec_p;

if (cd_cgc_fornec_w IS NOT NULL AND cd_cgc_fornec_w::text <> '') then

	select	CASE WHEN ie_tipo_tributacao='1' THEN 'S'  ELSE 'N' END
	into STRICT	ie_microempresa_w
	from	pessoa_juridica
	where	cd_cgc = cd_cgc_fornec_w;

end if;

return	ie_microempresa_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lic_obter_se_micro_empresa ( nr_seq_fornec_p bigint) FROM PUBLIC;
