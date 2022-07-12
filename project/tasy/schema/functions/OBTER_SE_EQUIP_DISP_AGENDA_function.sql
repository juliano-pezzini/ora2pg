-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_equip_disp_agenda ( nr_seq_agenda_p bigint, lista_equip_p text, qt_tempo_p bigint, nr_seq_agenda_pos_p bigint) RETURNS varchar AS $body$
DECLARE


dt_inicial_w		timestamp;
dt_final_w		timestamp;
qt_equip_man_w		bigint;
qt_equipamento_w		bigint;
qt_equip_agenda_w	bigint;
nr_seq_agenda_w		bigint;
ds_equipamento_w		varchar(80);
ds_agenda_w		varchar(50);
dt_agenda_w		timestamp;
nm_paciente_w		varchar(60);
nm_medico_w		varchar(50);
ie_consiste_w		varchar(15);
--qt_novo_registro_w	number(5);
cd_classif_equip_w	bigint;
qt_tempo_esterilizacao_w	bigint;
nr_minuto_duracao_w	bigint;
qt_equip_agenda_exec_w	bigint;
ie_contador_w		bigint	:= 0;
lista_equip_w		varchar(400);
tam_lista_w		bigint;
ie_pos_virgula_w		smallint;
cd_equipamento_w		bigint;
ie_disponivel_w		varchar(1):='S';
qt_tempo_w 		bigint	:= null;

BEGIN

/*
nr_seq_agenda_pos_p - Para a consistência de horários disponíveis, não é para considerar um horário disponível de equipamento para a própria agenda posicionada.
Ex: 	Tenho um agendamento A dás 15:30 até às 17:00 com o equipamento.
	Tenho outro agendamento B dás 16:00 até às 17:30
	Se estou posicionado na agendamento B, o horário tem que ficar disponivel às 17:00 horas, mas sem este parâmetro,
	está considerando a agenda B com equipamento indisponível até às 17:30, pois está verificando a mesma na consistência.
*/
if (coalesce(qt_tempo_p,0) > 0) then
	qt_tempo_w	:=  qt_tempo_p;
end if;

lista_equip_w	:= lista_equip_p;

while(ie_disponivel_w = 'S') and
	((lista_equip_w IS NOT NULL AND lista_equip_w::text <> '') or (ie_contador_w > 200)) loop
	begin
	tam_lista_w		:= length(lista_equip_w);
	ie_pos_virgula_w	:= position(',' in lista_equip_w);

	if (ie_pos_virgula_w <> 0) then
		begin
		cd_equipamento_w	:= substr(lista_equip_w,1,(ie_pos_virgula_w - 1));
		lista_equip_w		:= substr(lista_equip_w,(ie_pos_virgula_w + 1),tam_lista_w);
		end;
	end if;

	select	max(hr_inicio)
	into STRICT	dt_inicial_w
	from	agenda_paciente
	where	nr_sequencia	= nr_seq_agenda_p;

	qt_equip_man_w	:= obter_qt_equip_manutencao(null, cd_equipamento_w,dt_inicial_w);

	select	coalesce(sum(coalesce(qt_compartilhamento,qt_equipamento)) - qt_equip_man_w, 1),
		coalesce(max(cd_classificacao),0)
	into STRICT	qt_equipamento_w,
		cd_classif_equip_w
	from	equipamento
	where	cd_equipamento	= cd_equipamento_w
	and	ie_situacao	= 'A';

	qt_tempo_esterilizacao_w	:= 0;
	/* Obter o tempo de esterilização da classificação do equipamento */

	if (cd_classif_equip_w <> 0) then
		select	coalesce(max(qt_tempo_esterelizacao),0)
		into STRICT	qt_tempo_esterilizacao_w
		from	classif_equipamento
		where	nr_sequencia = cd_classif_equip_w;
	end if;

	select	hr_inicio,
		CASE WHEN ie_status_agenda='E' THEN  (hr_inicio + (qt_tempo_esterilizacao_w / 1440) - (1/86400))  ELSE (hr_inicio + ((coalesce(qt_tempo_w,nr_minuto_duracao) + coalesce(qt_tempo_esterilizacao_w,0)) / 1440) - (1/86400)) END
	into STRICT	dt_inicial_w,
		dt_final_w
	from	agenda_paciente
	where	nr_sequencia	= nr_seq_agenda_p;

	/* Obter qtde de agendamentos que foram executadas no periodo - neste só é contado o tempo de esterilização e não considera mais o tempo de duração pois o mesmo já foi realizado */

	select	count(*)
	into STRICT	qt_equip_agenda_exec_w
	from	agenda_pac_equip a,
		agenda_paciente b
	where	b.nr_sequencia	= a.nr_seq_agenda
	and	((hr_inicio between dt_inicial_w and dt_final_w) or
		(hr_inicio + (qt_tempo_esterilizacao_w / 1440) - (1/86400) between dt_inicial_w and dt_final_w) or
		((hr_inicio < dt_inicial_w) and (hr_inicio + (qt_tempo_esterilizacao_w / 1440) - (1/86400) > dt_final_w)))
	and	a.cd_equipamento = cd_equipamento_w
	and	ie_status_agenda = 'E'
	and	ie_origem_inf = 'I'
	and	b.nr_sequencia <> nr_seq_agenda_pos_p;

	/* Obter qtde de agendamentos que não foram executados e/ou cancelados no periodo */

	select	count(*)
	into STRICT	qt_equip_agenda_w
	from	agenda_pac_equip a,
		agenda_paciente b
	where	b.nr_sequencia	= a.nr_seq_agenda
	and	((hr_inicio between dt_inicial_w and dt_final_w) or
		(hr_inicio + ((nr_minuto_duracao + coalesce(qt_tempo_esterilizacao_w,0)) / 1440) - (1/86400) between dt_inicial_w and dt_final_w) or
		((hr_inicio < dt_inicial_w) and (hr_inicio + ((nr_minuto_duracao + coalesce(qt_tempo_esterilizacao_w,0)) / 1440) - (1/86400) > dt_final_w)))
	and	a.cd_equipamento = cd_equipamento_w
	and	ie_status_agenda not in ('C','E')
	and	ie_origem_inf = 'I'
	and	b.nr_sequencia <> nr_seq_agenda_pos_p;

	qt_equip_agenda_w	:= qt_equip_agenda_exec_w + qt_equip_agenda_w+1;

	if (qt_equipamento_w < qt_equip_agenda_w) then
		ie_disponivel_w := 'N';
	end if;
	ie_contador_w	:= ie_contador_w + 1;
	end;
end loop;

return	ie_disponivel_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_equip_disp_agenda ( nr_seq_agenda_p bigint, lista_equip_p text, qt_tempo_p bigint, nr_seq_agenda_pos_p bigint) FROM PUBLIC;

