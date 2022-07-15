-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE com_reajustar_negocio ( nr_sequencia_p bigint, pr_reajuste_p bigint, dt_reajuste_p timestamp, ds_observacao_p text, nm_usuario_p text) AS $body$
DECLARE


nr_seq_neg_lic_w	bigint;
qt_dias_data_w		integer;
vl_reajuste_w		double precision := 0;

C01 CURSOR FOR
SELECT	dt_licenca,
	nr_seq_mod_licenc,
	qt_licenca,
	vl_unitario,
	vl_total,
	nr_seq_canal,
	nr_seq_politica,
	dt_inicio_venc,
	vl_unit_manut,
	vl_manut_mensal,
	dt_inicio_venc_manut,
	cd_pessoa_fisica,
	vl_unit_distr,
	vl_distribuidor,
	ds_observacao,
	vl_original,
	vl_atual,
	ie_anterior,
	vl_unit_distr_atual,
	vl_distribuidor_atual,
	qt_mes_reaj
from	com_cli_neg_lic_item
where	nr_seq_neg_lic = nr_sequencia_p;
Vet01	C01%Rowtype;

C02 CURSOR FOR
SELECT	ie_origem_valor,
	dt_vencimento,
	vl_parcela,
	ie_vencto_fixo,
	ie_valor_fixo
from	com_cli_neg_lic_parc
where	nr_seq_negoc_lic = nr_sequencia_p;
Vet02	C02%Rowtype;


BEGIN

if (nr_sequencia_p > 0) then
	begin
	select	nextval('com_cli_neg_lic_seq')
	into STRICT	nr_seq_neg_lic_w
	;

	insert into com_cli_neg_lic(
			nr_sequencia,
			nr_seq_cliente,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			dt_assinatura,
			ds_contato_cliente,
			ds_contato_financ,
			ds_setor_nf,
			dt_liberacao,
			dt_financ,
			nr_seq_contrato,
			ie_limitado,
			ie_com_fin,
			pr_reajuste)
		SELECT	nr_seq_neg_lic_w,
			nr_seq_cliente,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			ds_contato_cliente,
			ds_contato_financ,
			ds_setor_nf,
			dt_liberacao,
			dt_financ,
			nr_seq_contrato,
			ie_limitado,
			'F',
			pr_reajuste_p
		from	com_cli_neg_lic
		where	nr_sequencia = nr_sequencia_p;

	open C01;
	loop
	fetch C01 into
		Vet01;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		select	round(dividir(obter_dias_entre_datas(dt_assinatura, dt_reajuste_p),30))
		into STRICT	qt_dias_data_w
		from	com_cli_neg_lic
		where	nr_sequencia = nr_sequencia_p;

		if (qt_dias_data_w > 12) then
			qt_dias_data_w := 12;
		end if;

		vl_reajuste_w := (dividir((Vet01.vl_atual * (dividir(pr_reajuste_p,100))),12)) * qt_dias_data_w;

		insert into com_cli_neg_lic_item(
				nr_sequencia,
				nr_seq_neg_lic,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				dt_licenca,
				nr_seq_mod_licenc,
				qt_licenca,
				vl_unitario,
				vl_total,
				nr_seq_canal,
				nr_seq_politica,
				dt_inicio_venc,
				vl_unit_manut,
				vl_manut_mensal,
				dt_inicio_venc_manut,
				cd_pessoa_fisica,
				vl_unit_distr,
				vl_distribuidor,
				ds_observacao,
				vl_original,
				vl_atual,
				ie_anterior,
				vl_unit_distr_atual,
				vl_distribuidor_atual,
				qt_mes_reaj)
			values (	nextval('com_cli_neg_lic_item_seq'),
				nr_seq_neg_lic_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				Vet01.dt_licenca,
				Vet01.nr_seq_mod_licenc,
				Vet01.qt_licenca,
				Vet01.vl_unitario,
				Vet01.vl_total,
				Vet01.nr_seq_canal,
				Vet01.nr_seq_politica,
				Vet01.dt_inicio_venc,
				Vet01.vl_unit_manut,
				Vet01.vl_manut_mensal,
				Vet01.dt_inicio_venc_manut,
				Vet01.cd_pessoa_fisica,
				Vet01.vl_unit_distr,
				Vet01.vl_distribuidor,
				ds_observacao_p,
				Vet01.vl_original,
				(Vet01.vl_atual + vl_reajuste_w),
				Vet01.ie_anterior,
				Vet01.vl_unit_distr_atual,
				Vet01.vl_distribuidor_atual,
				qt_dias_data_w);
		end;
	end loop;
	close c01;

	open C02;
	loop
	fetch C02 into
		Vet02;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		insert into com_cli_neg_lic_parc(
				nr_sequencia,
				nr_seq_negoc_lic,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				ie_origem_valor,
				dt_vencimento,
				vl_parcela,
				ie_vencto_fixo,
				ie_valor_fixo)
			values (	nextval('com_cli_neg_lic_parc_seq'),
				nr_seq_neg_lic_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				Vet02.ie_origem_valor,
				Vet02.dt_vencimento,
				Vet02.vl_parcela,
				Vet02.ie_vencto_fixo,
				Vet02.ie_valor_fixo);
		end;
	end loop;
	close c02;
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE com_reajustar_negocio ( nr_sequencia_p bigint, pr_reajuste_p bigint, dt_reajuste_p timestamp, ds_observacao_p text, nm_usuario_p text) FROM PUBLIC;

