-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE dime_reg_inventario ( nr_seq_controle_p bigint, cd_estabelecimento_p text, nm_usuario_p text, dt_referencia_p timestamp, ds_separador_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Gerar as informações referentes às saidas de valores de NF
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X ]  Objetos do dicionário [  ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
-------------------------------------------------------------------------------------------------------------------
Referências:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_arquivo_w			varchar(4000);
ds_arquivo_compl_w		varchar(4000);
ds_linha_w			varchar(8000);
ds_quadro_w			varchar(2);
nr_linha_w			bigint	:= qt_linha_p;
nr_seq_registro_w		bigint 	:= nr_sequencia_p;
separador_w			varchar(1)	:= ds_separador_p;
tp_registro_w			varchar(2);
vl_inicial_estoque_w		double precision	:= 0;
vl_final_estoque_w		double precision	:= 0;
vl_resumo_w			double precision	:= 0;
vl_receita_w			double precision	:= 0;
nr_item_resumo_w		valor_dominio.vl_dominio%type;
dt_inicial_w			timestamp;
dt_final_w			timestamp;

c_dominio CURSOR FOR
	SELECT	vl_dominio
	from	valor_dominio
	where	cd_dominio = 7273
	order by nr_seq_apresent;


BEGIN
if (pkg_date_utils.extract_field('MONTH',dt_referencia_p) = 6) then
	ds_quadro_w	:= '80';
	tp_registro_w	:= '80';

	dt_inicial_w	:= pkg_date_utils.add_month(pkg_date_utils.start_of(dt_referencia_p,'YEAR',0),-12,0);
	dt_final_w	:= fim_dia(fim_mes(dt_inicial_w));

	select	sum(vl_estoque)
	into STRICT	vl_inicial_estoque_w
	from	saldo_estoque
	where	cd_estabelecimento	= cd_estabelecimento_p
	and	dt_mesano_referencia between dt_inicial_w and dt_final_w;

	dt_inicial_w	:= pkg_date_utils.add_month(dt_inicial_w,11,0);
	dt_final_w	:= fim_dia(fim_mes(dt_inicial_w));

	select	sum(vl_estoque)
	into STRICT	vl_final_estoque_w
	from	saldo_estoque
	where	cd_estabelecimento	= cd_estabelecimento_p
	and	dt_mesano_referencia between dt_inicial_w and dt_final_w;


	dt_inicial_w	:= pkg_date_utils.add_month(pkg_date_utils.start_of(dt_referencia_p,'YEAR',0),-12,0);
	dt_final_w	:= fim_dia(fim_mes(pkg_date_utils.add_month(dt_inicial_w,11,0)));

	select	coalesce(sum(a.vl_total_nota),0)
	into STRICT	vl_receita_w
	FROM natureza_operacao o, nota_fiscal a
LEFT OUTER JOIN modelo_nota_fiscal m ON (a.nr_seq_modelo = m.nr_sequencia)
WHERE a.cd_natureza_operacao	= o.cd_natureza_operacao  and exists (SELECT	1
			from	fis_lote_livro_fiscal	f,
				fis_lote_nota_fiscal	n,
				fis_lote		l
			where	n.nr_seq_lote	= f.nr_seq_lote
			and	a.nr_sequencia	= n.nr_seq_nota_fiscal
			and	f.nr_seq_lote   = l.nr_sequencia
			and	l.ie_tipo_lote	= 'S'
			and	l.dt_inicial >= dt_inicial_w
			and	l.dt_final <= dt_final_w) and substr(o.cd_cfop,1,1) in (5,6,7);

	open c_dominio;
	loop
	fetch c_dominio into
		nr_item_resumo_w;
	EXIT WHEN NOT FOUND; /* apply on c_dominio */
		begin
		if (nr_item_resumo_w = '010') then
			vl_resumo_w	:= vl_inicial_estoque_w;
		elsif (nr_item_resumo_w = '020') then
			vl_resumo_w	:= vl_final_estoque_w;
		elsif (nr_item_resumo_w ='030') then
			vl_resumo_w	:= vl_receita_w;
		end if;

		ds_linha_w	:= 	tp_registro_w								|| separador_w ||
					ds_quadro_w								|| separador_w ||
					substr(coalesce(nr_item_resumo_w,0),1,4)					|| separador_w ||
					lpad(replace(campo_mascara(vl_resumo_w,2),'.',''),17,'0')		|| separador_w;

		ds_arquivo_w		:= substr(ds_linha_w,1,4000);
		ds_arquivo_compl_w	:= substr(ds_linha_w,4001,4000);
		nr_seq_registro_w	:= nr_seq_registro_w + 1;
		nr_linha_w		:= nr_linha_w + 1;

		insert into w_dime_arquivo(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_controle_dime,
			nr_linha,
			cd_registro,
			ds_arquivo)
		values (nextval('w_dime_arquivo_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_controle_p,
			nr_linha_w,
			tp_registro_w,
			ds_arquivo_w);
		end;
	end loop;
	close c_dominio;
end if;

qt_linha_p	:= nr_linha_w;
nr_sequencia_p	:= nr_seq_registro_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dime_reg_inventario ( nr_seq_controle_p bigint, cd_estabelecimento_p text, nm_usuario_p text, dt_referencia_p timestamp, ds_separador_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) FROM PUBLIC;
