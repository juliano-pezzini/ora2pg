-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_obter_se_classif_disp ( nr_seq_agenda_p bigint, nr_seq_classif_equip_p bigint, ds_erro_p INOUT text, nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_agenda_ant_p bigint, ie_novo_registro_p text, dt_inicial_p timestamp, nr_minuto_duracao_p bigint) AS $body$
DECLARE



dt_inicial_w		timestamp;
dt_final_w		timestamp;
nr_seq_agenda_w		    agenda_paciente.nr_sequencia%type;
ds_classif_equi_w		varchar(80);
ds_agenda_w		varchar(50);
dt_agenda_w		timestamp;
nm_paciente_w		varchar(60);
qt_equipamento_w		bigint;
qt_equip_agenda_w	bigint;
nm_medico_w		varchar(50);
ie_consiste_w		varchar(15);
qt_tempo_esterilizacao_w	bigint	:= 0;
qt_equip_man_w		bigint;
qt_tot_equip_w		bigint;
qt_novo_registro_w		integer;
ds_mensagem_w		varchar(255);
nr_minuto_duracao_w	bigint;

qt_equip_agenda_exec_w	bigint;


BEGIN

ie_consiste_w := Obter_Param_Usuario(871, 81, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_consiste_w);

qt_novo_registro_w	:= 0;
if (ie_novo_registro_p = 'S') then
	qt_novo_registro_w := 1;
end if;

select	coalesce(max(qt_tempo_esterelizacao),0)
into STRICT	qt_tempo_esterilizacao_w
from	classif_equipamento
where	nr_sequencia = nr_seq_classif_equip_p;

dt_inicial_w	:= dt_inicial_p;
dt_final_w	:= (dt_inicial_w + ((nr_minuto_duracao_p + coalesce(qt_tempo_esterilizacao_w,0)) / 1440) - (1/86400));

/*select	hr_inicio,
	decode(ie_status_agenda, 'E', (hr_inicio + (qt_tempo_esterilizacao_w / 1440) - (1/86400)), (hr_inicio + ((nr_minuto_duracao + nvl(qt_tempo_esterilizacao_w,0)) / 1440) - (1/86400)))
into	dt_inicial_w,
	dt_final_w
from	agenda_paciente
where	nr_sequencia	= nr_seq_agenda_p;*/
qt_equip_man_w	:= obter_qt_equip_manutencao(nr_seq_classif_equip_p, null);

if (qt_equip_man_w > 0) then
	ds_mensagem_w	:= WHEB_MENSAGEM_PCK.get_texto(279068,'NR_SEQ_CLASSIF_EQUIP='||obter_ds_equip_manutencao(nr_seq_classif_equip_p, null,'D')||';NR_SEQ_CLASSIF_EQUIP='||obter_ds_equip_manutencao(nr_seq_classif_equip_p, null,'DI')||';NR_SEQ_CLASSIF_EQUIP='||obter_ds_equip_manutencao(nr_seq_classif_equip_p, null,'DF'));
end if;
				
select	coalesce(sum(qt_equipamento) - qt_equip_man_w, 0),
	count(*)
into STRICT	qt_equipamento_w,
	qt_tot_equip_w
from	equipamento
where	cd_classificacao	= nr_seq_classif_equip_p
and	ie_situacao		= 'A';

/* Obter qtde de agendamentos que foram executadas no periodo - neste so eh contado o tempo de esterilizacao e nao considera mais o tempo de duracao pois o mesmo ja foi realizado */

select	count(*)
into STRICT	qt_equip_agenda_exec_w
from	agenda_pac_equip a,
	agenda_paciente b
where	b.nr_sequencia	= a.nr_seq_agenda	
and	((hr_inicio between dt_inicial_w and dt_final_w) or
	(hr_inicio + (qt_tempo_esterilizacao_w / 1440) - (1/86400) between dt_inicial_w and dt_final_w) or
	((hr_inicio < dt_inicial_w) and (hr_inicio + (qt_tempo_esterilizacao_w / 1440) - (1/86400) > dt_final_w)))
and	a.nr_seq_classif_equip  = nr_seq_classif_equip_p
and	b.nr_sequencia <> coalesce(nr_seq_agenda_ant_p,0)
and	ie_status_agenda = 'E'
and	ie_origem_inf = 'I';

/* Obter qtde de agendamentos que nao foram executados e/ou cancelados no periodo */

select	count(*)
into STRICT	qt_equip_agenda_w
from	agenda_pac_equip a,
	agenda_paciente b
where	b.nr_sequencia	= a.nr_seq_agenda	
and	((hr_inicio between dt_inicial_w and dt_final_w) or
	(hr_inicio + ((nr_minuto_duracao + coalesce(qt_tempo_esterilizacao_w,0)) / 1440) - (1/86400) between dt_inicial_w and dt_final_w) or
	((hr_inicio < dt_inicial_w) and (hr_inicio + ((nr_minuto_duracao + coalesce(qt_tempo_esterilizacao_w,0)) / 1440) - (1/86400) > dt_final_w)))
