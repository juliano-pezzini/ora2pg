-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION com_obter_dados_neg_comercial ( dt_mes_inicio_p timestamp, dt_mes_fim_p timestamp, dt_mes_p timestamp, nr_seq_canal_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE

/*ie_opcao_p
1	- Qt licença LUT prevista
2	- Qt licença CDU prevista
3	- Qt licença LUT real
4	- Qt licença CDU real
5	- Vl LUT prevista
6	- Vl CDU prevista
7	- Vl LUT real
8	- VL CDU real (Valor total - Valor do distribuidor)
9	- Acumulado LUT
10	- Acumulado CDU
11	- Vl. total LUT real
12	- Vl. total CDU real
*/
nr_seq_cliente_w		bigint;
dt_mes_w			timestamp;

qt_licenca_lut_prev_w		bigint;
qt_licenca_cdu_prev_w		bigint;
vl_licenca_lut_prev_w		double precision;
vl_licenca_cdu_prev_w		double precision;

qt_licenca_lut_real_w		bigint := 0;
qt_licenca_cdu_real_w		bigint := 0;
vl_licenca_lut_real_w		double precision := 0;
vl_licenca_cdu_real_w		double precision := 0;

qt_licenca_lut_real_ww		bigint;
qt_licenca_cdu_real_ww		bigint;
vl_licenca_lut_real_ww		double precision;
vl_licenca_cdu_real_ww		double precision;

vl_licenca_lut_prev_acum_w	double precision;
vl_licenca_lut_real_acum_w	double precision;

vl_licenca_lut_real_acum_ww	double precision;

qt_vencimento_w			bigint;

vl_total_lut_w			double precision;
vl_total_lut_acum_w		double precision;
vl_total_cdu_w			double precision;
vl_total_cdu_acum_w		double precision;

nr_seq_canal_w			bigint;

C01 CURSOR FOR
	SELECT	distinct d.nr_seq_cliente,
		CASE WHEN b.ie_modalidade='LUT' THEN 			CASE WHEN CASE WHEN PKG_DATE_UTILS.start_of(a.dt_inicio_venc,'month',0)=PKG_DATE_UTILS.start_of(coalesce(c.dt_vencimento, a.dt_inicio_venc),'month',0) THEN  a.qt_licenca  ELSE 0 END =0 THEN 			CASE WHEN PKG_DATE_UTILS.start_of(a.dt_inicio_venc,'month',0)=PKG_DATE_UTILS.ADD_MONTH(PKG_DATE_UTILS.start_of(coalesce(c.dt_vencimento, a.dt_inicio_venc),'month',0),-1,0) THEN  a.qt_licenca  ELSE 0 END   ELSE CASE WHEN PKG_DATE_UTILS.start_of(a.dt_inicio_venc,'month',0)=PKG_DATE_UTILS.start_of(coalesce(c.dt_vencimento, a.dt_inicio_venc),'month',0) THEN  a.qt_licenca  ELSE 0 END  END   ELSE 0 END  qt_licenca_lut,
		CASE WHEN b.ie_modalidade='CDU' THEN 			CASE WHEN CASE WHEN PKG_DATE_UTILS.start_of(a.dt_inicio_venc,'month',0)=PKG_DATE_UTILS.start_of(coalesce(c.dt_vencimento, a.dt_inicio_venc),'month',0) THEN  a.qt_licenca  ELSE 0 END =0 THEN 			CASE WHEN PKG_DATE_UTILS.start_of(a.dt_inicio_venc,'month',0)=PKG_DATE_UTILS.ADD_MONTH(PKG_DATE_UTILS.start_of(coalesce(c.dt_vencimento, a.dt_inicio_venc),'month',0),-1,0) THEN  a.qt_licenca  ELSE 0 END   ELSE CASE WHEN PKG_DATE_UTILS.start_of(a.dt_inicio_venc,'month',0)=PKG_DATE_UTILS.start_of(coalesce(c.dt_vencimento, a.dt_inicio_venc),'month',0) THEN  a.qt_licenca  ELSE 0 END  END   ELSE 0 END  qt_licenca_cdu,
		CASE WHEN b.ie_modalidade='LUT' THEN 			CASE WHEN CASE WHEN PKG_DATE_UTILS.start_of(a.dt_inicio_venc,'month',0)=PKG_DATE_UTILS.start_of(coalesce(c.dt_vencimento, a.dt_inicio_venc),'month',0) THEN  a.vl_atual  ELSE 0 END =0 THEN 			CASE WHEN PKG_DATE_UTILS.start_of(a.dt_inicio_venc,'month',0)=PKG_DATE_UTILS.ADD_MONTH(PKG_DATE_UTILS.start_of(coalesce(c.dt_vencimento, a.dt_inicio_venc),'month',0),-1,0) THEN  a.vl_atual  ELSE 0 END   ELSE CASE WHEN PKG_DATE_UTILS.start_of(a.dt_inicio_venc,'month',0)=PKG_DATE_UTILS.start_of(coalesce(c.dt_vencimento, a.dt_inicio_venc),'month',0) THEN  a.vl_atual  ELSE 0 END  END   ELSE 0 END  -
		CASE WHEN b.ie_modalidade='LUT' THEN 			CASE WHEN CASE WHEN PKG_DATE_UTILS.start_of(a.dt_inicio_venc,'month',0)=PKG_DATE_UTILS.start_of(coalesce(c.dt_vencimento, a.dt_inicio_venc),'month',0) THEN  a.vl_distribuidor  ELSE 0 END =0 THEN 			CASE WHEN PKG_DATE_UTILS.start_of(a.dt_inicio_venc,'month',0)=PKG_DATE_UTILS.ADD_MONTH(PKG_DATE_UTILS.start_of(coalesce(c.dt_vencimento, a.dt_inicio_venc),'month',0),-1,0) THEN  a.vl_distribuidor  ELSE 0 END   ELSE CASE WHEN PKG_DATE_UTILS.start_of(a.dt_inicio_venc,'month',0)=PKG_DATE_UTILS.start_of(coalesce(c.dt_vencimento, a.dt_inicio_venc),'month',0) THEN  a.vl_distribuidor  ELSE 0 END  END   ELSE 0 END  vl_lic_lut
	FROM com_modalidade_lic b, com_cli_neg_lic_item a, com_cli_neg_lic d
LEFT OUTER JOIN com_cli_neg_lic_parc c ON (d.nr_sequencia = c.nr_seq_negoc_lic)
WHERE a.nr_seq_mod_licenc 	= b.nr_sequencia  and d.nr_sequencia 		= a.nr_seq_neg_lic and coalesce(d.pr_reajuste::text, '') = '' and (a.nr_seq_canal 		= nr_seq_canal_p or coalesce(nr_seq_canal_p,0) = 0) --and	PKG_DATE_UTILS.start_of(d.dt_assinatura,'month',0) 	between PKG_DATE_UTILS.start_of(dt_mes_inicio_p,'month',0) and PKG_DATE_UTILS.start_of(dt_mes_fim_p,'month',0)
  and PKG_DATE_UTILS.start_of(a.dt_inicio_venc,'month',0) = PKG_DATE_UTILS.start_of(dt_mes_p,'month',0);

C02 CURSOR FOR
	SELECT	distinct d.nr_seq_cliente,
		PKG_DATE_UTILS.start_of(coalesce(c.dt_vencimento,a.dt_inicio_venc),'month',0),
		coalesce(CASE WHEN b.ie_modalidade='LUT' THEN coalesce(a.vl_atual,0)  ELSE 0 END  - CASE WHEN b.ie_modalidade='LUT' THEN coalesce(a.vl_distribuidor,0)  ELSE 0 END ,0)
	FROM com_modalidade_lic b, com_cli_neg_lic_item a, com_cli_neg_lic d
LEFT OUTER JOIN com_cli_neg_lic_parc c ON (d.nr_sequencia = c.nr_seq_negoc_lic)
WHERE a.nr_seq_mod_licenc	= b.nr_sequencia  and coalesce(d.pr_reajuste::text, '') = '' and d.nr_sequencia		= a.nr_seq_neg_lic and (a.nr_seq_canal 		= nr_seq_canal_p or coalesce(nr_seq_canal_p,0) = 0) and PKG_DATE_UTILS.start_of(a.dt_inicio_venc,'month',0) between PKG_DATE_UTILS.start_of(dt_mes_inicio_p,'month',0) and PKG_DATE_UTILS.start_of(dt_mes_p,'month',0);
	--and	PKG_DATE_UTILS.start_of(a.dt_inicio_venc,'month',0) between PKG_DATE_UTILS.start_of(dt_mes_inicio_p,'month',0) and PKG_DATE_UTILS.END_OF(dt_mes_p, 'MONTH', 0)
	--and	PKG_DATE_UTILS.start_of(d.dt_assinatura,'month',0) 	between PKG_DATE_UTILS.start_of(dt_mes_inicio_p,'month',0) and PKG_DATE_UTILS.start_of(dt_mes_fim_p,'month',0);
C03 CURSOR FOR
	/* Quando possui parcela */

	SELECT	d.nr_seq_cliente,
		a.nr_seq_canal,
		(coalesce(c.vl_parcela,0)-(dividir(a.vl_distribuidor,qt_vencimento_w))) vl_lic_cdu
	from	com_modalidade_lic b,
		com_cli_neg_lic d,
		com_cli_neg_lic_item a,
		com_cli_neg_lic_parc c
	where	a.nr_seq_mod_licenc 	= b.nr_sequencia
	and	d.nr_sequencia 		= c.nr_seq_negoc_lic
	and	d.nr_sequencia 		= a.nr_seq_neg_lic
	and	coalesce(d.pr_reajuste::text, '') = ''
	and (a.nr_seq_canal 		= nr_seq_canal_p or coalesce(nr_seq_canal_p,0) = 0)
	--and	PKG_DATE_UTILS.start_of(d.dt_assinatura,'month',0) 	between PKG_DATE_UTILS.start_of(dt_mes_inicio_p,'month',0) and PKG_DATE_UTILS.start_of(dt_mes_fim_p,'month',0)
	and	PKG_DATE_UTILS.start_of(c.dt_vencimento,'month',0) = PKG_DATE_UTILS.start_of(dt_mes_p,'month',0)
	and	b.ie_modalidade	= 'CDU'
	
UNION
 /* Quando não possui parcela */
	SELECT	d.nr_seq_cliente,
		a.nr_seq_canal,
		(coalesce(a.vl_atual,0) - coalesce(a.vl_distribuidor,0)) vl_lic_cdu
	from	com_modalidade_lic b,
		com_cli_neg_lic d,
		com_cli_neg_lic_item a
	where	a.nr_seq_mod_licenc 	= b.nr_sequencia
	and	d.nr_sequencia 		= a.nr_seq_neg_lic
	and	coalesce(d.pr_reajuste::text, '') = ''
	and	not exists (select	1
				from	com_cli_neg_lic_parc x
				where	d.nr_sequencia	= x.nr_seq_negoc_lic)
	and (a.nr_seq_canal 		= nr_seq_canal_p or coalesce(nr_seq_canal_p,0) = 0)
	--and	PKG_DATE_UTILS.start_of(d.dt_assinatura,'month',0) 	between PKG_DATE_UTILS.start_of(dt_mes_inicio_p,'month',0) and PKG_DATE_UTILS.start_of(dt_mes_fim_p,'month',0)
	and	PKG_DATE_UTILS.start_of(a.dt_inicio_venc,'month',0) = PKG_DATE_UTILS.start_of(dt_mes_p,'month',0)
	and	b.ie_modalidade	= 'CDU';


BEGIN

select	coalesce(count(distinct c.dt_vencimento),0)
into STRICT	qt_vencimento_w
FROM com_modalidade_lic b, com_cli_neg_lic_item a, com_cli_neg_lic d
LEFT OUTER JOIN com_cli_neg_lic_parc c ON (d.nr_sequencia = c.nr_seq_negoc_lic)
WHERE a.nr_seq_mod_licenc 	= b.nr_sequencia  and d.nr_sequencia 		= a.nr_seq_neg_lic and coalesce(d.pr_reajuste::text, '') = '' and (a.nr_seq_canal 		= nr_seq_canal_p or coalesce(nr_seq_canal_p,0) = 0) and PKG_DATE_UTILS.start_of(d.dt_assinatura,'month',0) between PKG_DATE_UTILS.start_of(dt_mes_inicio_p,'month',0) and PKG_DATE_UTILS.start_of(dt_mes_fim_p,'month',0);

if (ie_opcao_p in ('1','2','5','6')) then
	/*Dados Previstos*/

	select	sum(CASE WHEN b.ie_modalidade='LUT' THEN coalesce(a.qt_licenca,0)  ELSE 0 END ) qt_licenca_lut,
		sum(CASE WHEN b.ie_modalidade='CDU' THEN coalesce(a.qt_licenca,0)  ELSE 0 END ) qt_licenca_cdu,
		sum(CASE WHEN b.ie_modalidade='LUT' THEN coalesce(a.vl_licenca,0)  ELSE 0 END ) vl_lic_lut,
		sum(CASE WHEN b.ie_modalidade='CDU' THEN coalesce(a.vl_licenca,0)  ELSE 0 END ) vl_lic_cdu
	into STRICT	qt_licenca_lut_prev_w,
		qt_licenca_cdu_prev_w,
		vl_licenca_lut_prev_w,
		vl_licenca_cdu_prev_w
	from	com_modalidade_lic b,
		com_meta_venda a
	where	a.nr_seq_mod_licenc = b.nr_sequencia
	and (a.nr_seq_canal = nr_seq_canal_p or coalesce(nr_seq_canal_p,0) = 0)
	and	PKG_DATE_UTILS.start_of(a.dt_mes_ref,'month',0) = PKG_DATE_UTILS.start_of(dt_mes_p,'month',0);
elsif (ie_opcao_p in ('3','4','7')) then
	/*Dados Reais*/

	open C01;
	loop
	fetch C01 into
		nr_seq_cliente_w,
		qt_licenca_lut_real_ww,
		qt_licenca_cdu_real_ww,
		vl_licenca_lut_real_ww;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		qt_licenca_lut_real_w	:= coalesce(qt_licenca_lut_real_w,0) + coalesce(qt_licenca_lut_real_ww,0);
		qt_licenca_cdu_real_w	:= coalesce(qt_licenca_cdu_real_w,0) + coalesce(qt_licenca_cdu_real_ww,0);
		vl_licenca_lut_real_w	:= coalesce(vl_licenca_lut_real_w,0) + coalesce(vl_licenca_lut_real_ww,0);
		end;
	end loop;
	close C01;
elsif (ie_opcao_p = '8') then
	open C03;
	loop
	fetch C03 into
		nr_seq_cliente_w,
		nr_seq_canal_w,
		vl_licenca_cdu_real_ww;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin
		vl_licenca_cdu_real_w	:= coalesce(vl_licenca_cdu_real_w,0) + coalesce(vl_licenca_cdu_real_ww,0);
		end;
	end loop;
	close C03;

elsif (ie_opcao_p = '9') then
	select  sum(a.vl_licenca)
	into STRICT    vl_licenca_lut_prev_acum_w
	from    com_modalidade_lic b,
	        com_meta_venda a
	where   a.nr_seq_mod_licenc 	= b.nr_sequencia
	and     b.ie_modalidade 	= 'LUT'
	and (a.nr_seq_canal 	= nr_seq_canal_p or nr_seq_canal_p = 0)
	and     PKG_DATE_UTILS.start_of(a.dt_mes_ref,'month',0) between PKG_DATE_UTILS.start_of(dt_mes_inicio_p,'month',0) and PKG_DATE_UTILS.END_OF(dt_mes_p, 'MONTH', 0);
elsif (ie_opcao_p = '10') then
	open C02;
	loop
	fetch C02 into
		nr_seq_cliente_w,
		dt_mes_w,
		vl_licenca_lut_real_acum_ww;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		vl_licenca_lut_real_acum_w := coalesce(vl_licenca_lut_real_acum_w,0) + coalesce(vl_licenca_lut_real_acum_ww,0);
		end;
	end loop;
	close C02;
elsif (ie_opcao_p	= '11') then
	select	sum(vl_lic_lut)
	into STRICT	vl_total_lut_acum_w
	from (	SELECT	distinct d.nr_seq_cliente,
				a.nr_seq_canal,
				PKG_DATE_UTILS.start_of(coalesce(c.dt_vencimento,a.dt_inicio_venc),'month',0),
				coalesce(a.vl_total,0) vl_lic_lut
			FROM com_modalidade_lic b, com_cli_neg_lic_item a, com_cli_neg_lic d
LEFT OUTER JOIN com_cli_neg_lic_parc c ON (d.nr_sequencia = c.nr_seq_negoc_lic)
WHERE a.nr_seq_mod_licenc 	= b.nr_sequencia  and d.nr_sequencia 		= a.nr_seq_neg_lic and coalesce(d.pr_reajuste::text, '') = '' and (a.nr_seq_canal 		= nr_seq_canal_p or coalesce(nr_seq_canal_p,0) = 0) and PKG_DATE_UTILS.start_of(coalesce(c.dt_vencimento,a.dt_inicio_venc),'month',0) between PKG_DATE_UTILS.start_of(dt_mes_inicio_p,'month',0) and PKG_DATE_UTILS.start_of(dt_mes_p,'month',0) and b.ie_modalidade	= 'LUT' ) alias12;
elsif (ie_opcao_p = '12') then
	select	sum(vl_lic_cdu)
	into STRICT	vl_total_cdu_acum_w
	from (	SELECT	d.nr_seq_cliente,
				a.nr_seq_canal,
				CASE WHEN b.ie_modalidade='CDU' THEN coalesce(c.vl_parcela,0)  ELSE 0 END  vl_lic_cdu
			from	com_modalidade_lic b,
				com_cli_neg_lic d,
				com_cli_neg_lic_item a,
				com_cli_neg_lic_parc c
			where	a.nr_seq_mod_licenc 	= b.nr_sequencia
			and	d.nr_sequencia 		= c.nr_seq_negoc_lic
			and	d.nr_sequencia 		= a.nr_seq_neg_lic
			and	coalesce(d.pr_reajuste::text, '') = ''
			and (a.nr_seq_canal 		= nr_seq_canal_p or coalesce(nr_seq_canal_p,0) = 0)
			and	PKG_DATE_UTILS.start_of(c.dt_vencimento,'month',0) = PKG_DATE_UTILS.start_of(dt_mes_p,'month',0)
			and	b.ie_modalidade	= 'CDU'
			
UNION

			SELECT	d.nr_seq_cliente,
				a.nr_seq_canal,
				CASE WHEN b.ie_modalidade='CDU' THEN coalesce(a.vl_total,0)  ELSE 0 END  vl_lic_cdu
			from	com_modalidade_lic b,
				com_cli_neg_lic d,
				com_cli_neg_lic_item a
			where	a.nr_seq_mod_licenc 	= b.nr_sequencia
			and	d.nr_sequencia 		= a.nr_seq_neg_lic
			and	coalesce(d.pr_reajuste::text, '') = ''
			and	not exists (select	1
						from	com_cli_neg_lic_parc x
						where	d.nr_sequencia	= x.nr_seq_negoc_lic)
			and (a.nr_seq_canal 		= nr_seq_canal_p or coalesce(nr_seq_canal_p,0) = 0)
			and	PKG_DATE_UTILS.start_of(a.dt_inicio_venc,'month',0) = PKG_DATE_UTILS.start_of(dt_mes_p,'month',0)
			and	b.ie_modalidade	= 'CDU') alias15;
end if;

if (ie_opcao_p = '1') then
	return qt_licenca_lut_prev_w;
elsif (ie_opcao_p = '2') then
	return qt_licenca_cdu_prev_w;
elsif (ie_opcao_p = '3') then
	return qt_licenca_lut_real_w;
elsif (ie_opcao_p = '4') then
	return qt_licenca_cdu_real_w;
elsif (ie_opcao_p = '5') then
	return vl_licenca_lut_prev_w;
elsif (ie_opcao_p = '6') then
	return vl_licenca_cdu_prev_w;
elsif (ie_opcao_p = '7') then
	return vl_licenca_lut_real_w;
elsif (ie_opcao_p = '8') then
	return vl_licenca_cdu_real_w;
elsif (ie_opcao_p = '9') then
	return vl_licenca_lut_prev_acum_w;
elsif (ie_opcao_p = '10') then
	return vl_licenca_lut_real_acum_w;
elsif (ie_opcao_p = '11') then
	return vl_total_lut_acum_w;
elsif (ie_opcao_p = '12') then
	return vl_total_cdu_acum_w;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION com_obter_dados_neg_comercial ( dt_mes_inicio_p timestamp, dt_mes_fim_p timestamp, dt_mes_p timestamp, nr_seq_canal_p bigint, ie_opcao_p text) FROM PUBLIC;

