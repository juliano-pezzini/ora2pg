-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_w_atend_pacote_partic ( nr_seq_w_atend_pac_p bigint, nr_sequencia_p bigint, nr_seq_partic_p bigint, ie_grid_p text, nm_usuario_p text, cd_medico_executor_p text) AS $body$
BEGIN

if (ie_grid_p = 'REGRA') then

	insert into w_atend_pacote_partic(
		NR_SEQUENCIA,
		NR_SEQ_W_ATEND_PAC,
		DT_ATUALIZACAO,
		NM_USUARIO,
		DT_ATUALIZACAO_NREC,
		NM_USUARIO_NREC,
		CD_MEDICO_EXECUTOR,
		CD_ESPECIALIDADE,
		IE_FUNCAO_MEDICO,
		VL_PARTICIPANTE,
		NR_SEQ_REGRA)
	SELECT 	nextval('w_atend_pacote_partic_seq'),
		nr_seq_w_atend_pac_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		cd_medico_executor_p,
		cd_especialidade,
		ie_funcao_medico,
		vl_participante,
		nr_sequencia
	from 	pacote_tipo_acomod_partic
	where 	nr_sequencia = nr_sequencia_p;


elsif (ie_grid_p = 'GATILHO') then

	insert into w_atend_pacote_partic(
		NR_SEQUENCIA,
		NR_SEQ_W_ATEND_PAC,
		DT_ATUALIZACAO,
		NM_USUARIO,
		DT_ATUALIZACAO_NREC,
		NM_USUARIO_NREC,
		CD_MEDICO_EXECUTOR,
		CD_ESPECIALIDADE,
		IE_FUNCAO_MEDICO,
		VL_PARTICIPANTE,
		NR_SEQ_PARTIC)
	SELECT 	nextval('w_atend_pacote_partic_seq'),
		nr_seq_w_atend_pac_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		cd_pessoa_fisica,
		cd_especialidade,
		ie_funcao,
		vl_participante,
		nr_seq_partic_p
	from 	procedimento_participante
	where 	nr_sequencia = nr_sequencia_p
	and 	nr_seq_partic = nr_seq_partic_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_w_atend_pacote_partic ( nr_seq_w_atend_pac_p bigint, nr_sequencia_p bigint, nr_seq_partic_p bigint, ie_grid_p text, nm_usuario_p text, cd_medico_executor_p text) FROM PUBLIC;
