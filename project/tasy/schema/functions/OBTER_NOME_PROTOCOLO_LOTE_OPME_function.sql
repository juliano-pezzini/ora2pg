-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nome_protocolo_lote_opme (nr_lote_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w		varchar(255);


BEGIN

IF (nr_lote_p IS NOT NULL AND nr_lote_p::text <> '') THEN
	SELECT MAX(b.nm_protocolo)
	INTO STRICT	ie_retorno_w
	FROM 	lote_producao_comp a,
		protocolo_fornec_opme b
	WHERE 	nr_seq_protocolo = b.nr_sequencia
	AND  	a.nr_lote_producao = nr_lote_p;

END IF;


RETURN ie_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nome_protocolo_lote_opme (nr_lote_p bigint) FROM PUBLIC;

