-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE nut_gerar_solic_compra ( nr_seq_ordem_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_solic_compra_w		bigint;
nr_seq_tipo_alimento_w		bigint;
ie_gerar_req_ind_w  		varchar(1);
cd_material_w			integer;
qt_componente_w			double precision;
cd_unidade_medida_compra_w	varchar(30);
cd_unidade_medida_estoque_w	varchar(30);
cd_unidade_medida_consumo_w     varchar(30);
qt_conversao_w			double precision;
nr_item_w			bigint;
cd_local_estoque_w		smallint;
ie_arred_req_w			varchar(1);
ds_ordem_w			varchar(80);
cd_unidade_medida_genero_w	varchar(30);
ds_parametro_120_w 	 	varchar(1);
				
C01 CURSOR FOR
	SELECT	distinct
		c.nr_seq_tipo_alimento
	FROM material m, nut_pac_opcao_rec d, nut_genero_alim c, nut_receita_comp b, nut_receita a, nut_cardapio_dia e
LEFT OUTER JOIN nut_local_refeicao f ON (e.nr_seq_local = f.nr_sequencia)
WHERE a.nr_sequencia 		= b.nr_seq_receita and c.nr_sequencia 		= b.nr_seq_gen_alim and ((ds_parametro_120_w = 'N' and d.nr_seq_cardapio_dia 	= e.nr_sequencia)
  		or (ds_parametro_120_w = 'S' and d.nr_seq_cardapio_dia 	= e.nr_sequencia and coalesce(e.nr_seq_cycle,0)>0)) and a.nr_sequencia 		= d.nr_seq_receita and m.cd_material		= c.cd_material  and coalesce(c.ie_gerar_solic_compra,'N') = 'S' and e.nr_sequencia		in (SELECT nr_seq_cardapio
	   				    from   nut_ordem_prod_card
					    where  nr_seq_ordem   = nr_seq_ordem_p);
					
C02 CURSOR FOR
	SELECT 	distinct(c.cd_material),
		c.ie_arred_req,
		SUM(CASE WHEN ie_gerar_req_ind_w='S' THEN  d.qt_refeicao  ELSE e.qt_pessoa_atend END  * (b.qt_componente/coalesce(a.qt_rendimento,b.qt_componente))),
		substr(obter_dados_material_estab(c.cd_material,cd_estabelecimento_p,'UMC'),1,30) cd_unidade_medida_compra,
		substr(obter_dados_material_estab(c.cd_material,cd_estabelecimento_p,'UMS'),1,30) cd_unidade_medida_consumo,
		substr(obter_dados_material_estab(c.cd_material,cd_estabelecimento_p,'UME'),1,30) cd_unidade_medida_estoque,
		c.qt_conversao,
                coalesce(c.cd_unidade_medida,'G')
	FROM material m, nut_pac_opcao_rec d, nut_genero_alim c, nut_receita_comp b, nut_receita a, nut_cardapio_dia e
LEFT OUTER JOIN nut_local_refeicao f ON (e.nr_seq_local = f.nr_sequencia)
WHERE a.nr_sequencia 		= b.nr_seq_receita and c.nr_sequencia 		= b.nr_seq_gen_alim and ((ds_parametro_120_w = 'N' and d.nr_seq_cardapio_dia 	= e.nr_sequencia) 
  		or (ds_parametro_120_w = 'S' and d.nr_seq_cardapio_dia 	= e.nr_sequencia and coalesce(e.nr_seq_cycle,0)>0)) and a.nr_sequencia 		= d.nr_seq_receita and m.cd_material		= c.cd_material  and coalesce(c.ie_gerar_solic_compra,'N') = 'S' and c.nr_seq_tipo_alimento	= nr_seq_tipo_alimento_w and e.nr_sequencia		in (SELECT nr_seq_cardapio
	   				    from   nut_ordem_prod_card
					    where  nr_seq_ordem   = nr_seq_ordem_p) group BY	c.cd_material,
			c.ie_arred_req,
			substr(obter_dados_material_estab(c.cd_material,cd_estabelecimento_p,'UMC'),1,30),
			substr(obter_dados_material_estab(c.cd_material,cd_estabelecimento_p,'UMS'),1,30),
			substr(obter_dados_material_estab(c.cd_material,cd_estabelecimento_p,'UME'),1,30),
			c.qt_conversao, coalesce(c.cd_unidade_medida,'G');
			

BEGIN

ie_gerar_req_ind_w := obter_param_usuario(1003, 88, Obter_perfil_Ativo, nm_usuario_p, cd_estabelecimento_p, ie_gerar_req_ind_w);
cd_local_estoque_w := obter_param_usuario(913, 130, Obter_perfil_Ativo, nm_usuario_p, cd_estabelecimento_p, cd_local_estoque_w);
ds_parametro_120_w := obter_valor_param_usuario(1003,120,obter_perfil_ativo,wheb_usuario_pck.get_nm_usuario,wheb_usuario_pck.get_cd_estabelecimento);

select 	max(ds_ordem)
into STRICT	ds_ordem_w
from 	nut_ordem_prod
where	nr_sequencia = nr_seq_ordem_p;
	
open C01;
loop
fetch C01 into	
	nr_seq_tipo_alimento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	
	nr_solic_compra_w := gerar_solic_compra(cd_estabelecimento_p, 'N', 'N', cd_local_estoque_w, nm_usuario_p, nr_solic_compra_w);
	
	update 	solic_compra
	set	ds_observacao 	= WHEB_MENSAGEM_PCK.get_texto(303624,'NR_SEQ_ORDEM_P='|| NR_SEQ_ORDEM_P ||';DS_ORDEM_W='|| DS_ORDEM_W) /*'Gerada pela função Gestão da Nutrição a partir da ordem nº '||nr_seq_ordem_p||' - '||ds_ordem_w*/
	where 	nr_solic_compra = nr_solic_compra_w;	
	
	insert into nut_ordem_prod_solic(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_ordem,
			nr_seq_solic)
		values (	nextval('nut_ordem_prod_req_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_ordem_p,
			nr_solic_compra_w);
				
	open C02;
	loop
	fetch C02 into	
		cd_material_w,
		ie_arred_req_w,
		qt_componente_w,
		cd_unidade_medida_compra_w,
		cd_unidade_medida_consumo_w,
		cd_unidade_medida_estoque_w,
		qt_conversao_w,
                cd_unidade_medida_genero_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		
                if (coalesce(qt_componente_w, 0) = 0) then
                        begin
                        --Deve ser informada a quantidade de refeições no planejamento ou cardápio conforme parâmetro [88]!
			CALL wheb_mensagem_pck.exibir_mensagem_abort(1039798);
			end;
		end if;

		if (upper(cd_unidade_medida_compra_w) <> upper(cd_unidade_medida_genero_w)) then
			qt_componente_w := Obter_dose_convertida(cd_material_w,qt_componente_w, cd_unidade_medida_genero_w,cd_unidade_medida_compra_w);
		end if;
		
		select	coalesce(max(nr_item_solic_compra),0) + 1
		into STRICT	nr_item_w
		from	solic_compra_item
		where	nr_solic_compra = nr_solic_compra_w;

		insert into solic_compra_item(
			nr_solic_compra,
			nr_item_solic_compra,
			cd_material,
			cd_unidade_medida_compra,
			qt_material,
			dt_atualizacao,
			nm_usuario,
			ie_situacao,
			ds_material_direto,
			nr_cot_compra,
			nr_item_cot_compra,
			cd_motivo_baixa,
			dt_baixa,
			dt_solic_item,
			nr_seq_aprovacao,
			dt_autorizacao,
			vl_unit_previsto,
			ie_geracao,
			qt_conv_compra_est_orig,
			qt_saldo_disp_estoque)
		values (nr_solic_compra_w,
			nr_item_w,
			cd_material_w,
			cd_unidade_medida_compra_w,
			CASE WHEN ie_arred_req_w='S' THEN ceil(qt_componente_w)  ELSE qt_componente_w END ,
			clock_timestamp(),
			nm_usuario_p,
			'A',
			null,
			null,
			null,
			null,
			null,
			clock_timestamp(),
			null,
			null,
			null,
			'S',
			null,
			null);
			
		CALL gerar_solic_item_entrega(nr_solic_compra_w,nr_item_w,nm_usuario_p);
		
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
-- REVOKE ALL ON PROCEDURE nut_gerar_solic_compra ( nr_seq_ordem_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
