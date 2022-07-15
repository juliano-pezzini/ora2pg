-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cus_imp_natureza_gasto ( cd_empresa_p text, nr_seq_gng_p bigint, cd_classificacao_p bigint, cd_conta_contabil_p text, nm_usuario_p text) AS $body$
DECLARE


cd_grupo_natureza_gasto_w		integer;
ds_conta_contabil_w		varchar(255);


BEGIN

select	max(cd_grupo_natureza_gasto)
into STRICT	cd_grupo_natureza_gasto_w
from	grupo_natureza_gasto
where	nr_sequencia = nr_seq_gng_p;

select	max(ds_conta_contabil)
into STRICT	ds_conta_contabil_w
from	conta_contabil
where	cd_conta_contabil = cd_conta_contabil_p;

insert into natureza_gasto(
	cd_estabelecimento,
	cd_natureza_gasto,
	ds_natureza_gasto,
	nm_usuario,
	dt_atualizacao,
	ie_situacao,
	ie_natureza_gasto,
	cd_grupo_natureza_gasto,
	qt_dias_prazo_medio,
	ie_resumo,
	cd_classif_result,
	cd_conta_contabil,
	nr_seq_gng,
	nr_sequencia,
	cd_empresa,
	dt_atualizacao_nrec,
	nm_usuario_nrec)
values ( null,
	Somente_Numero(cd_conta_contabil_p),
	ds_conta_contabil_w,
	nm_usuario_p,
	clock_timestamp(),
	'A',
	'N',
	cd_grupo_natureza_gasto_w,
	30,
	'N',
	cd_classificacao_p,
	cd_conta_contabil_p,
	nr_seq_gng_p,
	nextval('natureza_gasto_seq'),
	cd_empresa_p,
	clock_timestamp(),
	nm_usuario_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cus_imp_natureza_gasto ( cd_empresa_p text, nr_seq_gng_p bigint, cd_classificacao_p bigint, cd_conta_contabil_p text, nm_usuario_p text) FROM PUBLIC;

