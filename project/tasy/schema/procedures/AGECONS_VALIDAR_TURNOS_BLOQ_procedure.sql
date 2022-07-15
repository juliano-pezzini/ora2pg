-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE agecons_validar_turnos_bloq (cd_agenda_p bigint, nm_usuario_p text, dt_inicio_p timestamp, dt_final_p timestamp, hr_inicial_p timestamp, hr_final_p timestamp, nr_seq_motivo_bloqueio_p bigint, nr_seq_motivo_bloqueio_new_p bigint, ie_motivo_bloqueio_p text, ie_motivo_bloqueio_new_p text, ie_dia_semana_p bigint, ie_acao_p text, ds_erro_p INOUT text) AS $body$
DECLARE


ds_erro_w varchar(255) := null;
qt_regra_bloq_sala_w bigint := 0;
agenda_turno_conflito_w bigint := 0;
nr_seq_sala_w bigint := null;
ie_verifica_lib_bloq_w bigint := 0;
ie_consiste_sala_w		varchar(1);

c01 CURSOR FOR
	SELECT ie_dia_semana,
		   dt_inicio_vigencia,
		   dt_final_vigencia,
		   hr_inicial,
		   hr_final,
		   nr_seq_sala,
		   nr_sequencia nr_seq_turno
	from agenda_turno
	where cd_agenda = cd_agenda_p
	  and (nr_seq_sala IS NOT NULL AND nr_seq_sala::text <> '')
	  and (ie_dia_semana = coalesce(ie_dia_semana_p, ie_dia_semana) or (ie_dia_semana = 9 and ie_dia_semana not in (7,1)))
	  and (((dt_inicio_vigencia <= coalesce(dt_inicio_p,dt_inicio_vigencia) or coalesce(dt_inicio_vigencia::text, '') = '')
		or (dt_final_vigencia >= coalesce(dt_final_p,dt_final_vigencia) or coalesce(dt_final_vigencia::text, '') = ''))
	    or hr_inicial <= coalesce(to_date('30121899 '||to_char(hr_inicial_p,'hh24miss'),'ddmmyyyy hh24miss'), hr_inicial)
		or hr_final >= coalesce(to_date('31122999 '||to_char(hr_inicial_p,'hh24miss'),'ddmmyyyy hh24miss'),hr_final))
	
union all

	SELECT ie_dia_semana ie_dia_semana,
		   DT_AGENDA dt_inicio_vigencia,
		   DT_AGENDA_FIM dt_final_vigencia,
		   hr_inicial hr_inicial,
		   hr_final hr_final,
		   nr_seq_sala nr_seq_sala,
		   nr_sequencia nr_seq_turno
	from AGENDA_TURNO_ESP
	where cd_agenda = cd_agenda_p
	  and (nr_seq_sala IS NOT NULL AND nr_seq_sala::text <> '')
	  and (ie_dia_semana = coalesce(ie_dia_semana_p, ie_dia_semana) or (ie_dia_semana_p = 9 and ie_dia_semana not in (7,1)))
	  and ((DT_AGENDA <= coalesce(dt_inicio_p,DT_AGENDA) or coalesce(DT_AGENDA::text, '') = '')
		or (DT_AGENDA_FIM >= coalesce(dt_final_p,DT_AGENDA_FIM) or coalesce(DT_AGENDA_FIM::text, '') = '')
		or hr_inicial <= coalesce(to_date('30121899 '||to_char(hr_inicial_p,'hh24miss'),'ddmmyyyy hh24miss'), hr_inicial)
		or hr_final >= coalesce(to_date('31122999 '||to_char(hr_inicial_p,'hh24miss'),'ddmmyyyy hh24miss'),hr_final));

