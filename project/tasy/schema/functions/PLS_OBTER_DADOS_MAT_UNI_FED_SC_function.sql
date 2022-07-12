-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dados_mat_uni_fed_sc (cd_material_p bigint, cd_fornecedor_p bigint, cd_grupo_estoque_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

							 
/* ATENÇÃO ! FUNCTION EXCLUSIVA PARA OBTER DADOS DA IMPORTAÇÃO DE MATERIAIS DA UNIMED FEDERAÇÃO SC */
 
 
ds_retorno_w		varchar(255);			
nr_seq_prestador_w	bigint;			
/*============ Opções =====================*/
 
/*   'NF'   -  Nome do Fornecedor		*/
 
/*   'NAF' -  Nome Abreviado do Fornecedor	*/
 
/*   'NG'  -  Nome do Grupo		*/
 
/*   'NFP'  -  Nome do Fornecedor Prestador	*/
 
/*========================================*/
			 
			 

BEGIN 
ds_retorno_w	:= null;
 
if (cd_fornecedor_p IS NOT NULL AND cd_fornecedor_p::text <> '') and (ie_opcao_p IS NOT NULL AND ie_opcao_p::text <> '') then 
	 
	if (ie_opcao_p	= 'NF') then 
		select	substr(max(nm_fornecedor),1,255) 
		into STRICT	ds_retorno_w 
		from	pls_fornec_mat_fed_sc 
		where	cd_fornecedor	= cd_fornecedor_p;	
	end if;
	 
	if (ie_opcao_p	= 'NAF') then 
		select	coalesce(max(nm_abreviado),substr(abrevia_nome(max(nm_fornecedor),null),1,255)) 
		into STRICT	ds_retorno_w 
		from	pls_fornec_mat_fed_sc 
		where	cd_fornecedor	= cd_fornecedor_p;
	end if;
	 
	if (ie_opcao_p = 'NFP') then 
		begin 
		select 	(substr(pls_obter_prestador_fornecedor(cd_fornecedor_p),1,20))::numeric  
		into STRICT	nr_seq_prestador_w 
		;
		exception 
		when others then			 
			select	substr(max(nm_fornecedor),1,255) 
			into STRICT	ds_retorno_w 
			from	pls_fornec_mat_fed_sc 
			where	cd_fornecedor	= cd_fornecedor_p;
		end;
		/*obtem nome interno do prestador*/
 
		select	substr(pls_obter_dados_prestador(nr_seq_prestador_w,'N'),1,255) 
		into STRICT	ds_retorno_w		 
		;
		 
		if (coalesce(ds_retorno_w::text, '') = '') then 
			/*obtem nome abreviado do fornecedor */
 
			select	substr(max(nm_abreviado),1,255) 
			into STRICT	ds_retorno_w 
			from	pls_fornec_mat_fed_sc 
			where	cd_fornecedor	= cd_fornecedor_p;
		end if;
		if (coalesce(ds_retorno_w::text, '') = '') then 
			/*obtem nome do fornecedor */
 
			select	substr(max(nm_fornecedor),1,255) 
			into STRICT	ds_retorno_w 
			from	pls_fornec_mat_fed_sc 
			where	cd_fornecedor	= cd_fornecedor_p;				
		end if;		
	end if;			
 
elsif (cd_grupo_estoque_p IS NOT NULL AND cd_grupo_estoque_p::text <> '') and (ie_opcao_p IS NOT NULL AND ie_opcao_p::text <> '') then 
	 
	if (ie_opcao_p	= 'NG') then 
		select	substr(max(ds_grupo_estoque),1,255) 
		into STRICT	ds_retorno_w 
		from	pls_grupo_est_fed_sc 
		where	cd_grupo_estoque	= cd_grupo_estoque_p;	
	end if;	
	 
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dados_mat_uni_fed_sc (cd_material_p bigint, cd_fornecedor_p bigint, cd_grupo_estoque_p bigint, ie_opcao_p text) FROM PUBLIC;

