-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ajustar_resp_cred_proc_glosa ( nr_sequencia_p bigint) AS $body$
DECLARE


cd_estabelecimento_w      	smallint  	:= 0;
ie_tipo_atendimento_w     	smallint    	:= 0;
nr_atendimento_w	  	bigint;
cd_convenio_w             	integer    	:= 0;
cd_categoria_w            	varchar(10);
cd_medico_executor_w      	varchar(10);
ie_origem_proced_w        	bigint    	:= 0;
cd_setor_atendimento_w    	integer  	:= 0;
cd_procedimento_w	bigint;
dt_procedimento_w	  	timestamp;

cd_regra_w		varchar(10);
cd_regra_honorario_w	varchar(5);
cd_pessoa_honorario_w	varchar(10);
cd_cgc_honorario_w	varchar(14);
ie_conta_honorario_w	varchar(1);
ie_calcula_honorario_w	varchar(1)	:= 'S';
nr_seq_criterio_w		bigint;
ie_tipo_servico_sus_w	smallint;
ie_tipo_ato_sus_w		smallint;
cd_cgc_prestador_w	varchar(14);
nr_seq_proc_pacote_w	bigint;
ie_pacote_w		varchar(1)	:=  'A';
ie_carater_inter_sus_w	varchar(2);
cd_especialidade_medica_w	integer:= 0;
nr_seq_classif_medico_w	bigint;
cd_procedencia_w		integer;
ie_doc_executor_w		smallint;
cd_cbo_w		varchar(06);
nr_seq_proc_interno_w	bigint;
ie_clinica_w		integer;
ie_funcao_medico_w	varchar(10);
vl_procedimento_w		double precision;
vl_custo_oper_orig_w    	double precision 	:= 0;
vl_anestesista_orig_w      	double precision 	:= 0;
vl_medico_orig_w           	double precision 	:= 0;
vl_materiais_orig_w        	double precision 	:= 0;
vl_auxiliares_orig_w       	double precision 	:= 0;
ie_classificacao_w		varchar(1);
ie_regra_honorario_servico_w	varchar(1);
vl_custo_operacional_w		double precision	:= 0;
nr_seq_exame_w		bigint;



BEGIN
select	cd_convenio,
	cd_categoria,
	cd_medico_executor,
	ie_origem_proced,
	cd_setor_atendimento,
	cd_procedimento,
	dt_procedimento,
	nr_atendimento,
	ie_tipo_servico_sus,
	ie_tipo_ato_sus,
	cd_cgc_prestador,
	nr_seq_proc_pacote,
	cd_especialidade,
	ie_doc_executor,
	cd_cbo,
	nr_seq_proc_interno,
	ie_funcao_medico,
	coalesce(vl_procedimento,0),
	coalesce(vl_custo_operacional,0),
	coalesce(vl_anestesista,0),
	coalesce(vl_medico,0),
	coalesce(vl_materiais,0),
	coalesce(vl_auxiliares,0),
	nr_seq_exame
into STRICT	cd_convenio_w,
	cd_categoria_w,
	cd_medico_executor_w,
	ie_origem_proced_w,
	cd_setor_atendimento_w,
	cd_procedimento_w,
	dt_procedimento_w,
	nr_atendimento_w,
	ie_tipo_servico_sus_w,
	ie_tipo_ato_sus_w,
	cd_cgc_prestador_w,
	nr_seq_proc_pacote_w,
	cd_especialidade_medica_w,
	ie_doc_executor_w,
	cd_cbo_w,
	nr_seq_proc_interno_w,
	ie_funcao_medico_w,
	vl_procedimento_w,
	vl_custo_oper_orig_w,
	vl_anestesista_orig_w,
	vl_medico_orig_w,
	vl_materiais_orig_w,
	vl_auxiliares_orig_w,
	nr_seq_exame_w
from 	procedimento_paciente
where 	nr_sequencia		= nr_sequencia_p;

select	cd_estabelecimento,
	ie_tipo_atendimento,
	ie_carater_inter_sus
into STRICT	cd_estabelecimento_w,
	ie_tipo_atendimento_w,
	ie_carater_inter_sus_w
from	atendimento_paciente
where	nr_atendimento	= nr_atendimento_w;

