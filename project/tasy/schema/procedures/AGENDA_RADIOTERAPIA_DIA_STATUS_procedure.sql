-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE agenda_radioterapia_dia_status ( cd_estabelecimento_p bigint, nr_seq_equipamento_p bigint, dt_Inicial_p timestamp, dt_final_p timestamp, nm_usuario_p text, ie_Status_p INOUT text) AS $body$
DECLARE



ie_Status_w			varchar(4000);
ie_Status_dia_w			varchar(10);
dt_atual_w			timestamp;
ie_dia_semana_w			varchar(10);
qt_horario_w			bigint;
qt_horario_livre_w		bigint;
qt_horario_cancelado_w		bigint;
ie_gerar_hor_livre_w		varchar(1);
ie_gerar_agenda_equip_w		varchar(1);


BEGIN


if	((dt_final_p - dt_inicial_p) > 255) then
	-- O Numero de dias é superior a 255
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(263467);
end if;

ie_status_w	:= '';
dt_atual_w	:= trunc(dt_inicial_p, 'dd');


while(dt_atual_w 	<= trunc(dt_final_p,'dd')) loop
	begin

	select	CASE WHEN count(1)=0 THEN 'S'  ELSE 'N' END
	into STRICT	ie_gerar_agenda_equip_w
	from	rxt_agenda a
	where	a.nr_seq_equipamento = nr_seq_equipamento_p
	and	trunc(a.dt_agenda,'dd') = dt_atual_w;

	/*Verificar se tem horário já gerado para a data. Se tiver não vai gerar novamente*/

	if (ie_gerar_agenda_equip_w = 'S') then
		CALL rxt_gerar_agenda_equip(	nr_seq_equipamento_p,
					dt_atual_w,
					'S',
					nm_usuario_p);
	end if;

	ie_status_dia_w			:= 'X';

	select 	pkg_date_utils.get_WeekDay(dt_atual_w)
	into STRICT 	ie_dia_semana_w
	;

	qt_horario_w			:= 0;
	qt_horario_livre_w		:= 0;
	qt_horario_cancelado_w		:= 0;

	select	count(*),
		sum(CASE WHEN ie_status_agenda='L' THEN 1  ELSE 0 END ),
		sum(CASE WHEN ie_status_agenda='C' THEN 1  ELSE 0 END )
	into STRICT	qt_horario_w,
		qt_horario_livre_w,
		qt_horario_cancelado_w
	from	rxt_agenda
	where	nr_seq_equipamento	= nr_seq_equipamento_p
	and	trunc(dt_agenda,'dd')	= dt_atual_w;

	/*
	Status por Dia
		L - Existem Livres
		N - Não tem Agenda Dia
		X - Todos horários Livres
		T - Todos Horarios Lotados
		D - Sabados e Domingos
		C - Cancelados
	*/
	if (qt_horario_livre_w > 0) and (qt_horario_w = qt_horario_livre_w)then
		ie_status_dia_w	:= 'X';
	elsif (qt_horario_livre_w > 0 ) then
		ie_status_dia_w	:= 'L';
	elsif (qt_horario_cancelado_w > 0 ) and (qt_horario_w = qt_horario_cancelado_w)then
		ie_status_dia_w	:= 'B';
	elsif (qt_horario_w > 0 ) and (qt_horario_livre_w = 0) then
		ie_status_dia_w	:= 'T';
	elsif (ie_dia_semana_w = 1) or (ie_dia_semana_w = 7) then
		ie_status_dia_w	:= 'D';
	elsif (qt_horario_w = 0 ) then
		ie_status_dia_w	:= 'N';
	end if;


	ie_status_w	:= ie_status_w || ie_status_dia_w;
	dt_atual_w	:= dt_atual_w + 1;

	end;

end loop;
ie_status_p		:= ie_status_w;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE agenda_radioterapia_dia_status ( cd_estabelecimento_p bigint, nr_seq_equipamento_p bigint, dt_Inicial_p timestamp, dt_final_p timestamp, nm_usuario_p text, ie_Status_p INOUT text) FROM PUBLIC;

