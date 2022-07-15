-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calcular_valor_proc_ageint ( nr_seq_ageint_p bigint, cd_convenio_p bigint, cd_categoria_p text, cd_estabelecimento_p bigint, dt_inicio_agendamento_p timestamp, cd_plano_p text, nm_usuario_p text, cd_usuario_convenio_p text, cd_pessoa_fisica_p text, ie_tipo_Atendimento_p bigint, nr_seq_cobetura_p bigint) AS $body$
DECLARE


nr_seq_proc_interno_w	bigint;
qt_pontos_w			preco_amb.qt_pontuacao%type;
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
VL_PROCEDIMENTO_w	double precision;
vl_item_w		double precision;
vl_aux_w		double precision;
nr_seq_item_ageint_w	bigint;
ds_aux_w		varchar(255);
ie_regra_w		integer;
cd_convenio_w		integer;
cd_convenio_ww		integer;
cd_categoria_w		varchar(10);
cd_plano_w		varchar(10);
ie_tipo_convenio_w	smallint;
dt_nascimento_w		timestamp;	
ie_Sexo_w		varchar(2);
qt_idade_w		smallint;
ie_glosa_w		varchar(1);
CD_EDICAO_AMB_w         integer;
VL_LANC_AUTOM_W         double precision;
ie_calcula_lanc_auto_w	varchar(1);
vl_custo_operacional_w	double precision;
vl_anestesista_w	double precision;
vl_medico_w		double precision;
vl_auxiliares_w		double precision;
vl_materiais_w		double precision;
cd_conv_item_w		integer;
cd_categ_item_w		varchar(10);
cd_plano_item_w		varchar(10);
nr_seq_regra_w		bigint;
ie_autorizacao_w	varchar(3);
ie_Resp_autor_w		varchar(10);
dt_transferencia_w	timestamp;
ie_edicao_w                  varchar(1);
cd_edicao_ajuste_w      bigint;
qt_item_edicao_w         bigint;
ie_pacote_w		varchar(1);
ie_pacote_item_w	varchar(1);	
cd_estab_item_w		smallint;
cd_estabelecimento_w	smallint;
ie_bloq_glosa_part_w	varchar(1);
ie_calc_glosa_atend_w	varchar(1);
ds_Erro_w		varchar(255);
nr_seq_Agenda_exame_w	agenda_integrada_item.nr_seq_Agenda_exame%type;
cd_proc_item_w		bigint;
ds_irrelavante_w	varchar(255);
nr_seq_ajuste_proc_w	bigint;
pr_glosa_w				double precision;
vl_glosa_w				double precision;
ie_regra_arredondamento_tx_w	varchar(1):= 'N';
ie_tipo_rounded_w		varchar(1);
ie_regra_arred_IPE_w		varchar(1):= 'N';
IE_CALCULA_GLOSA_w			parametro_Agenda_integrada.ie_calcula_glosa%type;
cd_medico_w					agenda_integrada_item.cd_medico%type;		
cd_especialidade_w			agenda_integrada_item.cd_especialidade%type;
ie_param_444_w               varchar(1) := '';
ie_excluir_valor             varchar(1) := 'N';

C01 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_proc_interno,
		dt_transferencia,
		coalesce(ie_pacote,'N'),
		cd_estabelecimento,
		nr_seq_Agenda_exame,
		cd_procedimento,
		cd_medico,
		cd_especialidade
	from	agenda_integrada_item
	where	nr_seq_agenda_int	= nr_seq_ageint_p
	and	(nr_seq_proc_interno IS NOT NULL AND nr_seq_proc_interno::text <> '');
			

BEGIN

select	coalesce(max(IE_CALCULA_GLOSA),'N')
into STRICT	IE_CALCULA_GLOSA_w
from	parametro_Agenda_integrada
where	coalesce(cd_estabelecimento, wheb_usuario_pck.get_cd_estabelecimento)	= wheb_usuario_pck.get_cd_estabelecimento;

select	coalesce(max(Obter_Valor_Param_Usuario(869, 7, Obter_Perfil_Ativo, nm_usuario_p, 0)), 'S')
into STRICT	ie_calcula_lanc_auto_w
;

ie_bloq_glosa_part_w := obter_param_usuario(869, 187, obter_perfil_ativo, nm_usuario_p, 0, ie_bloq_glosa_part_w);
ie_calc_glosa_atend_w := obter_param_usuario(869, 262, obter_perfil_ativo, nm_usuario_p, 0, ie_calc_glosa_atend_w);
ie_param_444_w := obter_param_usuario(869, 444, obter_perfil_ativo, nm_usuario_p, 0, ie_param_444_w);

