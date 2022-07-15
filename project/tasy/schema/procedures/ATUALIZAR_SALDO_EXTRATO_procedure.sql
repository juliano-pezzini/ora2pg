-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_saldo_extrato (nr_seq_extrato_p bigint, nm_usuario_p text) AS $body$
DECLARE


vl_credito_w		double precision;
vl_debito_w		double precision;
vl_saldo_atual_w	double precision;
vl_saldo_final_w	double precision;


BEGIN

select	sum(a.vl_lancamento)
into STRICT	vl_credito_w
from	banco_extrato_lanc a
where	a.ie_deb_cred		= 'C'
and	a.nr_seq_extrato	= nr_seq_Extrato_p;

select	sum(a.vl_lancamento)
into STRICT	vl_debito_w
from	banco_extrato_lanc a
where	a.ie_deb_cred		= 'D'
and	a.nr_seq_extrato	= nr_seq_Extrato_p;

select	max(a.vl_saldo_inicial)
into STRICT	vl_saldo_atual_w
from	banco_extrato a
where	nr_sequencia	= nr_seq_extrato_p;

vl_saldo_final_w	:= coalesce(vl_saldo_atual_w,0) + coalesce(vl_credito_w,0) - coalesce(vl_debito_w,0);

update	banco_extrato
set	vl_saldo_final	= coalesce(vl_saldo_final_w,0),
	dt_atualizacao	= clock_timestamp(),
	nm_usuario	= nm_usuario_p
where	nr_sequencia	= nr_seq_extrato_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_saldo_extrato (nr_seq_extrato_p bigint, nm_usuario_p text) FROM PUBLIC;

