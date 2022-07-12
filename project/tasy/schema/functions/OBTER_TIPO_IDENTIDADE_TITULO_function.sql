-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tipo_identidade_titulo ( nr_cd_pessoa_fisica_p TITULO_PAGAR.CD_PESSOA_FISICA%type ) RETURNS varchar AS $body$
DECLARE


ds_retorno_w PESSOA_FISICA.NR_CERT_NASC%type;


BEGIN

ds_retorno_w :='';

select max(obter_valor_dominio(10438, b.nr_seq_tipo_doc_identificacao))
into STRICT ds_retorno_w
from pessoa_fisica_aux b 
where b.cd_pessoa_fisica = nr_cd_pessoa_fisica_p;

RETURN ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tipo_identidade_titulo ( nr_cd_pessoa_fisica_p TITULO_PAGAR.CD_PESSOA_FISICA%type ) FROM PUBLIC;

