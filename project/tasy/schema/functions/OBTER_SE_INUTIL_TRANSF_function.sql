-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_inutil_transf (nr_seq_transfusao_p bigint, nr_seq_inutil_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(15);
dt_inutilizacao_w	timestamp;
dt_transfusao_w		timestamp;


BEGIN

if (nr_seq_inutil_p IS NOT NULL AND nr_seq_inutil_p::text <> '') then

	SELECT  MAX(x.dt_inutilizacao)
	INTO STRICT	dt_inutilizacao_w
        	FROM	san_inutilizacao x
        	WHERE	x.nr_sequencia = nr_seq_inutil_p;

end if;

if (nr_seq_transfusao_p IS NOT NULL AND nr_seq_transfusao_p::text <> '') then

	SELECT 	MAX(z.dt_transfusao)
	INTO STRICT	dt_transfusao_w
        	FROM    	san_transfusao z
       	WHERE  z.nr_sequencia = nr_seq_transfusao_p;

end if;

if (dt_inutilizacao_w IS NOT NULL AND dt_inutilizacao_w::text <> '') then
	ds_retorno_w := Wheb_mensagem_pck.get_texto(309832); --'Inutilizada';
elsif (dt_transfusao_w IS NOT NULL AND dt_transfusao_w::text <> '') then
	ds_retorno_w := Wheb_mensagem_pck.get_texto(309833); --'Transfundida';
else
	ds_retorno_w := '';

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_inutil_transf (nr_seq_transfusao_p bigint, nr_seq_inutil_p bigint) FROM PUBLIC;

