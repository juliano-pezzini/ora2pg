-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_lote_intercam_benef ( nr_seq_intercambio_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_carteira_benef_w		varchar(30);

C01 CURSOR FOR
	SELECT	b.nr_sequencia
	from	pls_segurado		a,
		pls_segurado_carteira	b
	where	a.nr_seq_intercambio	= nr_seq_intercambio_p
	and	b.nr_seq_segurado 	= a.nr_sequencia
	and	b.ie_situacao		= 'P'
	and	((a.dt_rescisao		>= clock_timestamp()) or (coalesce(a.dt_rescisao::text, '') = ''))
	and	coalesce(b.nr_seq_lote_emissao::text, '') = '';

BEGIN

open C01;
loop
fetch C01 into
	nr_seq_carteira_benef_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	CALL pls_gerar_emissao_intercambio(nr_seq_carteira_benef_w,cd_estabelecimento_p,'N',nm_usuario_p);
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_lote_intercam_benef ( nr_seq_intercambio_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
