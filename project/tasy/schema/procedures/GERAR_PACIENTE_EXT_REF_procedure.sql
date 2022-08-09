-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_paciente_ext_ref ( nr_atendimento_p bigint, nr_sequencia_p text) AS $body$
DECLARE

									
cd_medico_referido_w atendimento_paciente.cd_medico_referido%Type;
cd_cgc_indicacao_w atendimento_paciente.cd_cgc_indicacao%Type;


BEGIN
	select cd_medico_referido, cd_cgc_indicacao
	into STRICT cd_medico_referido_w, cd_cgc_indicacao_w
	from atendimento_paciente
	where nr_atendimento = nr_atendimento_p;
		
	insert into encounter_ref_rec(	nr_sequencia,
					nr_atendimento,
					dt_atualizacao, 
					nm_usuario, 
					dt_atualizacao_nrec, 
					nm_usuario_nrec,
					dt_liberacao,
					ie_situacao,
					cd_medico,
					cd_cgc,
					nr_seq_atend
					) values (
					nextval('encounter_ref_rec_seq'),
					nr_atendimento_p,
					clock_timestamp(),
					wheb_usuario_pck.get_nm_usuario,
					clock_timestamp(),
					wheb_usuario_pck.get_nm_usuario,
					clock_timestamp(),
					'A',
					cd_medico_referido_w,
					cd_cgc_indicacao_w,
					nr_sequencia_p);
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_paciente_ext_ref ( nr_atendimento_p bigint, nr_sequencia_p text) FROM PUBLIC;
