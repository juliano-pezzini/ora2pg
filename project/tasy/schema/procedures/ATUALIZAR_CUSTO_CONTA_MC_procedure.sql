-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_custo_conta_mc ( nr_interno_conta_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_estabelecimento_w		bigint;
cd_empresa_w			bigint;
ds_item_w			varchar(80);
dt_mesano_referencia_w		timestamp;
nr_seq_item_mc_w			bigint;
pr_item_w			double precision;
qt_registro_w			bigint;
vl_custo_variavel_w		double precision;
vl_receita_w			double precision;

c01 CURSOR FOR
SELECT	a.nr_sequencia,
	a.ds_item
from	cus_item_mc a
where	cd_empresa	= cd_empresa_w
and	ie_situacao	= 'A'
order by a.nr_seq_apres;


BEGIN

delete	from cus_conta_pac_mc
where	nr_interno_conta	= nr_interno_conta_p;

if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

select	cd_estabelecimento,
	dt_mesano_referencia
into STRICT	cd_estabelecimento_w,
	dt_mesano_referencia_w
from	conta_paciente
where	nr_interno_conta = nr_interno_conta_p;

cd_empresa_w	:= obter_empresa_estab(cd_estabelecimento_w);

select	count(*)
into STRICT	qt_registro_w
from	cus_item_mc_regra
where	cd_estabelecimento	= cd_estabelecimento_w;

if (qt_registro_w > 0) then

	select	coalesce(sum(vl_procedimento),0) + coalesce(sum(vl_material),0)
	into STRICT	vl_receita_w
	from	conta_paciente_resumo
	where	nr_interno_conta		= nr_interno_conta_p
	and	coalesce(qt_exclusao_custo,0)	= 0;

	open C01;
	loop
	fetch C01 into
		nr_seq_item_mc_w,
		ds_item_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		pr_item_w		:= cus_obter_perc_item_mc(cd_estabelecimento_w, nr_seq_item_mc_w, dt_mesano_referencia_w);

		vl_custo_variavel_w	:= (vl_receita_w * ( dividir(pr_item_w,100) ) );

		insert into cus_conta_pac_mc(
			nr_sequencia,
			nr_interno_conta,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_item,
			pr_aplicado,
			vl_custo_variavel)
		values (	nextval('cus_conta_pac_mc_seq'),
			nr_interno_conta_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_item_mc_w,
			pr_item_w,
			vl_custo_variavel_w);

		end;
	end loop;
	close C01;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_custo_conta_mc ( nr_interno_conta_p bigint, nm_usuario_p text) FROM PUBLIC;

