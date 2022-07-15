-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_fatur_cliente ( cd_cnpj_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, ie_resp_atend_p text, nr_seq_canal_p bigint, ie_total_p text) AS $body$
DECLARE


/*
ie_total_p
	S - Considera a soma de todos os valores
	N - Considera apenas as somas de LUT, CDU e Manutenção
*/
/*Procedure criada por Matheus para o relatorio WCOM 61057 */

ie_tipo_w				smallint;
qt_minuto_w			double precision		:= 0;
vl_cobranca_w			double precision		:= 0;
qt_hor_sup_w			double precision		:= 0;
qt_hor_des_w			double precision		:= 0;
vl_hor_sup_w			double precision		:= 0;
vl_hor_des_w			double precision		:= 0;
vl_total_horas_w			double precision		:= 0;
vl_total_w			double precision		:= 0;
vl_cdu_w				double precision		:= 0;
vl_impl_w				double precision		:= 0;
vl_treinamento_w			double precision		:= 0;
vl_manut_w			double precision		:= 0;
vl_lut_w				double precision		:= 0;
vl_repasse_w			double precision		:= 0;
qt_hora_w			double precision		:= 0;
nr_seq_localizacao_w		bigint;
cd_cnpj_w			varchar(14)		:= '';
dt_inicio_w			timestamp;
dt_fim_w				timestamp;
ie_abc_w				varchar(1);

vl_geral_w			double precision;
vl_acum_w			double precision;
pr_acum_w			double precision;
pr_cli_w				double precision := 0;


c01 CURSOR FOR
SELECT	a.cd_cnpj
from	com_cliente a
where	a.ie_classificacao	= 'C'
and	a.ie_situacao		= 'A'
and	((ie_resp_atend_p = 'A') or (ie_resp_atend_p = a.ie_resp_atend))
and (a.cd_cnpj = coalesce(cd_cnpj_p,a.cd_cnpj))
and	exists (select	1
		from	com_canal_cliente b
		where	a.nr_sequencia = b.nr_seq_cliente
		and	b.nr_seq_canal = CASE WHEN coalesce(nr_seq_canal_p,0)=0 THEN b.nr_seq_canal  ELSE nr_seq_canal_p END
		and	coalesce(b.dt_fim_atuacao::text, '') = ''
		and	b.ie_situacao = 'A'
		and	b.ie_tipo_atuacao = 'V');

c02 CURSOR FOR
SELECT	1,
	sum(coalesce(a.qt_minuto,0)),
	sum(coalesce(a.vl_cobranca,0))
from	man_ordem_serv_ativ a,
	man_ordem_servico b
where	a.nr_seq_ordem_serv = b.nr_sequencia
and	trunc(a.dt_atividade,'dd') between dt_inicio_w and dt_fim_w
and	b.nr_seq_localizacao = nr_seq_localizacao_w
and	exists (	select	1
			from	usuario_grupo_des x
			where	b.nr_seq_grupo_des = x.nr_seq_grupo
			and	a.nm_usuario_exec = x.nm_usuario_grupo)

union

selecT	2,
	sum(a.qt_minuto),
	sum(a.vl_cobranca)
from	man_ordem_serv_ativ a,
	man_ordem_servico b
where	a.nr_seq_ordem_serv = b.nr_sequencia
and	trunc(a.dt_atividade,'dd') between dt_inicio_w and dt_fim_w
and	b.nr_seq_localizacao = nr_seq_localizacao_w
and	exists (	select	1
			from	usuario_grupo_sup x
			where	b.nr_seq_grupo_sup = x.nr_seq_grupo
			and	a.nm_usuario_exec = x.nm_usuario_grupo);

c09 CURSOR FOR
SELECT	cd_cnpj, vl_total
from	com_w_fatur_cliente
order by vl_total desc;


BEGIN

delete from com_w_fatur_cliente;

dt_inicio_w			:= trunc(dt_inicial_p,'month');
dt_fim_w				:= trunc(dt_final_p,'dd') + 86399/86400;
ie_abc_w				:= 'A';

