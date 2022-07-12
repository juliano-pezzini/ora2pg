-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tipo_documento ( nr_seq_tipo_doc_p bigint) RETURNS varchar AS $body$
DECLARE


ds_documento_w  TIPO_DOCUMENTO_FORNEC.DS_TIPO_DOCUMENTO%type;


BEGIN

SELECT DS_TIPO_DOCUMENTO
INTO STRICT ds_documento_w
FROM TIPO_DOCUMENTO_FORNEC 
WHERE NR_SEQUENCIA = nr_seq_tipo_doc_p;


return ds_documento_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tipo_documento ( nr_seq_tipo_doc_p bigint) FROM PUBLIC;

