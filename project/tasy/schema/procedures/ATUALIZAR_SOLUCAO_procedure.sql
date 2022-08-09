-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_solucao ( nr_prescricao_p bigint, ie_suspender_p text) AS $body$
BEGIN

update	prescr_solucao
set	ie_suspender = ie_suspender_p
where	nr_prescricao = nr_prescricao_p
and	substr(obter_status_solucao_prescr(1, nr_prescricao, nr_seq_solucao),1,3) in ('R','I');

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_solucao ( nr_prescricao_p bigint, ie_suspender_p text) FROM PUBLIC;
