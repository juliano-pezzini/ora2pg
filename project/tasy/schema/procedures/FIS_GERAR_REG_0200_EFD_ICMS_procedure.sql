-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_gerar_reg_0200_efd_icms ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, ds_separador_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint, ie_mes_inventario_p bigint) AS $body$
DECLARE

 
dt_mesano_referencia_w	timestamp;
nr_seq_regra_efd_w		bigint;
nr_versao_efd_w			varchar(5);
tp_registro_w			varchar(4);
nr_linha_w			bigint := qt_linha_p;
nr_seq_registro_w			bigint := nr_sequencia_p;
ds_arquivo_w			varchar(4000);
ds_arquivo_compl_w		varchar(4000);
ds_linha_w			varchar(8000);
sep_w				varchar(1)	:= ds_separador_p;
dt_fim_w			timestamp;
qt_registros_regra_w		bigint;
nr_seq_regra_sped_w		bigint;

--itens que estarão no registro C170 
c01 CURSOR FOR 
SELECT	distinct '0200' tp_registro, 
	a.cd_material, 
	trim(both a.ds_material) ds_material, 
	substr(obter_dados_material_estab(a.cd_material,cd_estabelecimento_p,'UME'),1,30) cd_unidade_medida_estoque, 
	b.ie_tipo_fiscal, 
	substr(a.cd_classif_fiscal,1,8) cd_classif_fiscal 
FROM nota_fiscal_item i, material a
LEFT OUTER JOIN material_fiscal b ON (a.cd_material = b.cd_material)
, modelo_nota_fiscal m
LEFT OUTER JOIN nota_fiscal n ON (m.nr_sequencia = n.nr_seq_modelo)
WHERE n.cd_estabelecimento	= cd_estabelecimento_p and i.cd_material		= a.cd_material  and n.nr_sequencia		= i.nr_sequencia and m.cd_modelo_nf in ('01', '1B', '04', '55')  -- REGISTRO C100: NOTA FISCAL (CÓDIGO 01), NOTA FISCAL AVULSA (CÓDIGO 1B), NOTA FISCAL DE PRODUTOR (CÓDIGO 04) E NF-e (CÓDIGO 55). 
  and (((Obter_se_nota_entrada_saida(n.nr_sequencia)= 'E') and (n.dt_entrada_saida between dt_inicio_p and dt_fim_w) ) or  --nota de entrada 
 	((Obter_se_nota_entrada_saida(n.nr_sequencia)= 'S') and (n.dt_emissao between dt_inicio_p and dt_fim_w)))  --nota de saida 
--and	n.cd_operacao_nf in (30, 44, 4, 31, 25, 35, 23, 1, 2, 29, 42, 41, 21, 28) 
  and n.ie_situacao = 1  --aqui não trás as notas com situação = 3 (estornadas) porque no layout quando a nota for estornada as unidades de medida não devem ser informadas 
  and (((Obter_se_nota_entrada_saida(n.nr_sequencia) = 'E') and (ie_tipo_nota = 'EN')) 
or   ((Obter_se_nota_entrada_saida(n.nr_sequencia) = 'S') and (cd_modelo_nf = 1) and (ie_tipo_nota = 'SD'))) 
 
union
 
SELECT	distinct '0200' tp_registro, 
	a.cd_material, 
	trim(both a.ds_material) ds_material, 
	substr(obter_dados_material_estab(a.cd_material,cd_estabelecimento_p,'UME'),1,30) cd_unidade_medida_estoque, 
	b.ie_tipo_fiscal, 
	substr(a.cd_classif_fiscal,1,8) cd_classif_fiscal 
FROM saldo_estoque e, material a
LEFT OUTER JOIN material_fiscal b ON (a.cd_material = b.cd_material)
WHERE a.cd_material		= e.cd_material  and e.cd_estabelecimento	= cd_estabelecimento_p and e.dt_mesano_referencia 	= dt_mesano_referencia_w and qt_registros_regra_w > 0 order by 2;

vet01	C01%RowType;


BEGIN 
dt_fim_w := fim_dia(dt_fim_p); --coloca a hora junto ex: 01/01/2013 23:59:59 
dt_mesano_referencia_w	:= trunc(add_months(trunc(dt_inicio_p, 'mm'), - ie_mes_inventario_p), 'mm');
 
select	max(nr_seq_regra_efd) 
into STRICT	nr_seq_regra_sped_w 
from	fis_efd_controle 
where	nr_sequencia	= nr_seq_controle_p;
 
select	count(*) 
into STRICT	qt_registros_regra_w 
from	fis_regra_efd_reg	 
where	nr_seq_regra_efd = nr_seq_regra_sped_w 
and	ie_gerar = 'S' 
and	cd_registro = 'H010';
 
open C01;
loop 
fetch C01 into	 
	vet01;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin	 
		ds_linha_w	:= substr(	sep_w || vet01.tp_registro		 	|| 
					sep_w || vet01.cd_material		 	|| 
					sep_w || vet01.ds_material		 	|| 
					sep_w || ''				 	|| 
					sep_w || ''				 	|| 
					sep_w || vet01.cd_unidade_medida_estoque	|| 
					sep_w || vet01.ie_tipo_fiscal 		 	|| 
					sep_w || vet01.cd_classif_fiscal	 	|| 
					sep_w || ''				 	|| 
					sep_w || ''				 	|| 
					sep_w || ''				 	|| 
					sep_w || ''				 	|| sep_w,1,8000);
		 
		ds_arquivo_w		:= substr(ds_linha_w,1,4000);
		ds_arquivo_compl_w	:= substr(ds_linha_w,4001,4000);
		nr_seq_registro_w		:= nr_seq_registro_w + 1;
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
-- REVOKE ALL ON PROCEDURE fis_gerar_reg_0200_efd_icms ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, ds_separador_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint, ie_mes_inventario_p bigint) FROM PUBLIC;

