-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_tipo_divergencia ( nr_sequencia_p bigint, ie_tipo_p text default 'DS') RETURNS varchar AS $body$
DECLARE


ds_tipo_divergencia_w			varchar(80);
ie_tipo_divergencia_w			inspecao_tipo_divergencia.ie_tipo_divergencia%type;

ds_retorno_w				varchar(255);


BEGIN

if (ie_tipo_p = 'DS') then

	select	ds_tipo_divergencia
	into STRICT	ds_tipo_divergencia_w
	from	inspecao_tipo_divergencia
	where	nr_sequencia = nr_sequencia_p;

	ds_retorno_w := substr(ds_tipo_divergencia_w,1,80);

elsif (ie_tipo_p = 'IE') then

	select	ie_tipo_divergencia
	into STRICT	ie_tipo_divergencia_w
	from	inspecao_tipo_divergencia
	where	nr_sequencia = nr_sequencia_p;

	ds_retorno_w := ie_tipo_divergencia_w;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_tipo_divergencia ( nr_sequencia_p bigint, ie_tipo_p text default 'DS') FROM PUBLIC;

