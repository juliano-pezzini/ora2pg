-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_transferencia_cme ( nr_seq_origem_p bigint, nr_seq_conjunto_p bigint, nm_usuario_p text, ie_origem_inf_p text, ie_status_cme_p text) AS $body$
BEGIN

update	agenda_pac_cme
set	ie_status_cme 	= ie_status_cme_p,
	nm_usuario 	= nm_usuario_p,
	dt_atualizacao 	= clock_timestamp(),
	ie_origem_inf	= ie_origem_inf_p
where	nr_seq_agenda	= nr_seq_origem_p
and 	nr_seq_conjunto	= nr_seq_conjunto_p;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_transferencia_cme ( nr_seq_origem_p bigint, nr_seq_conjunto_p bigint, nm_usuario_p text, ie_origem_inf_p text, ie_status_cme_p text) FROM PUBLIC;
