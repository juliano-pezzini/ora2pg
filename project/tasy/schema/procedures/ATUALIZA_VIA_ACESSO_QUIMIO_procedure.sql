-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_via_acesso_quimio ( nr_seq_via_acesso_p bigint, nr_seq_interno_p bigint, nr_seq_atendimento_p bigint, ie_via_aplicacao_p text, atualizar_todos_p text) AS $body$
BEGIN

if (nr_seq_via_acesso_p IS NOT NULL AND nr_seq_via_acesso_p::text <> '') and (nr_seq_interno_p IS NOT NULL AND nr_seq_interno_p::text <> '') and (nr_seq_atendimento_p IS NOT NULL AND nr_seq_atendimento_p::text <> '') and (ie_via_aplicacao_p IS NOT NULL AND ie_via_aplicacao_p::text <> '') and (atualizar_todos_p IS NOT NULL AND atualizar_todos_p::text <> '') then

  update	paciente_atend_medic
  set	nr_seq_via_acesso	= nr_seq_via_acesso_p
  where	nr_seq_atendimento = nr_seq_atendimento_p
  and (atualizar_todos_p = 'S' or nr_seq_interno = nr_seq_interno_p)
  and	coalesce(nr_seq_diluicao::text, '') = ''
  and	ie_via_aplicacao	= ie_via_aplicacao_p;

  commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_via_acesso_quimio ( nr_seq_via_acesso_p bigint, nr_seq_interno_p bigint, nr_seq_atendimento_p bigint, ie_via_aplicacao_p text, atualizar_todos_p text) FROM PUBLIC;

