-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cx_origem_tit_receb_liq ( nr_titulo_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_caixa_w		varchar(255);
nr_lote_w		varchar(10);
dt_receb_convenio_w	varchar(20);
ds_titulos_pagar_w	varchar(255);
nr_seq_movto_pend_w	varchar(10);
dt_liquidacao_cobr_w	varchar(20);

BEGIN

begin
	select	substr(obter_desc_caixa(d.nr_seq_caixa),1,255),
		d.nr_seq_lote,
		obter_dados_tit_rec_liq(a.nr_titulo, a.nr_sequencia, 'DTR'),
		substr(obter_titulos_baixa(null,a.nr_titulo,a.nr_sequencia),1,255),
		substr(obter_dados_tit_rec_liq(a.nr_titulo, a.nr_sequencia, 'CRN'),1,10),
		obter_dt_liq_arq_titulo(a.nr_titulo,a.nr_sequencia,a.nr_seq_cobranca)
	into STRICT	ds_caixa_w,
		nr_lote_w,
		dt_receb_convenio_w,
		ds_titulos_pagar_w,
		nr_seq_movto_pend_w,
		dt_liquidacao_cobr_w
	FROM valor_dominio c, titulo_receber_liq a
LEFT OUTER JOIN movto_trans_financ d ON (a.nr_seq_movto_trans_fin = d.nr_sequencia)
LEFT OUTER JOIN tipo_recebimento b ON (a.cd_tipo_recebimento = b.cd_tipo_recebimento)
WHERE a.nr_titulo			= nr_titulo_p   and c.cd_dominio			= 711 and c.vl_dominio			= a.ie_acao and coalesce(a.ie_lib_caixa,'S')		= 'S';
exception
	when others then
	ds_caixa_w	:= '';
end;
if (ie_opcao_p = 'C') then
	return	ds_caixa_w;
elsif (ie_opcao_p = 'L') then
	return nr_lote_w;
elsif (ie_opcao_p = 'RC') then
	return dt_receb_convenio_w;
elsif (ie_opcao_p = 'TP') then
	return ds_titulos_pagar_w;
elsif (ie_opcao_p = 'MP') then
	return nr_seq_movto_pend_w;
elsif (ie_opcao_p = 'LC') then
	return dt_liquidacao_cobr_w;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cx_origem_tit_receb_liq ( nr_titulo_p bigint, ie_opcao_p text) FROM PUBLIC;

