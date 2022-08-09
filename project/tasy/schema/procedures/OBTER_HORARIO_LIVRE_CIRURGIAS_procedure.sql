-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_horario_livre_cirurgias ( dt_agenda_p timestamp, dt_final_p timestamp, cd_estabelecimento_p bigint, qt_minutos_p bigint, hr_inicial_p text, hr_final_p text, ds_restricao_p text, nm_usuario_p text, ie_grava_livre_p text) AS $body$
DECLARE

		 
cd_agenda_w	bigint;
ds_horarios_w	varchar(255);
c01 CURSOR FOR
	SELECT	cd_agenda 
	from	agenda 
	where	ie_situacao = 'A' 
	and	cd_tipo_agenda = 1 
	order by coalesce(nr_seq_apresent,0), ds_agenda;

BEGIN
open c01;
loop	 
	fetch C01 into 
		cd_agenda_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	ds_horarios_w := obter_horarios_livres_cirurgia( 
			cd_estabelecimento_p, cd_agenda_w, dt_agenda_p, dt_final_p, qt_minutos_p, hr_inicial_p, hr_final_p, ds_restricao_p, nm_usuario_p, ie_grava_Livre_p, ds_horarios_w);
	end;
end loop;
close c01;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_horario_livre_cirurgias ( dt_agenda_p timestamp, dt_final_p timestamp, cd_estabelecimento_p bigint, qt_minutos_p bigint, hr_inicial_p text, hr_final_p text, ds_restricao_p text, nm_usuario_p text, ie_grava_livre_p text) FROM PUBLIC;
