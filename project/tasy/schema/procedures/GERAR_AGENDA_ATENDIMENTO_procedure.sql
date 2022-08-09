-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_agenda_atendimento (nr_atendimento_p bigint, nr_seq_agenda_p bigint, ie_agenda_p text, nm_usuario_p text, cd_estabelecimento_p bigint default null) AS $body$
DECLARE

					
cd_pessoa_fisica_w		varchar(10);
cd_convenio_w			integer;
dt_nascimento_w			timestamp;
qt_idade_w			smallint;
cd_medico_resp_w		varchar(10);
cd_categoria_w			varchar(20);
cd_tipo_acomodacao_w		smallint;
cd_usuario_convenio_w		varchar(30);
cd_complemento_w		varchar(30);
dt_validade_carteira_w		timestamp;
ie_tipo_atendimento_w		bigint;
qt_idade_mes_w			smallint;
cd_plano_w			varchar(10);
ie_tipo_atend_vinculo_w		varchar(30) 	:= null;
ie_vincula_atend_w		varchar(1) 	:= 'S';
ie_cons_regra_agend_conv_w	varchar(1) 	:= 'N';
cd_agenda_w			bigint;
cd_setor_atendimento_w		bigint;
dt_agenda_w			timestamp;
ie_consistencia_w		varchar(255)	:= '';
ie_agenda_w			varchar(1)	:= 'S';
ie_classif_agenda_w		varchar(5);
qt_dias_regra_w			bigint;
nr_dias_fut_agendamento_w	bigint;
cd_estabelecimento_w		smallint := wheb_usuario_pck.get_cd_estabelecimento;
nr_seq_evento_w			bigint;
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
cd_seq_proc_interno_w		bigint;
ie_sexo_w			varchar(1);
hr_inicio_w			timestamp;
ie_carater_inter_sus_w		varchar(2);
cd_estab_w			smallint;
ie_conv_nao_lib_agenda_w 	varchar(1);
ie_status_agenda_w		varchar(3) := null;
ds_observacao_w			varchar(255);
cd_empresa_ref_w		bigint;
nm_usuario_origem_w		agenda_consulta.nm_usuario_origem%type;
nm_usuario_w			agenda_consulta.nm_usuario%type;
qt_regra_w			bigint;

c01 CURSOR FOR	
	SELECT	nr_seq_evento
	from	regra_envio_sms
	where	cd_estabelecimento		= cd_estabelecimento_w
	and	ie_evento_disp			= 'GAA'
	and	coalesce(qt_idade_w,0) between coalesce(qt_idade_min,0)	and coalesce(qt_idade_max,9999)
	and	coalesce(ie_sexo,coalesce(ie_sexo_w,'XPTO'))  = coalesce(ie_sexo_w,'XPTO')
	and	coalesce(cd_medico,coalesce(cd_medico_resp_w,'0')) = coalesce(cd_medico_resp_w,'0')
	and (obter_se_convenio_rec_alerta(cd_convenio_w,nr_sequencia) = 'S')
	and (obter_se_proc_rec_alerta(cd_seq_proc_interno_w,nr_sequencia,cd_procedimento_w,ie_origem_proced_w) = 'S')
	and (obter_classif_regra(nr_sequencia,coalesce(obter_classificacao_pf(cd_pessoa_fisica_w),0)) = 'S')
	and (obter_se_regra_envio(nr_sequencia,nr_atendimento_p) = 'S')
	and (obter_regra_alerta_agenda(nr_sequencia,cd_agenda_w,ie_status_agenda_w) = 'S')
	and	coalesce(ie_situacao,'A') = 'A';


BEGIN

if (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') then
	cd_estab_w	:= cd_estabelecimento_p;
else
	cd_estab_w	:= cd_estabelecimento_w;
end if;

ie_tipo_atend_vinculo_w := Obter_Param_Usuario(871, 542, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_tipo_atend_vinculo_w);
ie_cons_regra_agend_conv_w := Obter_Param_Usuario(821, 370, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_cons_regra_agend_conv_w);
qt_dias_regra_w := Obter_Param_Usuario(821, 5, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, qt_dias_regra_w);

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (ie_tipo_atend_vinculo_w IS NOT NULL AND ie_tipo_atend_vinculo_w::text <> '') and (obter_funcao_ativa = 871) then
	select   coalesce(max('S'),'N')
	into STRICT     ie_vincula_atend_w
	from     atendimento_paciente	
	where    nr_atendimento = nr_atendimento_p
	and      obter_se_contido(ie_tipo_atendimento,ie_tipo_atend_vinculo_w) = 'S';
end if;

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '') and (ie_agenda_p IS NOT NULL AND ie_agenda_p::text <> '') then
	/* obter dados atendimento */

	select	a.cd_pessoa_fisica,
		b.cd_convenio,
		to_date(obter_dados_pf(a.cd_pessoa_fisica,'DN'),'dd/mm/yyyy'),
		(obter_dados_pf(a.cd_pessoa_fisica,'I'))::numeric ,
		campo_numerico(obter_idade(obter_data_nascto_pf(a.cd_pessoa_fisica),clock_timestamp(),'MM')),
		a.cd_medico_resp,
		b.cd_categoria,
		b.cd_tipo_acomodacao,
		b.cd_usuario_convenio,
		b.cd_complemento,
		b.dt_validade_carteira,
		a.ie_tipo_atendimento,
		b.cd_plano_convenio
	into STRICT	cd_pessoa_fisica_w,
		cd_convenio_w,
		dt_nascimento_w,
		qt_idade_w,
		qt_idade_mes_w,
		cd_medico_resp_w,		
		cd_categoria_w,
		cd_tipo_acomodacao_w,
		cd_usuario_convenio_w,
		cd_complemento_w,
		dt_validade_carteira_w,
		ie_tipo_atendimento_w,
		cd_plano_w
	FROM atendimento_paciente a
