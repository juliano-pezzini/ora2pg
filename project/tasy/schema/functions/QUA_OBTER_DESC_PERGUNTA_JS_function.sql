-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION qua_obter_desc_pergunta_js (nr_sequencia_p bigint, nr_seq_documento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_pergunta_w	varchar(4000);


BEGIN

if (coalesce(nr_sequencia_p,0) > 0) then

	select	substr(ds_pergunta,1,4000)
	into STRICT	ds_pergunta_w
	from   	qua_doc_questionario
	where	nr_sequencia = nr_sequencia_p
	and	nr_seq_documento = nr_seq_documento_p;

end if;

return	ds_pergunta_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION qua_obter_desc_pergunta_js (nr_sequencia_p bigint, nr_seq_documento_p bigint) FROM PUBLIC;

