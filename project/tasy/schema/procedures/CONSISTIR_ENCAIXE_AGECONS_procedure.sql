-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_encaixe_agecons ( cd_agenda_destino_p bigint, nr_seq_origem_p bigint, dt_encaixe_p timestamp, ie_encaixe_transf_p text, nm_usuario_p text, cd_estabelecimento_p bigint, hr_encaixe_p timestamp, cd_convenio_p bigint, cd_plano_convenio_p text, cd_categoria_p text, cd_pessoa_fisica_p text, ds_aviso_p INOUT text, ds_erro_p INOUT text) AS $body$
DECLARE


qt_encaixe_perm_w		bigint;
qt_encaixe_perm_conv_w	bigint;
qt_encaixe_dia_w		bigint;
qt_permitida_regra_w		bigint;
qt_encaixe_existe_w		bigint;
ie_encaixar_limite_w		varchar(1);
ie_gerar_encaixe_hor_w		varchar(1);
qt_horario_w			integer;
dt_encaixe_w			timestamp;
ie_permite_pac_hor_w	varchar(1);
qt_agenda_pac_dia_w	bigint;
hr_inicial_regra_w	timestamp;
hr_final_regra_w	timestamp;
ie_dia_semana_w		smallint;
dt_agenda_fut_w		timestamp;
dt_agenda_ant_w		timestamp;
nr_min_perm_encaixe_w	bigint;
qt_min_w		bigint;
cd_convenio_regra_w	convenio.cd_convenio%type;
ie_consiste_tempo_minimo_w	varchar(1);
ds_erro_w varchar(4000);
ie_permite_w varchar(1);


BEGIN

ie_permite_pac_hor_w := obter_param_usuario(821, 48, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_permite_pac_hor_w);
ie_consiste_tempo_minimo_w := obter_param_usuario(821, 487, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_consiste_tempo_minimo_w);
if (coalesce(hr_encaixe_p::text, '') = '')then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(201339);
end if;



