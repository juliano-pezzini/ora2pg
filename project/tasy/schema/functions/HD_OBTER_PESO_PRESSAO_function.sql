-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hd_obter_peso_pressao ( cd_pessoa_fisica_p text, dt_dia_p timestamp) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(2) := '';


BEGIN

select	coalesce(max(ie_pressao || ie_peso), null)
into STRICT	ds_retorno_w
from	hd_prc_avaliacao a,
	hd_dialise b
where	b.nr_sequencia		= a.nr_seq_dialise
and	b.cd_pessoa_fisica	= cd_pessoa_fisica_p
and	trunc(dt_avaliacao)	= trunc(dt_dia_p);

return	ds_retorno_w;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hd_obter_peso_pressao ( cd_pessoa_fisica_p text, dt_dia_p timestamp) FROM PUBLIC;
