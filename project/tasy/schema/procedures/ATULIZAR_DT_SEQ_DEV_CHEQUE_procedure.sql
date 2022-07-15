-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atulizar_dt_seq_dev_cheque ( dt_seg_devolucao_p timestamp, nr_seq_cheque_p bigint, nm_usuario_p text) AS $body$
BEGIN
if (nr_seq_cheque_p IS NOT NULL AND nr_seq_cheque_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	update 	cheque_cr
	set    	dt_seg_devolucao = dt_seg_devolucao_p,
		nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp()
	where  	nr_seq_cheque = nr_seq_cheque_p;
	end;
end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atulizar_dt_seq_dev_cheque ( dt_seg_devolucao_p timestamp, nr_seq_cheque_p bigint, nm_usuario_p text) FROM PUBLIC;

