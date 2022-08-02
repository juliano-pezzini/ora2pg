-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ratear_titulo_rec_liq_cc ( nr_titulo_p bigint, nr_seq_baixa_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_interno_conta_w	bigint;
vl_glosa_item_w		double precision;
vl_amaior_item_w	double precision;
vl_guia_w		double precision;

cd_centro_custo_w	bigint;
pr_centro_custo_w	double precision;

vl_glosa_w		double precision;
vl_amaior_w		double precision;

vl_glosa_acum_w		double precision;
vl_amaior_acum_w	double precision;

ie_cc_glosa_w		varchar(15);
cd_estabelecimento_w	smallint;
vl_rec_item_w		titulo_receber_liq.vl_recebido%type;
vl_recebido_w		double precision;
vl_descontos_item_w	titulo_receber_liq.vl_descontos%type;	
vl_juros_item_w		titulo_receber_liq.vl_juros%type;					
vl_multa_item_w		titulo_receber_liq.vl_multa%type;
vl_descontos_w		titulo_rec_liq_cc.vl_desconto%type;
vl_juros_w		titulo_rec_liq_cc.vl_juros%type;
vl_multa_w		titulo_rec_liq_cc.vl_multa%type;	

vl_titulo_w		titulo_receber.vl_titulo%type;
vl_conta_w		conta_paciente.vl_conta%type;
vl_glosa_liq_w		titulo_receber_liq.vl_glosa%type;
vl_rec_maior_liq_w	titulo_receber_liq.vl_rec_maior%type;
vl_recebido_liq_w	titulo_receber_liq.vl_recebido%type;
vl_desconto_liq_w	titulo_receber_liq.vl_descontos%type;
vl_juros_liq_w		titulo_receber_liq.vl_juros%type;
vl_multa_liq_w		titulo_receber_liq.vl_multa%type;


/*cursor c01 is
	select	cd_centro_custo,
		dividir(sum(vl_item),vl_guia_w)
	from (
	select	nvl(b.cd_centro_custo, cd_centro_custo_w) cd_centro_custo,
		sum(vl_procedimento) vl_item
	from	setor_atendimento b,
		procedimento_paciente a
	where	a.nr_interno_conta	= nr_interno_conta_w
	  and	a.cd_setor_atendimento	= b.cd_setor_atendimento
	  and 	a.cd_motivo_exc_conta is null
	group by nvl(b.cd_centro_custo, cd_centro_custo_w)
	union all
	select	nvl(b.cd_centro_custo, cd_centro_custo_w) cd_centro_custo,
		sum(vl_material)
	from	setor_atendimento b,
		material_atend_paciente a
	where	a.nr_interno_conta	= nr_interno_conta_w
	  and 	a.cd_motivo_exc_conta is null
	  and	a.cd_setor_atendimento	= b.cd_setor_atendimento
	group by nvl(b.cd_centro_custo, cd_centro_custo_w))
	where	nr_interno_conta_w <> 0
	group by cd_centro_custo;*/
	
c01 CURSOR FOR
SELECT	cd_centro_custo,
		--dividir_sem_round(sum(vl_item),vl_guia_w)
		sum(vl_item)
	from (SELECT	coalesce(c.cd_centro_custo, cd_centro_custo_w) cd_centro_custo,
			coalesce(sum(b.vl_procedimento),0) vl_item
		from	atendimento_paciente d,
			setor_atendimento c,
			procedimento_paciente b
		where	b.cd_setor_atendimento	= c.cd_setor_atendimento
		and	b.nr_interno_conta	= nr_interno_conta_w
		and	coalesce(b.nr_seq_proc_pacote, b.nr_sequencia) = b.nr_sequencia
		and	b.nr_atendimento	= d.nr_atendimento
		and	coalesce(b.cd_motivo_exc_conta::text, '') = ''
		group	by
			coalesce(c.cd_centro_custo, cd_centro_custo_w),
			d.ie_tipo_atendimento,
			c.cd_centro_custo_receita,
			obter_tipo_protocolo(obter_protocolo_conpaci(b.nr_interno_conta))
		
union 	all

		select	coalesce(c.cd_centro_custo, cd_centro_custo_w),
			coalesce(sum(b.vl_material),0) vl_item
		from	atendimento_paciente d,
			setor_atendimento c,
			material_atend_paciente b
		where	b.cd_setor_atendimento	= c.cd_setor_atendimento
		and	b.nr_interno_conta	= nr_interno_conta_w
		and	b.nr_atendimento	= d.nr_atendimento
		and	coalesce(b.nr_seq_proc_pacote::text, '') = ''
		and	coalesce(b.cd_motivo_exc_conta::text, '') = ''
		group	by
			coalesce(c.cd_centro_custo, cd_centro_custo_w) ) alias15
	group	by
		cd_centro_custo;
	


BEGIN

select	b.ie_cc_glosa,
	b.cd_centro_custo_glosa,
	a.cd_estabelecimento
into STRICT	ie_cc_glosa_w,
	cd_centro_custo_w,
	cd_estabelecimento_w
from	parametro_contas_receber b,
	titulo_receber a
where	a.nr_titulo		= nr_titulo_p
and	a.cd_estabelecimento	= b.cd_estabelecimento;

vl_amaior_w		:= 0;

select	max(b.nr_interno_conta),
	max(vl_glosado),
	max(vl_adicional),
	max(c.vl_guia),
	max(a.vl_recebido),
	coalesce(max(a.vl_descontos),0),
	coalesce(max(a.vl_juros),0),
	coalesce(max(a.vl_multa),0)
into STRICT	nr_interno_conta_w,
	vl_glosa_item_w,
	vl_amaior_item_w,
	vl_guia_w,
	vl_rec_item_w,
	vl_descontos_item_w,
	vl_juros_item_w,
	vl_multa_item_w
from	conta_paciente_guia c,
	convenio_retorno_item b,
	titulo_receber_liq a
where	a.nr_seq_ret_item 	= b.nr_sequencia
  and	b.nr_interno_conta	= c.nr_interno_conta
  and	b.cd_autorizacao	= c.cd_autorizacao
  and	a.nr_titulo		= nr_titulo_p
  and	a.nr_sequencia		= nr_seq_baixa_p;

vl_glosa_acum_w		:= vl_glosa_item_w;
vl_amaior_acum_w	:= vl_amaior_item_w;


if (coalesce(nr_interno_conta_w,0)  = 0) then
	select  coalesce(max(b.nr_interno_conta),0)
	into STRICT    nr_interno_conta_w
	from    convenio_retorno_item b,
		titulo_receber_liq a
	where   a.nr_sequencia  	= nr_seq_baixa_p
	and 	a.nr_titulo     	= nr_titulo_p
	and 	a.nr_seq_ret_item   	= b.nr_sequencia;
end if;

select  max(vl_conta)
into STRICT    vl_conta_w
from    conta_paciente
where   nr_interno_conta    = nr_interno_conta_w;

select	max(vl_titulo)
into STRICT	vl_titulo_w
from	titulo_receber
where   nr_titulo       = nr_titulo_p;

select  coalesce(max(vl_glosa),0),
	coalesce(max(vl_rec_maior),0),
	coalesce(max(vl_recebido),0),
	coalesce(max(vl_descontos),0),
	coalesce(max(vl_juros),0),
	coalesce(max(vl_multa),0)
into STRICT    vl_glosa_liq_w,
	vl_rec_maior_liq_w,
	vl_recebido_liq_w,
	vl_desconto_liq_w,
	vl_juros_liq_w,
	vl_multa_liq_w
from    titulo_receber_liq
where   nr_titulo       = nr_titulo_p
and nr_sequencia        = nr_seq_baixa_p;



open c01;
loop
fetch c01 into	cd_centro_custo_w,
		pr_centro_custo_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	--vl_glosa_w		:= vl_glosa_item_w * pr_centro_custo_w;
	vl_glosa_w		:= coalesce((pr_centro_custo_w * dividir_sem_round(vl_titulo_w, vl_conta_w)) * (dividir_sem_round(vl_glosa_liq_w, vl_titulo_w)),0);
	--vl_amaior_w		:= vl_amaior_item_w * pr_centro_custo_w;
	vl_amaior_w		:= coalesce((pr_centro_custo_w * dividir_sem_round(vl_titulo_w, vl_conta_w)) * (dividir_sem_round(vl_rec_maior_liq_w, vl_titulo_w)),0);
	--vl_recebido_w		:= vl_rec_item_w * pr_centro_custo_w;
	vl_recebido_w		:= coalesce((pr_centro_custo_w * dividir_sem_round(vl_titulo_w, vl_conta_w)) * (dividir_sem_round(vl_recebido_liq_w, vl_titulo_w)),0);
	vl_glosa_acum_w 	:= vl_glosa_acum_w - vl_glosa_w;
	vl_amaior_acum_w	:= vl_amaior_acum_w - vl_amaior_w;
	--vl_descontos_w 		:= vl_descontos_item_w * pr_centro_custo_w;
	vl_descontos_w 		:= coalesce((pr_centro_custo_w * dividir_sem_round(vl_titulo_w, vl_conta_w)) * (dividir_sem_round(vl_desconto_liq_w, vl_titulo_w)),0);
	--vl_juros_w 			:= vl_juros_item_w * pr_centro_custo_w;
	vl_juros_w 			:= coalesce((pr_centro_custo_w * dividir_sem_round(vl_titulo_w, vl_conta_w)) * (dividir_sem_round(vl_juros_liq_w, vl_titulo_w)),0);
	--vl_multa_w 			:= vl_multa_item_w * pr_centro_custo_w;
	vl_multa_w 			:= coalesce((pr_centro_custo_w * dividir_sem_round(vl_titulo_w, vl_conta_w)) * (dividir_sem_round(vl_multa_liq_w, vl_titulo_w)),0);
	if (cd_centro_custo_w IS NOT NULL AND cd_centro_custo_w::text <> '') then

		insert into titulo_rec_liq_cc(	
			nr_sequencia, nr_titulo, nr_seq_baixa, dt_atualizacao,
			nm_usuario, cd_centro_custo, vl_baixa, vl_amaior, vl_recebido,
			vl_desconto, vl_juros, vl_multa)
		values (	
			nextval('titulo_rec_liq_cc_seq'), nr_titulo_p, nr_seq_baixa_p, clock_timestamp(),
			nm_usuario_p, cd_centro_custo_w, vl_glosa_w, vl_amaior_w, vl_recebido_w,
			vl_descontos_w, vl_juros_w, vl_multa_w);	
	end if;
end loop;
close c01;
if (vl_glosa_acum_w <> 0) then
	update	titulo_rec_liq_cc
	set	vl_baixa = vl_baixa + vl_glosa_acum_w
	where	nr_sequencia = (SELECT max(nr_sequencia) from titulo_rec_liq_cc
				where nr_titulo = nr_titulo_p
				  and nr_seq_baixa = nr_seq_baixa_p);
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ratear_titulo_rec_liq_cc ( nr_titulo_p bigint, nr_seq_baixa_p bigint, nm_usuario_p text) FROM PUBLIC;

