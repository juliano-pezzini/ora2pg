-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calcular_valor_proc_lab_ageint ( nr_seq_ageint_p bigint, cd_convenio_p bigint, cd_categoria_p text, cd_estabelecimento_p bigint, dt_inicio_agendamento_p timestamp, cd_plano_p text, nm_usuario_p text, cd_usuario_convenio_p text, cd_pessoa_fisica_p text, ie_tipo_Atendimento_p bigint, nr_seq_ageint_lab_p bigint, ie_trigger_p text) AS $body$
DECLARE


				
cd_convenio_w		integer;
qt_pontos_w			preco_amb.qt_pontuacao%type;
cd_categoria_w		varchar(10);
cd_plano_w		varchar(10);
vl_procedimento_w	double precision;
vl_aux_w		double precision;
ds_aux_w		varchar(10);
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
cd_convenio_ww		integer;
cd_categoria_ww		varchar(10);
cd_plano_ww		varchar(10);
ie_tipo_convenio_w	smallint;
ie_regra_w		integer;
ie_glosa_w		varchar(1);
cd_usuario_convenio_w	varchar(30);
qt_idade_w		smallint;
dt_nascimento_w		timestamp;
ie_Sexo_w		varchar(1);
cd_pessoa_fisica_w	varchar(10);
CD_EDICAO_AMB_w         integer;
VL_LANC_AUTOM_W         double precision;
vl_custo_operacional_w	double precision;
vl_anestesista_w	double precision;
vl_medico_w		double precision;
vl_auxiliares_w		double precision;
vl_materiais_w		double precision;
cd_medico_item_w	varchar(10);
nr_seq_ageint_w		bigint;
cd_conv_item_w		integer;
cd_categ_item_w		varchar(10);
cd_plano_item_w		varchar(10);
nr_seq_regra_w		bigint;
ie_autorizacao_w	varchar(3);
nr_minuto_duracao_w	bigint;
ie_resp_autor_w		varchar(10);
cd_medico_solicitante_w varchar(10);

ie_edicao_w             varchar(1);
cd_edicao_ajuste_w      bigint;
qt_item_edicao_w         bigint;
cd_estab_agenda_w	integer;
nm_paciente_w		varchar(60);
cd_paciente_agenda_w	varchar(10);
nm_paciente_agenda_w	varchar(60);
ie_pacote_w		varchar(1);
ie_inserir_prof_w	varchar(1);
ds_erro_w		varchar(255);
dt_nascimento_Ww	timestamp;
nr_minuto_duracao_ww	bigint;
ie_bloq_glosa_part_w	varchar(1);
nr_seq_cobertura_w	bigint;
ie_calc_glosa_atend_w	varchar(1);
cd_convenio_glosa_w	bigint;
cd_categoria_glosa_w	varchar(10);
ie_conv_cat_regra_w	varchar(1);
nr_seq_exame_w		bigint;
cd_setor_w		bigint;
nr_seq_proc_interno_aux_w	bigint;
nr_seq_proc_interno_w	bigint;	
nr_seq_ageint_exame_lab_w	bigint;
nr_seq_ajuste_proc_w	bigint;
pr_glosa_w				double precision;
vl_glosa_w				double precision;
ie_regra_arredondamento_tx_w	varchar(1):= 'N';
ie_tipo_rounded_w		varchar(1);
ie_regra_arred_IPE_w		varchar(1):= 'N';
IE_CALCULA_GLOSA_w			parametro_Agenda_integrada.ie_calcula_glosa%type;
ie_param_444_w               varchar(1) := '';
ie_excluir_valor             varchar(1) := 'N';

C01 CURSOR FOR
	SELECT	nr_seq_exame,
		nr_seq_proc_interno,
		nr_sequencia
	from	ageint_exame_lab
	where	nr_seq_ageint = nr_seq_ageint_p
	and	((nr_sequencia = nr_seq_ageint_lab_p) or (coalesce(nr_seq_ageint_lab_p::text, '') = ''));
	

BEGIN

select	coalesce(max(IE_CALCULA_GLOSA),'N')
into STRICT	IE_CALCULA_GLOSA_w
from	parametro_Agenda_integrada
where	coalesce(cd_estabelecimento, wheb_usuario_pck.get_cd_estabelecimento)	= wheb_usuario_pck.get_cd_estabelecimento;

/*  NÂO FAZER SELECT NA AGENDA_INTEGRADA ROTINA UTILIZADA EM TRIGGER! */

