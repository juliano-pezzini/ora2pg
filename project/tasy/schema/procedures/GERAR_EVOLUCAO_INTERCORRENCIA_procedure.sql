-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_evolucao_intercorrencia ( nr_seq_atendimento_p bigint, nm_usuario_p text, cd_evolucao_p INOUT bigint) AS $body$
DECLARE

 
ie_tipo_evolucao_w	varchar(3);
cd_medico_w		varchar(10);
ie_evolucao_clinica_w	varchar(3);
ie_lib_tipo_w		varchar(1);
cd_pessoa_fisica_w	varchar(10);
nr_atendimento_w	bigint;
nr_sequencia_w		bigint;
ds_motivo_w		varchar(4000);
nr_seq_paciente_w	bigint;
ie_liberar_evolucao_w	varchar(1);
dt_liberacao_w		timestamp;
cd_evolucao_w		bigint;


BEGIN 
 
ie_liberar_evolucao_w := Obter_Param_Usuario(3130, 253, wheb_usuario_pck.get_cd_perfil, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_liberar_evolucao_w);
 
if (nr_seq_atendimento_p IS NOT NULL AND nr_seq_atendimento_p::text <> '') then 
 
	select	max(coalesce(nr_atendimento, obter_atendimento_prescr(nr_prescricao))), 
		max(nr_seq_paciente) 
	into STRICT	nr_atendimento_w, 
		nr_seq_paciente_w 
	from	paciente_atendimento 
	where	nr_seq_atendimento = nr_seq_atendimento_p;
 
	select	coalesce(max(ie_tipo_evolucao),1), 
		max(cd_pessoa_fisica) 
	into STRICT	ie_tipo_evolucao_w, 
		cd_medico_w 
	from	usuario 
	where	nm_usuario	= nm_usuario_p;
 
	select	obter_valor_param_usuario(281, 226, obter_perfil_ativo, nm_usuario_p, obter_estab_atend(nr_atendimento_w)) 
	into STRICT	ie_evolucao_clinica_w 
	;
 
	if (coalesce(ie_evolucao_clinica_w::text, '') = '') then 
		ie_evolucao_clinica_w	:= 'E';
	end if;
 
	select	consiste_se_exibe_evolucao(ie_evolucao_clinica_w,cd_medico_w,nr_atendimento_w) 
	into STRICT	ie_lib_tipo_w 
	;
 
	select	CASE WHEN ie_lib_tipo_w='S' THEN ie_evolucao_clinica_w  ELSE null END  
	into STRICT	ie_evolucao_clinica_w 
	;
 
	select max(cd_pessoa_fisica) 
	into STRICT  cd_pessoa_fisica_w 
	from  paciente_setor 
	where  nr_seq_paciente = nr_seq_paciente_w;
 
	select	max(nr_sequencia) 
	into STRICT	nr_sequencia_w 
	from	paciente_atend_interc 
	where	nr_seq_atendimento = nr_seq_atendimento_p;
 
	select	substr(WHEB_MENSAGEM_PCK.get_texto(299045,null) || ': '||obter_ds_tipo_intercorrencia(nr_seq_tipo_interc)||chr(13)||chr(13)||substr(ds_motivo,1,3000),1,4000) 
	into STRICT	ds_motivo_w 
	from	paciente_atend_interc 
	where	nr_sequencia = nr_sequencia_w;
	 
	select 	nextval('evolucao_paciente_seq') 
	into STRICT	cd_evolucao_w 
	;
	 
	insert into evolucao_paciente( 
		cd_evolucao, 
		dt_evolucao, 
		ie_tipo_evolucao, 
		cd_pessoa_fisica, 
		dt_atualizacao, 
		nm_usuario, 
		nr_atendimento, 
		ds_evolucao, 
		cd_medico, 
		ie_evolucao_clinica, 
		cd_setor_atendimento, 
		cd_especialidade, 
		cd_medico_parecer, 
		ie_recem_nato, 
		ie_situacao, 
		dt_liberacao) 
	values (cd_evolucao_w, 
		clock_timestamp(), 
		ie_tipo_evolucao_w, 
		cd_pessoa_fisica_w, 
		clock_timestamp(), 
		nm_usuario_p, 
		nr_atendimento_w, 
		ds_motivo_w, 
		cd_medico_w, 
		ie_evolucao_clinica_w, 
		obter_setor_atendimento(nr_atendimento_w), 
		null, 
		null, 
		'N', 
		'A', 
		CASE WHEN ie_liberar_evolucao_w='S' THEN  clock_timestamp()  ELSE to_date(null) END );	
		 
cd_evolucao_p := cd_evolucao_w;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_evolucao_intercorrencia ( nr_seq_atendimento_p bigint, nm_usuario_p text, cd_evolucao_p INOUT bigint) FROM PUBLIC;

