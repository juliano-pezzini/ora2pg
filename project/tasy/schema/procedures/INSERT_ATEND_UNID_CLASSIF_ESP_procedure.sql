-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE insert_atend_unid_classif_esp ( nr_seq_classif_esp_old_p classif_especial_paciente.nr_sequencia%type, nr_seq_classif_esp_new_p classif_especial_paciente.nr_sequencia%type, nr_atendimento_p atendimento_paciente.nr_atendimento%type, nr_seq_interno_new_p atend_paciente_unidade.nr_seq_interno%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


nr_seq_interno_w 	  atend_paciente_unidade.nr_seq_interno%type;
nr_seq_interno_old_w 	  atend_paciente_unidade.nr_seq_interno%type;
nm_usuario_w		  usuario.nm_usuario%type;
nr_seq_classif_esp_new_w  classif_especial_paciente.nr_sequencia%type;


BEGIN

if (nr_seq_classif_esp_new_p IS NOT NULL AND nr_seq_classif_esp_new_p::text <> '') and (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (obter_funcao_ativa <> 3113) then
	
	nm_usuario_w := nm_usuario_p;
	
	select	max(nr_seq_interno)
	into STRICT	nr_seq_interno_w
	from	atend_paciente_unidade
	where	nr_atendimento	= nr_atendimento_p
	and	(dt_entrada_unidade IS NOT NULL AND dt_entrada_unidade::text <> '')
	and	coalesce(dt_saida_unidade::text, '') = '';

	
	if (nr_seq_interno_w IS NOT NULL AND nr_seq_interno_w::text <> '')	then
		update 	atend_pac_unid_classif_esp
		set	dt_final = clock_timestamp(),
			dt_atualizacao = clock_timestamp(),
			nm_usuario = nm_usuario_w
		where 	((nr_seq_classif_esp = nr_seq_classif_esp_old_p) or (coalesce(nr_seq_classif_esp::text, '') = ''))
		and	nr_seq_atend_pac_unidade = nr_seq_interno_w
		and	coalesce(dt_final::text, '') = '';
		
		insert	into atend_pac_unid_classif_esp( nr_sequencia,
				  dt_atualizacao_nrec,
				  nm_usuario_nrec,
				  dt_atualizacao,
				  nm_usuario,
				  nr_seq_classif_esp,
				  nr_seq_atend_pac_unidade,
				  dt_inicial,
				  nr_atendimento)
			values ( nextval('atend_pac_unid_classif_esp_seq'),
				  clock_timestamp(),
				  nm_usuario_w,
				  clock_timestamp(),
				  nm_usuario_w,
				  nr_seq_classif_esp_new_p,
				  nr_seq_interno_w,
				  clock_timestamp(),
				  nr_atendimento_p
				 );
	end if;
	
elsif (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '')  and (nr_seq_interno_new_p IS NOT NULL AND nr_seq_interno_new_p::text <> '') then

	nm_usuario_w := nm_usuario_p;

	select  max(nr_seq_classif_esp)
	into STRICT	nr_seq_classif_esp_new_w
	from	atendimento_paciente
	where	nr_atendimento = nr_atendimento_p;
	
	update 	atend_pac_unid_classif_esp
	set	dt_final = clock_timestamp(),
		dt_atualizacao = clock_timestamp(),
		nm_usuario = nm_usuario_w
	where 	nr_atendimento = nr_atendimento_p
	and	coalesce(dt_final::text, '') = '';
	
	
	insert	into atend_pac_unid_classif_esp( nr_sequencia,
				  dt_atualizacao_nrec,
				  nm_usuario_nrec,
				  dt_atualizacao,
				  nm_usuario,
				  nr_seq_classif_esp,
				  nr_seq_atend_pac_unidade,
				  dt_inicial,
				  nr_atendimento)
			values ( nextval('atend_pac_unid_classif_esp_seq'),
				  clock_timestamp(),
				  nm_usuario_w,
				  clock_timestamp(),
				  nm_usuario_w,
				  nr_seq_classif_esp_new_w,
				  nr_seq_interno_new_p,
				  clock_timestamp(),
				  nr_atendimento_p
				 );
end if;
		
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE insert_atend_unid_classif_esp ( nr_seq_classif_esp_old_p classif_especial_paciente.nr_sequencia%type, nr_seq_classif_esp_new_p classif_especial_paciente.nr_sequencia%type, nr_atendimento_p atendimento_paciente.nr_atendimento%type, nr_seq_interno_new_p atend_paciente_unidade.nr_seq_interno%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

