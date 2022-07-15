-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_proc_conv_forma (( nr_seq_regra_p bigint, ie_considera_proc_int_qtd_p text, nr_seq_proc_int_qtd_p text, cd_agenda_regra_p bigint, cd_convenio_regra_p bigint, ie_convenio_qtd_p text, cd_categoria_regra_p text, cd_plano_convenio_regra_p text, ie_consiste_qtd_hora_p text, hr_inicio_p timestamp, hr_fim_p timestamp, cd_medico_regra_p text, ie_medico_p text, nr_sequencia_p bigint, ie_estrutra_qtd_p text, cd_area_regra_p bigint, cd_especialidade_regra_p bigint, cd_grupo_regra_p bigint, nr_seq_proc_interno_p bigint, cd_procedimento_global_p bigint, ie_origem_proced_global_p text, cd_proced_regra_p bigint, ie_origem_proced_p text, ie_origem_proced_regra_p text, dt_referencia_p timestamp, cd_procedimento_p bigint, cd_agenda_p bigint, dt_referencia2_p timestamp, ie_agenda_p out text, ds_mensagem_padrao_p out text, nr_seq_topografia_p bigint default null) is qt_regra_w agenda_regra_quantidade.qt_regra%type) AS $body$
DECLARE

	ds_comando_w				varchar(2000);
	ds_ref_inicial_w			varchar(25);
	ds_ref_final_w				varchar(25);
	
	
