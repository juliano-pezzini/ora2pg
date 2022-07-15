-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_regulacao_atend ( nr_sequencia_p bigint, ie_tipo_p text, ie_informacao_p text, nr_seq_informacao_p bigint default null, cd_evolucao_p bigint default null, nr_seq_parecer_p bigint default null, nr_seq_resp_parecer_p bigint default null, nr_seq_grupo_regulacao_p bigint default null, nr_seq_reg_atend_p INOUT bigint DEFAULT NULL) AS $body$
DECLARE



regulacao_atend_w 			regulacao_atend%rowtype;
nr_seq_grupo_regulacao_w	regra_regulacao.nr_seq_grupo_regulacao%type;
nr_seq_prioridade_w			regulacao_atend.nr_seq_prioridade%type;
reg_integracao_w			gerar_int_padrao.reg_integracao;
ie_classificacao_w			paciente_home_care.ie_classificacao%type;
nr_seq_equip_control_w		hc_pac_equipamento.nr_seq_equip_control%type;

nr_seq_exame_cad_w		bigint;
nr_seq_exame_w			bigint;
cd_material_exame_w		varchar(20);
cd_procedimento_w		bigint;
nr_seq_proc_interno_w	bigint;
ie_origem_proced_w		bigint;
nr_atendimento_w		bigint;
cd_pessoa_fisica_w		varchar(10);
nr_seq_cpoe_w			bigint;
qt_reg_w				bigint;
cd_convenio_w			bigint;
nr_seq_requisicao_w		bigint;
cd_cpf_medico_w			varchar(20);
nr_cpf_pf_w				varchar(20);
nr_seq_segurado_w		bigint;
dt_nasc_benef_w			timestamp;
ie_sexo_benef_w			varchar(1);
cd_nacionalidade_w		varchar(10);
nm_beneficiario_w		varchar(255);
nm_mae_benef_w			varchar(255);
cd_prestador_w			varchar(30);
cd_cgc_w				varchar(15);
ie_integracao_w			varchar(1);
ds_parecer_w			varchar(4000);
nr_parecer_w			bigint;
nr_seq_motivo_solic_ext_w	bigint;
cd_material_w			bigint;
cd_proc_envio_w			varchar(255);
cd_mat_envio_w			varchar(255);
ie_origem_proced_envio_w   bigint;
cd_tipo_solicitacao_w	varchar(255);
cd_tipo_vaga_w			varchar(255);
ds_retorno_integracao_w	varchar(4000);
qt_exame_w				bigint;
nr_receita_amb_w  bigint;
qt_dose_w bigint;

ie_confirma_encaminhamento_w	varchar(1);
ie_confirma_regra_w				varchar(1);
nr_seq_fa_rec_farmacia_w	bigint;


BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then

  select	nextval('regulacao_atend_seq')
  into STRICT		regulacao_atend_w.nr_sequencia
