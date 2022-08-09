-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_pat_conta_contabil ( cd_empresa_p bigint, cd_estabelecimento_p bigint, nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;
nr_sequencia_w			pat_conta_contabil.nr_sequencia%type;
cd_conta_contabil_w		pat_conta_contabil.cd_conta_contabil%type;
dt_vigencia_w			timestamp;
tx_depreciacao_w			pat_conta_contabil.pr_depreciacao%type;
cd_conta_deprec_acum_w		pat_conta_contabil.cd_conta_deprec_acum%type;
cd_conta_deprec_res_w		pat_conta_contabil.cd_conta_deprec_res%type;
cd_historico_w			pat_conta_contabil.cd_historico%type;
cd_conta_baixa_w			pat_conta_contabil.cd_conta_baixa%type;
cd_hist_baixa_w			pat_conta_contabil.cd_hist_baixa%type;
cd_empresa_w			empresa.cd_empresa%type;

c01 CURSOR FOR
SELECT	cd_estabelecimento
from	estabelecimento
where	cd_empresa	= cd_empresa_p
and	cd_estabelecimento	<> cd_estabelecimento_p
and	ie_situacao	= 'A';

c02 CURSOR FOR
SELECT	nr_sequencia,
	cd_conta_contabil,
	dt_vigencia,
	pr_depreciacao,
	cd_conta_deprec_acum,
	cd_conta_deprec_res,
	cd_historico,
	cd_conta_baixa,
	cd_hist_baixa,
	cd_empresa
from	pat_conta_contabil
where	coalesce(cd_estabelecimento,cd_estabelecimento_P)	= cd_estabelecimento_p
and	nr_sequencia	= coalesce(nr_sequencia_p,nr_sequencia)
and	coalesce(cd_empresa,cd_empresa_P)      = cd_empresa_P;


BEGIN

open C01;
loop
fetch C01 into
	cd_estabelecimento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	open C02;
	loop
	fetch C02 into
		nr_sequencia_w,
		cd_conta_contabil_w,
		dt_vigencia_w,
		tx_depreciacao_w,
		cd_conta_deprec_acum_w,
		cd_conta_deprec_res_w,
		cd_historico_w,
		cd_conta_baixa_w,
		cd_hist_baixa_w,
		cd_empresa_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin

		insert into pat_conta_contabil(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			cd_conta_contabil,
			dt_vigencia,
			pr_depreciacao,
			cd_estabelecimento,
			cd_conta_deprec_acum,
			cd_conta_deprec_res,
			cd_historico,
			cd_conta_baixa,
			cd_hist_baixa,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			ie_situacao,
			cd_empresa)
		values ( nextval('pat_conta_contabil_seq'),
			clock_timestamp(),
			nm_usuario_p,
			cd_conta_contabil_w,
			dt_vigencia_w,
			tx_depreciacao_w,
			cd_estabelecimento_w,
			cd_conta_deprec_acum_w,
			cd_conta_deprec_res_w,
			cd_historico_w,
			cd_conta_baixa_w,
			cd_hist_baixa_w,
			clock_timestamp(),
			nm_usuario_p,
			'A',
			cd_empresa_w);
		end;
	end loop;
	close C02;

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copiar_pat_conta_contabil ( cd_empresa_p bigint, cd_estabelecimento_p bigint, nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
