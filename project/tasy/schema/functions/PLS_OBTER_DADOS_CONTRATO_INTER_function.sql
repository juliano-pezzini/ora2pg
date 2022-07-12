-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dados_contrato_inter ( nr_seq_intercambio_p bigint, cd_operadora_empresa_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

/* 
IE_OPCAO_P 
	CE	- Código empresarial do contrato 
	N	- Sequência 
	E    - Estipulante 
*/
 
ds_retorno_w			varchar(255);


BEGIN 
 
if (nr_seq_intercambio_p IS NOT NULL AND nr_seq_intercambio_p::text <> '') then 
	if (ie_opcao_p	= 'CE') then 
		select	cd_operadora_empresa 
		into STRICT		ds_retorno_w 
		from		pls_intercambio 
		where	nr_sequencia	= nr_seq_intercambio_p;
		 
	elsif (ie_opcao_p = 'E') then 
		select 	substr(obter_nome_pf_pj(cd_pessoa_fisica, cd_cgc),1,200) 
		into STRICT		ds_retorno_w 
		from		pls_intercambio 
		where	nr_sequencia	= nr_seq_intercambio_p;
	end if;
elsif (cd_operadora_empresa_p IS NOT NULL AND cd_operadora_empresa_p::text <> '') then 
	if (ie_opcao_p	= 'N') then 
		select	max(nr_sequencia) 
		into STRICT	ds_retorno_w 
		from	pls_intercambio 
		where	cd_operadora_empresa	= cd_operadora_empresa_p;
		 
	elsif (ie_opcao_p = 'E') then 
		select 	substr(obter_nome_pf_pj(cd_pessoa_fisica, cd_cgc),1,200) 
		into STRICT	ds_retorno_w 
		from	pls_intercambio 
		where	cd_operadora_empresa	= cd_operadora_empresa_p  LIMIT 1;
	end if;
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dados_contrato_inter ( nr_seq_intercambio_p bigint, cd_operadora_empresa_p bigint, ie_opcao_p text) FROM PUBLIC;
