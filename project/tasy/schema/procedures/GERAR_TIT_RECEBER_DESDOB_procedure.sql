-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_tit_receber_desdob ( nr_titulo_p bigint, nr_parcelas_p bigint, dt_vencimento_p timestamp, nm_usuario_p text, qt_dias_intervalo_p bigint, ie_juros_multa_p text, ie_data_contabil_p text) AS $body$
DECLARE


vl_saldo_titulo_w		double precision;
vl_parcela_w			double precision;
vl_parcela_original_w		double precision;
nr_sequencia_w			bigint;
vl_resto_w			real;
vl_centavos_w			real;
ie_venc_sobra_desdob_w 		varchar(01);
ie_tipo_sobra_desdob_w 		varchar(01);
dt_parcela_w			timestamp;
vl_juros_w			double precision;
vl_multa_w			double precision;
ie_data_contabil_w		varchar(10);
ie_dt_contab_desdob_w		varchar(10);
ie_altera_dt_contabil_w		varchar(10);
dt_contabil_w			timestamp;
dt_contabil_original_w		timestamp;
cd_estabelecimento_w		bigint;

BEGIN

select	max(a.vl_saldo_titulo),
	obter_juros_multa_titulo(max(a.nr_titulo),clock_timestamp(),'R','J') vl_juros,
	obter_juros_multa_titulo(max(a.nr_titulo),clock_timestamp(),'R','M') vl_multa,
	max(a.cd_estabelecimento),
	max(a.dt_contabil)
into STRICT	vl_saldo_titulo_w,
	vl_juros_w,
	vl_multa_w,
	cd_estabelecimento_w,
	dt_contabil_original_w
from	titulo_receber a
where	a.nr_titulo	= nr_titulo_p;

if (ie_juros_multa_p = 'S') then
	vl_saldo_titulo_w	:= coalesce(vl_saldo_titulo_w,0) + coalesce(vl_juros_w,0) + coalesce(vl_multa_w,0);
end if;

ie_altera_dt_contabil_w := obter_param_usuario(801, 141, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_altera_dt_contabil_w);

/*select do parametro_contas_receber*/

select	a.IE_VENC_SOBRA_DESDOB,		/*se for P - primeiro vencimento, se for U - ultimo vencimento*/
	a.IE_TIPO_SOBRA_DESDOB,		/*se for C - centavos, se for U - unidade monetária*/
	a.IE_DT_CONTAB_DESDOB		/*se for A - Data atual, se for C - Data contábil do título origina, se or V - Vencimento do título*/
into STRICT	ie_venc_sobra_desdob_w,
	ie_tipo_sobra_desdob_w,
	ie_dt_contab_desdob_w
from	parametro_contas_receber a,
	titulo_receber b
where	a.cd_estabelecimento	= b.cd_estabelecimento
and	b.nr_titulo 		= nr_titulo_p;

if (coalesce(ie_altera_dt_contabil_w,'N') = 'S') then
	if (ie_data_contabil_p = '0') then
		ie_data_contabil_w := 'A';
	elsif (ie_data_contabil_p = '1') then
		ie_data_contabil_w := 'C';
	elsif (ie_data_contabil_p = '2') then
		ie_data_contabil_w := 'V';
	elsif (ie_data_contabil_p = '3') then
		ie_data_contabil_w := 'U';
	end if;
else
	ie_data_contabil_w	:= ie_dt_contab_desdob_w;
end if;

dt_parcela_w := dt_vencimento_p;

IF (ie_tipo_sobra_desdob_w = 'U') THEN
	vl_centavos_w	:= vl_saldo_titulo_w - trunc(vl_saldo_titulo_w);
	vl_resto_w	:= ((vl_saldo_titulo_w - vl_centavos_w) mod nr_parcelas_p) + vl_centavos_w;
	vl_parcela_w	:= dividir((vl_saldo_titulo_w  - vl_resto_w),nr_parcelas_p);
ELSE
	vl_parcela_w	:= round((dividir(vl_saldo_titulo_w,nr_parcelas_p))::numeric, 2);
	vl_resto_w	:= vl_saldo_titulo_w - (vl_parcela_w * nr_parcelas_p);
END IF;

vl_parcela_original_w	:= vl_parcela_w;

FOR i in 1..nr_parcelas_p LOOP

	IF 	(ie_venc_sobra_desdob_w = 'P' AND i = 1) or
		(ie_venc_sobra_desdob_w = 'U' AND i = nr_parcelas_p) THEN
		vl_parcela_w := vl_parcela_w + vl_resto_w;
	END IF;

	if (ie_data_contabil_w = 'A') then
		dt_contabil_w	:= clock_timestamp();
	elsif (ie_data_contabil_w = 'C') then
		dt_contabil_w	:= dt_contabil_original_w;
	elsif (ie_data_contabil_w = 'V') then
		dt_contabil_w	:= dt_parcela_w;
	elsif (ie_data_contabil_w = 'U') then
		dt_contabil_w	:= PKG_DATE_UTILS.get_datetime(PKG_DATE_UTILS.END_OF(PKG_DATE_UTILS.ADD_MONTH(dt_parcela_w,-1,0), 'MONTH', 0), coalesce(dt_parcela_w, PKG_DATE_UTILS.GET_TIME('00:00:00')));
	end if;

	select	nextval('titulo_receber_desdob_seq')
	into STRICT	nr_sequencia_w
	;

	insert into titulo_receber_desdob(NR_SEQUENCIA,
		 NR_TITULO,
		 DT_VENCIMENTO,
		 VL_TITULO,
		 DT_ATUALIZACAO,
		 NM_USUARIO,
		 NR_TITULO_DEST,
		 VL_SALDO_JUROS,
		 VL_SALDO_MULTA,
		 DT_CONTABIL,
		 IE_JUROS_MULTA)
	values (nr_sequencia_w,
		 nr_titulo_p,
		 dt_parcela_w,
		 vl_parcela_w,
		 clock_timestamp(),
		 nm_usuario_p,
		 Null,
		 0,
		 0,
		 dt_contabil_w,
		 ie_juros_multa_p);

	vl_parcela_w := vl_parcela_original_w;

	if (qt_dias_intervalo_p > 0) then
		dt_parcela_w	:= dt_parcela_w + qt_dias_intervalo_p;
	else
		dt_parcela_w := PKG_DATE_UTILS.ADD_MONTH(dt_parcela_w,1,0);
	end if;

end loop;
COMMIT;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_tit_receber_desdob ( nr_titulo_p bigint, nr_parcelas_p bigint, dt_vencimento_p timestamp, nm_usuario_p text, qt_dias_intervalo_p bigint, ie_juros_multa_p text, ie_data_contabil_p text) FROM PUBLIC;
