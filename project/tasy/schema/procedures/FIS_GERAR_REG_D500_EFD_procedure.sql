-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_gerar_reg_d500_efd ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, ds_separador_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) AS $body$
DECLARE

 
cd_modelo_w			varchar(2);
nr_seq_regra_efd_w		bigint;
nr_versao_efd_w			varchar(5);
tp_registro_w			varchar(4);
nr_linha_w			bigint := qt_linha_p;
nr_seq_registro_w		bigint := nr_sequencia_p;
ds_arquivo_w			varchar(4000);
ds_arquivo_compl_w		varchar(4000);
ds_linha_w			varchar(8000);
sep_w				varchar(1)	:= ds_separador_p;
nr_sequencia_w			bigint;
dt_fim_w			timestamp;

c01 CURSOR FOR 
SELECT	'D500' tp_registro, 
	substr(CASE WHEN Obter_se_nota_entrada_saida(a.nr_sequencia)='E' THEN 0 WHEN Obter_se_nota_entrada_saida(a.nr_sequencia)='S' THEN 1 END ,1,1) ie_operacao, 
/*quando o tipo da nota é "Entrada(Emissão própria)" o ie_emissao_nf deve ser 0*/
 
	CASE WHEN Obter_Se_Nota_Entrada_Saida(a.nr_sequencia)='S' THEN  0 WHEN Obter_Se_Nota_Entrada_Saida(a.nr_sequencia)='E' THEN  CASE WHEN ie_tipo_nota='EP' THEN  0  ELSE 1 END  END  ie_emissao_nf, 
/*se for nota de entrada pega o emitente (pessoa física ou jurídica), se for de saída pega o cd_cgc */
 
	CASE WHEN Obter_Se_Nota_Entrada_Saida(a.nr_sequencia)='E' THEN  coalesce(a.cd_cgc_emitente, a.cd_pessoa_fisica)  ELSE cd_cgc END  cd_participante, 
/* nvl(cd_pessoa_fisica, cd_cgc_emitente) cd_participante, */
 
	 lpad(m.cd_modelo_nf, 2, 0) cd_modelo, 
/* situação: 01 Documento regular extemporâneo , 03 Documento cancelado extemporâneo, 07 Documento Fiscal Complementar extemporâneo. */
 
	substr(CASE WHEN a.ie_situacao=1 THEN  '00' WHEN a.ie_situacao=2 THEN  '02' WHEN a.ie_situacao=3 THEN  '02' WHEN a.ie_situacao=9 THEN  '02'  ELSE '07' END , 1, 2) cd_situacao, 
	substr(trim(both a.cd_serie_nf), 1, 3) cd_serie_nf, 
	'' sub_serie, 
	substr(coalesce(a.nr_nfe_imp, a.nr_nota_fiscal), 1, 9) nr_nota_fiscal, 
	substr(to_char(a.dt_emissao, 'ddmmyyyy'),1,8) dt_emissao, 
	substr(to_char(a.dt_entrada_saida, 'ddmmyyyy'),1,8) dt_entrada_saida, 
	a.vl_total_nota vl_total_nota, 
	(obter_dados_nota_fiscal(a.nr_sequencia, '37') + a.vl_descontos) vl_descontos, 
	a.vl_total_nota vl_serv, 
	0 vl_serv_nt, 
	0 vl_terc, 
	0 vl_da, 
	nfe_obter_valores_totais_num(a.nr_sequencia, 'ICMS', 'BC') vl_base_calc_icms, 
	nfe_obter_valores_totais_num(a.nr_sequencia, 'ICMS', 'VL') vl_icms, 
	'' cod_inf, 
	nfe_obter_valores_totais_num(a.nr_sequencia, 'PIS', 'VL') vl_pis, 
	nfe_obter_valores_totais_num(a.nr_sequencia, 'COFINS', 'VL') vl_cofins, 
	0 cod_cta, 
	1 tp_assinante, 
	a.nr_sequencia 
FROM modelo_nota_fiscal m
LEFT OUTER JOIN nota_fiscal a ON (m.nr_sequencia = a.nr_seq_modelo)
WHERE a.cd_estabelecimento	= cd_estabelecimento_p  and m.nr_sequencia in (	SELECT nr_seq_modelo_nf 
						from	fis_regra_efd_D500 
						where 	nr_seq_regra_efd = nr_seq_regra_efd_w) -- nota fiscal de serviço de transporte (código 07) e conhecimentos de transporte rodoviário de cargas (código 08), conhecimentos de transporte de cargas avulso (código 8b), aquaviário de cargas (código 09), aéreo (código 10), ferroviário de cargas (código 11) e multimodal de cargas (código 26),  
 --nota fiscal de transporte ferroviário de carga ( código 27) e conhecimento de transporte eletrônico ¿ ct-e (código 57) 
--and	m.cd_modelo_nf in ('21', '22') 
--and	a.cd_operacao_nf in (30, 44, 4, 31, 25, 35, 23, 1, 2, 29, 42, 41, 21, 28) 
  and (((Obter_se_nota_entrada_saida(a.nr_sequencia)= 'E') and (a.dt_entrada_saida between dt_inicio_p and dt_fim_w) ) or  --nota de entrada 
 	((Obter_se_nota_entrada_saida(a.nr_sequencia)= 'S') and (a.dt_emissao between dt_inicio_p and dt_fim_w)))  --nota de saida 
  and (a.dt_atualizacao_estoque IS NOT NULL AND a.dt_atualizacao_estoque::text <> '') and a.ie_situacao = 1 order by	2;

