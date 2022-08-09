-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE vincular_nf_venc_contrato ( nr_seq_vencimento_p bigint, nr_seq_nf_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_nota_w	bigint;


BEGIN

select	coalesce(max(nr_seq_nota),0)
into STRICT	nr_seq_nota_w
from	contrato_venc
where	nr_sequencia = nr_seq_vencimento_p;

if (nr_seq_nota_w = 0) then
	update	contrato_venc
	set	dt_atualizacao 	= clock_timestamp(),
		nm_usuario	= nm_usuario_p,
		nr_seq_nota	= nr_seq_nf_p
	where	nr_sequencia	= nr_seq_vencimento_p;
elsif (nr_seq_nota_w > 0) then
	update	contrato_venc
	set	dt_atualizacao 	= clock_timestamp(),
		nm_usuario	= nm_usuario_p,
		nr_seq_nota	 = NULL
	where	nr_sequencia	= nr_seq_vencimento_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE vincular_nf_venc_contrato ( nr_seq_vencimento_p bigint, nr_seq_nf_p bigint, nm_usuario_p text) FROM PUBLIC;
