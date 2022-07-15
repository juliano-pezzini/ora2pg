-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE agendar_prox_data_build (nr_sequencia_p bigint, nm_usuario_p text, ie_consiste_fila_p text default 'S', dt_agendamento_new_p INOUT text DEFAULT NULL, ie_periodo_new_p INOUT text DEFAULT NULL, ie_parar_p INOUT text DEFAULT NULL) AS $body$
DECLARE


dt_agendamento_new_w timestamp;
dt_agendamento_w	timestamp;
ie_periodo_new_w	varchar(20);
ie_periodo_w	varchar(2);
ie_flag_w		boolean:= false;
qt_agenda_w	bigint:=0;
qt_linha_numero_w bigint:=0;

procedure verifica_registro_agenda is
;
BEGIN
	-- Se existe agendamento
	select	count(*)
	into STRICT	qt_agenda_w
	from	agendamento_build a
	where	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and	trunc(a.dt_agendamento) = trunc(dt_agendamento_new_w)
	and	a.ie_periodo = ie_periodo_new_w;	
end;

procedure verifica_dia_util is
begin
	-- Agendamento passado em datas passadas nao sao permitidas
	if (trunc(dt_agendamento_new_w) < trunc(clock_timestamp())) then
		qt_agenda_w:= 1;
	end if;
	
	-- Agendamento em dias nao uteis nao sao permitidos
	if (obter_se_dia_util(dt_agendamento_new_w,1) = 'N') then
		qt_agenda_w:= 1;	
	end if;
	
	-- Agendamento passado em datas inviaveis nao sao permitidas
	if (trunc(dt_agendamento_new_w) = trunc(clock_timestamp())) then
		if (((to_char(clock_timestamp(),'hh24'))::numeric  > 2) and (ie_periodo_new_w = 'A')) or
		   (((to_char(clock_timestamp(),'hh24'))::numeric  > 4) and (ie_periodo_new_w = 'M')) or
		   (((to_char(clock_timestamp(),'hh24'))::numeric  > 10) and (ie_periodo_new_w = 'V')) or
		   (((to_char(clock_timestamp(),'hh24'))::numeric  > 22) and (ie_periodo_new_w = 'B')) then
			   qt_agenda_w:= 1;
		end if;
	end if;
end;

procedure atualiza_registro_agenda is
begin
    -- Liberar registro
	CALL liberar_agenda_build(nm_usuario_p, nr_sequencia_p, dt_agendamento_new_w, ie_periodo_new_w);
	
	dt_agendamento_new_p:= to_char(dt_agendamento_new_w);
	select	CASE WHEN ie_periodo_new_w='M' THEN substr(obter_desc_expressao(500444),1,100) WHEN ie_periodo_new_w='V' THEN substr(obter_desc_expressao(500445),1,100) WHEN ie_periodo_new_w='A' THEN 'Time A (BLR)' WHEN ie_periodo_new_w='B' THEN 'Time B (BLR)' END
	into STRICT	ie_periodo_new_p
	;

end;

procedure proximo_perido_agenda is
begin

	if (ie_periodo_new_w = 'A') then
		-- Se for primeiro horario India entao joga para segundo horario India
		ie_periodo_new_w:= 'M';
		dt_agendamento_new_w := TO_DATE(TO_CHAR(TRUNC(dt_agendamento_new_w) + 4/24,'dd/mm/yyyy hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss');
	elsif (ie_periodo_new_w = 'M') then
		-- Se for segundo horario India entao joga para manha Brasil
		ie_periodo_new_w:= 'V';
		dt_agendamento_new_w := TO_DATE(TO_CHAR(TRUNC(dt_agendamento_new_w) + 10/24,'dd/mm/yyyy hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss');
	elsif (ie_periodo_new_w = 'V') then
		-- Se for manha Brasil entao joga para vespertino Brasil
		ie_periodo_new_w:= 'B';
		dt_agendamento_new_w := TO_DATE(TO_CHAR(TRUNC(dt_agendamento_new_w) + 22/24,'dd/mm/yyyy hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss');
	else
		-- Se for vespertino Brasil entao joga para primeiro horario India
		ie_periodo_new_w:= 'A';
		dt_agendamento_new_w := TO_DATE(TO_CHAR(TRUNC(dt_agendamento_new_w+1) + 2/24,'dd/mm/yyyy hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss');
	end if;
	
end;


begin

select	a.dt_agendamento,
	a.ie_periodo
into STRICT	dt_agendamento_w,
	ie_periodo_w
from	agendamento_build a
where	a.nr_sequencia = nr_sequencia_p;

-- Variaveis se alimentam inicialmente e mudam ao deccorer do processo
ie_parar_p:= 'N';
dt_agendamento_new_w:= dt_agendamento_w;
ie_periodo_new_w:= ie_periodo_w;

if (ie_consiste_fila_p = 'S') then

	while(ie_flag_w = false) loop
	
		-- Linha de seguranca
		qt_linha_numero_w:= qt_linha_numero_w+1;
		qt_agenda_w:= 0;
		
		-- Se existe agendamento
		verifica_registro_agenda;

		-- Agendamento em dias nao uteis nao sao permitidos
		verifica_dia_util;

		-- Caso 0 a agenda esta lire para agendamento
		if (qt_agenda_w = 0) then
			-- Reagenda e liberar registro
			atualiza_registro_agenda;
			ie_flag_w:= true;
		else		
			-- Segue para o proximo periodo
			proximo_perido_agenda;
		end if;
		
		-- Linha seguranca para escapar do While infinito
		if (qt_linha_numero_w > 100) then
			ie_flag_w:= true;
		end if;
		
	end loop;
end if;


if (ie_consiste_fila_p = 'N') then
	
	-- Segue para o proximo periodo
	proximo_perido_agenda;
	
	while(ie_flag_w = false) loop
	
		-- Linha de seguranca
		qt_linha_numero_w:= qt_linha_numero_w+1;
		qt_agenda_w:= 0;
	
		-- Agendamento em dias nao uteis nao sao permitidos
		verifica_dia_util;
		
		if (qt_agenda_w = 0) then
			-- Se existe agendamento
			verifica_registro_agenda;

			if (qt_agenda_w = 0) then
				ie_parar_p:= 'S';
			end if;
			
			atualiza_registro_agenda;			
			ie_flag_w:= true;			
		else		
			-- Segue para o proximo periodo
			proximo_perido_agenda;
		end if;

		-- Linha seguranca para escapar do While infinito
		if (qt_linha_numero_w > 100) then
			ie_flag_w:= true;
		end if;
		
	end loop;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE agendar_prox_data_build (nr_sequencia_p bigint, nm_usuario_p text, ie_consiste_fila_p text default 'S', dt_agendamento_new_p INOUT text DEFAULT NULL, ie_periodo_new_p INOUT text DEFAULT NULL, ie_parar_p INOUT text DEFAULT NULL) FROM PUBLIC;

