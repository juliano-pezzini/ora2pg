-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_documentacao_relatorio (nr_seq_relat_p text) RETURNS varchar AS $body$
DECLARE

 
ie_existe_doc	varchar(1) 	:= 'N';
ds_retorno_w	varchar(4000)	:= 'Relatório sem documentação.';		
quebra1		varchar(20) 	:= chr(13) || chr(10);
quebra2		varchar(40) 	:= quebra1 || quebra1;
			

BEGIN 
 
select	coalesce(max('S'),'N') 
into STRICT	ie_existe_doc 
from	relatorio_documentacao 
where	nr_seq_relatorio = nr_seq_relat_p;
 
if (ie_existe_doc = 'S') then 
 
	select	quebra1 || 
		'Pessoa solicitante: ' 								|| quebra1 || 
		rpad(cd_pf_solic,10) || ' ' || substr(obter_nome_pf(cd_pf_solic),1,200) 	|| quebra2 || 
		'Criador: ' 									|| quebra1 || 
		rpad(cd_pf_criador,10) || ' ' || substr(obter_nome_pf(cd_pf_criador),1,200) 	|| quebra2 || 
		'Objetivo: ' 									|| quebra1 || 
		substr(ds_objetivo,1,2000) 							|| quebra2 || 
		'Observações: ' 								|| quebra1 || 
		substr(ds_observacao,1,4000) 
	into STRICT	ds_retorno_w 
	from	relatorio_documentacao 
	where	nr_seq_relatorio = nr_seq_relat_p;
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_documentacao_relatorio (nr_seq_relat_p text) FROM PUBLIC;
