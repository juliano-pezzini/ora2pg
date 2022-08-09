-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_os_confirmar_rev_hist ( nr_seq_ordem_serv_p bigint, nr_seq_historico_p bigint, nm_usuario_p text ) AS $body$
DECLARE


nr_seq_prox_estag_w			bigint;


BEGIN

	update	man_ordem_serv_tecnico
	set		nm_revisor_hist = nm_usuario_p,
			dt_revisao_hist = clock_timestamp()
	where	nr_sequencia = nr_seq_historico_p;

	commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_os_confirmar_rev_hist ( nr_seq_ordem_serv_p bigint, nr_seq_historico_p bigint, nm_usuario_p text ) FROM PUBLIC;
