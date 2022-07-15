-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_reg_inspecao_nf ( nr_sequencia_p bigint, nm_usuario_p text, nr_seq_registro_p INOUT bigint) AS $body$
DECLARE


qt_registro_w			nota_fiscal.nr_sequencia%type;
cd_estabelecimento_w		nota_fiscal.cd_estabelecimento%type;
cd_cgc_emitente_w		nota_fiscal.cd_cgc_emitente%type;
cd_pessoa_fisica_w		nota_fiscal.cd_pessoa_fisica%type;
ie_tipo_nota_w			nota_fiscal.ie_tipo_nota%type;
nr_seq_registro_w			inspecao_registro.nr_sequencia%type;
cd_pessoa_resp_w			pessoa_fisica.cd_pessoa_fisica%type;
nr_inspecao_w			inspecao_recebimento.nr_sequencia%type;
cd_material_w			inspecao_recebimento.cd_material%type;
qt_item_nf_w			nota_fiscal_item.qt_item_nf%type;
nr_ordem_compra_w		ordem_compra.nr_ordem_compra%type;
nr_item_oci_w			ordem_compra_item.nr_item_oci%type;
vl_unitario_item_nf_w		nota_fiscal_item.vl_unitario_item_nf%type;
dt_emissao_w			nota_fiscal.dt_emissao%type;
nr_nota_fiscal_w			nota_fiscal.nr_nota_fiscal%type;
nr_seq_entrega_w			ordem_compra_item_entrega.nr_sequencia%type;
pr_desconto_w			nota_fiscal_item.pr_desconto%type;
vl_desconto_w			nota_fiscal_item.vl_desconto%type;
cd_condicao_pagamento_w		nota_fiscal.cd_condicao_pagamento%type;
ds_complemento_w			nota_fiscal_item.ds_complemento%type;
nr_contrato_w			contrato.nr_sequencia%type;
nr_item_nf_w			nota_fiscal_item.nr_item_nf%type;
qt_item_estoque_w			nota_fiscal_item.qt_item_estoque%type;
cd_lote_fabricacao_w		nota_fiscal_item.cd_lote_fabricacao%type;
dt_validade_w			nota_fiscal_item.dt_validade%type;
ie_indeterminado_w			nota_fiscal_item.ie_indeterminado%type;
nr_seq_marca_w			nota_fiscal_item.nr_seq_marca%type;
cd_barra_material_w		nota_fiscal_item.cd_barra_material%type;
ds_barras_w			nota_fiscal_item.ds_barras%type;
dt_fabricacao_w			nota_fiscal_item.dt_fabricacao%type;
nr_seq_lote_fornec_w		nota_fiscal_item_lote.nr_sequencia%type;
VarParam44_w            varchar(5);
qt_dias_entrega_antecipada_w    funcao_parametro.vl_parametro%type;
dt_prevista_oci_w               ordem_compra_item_entrega.dt_prevista_entrega%type;
ds_materiais_w                  varchar(4000);

c01 CURSOR FOR
SELECT	b.cd_material,
	b.qt_item_nf,
	b.nr_ordem_compra,
	b.nr_item_oci,
	b.vl_unitario_item_nf,
	a.dt_emissao,
	a.nr_nota_fiscal,
	obter_nr_seq_entrega_oci(b.nr_ordem_compra, b.nr_item_oci, b.dt_entrega_ordem),
	b.pr_desconto,
	b.vl_desconto,
	a.cd_condicao_pagamento,
	b.ds_complemento,
	b.nr_contrato,
	b.nr_item_nf,
	b.qt_item_estoque,
	b.cd_lote_fabricacao,
	b.dt_validade,
	coalesce(b.ie_indeterminado,'N'),
	b.nr_seq_marca,
	b.cd_barra_material,
	b.ds_barras,
	b.dt_fabricacao
from	nota_fiscal a,
	nota_fiscal_item b
where	a.nr_sequencia = b.nr_sequencia
and	a.nr_sequencia = nr_sequencia_p
and	obter_se_exige_inspecao_nf(b.cd_material, a.nr_sequencia) = 'S';

c02 CURSOR FOR
SELECT	nr_sequencia,
	dt_validade,
	qt_material,
	cd_lote_fabricacao,
	nr_seq_marca,
	cd_barra_material,
	ds_barras,
	coalesce(ie_indeterminado,'N'),
	dt_fabricacao
from	nota_fiscal_item_lote	
where	nr_seq_nota = nr_sequencia_p
and	nr_item_nf = nr_item_nf_w;

c03 CURSOR FOR
SELECT b.nr_ordem_compra,
       b.nr_item_oci,
       b.cd_material
from   nota_fiscal a,
       nota_fiscal_item b
