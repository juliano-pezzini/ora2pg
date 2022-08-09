-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_aprov_compra_visao ( cd_estabelecimento_p bigint, nr_seq_campo_p bigint, cd_perfil_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_w	integer;
cd_perfil_w	integer;


BEGIN

cd_perfil_w := cd_perfil_p;
if (cd_perfil_p = 0) then
	cd_perfil_w := null;
end if;

select	coalesce(max(nr_seq_ordem), 0) +2
into STRICT	nr_seq_w
from	aprov_compra_visao
where	nm_usuario_visao = nm_usuario_p;

insert into aprov_compra_visao(
	nr_sequencia,
	cd_estabelecimento,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nm_usuario_visao,
	nr_seq_campo,
	nr_seq_ordem,
	cd_perfil_visao)
values ( nextval('aprov_compra_visao_seq'),
	cd_estabelecimento_p,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nm_usuario_p,
	nr_seq_campo_p,
	nr_seq_w,
	cd_perfil_w);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_aprov_compra_visao ( cd_estabelecimento_p bigint, nr_seq_campo_p bigint, cd_perfil_p bigint, nm_usuario_p text) FROM PUBLIC;
