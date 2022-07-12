-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION macros_envio_email_etapa () RETURNS varchar AS $body$
DECLARE


ds_mensagem_w				varchar(255);

/*  Macros disponiveis

ETAPA ORIGEM
ETAPA DESTINO
NÚMERO LOTE
QUANTIDADE CONTA
VALOR TOTAL
*/
BEGIN

ds_mensagem_w := '@ETAPA_ORIGEM' || chr(13) ||chr(10) ||
		 '@ETAPA_DESTINO' || chr(13) ||chr(10) ||
		 '@NUMERO_LOTE' || chr(13) ||chr(10) ||
		 '@QTDE_CONTA' || chr(13) ||chr(10) ||
		 '@VALOR_TOTAL';

return	ds_mensagem_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION macros_envio_email_etapa () FROM PUBLIC;
