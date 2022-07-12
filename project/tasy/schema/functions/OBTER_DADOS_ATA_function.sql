-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_ata (nr_seq_ata_p bigint, ie_opcao_p text, ie_tipo_p text) RETURNS varchar AS $body$
DECLARE

/* 
IE_OPCAO_P: 
DS - Descrição da ATA; 
CS - Consultor; 
DB - Distribuidor - COM_CANAL; 
 
IE_TIPO_P: 
C - Código; 
D - Descrição; 
*/
			 
 
cd_cnpj_canal_w		varchar(14);
cd_cnpj_cliente_w	varchar(14);
cd_consultor_w		varchar(10);
ds_ata_w		varchar(255);
ds_retorno_w		varchar(255);
			

BEGIN 
 
select	a.cd_consultor, 
	a.ds_ata, 
	b.cd_cnpj, 
	c.cd_cnpj 
into STRICT	cd_consultor_w, 
	ds_ata_w, 
	cd_cnpj_canal_w, 
	cd_cnpj_cliente_w 
FROM proj_ata a
LEFT OUTER JOIN com_canal b ON (a.nr_seq_canal = b.nr_sequencia)
LEFT OUTER JOIN com_cliente c ON (a.nr_seq_cliente = c.nr_sequencia)
WHERE a.nr_sequencia 		= nr_seq_ata_p;
 
if (IE_TIPO_P = 'C') then 
	if (IE_OPCAO_P = 'CS' ) then 
		ds_retorno_w := cd_consultor_w;
	elsif (IE_OPCAO_P = 'DB' ) then 
		ds_retorno_w := coalesce(cd_cnpj_canal_w,cd_cnpj_cliente_w);
	end if;	
else 
	if (IE_OPCAO_P = 'DS' ) then 
		ds_retorno_w := ds_ata_w;
	elsif (IE_OPCAO_P = 'CS' ) then 
		ds_retorno_w := obter_nome_pf_pj(cd_consultor_w,null);
	elsif (IE_OPCAO_P = 'DB' ) then 
		ds_retorno_w := obter_nome_pf_pj(null,coalesce(cd_cnpj_canal_w,cd_cnpj_cliente_w));
	end if;	
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_ata (nr_seq_ata_p bigint, ie_opcao_p text, ie_tipo_p text) FROM PUBLIC;