;

  regulacao_atend_w.dt_atualizacao := clock_timestamp();
  regulacao_atend_w.nm_usuario := wheb_usuario_pck.get_nm_usuario;
  regulacao_atend_w.dt_atualizacao_nrec := clock_timestamp();
  regulacao_atend_w.ie_situacao := 'A';
  regulacao_atend_w.ie_tipo := ie_tipo_p;
  regulacao_atend_w.dt_liberacao := clock_timestamp();
  regulacao_atend_w.dt_inativacao := null;
  regulacao_atend_w.ds_justificativa := null;
  regulacao_atend_w.cd_evolucao_ori := cd_evolucao_p;
  regulacao_atend_w.nr_seq_parecer_ori := nr_seq_parecer_p;
  regulacao_atend_w.nr_seq_resp_parecer_ori := nr_seq_resp_parecer_p;
  regulacao_atend_w.nr_seq_grupo_regulacao	:= nr_seq_grupo_regulacao_p;


	if ( ie_tipo_p = 'EN') then

		select	max(nr_atendimento),
				max(cd_pessoa_fisica),
				max(cd_especialidade),
				max(cd_medico_dest)
		into STRICT	nr_atendimento_w,
				cd_pessoa_fisica_w,
				regulacao_atend_w.cd_especialidade,
				regulacao_atend_w.cd_profissional_dest
		from	atend_encaminhamento
		where	nr_sequencia = nr_sequencia_p;

		regulacao_atend_w.nr_seq_encaminhamento := nr_sequencia_p;

		select	obter_procedimento_regulacao(ie_tipo_p, regulacao_atend_w.cd_especialidade, regulacao_atend_w.cd_profissional_dest)
		into STRICT	cd_proc_envio_w
		;

		select	obter_procedimento_regulacao(ie_tipo_p, regulacao_atend_w.cd_especialidade, regulacao_atend_w.cd_profissional_dest,null,null,null,null,null,null,null,null,null,null,'I')
		into STRICT	ie_origem_proced_envio_w
		;

		select	Obter_conf_Regulacao(ie_tipo_p, regulacao_atend_w.cd_especialidade, regulacao_atend_w.cd_profissional_dest,null,null,null,null,null,null,null,null,null,null,'C')
		into STRICT	ie_confirma_regra_w
		;

		regulacao_atend_w.cd_procedimento_envio := cd_proc_envio_w;
		regulacao_atend_w.ie_origem_proced := ie_origem_proced_envio_w;
		regulacao_atend_w.qt_solicitado := 1;


	elsif ( ie_tipo_p = 'EV') then

		SELECT	MAX(a.nr_atendimento),
				MAX(a.cd_pessoa_fisica),
				MAX(a.cd_especialidade),
				MAX(a.cd_medico_parecer)
		into STRICT	nr_atendimento_w,
				cd_pessoa_fisica_w,
				regulacao_atend_w.cd_especialidade,
				regulacao_atend_w.cd_profissional_dest
		FROM	evolucao_paciente a
		WHERE	a.cd_evolucao = nr_sequencia_p;

		select	obter_procedimento_regulacao(ie_tipo_p, regulacao_atend_w.cd_especialidade, regulacao_atend_w.cd_profissional_dest)
		into STRICT	cd_proc_envio_w
		;

		select	obter_procedimento_regulacao(ie_tipo_p, regulacao_atend_w.cd_especialidade, regulacao_atend_w.cd_profissional_dest,null,null,null,null,null,null,null,null,null,null,'I')
		into STRICT	ie_origem_proced_envio_w
		;

		select	Obter_conf_Regulacao(ie_tipo_p, regulacao_atend_w.cd_especialidade, regulacao_atend_w.cd_profissional_dest,null,null,null,null,null,null,null,null,null,null,'C')
		into STRICT	ie_confirma_regra_w
		;

		regulacao_atend_w.cd_procedimento_envio := cd_proc_envio_w;
		regulacao_atend_w.ie_origem_proced := ie_origem_proced_envio_w;

	elsif ( ie_tipo_p = 'SE') then

		regulacao_atend_w.nr_seq_pedido := nr_sequencia_p;
		regulacao_atend_w.nr_seq_pedido_item := nr_seq_informacao_p;


		select	max(a.nr_seq_exame),
				max(a.nr_seq_exame_lab),
				max(a.cd_material_exame),
				max(a.cd_procedimento),
				max(coalesce(a.nr_seq_proc_int_sus,a.nr_proc_interno)),
				max(a.ie_origem_proced),
				max(b.nr_atendimento),
				max(b.cd_pessoa_fisica),
				max(a.NR_SEQ_PRIORIDADE),
				max(a.qt_exame)
		into STRICT	nr_seq_exame_cad_w,
				nr_seq_exame_w,
				cd_material_exame_w,
				cd_procedimento_w,
				nr_seq_proc_interno_w,
				ie_origem_proced_w,
				nr_atendimento_w,
				cd_pessoa_fisica_w,
				nr_seq_prioridade_w,
				qt_exame_w
		from	pedido_exame_externo_item a,
				pedido_exame_externo b
		where	b.nr_sequencia = a.nr_seq_pedido
		and		a.nr_sequencia = nr_seq_informacao_p;

		select	obter_procedimento_regulacao(ie_tipo_p, null, null, cd_material_exame_w, nr_seq_exame_cad_w, ie_origem_proced_w,null,null,nr_seq_proc_interno_w,nr_seq_exame_w,cd_procedimento_w)
		into STRICT	cd_proc_envio_w
		;

		select	obter_procedimento_regulacao(ie_tipo_p, null, null, cd_material_exame_w, nr_seq_exame_cad_w, ie_origem_proced_w,null,null,nr_seq_proc_interno_w,nr_seq_exame_w,cd_procedimento_w,null,null,'I')
		into STRICT	ie_origem_proced_envio_w
		;

		select	Obter_conf_Regulacao(ie_tipo_p, null, null, cd_material_exame_w, nr_seq_exame_cad_w, ie_origem_proced_w,null,null,nr_seq_proc_interno_w,nr_seq_exame_w,cd_procedimento_w,null,null,'C')
		into STRICT	ie_confirma_regra_w
		;

		regulacao_atend_w.cd_procedimento_envio := coalesce(cd_proc_envio_w,cd_procedimento_w);
		regulacao_atend_w.ie_origem_proced := coalesce(coalesce(ie_origem_proced_envio_w,ie_origem_proced_w),1);

		regulacao_atend_w.qt_solicitado := coalesce(qt_exame_w,coalesce(qt_dose_w,1));

		if ( ie_informacao_p =  'SEC' ) then

			regulacao_atend_w.nr_seq_exame_cad := 	nr_seq_exame_cad_w;

		elsif ( ie_informacao_p =  'SE' ) then

			regulacao_atend_w.nr_seq_exame 		:= 	nr_seq_exame_w;
			regulacao_atend_w.cd_material_exame 	:= 	cd_material_exame_w;
			regulacao_atend_w.ie_origem_proced 	:= 	 coalesce(coalesce(ie_origem_proced_envio_w,ie_origem_proced_w),1);

		elsif ( ie_informacao_p =  'SP' ) then

			regulacao_atend_w.cd_procedimento 		:= 	cd_procedimento_w;
			regulacao_atend_w.ie_origem_proced 		:= 	ie_origem_proced_w;

		elsif ( ie_informacao_p =  'SPI' ) then

			regulacao_atend_w.nr_seq_proc_interno 		:= 	nr_seq_proc_interno_w;


		end if;

	elsif ( ie_tipo_p = 'TC') then


		select	max(obter_pessoa_atendimento(a.nr_atendimento,'C')),
				max(a.nr_atendimento),
				max(a.nr_seq_motivo_solic_externa)
		into STRICT	cd_pessoa_fisica_w,
				nr_atendimento_w,
				nr_seq_motivo_solic_ext_w
		from	solic_transf_externa a
		where	a.nr_sequencia = nr_sequencia_p;

		regulacao_atend_w.nr_seq_solic_transf := nr_sequencia_p;

		select	obter_procedimento_regulacao(ie_tipo_p, null, null, null, null, null, nr_seq_motivo_solic_ext_w)
		into STRICT	cd_proc_envio_w
		;

		select	obter_procedimento_regulacao(ie_tipo_p, null, null, null, null, null, nr_seq_motivo_solic_ext_w,null, null, null, null, null,null,'I')
		into STRICT	ie_origem_proced_envio_w
		;

		select	Obter_conf_Regulacao(ie_tipo_p, null, null, null, null, null, nr_seq_motivo_solic_ext_w,null, null, null, null, null,null,'C')
		into STRICT	ie_confirma_regra_w
		;

		regulacao_atend_w.cd_procedimento_envio := cd_proc_envio_w;
		regulacao_atend_w.ie_origem_proced 	:= 	 coalesce(coalesce(ie_origem_proced_envio_w,ie_origem_proced_w),1);

	elsif ( ie_tipo_p = 'EQ') then

		if (ie_informacao_p = 'HC') then
		
			select 	max(b.cd_pessoa_fisica),
					max(b.nr_atendimento_origem),
					max(a.nr_seq_equip_control)
			into STRICT	cd_pessoa_fisica_w,
					nr_atendimento_w,
					nr_seq_equip_control_w
			from 	hc_pac_equipamento a,
					paciente_home_care b
			where 	a.nr_sequencia = nr_sequencia_p
					and a.nr_seq_paciente = b.nr_sequencia;

			regulacao_atend_w.nr_seq_equip_home := nr_sequencia_p;
									
			select	obter_procedimento_regulacao(ie_tipo_p, null, null, null, null, null, null, null, null, null, null, null, null,'P',null,nr_seq_equip_control_w)
			into STRICT 	cd_proc_envio_w
			;

			select	obter_procedimento_regulacao(ie_tipo_p, null, null, null, null, null, null, null, null, null, null, null, null, 'I',null,nr_seq_equip_control_w)
			into STRICT 	ie_origem_proced_envio_w
			;

			select	Obter_conf_Regulacao(ie_tipo_p, null, null, null, null, null, null, null, null, null, null, null, null, 'C',null,nr_seq_equip_control_w)
			into STRICT 	ie_confirma_regra_w
			;
			
			regulacao_atend_w.cd_procedimento_envio := cd_proc_envio_w;
			regulacao_atend_w.ie_origem_proced 	:= 	 coalesce(coalesce(ie_origem_proced_envio_w,ie_origem_proced_w),1);
			
			
			
		else
			select	max(a.cd_pessoa_solicitante),
					max(a.nr_atendimento)
			into STRICT	cd_pessoa_fisica_w,
					nr_atendimento_w
			from	requisicao_item a
			where	a.nr_sequencia = nr_sequencia_p;

			regulacao_atend_w.nr_seq_requisicao_item := nr_sequencia_p;
		end if;

	elsif ( ie_tipo_p = 'ME') then
	
		select	max(a.cd_pessoa_fisica),
				max(a.nr_atendimento),
				max(a.cd_material),
        max(a.NR_SEQ_PRIORIDADE),
        coalesce(max(a.NR_SEQ_RECEITA_AMB),0),
        max(a.qt_dose)
		into STRICT	cd_pessoa_fisica_w,
				nr_atendimento_w,
				cd_material_w,
        nr_seq_prioridade_w,
        nr_receita_amb_w,
        qt_dose_w
		from	cpoe_material a
		where	a.nr_sequencia = nr_sequencia_p;

		regulacao_atend_w.nr_seq_cpoe := nr_sequencia_p;

		select	obter_procedimento_regulacao(ie_tipo_p, null, null, null, null, null, null, cd_material_w)
		into STRICT	cd_mat_envio_w
		;

		select	Obter_conf_Regulacao(ie_tipo_p, null, null, null, null, null, null, cd_material_w, null, null, null, null, null,'C')
		into STRICT	ie_confirma_regra_w
		;
				
		regulacao_atend_w.NR_SEQ_RECEITA_AMB := NR_RECEITA_AMB_W;
		regulacao_atend_w.cd_material 		 := cd_material_w;
		regulacao_atend_w.cd_material_envio	 := cd_mat_envio_w;
		
    regulacao_atend_w.qt_solicitado := coalesce(qt_dose_w, 1);

	elsif ( ie_tipo_p =  'CPOE') then

		select	max(a.cd_pessoa_fisica),
				max(a.nr_atendimento),
				max(a.nr_seq_proc_interno),
				max(a.cd_material_exame)
		into STRICT	cd_pessoa_fisica_w,
				nr_atendimento_w,
				nr_seq_proc_interno_w,
				cd_material_exame_w
		from	cpoe_procedimento a
		where	a.nr_sequencia = nr_sequencia_p;

		regulacao_atend_w.ie_tipo := 'SE';
		regulacao_atend_w.nr_seq_cpoe_proc := nr_sequencia_p;

		select	obter_procedimento_regulacao(ie_tipo_p, null, null, cd_material_exame_w, null, null, null, null, nr_seq_proc_interno_w)
		into STRICT 	cd_proc_envio_w
		;

		select	obter_procedimento_regulacao(ie_tipo_p, null, null, cd_material_exame_w, null, null, null, null, nr_seq_proc_interno_w, null, null, null, null,'I')
		into STRICT 	ie_origem_proced_envio_w
		;

		select	Obter_conf_Regulacao(ie_tipo_p, null, null, cd_material_exame_w, null, null, null, null, nr_seq_proc_interno_w, null, null, null, null,'C')
		into STRICT 	ie_confirma_regra_w
		;

		regulacao_atend_w.cd_procedimento_envio := cd_proc_envio_w;
		regulacao_atend_w.ie_origem_proced 	:= 	 coalesce(coalesce(ie_origem_proced_envio_w,ie_origem_proced_w),1);

	elsif ( ie_tipo_p = 'SV') then

		select	max(ie_solicitacao),
				max(ie_tipo_vaga),
				max(cd_pessoa_fisica),
				max(nr_atendimento),
				max(nr_seq_prioridade)
		into STRICT	cd_tipo_solicitacao_w,
				cd_tipo_vaga_w,
				cd_pessoa_fisica_w,
				nr_atendimento_w,
				nr_seq_prioridade_w
		from	gestao_vaga
		where	nr_sequencia = nr_sequencia_p;

		regulacao_atend_w.nr_seq_gestao_vaga := nr_sequencia_p;

		select	obter_procedimento_regulacao(ie_tipo_p, null, null, null, null, null, null, null, null, null, null, cd_tipo_solicitacao_w, cd_tipo_vaga_w)
		into STRICT 	cd_proc_envio_w
		;

		select	obter_procedimento_regulacao(ie_tipo_p, null, null, null, null, null, null, null, null, null, null, cd_tipo_solicitacao_w, cd_tipo_vaga_w, 'I')
		into STRICT 	ie_origem_proced_envio_w
		;

		select	Obter_conf_Regulacao(ie_tipo_p, null, null, null, null, null, null, null, null, null, null, cd_tipo_solicitacao_w, cd_tipo_vaga_w, 'C')
		into STRICT 	ie_confirma_regra_w
		;

		regulacao_atend_w.cd_procedimento_envio := cd_proc_envio_w;
		regulacao_atend_w.ie_origem_proced 	:= 	 coalesce(coalesce(ie_origem_proced_envio_w,ie_origem_proced_w),1);

	elsif ( ie_tipo_p = 'FA') then		
	
		select  max(b.nr_sequencia),
				max(b.cd_pessoa_fisica),
				max(a.cd_material),
				max(a.qt_dose),
				max(b.nr_atendimento),
				max(a.nr_seq_prioridade)
		into STRICT	nr_seq_fa_rec_farmacia_w,
				cd_pessoa_fisica_w,
				cd_material_w,
				qt_dose_w,
				nr_atendimento_w,
				nr_seq_prioridade_w
		from	fa_receita_farmacia_item a,
				fa_receita_farmacia b
		where 	a.nr_seq_receita = b.nr_sequencia
		and     a.nr_sequencia = nr_sequencia_p;
		
		select	obter_procedimento_regulacao('ME', null, null, null, null, null, null, cd_material_w)
		into STRICT	cd_mat_envio_w
		;

		select	Obter_conf_Regulacao('ME', null, null, null, null, null, null, cd_material_w, null, null, null, null, null,'C')
		into STRICT	ie_confirma_regra_w
		;
		
		regulacao_atend_w.ie_tipo := 'ME';
		regulacao_atend_w.nr_seq_receita_amb := nr_seq_fa_rec_farmacia_w;
		regulacao_atend_w.nr_seq_receita_item := nr_sequencia_p;
		regulacao_atend_w.cd_material 		 := cd_material_w;
		regulacao_atend_w.cd_material_envio	 := cd_mat_envio_w;
		regulacao_atend_w.qt_solicitado	:= coalesce(qt_dose_w, 1);
		
	elsif ( ie_tipo_p = 'SH') then

		select	max(ie_classificacao),				
				max(cd_pessoa_fisica),
				max(nr_atendimento_origem)
		into STRICT	ie_classificacao_w,
				cd_pessoa_fisica_w,
				nr_atendimento_w
		from	paciente_home_care
		where	nr_sequencia = nr_sequencia_p;

		regulacao_atend_w.nr_seq_home_care := nr_sequencia_p;

		select	obter_procedimento_regulacao(ie_tipo_p, null, null, null, null, null, null, null, null, null, null, null, null,'P',ie_classificacao_w)
		into STRICT 	cd_proc_envio_w
		;

		select	obter_procedimento_regulacao(ie_tipo_p, null, null, null, null, null, null, null, null, null, null, null, null, 'I',ie_classificacao_w)
		into STRICT 	ie_origem_proced_envio_w
		;

		select	Obter_conf_Regulacao(ie_tipo_p, null, null, null, null, null, null, null, null, null, null, null, null, 'C',ie_classificacao_w)
		into STRICT 	ie_confirma_regra_w
		;

		regulacao_atend_w.cd_procedimento_envio := cd_proc_envio_w;
		regulacao_atend_w.ie_origem_proced 	:= 	 coalesce(coalesce(ie_origem_proced_envio_w,ie_origem_proced_w),1);
		
	end if;

	if ( coalesce(nr_atendimento_w::text, '') = '') then

		Select  max(nr_atendimento)
		into STRICT	nr_atendimento_w
		from    atendimento_paciente
		where   cd_pessoa_fisica = cd_pessoa_fisica_w
		and     clock_timestamp() between dt_entrada and coalesce(dt_alta,clock_timestamp());

	end if;

	select	max(obter_convenio_atendimento(nr_atendimento)),
			max(obter_dados_pf(cd_medico_resp, 'CPF'))
	into STRICT	cd_convenio_w,
			cd_cpf_medico_w
	from	atendimento_paciente
	where	nr_atendimento = nr_atendimento_w;

	select	coalesce(max(ie_integracao),'N'),
			coalesce(max(ie_confirma_encaminhamento),'N')
	into STRICT	ie_integracao_w,
			ie_confirma_encaminhamento_w
	from	convenio_regulacao
	where	cd_convenio = cd_convenio_w
	and		ie_situacao = 'A';

	regulacao_atend_w.nr_atendimento := nr_atendimento_w;
	regulacao_atend_w.cd_pessoa_fisica := cd_pessoa_fisica_w;
	regulacao_atend_w.ie_status := 'EN';
	regulacao_atend_w.nr_seq_prioridade := coalesce(nr_seq_prioridade_w,1);
	regulacao_atend_w.ie_integracao := ie_integracao_w;

	insert into regulacao_atend values (regulacao_atend_w.*);

	commit;


	if ((ie_confirma_encaminhamento_w = 'N' and  ((ie_confirma_regra_w = 'N') or (ie_confirma_regra_w = 'X')) ) or ( ie_confirma_encaminhamento_w = 'S' and  ie_confirma_regra_w = 'N')) then

		CALL gerar_requisicao_regulacao(	regulacao_atend_w.nr_sequencia,
									coalesce(regulacao_atend_w.ie_tipo,ie_tipo_p),
									cd_pessoa_fisica_w,
									nr_atendimento_w,
									regulacao_atend_w.nm_usuario,
									ie_integracao_w,
									nr_seq_prioridade_w,
									coalesce(regulacao_atend_w.cd_procedimento_envio,cd_procedimento_w),
									coalesce(coalesce(regulacao_atend_w.ie_origem_proced,ie_origem_proced_w),1),
									coalesce(regulacao_atend_w.qt_solicitado,1),
                  cd_material_w,
                  qt_dose_w);


	else

		CALL Alterar_status_regulacao(regulacao_atend_w.nr_sequencia, 'AE', '', null,null,null,null,ie_integracao_w);

		if (nr_seq_prioridade_w IS NOT NULL AND nr_seq_prioridade_w::text <> '') then
			CALL Alterar_prioridade_regulacao(regulacao_atend_w.nr_sequencia, nr_seq_prioridade_w,' ',' ',null,null,null,null,null,null,null,ie_integracao_w,null);
		end if;

	end if;

	nr_seq_reg_atend_p := regulacao_atend_w.nr_sequencia;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_regulacao_atend ( nr_sequencia_p bigint, ie_tipo_p text, ie_informacao_p text, nr_seq_informacao_p bigint default null, cd_evolucao_p bigint default null, nr_seq_parecer_p bigint default null, nr_seq_resp_parecer_p bigint default null, nr_seq_grupo_regulacao_p bigint default null, nr_seq_reg_atend_p INOUT bigint DEFAULT NULL) FROM PUBLIC;

