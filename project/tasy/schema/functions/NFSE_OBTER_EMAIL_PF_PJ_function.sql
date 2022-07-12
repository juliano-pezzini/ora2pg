-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION nfse_obter_email_pf_pj (cd_estabelecimento_p bigint, cd_pessoa_fisica_p text, cd_cgc_p text, nr_seq_mensalidade_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(500):= null;
/*
Possveis retorna da funo;
 Return           N/A
 Return           null
 Return          email
*/
BEGIN

if (nr_seq_mensalidade_p IS NOT NULL AND nr_seq_mensalidade_p::text <> '') then
	
	--Obtm o e-mail  cadastrado do mensalista, podendo ele ser PF / PJ
	ds_retorno_w:= nfseops_obter_pf_pj_estab(cd_estabelecimento_p, cd_pessoa_fisica_p, cd_cgc_p, nr_seq_mensalidade_p,'M');
	
	if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') and (upper(ds_retorno_w) <> 'N/D') then
		return ds_retorno_w;
	end if;	
	
elsif (cd_cgc_p IS NOT NULL AND cd_cgc_p::text <> '') and (nr_seq_mensalidade_p is  null) then
	/*
	Busca o e-mail cadastrado da Pessoa Fsica.  
	A busca a ser realizada poder obter o e-mail do cadastrado do estabelecimento da Pessoa Jurdica
	Ou Pegar pelo complemento.
	*/
	ds_retorno_w:= obter_dados_pf_pj_estab(cd_estabelecimento_p, null, cd_cgc_p, 'M');
		
	if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') and (upper(ds_retorno_w) <> 'N/D') then
		return ds_retorno_w;
	end if;
else
        -- Obtm o e-mail do complemento da pessoa fsica
	ds_retorno_w:= nfse_obter_compl_pf(cd_pessoa_fisica_p,'M');
	
	if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then
		  return ds_retorno_w;
	end if;
	
	-- Busca o e-mail do cadastrado da Pessoa Fsica
	ds_retorno_w:= obter_dados_pf_pj(cd_pessoa_fisica_p, null, 'M');
	
	if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then
		 return ds_retorno_w;
	end if;

end if;

return	ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION nfse_obter_email_pf_pj (cd_estabelecimento_p bigint, cd_pessoa_fisica_p text, cd_cgc_p text, nr_seq_mensalidade_p bigint) FROM PUBLIC;

