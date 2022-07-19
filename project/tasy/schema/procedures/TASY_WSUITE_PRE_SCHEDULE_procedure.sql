-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tasy_wsuite_pre_schedule ( nm_usuario_p wsuite_pre_schedule.nm_usuario%type, cd_pessoa_fisica_p wsuite_pre_schedule.cd_pessoa_fisica%type, ds_nota_p wsuite_pre_schedule.ds_nota%type, nr_seq_proc_interno_p wsuite_pre_schedule.nr_seq_proc_interno%type, ie_tipo_agendamento_p wsuite_pre_schedule.ie_tipo_agendamento%type, cd_medico_p wsuite_pre_schedule.cd_medico%type, cd_especialidade_p wsuite_pre_schedule.cd_especialidade%type, ie_linked_user_p wsuite_pre_schedule.ie_linked_user%type, ds_login_p wsuite_pre_schedule.ds_login%type, cd_convenio_p wsuite_pre_schedule.cd_convenio%type, cd_categoria_p wsuite_pre_schedule.cd_categoria%type, cd_plano_p wsuite_pre_schedule.cd_plano%type, ie_private_p wsuite_pre_schedule.ie_private%type, nm_preferred_time_p wsuite_pre_schedule.nm_preferred_time%type, dt_agenda_start_p wsuite_pre_schedule.dt_agenda_start%type, dt_agenda_end_p wsuite_pre_schedule.dt_agenda_end%type, cd_estabelecimento_p wsuite_pre_schedule.cd_estabelecimento%type, nr_sequencia_p INOUT bigint, nr_seq_ageint_item_p bigint default null) AS $body$
DECLARE

	nr_sequencia_w 					wsuite_pre_schedule.nr_sequencia%type;
	nr_seq_ageint_item_transf_w 	agenda_integrada_item.nr_seq_ageint_item_transf%type;

	procedure remover_marcacao_multitransf(nr_seq_ageint_item_p bigint) is
	cd_estab_config_w	agenda_integrada.cd_estabelecimento%type;
	
BEGIN
	if (nr_seq_ageint_item_p IS NOT NULL AND nr_seq_ageint_item_p::text <> '') then
		select	max(a.cd_estabelecimento)
		into STRICT	cd_estab_config_w
		from  	agenda_integrada a,
				agenda_integrada_item ai
		where 	a.nr_sequencia = ai.nr_seq_agenda_int
		and   	ai.nr_sequencia = nr_seq_ageint_item_p;
		
		CALL remover_marcacao_item(nm_usuario_p, cd_estab_config_w, nr_seq_ageint_item_p);
	end if;

	/*for item in (select nr_sequencia from agenda_integrada_item where nr_seq_ageint_item_transf = nr_seq_ageint_item_w) loop
		remover_marcacao_item (nm_usuario_p, cd_estabelecimento_p, item.nr_sequencia);
	end loop;*/
	end;
	
begin
  select nextval('wsuite_pre_schedule_seq') into STRICT nr_sequencia_w;
  insert
  into wsuite_pre_schedule(
      nr_sequencia,
      dt_atualizacao,
      nm_usuario ,
      dt_atualizacao_nrec,
      nm_usuario_nrec,
      ie_situacao,
      dt_liberacao,
      ds_justificativa,
      cd_pessoa_fisica,
      ds_nota,
      ie_status,
      nr_seq_proc_interno,
      ie_tipo_agendamento,
      cd_medico,
      cd_especialidade,
      ie_status_mail,
      ie_linked_user,
      ds_login ,
      cd_convenio,
      cd_categoria,
      cd_plano,
      ie_private,
      dt_agenda_start ,
      dt_agenda_end,
      cd_agenda_scheduled,
      nm_preferred_time,
      cd_estabelecimento
    )
    values (
      nr_sequencia_w,
      clock_timestamp(),
      nm_usuario_p ,
      clock_timestamp(),
      nm_usuario_p,
      'A',
      clock_timestamp(),
      null,
      cd_pessoa_fisica_p,
      ds_nota_p,
      'R',
      nr_seq_proc_interno_p,
      ie_tipo_agendamento_p,
      cd_medico_p,
      CASE WHEN ie_tipo_agendamento_p='E' THEN null  ELSE cd_especialidade_p END ,
      'N',
      ie_linked_user_p,
      ds_login_p ,
      cd_convenio_p,
      cd_categoria_p,
      cd_plano_p,
      ie_private_p,
      dt_agenda_start_p,
      dt_agenda_end_p,
      null,
      nm_preferred_time_p,
      cd_estabelecimento_p
    );
	
	select	max(nr_seq_ageint_item_transf)
	into STRICT	nr_seq_ageint_item_transf_w
	from 	agenda_integrada_item 
	where 	nr_sequencia = nr_seq_ageint_item_p;
	
	if (nr_seq_ageint_item_transf_w IS NOT NULL AND nr_seq_ageint_item_transf_w::text <> '') then
		remover_marcacao_multitransf(nr_seq_ageint_item_transf_w);
	end if;
	
  nr_sequencia_p:=nr_sequencia_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tasy_wsuite_pre_schedule ( nm_usuario_p wsuite_pre_schedule.nm_usuario%type, cd_pessoa_fisica_p wsuite_pre_schedule.cd_pessoa_fisica%type, ds_nota_p wsuite_pre_schedule.ds_nota%type, nr_seq_proc_interno_p wsuite_pre_schedule.nr_seq_proc_interno%type, ie_tipo_agendamento_p wsuite_pre_schedule.ie_tipo_agendamento%type, cd_medico_p wsuite_pre_schedule.cd_medico%type, cd_especialidade_p wsuite_pre_schedule.cd_especialidade%type, ie_linked_user_p wsuite_pre_schedule.ie_linked_user%type, ds_login_p wsuite_pre_schedule.ds_login%type, cd_convenio_p wsuite_pre_schedule.cd_convenio%type, cd_categoria_p wsuite_pre_schedule.cd_categoria%type, cd_plano_p wsuite_pre_schedule.cd_plano%type, ie_private_p wsuite_pre_schedule.ie_private%type, nm_preferred_time_p wsuite_pre_schedule.nm_preferred_time%type, dt_agenda_start_p wsuite_pre_schedule.dt_agenda_start%type, dt_agenda_end_p wsuite_pre_schedule.dt_agenda_end%type, cd_estabelecimento_p wsuite_pre_schedule.cd_estabelecimento%type, nr_sequencia_p INOUT bigint, nr_seq_ageint_item_p bigint default null) FROM PUBLIC;

