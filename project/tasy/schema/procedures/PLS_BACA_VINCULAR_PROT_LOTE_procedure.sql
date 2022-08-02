-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_baca_vincular_prot_lote () AS $body$
DECLARE


nr_seq_lote_conta_w		bigint;
nr_seq_prestador_w		bigint;
cd_estabelecimento_w		bigint;
nr_seq_prestador_web_w		bigint;
nr_seq_lote_w			bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_prestador,
		cd_estabelecimento,
		nr_seq_prestador_web
	from	pls_lote_protocolo_conta
	where 	nr_sequencia in (
		SELECT	nr_seq_lote_conta
		from	pls_protocolo_conta
		where	ie_situacao('A','I','RE')
		and	ie_tipo_protocolo	= 'C'
		and	(nr_seq_lote_conta IS NOT NULL AND nr_seq_lote_conta::text <> ''))
	and	(dt_geracao_analise IS NOT NULL AND dt_geracao_analise::text <> '');

BEGIN

open C01;
loop
fetch C01 into
	nr_seq_lote_conta_w,
	nr_seq_prestador_w,
	cd_estabelecimento_w,
	nr_seq_prestador_web_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	nr_seq_lote_w := pls_obter_lote_aberto_web( nr_seq_prestador_w, cd_estabelecimento_w, nr_seq_prestador_web_w, 'Wheb', null, null, nr_seq_lote_w);

	update	pls_protocolo_conta
	set	nr_seq_lote_conta	= nr_seq_lote_w
	where	nr_seq_lote_conta	= nr_seq_lote_conta_w
	and	ie_situacao in ('A','I','RE');
	end;
end loop;
close C01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_baca_vincular_prot_lote () FROM PUBLIC;

