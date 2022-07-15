-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE apae_vincular_cirurgia (nr_sequencia_p aval_pre_anestesica.nr_sequencia%type, nr_cirurgia_p aval_pre_anestesica.nr_cirurgia%type, nr_atendimento_p aval_pre_anestesica.nr_atendimento%type, nr_seq_proc_interno_p aval_pre_anestesica.nr_seq_proc_interno%type, cd_medico_cirurgiao_p aval_pre_anestesica.cd_medico%type, nm_usuario_p aval_pre_anestesica.nm_usuario%type) AS $body$
BEGIN

  if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (nr_cirurgia_p IS NOT NULL AND nr_cirurgia_p::text <> '') then

    update aval_pre_anestesica
       set nr_cirurgia    = nr_cirurgia_p,
           nr_atendimento = nr_atendimento_p,
           nm_usuario     = nm_usuario_p,
           cd_medico      = cd_medico_cirurgiao_p,
           nr_seq_proc_interno  = nr_seq_proc_interno_p,
           dt_atualizacao = clock_timestamp()
     where nr_sequencia = nr_sequencia_p;

    commit;

  end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE apae_vincular_cirurgia (nr_sequencia_p aval_pre_anestesica.nr_sequencia%type, nr_cirurgia_p aval_pre_anestesica.nr_cirurgia%type, nr_atendimento_p aval_pre_anestesica.nr_atendimento%type, nr_seq_proc_interno_p aval_pre_anestesica.nr_seq_proc_interno%type, cd_medico_cirurgiao_p aval_pre_anestesica.cd_medico%type, nm_usuario_p aval_pre_anestesica.nm_usuario%type) FROM PUBLIC;

