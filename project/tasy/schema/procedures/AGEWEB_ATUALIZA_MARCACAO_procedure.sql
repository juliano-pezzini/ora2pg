-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageweb_atualiza_marcacao (cd_agenda_p bigint, hr_agenda_p text, cd_convenio_p bigint, cd_categoria_p text, cd_plano_p text, cd_pessoa_fisica_p text, nm_usuario_p text, cd_medico_p text, nr_seq_proc_interno_p bigint, nr_seq_dependente_p bigint, cd_empresa_p bigint, ds_erro_p INOUT text, ds_mensagem_p INOUT text) AS $body$
DECLARE


hr_agenda_w		varchar(30);
hr_dia_w		varchar(30);
hr_hora_w		varchar(30);
cd_tipo_agenda_w        bigint;
cd_especialidade_w	bigint;
cd_estabelecimento_w	smallint;
cd_profissional_w	varchar(10);

ie_classif_agenda_cons_w varchar(5);
ie_classif_regra_w	 varchar(5);
				
nr_Seq_agenda_w         agenda_consulta.nr_sequencia%type;
ie_status_Agenda_w      varchar(3);	
ie_reservado_w          varchar(1)     := 'L';		

qt_agendamento_w	bigint	:= 0;
cd_plano_w		varchar(10)	:= coalesce(cd_plano_p,'');
nm_paciente_w		varchar(255);
ds_email_destino_w	varchar(255);
ds_titulo_w		varchar(255);
ds_remetente_w		varchar(255);
ds_mensagem_w		varchar(32000);

ds_especialidade_w	varchar(255);
nm_especialista_w	varchar(255);

ds_nome_fantasia_estab_w	varchar(255);

cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;

ds_proc_exame_w		varchar(100);
ds_orientacao_w		varchar(32000) := '';	

qt_idade_pac_w		bigint;
ds_erro_idade_w		varchar(255);
ds_erro_idade_turno_esp_w varchar(255);

ie_permite_agendar_w	varchar(1) := 'S';
nr_seq_plano_w		bigint;
dt_nascimento_w		timestamp;
nm_dependente_w		varchar(255);
cd_pessoa_dependente_w	varchar(10);
ie_dia_semana_w		smallint;	
nr_seq_regra_w		bigint;	
ie_agenda_w		varchar(1);
ie_excecao_paciente_w 	bigint;
ds_mensagem_regra_w	varchar(255);
cd_setor_exclusivo_w	integer;
qt_agendamentos_w	bigint;
ie_agendado_w		varchar(1);	
hr_agenda_dt_w		timestamp;
ds_erro_w		varchar(4000);	
qt_regra_espec_w	integer;			
qt_agendamento_perm_w	bigint;
cd_municipio_ibge_w	varchar(6);
ie_status_agenda_ww	varchar(1);
ie_sexo_agenda_w	agenda.ie_sexo_agenda%type;
ie_sexo_pessoa_w	pessoa_fisica.ie_sexo%type;
ie_pessoa_obito_w	varchar(1);
ds_observacao_w		varchar(2000);
	
