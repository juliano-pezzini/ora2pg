-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alterar_sit_trab_benef ( nr_seq_segurado_p bigint, ie_situacao_trabalhista_p text, nm_usuario_p text) AS $body$
DECLARE


ie_situacao_trabalhista_ant_w	pls_segurado.ie_situacao_trabalhista%type;
nr_seq_segurado_w		pls_segurado.nr_sequencia%type;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_segurado
	where	((nr_sequencia = nr_seq_segurado_p) or (nr_seq_titular = nr_seq_segurado_p))
	order by coalesce(nr_seq_titular,0);


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_segurado_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	select	max(ie_situacao_trabalhista)
	into STRICT	ie_situacao_trabalhista_ant_w
	from	pls_segurado
	where	nr_sequencia	= nr_seq_segurado_w;

	if (coalesce(ie_situacao_trabalhista_ant_w,0) <> coalesce(ie_situacao_trabalhista_p,0)) then
		update	pls_segurado
		set	ie_situacao_trabalhista = ie_situacao_trabalhista_p,
			dt_atualizacao		= clock_timestamp(),
			nm_usuario		= nm_usuario_p
		where	nr_sequencia		= nr_seq_segurado_w;

		CALL pls_gerar_segurado_historico(
			nr_seq_segurado_w, '80', clock_timestamp(),
			wheb_mensagem_pck.get_texto(322869, 'IE_SITUACAO_TRABALHISTA_P=' ||substr(obter_valor_dominio(3840,ie_situacao_trabalhista_ant_w),1,255)),'pls_alterar_sit_trab_benef', null,
			null, null, null,
			clock_timestamp(), null, null,
			null, null, null,
			null, nm_usuario_p, 'S');
	end if;
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alterar_sit_trab_benef ( nr_seq_segurado_p bigint, ie_situacao_trabalhista_p text, nm_usuario_p text) FROM PUBLIC;

