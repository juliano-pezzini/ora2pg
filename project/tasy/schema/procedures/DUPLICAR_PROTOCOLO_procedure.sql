-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duplicar_protocolo ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE

				
nr_seq_protocolo_w	bigint;
nr_seq_fase_w	bigint;
nr_seq_campo_prot_w	bigint;
				

BEGIN
	if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
		
		select nextval('rxt_protocolo_seq')
		into STRICT nr_seq_protocolo_w
		;
		
		insert into rxt_protocolo(
			nr_sequencia,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			dt_atualizacao,
			nm_usuario,
			nm_protocolo,
			nr_seq_tipo,
			nr_seq_equipamento,
			ie_situacao,
			qt_dose_total,
			qt_check_film,
			ie_frequencia
			)
		SELECT	nr_seq_protocolo_w,
			clock_timestamp(),
			nm_usuario_p,
			dt_atualizacao,
			nm_usuario_p,
			substr(wheb_mensagem_pck.get_texto(285929) || nm_protocolo,1,80),
			nr_seq_tipo,
			nr_seq_equipamento,
			ie_situacao,
			qt_dose_total,
			qt_check_film,
			ie_frequencia
		from	rxt_protocolo
		where	nr_sequencia = nr_sequencia_p;	
		
		insert into rxt_protocolo_acessorio(nr_sequencia,
			nr_seq_protocolo,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_acessorio,
			nr_seq_campo)
		SELECT nextval('rxt_protocolo_acessorio_seq'),
			nr_seq_protocolo_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_acessorio,
			nr_seq_campo
		from rxt_protocolo_acessorio
		where nr_seq_protocolo = nr_seq_protocolo_w;

		insert into rxt_volume_protocolo(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_protocolo,
			nr_seq_volume,
			ds_volume)
		SELECT nextval('rxt_volume_protocolo_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_protocolo,
			nr_seq_volume,
			ds_volume
		from rxt_volume_protocolo
		where nr_seq_protocolo = nr_seq_protocolo_w;

		select nextval('rxt_campo_prot_roentgen_seq')
		into STRICT nr_seq_campo_prot_w
		;

		insert into rxt_campo_prot_roentgen(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nm_campo,
			qt_dia_trat,
			qt_dose_campo,
			qt_dose_dia,
			ds_protecao,
			nr_seq_protocolo,
			nr_seq_volume_protocolo)
		SELECT nr_seq_campo_prot_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nm_campo,
			qt_dia_trat,
			qt_dose_campo,
			qt_dose_dia,
			ds_protecao,
			nr_seq_protocolo,
			nr_seq_volume_protocolo
		from rxt_campo_prot_roentgen
		where nr_seq_protocolo = nr_seq_protocolo_w;

		insert into rxt_aplic_campo_prot_roent(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_kvp,
			nr_seq_ma,
			nr_seq_aplicador,
			ds_filtro_kvp,
			ds_info_adic_kvp,
			ds_info_adic_ma,
			nr_seq_campo_prot,
			nr_minuto_duracao,
			qt_tamanho_x,
			qt_tamanho_y,
			nr_segundo_duracao)
		SELECT nextval('rxt_aplic_campo_prot_roent_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_kvp,
			nr_seq_ma,
			nr_seq_aplicador,
			ds_filtro_kvp,
			ds_info_adic_kvp,
			ds_info_adic_ma,
			nr_seq_campo_prot,
			nr_minuto_duracao,
			qt_tamanho_x,
			qt_tamanho_y,
			nr_segundo_duracao
		from rxt_aplic_campo_prot_roent
		where nr_seq_campo_prot = nr_seq_campo_prot_w;

		insert into rxt_imagem_prot_roent(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			ds_titulo,
			ds_arquivo,
			nr_seq_campo_prot)
		SELECT nextval('rxt_imagem_prot_roent_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			ds_titulo,
			ds_arquivo,
			nr_seq_campo_prot
		from rxt_imagem_prot_roent
		where nr_seq_campo_prot = nr_seq_campo_prot_w;

		insert into rxt_braq_aplic_prot(nr_sequencia,
			cd_estabelecimento,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			ie_situacao,
			nr_seq_protocolo,
			nr_seq_aplicador,
			nr_insercao,
			qt_dose_total,
			qt_dose_insercao,
			qt_insercao_semana,				
			qt_intervalo_insercoes,
			nr_ordem_execucao_aplic)
		SELECT nextval('rxt_braq_aplic_prot_seq'),
			cd_estabelecimento,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			ie_situacao,
			nr_seq_protocolo,
			nr_seq_aplicador,
			nr_insercao,
			qt_dose_total,
			qt_dose_insercao,
			qt_insercao_semana,				
			qt_intervalo_insercoes,
			nr_ordem_execucao_aplic	
		from rxt_braq_aplic_prot
		where nr_seq_protocolo = nr_seq_protocolo_w;

		insert into rxt_campo_protocolo(nr_sequencia,
			nr_seq_protocolo,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			ds_campo,
			ie_situacao,
			nr_seq_apresent)
		SELECT nextval('rxt_campo_protocolo_seq'),
			nr_seq_protocolo_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			ds_campo,
			ie_situacao,
			nr_seq_apresent
		from rxt_campo_protocolo
		where nr_seq_protocolo = nr_seq_protocolo_w;

		insert into rxt_protocolo_acessorio(nr_sequencia,
			nr_seq_protocolo,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_acessorio,
			nr_seq_campo)
		SELECT nextval('rxt_protocolo_acessorio_seq'),
			nr_seq_protocolo_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_acessorio,
			nr_seq_campo
		from rxt_protocolo_acessorio
		where nr_seq_protocolo = nr_seq_protocolo_w;

		select nextval('rxt_fase_protocolo_seq')
		into STRICT nr_seq_fase_w
		;		

		insert into rxt_fase_protocolo(nr_sequencia,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			dt_atualizacao,
			nm_usuario,
			nr_seq_protocolo,
			nm_fase, qt_dose_fase,
			ie_final_semana,
			qt_dia_trat,
			qt_dose_dia,
			nr_seq_decubito,
			nr_seq_volume_protocolo,
			qt_intervalo)
		SELECT nr_seq_fase_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_protocolo_w,
			nm_fase,
			qt_dose_fase,
			ie_final_semana,
			qt_dia_trat,
			qt_dose_dia,
			nr_seq_decubito,
			nr_seq_volume_protocolo,
			qt_intervalo
		from rxt_fase_protocolo
		where nr_seq_protocolo = nr_seq_protocolo_w;

		insert into rxt_campo_fase_prot(nr_sequencia,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			dt_atualizacao,
			nm_usuario,
			nr_seq_fase,
			nr_seq_apres,
			nr_seq_campo,
			qt_dose_total,
			qt_dose_fracao)
		SELECT nextval('rxt_campo_fase_prot_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_fase,
			nr_seq_apres,
			nr_seq_campo,
			qt_dose_total,
			qt_dose_fracao
		from rxt_campo_fase_prot
		where nr_seq_fase = nr_seq_fase_w;

		insert into rxt_protocolo_proc_exec(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_proc_interno,
			nr_seq_protocolo,
			cd_convenio,
			nr_seq_modalidade)
		SELECT nextval('rxt_protocolo_proc_exec_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_proc_interno,
			nr_seq_protocolo,
			cd_convenio,
			nr_seq_modalidade
		from rxt_protocolo_proc_exec
		where nr_seq_protocolo = nr_seq_protocolo_w;
		
		commit;
	end if;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duplicar_protocolo ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

