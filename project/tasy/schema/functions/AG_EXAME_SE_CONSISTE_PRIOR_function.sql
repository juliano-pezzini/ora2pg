-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ag_exame_se_consiste_prior ( nr_seq_agenda_p bigint, cd_pessoa_fisica_p text, dt_agenda_p timestamp, nr_seq_proc_interno_p bigint, cd_estabelecimento_p bigint, qt_dias_consistencia_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w      varchar(1)   := 'N';
nr_seq_prioridade_w   bigint;
nr_prioridade_ant_w   bigint;
nr_prioridade_post_w  bigint;
nr_seq_proc_interno_w  bigint;
ds_erro_w        varchar(255)  := '';
ds_proc_interno_w    varchar(100);
ds_proc_interno_marc_w varchar(100);
dt_inicial_w      timestamp;
dt_final_w       timestamp;

C01 CURSOR FOR 
    /*HORÁRIOS PASSADOS*/
 
    SELECT Obter_Prioridade_Ag_Exame(a.nr_sequencia, a.nr_seq_proc_interno, cd_estabelecimento_p, dt_agenda_p), 
        a.nr_seq_proc_interno 
    from  agenda_paciente a, 
        agenda b 
    where  a.cd_agenda       = b.cd_agenda 
    and   a.cd_pessoa_fisica   = cd_pessoa_fisica_p 
    and   a.nr_seq_proc_interno  <> nr_seq_proc_interno_p 
    and   (a.nr_seq_proc_interno IS NOT NULL AND a.nr_seq_proc_interno::text <> '') 
    and   a.hr_inicio       < dt_agenda_p 
    and   a.dt_agenda       between trunc(dt_agenda_p - qt_dias_consistencia_p) and trunc(dt_agenda_p) + 86399 
    and   ds_retorno_w      = 'N' 
    and   a.ie_status_agenda   not in ('C','B','F','I','L','II');

C02 CURSOR FOR 
    /*HORÁRIOS FUTUROS*/
 
    SELECT Obter_Prioridade_Ag_Exame(a.nr_sequencia, a.nr_seq_proc_interno, cd_estabelecimento_p, dt_agenda_p), 
        a.nr_seq_proc_interno 
    from  agenda_paciente a, 
        agenda b 
    where  a.cd_agenda       = b.cd_agenda 
    and   a.cd_pessoa_fisica   = cd_pessoa_fisica_p 
    and   a.nr_seq_proc_interno  <> nr_seq_proc_interno_p 
    and   (a.nr_seq_proc_interno IS NOT NULL AND a.nr_seq_proc_interno::text <> '') 
    and   a.hr_inicio       > dt_agenda_p 
    and   a.dt_agenda       between trunc(dt_agenda_p) and trunc(dt_agenda_p + qt_dias_consistencia_p) + 86399/86400 
    and   ds_retorno_w      = 'N' 
    and   a.ie_status_agenda   not in ('C','B','F','I','L','II');


BEGIN 
 
if (nr_seq_proc_interno_p IS NOT NULL AND nr_seq_proc_interno_p::text <> '') then 
    nr_seq_prioridade_w   := Obter_Prioridade_Ag_Exame(nr_seq_agenda_p, nr_seq_proc_interno_p, cd_estabelecimento_p, dt_agenda_p);
 
    select max(ds_proc_exame) 
    into STRICT  ds_proc_interno_marc_w 
    from  proc_interno 
    where  nr_sequencia = nr_seq_proc_interno_p;
 
    if (nr_seq_prioridade_w  <> 999) then 
        open C01;
        loop 
        fetch C01 into 
            nr_prioridade_ant_w, 
            nr_seq_proc_interno_w;
        EXIT WHEN NOT FOUND; /* apply on C01 */
			begin 
			select	max(ds_proc_exame) 
			into STRICT	ds_proc_interno_w 
			from	proc_interno 
			where	nr_sequencia = nr_seq_proc_interno_w;
			 
			if (nr_prioridade_ant_w	<> 999) and (nr_prioridade_ant_w	> nr_seq_prioridade_w) then 
				ds_retorno_w	:= 'S';
				ds_erro_w	:= substr(wheb_mensagem_pck.get_texto(800084, 
										'DS_PROC_INTERNO_MARC='||ds_proc_interno_marc_w|| 
										';DS_PROC_INTERNO='||ds_proc_interno_w),1,255);
			end if;
			end;
		end loop;
		close C01;
 
		open C02;
		loop 
		fetch C02 into	 
			nr_prioridade_post_w, 
			nr_seq_proc_interno_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin 
			 
			select	max(ds_proc_exame) 
			into STRICT	ds_proc_interno_w 
			from	proc_interno 
			where	nr_sequencia = nr_seq_proc_interno_w;
			 
			if (nr_prioridade_post_w	<> 999) and (nr_prioridade_post_w	< nr_seq_prioridade_w) then 
				ds_retorno_w	:= 'S';
				ds_erro_w	:= substr(wheb_mensagem_pck.get_texto(800083, 
										'DS_PROC_INTERNO_MARC='||ds_proc_interno_marc_w|| 
										';DS_PROC_INTERNO='||ds_proc_interno_w),1,255);
			end if;
			end;
		end loop;
		close C02;
	end if;
end if;
 
return ds_erro_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ag_exame_se_consiste_prior ( nr_seq_agenda_p bigint, cd_pessoa_fisica_p text, dt_agenda_p timestamp, nr_seq_proc_interno_p bigint, cd_estabelecimento_p bigint, qt_dias_consistencia_p bigint) FROM PUBLIC;
