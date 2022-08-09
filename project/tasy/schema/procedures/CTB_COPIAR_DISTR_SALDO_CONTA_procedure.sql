-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_copiar_distr_saldo_conta ( nr_seq_regra_rat_cont_p bigint, cd_empresa_origem_p bigint, cd_estab_origem_p bigint, cd_estab_destino_p bigint, ie_copiar_todos_estab_p text, nm_usuario_p text) AS $body$
DECLARE


cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;
nr_seq_regra_rat_contab_w	ctb_regra_rat_contabil.nr_sequencia%type;

c_estabelecimento CURSOR FOR
	SELECT	cd_estabelecimento
	from	estabelecimento
	where	cd_empresa = cd_empresa_origem_p
	and	cd_estabelecimento <> cd_estab_origem_p
	and	((ie_copiar_todos_estab_p = 'S')
	or (cd_estabelecimento = cd_estab_destino_p));

c_regra_dest CURSOR FOR
	SELECT	cd_centro_custo_dest,
		cd_conta_contabil_dest,
		nr_seq_grupo,
		nr_sequencia,
		pr_rateio
	from	ctb_regra_rat_dest
	where	nr_seq_regra_rateio	= nr_seq_regra_rat_cont_p;

vet_regra_dest		c_regra_dest%rowtype;


BEGIN

open c_estabelecimento;
loop
fetch c_estabelecimento into
	cd_estabelecimento_w;
EXIT WHEN NOT FOUND; /* apply on c_estabelecimento */
	begin

	select	nextval('ctb_regra_rat_contabil_seq')
	into STRICT	nr_seq_regra_rat_contab_w
	;

	insert into ctb_regra_rat_contabil(
			nr_sequencia,
			nm_usuario,
			nm_usuario_nrec,
			dt_atualizacao,
			dt_atualizacao_nrec,
			cd_centro_origem,
			cd_conta_origem,
			cd_estabelecimento,
			cd_historico,
			ds_titulo,
			dt_final_vigencia,
			dt_inicio_vigencia,
			ie_regra_rat_saldo,
			nr_seq_calculo,
			pr_total_rateio)
		(SELECT	nr_seq_regra_rat_contab_w,
			nm_usuario_p,
			nm_usuario_p,
			clock_timestamp(),
			clock_timestamp(),
			cd_centro_origem,
			cd_conta_origem,
			cd_estabelecimento_w,
			cd_historico,
			ds_titulo,
			dt_final_vigencia,
			dt_inicio_vigencia,
			ie_regra_rat_saldo,
			nr_seq_calculo,
			pr_total_rateio
		from	ctb_regra_rat_contabil
		where	nr_sequencia	= nr_seq_regra_rat_cont_p);

	open c_regra_dest;
	loop
	fetch c_regra_dest into
		vet_regra_dest;
	EXIT WHEN NOT FOUND; /* apply on c_regra_dest */
		begin

		insert into ctb_regra_rat_dest(
			nr_sequencia,
			dt_atualizacao,
			dt_atualizacao_nrec,
			nm_usuario,
			nm_usuario_nrec,
			cd_centro_custo_dest,
			cd_conta_contabil_dest,
			nr_seq_grupo,
			nr_seq_regra_rateio,
			pr_rateio)
		values (
			nextval('ctb_regra_rat_dest_seq'),
			clock_timestamp(),
			clock_timestamp(),
			nm_usuario_p,
			nm_usuario_p,
			vet_regra_dest.cd_centro_custo_dest,
			vet_regra_dest.cd_conta_contabil_dest,
			vet_regra_dest.nr_seq_grupo,
			nr_seq_regra_rat_contab_w,
			vet_regra_dest.pr_rateio);

		end;
	end loop;
	close c_regra_dest;

	end;
end loop;
close c_estabelecimento;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_copiar_distr_saldo_conta ( nr_seq_regra_rat_cont_p bigint, cd_empresa_origem_p bigint, cd_estab_origem_p bigint, cd_estab_destino_p bigint, ie_copiar_todos_estab_p text, nm_usuario_p text) FROM PUBLIC;