open c01;
loop
fetch	c01 into
	cd_cnpj_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	select	max(nr_sequencia)
	into STRICT	nr_seq_localizacao_w
	from	man_localizacao
	where	cd_cnpj	= cd_cnpj_w;

	vl_total_horas_w	:= 0;
	qt_hor_des_w		:= 0;
	qt_hor_sup_w		:= 0;
	vl_hor_des_w		:= 0;
	vl_hor_sup_w		:= 0;
	qt_hora_w		:= 0;

	select	sum(vl_total_item_nf) vl_total,
		sum(CASE WHEN cd_procedimento=69000400 THEN  vl_total_item_nf WHEN cd_procedimento=6900700 THEN  vl_total_item_nf  ELSE 0 END ) vl_cdu,
		sum(CASE WHEN cd_procedimento=69000200 THEN  vl_total_item_nf  ELSE 0 END ) vl_impl,
		sum(CASE WHEN cd_procedimento=69000600 THEN  vl_total_item_nf  ELSE 0 END ) vl_treinamento,
		sum(CASE WHEN cd_procedimento=69000100 THEN  vl_total_item_nf  ELSE 0 END ) vl_manut,
		sum(CASE WHEN cd_procedimento=69000500 THEN  vl_total_item_nf  ELSE 0 END ) vl_lut,
		sum((	select	coalesce(sum(vl_repasse),0)
		 	from	nota_fiscal_item_rep r
		 	where	r.nr_seq_nf = a.nr_sequencia
		 	and	b.nr_item_nf = r.nr_seq_item_nf)) vl_repasse
	into STRICT	vl_total_w,
		vl_cdu_w,
		vl_impl_w,
		vl_treinamento_w,
		vl_manut_w,
		vl_lut_w,
		vl_repasse_w
	from	nota_fiscal_item b,
		nota_fiscal a
	where 	a.nr_sequencia	= b.nr_sequencia
	and	(b.cd_procedimento IS NOT NULL AND b.cd_procedimento::text <> '')
	and	a.ie_situacao		= 1
	and	trunc(dt_emissao,'dd') between dt_inicio_w and dt_fim_w
	and	a.cd_cgc		= cd_cnpj_w;

	if (coalesce(ie_total_p,'S') = 'N') then
		vl_total_w	:= coalesce(vl_cdu_w,0) + coalesce(vl_manut_w,0) + coalesce(vl_lut_w,0);
	end if;


	open c02;
	loop
	fetch	c02 into
		ie_tipo_w,
		qt_minuto_w,
		vl_cobranca_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		qt_hora_w		:= round((dividir(qt_minuto_w,60))::numeric,2);

		if (ie_tipo_w = 1) then
			qt_hor_des_w	:= qt_hor_des_w + qt_hora_w;
			vl_hor_des_w	:= vl_hor_des_w + vl_cobranca_w;
		elsif (ie_tipo_w = 2) then
			qt_hor_sup_w	:= qt_hor_sup_w + qt_hora_w;
			vl_hor_sup_w	:= vl_hor_sup_w + vl_cobranca_w;
		end if;
		vl_total_horas_w	:= vl_total_horas_w + vl_cobranca_w;
	end loop;
	close c02;

	qt_hor_des_w	:= round((qt_hor_des_w)::numeric,0);
	qt_hor_sup_w	:= round((qt_hor_sup_w)::numeric,0);

	insert into com_w_fatur_cliente(
		cd_cnpj,
		qt_hor_sup,
		qt_hor_des,
		vl_hor_sup,
		vl_hor_des,
		vl_total_horas,
		vl_total,
		vl_cdu,
		vl_impl,
		vl_treinamento,
		vl_manut,
		vl_lut,
		vl_repasse,
		ie_abc,
		pr_cliente)
	values (	cd_cnpj_w,
		CASE WHEN coalesce(qt_hor_sup_w::text, '') = '' THEN 0  ELSE qt_hor_sup_w END ,
		CASE WHEN coalesce(qt_hor_des_w::text, '') = '' THEN 0  ELSE qt_hor_des_w END ,
		CASE WHEN coalesce(vl_hor_sup_w::text, '') = '' THEN 0  ELSE vl_hor_sup_w END ,
		CASE WHEN coalesce(vl_hor_des_w::text, '') = '' THEN 0  ELSE vl_hor_des_w END ,
		CASE WHEN coalesce(vl_total_horas_w::text, '') = '' THEN 0  ELSE vl_total_horas_w END ,
		CASE WHEN coalesce(vl_total_w::text, '') = '' THEN 0  ELSE vl_total_w END ,
		CASE WHEN coalesce(vl_cdu_w::text, '') = '' THEN 0  ELSE vl_cdu_w END ,
		CASE WHEN coalesce(vl_impl_w::text, '') = '' THEN 0  ELSE vl_impl_w END ,
		CASE WHEN coalesce(vl_treinamento_w::text, '') = '' THEN 0  ELSE vl_treinamento_w END ,
		CASE WHEN coalesce(vl_manut_w::text, '') = '' THEN 0  ELSE vl_manut_w END ,
		CASE WHEN coalesce(vl_lut_w::text, '') = '' THEN 0  ELSE vl_lut_w END ,
		CASE WHEN coalesce(vl_repasse_w::text, '') = '' THEN 0  ELSE vl_repasse_w END ,
		ie_abc_w,
		0);

	end;
end loop;
close c01;

select	sum(vl_total)
into STRICT	vl_geral_w
from	com_w_fatur_cliente;
vl_acum_w	:= 0;

open c09;
loop
fetch	c09 into
	cd_cnpj_w,
	vl_total_w;
EXIT WHEN NOT FOUND; /* apply on c09 */
	vl_acum_w	:= vl_acum_w + vl_total_w;
	pr_acum_w	:= dividir((vl_acum_w * 100), vl_geral_w);
	pr_cli_w	:= dividir((vl_total_w * 100), vl_geral_w);

	if (pr_acum_w < 70) then
		ie_abc_w	:= 'A';
	elsif (pr_acum_w < 90) then
		ie_abc_w	:= 'B';
	else
		ie_abc_w	:= 'C';
	end if;

	update	com_w_fatur_cliente
	set	ie_abc		= ie_abc_w,
		pr_cliente	= pr_cli_w
	where	cd_cnpj		= cd_cnpj_w;

end loop;
close c09;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_fatur_cliente ( cd_cnpj_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, ie_resp_atend_p text, nr_seq_canal_p bigint, ie_total_p text) FROM PUBLIC;

