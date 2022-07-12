-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_nm_usuario_web ( nr_seq_usuario_web_p integer) RETURNS varchar AS $body$
DECLARE


nm_retorno_w			varchar(60);


BEGIN

select	coalesce(max(nm_usuario_web),'')
into STRICT	nm_retorno_w
from	pls_usuario_web
where	nr_sequencia	= nr_seq_usuario_web_p;

return	nm_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_nm_usuario_web ( nr_seq_usuario_web_p integer) FROM PUBLIC;