select	max(ie_Sexo),
	max(dt_nascimento)
into STRICT	ie_Sexo_w,
	dt_nascimento_w
from	pessoa_fisica
where	cd_pessoa_fisica	= cd_pessoa_fisica_p;

qt_idade_w	:= obter_idade(dt_nascimento_w, clock_timestamp(), 'A');

cd_convenio_ww	:= cd_convenio_p;
cd_categoria_w	:= cd_categoria_p;
cd_plano_w	:= cd_plano_p;

open C01;
loop
fetch C01 into
	nr_seq_item_ageint_w,
	nr_seq_proc_interno_w,
	dt_transferencia_w,
	ie_pacote_w,
	cd_estab_item_w,
	nr_seq_Agenda_exame_w,
	cd_proc_item_w,
	cd_medico_w,
	cd_especialidade_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	
	cd_estabelecimento_w	:= coalesce(cd_estab_item_w,cd_estabelecimento_p);

	select	max(cd_convenio),
		max(cd_categoria),
		max(cd_plano)
	into STRICT	cd_conv_item_w,
		cd_categ_item_w,
		cd_plano_item_w
	from	agenda_integrada_conv_item
	where	nr_seq_agenda_item	= nr_seq_item_ageint_w;
	
	if (cd_conv_item_w IS NOT NULL AND cd_conv_item_w::text <> '') then
		cd_convenio_ww	:= cd_conv_item_w;
		cd_categoria_w	:= cd_categ_item_w;
		cd_plano_w	:= cd_plano_item_w;
	end if;
	
	select	max(ie_tipo_convenio)
	into STRICT	ie_tipo_convenio_w
	from	convenio
	where	cd_convenio	= cd_convenio_ww;
	
	SELECT * FROM obter_proc_tab_interno_conv(
					nr_seq_proc_interno_w, cd_estabelecimento_w, cd_convenio_ww, cd_categoria_w, cd_plano_w, null, cd_procedimento_w, ie_origem_proced_w, null, clock_timestamp(), null, null, null, null, null, null, null, null) INTO STRICT cd_procedimento_w, ie_origem_proced_w;
	
	SELECT * FROM Consiste_Plano_mat_proc(cd_estabelecimento_w, cd_convenio_ww, cd_categoria_w, cd_plano_w, null, cd_procedimento_w, ie_origem_proced_w, null, coalesce(ie_tipo_Atendimento_p,0), 0, 0, null, nr_Seq_proc_interno_w, ds_aux_w, ds_aux_w, ie_regra_w, nr_seq_regra_w) INTO STRICT ds_aux_w, ds_aux_w, ie_regra_w, nr_seq_regra_w;
					
	SELECT * FROM ageint_consiste_plano_conv(
					null, cd_convenio_ww, cd_procedimento_w, ie_origem_proced_w, clock_timestamp(), 1, coalesce(ie_tipo_Atendimento_p,0), cd_plano_w, null, ds_erro_w, 0, null, ie_regra_w, null, nr_seq_regra_w, nr_Seq_proc_interno_W, cd_categoria_w, cd_estabelecimento_w, null, ie_Sexo_w, ie_glosa_w, cd_edicao_ajuste_w, nr_seq_cobetura_p, ds_irrelavante_w, ds_irrelavante_w, cd_pessoa_fisica_p, null, pr_glosa_w, vl_glosa_w) INTO STRICT ds_erro_w, ie_regra_w, nr_seq_regra_w, ie_glosa_w, cd_edicao_ajuste_w, ds_irrelavante_w, ds_irrelavante_w, pr_glosa_w, vl_glosa_w;
				
	ie_edicao_w		:= obter_se_proc_conv(cd_estabelecimento_w, cd_convenio_ww, cd_categoria_w, clock_timestamp(), cd_procedimento_W, ie_origem_proced_w, nr_Seq_proc_interno_w, ie_tipo_atendimento_p);
	
	ie_pacote_item_w	:= obter_Se_pacote_convenio(cd_procedimento_w, ie_origem_proced_w, cd_convenio_ww, cd_estabelecimento_w);

            if (ie_edicao_w				= 'N') and (coalesce(cd_edicao_ajuste_w,0) 	= 0) and (coalesce(ie_glosa_w,'L') 		= 'L') and (ie_pacote_item_w 			= 'N') then
                ie_glosa_w        := 'T';
            end if;

			if 	ie_glosa_w = 'E' and
				coalesce(ie_param_444_w,'N') = 'N' and
				ie_tipo_convenio_w = '1' then
				ie_excluir_valor := 'S';
			end if;
			
            if (ie_edicao_w 				= 'N') and (coalesce(cd_edicao_ajuste_w,0) 	> 0) and (coalesce(ie_glosa_w,'L') 		= 'L') and (ie_pacote_item_w 			= 'N') then
                        select   count(*)
                        into STRICT       qt_item_edicao_w
                        from      preco_amb
                        where   cd_edicao_amb = cd_edicao_ajuste_w
                        and       cd_procedimento = cd_procedimento_w
                        and       ie_origem_proced = ie_origem_proced_w;

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
		((coalesce(ie_glosa_w,'') not in ('T','G','R')) or (coalesce(ie_glosa_w::text, '') = '')))) and (IE_CALCULA_GLOSA_w = 'N' or (IE_CALCULA_GLOSA_w = 'S' and (coalesce(ie_glosa_w,'') not in ('P','R') or (coalesce(ie_glosa_w::text, '') = ''))))) then
		vl_procedimento_w	:= 0;
	else
		if (ie_glosa_w	in ('P','R') and
			IE_CALCULA_GLOSA_w = 'S') then
			SELECT * FROM Define_Preco_Procedimento(
				CD_ESTABELECIMENTO_w, cd_convenio_ww, cd_categoria_w, coalesce(dt_transferencia_w,dt_inicio_agendamento_p), CD_PROCEDIMENTO_w, 0, coalesce(ie_tipo_Atendimento_p,0), 0, cd_medico_w, --medico
				0, 0, 0, nr_seq_proc_interno_w, null, --usuario convenio
				cd_plano_w, 0, 0, null, VL_PROCEDIMENTO_w, vl_custo_operacional_w, vl_anestesista_w, vl_medico_w, vl_auxiliares_w, vl_materiais_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, qt_pontos_w, CD_EDICAO_AMB_w, ds_aux_w, nr_seq_ajuste_proc_w, 0, null, 0, 'N', null, null, null, null, null, cd_especialidade_w, null, null, null, null, null, null, null, null, null, null) INTO STRICT VL_PROCEDIMENTO_w, vl_custo_operacional_w, vl_anestesista_w, vl_medico_w, vl_auxiliares_w, vl_materiais_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, qt_pontos_w, CD_EDICAO_AMB_w, ds_aux_w, nr_seq_ajuste_proc_w;

			if (ie_glosa_w = 'P') then
				vl_glosa_w:= vl_procedimento_w * pr_glosa_w / 100;
				
				/* ROTINA DE ARREDONDAMENTO, USADO PELO CONVENIO IPE   --->>    INICIO  <<----- */

				begin
				select 	coalesce(max(ie_regra_arredondamento_tx),'N')
				into STRICT	ie_regra_arredondamento_tx_w
				from 	parametro_faturamento
				where 	cd_estabelecimento = cd_estabelecimento_w;
				exception
					when others then
						ie_regra_arredondamento_tx_w:= 'N';
				end;	

				if (ie_regra_arredondamento_tx_w = 'S')then

					select	max(ie_arredondamento)
					into STRICT	ie_tipo_rounded_w
					from	convenio_estabelecimento
					where	cd_convenio	  	= cd_convenio_w
					and	cd_estabelecimento	= cd_estabelecimento_w;

					if (ie_tipo_rounded_w = 'R') then

						select 	obter_regra_arredondamento(cd_convenio_ww, cd_categoria_w, cd_procedimento_w, ie_origem_proced_w, cd_estabelecimento_w,
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
				where	cd_estabelecimento	= cd_estabelecimento_w;
				
				if (cd_convenio_w IS NOT NULL AND cd_convenio_w::text <> '') then
					select	max(cd_plano)
					into STRICT	cd_plano_w
					from	convenio_plano
					where	cd_convenio	= cd_convenio_w
					and	ie_situacao	= 'A';
				end if;
			end if;
			
			if (coalesce(cd_convenio_w::text, '') = '') then
				cd_convenio_w	:= cd_convenio_ww;
				cd_Categoria_w	:= cd_categoria_w;
				cd_plano_w	:= cd_plano_w;
			end if;
					
			if ie_excluir_valor <> 'S' then
					
				SELECT * FROM Define_Preco_Procedimento(
					cd_estabelecimento_w, cd_convenio_w, cd_categoria_w, coalesce(dt_transferencia_w,dt_inicio_agendamento_p), CD_PROCEDIMENTO_w, 0, coalesce(ie_tipo_atendimento_p,0), 0, cd_medico_w, --medico
					0, 0, 0, nr_seq_proc_interno_w, null, --usuario convenio
					cd_plano_w, 0, 0, null, VL_PROCEDIMENTO_w, vl_custo_operacional_w, vl_anestesista_w, vl_medico_w, vl_auxiliares_w, vl_materiais_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, qt_pontos_w, CD_EDICAO_AMB_w, ds_aux_w, nr_seq_ajuste_proc_w, 0, null, 0, 'N', null, null, null, null, null, cd_especialidade_w, null, null, null, null, null, null, null, null, null, null) INTO STRICT VL_PROCEDIMENTO_w, vl_custo_operacional_w, vl_anestesista_w, vl_medico_w, vl_auxiliares_w, vl_materiais_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, qt_pontos_w, CD_EDICAO_AMB_w, ds_aux_w, nr_seq_ajuste_proc_w;
					
			end if;
			
			if (ie_calcula_lanc_auto_w	<> 'N') then
				/*Calcular_Lancamento_Automatico
						(cd_estabelecimento_w,
						cd_convenio_w,
						CD_CATEGORIA_W,
						sysdate,
						0,
						cd_procedimento_w,
						ie_origem_proced_w,
						null,
						0,
						nvl(QT_IDADE_W,0),
						0,
						0,
						nvl(NR_SEQ_PROC_INTERNO_W,0),
						nvl(ie_tipo_Atendimento_p,0),
						0,
						CD_USUARIO_CONVENIO_P,
						CD_PLANO_w,
						0,
						0,
						4,
						null, 
						CD_EDICAO_AMB_w,
						VL_LANC_AUTOM_W); */

					
				--vl_lanc_autom_w	:= obter_valor_regra_lanc_aut(cd_estabelecimento_w, cd_convenio_w, cd_categoria_w, cd_procedimento_w,ie_origem_proced_w,nr_seq_proc_interno_w, 34, 'T');
				vl_lanc_autom_w := ageint_Calcular_Lanc_Aut(cd_estabelecimento_w, cd_convenio_w, cd_categoria_w, clock_timestamp(), null, cd_procedimento_w, ie_origem_proced_w, null, null, qt_idade_w, null, 0, nr_seq_proc_interno_w, ie_tipo_atendimento_p, null, cd_usuario_convenio_p, cd_plano_w, null, null, 4, null, cd_edicao_amb_w, vl_lanc_autom_w);
			end if;
		end if;
	end if;
	
	if (ie_pacote_w	= 'N') then		
		
		if (ie_calcula_lanc_auto_w = 'S') then
			vl_item_w		:= vl_procedimento_w + coalesce(VL_LANC_AUTOM_W,0);
		else
			vl_item_w		:= vl_procedimento_w;
		end if;
	
		update	agenda_integrada_item
		set	vl_item			= vl_item_w,
			ie_Regra		= ie_regra_w,
			ie_glosa		= ie_glosa_w,
			vl_custo_operacional	= vl_custo_operacional_w,
			vl_anestesista		= vl_anestesista_w,
			vl_medico		= vl_medico_w,
			vl_auxiliares		= vl_auxiliares_w,
			vl_materiais		= vl_materiais_w,
			vl_lanc_auto		= VL_LANC_AUTOM_W,
			nr_seq_regra		= nr_seq_regra_w,
			cd_procedimento		= cd_procedimento_w,
			ie_origem_proced	= ie_origem_proced_w,
			ie_autorizacao		= ie_autorizacao_w
		where	nr_sequencia		= nr_seq_item_Ageint_w;
	end if;
	
	if (nr_seq_agenda_exame_w IS NOT NULL AND nr_seq_agenda_exame_w::text <> '') and (cd_proc_item_w	<> cd_procedimento_w) then
		update	agenda_paciente
		set	cd_procedimento		= cd_procedimento_w,
			ie_origem_proced	= ie_origem_proced_w,
			dt_atualizacao		= clock_timestamp(),
			nm_usuario		= nm_usuario_p
		where	nr_sequencia	= nr_seq_agenda_exame_w;
	end if;
	
	cd_convenio_ww	:= cd_convenio_p;
	cd_categoria_w	:= cd_categoria_p;
	cd_plano_w	:= cd_plano_p;
	end;
end loop;
close C01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calcular_valor_proc_ageint ( nr_seq_ageint_p bigint, cd_convenio_p bigint, cd_categoria_p text, cd_estabelecimento_p bigint, dt_inicio_agendamento_p timestamp, cd_plano_p text, nm_usuario_p text, cd_usuario_convenio_p text, cd_pessoa_fisica_p text, ie_tipo_Atendimento_p bigint, nr_seq_cobetura_p bigint) FROM PUBLIC;

