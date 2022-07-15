-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lfpd_registro_b450 ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, ds_separador_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) AS $body$
DECLARE

 
contador_w		bigint	:= 0;
ds_arquivo_w		varchar(4000);
ds_arquivo_compl_w	varchar(4000);
ds_linha_w		varchar(8000);
nr_linha_w		bigint	:= qt_linha_p;
nr_seq_registro_w	bigint	:= nr_sequencia_p;
sep_w			varchar(1)	:= ds_separador_p;
cd_municipio_w		varchar(10);
cd_cgc_w		varchar(14);

c01 CURSOR FOR 
	SELECT	'B450' cd_registro, 
		substr(CASE WHEN Obter_se_nota_entrada_saida(n.nr_sequencia)='E' THEN 0 WHEN Obter_se_nota_entrada_saida(n.nr_sequencia)='S' THEN 1 END ,1,1) ie_operacao, 
		'5300108' cd_municipio, 
		replace(campo_mascara(sum(obter_valor_tipo_tributo_nota(n.nr_sequencia, 'B', 'ISS')),2),'.',',') vl_contabil_nota, 
		replace(campo_mascara(sum(obter_valor_tipo_tributo_nota(n.nr_sequencia, 'B', 'ISS')),2),'.',',') vl_base_calculo, 
		'0' vl_isento, 
		'0' vl_deducoes, 
		replace(campo_mascara(sum(Obter_Valor_tipo_Trib_Retido(n.nr_sequencia, 'V', 'ISS')),2),'.',',') vl_issqn_retido, 
		replace(campo_mascara(sum(obter_valor_tipo_tributo_nota(n.nr_sequencia, 'V', 'ISS')),2),'.',',') vl_issqn_destacado 
	from	nota_fiscal		n, 
		operacao_nota		o 
	where  n.cd_operacao_nf	= o.cd_operacao_nf 
	and 	o.ie_servico		= 'S' 
	and	n.ie_situacao		= 1 
	and	n.cd_estabelecimento	= cd_estabelecimento_p 
	and	(n.dt_atualizacao_estoque IS NOT NULL AND n.dt_atualizacao_estoque::text <> '') 
	and	n.dt_emissao between dt_inicio_p and dt_fim_p 
	and	n.vl_total_nota > 0 
	and 	obter_valor_tipo_tributo_nota(n.nr_sequencia, 'B', 'ISS') > 0 
	and coalesce(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'CDPAIS'),'1058') = '1058' 
	and	exists (SELECT	1 
		from	nota_fiscal_item x 
		where	x.nr_sequencia = n.nr_sequencia 
		and 	(((coalesce(Obter_se_nota_entrada_saida(n.nr_sequencia),'E') = 'E') and (x.cd_material IS NOT NULL AND x.cd_material::text <> '')) 
			or ((coalesce(Obter_se_nota_entrada_saida(n.nr_sequencia),'E') = 'S') and (x.cd_procedimento IS NOT NULL AND x.cd_procedimento::text <> '')))  
		 LIMIT 1) 
	group by substr(CASE WHEN Obter_se_nota_entrada_saida(n.nr_sequencia)='E' THEN 0 WHEN Obter_se_nota_entrada_saida(n.nr_sequencia)='S' THEN 1 END ,1,1);

vet01	c01%RowType;


BEGIN 
 
open C01;
loop 
fetch C01 into 
	vet01;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	contador_w	:= contador_w + 1;
 
	cd_municipio_w	:= vet01.cd_municipio;
 
	ds_linha_w	:= substr(	sep_w	|| vet01.cd_registro		|| 
					sep_w	|| vet01.ie_operacao		|| 
					sep_w	|| cd_municipio_w		|| 
					sep_w	|| vet01.vl_contabil_nota	|| 
					sep_w	|| vet01.vl_base_calculo	|| 
					sep_w	|| vet01.vl_isento		|| 
					sep_w	|| vet01.vl_deducoes		|| 
					sep_w	||vet01.vl_issqn_retido		|| 
					sep_w	|| vet01.vl_issqn_destacado	|| 
					sep_w, 1, 8000);
 
	ds_arquivo_w		:= substr(ds_linha_w,1,4000);
	ds_arquivo_compl_w	:= substr(ds_linha_w,4001,4000);
	nr_seq_registro_w	:= nr_seq_registro_w + 1;
	nr_linha_w		:= nr_linha_w + 1;
 
	insert into fis_lfpd_arquivo(nr_sequencia, 
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		nr_linha, 
		ds_arquivo, 
		ds_arquivo_compl, 
		cd_registro, 
		nr_seq_controle_lfpd) 
	values (nextval('fis_lfpd_arquivo_seq'), 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		nr_linha_w, 
		ds_arquivo_w, 
		ds_arquivo_compl_w, 
		vet01.cd_registro, 
		nr_seq_controle_p);
 
	if (mod(contador_w,100) = 0) then 
		commit;
	end if;
	end;
end loop;
close C01;
 
commit;
 
qt_linha_p	:= nr_linha_w;
nr_sequencia_p	:= nr_seq_registro_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lfpd_registro_b450 ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, ds_separador_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) FROM PUBLIC;

