-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_eis_cobranca ( dt_inicio_p timestamp) AS $body$
DECLARE

 
 
dt_ref_conta_w			timestamp;
dt_emissao_w			timestamp;
dt_vencimento_w			timestamp;
dt_baixa_w			timestamp;
cd_convenio_w			integer;
vl_titulo_w			double precision;
vl_Saldo_w			double precision;
vl_recebido_w			double precision;
vl_glosado_w			double precision;
vl_a_menor_w			double precision;
vl_rec_maior_w		double precision;
vl_sem_retorno_w		double precision;
vl_juro_multa_w		double precision;
vl_desconto_w			double precision;
vl_estorno_w			double precision;
qt_titulo_w			integer;
ds_tipo_protocolo_w		varchar(255);
qt_registro_w			integer;
cd_tipo_rec_w			integer;
cd_estabelecimento_w		integer;
vl_atraso_w			double precision := 0;
vl_recebimento_w		double precision := 0;

c01 CURSOR FOR 
SELECT		cd_estabelecimento, 
		coalesce(dt_ref_conta, coalesce(obter_mesano_conta_tit_rec(nr_titulo),trunc(dt_emissao,'month'))) dt_ref_conta, 
		trunc(dt_emissao,'month'), 
		trunc(dt_pagamento_previsto,'month'), 
		trunc(clock_timestamp() - interval '20000 days','month'), 
		coalesce(cd_convenio_conta, coalesce(obter_convenio_tit_rec(nr_titulo),0)) cd_convenio, 
		count(distinct nr_titulo), 
		sum(vl_titulo), 
		sum(vl_saldo_titulo), 
		0,0,0,0,0, 
 		sum(CASE WHEN vl_saldo_titulo=0 THEN  0  ELSE coalesce(obter_valor_conta_tit_sretorno(nr_titulo, clock_timestamp()),0) END ), 
 		sum(coalesce(CASE WHEN vl_saldo_titulo=0 THEN  0  ELSE coalesce(EIS_Obter_Valor_Amenor_Tit_Rec(nr_titulo,clock_timestamp()),0) END ,0)), 
		0, 0, 0, 
		obter_desc_tipo_protocolo(nr_seq_protocolo) ie_tipo_protocolo 
from 		titulo_receber 
where		dt_emissao >= trunc(dt_inicio_p,'month') 
 and		ie_situacao <> '3' 
group by	cd_estabelecimento, 
		coalesce(dt_ref_conta, coalesce(obter_mesano_conta_tit_rec(nr_titulo),trunc(dt_emissao,'month'))), 
		trunc(dt_emissao,'month'), 
		trunc(dt_pagamento_previsto,'month'), 
		trunc(clock_timestamp() - interval '20000 days','month'), 
		coalesce(cd_convenio_conta, coalesce(obter_convenio_tit_rec(nr_titulo),0)), 
		obter_desc_tipo_protocolo(nr_seq_protocolo) 

union
 
SELECT		a.cd_estabelecimento, 
		coalesce(obter_mesano_conta_tit_rec(a.nr_titulo),trunc(a.dt_emissao,'month')) dt_ref_conta, 
		trunc(a.dt_emissao,'month'), 
		trunc(a.dt_pagamento_previsto,'month'), 
		trunc(b.dt_recebimento,'month'), 
		coalesce(obter_convenio_tit_rec(a.nr_titulo),0) cd_convenio, 
		0, 0, 0, 
		sum(CASE WHEN b.cd_tipo_recebimento=cd_tipo_rec_w THEN  0  ELSE coalesce(b.vl_recebido,0) END ), 
		sum(coalesce(b.vl_glosa,0)), 
		sum(coalesce(b.vl_rec_maior,0)), 
		sum(coalesce(b.vl_juros,0) + coalesce(vl_multa,0)), 
		sum(coalesce(b.vl_descontos,0)), 
		0, 0, 
		sum(CASE WHEN b.cd_tipo_recebimento=cd_tipo_rec_w THEN  coalesce(b.vl_recebido,0)  ELSE 0 END ), 
		sum(b.vl_recebido * (trunc(b.dt_recebimento, 'dd') - trunc(a.dt_vencimento, 'dd'))), 
		sum(b.vl_recebido * (trunc(b.dt_recebimento, 'dd') - trunc(coalesce(c.dt_envio,a.dt_emissao), 'dd'))), /* Paulo - OS 75699 - 30/11/2007 - Coloquei nvl(c.dt_envio */
 
		obter_desc_tipo_protocolo(c.nr_seq_protocolo) 
