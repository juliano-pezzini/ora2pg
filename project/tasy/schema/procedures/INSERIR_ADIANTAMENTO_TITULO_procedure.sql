-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_adiantamento_titulo ( nr_adiantamento_p bigint, nr_seq_trans_fin_p bigint, nr_titulo_p bigint, vl_adiantamento_p bigint, nr_seq_p INOUT bigint, nm_usuario_p text) AS $body$
DECLARE

nr_seq_w	bigint;

BEGIN
if (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	select  	coalesce(max(a.nr_sequencia),0) + 1
	into STRICT	nr_seq_w
	from    	titulo_pagar_adiant a
	where   	nr_titulo   = nr_titulo_p;

	insert 	into titulo_pagar_adiant(dt_atualizacao,
		dt_contabil,
		nm_usuario,
		nr_adiantamento,
		nr_lote_contabil,
		nr_seq_trans_fin,
		nr_sequencia,
		nr_titulo,
		vl_adiantamento)
	values (clock_timestamp(),
		clock_timestamp(),
		nm_usuario_p,
		nr_adiantamento_p,
		0,
		nr_seq_trans_fin_p,
		nr_seq_w,
		nr_titulo_p,
		vl_adiantamento_p);
	commit;
	end;
end if;
nr_seq_p	:= nr_seq_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_adiantamento_titulo ( nr_adiantamento_p bigint, nr_seq_trans_fin_p bigint, nr_titulo_p bigint, vl_adiantamento_p bigint, nr_seq_p INOUT bigint, nm_usuario_p text) FROM PUBLIC;
