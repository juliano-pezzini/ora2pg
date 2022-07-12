-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_preco_atual_mat (nr_seq_simpro_p bigint, nr_seq_brasindice_p bigint, ie_tipo_tabela_p text, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE


/*
ie_opcao_p		'PAB' - Preço atual brasindice
			'PCB' - Preço convertido brasindice
			'PAS' - Preço atual simpro
			'PCS' - Preço convertido simpro

ie_tipo_tabela_p	'S' - Simpro
			'B' - Brasindice
*/
vl_preco_venda_w	double precision;
vl_preco_w		double precision := 0;
cd_simpro_w		bigint;
qt_conversao_w		double precision;
cd_medicamento_w	varchar(6);
cd_laboratorio_w	varchar(6);
cd_apresentacao_w	varchar(6);


BEGIN

/*
if	(ie_tipo_tabela_p = 'S') then

	select	nvl(max(qt_conversao),1),
		nvl(max(cd_simpro),0)
	into	qt_conversao_w,
		cd_simpro_w
	from	pls_material_simpro
	where	nr_sequencia	= nr_seq_simpro_p;

	if	(cd_simpro_w > 0) then

		select	nvl(max(vl_preco_venda),0)
		into	vl_preco_venda_w
		from	simpro_preco
		where	cd_simpro = cd_simpro_w
		and	dt_vigencia =	(select max(dt_vigencia)
					from simpro_preco
					where cd_simpro = cd_simpro_w);

		if	(ie_opcao_p	= 'PAS') then
			vl_preco_w	:= vl_preco_venda_w;
		elsif	(ie_opcao_p	= 'PCS') then
			vl_preco_w	:= dividir_sem_round(vl_preco_venda_w,qt_conversao_w);
		end if;
	end if;

elsif	(ie_tipo_tabela_p = 'B') then

	if	(nr_seq_brasindice_p is not null) then

		select	cd_medicamento,
			cd_laboratorio,
			cd_apresentacao,
			qt_conversao
		into	cd_medicamento_w,
			cd_laboratorio_w,
			cd_apresentacao_w,
			qt_conversao_w
		from	pls_material_brasindice
		where	nr_sequencia	= nr_seq_brasindice_p;

		if	(cd_medicamento_w is not null) and
			(cd_laboratorio_w is not null) and
			(cd_apresentacao_w is not null) then

			select	nvl(sum(vl_preco_medicamento),0)
			into	vl_preco_venda_w
			from	brasindice_preco
			where	cd_medicamento	= cd_medicamento_w
			and	cd_apresentacao	= cd_apresentacao_w
			and	cd_laboratorio	= cd_laboratorio_w
			and	dt_inicio_vigencia =
						(select	max(dt_inicio_vigencia)
						from	brasindice_preco
						where	cd_medicamento	= cd_medicamento_w);

			if	(ie_opcao_p	= 'PAB') then
				vl_preco_w	:= vl_preco_venda_w;
			elsif	(ie_opcao_p	= 'PCB') then
				vl_preco_w	:= dividir_sem_round(vl_preco_venda_w,qt_conversao_w);
			end if;
		end if;
	end if;
end if;

*/
return vl_preco_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_preco_atual_mat (nr_seq_simpro_p bigint, nr_seq_brasindice_p bigint, ie_tipo_tabela_p text, ie_opcao_p text) FROM PUBLIC;