where  a.nr_sequencia = b.nr_sequencia
and    a.nr_sequencia = nr_sequencia_p;


BEGIN

if (obter_valor_param_usuario(40, 509, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento) = 'N') then

	qt_dias_entrega_antecipada_w := coalesce((obter_valor_param_usuario(40, 91, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento)), 0);

	if (qt_dias_entrega_antecipada_w > 0) then
	
		open c03;
		loop
		fetch c03
		into nr_ordem_compra_w,
		     nr_item_oci_w,
		     cd_material_w;
		EXIT WHEN NOT FOUND; /* apply on c03 */
	
		begin
		
			select coalesce(min(dt_prevista_entrega), clock_timestamp())
			into STRICT dt_prevista_oci_w
			from ordem_compra_item_entrega
			where nr_ordem_compra = nr_ordem_compra_w
			and nr_item_oci = nr_item_oci_w
			and (dt_prevista_entrega IS NOT NULL AND dt_prevista_entrega::text <> '')
			and coalesce(dt_cancelamento::text, '') = ''
			and coalesce(dt_real_entrega::text, '') = '';
			
			if ((trunc(dt_prevista_oci_w,'dd') - trunc(clock_timestamp(), 'dd')) > qt_dias_entrega_antecipada_w) then
			
				if (coalesce(ds_materiais_w::text, '') = '') then
					ds_materiais_w := cd_material_w;
				else
					ds_materiais_w := substr(ds_materiais_w || ', ' || cd_material_w, 1, 4000);
				end if;
								
			end if;
	
		end;
	
		end loop;
		close c03;
		
		if (ds_materiais_w IS NOT NULL AND ds_materiais_w::text <> '') then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(wheb_mensagem_pck.get_texto(278723) || ' ' ||
			                                        wheb_mensagem_pck.get_texto(1018599) || ' ' ||
			                                        ds_materiais_w);
		end if;
		
	end if;
	
end if;

select	count(1)
into STRICT	qt_registro_w
from	nota_fiscal_item
where	nr_sequencia = nr_sequencia_p
and	(cd_material IS NOT NULL AND cd_material::text <> '')
and	obter_se_exige_inspecao_nf(cd_material, nr_sequencia) = 'S';

