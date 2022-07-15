-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_lista_espera_pep ( nr_seq_pedido_p bigint, nm_tabela_pedido_p text, nm_usuario_p text) AS $body$
DECLARE

 
cd_agenda_w				bigint;
cd_especialidade_w		integer;
cd_medico_w				varchar(10);
cd_tipo_agenda_w		bigint;
ie_classif_agenda_w		varchar(1);
cd_pessoa_fisica_w		varchar(10);
cd_medico_dest_w		varchar(10);
nr_seq_programa_w		bigint;
cd_espec_medico_w		integer;
cd_espec_encaminhamento_w	integer;
nr_seq_exame_w			bigint;
nr_seq_exame_lab_w		bigint;
cd_material_exame_w		varchar(20);
ds_exame_sem_cad_w		varchar(255);
cd_procedimento_w		bigint;
nr_proc_interno_w		bigint;
ie_origem_proced_w		bigint;
ie_urgente_w			varchar(1);
qt_exame_w				integer;
cd_ciap_w				varchar(5);
cd_doenca_cid_w			varchar(10);
ds_observacao_w			varchar(4000);
nr_Atendimento_w		bigint;
cd_convenio_w			integer;
ie_pendente_w			varchar(1);	
 
C01 CURSOR FOR 
	SELECT	a.nr_seq_exame, 
		a.nr_seq_exame_lab, 
		a.cd_material_exame, 
		a.ds_exame_sem_cad, 
		a.cd_procedimento, 
		a.nr_proc_interno, 
		a.ie_origem_proced, 
		a.ie_urgente, 
		a.qt_exame		 
	from	pedido_exame_externo_item a 
	where	a.nr_seq_pedido = nr_seq_pedido_p;


BEGIN 
 
