-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_data_nota_credito (nr_seq_nota_credito_p bigint, ie_opcao_p text) RETURNS timestamp AS $body$
DECLARE


/* ie_opcao_p
'DT'		Data da nota de crédito		dt_nota_credito
'DV'		Data de vencimento		dt_vencimento
*/
ds_retorno_w		timestamp;
dt_nota_credito_w	          	timestamp;
dt_vencimento_w		timestamp;


BEGIN

SELECT	a.dt_nota_credito,
	a.dt_vencimento
INTO STRICT	dt_nota_credito_w,
	dt_vencimento_w
FROM	nota_credito a
WHERE	a.nr_sequencia	= nr_seq_nota_credito_p;


IF (ie_opcao_p	= 'DT') THEN
	ds_retorno_w	:= dt_nota_credito_w;
ELSIF (ie_opcao_p	= 'DV') THEN
	ds_retorno_w	:= dt_vencimento_w;
END IF;

RETURN ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_data_nota_credito (nr_seq_nota_credito_p bigint, ie_opcao_p text) FROM PUBLIC;
