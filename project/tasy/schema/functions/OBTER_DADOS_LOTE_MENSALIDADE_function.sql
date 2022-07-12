-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_lote_mensalidade ( nr_seq_lote_mens_p bigint, ie_tipo_dado_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(255)	:= null;
dt_geracao_w			timestamp;
dt_mesano_referencia_w		timestamp;


BEGIN

if (ie_tipo_dado_p = 'DR') then
	select	dt_mesano_referencia
	into STRICT	dt_mesano_referencia_w
	from	pls_lote_mensalidade
	where	nr_sequencia = nr_seq_lote_mens_p;

	ds_retorno_w	:= to_char(dt_mesano_referencia_w,'dd/mm/yyyy');

elsif (ie_tipo_dado_p = 'DG') then
	select	dt_geracao
	into STRICT	dt_geracao_w
	from	pls_lote_mensalidade
	where	nr_sequencia = nr_seq_lote_mens_p;

	ds_retorno_w	:= to_char(dt_geracao_w,'dd/mm/yyyy');
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_lote_mensalidade ( nr_seq_lote_mens_p bigint, ie_tipo_dado_p text) FROM PUBLIC;

