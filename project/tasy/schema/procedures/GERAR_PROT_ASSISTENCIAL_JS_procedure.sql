-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_prot_assistencial_js ( nr_atendimento_p bigint, nm_usuario_p text, nr_seq_resultado_p bigint, nr_sequencia_p bigint) AS $body$
DECLARE


jobno	bigint;
joblog varchar(255);


BEGIN

    if nr_seq_resultado_p > 0 then

		joblog := '  GQA_Aprov_Exame_result_item_js('''|| nr_seq_resultado_p || ''',''' ||nr_sequencia_p ||''','''|| nm_usuario_p ||''');';

		dbms_job.submit(jobno, joblog);

    end if;

    if nr_atendimento_p > 0 then

        joblog := ' gera_protocolo_assistencial('''|| nr_atendimento_p || ''',''' || nm_usuario_p ||''');';

        dbms_job.submit(jobno, joblog);

    end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_prot_assistencial_js ( nr_atendimento_p bigint, nm_usuario_p text, nr_seq_resultado_p bigint, nr_sequencia_p bigint) FROM PUBLIC;
