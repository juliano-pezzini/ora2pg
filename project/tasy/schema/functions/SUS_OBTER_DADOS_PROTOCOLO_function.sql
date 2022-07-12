-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_dados_protocolo ( nr_seq_interna_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);
cd_protocolo_w		bigint;
nm_medicacao_w		varchar(255);
nr_sequencia_w		integer;

/*ie_opcao_p:
NP 	- Nome do protocolo
CP 	- Código do Protocolo
NS	- Nome do Sub-tipo do protocolo
SS	- Sequência do Sub-tipo do protocolo
*/
BEGIN

select	max(cd_protocolo),
	max(nm_medicacao),
	max(nr_sequencia)
into STRICT	cd_protocolo_w,
	nm_medicacao_w,
        nr_sequencia_w
from	protocolo_medicacao
where	nr_seq_interna = nr_seq_interna_p;

if (ie_opcao_p = 'NP') then
	select	nm_protocolo
	into STRICT	ds_retorno_w
	from	protocolo
	where	cd_protocolo	= cd_protocolo_w;
elsif (ie_opcao_p = 'CP') then
	ds_retorno_w	:= cd_protocolo_w;
elsif (ie_opcao_p = 'NS') then
	ds_retorno_w	:= nm_medicacao_w;
elsif (ie_opcao_p = 'SS') then
	ds_retorno_w	:= nr_sequencia_w;
end if;

return ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_dados_protocolo ( nr_seq_interna_p bigint, ie_opcao_p text) FROM PUBLIC;
