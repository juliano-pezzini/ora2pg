-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE insert_block_procedures (nr_atendimento_p PROC_ATEND_BLOQ_MEDICO.NR_ATENDIMENTO%type, nr_prescricao_p PROC_ATEND_BLOQ_MEDICO.NR_PRESCRICAO%type, nr_seq_prescricao_p PROC_ATEND_BLOQ_MEDICO.NR_SEQ_PRESCRICAO%type, nm_usuario_p PROC_ATEND_BLOQ_MEDICO.NM_USUARIO%type) AS $body$
BEGIN

  insert into PROC_ATEND_BLOQ_MEDICO(NR_SEQUENCIA,
                                      DT_ATUALIZACAO,
                                      NM_USUARIO,
                                      DT_ATUALIZACAO_NREC,
                                      NM_USUARIO_NREC,
                                      NR_ATENDIMENTO,
                                      NR_PRESCRICAO,
                                      NR_SEQ_PRESCRICAO)
                              values (nextval('proc_atend_bloq_medico_seq'),
                                      clock_timestamp(),
                                      nm_usuario_p,
                                      clock_timestamp(),
                                      nm_usuario_p,
                                      nr_atendimento_p,
                                      nr_prescricao_p,
                                      nr_seq_prescricao_p);

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE insert_block_procedures (nr_atendimento_p PROC_ATEND_BLOQ_MEDICO.NR_ATENDIMENTO%type, nr_prescricao_p PROC_ATEND_BLOQ_MEDICO.NR_PRESCRICAO%type, nr_seq_prescricao_p PROC_ATEND_BLOQ_MEDICO.NR_SEQ_PRESCRICAO%type, nm_usuario_p PROC_ATEND_BLOQ_MEDICO.NM_USUARIO%type) FROM PUBLIC;