LEFT OUTER JOIN atend_categoria_convenio b ON (a.nr_atendimento = b.nr_atendimento)
, obter_atecaco_atendimento(a
LEFT OUTER JOIN atend_categoria_convenio b ON (obter_atecaco_atendimento(a.nr_atendimento) = b.nr_seq_interno)
WHERE a.nr_atendimento = nr_atendimento_p;

	if (ie_agenda_p = 'C') then /* agenda consulta */
		
		select	max(a.cd_agenda),
			max(a.cd_setor_atendimento),
			max(a.dt_agenda),
			max(a.ie_classif_agenda),
			max(a.cd_empresa_ref),
			max(a.nm_usuario_origem),
			max(a.nm_usuario)
		into STRICT	cd_agenda_w,
			cd_setor_atendimento_w,
			dt_agenda_w,
			ie_classif_agenda_w,
			cd_empresa_ref_w,
			nm_usuario_origem_w,
			nm_usuario_w
		from	agenda_consulta a
		where	a.nr_sequencia = nr_seq_agenda_p;
		
		CALL consiste_convenio_agecons(0, cd_agenda_w, cd_convenio_w, dt_agenda_w, '');
		
		select	max(nr_dias_fut_agendamento)
		into STRICT	nr_dias_fut_agendamento_w
		from	agenda
		where	cd_agenda = cd_agenda_w;
		
		/* Consistir regras gerais da agenda Agendamentos por convenio */

		if (ie_cons_regra_agend_conv_w = 'S') then
						
			CALL consiste_regra_agecons_conv(cd_convenio_w,
							cd_categoria_w,
							cd_agenda_w,
							cd_setor_atendimento_w,
							cd_plano_w,
							cd_pessoa_fisica_w,
							dt_agenda_w,
							cd_estab_w,
							cd_empresa_ref_w,
							null);		
		end if;
		
		/* Regra agenda classificacao */

		SELECT * FROM consistir_classif_agecon(wheb_usuario_pck.get_cd_estabelecimento, cd_pessoa_fisica_w, dt_agenda_w, cd_agenda_w, cd_convenio_w, null, null, null, ie_classif_agenda_w, nr_seq_agenda_p, ie_consistencia_w, ie_agenda_w) INTO STRICT ie_consistencia_w, ie_agenda_w;
					
		if (ie_agenda_w = 'N') then
			CALL wheb_mensagem_pck.Exibir_Mensagem_Abort(195220, 'IE_CONSISTENCIA_W='||IE_CONSISTENCIA_W);
		end if;
		
		if (qt_dias_regra_w > 0) and
			(trunc(dt_agenda_w) > (trunc(clock_timestamp()) + qt_dias_regra_w)) then
			CALL wheb_mensagem_pck.Exibir_Mensagem_Abort(195221, 'QT_DIAS_REGRA_W='||QT_DIAS_REGRA_W);
		end if;
		
		if (nr_dias_fut_agendamento_w IS NOT NULL AND nr_dias_fut_agendamento_w::text <> '') and
			(trunc(dt_agenda_w) > (trunc(clock_timestamp()) + nr_dias_fut_agendamento_w)) then
			CALL wheb_mensagem_pck.Exibir_Mensagem_Abort(195222, 'NR_DIAS_FUT_AGENDAMENTO_W='||NR_DIAS_FUT_AGENDAMENTO_W);
		end if;
		
		select	max(obter_se_conv_lib_agenda_serv(cd_agenda_w, cd_convenio_w))
		into STRICT	ie_conv_nao_lib_agenda_w
		;

		if (wheb_usuario_pck.get_cd_funcao = 866) then
			
			if (ie_conv_nao_lib_agenda_w = 'N') then
				CALL wheb_mensagem_pck.Exibir_Mensagem_Abort(220661);
			end if;		
			
		elsif (ie_conv_nao_lib_agenda_w = 'S') then
				
				select	count(*)
				into STRICT	qt_regra_w
				from	regra_lib_conv_agenda
				where	cd_agenda = cd_agenda_w;

				if (qt_regra_w > 0) then
				CALL wheb_mensagem_pck.Exibir_Mensagem_Abort(1033942);	
				end if;
						
		end if;		
			
		if (coalesce(nm_usuario_origem_w::text, '') = '') then			
		
			update	agenda_consulta
			set	cd_pessoa_fisica	= cd_pessoa_fisica_w,
				cd_convenio		= cd_convenio_w,
				dt_nascimento_pac	= dt_nascimento_w,
				qt_idade_pac		= qt_idade_w,
				cd_medico_solic	= cd_medico_resp_w,
				cd_categoria		= cd_categoria_w,
				cd_tipo_acomodacao	= cd_tipo_acomodacao_w,
				cd_usuario_convenio	= cd_usuario_convenio_w,
				cd_complemento	= cd_complemento_w,
				dt_validade_carteira	= dt_validade_carteira_w,
				ie_status_agenda	= 'N',
				dt_atualizacao	= clock_timestamp(),
				nm_usuario		= nm_usuario_p,
				nm_paciente		= obter_nome_pf(cd_pessoa_fisica_w),
				nm_usuario_origem	= nm_usuario_p,
				dt_agendamento		= clock_timestamp(),
				nr_atendimento		= nr_atendimento_p,
                nr_telefone		= obter_fone_pac_agenda(cd_pessoa_fisica_w)
			where	nr_sequencia		= nr_seq_agenda_p;
		end if;
		
	elsif (ie_agenda_p = 'E') then /* agenda paciente */
		
		if (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '') then
			begin
			select	max(a.nr_seq_proc_interno),
				max(a.ie_origem_proced),
				max(a.cd_procedimento),
				max(substr(obter_Sexo_pf(cd_pessoa_fisica,'C'),1,60)),
				max(a.hr_inicio),
				max(a.cd_agenda),
				max(a.ie_status_agenda),
				max(substr(ds_observacao,1,60)),
				max(a.nm_usuario_orig),
				max(a.nm_usuario)
			into STRICT	cd_seq_proc_interno_w,
				ie_origem_proced_w,
				cd_procedimento_w,
				ie_sexo_w,
				hr_inicio_w,
				cd_agenda_w,
				ie_status_agenda_w,
				ds_observacao_w,
				nm_usuario_origem_w,
				nm_usuario_w
			from	agenda_paciente a
			where	nr_sequencia = nr_seq_agenda_p;
			end;
		end if;	
		
		if (coalesce(nm_usuario_origem_w::text, '') = '') then
		
			update	agenda_paciente
			set	cd_pessoa_fisica	= cd_pessoa_fisica_w,
				nm_paciente		= obter_nome_pf(cd_pessoa_fisica_w),
				dt_nascimento_pac	= dt_nascimento_w,
				qt_idade_paciente	= qt_idade_w,
				qt_idade_mes		= qt_idade_mes_w,
				nr_telefone		= obter_fone_pac_agenda(cd_pessoa_fisica_w),
				cd_convenio		= cd_convenio_w,
				cd_categoria		= cd_categoria_w,
				cd_usuario_convenio	= cd_usuario_convenio_w,
				dt_validade_carteira	= dt_validade_carteira_w,
				cd_tipo_acomodacao	= cd_tipo_acomodacao_w,
				cd_medico		= cd_medico_resp_w,
				cd_medico_exec		= cd_medico_resp_w,
				ie_status_agenda	= 'N',
				nm_usuario_orig		= nm_usuario_p,
				dt_agendamento		= clock_timestamp(),
				dt_atualizacao		= clock_timestamp(),			
				nr_atendimento		= CASE WHEN ie_vincula_atend_w='S' THEN nr_atendimento_p  ELSE null END ,
				ie_tipo_atendimento	= ie_tipo_atendimento_w,
				cd_plano		= cd_plano_w,
				ie_agenda_atend		= 'S',
				ie_tipo_agendamento	= 'AA'
			where	nr_sequencia		= nr_seq_agenda_p;
		end if;
	end if;
end if;

commit;

CALL gerar_lancamento_automatico(nr_atendimento_p, null, 586, nm_usuario_p, nr_seq_agenda_p, null, null, null, ie_classif_agenda_w, null);

open c01;
loop
fetch c01 into	
	nr_seq_evento_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin		
	if (nr_seq_evento_w IS NOT NULL AND nr_seq_evento_w::text <> '') then
		begin
		
		
		
		CALL gerar_evento_agenda_trigger(	nr_seq_evento_w,
						nr_atendimento_p,
						cd_pessoa_fisica_w,
						null,
						nm_usuario_p,
						cd_agenda_w,
						hr_inicio_w, 
						cd_medico_resp_w, 
						cd_procedimento_w,
						ie_origem_proced_w, 
						null,
						null,
						null,
						null,
						cd_convenio_w,
						null,
						'N',
						nr_seq_agenda_p,
						null,
						null,
						null,
						null,
						ds_observacao_w);
		end;
	end if;
	end;
end loop;
close c01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_agenda_atendimento (nr_atendimento_p bigint, nr_seq_agenda_p bigint, ie_agenda_p text, nm_usuario_p text, cd_estabelecimento_p bigint default null) FROM PUBLIC;
