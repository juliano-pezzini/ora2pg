-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calcular_juro_multa_cheque (nr_seq_cheque_p bigint, dt_referencia_p timestamp, dt_vencimento_p timestamp, vl_juros_p INOUT bigint, vl_multa_p INOUT bigint) AS $body$
DECLARE


dt_vencimento_w			timestamp;
qt_dia_venc_w			bigint;
pr_juro_padrao_w		double precision;
pr_multa_padrao_w		double precision;
cd_estabelecimento_w		smallint;
cd_tipo_taxa_juro_w		bigint;
cd_tipo_taxa_multa_w		bigint;
ie_tipo_taxa_w			varchar(255);
pr_juros_w			double precision;
vl_cheque_w			double precision;
vl_saldo_juros_w		double precision;
vl_saldo_multa_w		double precision;
tx_juros_cobranca_w		double precision;
tx_multa_cobranca_w		double precision;
cd_tipo_tx_juros_ch_w		bigint;
cd_tipo_tx_multa_ch_w		bigint;


BEGIN

select	max(a.dt_vencimento_atual),
	max(a.cd_estabelecimento),
	max(a.vl_cheque),
	max(tx_juros_cobranca),
	max(tx_multa_cobranca),
	max(cd_tipo_taxa_juros),
	max(cd_tipo_taxa_multa)
into STRICT	dt_vencimento_w,
	cd_estabelecimento_w,
	vl_cheque_w,
	tx_juros_cobranca_w,
	tx_multa_cobranca_w,
	cd_tipo_tx_juros_ch_w,
	cd_tipo_tx_multa_ch_w
from	cheque_cr a
where	a.nr_seq_cheque	= nr_seq_cheque_p;

if (dt_vencimento_p IS NOT NULL AND dt_vencimento_p::text <> '') then
	dt_vencimento_w	:= dt_vencimento_p;
end if;

qt_dia_venc_w	:= trunc(dt_referencia_p, 'dd') - trunc(dt_vencimento_w, 'dd');

if (qt_dia_venc_w > 0) then

	select	coalesce(tx_juros_cobranca_w, max(a.pr_juro_padrao)),
		coalesce(tx_multa_cobranca_w, max(a.pr_multa_padrao)),
		coalesce(cd_tipo_tx_juros_ch_w, max(a.cd_tipo_taxa_juro)),
		coalesce(cd_tipo_tx_multa_ch_w, max(a.cd_tipo_taxa_multa))
	into STRICT	pr_juro_padrao_w,
		pr_multa_padrao_w,
		cd_tipo_taxa_juro_w,
		cd_tipo_taxa_multa_w
	from	parametro_contas_receber a
	where	a.cd_estabelecimento	= cd_estabelecimento_w;

	if (pr_juro_padrao_w > 0) then

		select	ie_tipo_taxa
		into STRICT	ie_tipo_taxa_w
		from	tipo_taxa
		where	cd_tipo_taxa	= cd_tipo_taxa_juro_w;

		if (ie_tipo_taxa_w = 'A') then
			pr_juros_w	:= dividir_sem_round((pr_juro_padrao_w)::numeric, 365) * qt_dia_venc_w;
		elsif (ie_tipo_taxa_w = 'M') then
			pr_juros_w	:= dividir_sem_round((pr_juro_padrao_w)::numeric, 30) * qt_dia_venc_w;
		elsif (ie_tipo_taxa_w = 'D') then
			pr_juros_w	:= pr_juro_padrao_w * qt_dia_venc_w;
		end if;

		if (ie_tipo_taxa_w = 'V') then
			vl_saldo_juros_w	:= pr_juro_padrao_w * qt_dia_venc_w;
		else
			vl_saldo_juros_w	:= vl_cheque_w * (dividir_sem_round((pr_juros_w)::numeric, 100));
		end if;

	end if;

	if (pr_multa_padrao_w > 0) then
		vl_saldo_multa_w	:= vl_cheque_w * (dividir_sem_round((pr_multa_padrao_w)::numeric, 100));
	end if;

end if;

vl_juros_p	:= vl_saldo_juros_w;
vl_multa_p	:= vl_saldo_multa_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calcular_juro_multa_cheque (nr_seq_cheque_p bigint, dt_referencia_p timestamp, dt_vencimento_p timestamp, vl_juros_p INOUT bigint, vl_multa_p INOUT bigint) FROM PUBLIC;

