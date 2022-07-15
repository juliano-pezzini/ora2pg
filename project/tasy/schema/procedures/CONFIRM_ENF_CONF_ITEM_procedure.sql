-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE confirm_enf_conf_item ( nr_sequencia_p sumario_enf_conf_list.nr_sequencia%type, nm_aprovador_p sumario_enf_conf_list.nm_usuario%type, ie_nurse_sum_p text default null) AS $body$
DECLARE


nr_seq_conf_list_w sumario_enf_conf_list.nr_sequencia%type;
nr_seq_sum_enf_w sumario_enf_conf_list.nr_seq_sum_enf%type;


BEGIN
  if (ie_nurse_sum_p IS NOT NULL AND ie_nurse_sum_p::text <> '') then
    select nr_sequencia
    into STRICT nr_seq_conf_list_w
    from sumario_enf_conf_list
    where nr_seq_sum_enf = nr_sequencia_p;
  else
    nr_seq_conf_list_w := nr_sequencia_p;
  end if;

	update sumario_enf_conf_list
	set dt_aprovacao = clock_timestamp(),
		nm_aprovador = nm_aprovador_p
	where nr_sequencia = nr_seq_conf_list_w;

    update SUMARIO_ENFERMAGEM
	set DT_APPROVED = clock_timestamp()
	where nr_sequencia = nr_sequencia_p;

    select s.nr_seq_sum_enf
    into STRICT nr_seq_sum_enf_w
    from sumario_enf_conf_list s
    where s.nr_sequencia = nr_seq_conf_list_w;

    update SUMARIO_ENFERMAGEM
	set DT_APPROVED = clock_timestamp()
	where nr_sequencia = nr_seq_sum_enf_w;

  commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE confirm_enf_conf_item ( nr_sequencia_p sumario_enf_conf_list.nr_sequencia%type, nm_aprovador_p sumario_enf_conf_list.nm_usuario%type, ie_nurse_sum_p text default null) FROM PUBLIC;

