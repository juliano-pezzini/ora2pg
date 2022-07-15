-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_atendimento_orcamento ( nr_seq_orcamento_p bigint, dt_atendimento_p timestamp, cd_setor_Atendimento_p bigint, nr_doc_convenio_p text, ie_tipo_atendimento_p bigint, ie_clinica_p bigint, cd_procedencia_p bigint, cd_medico_p text, cd_unidade_basica_p text, cd_unidade_compl_p text, cd_estabelecimento_p bigint, nm_usuario_p text, nr_atendimento_p INOUT bigint, cd_tipo_acomodacao_p bigint) AS $body$
DECLARE


nr_atendimento_w	bigint;
cd_pessoa_fisica_w	varchar(10);
cd_convenio_w		integer;
nr_seq_atepaco_w	bigint;
nr_seq_atepacu_w	bigint;
cd_categoria_w		varchar(10);
cd_plano_convenio_w	varchar(10);
cd_tipo_acomodacao_w	integer;
ie_gerar_prescricao_w	varchar(10);
cd_pessoa_responsavel_w	varchar(10);
ie_carater_inter_sus_w	 varchar(2);
nr_seq_classificacao_w   bigint;
ie_aprovar_atendimento_w varchar(10);
ie_status_orcamento_w	orcamento_paciente.ie_status_orcamento%type;
dt_aprovacao_w		orcamento_paciente.dt_aprovacao%type;
cd_usuario_convenio_w 	orcamento_paciente.cd_usuario_convenio%type;


BEGIN



select	cd_convenio,
	cd_categoria,
	cd_pessoa_fisica,
	cd_plano,
	cd_tipo_acomodacao,
	cd_pessoa_responsavel,
	ie_carater_inter_sus,
	nr_seq_classificacao,
	ie_status_orcamento,
	dt_aprovacao,
	cd_usuario_convenio
into STRICT	cd_convenio_w,
	cd_categoria_w,
	cd_pessoa_fisica_w,
	cd_plano_convenio_w,
	cd_tipo_acomodacao_w,
	cd_pessoa_responsavel_w,
	ie_carater_inter_sus_w,
	nr_seq_classificacao_w,
	ie_status_orcamento_w,
	dt_aprovacao_w,
	cd_usuario_convenio_w
from	orcamento_paciente
where	nr_sequencia_orcamento	= nr_seq_orcamento_p;


select	nextval('atendimento_paciente_seq')
into STRICT	nr_atendimento_w
;
ie_gerar_prescricao_w	:=  coalesce(Obter_Valor_Param_Usuario(106,26, Obter_Perfil_Ativo, nm_usuario_p, coalesce(cd_estabelecimento_p,1)),'N');
ie_aprovar_atendimento_w :=  coalesce(Obter_Valor_Param_Usuario(106,142, Obter_Perfil_Ativo, nm_usuario_p, coalesce(cd_estabelecimento_p,1)),'N');


insert into atendimento_paciente(	nr_atendimento,
					cd_pessoa_fisica,
					cd_estabelecimento,
					cd_procedencia,
					dt_entrada,
					ie_tipo_atendimento,
					dt_atualizacao,
					nm_usuario,
					cd_medico_resp,
					ie_permite_visita,
					ie_tipo_convenio,
					ie_clinica,
					cd_pessoa_responsavel,
					ie_carater_inter_sus,
					nr_seq_classificacao,
					nm_usuario_atend)
			values (	nr_atendimento_w,
					cd_pessoa_fisica_w,
					cd_estabelecimento_p,
					cd_procedencia_p,
					dt_atendimento_p,
					ie_tipo_atendimento_p,
					clock_timestamp(),
					nm_usuario_p,
					cd_medico_p,
					'S',
					obter_tipo_convenio(cd_convenio_w),
					ie_clinica_p,
					cd_pessoa_responsavel_w,
					ie_carater_inter_sus_w,
					nr_seq_classificacao_w,
					nm_usuario_p);
				
select	nextval('atend_categoria_convenio_seq')
into STRICT	nr_seq_atepaco_w
;

insert	into atend_categoria_convenio(	nr_atendimento,
					cd_convenio,
					cd_categoria,
					dt_inicio_vigencia,
					dt_final_vigencia,
					dt_atualizacao,
					cd_usuario_convenio,
					nm_usuario,
					nr_doc_convenio,
					nr_seq_interno,
					cd_plano_convenio,
					cd_tipo_acomodacao)
		values (	nr_Atendimento_w,
					cd_convenio_w,
					cd_categoria_w,
					dt_atendimento_p,
					null,
					clock_timestamp(),
					cd_usuario_convenio_w,
					nm_usuario_p,
					nr_doc_convenio_p,
					nr_seq_atepaco_w,
					cd_plano_convenio_w,
					cd_tipo_acomodacao_w);
					
select	nextval('atend_paciente_unidade_seq')
into STRICT	nr_seq_atepacu_w
;
insert into atend_paciente_unidade(	nr_atendimento,
					nr_sequencia,
					cd_setor_atendimento,
					cd_unidade_basica,
					cd_unidade_compl,
					dt_entrada_unidade,
					dt_atualizacao,
					nm_usuario,
					cd_tipo_acomodacao,
					dt_saida_interno,
					nr_seq_interno)
		values (	nr_atendimento_w,
					1,
					cd_setor_atendimento_p,
					cd_unidade_basica_p,
					cd_unidade_compl_p,
					dt_atendimento_p,
					clock_timestamp(),
					nm_usuario_p,
					cd_tipo_acomodacao_p,
					clock_timestamp(),
					nr_seq_atepacu_w
					);


update	orcamento_paciente
set	nr_atendimento	= nr_atendimento_w
where	nr_sequencia_orcamento	= nr_seq_orcamento_p;

commit;

nr_atendimento_p	:= nr_atendimento_w;

if (ie_gerar_prescricao_w	= 'S') then
	CALL Gerar_Prescr_Orcamento_Atend(	nr_atendimento_w,
					nr_seq_orcamento_p,
					nr_seq_atepacu_w,
					cd_medico_p,
					nm_usuario_p);

end if;

if	((coalesce(ie_aprovar_atendimento_w,'N') = 'S') and (ie_status_orcamento_w <> 2) and (coalesce(dt_aprovacao_w::text, '') = '')) then
	CALL Aprovar_orcamento(nr_seq_orcamento_p,nm_usuario_p,cd_estabelecimento_p);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_atendimento_orcamento ( nr_seq_orcamento_p bigint, dt_atendimento_p timestamp, cd_setor_Atendimento_p bigint, nr_doc_convenio_p text, ie_tipo_atendimento_p bigint, ie_clinica_p bigint, cd_procedencia_p bigint, cd_medico_p text, cd_unidade_basica_p text, cd_unidade_compl_p text, cd_estabelecimento_p bigint, nm_usuario_p text, nr_atendimento_p INOUT bigint, cd_tipo_acomodacao_p bigint) FROM PUBLIC;