if (qt_registro_w > 0) then

	VarParam44_w := obter_valor_param_usuario(270,44,obter_perfil_ativo,wheb_usuario_pck.get_nm_usuario,wheb_usuario_pck.get_cd_estabelecimento);

	select	cd_estabelecimento,
		cd_cgc_emitente,
		cd_pessoa_fisica,
		ie_tipo_nota,
		obter_pessoa_fisica_usuario(nm_usuario_p, 'C')
	into STRICT	cd_estabelecimento_w,
		cd_cgc_emitente_w,
		cd_pessoa_fisica_w,
		ie_tipo_nota_w,
		cd_pessoa_resp_w
	from	nota_fiscal
	where	nr_sequencia = nr_sequencia_p;
	
	if (ie_tipo_nota_w = 'EF') then
		cd_cgc_emitente_w := '';
	else
		cd_pessoa_fisica_w := '';
	end if;

	select	nextval('inspecao_registro_seq')
	into STRICT	nr_seq_registro_w
	;
	
	insert into inspecao_registro(
		nr_sequencia,
		cd_estabelecimento,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		dt_registro,
		cd_pessoa_resp,
		nr_seq_nf,
		cd_cnpj,
		cd_pessoa_fisica,
		ie_origem)
	values (	nr_seq_registro_w,
		cd_estabelecimento_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		cd_pessoa_resp_w,
		nr_sequencia_p,
		cd_cgc_emitente_w,
		cd_pessoa_fisica_w,
		'NF');
		
	open C01;
	loop
	fetch C01 into	
		cd_material_w,
		qt_item_nf_w,
		nr_ordem_compra_w,
		nr_item_oci_w,
		vl_unitario_item_nf_w,
		dt_emissao_w,
		nr_nota_fiscal_w,
		nr_seq_entrega_w,
		pr_desconto_w,
		vl_desconto_w,
		cd_condicao_pagamento_w,
		ds_complemento_w,
		nr_contrato_w,
		nr_item_nf_w,
		qt_item_estoque_w,
		cd_lote_fabricacao_w,
		dt_validade_w,
		ie_indeterminado_w,
		nr_seq_marca_w,
		cd_barra_material_w,
		ds_barras_w,
		dt_fabricacao_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		
		select	nextval('inspecao_recebimento_seq')
		into STRICT	nr_inspecao_w
		;
			
		insert into inspecao_recebimento(
			nr_sequencia,
			nr_seq_registro,
			cd_cgc,
			cd_material,
			dt_recebimento,
			dt_atualizacao,
			nm_usuario,
			qt_inspecao,
			ie_externo,
			ie_interno,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			cd_pessoa_responsavel,
			ie_temperatura,
			ie_laudo,
			nr_ordem_compra,
			nr_item_oci,
			vl_unitario_material,
			dt_entrega_real,
			nr_seq_nota_fiscal,
			nr_nota_fiscal,
			nr_seq_entrega,
			pr_desconto,
			vl_desconto,
			cd_condicao_pagamento,
			ds_material_direto,
			cd_pessoa_fisica,
			nr_seq_contrato,
			nr_seq_item_nf,
			nr_seq_marca)
		values (	nr_inspecao_w,
			nr_seq_registro_w,
			cd_cgc_emitente_w,
			cd_material_w,
			clock_timestamp(),
			clock_timestamp(),
			nm_usuario_p,
			qt_item_nf_w,
			'N',
			'N',
			clock_timestamp(),
			nm_usuario_p,
			cd_pessoa_resp_w,
			'',
			'N',
			nr_ordem_compra_w,
			nr_item_oci_w,
			vl_unitario_item_nf_w,
			dt_emissao_w,
			nr_sequencia_p,
			nr_nota_fiscal_w,
			nr_seq_entrega_w,
			pr_desconto_w,
			vl_desconto_w,
			cd_condicao_pagamento_w,
			ds_complemento_w,
			cd_pessoa_fisica_w,
			nr_contrato_w,
			nr_item_nf_w,
			nr_seq_marca_w);
			
			
		if (VarParam44_w = 'I') then
			
			insert into inspecao_rec_contagem(
				nr_sequencia,
				nr_seq_registro,
				cd_material,
				qt_inspecao,
				cd_lote_fabricacao,
				dt_validade,
				ie_indeterminada,
				ds_observacao,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				ds_barras,
				nr_seq_nota_fiscal,
				nr_seq_item_nf)
			values (	nextval('inspecao_rec_contagem_seq'),
				nr_seq_registro_w,
				cd_material_w,
				qt_item_nf_w,
				null,
				dt_validade_w,
				ie_indeterminado_w,
				'',
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				ds_barras_w,
				nr_sequencia_p,
				nr_item_nf_w);
				
        end if;	
		
		if (cd_lote_fabricacao_w IS NOT NULL AND cd_lote_fabricacao_w::text <> '') then
		
			insert into inspecao_recebimento_lote(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				nr_seq_inspecao,
				dt_validade,
				qt_material,
				cd_lote_fabricacao,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_marca,
				ie_indeterminada,
				cd_barra_material,
				ds_barras,
				dt_fabricacao)
			values (	nextval('inspecao_recebimento_lote_seq'),
				clock_timestamp(),
				nm_usuario_p,
				nr_inspecao_w,
				dt_validade_w,
				qt_item_estoque_w,
				cd_lote_fabricacao_w,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_marca_w,
				ie_indeterminado_w,
				cd_barra_material_w,
				ds_barras_w,
				dt_fabricacao_w);
			
		end if;
		
		open C02;
		loop
		fetch C02 into	
			nr_seq_lote_fornec_w,
			dt_validade_w,
			qt_item_estoque_w,
			cd_lote_fabricacao_w,
			nr_seq_marca_w,
			cd_barra_material_w,
			ds_barras_w,
			ie_indeterminado_w,
			dt_fabricacao_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			insert into inspecao_recebimento_lote(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				nr_seq_inspecao,
				dt_validade,
				qt_material,
				cd_lote_fabricacao,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_marca,
				ie_indeterminada,
				cd_barra_material,
				ds_barras,
				dt_fabricacao)
			values (	nextval('inspecao_recebimento_lote_seq'),
				clock_timestamp(),
				nm_usuario_p,
				nr_inspecao_w,
				dt_validade_w,
				qt_item_estoque_w,
				cd_lote_fabricacao_w,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_marca_w,
				ie_indeterminado_w,
				cd_barra_material_w,
				ds_barras_w,
				dt_fabricacao_w);
			
			end;
		end loop;
		close C02;
		
		update	nota_fiscal_item
		set	nr_seq_inspecao = nr_inspecao_w
		where	nr_sequencia = nr_sequencia_p
		and	nr_item_nf = nr_item_nf_w;
				
		end;
	end loop;
	close C01;
		
	update	nota_fiscal
	set	nr_seq_reg_inspecao = nr_seq_registro_w
	where	nr_sequencia = nr_sequencia_p;


end if;

commit;

nr_seq_registro_p := nr_seq_registro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_reg_inspecao_nf ( nr_sequencia_p bigint, nm_usuario_p text, nr_seq_registro_p INOUT bigint) FROM PUBLIC;

