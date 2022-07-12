-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE generate_data_hcp_pkg.generate_hcp_content (nr_seq_dataset_p bigint, nr_atendimento_p bigint, nm_usuario_p text, dt_initial_date_ref_w timestamp, dt_end_date_ref_w timestamp) AS $body$
DECLARE

		ds_segment_w      varchar(32767);
		ds_segment_clob_w text := '';
	
BEGIN
		SELECT ac.cd_usuario_convenio /*Insurer  Membership Identifier*/
 
				|| generate_data_hcp_pkg.get_insurer_identifier(ac.cd_convenio) /*Insurer Identifier*/
 
				|| ap.nr_atendimento /* Episode Identifier */
 
		INTO STRICT	ds_segment_w 
		FROM	atendimento_paciente ap, 
				pessoa_fisica pf, 
				atend_categoria_convenio ac 
		WHERE	pf.cd_pessoa_fisica = ap.cd_pessoa_fisica 
		AND		ap.nr_atendimento = nr_atendimento_p;

		/* format clob data */
 
		SELECT	Concat(ds_segment_clob_w, ds_segment_w) 
		INTO STRICT	ds_segment_clob_w 
		;

		/* update clob data in table */
 
		UPDATE	hcp_dataset_send 
		SET		cd_record_type = 'HCP', 
				ds_dataset_contents = ds_segment_clob_w 
		WHERE	nr_sequencia = nr_seq_dataset_p;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE generate_data_hcp_pkg.generate_hcp_content (nr_seq_dataset_p bigint, nr_atendimento_p bigint, nm_usuario_p text, dt_initial_date_ref_w timestamp, dt_end_date_ref_w timestamp) FROM PUBLIC;
