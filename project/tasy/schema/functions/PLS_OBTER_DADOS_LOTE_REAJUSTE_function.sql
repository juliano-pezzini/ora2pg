-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dados_lote_reajuste (nr_seq_reajuste_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*	ie_opcao_p
	'P' - Percentual do reajuste
	'DI' - Data período inicial
	'DF' - Data período final
	'IR' - Indice de reajuste
	'OA' - Ofício ANS
	'PA' - Protocolo ANS	*/
nr_seq_lote_w		bigint;
dt_periodo_inicial_w	timestamp;
dt_periodo_final_w	timestamp;
tx_reajuste_w		double precision;
ie_indice_reajuste_w	varchar(1);
ds_oficio_ans_W		varchar(255);
nr_protocolo_ans_w	varchar(60);
ds_retorno_w		varchar(255);


BEGIN

if (coalesce(nr_seq_reajuste_p,0) > 0) then
	select	NR_SEQ_REAJUSTE
	into STRICT	nr_seq_lote_w
	from	pls_reajuste_preco
	where	nr_sequencia	= nr_seq_reajuste_p;

	select	DT_PERIODO_INICIAL,
		DT_PERIODO_FINAL,
		TX_REAJUSTE,
		IE_INDICE_REAJUSTE,
		DS_OFICIO_ANS,
		NR_PROTOCOLO_ANS
	into STRICT	dt_periodo_inicial_w,
		dt_periodo_final_w,
		tx_reajuste_w,
		ie_indice_reajuste_w,
		ds_oficio_ans_W,
		nr_protocolo_ans_w
	from	pls_reajuste
	where	nr_sequencia = nr_seq_lote_w;

	if (ie_opcao_p	= 'P') then
		ds_retorno_w := to_char(tx_reajuste_w);
	elsif (ie_opcao_p = 'DI') then
		ds_retorno_w := to_char(dt_periodo_inicial_w,'dd/mm/yyyy');
	elsif (ie_opcao_p = 'DF') then
		ds_retorno_w := to_char(dt_periodo_final_w,'dd/mm/yyyy');
	elsif (ie_opcao_p = 'IR') then
		ds_retorno_w := ie_indice_reajuste_w;
	elsif (ie_opcao_p = 'OA') then
		ds_retorno_w := ds_oficio_ans_w;
	elsif (ie_opcao_p = 'PA') then
		ds_retorno_w := nr_protocolo_ans_w;
	end if;


end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dados_lote_reajuste (nr_seq_reajuste_p bigint, ie_opcao_p text) FROM PUBLIC;
