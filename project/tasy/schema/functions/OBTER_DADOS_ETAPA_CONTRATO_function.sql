-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_etapa_contrato ( nr_seq_etapa_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

 
nr_seq_contrato_w	bigint;
retorno_w		varchar(1000);

/* Opções 
DE	: descrição da etapa do contrato 
TE	: tipo da etapa do contrato 
NR_CO	: número do contrato 
DS_CO	: contratado 
TC	: tipo do contrato 
DI	: data de início do contrato 
DF	: data de fim do contrato 
OBJ	: objeto do contrato 
OBS	: observação da etapa do contrato 
*/
 
 

BEGIN 
 
select	nr_seq_contrato 
into STRICT	nr_seq_contrato_w 
from	contrato_etapa 
where	nr_sequencia = nr_seq_etapa_p;
 
if (ie_opcao_p = 'DE') then 
	 
	select	ds_etapa 
	into STRICT	retorno_w 
	from	contrato_etapa 
	where	nr_sequencia = nr_seq_etapa_p;
 
elsif (ie_opcao_p = 'TE') then 
	 
	select	ds_tipo_etapa 
	into STRICT	retorno_w 
	from	contrato_tipo_etapa 
	where	nr_sequencia = (	SELECT	nr_seq_tipo_etapa 
					from	contrato_etapa 
					where	nr_sequencia = nr_seq_etapa_p);
 
elsif (ie_opcao_p = 'NR_CO') then 
 
	retorno_w := to_char(nr_seq_contrato_w);
 
elsif (ie_opcao_p = 'DS_CO') then 
 
	select	substr(obter_nome_pf_pj(cd_pessoa_contratada,cd_cgc_contratado),1,255) 
	into STRICT	retorno_w 
	from	contrato 
	where	nr_sequencia = nr_seq_contrato_w;
 
elsif (ie_opcao_p = 'TC') then 
 
	select	ds_tipo_contrato 
	into STRICT	retorno_w 
	from	tipo_contrato 
	where	nr_sequencia = (	SELECT 	nr_seq_tipo_contrato 
					from	contrato 
					where	nr_sequencia = nr_seq_contrato_w);
 
elsif (ie_opcao_p = 'DI') then 
 
	select	to_char(dt_inicio,'dd/mm/yyyy') 
	into STRICT	retorno_w 
	from	contrato 
	where	nr_sequencia = nr_seq_contrato_w;
 
elsif (ie_opcao_p = 'DF') then 
 
	select	to_char(dt_fim,'dd/mm/yyyy') 
	into STRICT	retorno_w 
	from	contrato 
	where	nr_sequencia = nr_seq_contrato_w;
 
elsif (ie_opcao_p = 'OBJ') then 
 
	select	ds_objeto_contrato 
	into STRICT	retorno_w 
	from	contrato 
	where	nr_sequencia = nr_seq_contrato_w;
	 
elsif (ie_opcao_p = 'OBS') then 
 
	select	ds_observacao 
	into STRICT	retorno_w 
	from	contrato_etapa 
	where	nr_sequencia = nr_seq_etapa_p;
 
end if;
 
return	retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_etapa_contrato ( nr_seq_etapa_p bigint, ie_opcao_p text) FROM PUBLIC;