select	coalesce(max(ie_regra_honorario_servico),'N')
into STRICT	ie_regra_honorario_servico_w
from	parametro_faturamento
where	cd_estabelecimento = cd_estabelecimento_w;


begin
select	nr_seq_classif_medico,
	ie_clinica
into STRICT	nr_seq_classif_medico_w,
	ie_clinica_w
from	atendimento_paciente
where 	nr_atendimento     	= nr_atendimento_w;
exception
    	when others then
	nr_seq_classif_medico_w:=null;
end;


ie_pacote_w:= obter_se_pacote(nr_sequencia_p,nr_seq_proc_pacote_w);


begin

select	cd_procedencia
into STRICT	cd_procedencia_w
from 	atendimento_paciente
where 	nr_atendimento 	= nr_atendimento_w;
exception
    	when others then
      	cd_procedencia_w := 0;
end;

select	max(ie_classificacao)
into STRICT	ie_classificacao_w
from	procedimento
where	cd_procedimento = cd_procedimento_w
and	ie_origem_proced = ie_origem_proced_w;

SELECT * FROM obter_regra_honorario(
	cd_estabelecimento_w, cd_convenio_w, cd_categoria_w, cd_procedimento_w, ie_origem_proced_w, dt_procedimento_w, ie_tipo_atendimento_w, cd_setor_atendimento_w, ie_tipo_servico_sus_w, ie_tipo_ato_sus_w, cd_medico_executor_w, cd_cgc_prestador_w, ie_pacote_w, ie_carater_inter_sus_w, null, cd_regra_honorario_w, ie_conta_honorario_w, ie_calcula_honorario_w, cd_cgc_honorario_w, cd_pessoa_honorario_w, nr_seq_criterio_w, cd_especialidade_medica_w, null, ie_funcao_medico_w, ie_clinica_w, null, nr_seq_classif_medico_w, cd_procedencia_w, ie_doc_executor_w, cd_cbo_w, nr_seq_proc_interno_w, nr_seq_exame_w) INTO STRICT cd_regra_honorario_w, ie_conta_honorario_w, ie_calcula_honorario_w, cd_cgc_honorario_w, cd_pessoa_honorario_w, nr_seq_criterio_w;

if (ie_classificacao_w = 1) then

	if (coalesce(ie_conta_honorario_w,'N') 	= 'S') then
		vl_procedimento_w := vl_custo_oper_orig_w + vl_anestesista_orig_w + vl_medico_orig_w +
					vl_materiais_orig_w + vl_auxiliares_orig_w;
	elsif (coalesce(ie_conta_honorario_w,'N') 	= 'T') 	then
		vl_procedimento_w		:= 0;
	elsif (coalesce(ie_conta_honorario_w,'N') 	= 'N') then
		vl_procedimento_w := vl_custo_oper_orig_w + vl_anestesista_orig_w +
					vl_materiais_orig_w + vl_auxiliares_orig_w;
	end if;

	if (cd_cgc_honorario_w IS NOT NULL AND cd_cgc_honorario_w::text <> '') then
		cd_cgc_prestador_w		:= cd_cgc_honorario_w;
	end if;

	update	procedimento_paciente
	set	ie_responsavel_credito	= cd_regra_honorario_w,
		vl_procedimento		= vl_procedimento_w,
		cd_cgc_prestador		= cd_cgc_prestador_w
	where	nr_sequencia		= nr_sequencia_p;

else

	if (ie_conta_honorario_w = 'T') and (ie_regra_honorario_servico_w = 'S') then
		vl_custo_operacional_w	:= vl_procedimento_w;
		vl_procedimento_w	:= 0;
	end if;

	update	procedimento_paciente
	set	ie_responsavel_credito	= cd_regra_honorario_w,
		cd_cgc_prestador	= cd_cgc_prestador_w,
		vl_procedimento		= vl_procedimento_w,
		vl_custo_operacional	= vl_custo_operacional_w
	where	nr_sequencia		= nr_sequencia_p;
end if;

--if (nvl(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if; Dava erro porque é chamado a partir atualiza_preco_proc_amb que é chamado na trigger da exame_lab_result_item
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ajustar_resp_cred_proc_glosa ( nr_sequencia_p bigint) FROM PUBLIC;