FROM titulo_receber_liq b, titulo_receber a
LEFT OUTER JOIN protocolo_convenio c ON (a.nr_seq_protocolo = c.nr_seq_protocolo)
WHERE a.dt_emissao >= trunc(dt_inicio_p,'month') and a.nr_titulo		= b.nr_titulo  and coalesce(ie_lib_caixa, 'S') = 'S' group by	a.cd_estabelecimento, 
		coalesce(obter_mesano_conta_tit_rec(a.nr_titulo),trunc(a.dt_emissao,'month')), 
		trunc(a.dt_emissao,'month'), 
		trunc(a.dt_pagamento_previsto,'month'), 
		trunc(b.dt_recebimento,'month'), 
		obter_desc_tipo_protocolo(c.nr_seq_protocolo), 
		coalesce(obter_convenio_tit_rec(a.nr_titulo),0);
		

BEGIN 
 
select	coalesce(min(cd_tipo_recebimento),4) 
into STRICT	cd_tipo_rec_w 
from	tipo_recebimento 
where	ie_tipo_consistencia = 4;
 
delete	from eis_cobranca;
commit;
 
CALL atualizar_dados_tit_rec(dt_inicio_p);
 
OPEN C01;
LOOP 
FETCH C01 into	 
	cd_estabelecimento_w, 
	dt_ref_conta_w, 
	dt_emissao_w, 
	dt_vencimento_w, 
	dt_baixa_w, 
	cd_convenio_w, 
	qt_titulo_w, 
	vl_titulo_w, 
	vl_saldo_w, 
	vl_recebido_w, 
	vl_glosado_w, 
	vl_rec_maior_w, 
	vl_juro_multa_w, 
	vl_desconto_w, 
	vl_sem_retorno_w, 
	vl_a_menor_w, 
	vl_estorno_w, 
	vl_atraso_w, 
	vl_recebimento_w, 
	ds_tipo_protocolo_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
 
	select 	count(*) 
	into STRICT	qt_registro_w 
	from	eis_cobranca 
	where	dt_ref_conta		= dt_ref_conta_w 
	and	dt_emissao		= dt_emissao_w 
	and	dt_vencimento		= dt_vencimento_w 
	and	dt_baixa		= dt_baixa_w 
	and	cd_convenio		= cd_convenio_w 
	and	cd_estabelecimento	= cd_estabelecimento_w;
 
	if (qt_registro_w > 0) then 
		update	eis_Cobranca 
		set	qt_titulo		= qt_titulo + qt_titulo_w, 
			vl_titulo		= vl_titulo + vl_titulo_w, 
			vl_saldo		= vl_saldo + vl_saldo_w, 
			vl_recebido		= vl_recebido + vl_recebido_w, 
			vl_glosado		= vl_glosado + vl_glosado_w, 
			vl_rec_maior		= vl_rec_maior + vl_rec_maior_w, 
			vl_juro_multa		= vl_juro_multa + vl_juro_multa_w, 
			vl_desconto		= vl_desconto + vl_desconto_w, 
			vl_dia_atraso		= vl_dia_atraso + vl_atraso_w, 
			vl_dia_receb		= vl_dia_receb + vl_recebimento_w 
		where	dt_ref_conta		= dt_ref_conta_w 
		and	dt_emissao		= dt_emissao_w 
		and	dt_vencimento		= dt_vencimento_w 
		and	dt_baixa		= dt_baixa_w 
		and	cd_convenio		= cd_convenio_w 
		and	cd_estabelecimento	= cd_estabelecimento_w;
	else 
		insert	into eis_Cobranca( 
			dt_ref_conta, 
			dt_emissao, 
			dt_vencimento, 
			dt_baixa, 
			cd_convenio, 
			qt_titulo, 
			vl_titulo, 
			vl_recebido, 
			vl_glosado, 
			vl_rec_maior, 
			vl_juro_multa, 
			vl_desconto, 
			vl_saldo, 
			vl_sem_retorno, 
			vl_a_menor, 
			vl_estorno, 
			cd_estabelecimento, 
			vl_dia_atraso, 
			vl_dia_receb, 
			ds_tipo_protocolo) 
		values ( 
			dt_ref_conta_w, 
			dt_emissao_w, 
			dt_vencimento_w, 
			dt_baixa_w, 
			cd_convenio_w, 
			qt_titulo_w, 
			vl_titulo_w, 
			vl_recebido_w, 
			vl_glosado_w, 
			vl_rec_maior_w, 
			vl_juro_multa_w, 
			vl_desconto_w, 
			vl_saldo_w, 
			vl_sem_retorno_w, 
			vl_a_menor_w, 
			vl_estorno_w, 
			cd_estabelecimento_w, 
			vl_atraso_w, 
			vl_recebimento_w, 
			ds_tipo_protocolo_w);
	end if;
 
end loop;
close c01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_eis_cobranca ( dt_inicio_p timestamp) FROM PUBLIC;

