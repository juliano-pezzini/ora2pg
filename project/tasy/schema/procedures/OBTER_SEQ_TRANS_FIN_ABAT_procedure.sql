-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_seq_trans_fin_abat ( nr_seq_trans_receber_p INOUT bigint, nr_seq_trans_pagar_p INOUT bigint, cd_estabelecimento_p bigint) AS $body$
DECLARE

nr_seq_trans_receber_w	bigint;
nr_seq_trans_pagar_w	bigint;

BEGIN
if (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') then
	begin
	select 	nr_seq_trans_fin_abat
	into STRICT	nr_seq_trans_receber_w
	from 	parametro_contas_receber
	where 	cd_estabelecimento = cd_estabelecimento_p;

	select 	nr_seq_trans_fin_abat
	into STRICT 	nr_seq_trans_pagar_w
	from 	parametros_contas_pagar
	where 	cd_estabelecimento = cd_estabelecimento_p;
	end;
end if;
nr_seq_trans_receber_p	:= 	nr_seq_trans_receber_w;
nr_seq_trans_pagar_p	:=	nr_seq_trans_pagar_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_seq_trans_fin_abat ( nr_seq_trans_receber_p INOUT bigint, nr_seq_trans_pagar_p INOUT bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
