-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nr_rgct_dig (cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(20);
nr_rgct_w	bigint;
nr_rgct_dig_w	integer;


BEGIN

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
SELECT	MAX(a.nr_rgct),
	MAX(a.nr_rgct_dig)
INTO STRICT	nr_rgct_w,
	nr_rgct_dig_w
FROM	tx_registro_snt a,
	tx_receptor b
WHERE	a.nr_seq_receptor = b.nr_sequencia
AND	a.ie_status_rgct = 'A'
AND	b.cd_pessoa_fisica = cd_pessoa_fisica_p
AND	a.nr_sequencia = 	(SELECT		  MAX(x.nr_sequencia)
			FROM		  tx_registro_snt x,
					  tx_receptor y
			WHERE		  x.nr_seq_receptor = y.nr_sequencia
			AND		  y.cd_pessoa_fisica = cd_pessoa_fisica_p);

end if;

ds_retorno_w := nr_rgct_w||' - '||nr_rgct_dig_w;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nr_rgct_dig (cd_pessoa_fisica_p text) FROM PUBLIC;

