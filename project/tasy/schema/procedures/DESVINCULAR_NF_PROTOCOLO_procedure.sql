-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE desvincular_nf_protocolo ( nr_seq_protocolo_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_nf_w		bigint;

c01 CURSOR FOR
	SELECT	nr_sequencia
	from	nota_fiscal
	where	nr_seq_protocolo = nr_seq_protocolo_p
	and 	ie_situacao in ('2','3') -- Estorno e Estornadas
	order by 1;


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_nf_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	update	nota_fiscal
	set	nr_seq_protocolo 	 = NULL,
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp()
	where	nr_sequencia 		= nr_seq_nf_w;

	CALL gerar_historico_nota_fiscal(nr_seq_nf_w, nm_usuario_p, '32', wheb_mensagem_pck.get_texto(799367,'NR_SEQ_PROTOCOLO=' || nr_seq_protocolo_p));

	end;
	end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE desvincular_nf_protocolo ( nr_seq_protocolo_p bigint, nm_usuario_p text) FROM PUBLIC;

