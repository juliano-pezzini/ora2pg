-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE disconfirm_enf_conf_item (nr_sequence_p sumario_enf_conf_list.nr_sequencia%type, ds_disconfirm_reason_p sumario_enf_conf_list.ds_motivo%type) AS $body$
BEGIN
	update sumario_enf_conf_list
	set dt_aprovacao  = NULL,
		nm_aprovador  = NULL,
		dt_canc_aprovacao = clock_timestamp(),
		ds_motivo = ds_disconfirm_reason_p
	where nr_sequencia = nr_sequence_p;
    commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE disconfirm_enf_conf_item (nr_sequence_p sumario_enf_conf_list.nr_sequencia%type, ds_disconfirm_reason_p sumario_enf_conf_list.ds_motivo%type) FROM PUBLIC;
