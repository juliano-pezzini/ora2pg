-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION qua_obter_se_existe_valid_doc ( nr_seq_documento_p bigint) RETURNS varchar AS $body$
DECLARE


qt_existe_w	bigint;
ie_retorno_w	varchar(1);


BEGIN

ie_retorno_w	:= 'N';

select	count(*)
into STRICT	qt_existe_w
from	qua_documento
where	nr_sequencia = nr_seq_documento_p
and	(cd_pessoa_validacao IS NOT NULL AND cd_pessoa_validacao::text <> '');

if (qt_existe_w = 0) then
	begin

	select	count(*)
	into STRICT	qt_existe_w
	from	qua_doc_validacao
	where	nr_seq_doc = nr_seq_documento_p
	and	((cd_pessoa_validacao IS NOT NULL AND cd_pessoa_validacao::text <> '') or (cd_cargo IS NOT NULL AND cd_cargo::text <> ''));

	if (qt_existe_w > 0) then
		ie_retorno_w	:= 'S';
	end if;

	end;
else
	ie_retorno_w	:= 'S';
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION qua_obter_se_existe_valid_doc ( nr_seq_documento_p bigint) FROM PUBLIC;

