-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lab_insert_laudo_paciente ( CD_PESSOA_FISICA_P bigint, CD_MEDICO_P bigint, DT_LAUDO_P timestamp, NR_ATENDIMENTO_P bigint, NR_SEQ_RESULTADO_P bigint, NR_SEQ_RESULTADO_W INOUT bigint ) AS $body$
BEGIN

if (nr_seq_resultado_p IS NOT NULL AND nr_seq_resultado_p::text <> '') then
  update IMAGEM_PAC_PROT_EXTERNO set
    DT_LIBERACAO = clock_timestamp()
    where nr_sequencia = NR_SEQ_RESULTADO_P;
  commit;
else
  insert into IMAGEM_PAC_PROT_EXTERNO(NR_SEQUENCIA,
    DT_ATUALIZACAO,
    CD_MEDICO,
    CD_PESSOA_FISICA,
    NR_ATENDIMENTO,
    NM_USUARIO,
    DT_LIBERACAO,
    DT_EXAME)
  values (
    nextval('imagem_pac_prot_externo_seq'),
    clock_timestamp(),
    CD_MEDICO_P,
    CD_PESSOA_FISICA_P,
    NR_ATENDIMENTO_P,
    wheb_usuario_pck.get_nm_usuario,
    clock_timestamp(),
    DT_LAUDO_P
  )
  returning NR_SEQUENCIA into NR_SEQ_RESULTADO_W;

  commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lab_insert_laudo_paciente ( CD_PESSOA_FISICA_P bigint, CD_MEDICO_P bigint, DT_LAUDO_P timestamp, NR_ATENDIMENTO_P bigint, NR_SEQ_RESULTADO_P bigint, NR_SEQ_RESULTADO_W INOUT bigint ) FROM PUBLIC;