BEGIN
	
	ds_comando_w :=	' select	count(1) ' ||
	' from	agenda_paciente a ';
	
	if (ie_pac_proc_p = 'S') then
		ds_comando_w := ds_comando_w || chr(13) || chr(10) ||
		'	, agenda_paciente_proc b';
	end if;
	
	ds_comando_w := ds_comando_w || chr(13) || chr(10) || ' where 1 = 1 ';
	
	if (ie_pac_proc_p = 'S') then
		ds_comando_w := ds_comando_w || chr(13) || chr(10) ||
		' and	a.nr_sequencia		= b.nr_sequencia';
	end if;
	
	if (cd_agenda_regra_p IS NOT NULL AND cd_agenda_regra_p::text <> '') then
		ds_comando_w := ds_comando_w || chr(13) || chr(10) ||
			' and a.cd_agenda		= ' || cd_agenda_p;
	end if;
		
	if (coalesce(cd_convenio_regra_p,0) > 0) and (ie_convenio_qtd_p = 'S') then
		ds_comando_w := ds_comando_w || chr(13) || chr(10) ||
			' and a.cd_convenio		= ' || cd_convenio_regra_p;
	end if;
	
	if (cd_categoria_regra_p IS NOT NULL AND cd_categoria_regra_p::text <> '') then
		ds_comando_w := ds_comando_w || chr(13) || chr(10) ||
			' and a.cd_categoria		= ' || cd_categoria_regra_p;
	end if;
	
	if (cd_plano_convenio_regra_p IS NOT NULL AND cd_plano_convenio_regra_p::text <> '') then
		ds_comando_w := ds_comando_w || chr(13) || chr(10) ||
			' and a.cd_plano		= ' || cd_plano_convenio_regra_p;
	end if;
		
	if (ie_forma_consistencia_w = 'M') then
		ds_comando_w := ds_comando_w || chr(13) || chr(10) ||
			' and a.dt_agenda between ' ||CHR(39) || ESTABLISHMENT_TIMEZONE_UTILS.startOfMonth(dt_referencia_p)|| CHR(39)|| ' and ' || CHR(39)|| ESTABLISHMENT_TIMEZONE_UTILS.endOfMonth(dt_referencia_p) || CHR(39);
	elsif (ie_forma_consistencia_w = 'D') then
		ds_comando_w := ds_comando_w || chr(13) || chr(10) ||
			' and a.dt_agenda between '||CHR(39) ||ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_referencia2_p)|| CHR(39)|| ' and ' ||CHR(39) ||ESTABLISHMENT_TIMEZONE_UTILS.endOfDay(dt_referencia2_p)|| CHR(39);
	elsif (ie_forma_consistencia_w = 'A') then
		ds_comando_w := ds_comando_w || chr(13) || chr(10) ||
			' and a.dt_agenda between '||CHR(39) ||ESTABLISHMENT_TIMEZONE_UTILS.startOfYear(dt_referencia_p)|| CHR(39)|| ' and ' ||CHR(39) ||ESTABLISHMENT_TIMEZONE_UTILS.endOfYear(dt_referencia_p)|| CHR(39);
	elsif (ie_forma_consistencia_w = 'S') then
		select	obter_inicio_fim_semana(dt_referencia2_p,'I'),
			obter_inicio_fim_semana(dt_referencia2_p,'F')||'23:59:59'
		into STRICT	ds_ref_inicial_w,
			ds_ref_final_w
		;

		ds_comando_w := ds_comando_w || chr(13) || chr(10) ||
			' and a.dt_agenda between to_date('''||ds_ref_inicial_w||''' ,''dd/mm/yyyy'') and to_date('''||ds_ref_final_w||''',''dd/mm/yyyy hh24:mi:ss'')';
	end if;

	ds_comando_w := ds_comando_w || chr(13) || chr(10) ||
		' and a.ie_status_agenda not in (''C'',''L'',''B'') ';
	
	ds_comando_w := ds_comando_w || chr(13) || chr(10) ||
		' and a.nm_paciente is not null ';
		
	if (ie_consiste_qtd_hora_p = 'S') then
		ds_comando_w := ds_comando_w || chr(13) || chr(10) ||
			' and a.hr_inicio between to_date(to_char(a.dt_agenda, ''dd/mm/yyyy'') || '' '' ||'||   CHR(39)||coalesce(to_char(hr_inicio_p,'hh24:mi:ss'),'00:00:00')|| CHR(39)||',''dd/mm/yyyy hh24:mi:ss'') '|| chr(13) || chr(10) ||
				' and 	to_date(to_char(a.dt_agenda, ''dd/mm/yyyy'') || '' '' ||'||  CHR(39)|| coalesce(to_char(hr_fim_p,'hh24:mi:ss'), '00:00:00')|| CHR(39)||',''dd/mm/yyyy hh24:mi:ss'') ';
	end if;
		
	if (ie_medico_p = 'E') and (cd_medico_regra_p IS NOT NULL AND cd_medico_regra_p::text <> '') then
		ds_comando_w := ds_comando_w || chr(13) || chr(10) ||
			' and a.cd_medico_exec = '|| cd_medico_regra_p;
	end if;

	if (ie_medico_p = 'R') and (cd_medico_regra_p IS NOT NULL AND cd_medico_regra_p::text <> '') then
		ds_comando_w := ds_comando_w || chr(13) || chr(10) ||
			' and a.cd_medico = '|| cd_medico_regra_p;
	end if;
	
	if (ie_considera_proc_int_qtd_p = 'S') and (nr_seq_proc_int_qtd_p IS NOT NULL AND nr_seq_proc_int_qtd_p::text <> '') then
		if (nr_seq_proc_int_qtd_p IS NOT NULL AND nr_seq_proc_int_qtd_p::text <> '') then
			if (ie_pac_proc_p = 'S') then
				ds_comando_w := ds_comando_w || chr(13) || chr(10) || 'and	b.nr_seq_proc_interno = '||nr_seq_proc_int_qtd_p;
			else
				ds_comando_w := ds_comando_w || chr(13) || chr(10) || 'and	a.nr_seq_proc_interno = '||nr_seq_proc_int_qtd_p;
			end if;
		end if;
	elsif (ie_estrutra_qtd_p = 'S') then
		if (ie_pac_proc_p = 'S') then
			if (cd_area_regra_p IS NOT NULL AND cd_area_regra_p::text <> '') then
				ds_comando_w := ds_comando_w || chr(13) || chr(10) || ' and	obter_area_procedimento(b.cd_procedimento,b.ie_origem_proced) = '||cd_area_regra_p;
			end if;
			if (cd_especialidade_regra_p IS NOT NULL AND cd_especialidade_regra_p::text <> '') then
				ds_comando_w := ds_comando_w || chr(13) || chr(10) || ' and	Obter_Especialidade_Proced(b.cd_procedimento,b.ie_origem_proced) = '||cd_especialidade_regra_p;
			end if;
			if (cd_grupo_regra_p IS NOT NULL AND cd_grupo_regra_p::text <> '') then
				ds_comando_w := ds_comando_w || chr(13) || chr(10) || ' and	obter_grupo_procedimento(b.cd_procedimento,b.ie_origem_proced,''C'') ='||cd_grupo_regra_p;
			end if;
		else
			if (cd_area_regra_p IS NOT NULL AND cd_area_regra_p::text <> '') then
				ds_comando_w := ds_comando_w || chr(13) || chr(10) || ' and	obter_area_procedimento(a.cd_procedimento,a.ie_origem_proced) = '||cd_area_regra_p;
			end if;
			if (cd_especialidade_regra_p IS NOT NULL AND cd_especialidade_regra_p::text <> '') then
				ds_comando_w := ds_comando_w || chr(13) || chr(10) || ' and	Obter_Especialidade_Proced(a.cd_procedimento,a.ie_origem_proced) = '||cd_especialidade_regra_p;
			end if;
			if (cd_grupo_regra_p IS NOT NULL AND cd_grupo_regra_p::text <> '') then
				ds_comando_w := ds_comando_w || chr(13) || chr(10) || ' and	obter_grupo_procedimento(a.cd_procedimento,a.ie_origem_proced,''C'') ='||cd_grupo_regra_p;
			end if;
		end if;
	else
		if (nr_seq_proc_interno_p IS NOT NULL AND nr_seq_proc_interno_p::text <> '') and (ie_pac_proc_p = 'N') then
			ds_comando_w := ds_comando_w || chr(13) || chr(10) || ' and	(a.nr_seq_proc_interno = '||nr_seq_proc_interno_p||') ';
		end if;
		if (cd_proced_regra_p IS NOT NULL AND cd_proced_regra_p::text <> '') and ((cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') or (cd_procedimento_global_p IS NOT NULL AND cd_procedimento_global_p::text <> '')) then
			if (ie_pac_proc_p = 'S') then
				ds_comando_w := ds_comando_w || chr(13) || chr(10) || ' and	((b.cd_procedimento = '||cd_procedimento_p||') or (b.cd_procedimento = '||cd_procedimento_global_p||')) ';
			else
				ds_comando_w := ds_comando_w || chr(13) || chr(10) || ' and	((a.cd_procedimento = '||cd_procedimento_p||') or (a.cd_procedimento = '||cd_procedimento_global_p||')) ';
			end if;
		end if;
		if (ie_origem_proced_regra_p IS NOT NULL AND ie_origem_proced_regra_p::text <> '') and ((ie_origem_proced_p IS NOT NULL AND ie_origem_proced_p::text <> '') or (ie_origem_proced_global_p IS NOT NULL AND ie_origem_proced_global_p::text <> '')) then
			if (ie_pac_proc_p = 'S') then
				ds_comando_w := ds_comando_w || chr(13) || chr(10) || ' and	((b.ie_origem_proced = '||ie_origem_proced_p||') or (b.ie_origem_proced = '||ie_origem_proced_global_p||')) ';
			else
				ds_comando_w := ds_comando_w || chr(13) || chr(10) || ' and	((a.ie_origem_proced = '||ie_origem_proced_p||') or (a.ie_origem_proced = '||ie_origem_proced_global_p||')) ';
			end if;
		end if;
	end if;
	
	if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
		ds_comando_w := ds_comando_w || chr(13) || chr(10) ||
			' and	a.nr_sequencia <> '|| nr_sequencia_p;
	end if;
	
	if (nr_seq_topografia_p IS NOT NULL AND nr_seq_topografia_p::text <> '') then
		if (ie_pac_proc_p = 'S') then
			ds_comando_w := ds_comando_w || chr(13) || chr(10) ||
				' and b.cd_topografia_proced = ' || nr_seq_topografia_p;
		else
			ds_comando_w := ds_comando_w || chr(13) || chr(10) ||
				' and a.cd_topografia_proced = ' || nr_seq_topografia_p;
		end if;
	end if;
	
	begin
		EXECUTE ds_comando_w into STRICT qt_agenda_w;
	exception
	when others then
		CALL gravar_log_mov(417887, 'Erro - ' || ds_comando_w, 'TASY');
	end;
	
	return;

	end;
		
begin

/* Faz a mesma verificacao da procedure consistir_proc_agenda, em relacao a ie_forma_consistencia */

open c01;
loop
fetch c01 into
	qt_regra_w,
	ie_forma_consistencia_w,
	ds_mensagem_padrao_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
		if (ie_mesmo_dia_w = ie_forma_consistencia_w) then
			goto valida_qtd;
		else
			ie_mesmo_dia_w := ie_forma_consistencia_w;
		end if;

		qt_agenda_w := obter_valor_agenda_regra_qtd(ie_forma_consistencia_w, 'N');

		if (ie_consiste_qtd_hora_p	= 'S') then
			qt_agenda_adic_w := obter_valor_agenda_regra_qtd(ie_forma_consistencia_w, 'S');

			qt_agenda_w	:= qt_agenda_w + qt_agenda_adic_w;
		end if;

		<<valida_qtd>>
		/*Se alguma regra ? ultrapassada ou  alcan?ou seu limite gera a mensagem e finaliza a procedure retornando a mensagem gerada   */

		if (qt_agenda_w >= qt_regra_w) then
			ie_agenda_p	:= 'Q';
			if (ds_mensagem_padrao_w IS NOT NULL AND ds_mensagem_padrao_w::text <> '') then
				ds_mensagem_padrao_p := ds_mensagem_padrao_w;
			end if;
			EXIT;
		end if;
	end;
end loop;
close c01;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_proc_conv_forma (( nr_seq_regra_p bigint, ie_considera_proc_int_qtd_p text, nr_seq_proc_int_qtd_p text, cd_agenda_regra_p bigint, cd_convenio_regra_p bigint, ie_convenio_qtd_p text, cd_categoria_regra_p text, cd_plano_convenio_regra_p text, ie_consiste_qtd_hora_p text, hr_inicio_p timestamp, hr_fim_p timestamp, cd_medico_regra_p text, ie_medico_p text, nr_sequencia_p bigint, ie_estrutra_qtd_p text, cd_area_regra_p bigint, cd_especialidade_regra_p bigint, cd_grupo_regra_p bigint, nr_seq_proc_interno_p bigint, cd_procedimento_global_p bigint, ie_origem_proced_global_p text, cd_proced_regra_p bigint, ie_origem_proced_p text, ie_origem_proced_regra_p text, dt_referencia_p timestamp, cd_procedimento_p bigint, cd_agenda_p bigint, dt_referencia2_p timestamp, ie_agenda_p out text, ds_mensagem_padrao_p out text, nr_seq_topografia_p bigint default null) is qt_regra_w agenda_regra_quantidade.qt_regra%type) FROM PUBLIC;