c02_turno CURSOR FOR
	SELECT ar.cd_agenda,
		   ar.nr_sequencia,
		   ar.dt_inicio_vigencia,
		   ar.dt_final_vigencia,
		   ar.hr_inicial,
		   ar.hr_final,
		   ar.ie_dia_semana
	  from agenda_turno ar,
		   agenda a
	 where ar.cd_agenda <> cd_agenda_p
	   and a.cd_agenda = ar.cd_agenda
	   and ar.nr_seq_sala = nr_seq_sala_w
	   and a.cd_tipo_agenda in (3,4)
	
union all

	SELECT ar.cd_agenda,
		   ar.nr_sequencia,
		   ar.DT_AGENDA dt_inicio_vigencia,
		   ar.DT_AGENDA_FIM dt_final_vigencia,
		   ar.hr_inicial,
		   ar.hr_final,
		   ar.ie_dia_semana
	  from agenda_turno_esp ar,
		   agenda a
	 where ar.cd_agenda <> cd_agenda_p
	   and a.cd_agenda = ar.cd_agenda
	   and ar.nr_seq_sala = nr_seq_sala_w
	   and a.cd_tipo_agenda in (3,4);	
		
BEGIN

select 	count(*)
into STRICT	qt_regra_bloq_sala_w
from	AGECONS_REGRA_TURNO_SALA art
where (coalesce(art.nr_seq_motivo,0) = coalesce(nr_seq_motivo_bloqueio_p,0))
  and	art.ie_motivo_bloqueio = ie_motivo_bloqueio_p
  and	coalesce(ie_situacao, 'A') = 'A';

  ie_consiste_sala_w := obter_valor_param_usuario(821, 302, obter_perfil_ativo, nm_usuario_p, 0);

	if (qt_regra_bloq_sala_w > 0 and coalesce(ie_consiste_sala_w,'N') = 'S') then

		for c01_r in c01 loop

			begin
				
				nr_seq_sala_w := c01_r.nr_seq_sala;
				
				for c02_r in c02_turno loop
					
					begin
						
						if ( (
							 (dt_inicio_p > coalesce(c02_r.dt_inicio_vigencia,dt_inicio_p) and dt_final_p > coalesce(c02_r.dt_inicio_vigencia,dt_inicio_p) or dt_final_p < coalesce(c02_r.dt_final_vigencia,dt_final_p)) and
							 ((c02_r.hr_inicial >= coalesce(hr_inicial_p,c02_r.hr_inicial) and c02_r.hr_inicial <= coalesce(hr_final_p,c02_r.hr_inicial)) or (c02_r.hr_final >= coalesce(hr_final_p,c02_r.hr_final) and c02_r.hr_inicial < coalesce(hr_final_p,c02_r.hr_final))) and (c02_r.ie_dia_semana = coalesce(ie_dia_semana_p,c02_r.ie_dia_semana) or (c02_r.ie_dia_semana = 9 and  c02_r.ie_dia_semana not in (7,1))))
							 ) then							
								ds_erro_w := wheb_mensagem_pck.get_texto(1095124,null);
								goto fim_exec;
							
						elsif  ((dt_inicio_p <= coalesce(c02_r.dt_inicio_vigencia,dt_inicio_p) and dt_final_p >= coalesce(c02_r.dt_final_vigencia,dt_final_p)) and
							 ((c02_r.hr_inicial < coalesce(hr_inicial_p,to_date(to_char(c02_r.hr_inicial,'ddmmyyyy')||' 000000','ddmmyyyy hh24miss')) and c02_r.hr_inicial <= coalesce(hr_final_p,to_date(to_char(c02_r.hr_inicial,'ddmmyyyy')||' 000000','ddmmyyyy hh24miss'))) or (c02_r.hr_final > coalesce(hr_final_p,to_date(to_char(c02_r.hr_final,'ddmmyyyy')||' 235959','ddmmyyyy hh24miss'))) or (c02_r.hr_inicial < coalesce(hr_inicial_p,to_date(to_char(c02_r.hr_inicial,'ddmmyyyy')||' 000000','ddmmyyyy hh24miss'))
							 )) and (c02_r.ie_dia_semana = coalesce(ie_dia_semana_p,c02_r.ie_dia_semana) or (c02_r.ie_dia_semana = 9 and  c02_r.ie_dia_semana not in (7,1)))) then
							
		
								goto fim_exec;
						elsif  ((dt_inicio_p <= coalesce(c02_r.dt_inicio_vigencia,dt_inicio_p) and dt_final_p >= coalesce(c02_r.dt_final_vigencia,dt_final_p) and coalesce(c01_r.dt_final_vigencia,dt_inicio_p) >= dt_inicio_p) and
							 ((c02_r.hr_inicial >= coalesce(hr_inicial_p,to_date(to_char(c02_r.hr_inicial,'ddmmyyyy')||' 000000','ddmmyyyy hh24miss')) and c02_r.hr_inicial <= coalesce(hr_final_p,to_date(to_char(c02_r.hr_inicial,'ddmmyyyy')||' 000000','ddmmyyyy hh24miss'))) or (c02_r.hr_final <= coalesce(hr_final_p,to_date(to_char(c02_r.hr_final,'ddmmyyyy')||' 235959','ddmmyyyy hh24miss')))) and
							 ie_acao_p = 'D') then
							
							
									ds_erro_w := wheb_mensagem_pck.get_texto(1095124,null);
									goto fim_exec;
							
						elsif (
								(dt_inicio_p <= coalesce(c02_r.dt_inicio_vigencia,dt_inicio_p) and dt_final_p >= coalesce(c02_r.dt_final_vigencia,dt_final_p) and (c02_r.hr_inicial >= coalesce(hr_inicial_p,c02_r.hr_inicial) and c02_r.hr_inicial <= coalesce(hr_final_p,c02_r.hr_inicial)) and (c02_r.ie_dia_semana <> ie_dia_semana_p) and
								((c02_r.ie_dia_semana = 9 and ie_dia_semana_p <> 9) or (c02_r.ie_dia_semana not in (7,1) and ie_dia_semana_p <> 9) or c02_r.ie_dia_semana in (7,1) and ie_dia_semana_p not in (7,1) ))) then
								
								ds_erro_w := wheb_mensagem_pck.get_texto(1095124,null);
								goto fim_exec;
								
						elsif ( coalesce(nr_seq_motivo_bloqueio_p,0) <> coalesce(nr_seq_motivo_bloqueio_new_p,0) or ie_motivo_bloqueio_p <> ie_motivo_bloqueio_new_p ) then

							select max(qt_lib_sala) qt_lib_sala
							 into STRICT ie_verifica_lib_bloq_w from (
									 SELECT COUNT(1) qt_lib_sala
								  FROM AGENDA_TURNO AGT,
									   AGENDA_BLOQUEIO AB,
									   AGECONS_REGRA_TURNO_SALA ATS
								 WHERE AGT.CD_AGENDA = AB.CD_AGENDA
								   AND AB.IE_MOTIVO_BLOQUEIO = ATS.IE_MOTIVO_BLOQUEIO
								   AND coalesce(AB.NR_SEQ_MOTIVO_BLOQ_AG,0) = coalesce(ATS.NR_SEQ_MOTIVO,coalesce(AB.NR_SEQ_MOTIVO_BLOQ_AG,0))
								   and coalesce(AB.NR_SEQ_MOTIVO_BLOQ_AG,0) = coalesce(nr_seq_motivo_bloqueio_p,0)
								   and AB.IE_MOTIVO_BLOQUEIO = ie_motivo_bloqueio_p
								   and (agt.ie_dia_semana = coalesce(ab.ie_dia_semana,agt.ie_dia_semana)
									or (agt.ie_dia_semana = 9 and coalesce(ab.ie_dia_semana,agt.ie_dia_semana) not in (7,1))
									or (ab.ie_dia_semana = 9 and agt.ie_dia_semana not in (7,1)))            
								   and ((c02_r.ie_dia_semana = coalesce(ab.ie_dia_semana,c02_r.ie_dia_semana))
									or (ab.ie_dia_semana = 9 and c02_r.ie_dia_semana not in (1,7))) 
								   AND to_date('30121899 '||to_char(AGT.HR_INICIAL,'hh24miss'),'ddmmyyyy hh24miss') <= coalesce(to_date('30121899 '||to_char(AB.HR_INICIO_BLOQUEIO,'hh24miss'),'ddmmyyyy hh24miss'),to_date('30121899 '||to_char(AGT.HR_INICIAL,'hh24miss'),'ddmmyyyy hh24miss'))
								   AND to_date('30121899 '||to_char(AGT.HR_FINAL,'hh24miss'),'ddmmyyyy hh24miss') >= coalesce(to_date('30121899 '||to_char(AB.HR_FINAL_BLOQUEIO,'hh24miss'),'ddmmyyyy hh24miss'),to_date('30121899 '||to_char(AGT.HR_FINAL,'hh24miss'),'ddmmyyyy hh24miss'))
								   AND AB.DT_INICIAL >= coalesce(AGT.DT_INICIO_VIGENCIA, AB.DT_INICIAL)
								   AND AB.DT_FINAL <= coalesce(AGT.DT_FINAL_VIGENCIA, AB.DT_FINAL)
								   AND to_date('30121899 '||to_char(c02_r.hr_inicial,'hh24miss'),'ddmmyyyy hh24miss') >= coalesce(AB.HR_INICIO_BLOQUEIO,to_date('30121899 '||to_char(c02_r.hr_inicial,'hh24miss'),'ddmmyyyy hh24miss')) 
								   and to_date('30121899 '||to_char(c02_r.hr_inicial,'hh24miss'),'ddmmyyyy hh24miss') <= coalesce(AB.HR_FINAL_BLOQUEIO,to_date('30121899 '||to_char(c02_r.hr_final,'hh24miss'),'ddmmyyyy hh24miss'))
								   AND to_date('30121899 '||to_char(c02_r.hr_final,'hh24miss'),'ddmmyyyy hh24miss') <= coalesce(AB.HR_FINAL_BLOQUEIO,to_date('30121899 '||to_char(c02_r.hr_final,'hh24miss'),'ddmmyyyy hh24miss'))
								   AND AB.DT_INICIAL <= coalesce(c02_r.dt_inicio_vigencia,to_date('30121899','ddmmyyyy')) and AB.DT_FINAL >= coalesce(c02_r.dt_inicio_vigencia,to_date('30121899','ddmmyyyy'))
								   AND AB.DT_FINAL >= c02_r.dt_final_vigencia
								   and ab.cd_agenda <> c02_r.cd_agenda
								   and agt.nr_seq_sala = nr_seq_sala_w
								
UNION ALL

								SELECT COUNT(1) qt_lib_sala
								  FROM AGENDA_TURNO_ESP AGT,
									   AGENDA_BLOQUEIO AB,
									   AGECONS_REGRA_TURNO_SALA ATS
								 WHERE AGT.CD_AGENDA = AB.CD_AGENDA
								   AND AB.IE_MOTIVO_BLOQUEIO = ATS.IE_MOTIVO_BLOQUEIO
								   AND coalesce(AB.NR_SEQ_MOTIVO_BLOQ_AG,0) = coalesce(ATS.NR_SEQ_MOTIVO,coalesce(AB.NR_SEQ_MOTIVO_BLOQ_AG,0))
								   and coalesce(AB.NR_SEQ_MOTIVO_BLOQ_AG,0) = coalesce(nr_seq_motivo_bloqueio_p,0)
								   and AB.IE_MOTIVO_BLOQUEIO = ie_motivo_bloqueio_p
								   and (agt.ie_dia_semana = coalesce(ab.ie_dia_semana,agt.ie_dia_semana) 
									or (agt.ie_dia_semana = 9 and coalesce(ab.ie_dia_semana,agt.ie_dia_semana) not in (7,1))
									or (ab.ie_dia_semana = 9 and agt.ie_dia_semana not in (7,1)))            
								   and ((c02_r.ie_dia_semana = coalesce(ab.ie_dia_semana,c02_r.ie_dia_semana))
									or (ab.ie_dia_semana = 9 and c02_r.ie_dia_semana not in (1,7))) 
								   AND to_date('30121899 '||to_char(AGT.HR_INICIAL,'hh24miss'),'ddmmyyyy hh24miss') <= coalesce(to_date('30121899 '||to_char(AB.HR_INICIO_BLOQUEIO,'hh24miss'),'ddmmyyyy hh24miss'),to_date('30121899 '||to_char(AGT.HR_INICIAL,'hh24miss'),'ddmmyyyy hh24miss'))
								   AND to_date('30121899 '||to_char(AGT.HR_FINAL,'hh24miss'),'ddmmyyyy hh24miss') >= coalesce(to_date('30121899 '||to_char(AB.HR_FINAL_BLOQUEIO,'hh24miss'),'ddmmyyyy hh24miss'),to_date('30121899 '||to_char(AGT.HR_FINAL,'hh24miss'),'ddmmyyyy hh24miss'))
								   AND AB.DT_INICIAL >= AGT.DT_AGENDA
								   AND AB.DT_FINAL <= coalesce(AGT.DT_AGENDA_FIM, AB.DT_FINAL)
								   AND to_date('30121899 '||to_char(c02_r.hr_inicial,'hh24miss'),'ddmmyyyy hh24miss') >= coalesce(AB.HR_INICIO_BLOQUEIO,to_date('30121899 '||to_char(c02_r.hr_inicial,'hh24miss'),'ddmmyyyy hh24miss')) 
								   and to_date('30121899 '||to_char(c02_r.hr_inicial,'hh24miss'),'ddmmyyyy hh24miss') <= coalesce(AB.HR_FINAL_BLOQUEIO,to_date('30121899 '||to_char(c02_r.hr_final,'hh24miss'),'ddmmyyyy hh24miss'))
								   AND to_date('30121899 '||to_char(c02_r.hr_final,'hh24miss'),'ddmmyyyy hh24miss') <= coalesce(AB.HR_FINAL_BLOQUEIO,to_date('30121899 '||to_char(c02_r.hr_final,'hh24miss'),'ddmmyyyy hh24miss'))
								   AND AB.DT_INICIAL <= coalesce(c02_r.dt_inicio_vigencia,to_date('30121899','ddmmyyyy')) and AB.DT_FINAL >= coalesce(c02_r.dt_inicio_vigencia,to_date('30121899','ddmmyyyy'))		   
								   AND AB.DT_FINAL >= c02_r.dt_final_vigencia
								   and ab.cd_agenda <> c02_r.cd_agenda
								   and agt.nr_seq_sala = nr_seq_sala_w) alias109;
								
								   if (ie_verifica_lib_bloq_w > 0) then
										ds_erro_w := wheb_mensagem_pck.get_texto(1095124,null);
										goto fim_exec;
								   end if;
						
						end if;
						
					end;
					
				end loop;
				
			end;

		end loop;

	end if;
	<<fim_exec>>
	ds_erro_p := ds_erro_w;

end;	
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE agecons_validar_turnos_bloq (cd_agenda_p bigint, nm_usuario_p text, dt_inicio_p timestamp, dt_final_p timestamp, hr_inicial_p timestamp, hr_final_p timestamp, nr_seq_motivo_bloqueio_p bigint, nr_seq_motivo_bloqueio_new_p bigint, ie_motivo_bloqueio_p text, ie_motivo_bloqueio_new_p text, ie_dia_semana_p bigint, ie_acao_p text, ds_erro_p INOUT text) FROM PUBLIC;

