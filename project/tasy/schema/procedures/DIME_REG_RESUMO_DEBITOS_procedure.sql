-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE dime_reg_resumo_debitos ( nr_seq_controle_p bigint, cd_estabelecimento_p text, nm_usuario_p text, dt_referencia_p timestamp, ds_separador_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint ) AS $body$
DECLARE


ds_arquivo_w		varchar(4000);
ds_arquivo_compl_w	varchar(4000);
ds_linha_w		varchar(8000);
ds_quadro_w		varchar(2);
nr_linha_w		bigint	:= qt_linha_p;
nr_seq_registro_w	bigint 	:= nr_sequencia_p;
separador_w		varchar(1)	:= ds_separador_p;
tp_registro_w		varchar(2);

cd_cfop_w			bigint;
nr_item_resumo_w		varchar(03);
ds_item_resumo_w		varchar(255);
vl_resumo_w			double precision;
vl_contabil_entrada_w		double precision;
vl_base_calculo_entrada_w	double precision;
vl_imposto_cred_entrada_w	double precision;
vl_isenta_entrada_w		double precision;
vl_outras_entrada_w		double precision;
vl_contabil_saida_w		double precision;
vl_base_calculo_saida_w		double precision;
vl_imposto_cred_saida_w		double precision;
vl_isenta_saida_w		double precision;
vl_outras_saida_w		double precision;

c01 CURSOR FOR
	SELECT	vl_dominio
	from	valor_dominio
	where	cd_dominio = 6901
	order by nr_seq_apresent;



BEGIN

ds_quadro_w := '04';
tp_registro_w := '25';

/* Buscar dados entrada */

	select	sum(a.vl_total_nota) vl_total_nota,
			sum(obter_dados_trib_item_nf(a.nr_sequencia,'ICMS','BC')) vl_base_calculo,
			sum(obter_dados_trib_item_nf(a.nr_sequencia,'ICMS','TR')) vl_tributo,
			sum(obter_dados_trib_item_nf(a.nr_sequencia,'ICMS','O')) vl_outras
	into STRICT	vl_contabil_entrada_w,
			vl_base_calculo_entrada_w,
			vl_imposto_cred_entrada_w,
			vl_outras_entrada_w
	FROM natureza_operacao o, nota_fiscal a
LEFT OUTER JOIN modelo_nota_fiscal m ON (a.nr_seq_modelo = m.nr_sequencia)
WHERE a.cd_natureza_operacao	= o.cd_natureza_operacao  and exists (	SELECT	1
				from	fis_lote_livro_fiscal f,
					fis_lote_nota_fiscal n,
					fis_lote l
				where	n.nr_seq_lote		= f.nr_seq_lote
				and	n.nr_seq_nota_fiscal 	= a.nr_sequencia
				and	f.nr_seq_lote   = l.nr_sequencia
				and	dt_referencia_p between l.dt_inicial and l.dt_final
				and	l.ie_tipo_lote = 'E') and substr(o.cd_cfop,1,1) in (1,2,3);

/* Buscar dados saída */

	select	sum(a.vl_total_nota) vl_total_nota,
			sum(obter_dados_trib_item_nf(a.nr_sequencia,'ICMS','BC')) vl_base_calculo,
			sum(obter_dados_trib_item_nf(a.nr_sequencia,'ICMS','TR')) vl_tributo,
			sum(obter_dados_trib_item_nf(a.nr_sequencia,'ICMS','O')) vl_outras
	into STRICT	vl_contabil_saida_w,
			vl_base_calculo_saida_w,
			vl_imposto_cred_saida_w,
			vl_outras_saida_w
	FROM natureza_operacao o, nota_fiscal a
LEFT OUTER JOIN modelo_nota_fiscal m ON (a.nr_seq_modelo = m.nr_sequencia)
WHERE a.cd_natureza_operacao	= o.cd_natureza_operacao  and exists (	SELECT	1
				from	fis_lote_livro_fiscal f,
					fis_lote_nota_fiscal n,
					fis_lote l
				where	n.nr_seq_lote		= f.nr_seq_lote
				and	n.nr_seq_nota_fiscal 	= a.nr_sequencia
				and	f.nr_seq_lote   = l.nr_sequencia
				and	dt_referencia_p between l.dt_inicial and l.dt_final
				and	l.ie_tipo_lote = 'S') and substr(o.cd_cfop,1,1) in (5,6,7);

open c01;
loop
fetch c01 into
	nr_item_resumo_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	if (nr_item_resumo_w = '010') then
		vl_resumo_w := coalesce( vl_imposto_cred_saida_w ,0);
	elsif (nr_item_resumo_w = '020') then
		vl_resumo_w := 0;
	elsif (nr_item_resumo_w ='030') then
		vl_resumo_w := 0;
	elsif (nr_item_resumo_w = '040') then
		vl_resumo_w := 0;
	elsif (nr_item_resumo_w = '050') then
		vl_resumo_w := 0;
	elsif (nr_item_resumo_w = '060') then
		vl_resumo_w := 0;
	elsif (nr_item_resumo_w =  '070') then
		vl_resumo_w := 0;
	elsif (nr_item_resumo_w = '990') then
		vl_resumo_w := coalesce(vl_imposto_cred_saida_w,0);

	end if;



	/* Montar o arquivo */

	ds_linha_w	:= 	tp_registro_w								|| separador_w ||
				ds_quadro_w								|| separador_w ||
				substr(coalesce(nr_item_resumo_w,0),1,4)					|| separador_w ||
				lpad(replace(campo_mascara(vl_resumo_w,2),'.',''),17,'0')		|| separador_w;


	ds_arquivo_w := substr(ds_linha_w,1,4000);
	ds_arquivo_compl_w := substr(ds_linha_w,4001,4000);
	nr_seq_registro_w := nr_seq_registro_w + 1;
	nr_linha_w := nr_linha_w + 1;

	-- insert na tabela do DIME
	insert into w_dime_arquivo(		nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_seq_controle_dime,
					nr_linha,
					cd_registro,
					ds_arquivo)
			values (	nextval('w_dime_arquivo_seq'),
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_controle_p,
					nr_linha_w,
					tp_registro_w,
					ds_arquivo_w);

	commit;

	end;
end loop;
close c01;

qt_linha_p := nr_linha_w;
nr_sequencia_p := nr_seq_registro_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dime_reg_resumo_debitos ( nr_seq_controle_p bigint, cd_estabelecimento_p text, nm_usuario_p text, dt_referencia_p timestamp, ds_separador_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint ) FROM PUBLIC;

