-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE univtrp_horario_livre_consulta ( cd_especialidade_p bigint, cd_estabelecimento_p bigint, dt_inicial_p timestamp, nm_usuario_p text) AS $body$
DECLARE

 
cd_agenda_w   	bigint;
ie_feriado_w  	varchar(1);
qt_gerado_w   	bigint;
i        	bigint;
ds_retorno_w  	varchar(255);
dt_inicial_w  	timestamp;
dt_final_w   	timestamp;
dt_menor_w   	timestamp;
cd_especialidade_w	bigint;
ie_gerar_sobra_hor_w 	varchar(1);

 
 
C01 CURSOR FOR 
    SELECT a.cd_agenda, 
        coalesce(a.ie_feriado,'S'), 
		coalesce(a.cd_especialidade, 0), 
		coalesce(a.ie_gerar_sobra_horario,'N') 
    from  agenda a 
    where  a.ie_situacao  = 'A' 
    and	((a.cd_especialidade = cd_especialidade_p) or (coalesce(cd_especialidade_p::text, '') = '')) 
	and	(a.cd_especialidade IS NOT NULL AND a.cd_especialidade::text <> '') 
    order by 1;

BEGIN
 
/* 
delete tbyegmann; 
dt_final_w  := dt_final_p; 
*/
 
 
    open C01;
    loop 
    fetch C01 into 
        cd_agenda_w, 
        ie_feriado_w, 
		cd_especialidade_w, 
		ie_gerar_sobra_hor_w;
    EXIT WHEN NOT FOUND; /* apply on C01 */
    begin 
    i    := 0;
    dt_inicial_w  := dt_inicial_p;
 
    ds_retorno_w := Horario_Livre_Consulta( cd_estabelecimento_p, cd_agenda_w, ie_feriado_w, dt_inicial_w, nm_usuario_p, 'S', ie_gerar_sobra_hor_w, 'N', null, ds_retorno_w);
 
    select min(dt_agenda) 
    into STRICT  dt_menor_w 
    from  agenda_consulta 
    where  cd_agenda = cd_agenda_w 
    and   dt_agenda between trunc(dt_inicial_w) and trunc(dt_inicial_w) + 83699/86400 
    and   ie_status_agenda = 'L' 
	and	dt_agenda >= clock_timestamp();
 
 
    while(coalesce(dt_menor_w::text, '') = '') and (i <= 30) loop 
        begin 
        ds_retorno_w := Horario_Livre_Consulta( cd_estabelecimento_p, cd_agenda_w, ie_feriado_w, dt_inicial_w, nm_usuario_p, 'S', ie_gerar_sobra_hor_w, 'N', null, ds_retorno_w);
 
        select min(dt_agenda) 
        into STRICT  dt_menor_w 
        from  agenda_consulta 
        where  cd_agenda = cd_agenda_w 
        and   dt_agenda between trunc(dt_inicial_w) and trunc(dt_inicial_w) + 83699/86400 
        and   ie_status_agenda = 'L' 
		and	dt_agenda >= clock_timestamp();
 
        dt_inicial_w := dt_inicial_w + 1;
        i := i + 1;
 
        end;
    end loop;
 
 
    /*insert 	into tbyegmann(	ds_dados, 
				cd_especialidade, 
				cd_agenda) 
		values 		(to_char(dt_menor_w,'dd/mm/yyyy hh24:mi:ss'), 
				cd_especialidade_w, 
				cd_agenda_w); 
	*/
 
 
    end;
    end loop;
    close C01;
 
commit;
 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE univtrp_horario_livre_consulta ( cd_especialidade_p bigint, cd_estabelecimento_p bigint, dt_inicial_p timestamp, nm_usuario_p text) FROM PUBLIC;

