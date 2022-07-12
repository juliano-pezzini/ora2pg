-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_conv_nacional (cd_convenio_p bigint) RETURNS varchar AS $body$
DECLARE



ie_nacional_w	varchar(01)	:= 'C';
nr_seq_pais_w	bigint;
CD_SG_PAIS_w	varchar(3);


BEGIN

select	max(nr_seq_pais)
into STRICT	nr_seq_pais_w
from	convenio a, pessoa_juridica b
where	a.cd_cgc	= b.cd_cgc
and	a.cd_convenio	= cd_convenio_p;

select	max(SG_PAIS)
into STRICT	CD_SG_PAIS_w
from	pais
where	nr_sequencia	= nr_seq_pais_w;


if (upper(CD_SG_PAIS_w) =  'BR') or (upper(CD_SG_PAIS_w) =  'BRA') then
	ie_nacional_w	:= 'S';
elsif (CD_SG_PAIS_w IS NOT NULL AND CD_SG_PAIS_w::text <> '') then
	ie_nacional_w	:= 'N';
else
	ie_nacional_w	:= 'C';
end if;


return	ie_nacional_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_conv_nacional (cd_convenio_p bigint) FROM PUBLIC;
