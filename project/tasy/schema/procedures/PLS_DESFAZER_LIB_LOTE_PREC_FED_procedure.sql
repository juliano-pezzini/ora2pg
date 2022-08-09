-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_desfazer_lib_lote_prec_fed (nr_seq_lote_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_pre_imp_w		bigint;
nr_seq_preco_w			bigint;
ie_situacao_w			varchar(1);
ie_situacao_ant_w		varchar(1);

C01 CURSOR FOR
	SELECT	nr_sequencia,
		ie_situacao,
		ie_situacao_ant,
		nr_seq_preco
	from	pls_mat_uni_sc_pre_imp
	where	nr_seq_lote = nr_seq_lote_p
	and	ie_inconsistente = 'N';


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_pre_imp_w,
	ie_situacao_w,
	ie_situacao_ant_w,
	nr_seq_preco_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	if (coalesce(ie_situacao_ant_w::text, '') = '') then
		update	pls_mat_uni_sc_pre_imp
		set	nr_seq_preco	 = NULL
		where	nr_sequencia	= nr_seq_pre_imp_w;

		delete	FROM pls_mat_uni_fed_sc_preco
		where	nr_sequencia	= nr_seq_preco_w;
	else
		update	pls_mat_uni_fed_sc_preco
		set	ie_situacao	= ie_situacao_ant_w
		where	nr_sequencia	= nr_seq_preco_w;
	end if;
	end;
end loop;
close C01;

update	pls_lote_preco_unimed_sc
set	dt_liberacao	 = NULL,
	nm_usuario	= nm_usuario_p,
	dt_atualizacao	= clock_timestamp()
where	nr_sequencia	= nr_seq_lote_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_desfazer_lib_lote_prec_fed (nr_seq_lote_p bigint, nm_usuario_p text) FROM PUBLIC;
