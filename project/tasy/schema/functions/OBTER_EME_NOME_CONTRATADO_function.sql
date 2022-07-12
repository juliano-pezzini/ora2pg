-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_eme_nome_contratado ( nr_seq_contrato_p bigint, ie_opcao_p text default 'P') RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w			varchar(100);
ds_evento_w			varchar(80);
ds_nome_contrato_w		varchar(80);

-- P -> Pessoa juridica/Fisica contratada 
--N -> Nome do contrato 
 

BEGIN 
 
select	obter_nome_pf_pj(cd_pessoa_fisica,cd_cgc), 
	ds_evento, 
	nm_contrato 
into STRICT	ds_retorno_w, 
	ds_evento_w, 
	ds_nome_contrato_w 
from	eme_contrato 
where	nr_sequencia = nr_seq_contrato_p;
 
if (ie_opcao_p = 'N') then 
	ds_retorno_w := ds_nome_contrato_w;
end if;
 
 
RETURN	ds_retorno_w;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_eme_nome_contratado ( nr_seq_contrato_p bigint, ie_opcao_p text default 'P') FROM PUBLIC;

