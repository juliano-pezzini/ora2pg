-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE retira_item_ciclo ( nr_sequencia_p bigint, ie_aba_p text, nm_usuario_p text) AS $body$
DECLARE


/*
ie_aba_p
C = Ciclo;
CL = Ciclo lavadora;
*/
BEGIN
if (coalesce(nr_sequencia_p,0) > 0) then

	if (ie_aba_p = 'C') then

		update  cm_conjunto_cont
		set     nr_seq_ciclo  = NULL,
		          dt_atualizacao = clock_timestamp(),
		          dt_validade  = NULL,
		          nm_usuario = nm_usuario_p
		where   nr_sequencia = nr_sequencia_p;

	elsif (ie_aba_p = 'CL') then

		update	cm_conjunto_cont
		set	nr_seq_ciclo_lav  = NULL,
		                nm_usuario = nm_usuario_p,
			dt_atualizacao = clock_timestamp()
		where	nr_sequencia = nr_sequencia_p;

	end if;

end if;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE retira_item_ciclo ( nr_sequencia_p bigint, ie_aba_p text, nm_usuario_p text) FROM PUBLIC;
