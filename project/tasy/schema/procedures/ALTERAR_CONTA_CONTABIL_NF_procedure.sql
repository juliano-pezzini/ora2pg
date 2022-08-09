-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_conta_contabil_nf ( nr_sequencia_p bigint, nr_item_nf_p bigint, cd_conta_contabil_p text, nm_usuario_p text) AS $body$
DECLARE


cd_conta_contabil_ant_w	varchar(20);
ds_historico_w		varchar(255);
qt_registro_w		bigint;
vl_total_nota_w		double precision;


BEGIN


if (nr_sequencia_p > 0) then

	select	max(cd_conta_contabil)
	into STRICT	cd_conta_contabil_ant_w
	from	nota_fiscal_conta
	where	nr_sequencia	= nr_sequencia_p;

	select	count(*)
	into STRICT	qt_registro_w
	from	nota_fiscal_conta
	where	nr_seq_nf		= nr_sequencia_p;


	if (qt_registro_w > 0) then

		update	nota_fiscal_conta
		set	cd_conta_contabil	= cd_conta_contabil_p
		where	nr_seq_nf		= nr_sequencia_p;

		ds_historico_w	:=  wheb_mensagem_pck.get_texto(315092,	'NM_USUARIO_P='||NM_USUARIO_P||
									';DATA='||clock_timestamp()||
									';CD_CONTA_CONTABIL_ANT_W='||CD_CONTA_CONTABIL_ANT_W||
									';CD_CONTA_CONTABIL_P='||CD_CONTA_CONTABIL_P);

		CALL gerar_historico_nota_fiscal(	nr_sequencia_p,
						nm_usuario_p,
						37,--Alteração de Conta Contábil
						substr(ds_historico_w,1,255));
	else
		select	coalesce(vl_total_nota,0)
		into STRICT	vl_total_nota_w
		from	nota_fiscal
		where	nr_sequencia = nr_sequencia_p;

		insert into nota_fiscal_conta(
			nr_sequencia,
			nr_seq_nf,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			cd_conta_contabil,
			vl_contabil)
		values (	nextval('nota_fiscal_conta_seq'),
			nr_sequencia_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			cd_conta_contabil_p,
			vl_total_nota_w);
	end if;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_conta_contabil_nf ( nr_sequencia_p bigint, nr_item_nf_p bigint, cd_conta_contabil_p text, nm_usuario_p text) FROM PUBLIC;
