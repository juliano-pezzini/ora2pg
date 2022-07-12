-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_tipo_doc_orc (nr_seq_tipo_doc_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(200);


BEGIN

select 	coalesce(max(ds_documento),wheb_mensagem_pck.get_texto(312153))
into STRICT	ds_retorno_w
from 	tipo_documento_orc
where 	nr_sequencia = nr_seq_tipo_doc_p;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_tipo_doc_orc (nr_seq_tipo_doc_p bigint) FROM PUBLIC;

