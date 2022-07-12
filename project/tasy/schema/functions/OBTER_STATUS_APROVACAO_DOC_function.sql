-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_status_aprovacao_doc (nm_tabela_p text, qt_chave_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(100);


BEGIN

begin
select	max(ie_status)
into STRICT	ds_retorno_w
from	documento_aprovacao
where	nr_seq_origem	= qt_chave_p and nm_tabela_origem = nm_tabela_p
and coalesce(ie_situacao,'X') <> 'I';
exception when no_data_found then
ds_retorno_w := 'I';
end;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_status_aprovacao_doc (nm_tabela_p text, qt_chave_p bigint) FROM PUBLIC;

