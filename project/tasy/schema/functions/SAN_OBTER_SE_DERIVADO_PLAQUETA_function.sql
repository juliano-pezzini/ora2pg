-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION san_obter_se_derivado_plaqueta ( nr_seq_derivado_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w	varchar(3);


BEGIN

if (nr_seq_derivado_p IS NOT NULL AND nr_seq_derivado_p::text <> '') then

	select 	CASE WHEN coalesce(ie_tipo_derivado,ie_tipo_hemocomponente)='CP' THEN 'S'  ELSE 'N' END
	into STRICT	ie_retorno_w
	from	san_derivado
	where	nr_sequencia	= nr_seq_derivado_p;

end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION san_obter_se_derivado_plaqueta ( nr_seq_derivado_p bigint) FROM PUBLIC;

