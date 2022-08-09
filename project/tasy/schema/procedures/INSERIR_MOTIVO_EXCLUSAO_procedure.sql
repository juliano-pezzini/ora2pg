-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_motivo_exclusao ( cd_motivo_exclusao_p bigint, cd_procedimento_p bigint, nr_seq_exame_p bigint, nr_prescricao_p bigint, ie_origem_proced_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w bigint;

BEGIN

--nr_sequencia_w := log_proc_motivo_exclusao_seq.nextval;
insert into log_proc_motivo_exclusao(
			 nr_sequencia,
			 cd_motivo_exclusao,
			 cd_procedimento,
			 nr_seq_exame,
			 dt_atualizacao_nrec,
			 nm_usuario_nrec,
			 nr_prescricao,
			 ie_origem_proced
		 )
			values (
			 nextval('log_proc_motivo_exclusao_seq'),
			 cd_motivo_exclusao_p,
			 cd_procedimento_p,
			 nr_seq_exame_p,
			 clock_timestamp(),
			 nm_usuario_p,
			 nr_prescricao_p,
			 ie_origem_proced_p
			 );

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_motivo_exclusao ( cd_motivo_exclusao_p bigint, cd_procedimento_p bigint, nr_seq_exame_p bigint, nr_prescricao_p bigint, ie_origem_proced_p bigint, nm_usuario_p text) FROM PUBLIC;