if (nr_seq_pedido_p IS NOT NULL AND nr_seq_pedido_p::text <> '') then 
	if (nm_tabela_pedido_p = 'ATEND_ENCAMINHAMENTO') then 
		select	max(a.cd_agenda), 
			max(a.cd_pessoa_fisica), 
			max(a.cd_medico_dest), 
			max(a.cd_especialidade), 
			max(obter_especialidade_medico(a.cd_medico_dest,null)), 
			max(cd_ciap), 
			max(cd_doenca), 
			max(ds_observacao), 
			max(nr_atendimento) 
		into STRICT	cd_agenda_w, 
			cd_pessoa_fisica_w, 
			cd_medico_dest_w, 
			cd_espec_encaminhamento_w, 
			cd_espec_medico_w, 
			cd_ciap_w, 
			cd_doenca_cid_w, 
			ds_observacao_w, 
			nr_Atendimento_w 
		from	atend_encaminhamento a 
		where	a.nr_sequencia = nr_seq_pedido_p;
		 
		 
		select 	max(obter_convenio_atendimento(nr_Atendimento_w)) 
		into STRICT	cd_convenio_w 
		;
 
		select	max(a.cd_especialidade), 
			max(a.cd_pessoa_fisica), 
			max(a.cd_tipo_agenda), 
			max(a.ie_classificacao)			 
		into STRICT	cd_especialidade_w, 
			cd_medico_w, 
			cd_tipo_agenda_w, 
			ie_classif_agenda_w 
		from	agenda a 
		where	a.cd_agenda = cd_agenda_w;
 
		insert into agenda_lista_espera( 
			nr_sequencia, 
			cd_ciap, 
			cd_cid, 
			cd_agenda, 
			cd_especialidade, 
			cd_medico, 
			cd_tipo_agenda, 
			ie_classif_agenda, 
			nm_tabela_pedido, 
			nr_seq_pedido, 
			cd_pessoa_fisica, 
			dt_agendamento, 
			dt_atualizacao, 
			dt_atualizacao_nrec, 
			dt_desejada, 
			ie_status_espera, 
			nm_usuario_agenda, 
			nm_usuario, 
			nm_usuario_nrec, 
			ds_observacao, 
			cd_convenio) 
		values ( 
			nextval('agenda_lista_espera_seq'), 
			cd_ciap_w, 
			cd_doenca_cid_w, 
			cd_agenda_w, 
			coalesce(cd_especialidade_w,coalesce(cd_espec_encaminhamento_w,cd_espec_medico_w)), 
			coalesce(cd_medico_w,cd_medico_dest_w), 
			cd_tipo_agenda_w, 
			ie_classif_agenda_w, 
			nm_tabela_pedido_p, 
			nr_seq_pedido_p, 
			cd_pessoa_fisica_w, 
			clock_timestamp(), 
			clock_timestamp(), 
			clock_timestamp(), 
			clock_timestamp(), 
			'A', 
			nm_usuario_p, 
			nm_usuario_p, 
			nm_usuario_p, 
			substr(ds_observacao_w,1,2000), 
			cd_convenio_w);
	elsif (nm_tabela_pedido_p = 'ATEND_PROGRAMA_SAUDE') then	 
			 
		CALL gerar_programa_saude_pep(nr_seq_pedido_p);	
							 
	elsif (nm_tabela_pedido_p = 'PEDIDO_EXAME_EXTERNO') then 
		select	max(a.cd_pessoa_fisica), 
				max(a.nr_atendimento), 
			max(IE_PENDENTE) 
		into STRICT	cd_pessoa_fisica_w, 
				nr_Atendimento_w, 
			ie_pendente_w 
		from	pedido_exame_externo a 
		where	a.nr_sequencia = nr_seq_pedido_p;
 
		if (coalesce(IE_PENDENTE_W,'N') = 'S') then 
 
			open C01;
			loop 
			fetch C01 into	 
				nr_seq_exame_w, 
				nr_seq_exame_lab_w, 
				cd_material_exame_w, 
				ds_exame_sem_cad_w, 
				cd_procedimento_w, 
				nr_proc_interno_w, 
				ie_origem_proced_w, 
				ie_urgente_w, 
				qt_exame_w;
			EXIT WHEN NOT FOUND; /* apply on C01 */
				begin 
				 
				 
				cd_convenio_w := obter_convenio_atendimento(nr_Atendimento_w);
				 
				if (nr_seq_exame_w IS NOT NULL AND nr_seq_exame_w::text <> '') then 
				 
					 
				 
					insert into agenda_lista_espera( 
						nr_sequencia, 
						nr_seq_exame, 
						ie_urgente, 
						qt_procedimento, 
						nm_tabela_pedido, 
						nr_seq_pedido, 
						cd_pessoa_fisica, 
						dt_agendamento, 
						dt_atualizacao, 
						dt_atualizacao_nrec, 
						dt_desejada, 
						ie_status_espera, 
						nm_usuario_agenda, 
						nm_usuario, 
						nm_usuario_nrec, 
						cd_convenio) 
					values ( 
						nextval('agenda_lista_espera_seq'), 
						nr_seq_exame_w, 
						ie_urgente_w, 
						qt_exame_w, 
						nm_tabela_pedido_p, 
						nr_seq_pedido_p, 
						cd_pessoa_fisica_w, 
						clock_timestamp(), 
						clock_timestamp(), 
						clock_timestamp(), 
						clock_timestamp(), 
						'A', 
						nm_usuario_p, 
						nm_usuario_p, 
						nm_usuario_p, 
						cd_convenio_w);
				end if;
 
				if (nr_seq_exame_lab_w IS NOT NULL AND nr_seq_exame_lab_w::text <> '') then 
					insert into agenda_lista_espera( 
						nr_sequencia, 
						nr_seq_exame_lab, 
						cd_material_exame, 
						ie_urgente, 
						qt_procedimento, 
						nm_tabela_pedido, 
						nr_seq_pedido, 
						cd_pessoa_fisica, 
						dt_agendamento, 
						dt_atualizacao, 
						dt_atualizacao_nrec, 
						dt_desejada, 
						ie_status_espera, 
						nm_usuario_agenda, 
						nm_usuario, 
						nm_usuario_nrec, 
						cd_convenio) 
					values ( 
						nextval('agenda_lista_espera_seq'), 
						nr_seq_exame_lab_w, 
						cd_material_exame_w, 
						ie_urgente_w, 
						qt_exame_w, 
						nm_tabela_pedido_p, 
						nr_seq_pedido_p, 
						cd_pessoa_fisica_w, 
						clock_timestamp(), 
						clock_timestamp(), 
						clock_timestamp(), 
						clock_timestamp(), 
						'A', 
						nm_usuario_p, 
						nm_usuario_p, 
						nm_usuario_p, 
						cd_convenio_w);
				end if;
 
				if (ds_exame_sem_cad_w IS NOT NULL AND ds_exame_sem_cad_w::text <> '') then 
					insert into agenda_lista_espera( 
						nr_sequencia, 
						ds_exame_sem_cad, 
						ie_urgente, 
						qt_procedimento, 
						nm_tabela_pedido, 
						nr_seq_pedido, 
						cd_pessoa_fisica, 
						dt_agendamento, 
						dt_atualizacao, 
						dt_atualizacao_nrec, 
						dt_desejada, 
						ie_status_espera, 
						nm_usuario_agenda, 
						nm_usuario, 
						nm_usuario_nrec, 
						cd_convenio) 
					values ( 
						nextval('agenda_lista_espera_seq'), 
						ds_exame_sem_cad_w, 
						ie_urgente_w, 
						qt_exame_w, 
						nm_tabela_pedido_p, 
						nr_seq_pedido_p, 
						cd_pessoa_fisica_w, 
						clock_timestamp(), 
						clock_timestamp(), 
						clock_timestamp(), 
						clock_timestamp(), 
						'A', 
						nm_usuario_p, 
						nm_usuario_p, 
						nm_usuario_p, 
						cd_convenio_w);
				end if;
 
				if (cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '') then 
					insert into agenda_lista_espera( 
						nr_sequencia, 
						cd_procedimento, 
						ie_origem_proced, 
						ie_urgente, 
						qt_procedimento, 
						nm_tabela_pedido, 
						nr_seq_pedido, 
						cd_pessoa_fisica, 
						dt_agendamento, 
						dt_atualizacao, 
						dt_atualizacao_nrec, 
						dt_desejada, 
						ie_status_espera, 
						nm_usuario_agenda, 
						nm_usuario, 
						nm_usuario_nrec, 
						cd_convenio) 
					values ( 
						nextval('agenda_lista_espera_seq'), 
						cd_procedimento_w, 
						ie_origem_proced_w, 
						ie_urgente_w, 
						qt_exame_w, 
						nm_tabela_pedido_p, 
						nr_seq_pedido_p, 
						cd_pessoa_fisica_w, 
						clock_timestamp(), 
						clock_timestamp(), 
						clock_timestamp(), 
						clock_timestamp(), 
						'A', 
						nm_usuario_p, 
						nm_usuario_p, 
						nm_usuario_p, 
						cd_convenio_w);
				end if;
 
				if (nr_proc_interno_w IS NOT NULL AND nr_proc_interno_w::text <> '') then 
					insert into agenda_lista_espera( 
						nr_sequencia, 
						nr_seq_proc_interno, 
						ie_urgente, 
						qt_procedimento, 
						nm_tabela_pedido, 
						nr_seq_pedido, 
						cd_pessoa_fisica, 
						dt_agendamento, 
						dt_atualizacao, 
						dt_atualizacao_nrec, 
						dt_desejada, 
						ie_status_espera, 
						nm_usuario_agenda, 
						nm_usuario, 
						nm_usuario_nrec, 
						cd_convenio) 
					values ( 
						nextval('agenda_lista_espera_seq'), 
						nr_proc_interno_w, 
						ie_urgente_w, 
						qt_exame_w, 
						nm_tabela_pedido_p, 
						nr_seq_pedido_p, 
						cd_pessoa_fisica_w, 
						clock_timestamp(), 
						clock_timestamp(), 
						clock_timestamp(), 
						clock_timestamp(), 
						'A', 
						nm_usuario_p, 
						nm_usuario_p, 
						nm_usuario_p, 
						cd_convenio_w);
				end if;
				end;
			end loop;
			close C01;
		end if;	
		 
	end if;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_lista_espera_pep ( nr_seq_pedido_p bigint, nm_tabela_pedido_p text, nm_usuario_p text) FROM PUBLIC;