c01 CURSOR FOR
	SELECT 	coalesce(nr_sequencia,0)
	from	regra_agecons_convenio
	where	((cd_convenio = cd_convenio_p) or (coalesce(cd_convenio::text, '') = ''))
	and	((cd_agenda = cd_agenda_p) or (coalesce(cd_agenda::text, '') = ''))
	and	((cd_categoria = cd_categoria_p) or (coalesce(cd_categoria::text, '') = ''))
	and	((cd_plano_convenio = cd_plano_p) or (coalesce(cd_plano_convenio::text, '') = ''))
	and	((cd_medico = cd_profissional_w) or (coalesce(cd_medico::text, '') = ''))
	and	((coalesce(ie_primeiro_agendamento,'N') = 'S' and ie_agendado_w = 'N') or (coalesce(ie_primeiro_agendamento,'N') = 'N'))
	and	((cd_pessoa_fisica = cd_pessoa_fisica_p) or (coalesce(cd_pessoa_fisica::text, '') = ''))
	and (trunc(hr_agenda_dt_w) >= dt_inicial_vigencia or coalesce(dt_inicial_vigencia::text, '') = '')
	and (trunc(hr_agenda_dt_w) <= dt_final_vigencia or coalesce(dt_final_vigencia::text, '') = '')
	and (hr_agenda_dt_w between to_date(to_char(hr_agenda_dt_w,'dd/mm/yyyy') ||' '|| to_char(coalesce(hr_inicial,trunc(hr_agenda_dt_w,'dd')),'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')
	and 	to_date(to_char(hr_agenda_dt_w,'dd/mm/yyyy') ||' '|| to_char(coalesce(hr_final,trunc(hr_agenda_dt_w)+86399/86400),'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss'))
	and	((cd_setor_atendimento = cd_setor_exclusivo_w) or (coalesce(cd_setor_atendimento::text, '') = ''))
	and	((ie_dia_semana = ie_dia_semana_w) or ((ie_dia_semana = 9) and (ie_dia_Semana_w not in (7,1))) or (coalesce(ie_dia_semana::text, '') = ''))
	and	(((cd_setor_atendimento = cd_setor_exclusivo_w) and coalesce(ie_forma_consiste_setor,'E') = 'E') or (coalesce(cd_setor_atendimento::text, '') = ''))
	and	((cd_especialidade = cd_especialidade_w) or (coalesce(cd_especialidade::text, '') = ''))
	and	((nr_seq_plano = nr_seq_plano_w) or (coalesce(nr_seq_plano::text, '') = ''))
	--and	nvl(ie_forma_consiste_setor,'A') = 'E'
	and 	((cd_municipio_ibge = cd_municipio_ibge_w) or (coalesce(cd_municipio_ibge::text, '') = ''))
	order 	by	coalesce(cd_convenio,0),
			coalesce(cd_pessoa_fisica,0), 
			coalesce(cd_setor_atendimento,0), 
			coalesce(cd_plano_convenio,0), 
			coalesce(cd_categoria,0),
			coalesce(cd_agenda,0),
			coalesce(cd_especialidade,0),
			coalesce(dt_inicial_vigencia,clock_timestamp()),
			coalesce(dt_final_vigencia,clock_timestamp()),
			coalesce(hr_inicial,clock_timestamp()),
			coalesce(hr_final,clock_timestamp());				
				   

BEGIN

select 	obter_se_paciente_obito(cd_pessoa_fisica_p ) 
into STRICT	ie_pessoa_obito_w
;

if (ie_pessoa_obito_w = 'A')then
	ds_erro_p := Wheb_mensagem_pck.get_texto(72025);
elsif (ie_pessoa_obito_w = 'C') then
	ds_erro_p := Wheb_mensagem_pck.get_texto(72026);
else
	begin
	ds_erro_p := '';

	select	max(cd_municipio_ibge)
	into STRICT	cd_municipio_ibge_w
	from	compl_pessoa_fisica
	where	cd_pessoa_fisica	= cd_pessoa_fisica_p
	and	ie_tipo_complemento	= 1;

	select  max(cd_tipo_agenda),
		max(cd_especialidade),
		max(cd_estabelecimento),
		max(cd_pessoa_fisica),
		max(cd_setor_exclusivo),
		max(substr(Obter_nome_fantasia_estab(cd_estabelecimento),1,255)),
		max(coalesce(ie_sexo_agenda, 'A'))
	into STRICT    cd_tipo_agenda_w,
		cd_especialidade_w,
		cd_estabelecimento_w,
		cd_profissional_w,
		cd_setor_exclusivo_w,
		ds_nome_fantasia_estab_w,
		ie_sexo_agenda_w
	from    agenda
	where   cd_agenda       = cd_agenda_p;

	select	max(ie_classif_agenda_cons)
	into STRICT	ie_classif_agenda_cons_w
	from	parametro_agenda_web;

	begin
	select	max(a.nr_seq_plano)
	into STRICT	nr_seq_plano_w
	from	pls_segurado	a
	where	a.cd_pessoa_fisica	= cd_pessoa_fisica_p
	and	((coalesce(a.dt_rescisao::text, '') = '') or (a.dt_rescisao > clock_timestamp()))
	and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '');
	exception
	when others then
	nr_seq_plano_w	:= 0;	
	end;


	hr_agenda_w	:= to_char(to_date(hr_agenda_p,'dd/mm/yyyy hh24:mi:ss'),'dd/mm/yyyy hh24:mi');
	hr_dia_w	:= to_char(to_date(hr_agenda_p,'dd/mm/yyyy hh24:mi:ss'),'dd/mm/yyyy');		
	hr_hora_w	:= to_char(to_date(hr_agenda_p,'dd/mm/yyyy hh24:mi:ss'),'hh24:mi');

	hr_agenda_dt_w	:= to_date(hr_agenda_p,'dd/mm/yyyy hh24:mi:ss');
	ie_dia_semana_w	:= obter_cod_dia_semana(hr_agenda_dt_w);

	if (nr_seq_dependente_p IS NOT NULL AND nr_seq_dependente_p::text <> '') then
		select	max(dt_nascimento),
			max(nm_dependente),
			max(cd_pessoa_dependente)
		into STRICT	dt_nascimento_w,
			nm_dependente_w,
			cd_pessoa_dependente_w
		from	pessoa_fisica_dependente
		where	nr_sequencia = nr_seq_dependente_p;
	end if;

	if (cd_tipo_agenda_w = 3) then
		
		/*Validar o sexo do paciente x agenda*/

		if (ie_sexo_agenda_w <> 'A') then
			select	max(coalesce(ie_sexo,'A'))
			into STRICT	ie_sexo_pessoa_w
			from	pessoa_fisica
			where	cd_pessoa_fisica = cd_pessoa_fisica_p;
			
			if	(ie_sexo_pessoa_w <> 'A' AND ie_sexo_pessoa_w <> 'I') and (ie_sexo_pessoa_w <> ie_sexo_agenda_w)then
				--O sexo do paciente selecionado nao eh permitido nesta agenda!
				ds_erro_p := WHEB_MENSAGEM_PCK.get_texto(268471,null);
				goto final;
			end if;		
		end if;
		
		select	count(*)
		into STRICT	qt_agendamentos_w
		from	agenda_consulta a,
				agenda b
		where	a.cd_agenda 		= b.cd_agenda
		and		b.cd_pessoa_fisica 	= cd_profissional_w
		and		a.cd_pessoa_fisica	= cd_pessoa_fisica_p
		and (a.cd_convenio		= cd_convenio_p or (coalesce(cd_convenio_p::text, '') = '' and coalesce(a.cd_convenio::text, '') = ''))
		and		a.ie_status_agenda not in ('C','F');

		select	max(coalesce(qt_regra,0)) qt_regra
		into STRICT	qt_regra_espec_w
		from	ageweb_regra_qt_espec
		where	cd_especialidade = cd_especialidade_w;
		
		if (qt_regra_espec_w > 0) then
			qt_agendamento_perm_w	:= qt_regra_espec_w;
		else
			qt_agendamento_perm_w	:= 1;
		end if;
		
		if (qt_agendamentos_w >= qt_regra_espec_w) then
			ie_agendado_w := 'S';
		else
			ie_agendado_w := 'N';
		end if;
		
		open c01;
		loop
		fetch c01 into	
			nr_seq_regra_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			begin
			nr_seq_regra_w := nr_seq_regra_w;
			end;
		end loop;
		close c01;

		if (nr_seq_regra_w > 0) then
			
			select	coalesce(max(ie_permite),'S'),
				coalesce(max(ds_mensagem),'')
			into STRICT	ie_agenda_w,
				ds_mensagem_regra_w
			from	regra_agecons_convenio
			where	nr_sequencia = nr_seq_regra_w
			and	((cd_pessoa_fisica = cd_pessoa_fisica_p) or (coalesce(cd_pessoa_fisica::text, '') = ''));
					
			select 	count(*)
			into STRICT	ie_excecao_paciente_w
			from	regra_agecons_convenio
			where	((cd_convenio = cd_convenio_p) or (coalesce(cd_convenio::text, '') = ''))
			and	((cd_agenda = cd_agenda_p) or (coalesce(cd_agenda::text, '') = ''))
			and	((cd_categoria = cd_categoria_p) or (coalesce(cd_categoria::text, '') = ''))
			and	((cd_plano_convenio = cd_plano_p) or (coalesce(cd_plano_convenio::text, '') = ''))
			and	coalesce(cd_setor_atendimento::text, '') = ''
			and	((cd_medico = cd_profissional_w) or (coalesce(cd_medico::text, '') = ''))
			and (trunc(hr_agenda_dt_w) >= dt_inicial_vigencia or coalesce(dt_inicial_vigencia::text, '') = '')
			and (trunc(hr_agenda_dt_w) <= dt_final_vigencia or coalesce(dt_final_vigencia::text, '') = '')
			and (hr_agenda_dt_w between to_date(to_char(hr_agenda_dt_w,'dd/mm/yyyy') ||' '|| to_char(coalesce(hr_inicial,trunc(hr_agenda_dt_w,'dd')),'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')
			and 	to_date(to_char(hr_agenda_dt_w,'dd/mm/yyyy') ||' '|| to_char(coalesce(hr_final,trunc(hr_agenda_dt_w)+86399/86400),'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss'))
			and	cd_pessoa_fisica = cd_pessoa_fisica_p			
			and	((cd_especialidade = cd_especialidade_w) or (coalesce(cd_especialidade::text, '') = ''))
			and	ie_permite = 'S';
			
			if	(ie_agenda_w = 'N' AND ie_excecao_paciente_w = 0) then		
				ie_permite_agendar_w := 'N';
				ds_mensagem_p	:= ds_mensagem_regra_w;
			end if;
				
		end if;
		
		if (ie_permite_agendar_w = 'S') then
		
			/* Buscando seuqencia de agendamento conforme o horario que se deseja marcar */

			select  coalesce(max(nr_sequencia),0),
				max(ie_status_agenda)
			into STRICT    nr_Seq_agenda_w,
				ie_status_Agenda_w
			from    agenda_consulta
			where   cd_agenda       = cd_agenda_p
			and     dt_agenda       = to_date(hr_agenda_p,'dd/mm/yyyy hh24:mi:ss');
			
			/* Verificando agendamentos marcados para o futuro com a especialidade que esta tentando marcar */

			if (coalesce(nr_seq_dependente_p::text, '') = '') then
				select	count(*)
				into STRICT	qt_agendamento_w
				from	agenda a,
					agenda_consulta b
				where	a.cd_agenda = b.cd_agenda
				and	b.cd_pessoa_fisica	= cd_pessoa_fisica_p
				and	a.cd_especialidade 	= cd_especialidade_w
				and	a.cd_tipo_agenda	= 3
				and	b.ie_status_agenda	not in ('C','E','F','I')
				and	b.dt_agenda		> clock_timestamp();
				
				qt_idade_pac_w	:= (obter_dados_pf(cd_pessoa_fisica_p, 'I'))::numeric;
			else			
				qt_idade_pac_w  := (obter_idade(dt_nascimento_w, trunc(clock_timestamp()), 'A'));
			end if;
			
			
				
			/* Verificando idade */

			SELECT * FROM Consiste_Idade_Agenda_Pac(cd_agenda_p, to_date(hr_agenda_p,'dd/mm/yyyy hh24:mi:ss'), qt_idade_pac_w, null, ds_erro_idade_w, ds_erro_idade_turno_esp_w, nm_usuario_p) INTO STRICT ds_erro_idade_w, ds_erro_idade_turno_esp_w;
			
			if (ds_erro_idade_w IS NOT NULL AND ds_erro_idade_w::text <> '') then
				ds_erro_p := ds_erro_idade_w;
			end if;
			
			if (qt_agendamento_w >= qt_agendamento_perm_w) then
				ds_erro_p := upper(WHEB_MENSAGEM_PCK.get_texto(277664,null));--'Voce ja possui um agendamento marcado para esta especialidade, verifique!';
			/*elsif	(ie_reservado_w = 'N') then
				ds_erro_p := upper(WHEB_MENSAGEM_PCK.get_texto(277666,null));--'Este horario nao encontra-se mais disponivel para agendamento, por gentileza selecione outro!.';*/
			end if;
					
			ie_classif_regra_w := ageweb_obter_classif(cd_especialidade_w, qt_idade_pac_w, to_date(hr_agenda_p,'dd/mm/yyyy hh24:mi:ss'), cd_profissional_w);

			ie_classif_agenda_cons_w := coalesce(ie_classif_regra_w,ie_classif_agenda_cons_w);
				
			if  --(ie_reservado_w <> 'N') and			
				(coalesce(ds_erro_idade_w::text, '') = '') and (coalesce(ds_erro_p::text, '') = '') then
				
				/*Validar se horario ja marcado*/

				if (nr_seq_agenda_w IS NOT NULL AND nr_seq_agenda_w::text <> '') then
				begin
				select	ds_obs				
				into STRICT	ds_observacao_w
				from ( 	SELECT	b.ds_observacao ds_obs
						from	agenda_consulta a,
								agenda_turno b
						where	a.nr_sequencia = nr_seq_agenda_w
						and		b.nr_sequencia	= a.nr_seq_turno
						
union

						SELECT	b.ds_observacao ds_obs
						from	agenda_consulta a,
								agenda_turno_esp b
						where	a.nr_sequencia = nr_seq_agenda_w
						and		b.nr_sequencia	= a.nr_seq_turno_esp) alias5;
				
				exception
				when others then
					ds_observacao_w := null;
				end;
				
				select	max(coalesce(CASE WHEN coalesce(coalesce(cd_pessoa_fisica, CASE WHEN nm_paciente=ds_observacao_w THEN null  ELSE nm_paciente END )::text, '') = '' THEN  'L'  ELSE 'N' END ,'L'))
				into STRICT	ie_status_agenda_ww
				from	agenda_consulta
				where	nr_sequencia = nr_seq_agenda_w;
				end if;		
				
				if (ie_status_agenda_ww = 'L') and (qt_agendamento_w < qt_agendamento_perm_w) and (coalesce(ds_erro_idade_w::text, '') = '') then
					/* Tentando reservar o horario */

					ie_reservado_w := reservar_horario_agecons(nr_seq_agenda_w, nm_usuario_p, ie_reservado_w);
				end if;		
				
				if (ie_reservado_w = 'N') then
					ds_erro_p := upper(WHEB_MENSAGEM_PCK.get_texto(277666,null));--'Este horario nao encontra-se mais disponivel para agendamento, por gentileza selecione outro!.';*/
				end if;
				
				if (ie_reservado_w <> 'N') and (coalesce(ds_erro_idade_w::text, '') = '') and (coalesce(ds_erro_p::text, '') = '') then
					/* Marcando agendamento */
			
					if (ie_status_agenda_ww = 'L') then							
						if (coalesce(nr_seq_dependente_p::text, '') = '') then
							update	agenda_consulta
							set	cd_pessoa_fisica	= cd_pessoa_fisica_p,
								nm_paciente		= obter_nome_pf(cd_pessoa_fisica_p),
								cd_convenio		= cd_convenio_p,
								cd_categoria		= cd_categoria_p,
								cd_plano		= cd_plano_p,
								ie_forma_agendamento	= 7,
								ie_status_agenda	= 'N',
								ie_agenda_web		= 'S',
								nr_telefone		= obter_fone_pac_agenda(cd_pessoa_fisica_p),
								dt_nascimento_pac	= to_date(substr(obter_dados_pf(cd_pessoa_fisica_p,'DN'),1,10),'dd/mm/yyyy'),
								qt_idade_pac		= obter_dados_pf(cd_pessoa_fisica_p,'I'),
								ie_classif_agenda	= coalesce(ie_classif_agenda_cons_w,ie_classif_agenda),
								nm_usuario		= nm_usuario_p,
								dt_atualizacao		= clock_timestamp(),
								nm_usuario_acesso	 = NULL,
								cd_empresa_ref	 	= cd_empresa_p
							where	nr_sequencia		= nr_seq_agenda_w;
						else
							update	agenda_consulta
							set	cd_pessoa_fisica	= coalesce(cd_pessoa_dependente_w,cd_pessoa_fisica),
								nm_paciente		= CASE WHEN cd_pessoa_dependente_w = NULL THEN nm_dependente_w  ELSE nm_paciente END ,
								cd_convenio		= cd_convenio_p,
								cd_categoria		= cd_categoria_p,
								cd_plano		= cd_plano_p,
								ie_forma_agendamento	= 7,
								ie_status_agenda	= 'N',
								ie_agenda_web		= 'S',
								nr_telefone		= obter_fone_pac_agenda(cd_pessoa_fisica_p),
								dt_nascimento_pac	= dt_nascimento_w,
								qt_idade_pac		= qt_idade_pac_w,
								ie_classif_agenda	= coalesce(ie_classif_agenda_cons_w,ie_classif_agenda),
								nm_usuario		= nm_usuario_p,
								dt_atualizacao		= clock_timestamp(),
								nm_usuario_acesso	 = NULL,
								nr_matricula_ageweb	= cd_pessoa_fisica_p,
								cd_empresa_ref	 	= cd_empresa_p
							where	nr_sequencia		= nr_seq_agenda_w;							
						end if;						
						commit;
					else
						--'Este horario nao encontra-se mais disponivel para agendamento, por gentileza selecione outro!.'
						ds_erro_p := upper(WHEB_MENSAGEM_PCK.get_texto(277666,null));
						goto final;
					end if;
					
					update	ageweb_login
					set		cd_convenio		= cd_convenio_p,
							cd_categoria 	= cd_categoria_p,
							cd_plano		= cd_plano_p
					where	ds_login		= cd_pessoa_fisica_p;			
					
					select	substr(max(ds_titulo),1,255),
							substr(max(ds_remetente),1,255),
							substr(max(ds_mensagem),1,4000)
					into STRICT	ds_titulo_w,
							ds_remetente_w,
							ds_mensagem_w
					from	ageweb_cadastro_email
					where	ie_tipo_email = 'C'
					and		((ie_tipo_agenda = 'C') or (ie_tipo_agenda = 'A'));
						
					select	substr(max(b.ds_email),1,255),
							substr(max(obter_nome_pf(a.cd_pessoa_fisica)),1,255)
					into STRICT	ds_email_destino_w,
							nm_paciente_w
					from	pessoa_fisica a,
							compl_pessoa_fisica b
					where	a.cd_pessoa_fisica 	= b.cd_pessoa_fisica
					and		b.ie_tipo_complemento 	= 1
					and		a.cd_pessoa_fisica	= cd_pessoa_fisica_p;
					
					if (ds_titulo_w IS NOT NULL AND ds_titulo_w::text <> '') and (ds_remetente_w IS NOT NULL AND ds_remetente_w::text <> '') and (ds_mensagem_w IS NOT NULL AND ds_mensagem_w::text <> '') and (ds_email_destino_w IS NOT NULL AND ds_email_destino_w::text <> '') then
						
						select	substr(max(b.ds_especialidade),1,255),
								substr(max(obter_nome_pf(c.cd_pessoa_fisica)),1,255)					
						into STRICT	ds_especialidade_w,
								nm_especialista_w
						from	agenda a,
								especialidade_medica b,
								pessoa_fisica c
						where	a.cd_especialidade = b.cd_especialidade
						and		a.cd_pessoa_fisica = c.cd_pessoa_fisica
						and		a.cd_agenda = cd_agenda_p;
							
						ds_orientacao_w	:= Wheb_mensagem_pck.get_texto(307631); --'Sem orientacao';
						
						if (((nm_paciente_w IS NOT NULL AND nm_paciente_w::text <> '')  and (position('@paciente' in ds_mensagem_w) > 0)) or
						    ((nm_dependente_w IS NOT NULL AND nm_dependente_w::text <> '') and (position('@paciente' in ds_mensagem_w) > 0))) then
							
							if (coalesce(nr_seq_dependente_p::text, '') = '') then
								ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@paciente', nm_paciente_w),1,4000);
							else
								ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@paciente', nm_dependente_w),1,4000);
							end if;
						else
							ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@paciente', ' '),1,4000);
						end if;
						
						if (hr_agenda_w IS NOT NULL AND hr_agenda_w::text <> '') and (position('@data' in ds_mensagem_w) > 0) then
							ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@data', hr_agenda_w),1,4000);			
						else
							ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@data', ' '),1,4000);			
						end if;
						
						if (hr_dia_w IS NOT NULL AND hr_dia_w::text <> '') and (position('@dia' in ds_mensagem_w) > 0)  then
							ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@dia', hr_dia_w),1,4000);
						else
							ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@dia', ' '),1,4000);			
						end if;
						
						if (hr_hora_w IS NOT NULL AND hr_hora_w::text <> '') and (position('@hora' in ds_mensagem_w) > 0)  then
							ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@hora', hr_hora_w),1,4000);
						else
							ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@hora', ' '),1,4000);			
						end if;
						
						if (ds_especialidade_w IS NOT NULL AND ds_especialidade_w::text <> '') and (position('@agendamento' in ds_mensagem_w) > 0)  then
							ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@agendamento', ds_especialidade_w),1,4000);
						else
							ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@agendamento', ' '),1,4000);			
						end if;
						
						if (nm_especialista_w IS NOT NULL AND nm_especialista_w::text <> '') and (position('@especialista' in ds_mensagem_w) > 0)  then
							ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@especialista', nm_especialista_w),1,4000);
						else
							ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@especialista', ' '),1,4000);			
						end if;
						
						if (ds_orientacao_w IS NOT NULL AND ds_orientacao_w::text <> '') and (position('@orientacao' in ds_mensagem_w) > 0)  then
							ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@orientacao', ds_orientacao_w),1,4000);
						else
							ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@orientacao', ' '),1,4000);			
						end if;				
						
						if (ds_nome_fantasia_estab_w IS NOT NULL AND ds_nome_fantasia_estab_w::text <> '') and (position('@estab' in ds_mensagem_w) > 0)  then
							ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@estab', ds_nome_fantasia_estab_w),1,4000);
						else
							ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@estab', ' '),1,4000);			
						end if;					
						if (nr_seq_agenda_w IS NOT NULL AND nr_seq_agenda_w::text <> '') and (position('@seq_agenda' in ds_mensagem_w) > 0) then
							ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@seq_agenda', nr_seq_agenda_w),1,4000);
						end if;

						CALL enviar_email(ds_titulo_w, substr(ds_mensagem_w,1,4000), ds_remetente_w, ds_email_destino_w, 'Tasy', 'A');
					end if;
							
					ds_erro_p := upper(WHEB_MENSAGEM_PCK.get_texto(277667,null));
				end if;
			end if;
		else
			ds_erro_p := upper(WHEB_MENSAGEM_PCK.get_texto(277668,null));
		end if;
			
	elsif (cd_tipo_agenda_w = 2)	 then

		select  coalesce(max(nr_sequencia),0),
				max(ie_status_agenda)
		into STRICT    nr_Seq_agenda_w,
				ie_status_Agenda_w
		from    agenda_paciente
		where   cd_agenda       = cd_agenda_p
		and     hr_inicio       = to_date(hr_agenda_p,'dd/mm/yyyy hh24:mi:ss');
		
		/* Tentando reservar o horario */

		ie_reservado_w := reservar_horario_agenda_exame(nr_seq_agenda_w, nm_usuario_p, ie_reservado_w);
		
		if (ie_reservado_w <> 'N') then
			
			SELECT * FROM obter_proc_tab_interno_conv(
						nr_seq_proc_interno_p, cd_estabelecimento_w, cd_convenio_p, cd_categoria_p, cd_plano_p, null, cd_procedimento_w, ie_origem_proced_w, null, clock_timestamp(), null, null, null, null, null, null, null, null) INTO STRICT cd_procedimento_w, ie_origem_proced_w;
			
			/*Validar se horario ja marcado*/

			if (nr_seq_agenda_w IS NOT NULL AND nr_seq_agenda_w::text <> '') then
				begin
			select	ds_obs
			into STRICT	ds_observacao_w
			from ( 	SELECT	b.ds_observacao ds_obs
					from	agenda_paciente a,
							agenda_horario b
					where	a.nr_sequencia = nr_seq_agenda_w
					and		b.nr_sequencia	= a.nr_seq_horario
					
union

					SELECT	b.ds_observacao ds_obs
					from	agenda_paciente a,
							agenda_horario_esp b
					where	a.nr_sequencia = nr_seq_agenda_w
					and		b.nr_sequencia	= a.nr_seq_esp) alias1;
			
			exception
			when others then
				ds_observacao_w := null;
			end;
				
			select	max(coalesce(CASE WHEN coalesce(coalesce(cd_pessoa_fisica, CASE WHEN nm_paciente=ds_observacao_w THEN null  ELSE nm_paciente END )::text, '') = '' THEN  'L'  ELSE 'N' END ,'L'))
			into STRICT	ie_status_agenda_ww
			from	agenda_paciente
			where	nr_sequencia = nr_seq_agenda_w;
			end if;							

			if (ie_status_agenda_ww = 'L') then
				if (coalesce(nr_seq_dependente_p::text, '') = '') then
					update	agenda_paciente
					set	cd_pessoa_fisica	= cd_pessoa_fisica_p,
						cd_convenio		= cd_convenio_p,
						cd_categoria		= cd_categoria_p,
						cd_plano		= cd_plano_p,
						ie_forma_agendamento	= 7,
						ie_status_agenda	= 'N',
						ie_agenda_web		= 'S',
						nr_telefone		= obter_fone_pac_agenda(cd_pessoa_fisica_p),
						dt_nascimento_pac	= to_date(substr(obter_dados_pf(cd_pessoa_fisica_p,'DN'),1,10),'dd/mm/yyyy'),
						qt_idade_paciente	= obter_dados_pf(cd_pessoa_fisica_p,'I'),
						nm_usuario		= nm_usuario_p,
						dt_atualizacao		= clock_timestamp(),
						nm_usuario_acesso	 = NULL,
						nr_seq_proc_interno	= nr_seq_proc_interno_p,
						cd_procedimento		= cd_procedimento_w,
						ie_origem_proced	= ie_origem_proced_w,
						cd_medico_exec		= cd_medico_p,
						cd_empresa_ref	 	= cd_empresa_p
					where	nr_sequencia		= nr_seq_agenda_w;
				else
					update	agenda_paciente
					set	cd_pessoa_fisica	= coalesce(cd_pessoa_dependente_w,cd_pessoa_fisica),
						nm_paciente		= CASE WHEN cd_pessoa_dependente_w = NULL THEN nm_dependente_w  ELSE nm_paciente END ,
						cd_convenio		= cd_convenio_p,
						cd_categoria		= cd_categoria_p,
						cd_plano		= cd_plano_p,
						ie_forma_agendamento	= 7,
						ie_status_agenda	= 'N',
						ie_agenda_web		= 'S',
						nr_telefone		= obter_fone_pac_agenda(cd_pessoa_fisica_p),
						dt_nascimento_pac	= dt_nascimento_w,
						qt_idade_paciente	= qt_idade_pac_w,
						nm_usuario		= nm_usuario_p,
						dt_atualizacao		= clock_timestamp(),
						nm_usuario_acesso	 = NULL,
						nr_seq_proc_interno	= nr_seq_proc_interno_p,
						cd_procedimento		= cd_procedimento_w,
						ie_origem_proced	= ie_origem_proced_w,
						cd_medico_exec		= cd_medico_p,
						nr_matricula_ageweb	= cd_pessoa_fisica_p,
						cd_empresa_ref	 	= cd_empresa_p
					where	nr_sequencia		= nr_seq_agenda_w;
				end if;
			else
				--'Este horario nao encontra-se mais disponivel para agendamento, por gentileza selecione outro!.'
				ds_erro_p := upper(WHEB_MENSAGEM_PCK.get_texto(277666,null));
				goto final;
			end if;		
			
			update	ageweb_login
			set		cd_convenio		= cd_convenio_p,
					cd_categoria 	= cd_categoria_p,
					cd_plano		= cd_plano_p
			where	ds_login		= cd_pessoa_fisica_p;
			
			select	max(ds_titulo),
					max(ds_remetente),
					max(ds_mensagem)
			into STRICT	ds_titulo_w,
					ds_remetente_w,
					ds_mensagem_w
			from	ageweb_cadastro_email
			where	ie_tipo_email = 'C'
			and	((ie_tipo_agenda = 'E') or (ie_tipo_agenda = 'A'));
				
			select	max(b.ds_email),
					substr(max(obter_nome_pf(a.cd_pessoa_fisica)),1,255)
			into STRICT	ds_email_destino_w,
					nm_paciente_w
			from	pessoa_fisica a,
					compl_pessoa_fisica b
			where	a.cd_pessoa_fisica 	= b.cd_pessoa_fisica
			and		b.ie_tipo_complemento 	= 1
			and		a.cd_pessoa_fisica	= cd_pessoa_fisica_p;
			
			if (ds_titulo_w IS NOT NULL AND ds_titulo_w::text <> '') and (ds_remetente_w IS NOT NULL AND ds_remetente_w::text <> '') and (ds_mensagem_w IS NOT NULL AND ds_mensagem_w::text <> '') and (ds_email_destino_w IS NOT NULL AND ds_email_destino_w::text <> '') then
				
				nm_especialista_w	:= obter_nome_pf(cd_medico_p);
				
				select	max(ds_proc_exame)
				into STRICT	ds_proc_exame_w
				from	proc_interno
				where	nr_sequencia = nr_seq_proc_interno_p;
				
				ds_orientacao_w := coalesce(obter_orientacao_proc_agexame(cd_procedimento_w,ie_origem_proced_w,cd_convenio_p,nr_seq_proc_interno_p,null,null,nr_seq_agenda_w),Wheb_mensagem_pck.get_texto(307631) /*'Sem orientacao'*/
);
							
				if (((nm_paciente_w IS NOT NULL AND nm_paciente_w::text <> '')  and (position('@paciente' in ds_mensagem_w) > 0)) or
				    ((nm_dependente_w IS NOT NULL AND nm_dependente_w::text <> '') and (position('@paciente' in ds_mensagem_w) > 0))) then
					
					if (coalesce(nr_seq_dependente_p::text, '') = '') then
						ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@paciente', nm_paciente_w),1,4000);
					else
						ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@paciente', nm_dependente_w),1,4000);
					end if;
				else
					ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@paciente', ' '),1,4000);
				end if;
				
				if (hr_agenda_w IS NOT NULL AND hr_agenda_w::text <> '') and (position('@data' in ds_mensagem_w) > 0) then
					ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@data', hr_agenda_w),1,4000);			
				else
					ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@data', ' '),1,4000);			
				end if;
				
				if (hr_dia_w IS NOT NULL AND hr_dia_w::text <> '') and (position('@dia' in ds_mensagem_w) > 0)  then
					ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@dia', hr_dia_w),1,4000);
				else
					ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@dia', ' '),1,4000);			
				end if;
				
				if (hr_hora_w IS NOT NULL AND hr_hora_w::text <> '') and (position('@hora' in ds_mensagem_w) > 0)  then
					ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@hora', hr_hora_w),1,4000);
				else
					ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@hora', ' '),1,4000);			
				end if;
				
				if (ds_especialidade_w IS NOT NULL AND ds_especialidade_w::text <> '') and (position('@agendamento' in ds_mensagem_w) > 0)  then
					ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@agendamento', ds_especialidade_w),1,4000);
				else
					ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@agendamento', ' '),1,4000);			
				end if;
				
				if (nm_especialista_w IS NOT NULL AND nm_especialista_w::text <> '') and (position('@especialista' in ds_mensagem_w) > 0)  then
					ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@especialista', nm_especialista_w),1,4000);
				else
					ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@especialista', ' '),1,4000);			
				end if;
				
				if (ds_orientacao_w IS NOT NULL AND ds_orientacao_w::text <> '') and (position('@orientacao' in ds_mensagem_w) > 0)  then
					ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@orientacao', ds_orientacao_w),1,4000);
				else
					ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@orientacao', ' '),1,4000);			
				end if;	

				if (ds_nome_fantasia_estab_w IS NOT NULL AND ds_nome_fantasia_estab_w::text <> '') and (position('@estab' in ds_mensagem_w) > 0)  then
					ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@estab', ds_nome_fantasia_estab_w),1,4000);
				else
					ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@estab', ' '),1,4000);			
				end if;				
				
				if (nr_seq_agenda_w IS NOT NULL AND nr_seq_agenda_w::text <> '') and (position('@seq_agenda' in ds_mensagem_w) > 0) then
					ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@seq_agenda', nr_seq_agenda_w),1,4000);
				end if;
				
				CALL enviar_email(ds_titulo_w,  substr(ds_mensagem_w,1,4000), ds_remetente_w, ds_email_destino_w, 'Tasy', 'A');
			end if; 		
			
			ds_erro_p := upper(WHEB_MENSAGEM_PCK.get_texto(277667,null));
		
		end if;
		
	end if;
		<<final>>
			ds_erro_w	:= '';		
	exception
	when others then
		ds_erro_w	:= substr(sqlerrm,1,2000);
		ds_erro_w	:= substr(ds_erro_w||'-'||wheb_mensagem_pck.get_texto(799933)||'>'||cd_agenda_p||'-'||hr_agenda_p||'-'||cd_convenio_p||'-'||cd_categoria_p||'-'||cd_plano_p||'-'||cd_pessoa_fisica_p||'-'||cd_medico_p||'-'||
					  nr_seq_proc_interno_p||'-'||nr_seq_dependente_p||'-'||cd_empresa_p,1,4000);				
		insert into log_ageweb(dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, ds_log) values (clock_timestamp(),'ageWeb',clock_timestamp(),'ageWeb',ds_erro_w);
		
		ds_erro_p := Wheb_mensagem_pck.get_texto(307632); --'Ocorreu algum problema ao realizar seu agendamento! Favor entrar em contato com o hospital';
	end;

end if;

if (coalesce(ds_erro_p,'OK') = 'OK') then
	commit;	
else
	rollback;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageweb_atualiza_marcacao (cd_agenda_p bigint, hr_agenda_p text, cd_convenio_p bigint, cd_categoria_p text, cd_plano_p text, cd_pessoa_fisica_p text, nm_usuario_p text, cd_medico_p text, nr_seq_proc_interno_p bigint, nr_seq_dependente_p bigint, cd_empresa_p bigint, ds_erro_p INOUT text, ds_mensagem_p INOUT text) FROM PUBLIC;

