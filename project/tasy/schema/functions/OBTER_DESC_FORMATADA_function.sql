-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_formatada ( ds_texto_p text, ie_formato_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(4000);

/*
ie_formato_p
N	= Negrito
I	= Itálico
S	= Sublinhado
K	= Hachurada

*/
BEGIN


ds_retorno_w	:= '#' || ds_texto_p || '#' || ie_formato_p ||'#P';


RETURN ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_formatada ( ds_texto_p text, ie_formato_p text) FROM PUBLIC;
