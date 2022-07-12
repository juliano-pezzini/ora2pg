-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_criterio_honor_proc ( nr_sequencia_p bigint) RETURNS bigint AS $body$
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
nr_seq_exame_w		bigint;

cd_plano_w	atend_categoria_convenio.cd_plano_convenio%type;
dt_conta_w	procedimento_paciente.dt_conta%type;


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
	nr_seq_exame,
	coalesce(dt_conta, coalesce(dt_prescricao,dt_procedimento))
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
	nr_seq_exame_w,
	dt_conta_w
from 	procedimento_paciente
where 	nr_sequencia		= nr_sequencia_p;

select	cd_estabelecimento,
	ie_tipo_atendimento,
	ie_carater_inter_sus,
	coalesce(obter_dado_atend_cat_conv(nr_atendimento_w, dt_conta_w, cd_convenio_w, cd_categoria_w, 'P'), obter_dado_atend_conv(nr_atendimento_w, dt_conta_w, cd_convenio_w, 'P'))
into STRICT	cd_estabelecimento_w,
	ie_tipo_atendimento_w,
	ie_carater_inter_sus_w,
	cd_plano_w
from	atendimento_paciente
where	nr_atendimento	= nr_atendimento_w;


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


SELECT * FROM obter_regra_honorario(
	cd_estabelecimento_w, cd_convenio_w, cd_categoria_w, cd_procedimento_w, ie_origem_proced_w, dt_procedimento_w, ie_tipo_atendimento_w, cd_setor_atendimento_w, ie_tipo_servico_sus_w, ie_tipo_ato_sus_w, cd_medico_executor_w, cd_cgc_prestador_w, ie_pacote_w, ie_carater_inter_sus_w, cd_plano_w, cd_regra_w, ie_conta_honorario_w, ie_calcula_honorario_w, cd_cgc_honorario_w, cd_pessoa_honorario_w, nr_seq_criterio_w, cd_especialidade_medica_w, null, ie_funcao_medico_w, ie_clinica_w, null, nr_seq_classif_medico_w, cd_procedencia_w, ie_doc_executor_w, cd_cbo_w, nr_seq_proc_interno_w, nr_seq_exame_w) INTO STRICT cd_regra_w, ie_conta_honorario_w, ie_calcula_honorario_w, cd_cgc_honorario_w, cd_pessoa_honorario_w, nr_seq_criterio_w;

return nr_seq_criterio_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_criterio_honor_proc ( nr_sequencia_p bigint) FROM PUBLIC;
