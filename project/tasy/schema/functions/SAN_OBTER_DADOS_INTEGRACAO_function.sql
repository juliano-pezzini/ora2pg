-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION san_obter_dados_integracao ( ie_tipo_integracao_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*
ie_opcao_p
S - Código sistema hemoterapia
V - Versão leiaute
A - Tipo arquivo
I - Interface
*/
ds_retorno_w		varchar(255);
nr_seq_integracao_w	bigint;
cd_sistema_hemot_w	varchar(80);
ds_versao_w		varchar(80);
ds_arquivo_w		varchar(80);
cd_interface_w		integer;


BEGIN
if (ie_tipo_integracao_p IS NOT NULL AND ie_tipo_integracao_p::text <> '') then

	select	max(nr_sequencia)
	into STRICT	nr_seq_integracao_w
	from	san_integracao
	where	ie_integracao = ie_tipo_integracao_p
	and	clock_timestamp()	between dt_inicio_vigencia and fim_dia(dt_fim_vigencia);

	if (nr_seq_integracao_w IS NOT NULL AND nr_seq_integracao_w::text <> '') then

		select	cd_sistema_hemoterapia,
			ds_versao,
			ds_arquivo,
			cd_interface
		into STRICT	cd_sistema_hemot_w,
			ds_versao_w,
			ds_arquivo_w,
			cd_interface_w
		from	san_integracao
		where	nr_sequencia = nr_seq_integracao_w;

		if (ie_opcao_p = 'S') then
			ds_retorno_w := cd_sistema_hemot_w;
		elsif (ie_opcao_p = 'V') then
			ds_retorno_w := ds_versao_w;
		elsif (ie_opcao_p = 'A') then
			ds_retorno_w := ds_arquivo_w;
		elsif (ie_opcao_p = 'I') then
			ds_retorno_w := cd_interface_w;
		end if;

	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION san_obter_dados_integracao ( ie_tipo_integracao_p text, ie_opcao_p text) FROM PUBLIC;

