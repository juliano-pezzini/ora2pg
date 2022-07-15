-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE generate_task_delayed ( nr_atendimento_p atendimento_paciente.nr_atendimento%type, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, nr_seq_item_cpoe_p cpoe_material.nr_sequencia%type, ie_tipo_item_cpoe_p wl_worklist.ie_tipo_item_cpoe%type, dt_liberacao_p cpoe_material.dt_liberacao%type, dt_liberacao_enf_p cpoe_material.dt_liberacao_enf%type, dt_liberacao_enf_old_p cpoe_material.dt_liberacao_enf%type, dt_inicio_p cpoe_material.dt_inicio%type) AS $body$
DECLARE


nr_seq_wl_item_w	wl_perfil.nr_sequencia%type;
nr_seq_proc_interno_w	cpoe_procedimento.nr_seq_proc_interno%type;
ie_obter_se_consiste_w varchar(10);


BEGIN
if ((dt_liberacao_p IS NOT NULL AND dt_liberacao_p::text <> '')
	and coalesce(dt_liberacao_enf_old_p::text, '') = '' 
	and (dt_liberacao_enf_p IS NOT NULL AND dt_liberacao_enf_p::text <> '')) then
	
	if ( ie_tipo_item_cpoe_p = 'P' ) then
		select 
			max(nr_seq_proc_interno) 
		into STRICT 
			nr_seq_proc_interno_w 
		from cpoe_procedimento
		where nr_sequencia = nr_seq_item_cpoe_p;
	end if;
	
	ie_obter_se_consiste_w := ADEP_obter_se_consiste_item( ie_tipo_item_cpoe_p, obter_perfil_ativo, null, null, nr_seq_proc_interno_w);
	nr_seq_wl_item_w := obter_se_worklist_lib_cat('D');

	if ((nr_seq_wl_item_w IS NOT NULL AND nr_seq_wl_item_w::text <> '') and ie_obter_se_consiste_w = 'S') then
		CALL gerar_registro_worklist(nr_atendimento_p,
					clock_timestamp(), 
					wheb_usuario_pck.get_nm_usuario, 
					coalesce(dt_inicio_p, clock_timestamp()),
					coalesce(dt_inicio_p, clock_timestamp()) + 1, 
					cd_pessoa_fisica_p, 
					nr_seq_wl_item_w, 
					nr_seq_item_cpoe_p, 
					ie_tipo_item_cpoe_p,
					'N');
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE generate_task_delayed ( nr_atendimento_p atendimento_paciente.nr_atendimento%type, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, nr_seq_item_cpoe_p cpoe_material.nr_sequencia%type, ie_tipo_item_cpoe_p wl_worklist.ie_tipo_item_cpoe%type, dt_liberacao_p cpoe_material.dt_liberacao%type, dt_liberacao_enf_p cpoe_material.dt_liberacao_enf%type, dt_liberacao_enf_old_p cpoe_material.dt_liberacao_enf%type, dt_inicio_p cpoe_material.dt_inicio%type) FROM PUBLIC;

