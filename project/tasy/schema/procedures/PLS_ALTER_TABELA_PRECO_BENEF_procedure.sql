-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alter_tabela_preco_benef ( nr_seq_segurado_p bigint, nr_seq_tabela_nova_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


nr_seq_tabela_ant_w	bigint;
nm_tabela_w		varchar(255);
nm_usuario_w		varchar(255);
vl_parametro_w		varchar(2);
nr_seq_contrato_w		bigint;


BEGIN

select	b.nr_sequencia,
	b.nm_tabela,
	a.nr_seq_contrato
into STRICT	nr_seq_tabela_ant_w,
	nm_tabela_w,
	nr_seq_contrato_w
from	pls_tabela_preco	b,
	pls_segurado		a
where	a.nr_seq_tabela = b.nr_sequencia
and	a.nr_sequencia = nr_seq_segurado_p;

select	nm_usuario
into STRICT	nm_usuario_w
from	pls_tabela_preco
where	nr_sequencia = nr_seq_tabela_nova_p;

/* Gerar histórico */

CALL pls_gerar_segurado_historico( 	nr_seq_segurado_p, '3', clock_timestamp(), 'Mudança individual de tabela de preço',
				'Alterada tabela de preço de '|| nr_seq_tabela_ant_w ||' - '|| nm_tabela_w || ' para ' ||
				nr_seq_tabela_nova_p || ' - ' || nm_tabela_w || ' - 2', null, null, null, null,
				clock_timestamp(), null, null, null, null, null, null, nm_usuario_w, 'S');

update	pls_segurado
set	nr_seq_tabela = nr_seq_tabela_nova_p
where	nr_sequencia = nr_seq_segurado_p;


if (coalesce(nr_seq_contrato_w::text, '') = '') then
	vl_parametro_w := Obter_Param_Usuario(1202, 114, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, vl_parametro_w);

	if (coalesce(vl_parametro_w,'N') = 'N') then
		update	pls_segurado
		set	nr_seq_tabela_origem = nr_seq_tabela_ant_w
		where	nr_sequencia = nr_seq_segurado_p;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alter_tabela_preco_benef ( nr_seq_segurado_p bigint, nr_seq_tabela_nova_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
