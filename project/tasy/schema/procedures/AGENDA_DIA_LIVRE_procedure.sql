-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE agenda_dia_livre ( cd_estabelecimento_p bigint, cd_agenda_p bigint, cd_especialidade_p bigint, dt_Inicial_p timestamp, dt_final_p timestamp, ie_primeiro_Livre_p text, ie_classif_p text, nm_usuario_p text, dt_Final_Consulta_p INOUT timestamp) AS $body$
DECLARE

 
cd_agenda_w			bigint;
dt_atual_w			timestamp;
qt_horario_livre_w	integer;
ie_feriado_w		varchar(001);
cd_pessoa_fisica_w	varchar(010);

C01 CURSOR FOR 
	SELECT 	distinct(b.cd_agenda), ie_feriado 
	from 	agenda b, 
		medico_especialidade a 
	where a.cd_pessoa_fisica	= b.cd_pessoa_fisica 
	 and	a.cd_especialidade	= cd_especialidade_p 
	 and coalesce(cd_agenda_p,0)	= 0 
	 and b.cd_pessoa_fisica in ( 
		SELECT cd_pessoa_fisica 
		from  pessoa_fisica 
		Where cd_pessoa_fisica = cd_pessoa_fisica_w 
		
union
 
		select cd_medico_prop 
		from  med_permissao 
		where cd_pessoa_fisica = cd_pessoa_fisica_w) 
	
union
 
	select cd_agenda, ie_feriado 
	from 	agenda 
	where cd_agenda			= cd_agenda_p;


BEGIN 
 
select cd_pessoa_fisica 
into STRICT	cd_pessoa_fisica_w 
from 	usuario 
where nm_usuario	= nm_usuario_p;
dt_Final_Consulta_p			:= null;
 
OPEN C01;
LOOP 
FETCH C01 into 
	cd_agenda_w, 
	ie_feriado_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	dt_atual_w			:= dt_inicial_p;
	while(dt_atual_w	<= dt_final_p) loop 
		CALL Agenda_Horario_Livre( 
			cd_estabelecimento_p, 
			cd_agenda_w, 
			ie_feriado_w,	 
			dt_atual_w, 
			nm_usuario_p);
		if (coalesce(ie_primeiro_livre_p,'N') = 'S') then 
			begin 
 
			/* Ricardo alterado no dia 05/01/2004 (foi incluido no sql abaixo a linha do status da agenda <> de bloqueado */
 
			/*     ao selecionar a opção de posicionar no primeiro horário livre, posicionava nas agendas bloqueadas */
 
 
			 
 
			select count(*) 
			into STRICT	qt_horario_livre_w 
			from 	Agenda_consulta 
			where	cd_agenda		 = cd_agenda_w 
			and dt_agenda between dt_atual_w and dt_atual_w + .9999 
			and ie_classif_agenda = coalesce(ie_classif_p, ie_classif_agenda) 
			and coalesce(cd_pessoa_fisica::text, '') = '' 
			and ie_status_agenda	<> 'B';
 
			 
			dt_final_consulta_p	 := dt_atual_w;
			if (qt_horario_livre_w > 0) then 
				dt_atual_w		:= dt_final_p + 1;
			end if;
			end;
		end if;
		dt_atual_w		:= dt_atual_w + 1;
		end loop;
END LOOP;
CLOSE C01;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE agenda_dia_livre ( cd_estabelecimento_p bigint, cd_agenda_p bigint, cd_especialidade_p bigint, dt_Inicial_p timestamp, dt_final_p timestamp, ie_primeiro_Livre_p text, ie_classif_p text, nm_usuario_p text, dt_Final_Consulta_p INOUT timestamp) FROM PUBLIC;
