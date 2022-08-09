-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_prescr_medica_cid ( nm_usuario_p text, nr_prescricao_p bigint, cd_doenca_cid_p text, nr_seq_dieta_p bigint) AS $body$
DECLARE


nr_sequencia_w	bigint;


BEGIN

if (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (cd_doenca_cid_p IS NOT NULL AND cd_doenca_cid_p::text <> '') and (nr_seq_dieta_p IS NOT NULL AND nr_seq_dieta_p::text <> '') then

	select	nextval('prescr_medica_cid_seq')
	into STRICT	nr_sequencia_w
	;

	insert into prescr_medica_cid(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_prescricao,
		cd_doenca_cid,
		nr_seq_dieta)
	values (
		nr_sequencia_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_prescricao_p,
		cd_doenca_cid_p,
		nr_seq_dieta_p);
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_prescr_medica_cid ( nm_usuario_p text, nr_prescricao_p bigint, cd_doenca_cid_p text, nr_seq_dieta_p bigint) FROM PUBLIC;
