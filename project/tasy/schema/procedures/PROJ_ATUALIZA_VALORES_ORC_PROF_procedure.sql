-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE proj_atualiza_valores_orc_prof ( nr_seq_orc_prof_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
cd_executor_w			varchar(10);
vl_custo_total_w		double precision	:= 0;
pr_adic_clt_w			double precision	:= 0;
vl_adicional_clt_w		double precision	:= 0;
nr_seq_orc_w			bigint;
dt_orcamento_w			timestamp;
pr_imposto_w			double precision	:= 0;
vl_imposto_w			double precision	:= 0;
vl_receita_total_w		double precision	:= 0;
vl_margem_w			double precision	:= 0;
ie_regime_contr_w		varchar(15);
pr_custo_inst_w			double precision	:= 0;
vl_custo_inst_w			double precision	:= 0;
qt_semana_w			bigint;
qt_hora_sem_w			bigint;
qt_horas_w			bigint;
nr_seq_nivel_cons_w		bigint;
vl_hora_rec_w			double precision;
vl_custo_hora_w			double precision;


BEGIN 
 
begin 
select	cd_executor, 
	coalesce(vl_hora_rec,0), 
	coalesce(vl_custo_hora,0), 
	vl_custo_total, 
	vl_receita_total, 
	nr_seq_orc, 
	coalesce(qt_semana,0), 
	coalesce(qt_hora_sem,0), 
	coalesce(nr_seq_nivel_cons,0) 
into STRICT	cd_executor_w, 
	vl_hora_rec_w, 
	vl_custo_hora_w, 
	vl_custo_total_w, 
	vl_receita_total_w, 
	nr_seq_orc_w, 
	qt_semana_w, 
	qt_hora_sem_w, 
	nr_seq_nivel_cons_w 
from	proj_orc_prof 
where	nr_sequencia	= nr_seq_orc_prof_p;
exception 
	when others then 
	cd_executor_w	:= '';
	qt_semana_w	:= 0;
	qt_hora_sem_w	:= 0;
	vl_hora_rec_w	:= 0;
	vl_custo_hora_w	:= 0;
end;
 
begin 
select	dt_orcamento 
into STRICT	dt_orcamento_w 
from	proj_orcamento 
where	nr_sequencia	= nr_seq_orc_w;
exception 
	when others then 
	dt_orcamento_w	:= null;
end;
 
qt_horas_w	:= qt_semana_w * qt_hora_sem_w;
 
if (vl_custo_hora_w = 0) then 
	vl_custo_hora_w		:= proj_obter_valor_hora_orc(nr_seq_nivel_cons_w, cd_executor_w, nr_seq_orc_w, 1);
end if;
 
if (vl_hora_rec_w	= 0) then 
	vl_hora_rec_w		:= proj_obter_valor_hora_orc(nr_seq_nivel_cons_w, cd_executor_w, nr_seq_orc_w, 2);
end if;
 
vl_custo_total_w	:= vl_custo_hora_w * qt_horas_w;
vl_receita_total_w	:= vl_hora_rec_w * qt_horas_w;
 
select	coalesce(max(ie_regime_contr),'PJ') 
into STRICT	ie_regime_contr_w 
from	com_canal_consultor 
where	cd_pessoa_fisica	= cd_executor_w;
 
if (ie_regime_contr_w	= 'CLT') then 
	pr_adic_clt_w		:= proj_obter_perc_clt(dt_orcamento_w,1);
	vl_adicional_clt_w	:= dividir((vl_custo_total_w * pr_adic_clt_w),100);
else 
	vl_adicional_clt_w	:= 0;
end if;
 
pr_imposto_w	:= proj_obter_perc_imposto_fat(dt_orcamento_w);
vl_imposto_w	:= dividir((vl_receita_total_w * pr_imposto_w),100);
 
pr_custo_inst_w	:= proj_obter_perc_custo_inst(dt_orcamento_w);
vl_custo_inst_w	:= dividir((vl_receita_total_w * pr_custo_inst_w),100);
 
vl_margem_w	:= vl_receita_total_w - (vl_custo_total_w + vl_imposto_w + vl_adicional_clt_w);
 
update	proj_orc_prof 
set	vl_custo_hora		= vl_custo_hora_w, 
	vl_custo_total		= vl_custo_total_w, 
	vl_hora_rec		= vl_hora_rec_w, 
	vl_receita_total	= vl_receita_total_w, 
	vl_adicional_clt	= vl_adicional_clt_w, 
	vl_imposto		= vl_imposto_w, 
	vl_custo_inst		= vl_custo_inst_w, 
	vl_margem		= vl_margem_w, 
	qt_horas		= qt_horas_w 
where	nr_sequencia		= nr_seq_orc_prof_p;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE proj_atualiza_valores_orc_prof ( nr_seq_orc_prof_p bigint, nm_usuario_p text) FROM PUBLIC;
