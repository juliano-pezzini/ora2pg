-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_usuario_status_leito (nr_seq_interno_p bigint, ie_status_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w 	varchar(255);


BEGIN

SELECT	MAX(nm_usuario)
INTO STRICT	ds_retorno_w
FROM	unidade_atend_hist
WHERE	nr_seq_unidade		= nr_seq_interno_p
AND	ie_status_unidade 	= ie_status_p;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_usuario_status_leito (nr_seq_interno_p bigint, ie_status_p text) FROM PUBLIC;
