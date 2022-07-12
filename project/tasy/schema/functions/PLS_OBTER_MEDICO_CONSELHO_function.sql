-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_medico_conselho ( nr_conselho_p text, nr_seq_conselho_p text) RETURNS varchar AS $body$
DECLARE


cd_retorno_w			varchar(255);


BEGIN

select	max(a.cd_pessoa_fisica)
into STRICT	cd_retorno_w
from	pessoa_fisica		a,
	medico			b
where	a.nr_seq_conselho	= nr_seq_conselho_p
and	a.cd_pessoa_fisica	= b.cd_pessoa_fisica
and	b.nr_crm 		= nr_conselho_p
and	b.ie_situacao		<> 'I';

return	cd_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_medico_conselho ( nr_conselho_p text, nr_seq_conselho_p text) FROM PUBLIC;
