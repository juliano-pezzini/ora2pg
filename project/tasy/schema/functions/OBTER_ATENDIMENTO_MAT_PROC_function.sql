-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_atendimento_mat_proc ( nr_seq_mat_proc_p bigint, ie_mat_proc_p text) RETURNS bigint AS $body$
DECLARE


nr_atendimento_w bigint;


BEGIN
if (ie_mat_proc_p = '1') then -- material
  select nr_atendimento
  into STRICT   nr_atendimento_w
  from   material_atend_paciente
  where  nr_sequencia = nr_seq_mat_proc_p;
elsif (ie_mat_proc_p = '2') then -- procedimento
  select nr_atendimento
  into STRICT   nr_atendimento_w
  from   procedimento_paciente
  where  nr_sequencia = nr_seq_mat_proc_p;
end if;

return nr_atendimento_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_atendimento_mat_proc ( nr_seq_mat_proc_p bigint, ie_mat_proc_p text) FROM PUBLIC;
