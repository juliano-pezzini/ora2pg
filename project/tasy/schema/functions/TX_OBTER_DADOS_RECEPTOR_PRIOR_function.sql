-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tx_obter_dados_receptor_prior (nr_seq_receptor_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


nr_prioridade_w			integer;
ds_observacao_w			varchar(255);
nr_seq_motivo_prioridade_w	bigint;
ds_motivo_prioridade_w		varchar(255);
ds_retorno_w			varchar(255);

/*
ie_opcao_p:
	O - Observação
	P - Prioridade
	N - Sequência motivo
	D - Descrição do motivo
*/
BEGIN

if (coalesce(nr_seq_receptor_p,0) > 0) then

	select	max(nr_prioridade),
		max(ds_observacao),
		max(nr_seq_motivo_prioridade),
		max(substr(tx_obter_desc_motivo_prior(nr_seq_motivo_prioridade,'D'),1,255))
	into STRICT	nr_prioridade_w,
		ds_observacao_w,
		nr_seq_motivo_prioridade_w,
		ds_motivo_prioridade_w
	from	tx_receptor_prioridade
	where 	nr_seq_receptor = nr_seq_receptor_p;

	if (ie_opcao_p = 'O') then
		ds_retorno_w := ds_observacao_w;
	elsif (ie_opcao_p = 'P') then
		ds_retorno_w := nr_prioridade_w;
	elsif (ie_opcao_p = 'N') then
		ds_retorno_w := nr_seq_motivo_prioridade_w;
	elsif (ie_opcao_p = 'D') then
		ds_retorno_w := ds_motivo_prioridade_w;
	end if;

end if;

return ds_retorno_w;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tx_obter_dados_receptor_prior (nr_seq_receptor_p bigint, ie_opcao_p text) FROM PUBLIC;

