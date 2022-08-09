-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_solic_alter_dt_prevista ( dt_prevista_p timestamp, ds_motivo_p text, nr_seq_atendimento_p bigint) AS $body$
BEGIN
if (nr_seq_atendimento_p IS NOT NULL AND nr_seq_atendimento_p::text <> '') and (dt_prevista_p IS NOT NULL AND dt_prevista_p::text <> '') and (ds_motivo_p IS NOT NULL AND ds_motivo_p::text <> '') then

   update paciente_atendimento
   set    dt_solic_transf = dt_prevista_p,
          DS_SOLIC_TRANSF = ds_motivo_p
   where  nr_seq_atendimento = nr_seq_atendimento_p;
end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_solic_alter_dt_prevista ( dt_prevista_p timestamp, ds_motivo_p text, nr_seq_atendimento_p bigint) FROM PUBLIC;
