-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_compl_pf_tipo ( cd_pessoa_fisica_p text, ie_tipo_complemento_p bigint, ie_descricao_p text ) RETURNS varchar AS $body$
DECLARE

			 
/* 
 Ao contrário da obter_compl_pf essa function verifica primeiro se existe o registro na pessoa física e caso não exista pega a informação 
 do complemento, na obter_compl_pf pega primeiro do complemento e depois da pessoa física 
  
  ie_tipo_complemento_p 
 
  1 - residencial 
  2 - comercial 
  3 - responsável 
  4 - pai 
  5 - mãe 
  6 - conjuge 
  7 - comercial 2 
  
  ie_descricao_p 
  
  n - nome 
  t - telefone 
  c - nº cpf 
  i - nº identidade 
  ci - cidade 
  uf - estado 
  cep - cep 
  
*/
 
 
ds_descricao_w			varchar(255) := '';


BEGIN 
 
begin 
 
	if (coalesce(ie_tipo_complemento_p,0) > 0) and (coalesce(cd_pessoa_fisica_p,0) > 0) then 
		begin 
		 
		IF (ie_descricao_p = 'N') THEN 
 
			select	max(coalesce(nm_pessoa,'')) 
			into STRICT	ds_descricao_w 
			from (SELECT	max(b.nm_contato)	nm_pessoa 
			from	compl_pessoa_fisica b 
			where	b.cd_pessoa_fisica = cd_pessoa_fisica_p 
			and (select max(obter_nome_pf(c.cd_pessoa_fisica)) 
				from	pessoa_fisica c 
				where	c.cd_pessoa_fisica = cd_pessoa_fisica_p) is null 
			and	b.ie_tipo_complemento = ie_tipo_complemento_p 
			
union all
 
			SELECT	max(substr(obter_nome_pf(a.cd_pessoa_fisica), 1, 255)) nm_pessoa 
			from	pessoa_fisica a 
			where	a.cd_pessoa_fisica = cd_pessoa_fisica_p) alias14;
			 
 
		ELSIF (ie_descricao_p = 'T') THEN 
 
			select	max(coalesce(nr_telefone,'')) 
			into STRICT	ds_descricao_w 
			from (SELECT	max(b.nr_telefone)	nr_telefone 
			from	compl_pessoa_fisica b 
			where	b.cd_pessoa_fisica = cd_pessoa_fisica_p 
			and	b.ie_tipo_complemento = ie_tipo_complemento_p) alias4;
 
		ELSIF (ie_descricao_p = 'C') THEN 
 
			select	max(coalesce(nr_cpf,'')) 
			into STRICT	ds_descricao_w 
			from (SELECT	max(b.nr_cpf)	nr_cpf 
			from	compl_pessoa_fisica b 
			where	b.cd_pessoa_fisica = cd_pessoa_fisica_p 
			and (select max(c.nr_cpf) 
				from	pessoa_fisica c 
				where	c.cd_pessoa_fisica = cd_pessoa_fisica_p) is null 
			and	b.ie_tipo_complemento = ie_tipo_complemento_p 
			
union all
 
			SELECT	max(a.nr_cpf) nr_cpf 
			from	pessoa_fisica a 
			where	a.cd_pessoa_fisica = cd_pessoa_fisica_p) alias7;
 
 
		ELSIF (ie_descricao_p = 'I') THEN 
 
			select	max(coalesce(nr_identidade,'')) 
			into STRICT	ds_descricao_w 
			from (SELECT	max(b.nr_identidade)	nr_identidade 
			from	compl_pessoa_fisica b 
			where	b.cd_pessoa_fisica = cd_pessoa_fisica_p 
			and (select max(c.nr_identidade) 
				from	pessoa_fisica c 
				where	c.cd_pessoa_fisica = cd_pessoa_fisica_p) is null 
			and	b.ie_tipo_complemento = ie_tipo_complemento_p 
			
union all
 
			SELECT	max(a.nr_identidade) nr_identidade 
			from	pessoa_fisica a 
			where	a.cd_pessoa_fisica = cd_pessoa_fisica_p) alias7;
 
		ELSIF (ie_descricao_p = 'CI') THEN 
 
			select	max(coalesce(ds_municipio,'')) 
			into STRICT	ds_descricao_w 
			from (SELECT	max(b.ds_municipio)	ds_municipio 
			from	compl_pessoa_fisica b 
			where	b.cd_pessoa_fisica = cd_pessoa_fisica_p 
			and	b.ie_tipo_complemento = ie_tipo_complemento_p) alias4;
 
		ELSIF (ie_descricao_p = 'UF') THEN 
 
			select	max(coalesce(sg_estado,'')) 
			into STRICT	ds_descricao_w 
			from (SELECT	max(b.sg_estado)	sg_estado 
			from	compl_pessoa_fisica b 
			where	b.cd_pessoa_fisica = cd_pessoa_fisica_p 
			and	b.ie_tipo_complemento = ie_tipo_complemento_p) alias4;
 
		ELSIF (ie_descricao_p = 'CEP') THEN 
 
			select	max(coalesce(cd_cep,'')) 
			into STRICT	ds_descricao_w 
			from (SELECT	max(b.cd_cep)	cd_cep 
			from	compl_pessoa_fisica b 
			where	b.cd_pessoa_fisica = cd_pessoa_fisica_p 
			and	b.ie_tipo_complemento = ie_tipo_complemento_p) alias4;
 
		END IF;
		 
		end;
	end if;
	 
exception 
 
when others then 
 
	ds_descricao_w := '';
 
end;
 
return	ds_descricao_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_compl_pf_tipo ( cd_pessoa_fisica_p text, ie_tipo_complemento_p bigint, ie_descricao_p text ) FROM PUBLIC;

