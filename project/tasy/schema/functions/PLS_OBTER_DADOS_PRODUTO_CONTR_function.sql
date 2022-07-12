-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dados_produto_contr ( nr_seq_contrato_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(255);
ie_regulamentacao_w		varchar(255);
ds_tipo_contratacao_w		varchar(255);
ds_plano_w			varchar(80);
nr_seq_plano_w			bigint;

/*
	N - Nome do produto
	R - Regulamentação
	S - Sequencia
	TC - Tipo de contaratção
*/
BEGIN


select	max(nr_seq_plano)
into STRICT	nr_seq_plano_w
from	pls_contrato_plano
where	nr_seq_contrato	= nr_seq_contrato_p
and	ie_situacao	= 'A'
and	coalesce(dt_fim_vigencia::text, '') = '';

select	ds_plano,
	ie_regulamentacao,
	ie_tipo_contratacao
into STRICT	ds_plano_w,
	ie_regulamentacao_w,
	ds_tipo_contratacao_w
from	pls_plano
where	nr_sequencia		= nr_seq_plano_w;


if (ie_opcao_p = 'N') then
	ds_retorno_w	:= ds_plano_w;
elsif (ie_opcao_p = 'R') then
	ds_retorno_w	:= ie_regulamentacao_w;
elsif (ie_opcao_p = 'S') then
	ds_retorno_w	:= nr_seq_plano_w;
elsif (ie_opcao_p = 'TC') then
	ds_retorno_w	:= ds_tipo_contratacao_w;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dados_produto_contr ( nr_seq_contrato_p bigint, ie_opcao_p text) FROM PUBLIC;

