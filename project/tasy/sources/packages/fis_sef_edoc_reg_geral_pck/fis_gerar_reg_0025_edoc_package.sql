-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE fis_sef_edoc_reg_geral_pck.fis_gerar_reg_0025_edoc () AS $body$
DECLARE


nr_seq_fis_sef_edoc_0025_w	fis_sef_edoc_0025.nr_sequencia%type;


BEGIN

/*Pega a sequencia da taleba fis_sef_edoc_0025 para o insert*/

select	nextval('fis_sef_edoc_0025_seq')
into STRICT	nr_seq_fis_sef_edoc_0025_w
;

insert into fis_sef_edoc_0025(	nr_sequencia,
					dt_atualizacao,
					dt_atualizacao_nrec,
					nm_usuario,
					nm_usuario_nrec,
					cd_reg,
					cd_bf_icms,
					cd_bf_iss,
					nr_seq_controle
					)
			values (	nr_seq_fis_sef_edoc_0025_w,
					clock_timestamp(),
					clock_timestamp(),
					current_setting('fis_sef_edoc_reg_geral_pck.nm_usuario_w')::usuario.nm_usuario%type,
					current_setting('fis_sef_edoc_reg_geral_pck.nm_usuario_w')::usuario.nm_usuario%type,
					'0025',
					'PE001',
					null,
					current_setting('fis_sef_edoc_reg_geral_pck.nr_seq_controle_w')::fis_sef_edoc_controle.nr_sequencia%type
					);

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_sef_edoc_reg_geral_pck.fis_gerar_reg_0025_edoc () FROM PUBLIC;