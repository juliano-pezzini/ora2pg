-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_destinatario ( NR_SEQ_DESTINATARIO_P bigint default null) RETURNS varchar AS $body$
DECLARE


DS_RETORNO_W	varchar(255);


BEGIN

	SELECT 	MAX(NM_DESTINATARIO)
	INTO STRICT	DS_RETORNO_W
	FROM	DESTINATARIO_CARTA_MEDICA
	WHERE nr_sequencia = NR_SEQ_DESTINATARIO_P;

	return DS_RETORNO_W;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_destinatario ( NR_SEQ_DESTINATARIO_P bigint default null) FROM PUBLIC;
