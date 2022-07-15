-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE negar_antecip_result ( nr_prescricao_p bigint, nr_seq_prescr_p bigint, nm_usuario_p text) AS $body$
BEGIN
update 	prescr_procedimento
set	dt_antecipa_result  = NULL,
	nm_usuario_antecipacao = nm_usuario_p
where 	nr_prescricao 	= nr_prescricao_p
and 	nr_sequencia 	= nr_seq_prescr_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE negar_antecip_result ( nr_prescricao_p bigint, nr_seq_prescr_p bigint, nm_usuario_p text) FROM PUBLIC;