ie_bloq_glosa_part_w := obter_param_usuario(869, 187, obter_perfil_ativo, nm_usuario_p, 0, ie_bloq_glosa_part_w);
ie_calc_glosa_atend_w := obter_param_usuario(869, 262, obter_perfil_ativo, nm_usuario_p, 0, ie_calc_glosa_atend_w);
ie_param_444_w := obter_param_usuario(869, 444, obter_perfil_ativo, nm_usuario_p, 0, ie_param_444_w);

select	max(ie_Sexo)			
into STRICT	ie_Sexo_w		
from	pessoa_fisica
where	cd_pessoa_fisica	= cd_pessoa_fisica_p;
	
cd_convenio_ww	:= cd_convenio_p;
cd_categoria_ww	:= cd_categoria_p;
cd_plano_ww	:= cd_plano_p;

open C01;
loop
fetch C01 into	
	nr_seq_exame_w,
	nr_seq_proc_interno_w,
	nr_seq_ageint_exame_lab_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	
	select	max(cd_convenio),
		max(cd_categoria),
		max(cd_plano)
	into STRICT	cd_conv_item_w,
		cd_categ_item_w,
		cd_plano_item_w
	from	ageint_exame_lab_conv_item
	where	nr_seq_lab_item	= nr_seq_ageint_exame_lab_w;
	
	if (cd_conv_item_w IS NOT NULL AND cd_conv_item_w::text <> '') then
		cd_convenio_ww	:= cd_conv_item_w;
		cd_categoria_ww	:= cd_categ_item_w;
		cd_plano_ww	:= cd_plano_item_w;
	end if;
	
	select	max(ie_tipo_convenio)
	into STRICT	ie_tipo_convenio_w
	from	convenio
	where	cd_convenio	= cd_convenio_ww;
	
	if (nr_seq_proc_interno_w IS NOT NULL AND nr_seq_proc_interno_w::text <> '') then				
		SELECT * FROM obter_proc_tab_interno_conv(
					    nr_seq_proc_interno_w, cd_estabelecimento_p, cd_convenio_ww, cd_categoria_ww, null, null, cd_procedimento_w, ie_origem_proced_w, null, clock_timestamp(), null, null, null, null, null, null, null, null) INTO STRICT cd_procedimento_w, ie_origem_proced_w;
	else
		SELECT * FROM obter_exame_lab_convenio(
					nr_seq_exame_w, cd_convenio_ww, cd_categoria_ww, ie_tipo_Atendimento_p, cd_estabelecimento_p, ie_tipo_convenio_w, null, null, cd_plano_ww, cd_setor_w, cd_procedimento_w, ie_origem_proced_w, ds_erro_w, nr_seq_proc_interno_aux_w, clock_timestamp()) INTO STRICT cd_setor_w, cd_procedimento_w, ie_origem_proced_w, ds_erro_w, nr_seq_proc_interno_aux_w;
	end if;
	
	SELECT * FROM ageint_consiste_plano_conv(
		null, cd_convenio_ww, cd_procedimento_w, ie_origem_proced_w, clock_timestamp(), 1, coalesce(ie_tipo_Atendimento_p,0), cd_plano_ww, null, ds_erro_w, 0, nr_seq_exame_w, ie_regra_w, null, nr_seq_regra_w, nr_seq_proc_interno_w, cd_categoria_ww, cd_estabelecimento_p, null, ie_Sexo_w, ie_glosa_w, cd_edicao_ajuste_w, nr_seq_cobertura_w, cd_convenio_glosa_w, cd_categoria_glosa_w, cd_pessoa_fisica_p, null, pr_glosa_w, vl_glosa_w) INTO STRICT ds_erro_w, ie_regra_w, nr_seq_regra_w, ie_glosa_w, cd_edicao_ajuste_w, cd_convenio_glosa_w, cd_categoria_glosa_w, pr_glosa_w, vl_glosa_w;
			
			
	ie_edicao_w	:= ageint_obter_se_proc_conv(cd_estabelecimento_p, cd_convenio_ww, cd_categoria_ww, clock_timestamp(), cd_procedimento_w, ie_origem_proced_w, nr_Seq_proc_interno_w, ie_tipo_Atendimento_p);

	ie_pacote_w	:= obter_Se_pacote_convenio(cd_procedimento_w, ie_origem_proced_w, cd_convenio_ww, cd_estabelecimento_p);

		
	if (ie_edicao_w 				= 'N') and (coalesce(cd_edicao_ajuste_w,0) 	= 0) and (coalesce(ie_glosa_w,'L') 		= 'L') and (ie_pacote_w				= 'N') then
		ie_glosa_w        			:= 'T';
	end if;

	if 	ie_glosa_w = 'E' and
		ie_param_444_w = 'N' and
		ie_tipo_convenio_w = '1' then
		ie_excluir_valor := 'S';
	end if;
			
	if (ie_edicao_w 				= 'N') and (coalesce(cd_edicao_ajuste_w,0) 	> 0) and (coalesce(ie_glosa_w,'L') 		= 'L') and (ie_pacote_w				= 'N') then

		select   count(*)
		into STRICT     qt_item_edicao_w
		from     preco_amb
		where    cd_edicao_amb = cd_edicao_ajuste_w
		and      cd_procedimento = cd_procedimento_w
		and      ie_origem_proced = ie_origem_proced_w;
				
		if (qt_item_edicao_w = 0) then
			 ie_glosa_w :=    'G';
		end if;
			
	end if;

	ie_autorizacao_w	:= 'L';

	if	((ie_Regra_w in (1,2,5)) or
		(ie_Regra_w = 8 AND ie_bloq_glosa_part_w = 'N')) then
		ie_autorizacao_w	:= 'B';
	elsif (ie_Regra_w in (3,6,7)) then
		select 	coalesce(max(ie_resp_autor),'H')
		into STRICT	ie_resp_autor_w
		from 	regra_convenio_plano
		where 	nr_sequencia = nr_seq_regra_w;
		if (ie_resp_autor_w	= 'H') then
			ie_autorizacao_w	:= 'PAH';
		elsif (ie_resp_autor_w	= 'P') then
			ie_autorizacao_w	:= 'PAP';
		end if;
	end if;
				
	if (ie_glosa_w in ('G','T','D','F')) then
		ie_autorizacao_w	:= 'B';
	end if;
		
		
	if (ie_excluir_valor = 'S') OR (
		((((coalesce(ie_Regra_w,0) not in (1,2,5)) or (coalesce(ie_glosa_w,'') not in ('T','E','R','B','H','Z',''))) and (ie_tipo_convenio_w <> 1) and (ie_calc_glosa_atend_w = 'N')) or				
		((ie_calc_glosa_atend_w = 'S') 	and (ie_tipo_convenio_w <> 1) 	and
		 ((coalesce(ie_glosa_w,'') not in ('T','G','P','R')) or (coalesce(ie_glosa_w::text, '') = '')))) and (IE_CALCULA_GLOSA_w = 'N' or (IE_CALCULA_GLOSA_w = 'S' and (coalesce(ie_glosa_w,'') not in ('P','R') or (coalesce(ie_glosa_w::text, '') = ''))))) then
		vl_procedimento_w	:= 0;				
	else			
		if (ie_glosa_w	in ('P','R') and
			IE_CALCULA_GLOSA_w = 'S') then
			SELECT * FROM Define_Preco_Procedimento(
				CD_ESTABELECIMENTO_p, cd_convenio_w, cd_categoria_w, dt_inicio_agendamento_p, cd_procedimento_w, 0, coalesce(ie_tipo_Atendimento_p,0), 0, null, --medico
				0, 0, 0, nr_seq_proc_interno_w, null, --usuario convenio
				cd_plano_w, 0, 0, null, VL_PROCEDIMENTO_w, vl_custo_operacional_w, vl_anestesista_w, vl_medico_w, vl_auxiliares_w, vl_materiais_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, qt_pontos_w, CD_EDICAO_AMB_w, ds_aux_w, nr_seq_ajuste_proc_w, 0, null, 0, 'N', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null) INTO STRICT VL_PROCEDIMENTO_w, vl_custo_operacional_w, vl_anestesista_w, vl_medico_w, vl_auxiliares_w, vl_materiais_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, qt_pontos_w, CD_EDICAO_AMB_w, ds_aux_w, nr_seq_ajuste_proc_w;

			if (ie_glosa_w = 'P') then
				vl_glosa_w:= vl_procedimento_w * pr_glosa_w / 100;
				
				/* ROTINA DE ARREDONDAMENTO, USADO PELO CONVÊNIO IPE   --->>    INICIO  <<----- */

				begin
				select 	coalesce(max(ie_regra_arredondamento_tx),'N')
				into STRICT	ie_regra_arredondamento_tx_w
				from 	parametro_faturamento
				where 	cd_estabelecimento = cd_estabelecimento_p;
				exception
					when others then
						ie_regra_arredondamento_tx_w:= 'N';
				end;	

				if (ie_regra_arredondamento_tx_w = 'S')then

					select	max(ie_arredondamento)
					into STRICT	ie_tipo_rounded_w
					from	convenio_estabelecimento
					where	cd_convenio	  	= cd_convenio_w
					and	cd_estabelecimento	= cd_estabelecimento_p;

					if (ie_tipo_rounded_w = 'R') then

						select 	obter_regra_arredondamento(cd_convenio_ww, cd_categoria_w, cd_procedimento_w, ie_origem_proced_w, cd_estabelecimento_p,
								coalesce(clock_timestamp(),clock_timestamp()), 'P', 1)
						into STRICT	ie_tipo_rounded_w
						;
						
						ie_regra_arred_IPE_w:= 'S';

					end if;

					if (ie_tipo_rounded_w IS NOT NULL AND ie_tipo_rounded_w::text <> '') and (ie_regra_arred_IPE_w = 'S') then

						vl_glosa_w := arredondamento(vl_glosa_w, 2, ie_tipo_rounded_w);
						
					else
						ie_regra_arred_IPE_w:= 'N';
					end if;

				end if;
				if (vl_glosa_w	> 0)  then
					vl_procedimento_w	:= vl_procedimento_w - vl_glosa_w;
				end if;	
			else
				vl_procedimento_w:= vl_glosa_w;
			end if;									
		else
			if (ie_tipo_convenio_w <> 1) then
				select	max(cd_convenio_partic),
					max(cd_categoria_partic)
				into STRICT	cd_convenio_w,
					cd_categoria_w
				from	parametro_faturamento
				where	cd_estabelecimento	= cd_estabelecimento_p;
				
				if (ie_conv_cat_regra_w = 'S') then
					cd_convenio_w	:= coalesce(cd_convenio_glosa_w,cd_convenio_w);
					cd_categoria_w	:= coalesce(cd_categoria_glosa_w,cd_categoria_w);					
				end if;
				
				if (cd_convenio_ww IS NOT NULL AND cd_convenio_ww::text <> '') then
					select	max(cd_plano)
					into STRICT	cd_plano_w
					from	convenio_plano
					where	cd_convenio	= cd_convenio_w
					and	ie_situacao	= 'A';
				end if;
			end if;
			
			if (coalesce(cd_convenio_w::text, '') = '') then
				cd_convenio_w	:= cd_convenio_ww;
				cd_Categoria_w	:= cd_categoria_ww;
				cd_plano_w	:= cd_plano_ww;
			end if;
			
			if ie_excluir_valor <> 'S' then
				SELECT * FROM Define_Preco_Procedimento(
					cd_estabelecimento_p, cd_convenio_w, cd_categoria_w, dt_inicio_agendamento_p, cd_procedimento_w, 0, coalesce(ie_tipo_Atendimento_p,0), 0, null, --medico
					0, 0, 0, nr_seq_proc_interno_w, null, --usuario convenio
					cd_plano_w, 0, 0, null, VL_PROCEDIMENTO_w, vl_custo_operacional_w, vl_anestesista_w, vl_medico_w, vl_auxiliares_w, vl_materiais_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, qt_pontos_w, CD_EDICAO_AMB_w, ds_aux_w, nr_seq_ajuste_proc_w, 0, null, 0, 'N', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null) INTO STRICT VL_PROCEDIMENTO_w, vl_custo_operacional_w, vl_anestesista_w, vl_medico_w, vl_auxiliares_w, vl_materiais_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, qt_pontos_w, CD_EDICAO_AMB_w, ds_aux_w, nr_seq_ajuste_proc_w;	
			end if;
		end if;
	end if;
	update	ageint_exame_lab
	set	ie_Regra		= ie_regra_w,
		ie_glosa		= ie_glosa_w,
		nr_seq_regra		= nr_seq_regra_w,
		cd_procedimento		= cd_procedimento_w,
		ie_origem_proced	= ie_origem_proced_w,
		ie_autorizacao		= ie_autorizacao_w,
		vl_custo_operacional	= vl_custo_operacional_w,
		vl_anestesista		= vl_anestesista_w,
		vl_medico		= vl_medico_w,
		vl_auxiliares 		= vl_auxiliares_w,
		vl_materiais		= vl_materiais_w,
		vl_item			= vl_procedimento_w
	where	nr_sequencia		= nr_seq_ageint_exame_lab_w;
	
	if (ie_trigger_p = 'N') then
		commit;
	end if;
	
	cd_convenio_ww	:= cd_convenio_p;
	cd_categoria_ww	:= cd_categoria_p;
	cd_plano_ww	:= cd_plano_p;
	
	end;
end loop;
close C01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calcular_valor_proc_lab_ageint ( nr_seq_ageint_p bigint, cd_convenio_p bigint, cd_categoria_p text, cd_estabelecimento_p bigint, dt_inicio_agendamento_p timestamp, cd_plano_p text, nm_usuario_p text, cd_usuario_convenio_p text, cd_pessoa_fisica_p text, ie_tipo_Atendimento_p bigint, nr_seq_ageint_lab_p bigint, ie_trigger_p text) FROM PUBLIC;

