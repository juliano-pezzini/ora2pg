-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_nome_contrato (nr_seq_contrato_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

					 
ds_retorno_w			varchar(255);

/* Especifica para retornar nome do contrato */
 
	 

BEGIN 
 
	if(nr_seq_contrato_p IS NOT NULL AND nr_seq_contrato_p::text <> '' AND ie_opcao_p IS NOT NULL AND ie_opcao_p::text <> '')then 
 
		select substr(pls_obter_dados_contrato(a.nr_sequencia,ie_opcao_p),1,255) 
		into STRICT ds_retorno_w 
		from pls_contrato a 
		where a.nr_contrato = nr_seq_contrato_p;
		 
	end if;
 
return ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_nome_contrato (nr_seq_contrato_p bigint, ie_opcao_p text) FROM PUBLIC;
