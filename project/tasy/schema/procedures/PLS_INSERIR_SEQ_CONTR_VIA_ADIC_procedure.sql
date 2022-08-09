-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_inserir_seq_contr_via_adic ( nm_usuario_p text, nr_seq_lote_p bigint, nr_contrato_p bigint) AS $body$
DECLARE


nr_seq_contrato_w	bigint	:= null;


BEGIN

if (coalesce(nr_contrato_p,0) <> 0) then
	select	nr_sequencia
	into STRICT	nr_seq_contrato_w
	from	pls_contrato
	where	nr_contrato	= nr_contrato_p;
else
	nr_seq_contrato_w	:= null;
end if;

update	pls_via_adic_cart_lote
set 	nr_seq_contrato	= nr_seq_contrato_w
where	nr_sequencia	= nr_seq_lote_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_inserir_seq_contr_via_adic ( nm_usuario_p text, nr_seq_lote_p bigint, nr_contrato_p bigint) FROM PUBLIC;