vet01	C01%RowType;


BEGIN 
dt_fim_w := fim_dia(dt_fim_p); --coloca a hora junto ex: 01/01/2013 23:59:59 
select nr_seq_regra_efd 
into STRICT nr_seq_regra_efd_w 
from fis_efd_controle 
where nr_sequencia = nr_seq_controle_p;
 
 
open C01;
loop 
fetch C01 into	 
	vet01;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	nr_sequencia_w	:= vet01.nr_sequencia;
	cd_modelo_w	:= vet01.cd_modelo;
	 
	if (vet01.cd_situacao = '00') then 
		ds_linha_w	:= substr(	sep_w || vet01.tp_registro	 						|| 
						sep_w || vet01.ie_operacao						|| 
						sep_w || vet01.ie_emissao_nf						|| 
						sep_w || vet01.cd_participante	 				|| 
						sep_w || vet01.cd_modelo						|| 
						sep_w || vet01.cd_situacao						|| 
						sep_w || vet01.cd_serie_nf 						|| 
						sep_w || vet01.sub_serie 						||						 
						sep_w || vet01.nr_nota_fiscal	 					|| 
						sep_w || vet01.dt_emissao						|| 
						sep_w || vet01.dt_entrada_saida					|| 
						sep_w || substr(sped_obter_campo_valor(vet01.vl_total_nota), 1, 30)		|| 
						sep_w || substr(sped_obter_campo_valor(vet01.vl_descontos), 1, 30) 		|| 
						sep_w || vet01.vl_serv					|| 
						sep_w || vet01.vl_serv_nt					|| 
						sep_w || vet01.vl_terc					|| 
						sep_w || vet01.vl_da						|| 
						sep_w || substr(sped_obter_campo_valor(vet01.vl_base_calc_icms), 1, 30)	|| 
						sep_w || substr(sped_obter_campo_valor(vet01.vl_icms), 1, 30)		|| 
						sep_w || vet01.cod_inf					|| 
						sep_w || substr(sped_obter_campo_valor(vet01.vl_pis), 1, 30)		|| 
						sep_w || substr(sped_obter_campo_valor(vet01.vl_cofins), 1, 30)		|| 
						sep_w || vet01.cod_cta					|| 
						sep_w || vet01.tp_assinante					|| 
						sep_w,1,8000);
	else --informar apenas os campos: reg, ind_oper, ind_emit, cod_mod, cod_sit, ser, num_doc e dt_doc 
		ds_linha_w	:= substr(	sep_w || vet01.tp_registro	 						|| 
						sep_w || vet01.ie_operacao						|| 
						sep_w || vet01.ie_emissao_nf						|| 
						sep_w || ''	 				|| 
						sep_w || vet01.cd_modelo						|| 
						sep_w || vet01.cd_situacao						|| 
						sep_w || vet01.cd_serie_nf 						|| 
						sep_w || '' 						||						 
						sep_w || vet01.nr_nota_fiscal	 					|| 
						sep_w || vet01.dt_emissao						|| 
						sep_w || ''					|| 
						sep_w || ''		|| 
						sep_w || '' 		|| 
						sep_w || ''					|| 
						sep_w || ''					|| 
						sep_w || ''					|| 
						sep_w || ''						|| 
						sep_w || ''	|| 
						sep_w || ''		|| 
						sep_w || ''					|| 
						sep_w || ''	|| 
						sep_w || ''	|| 
						sep_w || ''					|| 
						sep_w || ''					|| 
						sep_w,1,8000);
	end if;
	 
	ds_arquivo_w		:= substr(ds_linha_w,1,4000);
	ds_arquivo_compl_w	:= substr(ds_linha_w,4001,4000);
	nr_seq_registro_w	:= nr_seq_registro_w + 1;
	nr_linha_w		:= nr_linha_w + 1;
 
	insert into fis_efd_arquivo( 
		nr_sequencia, 
		nm_usuario, 
		dt_atualizacao, 
		nm_usuario_nrec, 
		dt_atualizacao_nrec, 
		nr_seq_controle_efd, 
		nr_linha, 
		cd_registro, 
		ds_arquivo, 
		ds_arquivo_compl) 
	values (	nr_seq_registro_w, 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		nr_seq_controle_p, 
		nr_linha_w, 
		vet01.tp_registro, 
		ds_arquivo_w, 
		ds_arquivo_compl_w);
		 
 
	if (vet01.cd_situacao = '00') then 
		SELECT * FROM fis_gerar_reg_D590_efd(	nr_seq_controle_p, nm_usuario_p, cd_estabelecimento_p, dt_inicio_p, dt_fim_p, cd_empresa_p, ds_separador_p, nr_sequencia_w, nr_linha_w, nr_seq_registro_w) INTO STRICT nr_linha_w, nr_seq_registro_w;
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
-- REVOKE ALL ON PROCEDURE fis_gerar_reg_d500_efd ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, ds_separador_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) FROM PUBLIC;