and	a.nr_seq_classif_equip  = nr_seq_classif_equip_p
and	ie_status_agenda not in ('C','E')
and	b.nr_sequencia <> coalesce(nr_seq_agenda_ant_p,0)
and	ie_origem_inf = 'I';

qt_equip_agenda_w	:= qt_equip_agenda_exec_w + qt_equip_agenda_w + qt_novo_registro_w;

if (qt_equipamento_w < qt_equip_agenda_w) then

	select	max(nr_seq_agenda)
	into STRICT	nr_seq_agenda_w
	from	(SELECT	coalesce(max(b.nr_sequencia),0) nr_seq_agenda
		from	agenda_pac_equip a,
			agenda_paciente b
		where	b.nr_sequencia	= a.nr_seq_agenda	
		and	((hr_inicio between dt_inicial_w and dt_final_w) or
			(hr_inicio + (qt_tempo_esterilizacao_w / 1440) - (1/86400) between dt_inicial_w and dt_final_w) or
			((hr_inicio < dt_inicial_w) and (hr_inicio + (qt_tempo_esterilizacao_w / 1440) - (1/86400) > dt_final_w)))
		and	a.nr_seq_classif_equip  = nr_seq_classif_equip_p
		and	ie_status_agenda = 'E'
		and	b.nr_sequencia <> coalesce(nr_seq_agenda_ant_p,0)
		and	ie_origem_inf = 'I'		
		
union
		
		SELECT	coalesce(max(b.nr_sequencia),0)
		from	agenda_pac_equip a,
			agenda_paciente b
		where	b.nr_sequencia	= a.nr_seq_agenda	
		and	((hr_inicio between dt_inicial_w and dt_final_w) or  
			(hr_inicio + ((nr_minuto_duracao + coalesce(qt_tempo_esterilizacao_w,0)) / 1440) - (1/86400) between dt_inicial_w and dt_final_w) or
			((hr_inicio < dt_inicial_w) and (hr_inicio + ((nr_minuto_duracao + coalesce(qt_tempo_esterilizacao_w,0)) / 1440) - (1/86400) > dt_final_w)))
		and	a.nr_seq_classif_equip  = nr_seq_classif_equip_p
		and	b.nr_sequencia <> coalesce(nr_seq_agenda_ant_p,0)
		and	ie_status_agenda not in ('C','E')
		and	ie_origem_inf = 'I') alias33;	
	
	if (nr_seq_agenda_w > 0) then
		select	substr(obter_desc_classif_equip(nr_seq_classif_equip_p),1,60),
			hr_inicio,
			substr(obter_nome_agenda(cd_agenda),1,50),
			nm_paciente,
			substr(obter_nome_pf(cd_medico),1,50),
			nr_minuto_duracao
		into STRICT	ds_classif_equi_w,
			dt_agenda_w,
			ds_agenda_w,
			nm_paciente_w,
			nm_medico_w,
			nr_minuto_duracao_w
		from	agenda_paciente
		where	nr_sequencia	= nr_seq_agenda_w;		
		
		if (qt_equip_man_w >= qt_tot_equip_w) then
			ds_erro_p := WHEB_MENSAGEM_PCK.get_texto(279053,'DS_CLASSIF_EQUI='||ds_classif_equi_w||';DS_MENSAGEM='||ds_mensagem_w);
		else
			ds_erro_p := WHEB_MENSAGEM_PCK.get_texto(279055,'DS_CLASSIF_EQUI='||ds_classif_equi_w||';DT_AGENDA='||to_char(dt_agenda_w,'dd/mm/yyyy hh24:mi')||';DS_AGENDA='||ds_agenda_w||';QT_NR_TEMPO='||to_char(qt_tempo_esterilizacao_w + nr_minuto_duracao_w));
		end if;
	elsif (qt_equip_man_w >= qt_tot_equip_w) and (ie_novo_registro_p = 'S') then

		ds_erro_p := WHEB_MENSAGEM_PCK.get_texto(279053,'DS_CLASSIF_EQUI='||ds_classif_equi_w||';DS_MENSAGEM='||ds_mensagem_w);
				
	elsif (qt_equipamento_w = 0) then
	
		ds_erro_p := WHEB_MENSAGEM_PCK.get_texto(279056,'DS_CLASSIF_EQUI='||ds_classif_equi_w);
				
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_obter_se_classif_disp ( nr_seq_agenda_p bigint, nr_seq_classif_equip_p bigint, ds_erro_p INOUT text, nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_agenda_ant_p bigint, ie_novo_registro_p text, dt_inicial_p timestamp, nr_minuto_duracao_p bigint) FROM PUBLIC;

