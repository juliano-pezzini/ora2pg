-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fa_alterar_status_entrega_js ( nr_sequencia_p bigint, nr_seq_entrega_p bigint, nr_seq_entrega_item_p bigint, ie_status_medicacao_p text, ie_separacao_medic_p INOUT text) AS $body$
BEGIN

	CALL fa_alterar_status_entrega(nr_seq_entrega_p, nr_seq_entrega_item_p, ie_status_medicacao_p);

	ie_separacao_medic_p := obter_se_separacao_medic(nr_sequencia_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fa_alterar_status_entrega_js ( nr_sequencia_p bigint, nr_seq_entrega_p bigint, nr_seq_entrega_item_p bigint, ie_status_medicacao_p text, ie_separacao_medic_p INOUT text) FROM PUBLIC;
