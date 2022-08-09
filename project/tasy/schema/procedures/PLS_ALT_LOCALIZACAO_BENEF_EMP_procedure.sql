-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alt_localizacao_benef_emp ( nr_seq_segurado_p bigint, nr_seq_localizacao_benef_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


ds_localizacao_ant_w	varchar(255);
ds_localizacao_novo_w	varchar(255);


BEGIN

begin
select	b.ds_localizacao
into STRICT	ds_localizacao_ant_w
from	pls_localizacao_benef	b,
	pls_segurado		a
where	a.nr_seq_localizacao_benef = b.nr_sequencia
and	a.nr_sequencia = nr_seq_segurado_p;
exception
when others then
ds_localizacao_ant_w := '';
end;

select	ds_localizacao
into STRICT	ds_localizacao_novo_w
from	pls_localizacao_benef
where	nr_sequencia = nr_seq_localizacao_benef_p;

update	pls_segurado
set	nr_seq_localizacao_benef	= nr_seq_localizacao_benef_p,
	dt_atualizacao			= clock_timestamp(),
	nm_usuario			= nm_usuario_p
where	nr_sequencia			= nr_seq_segurado_p;

CALL pls_gerar_segurado_historico(	nr_seq_segurado_p, '55', clock_timestamp(), 'Alteração da localização na empresa de '|| substr(ds_localizacao_ant_w,1,255) || ' para '||substr(ds_localizacao_novo_w,1,255),
				'pls_alt_localizacao_benef_emp', null, null, null,
				null, clock_timestamp(), null, null,
				null, null, null, null,
				nm_usuario_p, 'N');

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alt_localizacao_benef_emp ( nr_seq_segurado_p bigint, nr_seq_localizacao_benef_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
