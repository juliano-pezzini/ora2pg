-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_tipo_doc_far ( nr_sequencia_p bigint, ie_tipo_p text) RETURNS varchar AS $body$
DECLARE


nm_documento_w		varchar(100);
nr_seq_tipo_avaliacao_w	bigint;
ds_retorno_w		varchar(255);


BEGIN

select 	max(nm_documento),
	max(nr_seq_tipo_avaliacao)
into STRICT	nm_documento_w,
	nr_seq_tipo_avaliacao_w
from	tipo_documento_farmacia
where	nr_sequencia = nr_sequencia_p;

if (ie_tipo_p = 'DS') then
	ds_retorno_w := nm_documento_w;
elsif (ie_tipo_p = 'AV') then
	ds_retorno_w := nr_seq_tipo_avaliacao_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_tipo_doc_far ( nr_sequencia_p bigint, ie_tipo_p text) FROM PUBLIC;