if (cd_agenda_destino_p IS NOT NULL AND cd_agenda_destino_p::text <> '') and (dt_encaixe_p IS NOT NULL AND dt_encaixe_p::text <> '') then
	begin

	dt_encaixe_w := pkg_date_utils.get_DateTime(dt_encaixe_p, hr_encaixe_p);
	

    if (ie_consiste_tempo_minimo_w = 'S') then
        CALL Consistir_quimio_dur_agecons(dt_encaixe_w, cd_pessoa_fisica_p, nm_usuario_p, cd_estabelecimento_p);
    end if;

	select	coalesce(max(nr_min_perm_encaixe),0)
	into STRICT	nr_min_perm_encaixe_w
	from	agenda
	where	cd_agenda = cd_agenda_destino_p;
	
	if (nr_min_perm_encaixe_w > 0) then
		select	min(dt_agenda)
		into STRICT	dt_agenda_fut_w
		from	agenda_consulta
		where	cd_agenda = cd_agenda_destino_p
		and	dt_agenda > dt_encaixe_w
		and	trunc(dt_agenda) = trunc(dt_encaixe_p)
		and	ie_status_agenda not in ('C','B','II');
		
		select	max(dt_agenda)
		into STRICT	dt_agenda_ant_w
		from	agenda_consulta
		where	cd_agenda = cd_agenda_destino_p
		and	dt_agenda < dt_encaixe_w
		and	trunc(dt_agenda) = trunc(dt_encaixe_p)
		and	ie_status_agenda not in ('C','B','II');

		if (dt_agenda_fut_w IS NOT NULL AND dt_agenda_fut_w::text <> '') then
			
			qt_min_w := (dt_agenda_fut_w - dt_encaixe_w) * 1440;
				
			if (qt_min_w < nr_min_perm_encaixe_w) then				
				CALL wheb_mensagem_pck.exibir_mensagem_abort(263018);
			end if;
		end if;
		
		if (dt_agenda_ant_w IS NOT NULL AND dt_agenda_ant_w::text <> '') then
			
			qt_min_w := (dt_encaixe_w - dt_agenda_ant_w) * 1440;
		
			if (qt_min_w < nr_min_perm_encaixe_w) then				
				CALL wheb_mensagem_pck.exibir_mensagem_abort(263021);
			end if;
		end if;
	end if;

	if (ie_permite_pac_hor_w <> 'S') then
		select 	count(nr_sequencia)
		into STRICT	qt_agenda_pac_dia_w
		from	agenda_consulta
		where	trunc(dt_agenda) = trunc(dt_encaixe_p)
		and	cd_pessoa_fisica = cd_pessoa_fisica_p
		and	cd_agenda = cd_agenda_destino_p
		and	ie_status_agenda <> 'C';

		if (qt_agenda_pac_dia_w > 0) then
			ds_aviso_p := Wheb_mensagem_pck.get_texto(306511); -- 'J? existe um agendamento para este paciente nesta agenda!';
		end if;
	end if;

	if (cd_convenio_p IS NOT NULL AND cd_convenio_p::text <> '') then
		CALL consiste_regra_agecons_conv(cd_convenio_p, cd_categoria_p,cd_agenda_destino_p,null,cd_plano_convenio_p,cd_pessoa_fisica_p,dt_encaixe_w,cd_estabelecimento_p, null, null);
	end if;
	
	select	coalesce(obter_qt_encaixe_perm_agenda(cd_agenda_destino_p),0),
		coalesce(obter_qt_encaixe_agenda_dia(cd_agenda_destino_p, dt_encaixe_p),0),
		coalesce(max(Obter_Valor_Param_Usuario(821,51, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p)),'N'),
		coalesce(max(Obter_Valor_Param_Usuario(821,59, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p)),'N')
	into STRICT	qt_encaixe_perm_w, 
		qt_encaixe_dia_w,  
		ie_encaixar_limite_w,
		ie_gerar_encaixe_hor_w
	;

	select	count(*)
	into STRICT	qt_horario_w
	from	agenda_consulta
	where	cd_agenda = cd_agenda_destino_p
	and	trunc(dt_agenda,'dd') = trunc(dt_encaixe_w,'dd')
	and	dt_agenda = dt_encaixe_w
	and	ie_status_agenda <> 'C';

	if (qt_horario_w > 0) then

		if (ie_gerar_encaixe_hor_w	 = 'S') then
			ds_erro_p	:= WHEB_MENSAGEM_PCK.get_texto(279675,null);
		end if;

		if (ie_gerar_encaixe_hor_w	 = 'N') then		
			CALL wheb_mensagem_pck.exibir_mensagem_abort(263022);			
		end if;

	end if;
	
	if (qt_encaixe_perm_w > 0) and (qt_encaixe_dia_w > 0) and (qt_encaixe_perm_w <= qt_encaixe_dia_w) then
		begin
		if (ie_encaixar_limite_w = 'S') then
			ds_erro_p	:= substr(WHEB_MENSAGEM_PCK.get_texto(279676,null),1,255);
		else
			CALL wheb_mensagem_pck.exibir_mensagem_abort(263023);
		end if;
		end;
	elsif (qt_encaixe_perm_w = 0) then 		

		SELECT * FROM validar_regra_encaixe_agenda(cd_tipo_agenda_p => 3, dt_encaixe_p => dt_encaixe_p, hr_encaixe_p => null, dt_hr_encaixe_p => dt_encaixe_w, cd_agenda_p => cd_agenda_destino_p, cd_convenio_p => cd_convenio_p, ie_permite_p => ie_permite_w, ds_erro_p => ds_erro_w) INTO STRICT ie_permite_p => ie_permite_w, ds_erro_p => ds_erro_w;

    if ie_permite_w = 'N' then
    
      if (ie_encaixar_limite_w = 'S') then
        ds_erro_p := ds_erro_w;
      else
        CALL wheb_mensagem_pck.exibir_mensagem_abort(263024);
      end if;

    end if;
	end if;
	
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_encaixe_agecons ( cd_agenda_destino_p bigint, nr_seq_origem_p bigint, dt_encaixe_p timestamp, ie_encaixe_transf_p text, nm_usuario_p text, cd_estabelecimento_p bigint, hr_encaixe_p timestamp, cd_convenio_p bigint, cd_plano_convenio_p text, cd_categoria_p text, cd_pessoa_fisica_p text, ds_aviso_p INOUT text, ds_erro_p INOUT text) FROM PUBLIC;

