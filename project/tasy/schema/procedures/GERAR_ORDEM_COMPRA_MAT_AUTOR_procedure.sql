-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_ordem_compra_mat_autor ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE



/*Variaveis do mateiral/autorizacao */

nr_sequencia_autor_w		bigint;
cd_material_w			integer;
nr_sequencia_w			bigint;
qt_autorizada_w			double precision;
vl_unitario_w			double precision;
cd_cnpj_w			varchar(14);
cd_unidade_medida_w		varchar(30);

/*Variaveis do parametro de compras*/

cd_comprador_padrao_w		varchar(10);
cd_cond_pagto_padrao_w		bigint;
cd_moeda_padrao_w		bigint;
cd_local_estoque_padrao_w	bigint;
cd_local_entrega_w		bigint;

/*Variaveis da ordem de compras*/

nr_ordem_compra_w		bigint;
cd_condicao_pagamento_w		bigint;
cd_pessoa_solicitante_w		varchar(10);
cd_comprador_w			varchar(10);
nr_item_w			integer;
nr_atendimento_w			bigint;
cd_local_estoque_w		smallint;
cd_centro_custo_w			varchar(20);
/*Variaveis gerais/auxiliares*/

qt_existe_w			bigint;
cd_estabelecimento_w		smallint := wheb_usuario_pck.get_cd_estabelecimento;

ie_permite_gerar_vl_zerado_w	varchar(5) := 'N';

qt_solicitada_w			bigint;
ds_observacao_w			varchar(4000);
ds_convenio_w			varchar(255);
nm_paciente_w			pessoa_fisica.nm_pessoa_fisica%type;
nm_medico_w			varchar(100);
dt_cirurgia_w			varchar(25);
nr_atendimento_ww		bigint;
ie_utilizada_w			varchar(1);
qt_utilizada_w			bigint;
qt_regra_w			bigint;
qt_dia_prazo_entrega_w		pessoa_juridica_estab.qt_dia_prazo_entrega%type;
tx_desc_antecipacao_w		pessoa_juridica_estab.tx_desc_antecipacao%type;
pr_desc_financeiro_w		pessoa_juridica_estab.pr_desc_financeiro%type;
dt_entrega_w			ordem_compra_item_entrega.dt_prevista_entrega%type;
ie_obs_nm_consig_w		parametro_compras.ie_obs_nm_consig%type;

/*Busca todos os itens que possuem valor e quantidade autorizada da autorizacao do fornecedor selecionado*/

c01 CURSOR FOR
SELECT	nr_sequencia,
	cd_material,
	coalesce(qt_autorizada,0),
	coalesce(qt_solicitada,0),
	vl_unitario,
	obter_regra_centro_custo_mat(cd_estabelecimento_w,cd_material,'O','V'),
	obter_regra_local_material(cd_estabelecimento_w,cd_material,'O','V'),
	obter_regra_local_entrega(cd_estabelecimento_w,cd_material,'O','V')
from	material_autorizado
where	nr_sequencia_autor 	= nr_sequencia_autor_w
and	cd_cgc_fabricante		= cd_cnpj_w
and	(((ie_permite_gerar_vl_zerado_w = 'N') and (vl_unitario > 0) and (qt_autorizada > 0)) or (ie_permite_gerar_vl_zerado_w = 'S'))
and	coalesce(nr_ordem_compra::text, '') = '';


BEGIN

ie_permite_gerar_vl_zerado_w := obter_param_usuario(3004, 173, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_permite_gerar_vl_zerado_w);
ie_utilizada_w := obter_param_usuario(3004, 230, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_utilizada_w);

if (nr_sequencia_p > 0) then
	begin
	select	nr_sequencia_autor,
		cd_cgc_fabricante,
		nr_atendimento
	into STRICT	nr_sequencia_autor_w,
		cd_cnpj_w,
		nr_atendimento_w
	from	material_autorizado
	where	nr_sequencia = nr_sequencia_p;

	/*Verifica se tem algum item, se tiver, gera a OC*/

	select	count(*)
	into STRICT	qt_existe_w
	from	material_autorizado
	where	nr_sequencia_autor 	= nr_sequencia_autor_w
	and	cd_cgc_fabricante		= cd_cnpj_w	
	and	(((ie_permite_gerar_vl_zerado_w = 'N') and (vl_unitario > 0) and (qt_autorizada > 0)) or (ie_permite_gerar_vl_zerado_w = 'S'))
	and	coalesce(nr_ordem_compra::text, '') = '';
	
	if (qt_existe_w = 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(173299);
	end if;

	/*Busca valores padrao para os campos obrigatorios no parametro compras*/

	select	coalesce(max(cd_condicao_pagamento_padrao),0),
		coalesce(max(cd_moeda_padrao),0),
		coalesce(max(cd_comprador_padrao),0),
		coalesce(max(cd_local_estoque_padrao),0)
	into STRICT	cd_cond_pagto_padrao_w,
		cd_moeda_padrao_w,
		cd_comprador_padrao_w,
		cd_local_estoque_padrao_w
	from	parametro_compras
	where	cd_estabelecimento = cd_estabelecimento_w;
	
	/*Busca condicao de pagamento padrao do fornecedor para o estabelecimento logado*/

	select	coalesce(max(cd_cond_pagto),cd_cond_pagto_padrao_w),
		max(qt_dia_prazo_entrega),
		coalesce(max(tx_desc_antecipacao),0),
		coalesce(max(pr_desc_financeiro),0)
	into STRICT	cd_condicao_pagamento_w,
		qt_dia_prazo_entrega_w,
		tx_desc_antecipacao_w,
		pr_desc_financeiro_w
	from	pessoa_juridica_estab
	where	cd_cgc = cd_cnpj_w
	and	cd_estabelecimento = cd_estabelecimento_w;
	
	if (cd_condicao_pagamento_w = 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(173300);
	end if;
	
	if (cd_moeda_padrao_w = 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(173301);
	end if;
	
	cd_pessoa_solicitante_w := substr(obter_pessoa_fisica_usuario(nm_usuario_p, 'C'),1,10);
	
	begin
	select	cd_pessoa_fisica
	into STRICT	cd_comprador_w
	from	comprador
	where	ie_situacao 		= 'A'
	and	cd_pessoa_fisica		= cd_pessoa_solicitante_w
	and	cd_estabelecimento 	= cd_estabelecimento_w  LIMIT 1;
	exception
	when others then
		cd_comprador_w := cd_comprador_padrao_w;
	end;
	
	if (coalesce(cd_comprador_w,'X') = 'X') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(173302);
	end if;

	select	nextval('ordem_compra_seq')
	into STRICT	nr_ordem_compra_w
	;

	begin
	
	select	coalesce(ie_obs_nm_consig, 'N')
	into STRICT	ie_obs_nm_consig_w
	from	parametro_compras
	where	cd_estabelecimento 	=	cd_estabelecimento_w;
	
	select substr(obter_nome_medico(cd_medico_solicitante, 'C'),1,100),
		   OBTER_SE_INICIAIS_PACIENTE(substr(obter_nome_pf_pj(cd_pessoa_fisica,null),1,255), ie_obs_nm_consig_w),
	       substr(obter_desc_convenio(cd_convenio),1,100),
	       nr_atendimento,
	       substr(obter_cirurgia_autor_convenio(nr_sequencia,'DT'),1,25)
	into STRICT   nm_medico_w,
		   nm_paciente_w,
	       ds_convenio_w,
	       nr_atendimento_ww,
	       dt_cirurgia_w
	from   autorizacao_convenio
	where  nr_sequencia = nr_sequencia_autor_w;
	
	if (ie_obs_nm_consig_w = 'S') then
	ds_observacao_w :=substr( wheb_mensagem_pck.get_texto(302173,
							'NR_ATENDIMENTO=' || nr_atendimento_ww ||
							';NM_PACIENTE=' || nm_paciente_w ||
							';NM_MEDICO=' || nm_medico_w ||
							';DS_CONVENIO=' || ds_convenio_w || 
							';DT_CIRURGIA=' || dt_cirurgia_w),1,4000);
	else
	ds_observacao_w :=substr( wheb_mensagem_pck.get_texto(1203967,
                              'NR_ATENDIMENTO=' || nr_atendimento_ww ||
	                          ';NM_MEDICO=' || nm_medico_w ||
	                          ';DS_CONVENIO=' || ds_convenio_w || 
	                          ';DT_CIRURGIA=' || dt_cirurgia_w),1,4000);
	end if;
				
	exception
	when no_data_found or too_many_rows then
		ds_observacao_w	:= null;
 	end;

	insert into ordem_compra(nr_ordem_compra,
				cd_estabelecimento,
				cd_cgc_fornecedor,
				cd_condicao_pagamento,
				cd_comprador,
				dt_ordem_compra,
				dt_atualizacao,
				nm_usuario,
				cd_moeda,
				ie_situacao,
				dt_inclusao,
				cd_pessoa_solicitante,
				ie_frete,
				dt_entrega,
				ie_aviso_chegada,
				ie_emite_obs,
				ie_urgente,
				ie_tipo_ordem,
				vl_frete,
				pr_juros_negociado,
				vl_desconto,
				pr_desc_pgto_antec,
				nr_atendimento,
				cd_local_entrega,
				ds_observacao)
			values (	nr_ordem_compra_w,
				cd_estabelecimento_w,
				cd_cnpj_w,
				cd_condicao_pagamento_w,
				cd_comprador_w,
				clock_timestamp(),
				clock_timestamp(),
				nm_usuario_p,
				cd_moeda_padrao_w,
				'A',
				clock_timestamp(),
				cd_pessoa_solicitante_w,
				'C',
				clock_timestamp(),
				'N',
				'S',
				'N',
				'V',
				0,
				0,
				0,
				0,
				nr_atendimento_w,
				cd_local_estoque_padrao_w,
				ds_observacao_w);
	open C01;
	loop
	fetch C01 into	
		nr_sequencia_w,
		cd_material_w,
		qt_autorizada_w,
		qt_solicitada_w,
		vl_unitario_w,
		cd_centro_custo_w,
		cd_local_estoque_w,
		cd_local_entrega_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		select	cd_unidade_medida_compra
		into STRICT	cd_unidade_medida_w
		from	material
		where	cd_material = cd_material_w;
		
		select	coalesce(max(nr_item_oci),0) + 1
		into STRICT	nr_item_w
		from	ordem_compra_item
		where	nr_ordem_compra = nr_ordem_compra_w;
		
		select	obter_qt_utilizada_mat_autor(nr_sequencia_w)
		into STRICT	qt_utilizada_w
		;
		
		select CASE WHEN qt_autorizada_w=0 THEN qt_solicitada_w  ELSE qt_autorizada_w END
		into STRICT qt_regra_w
		;
		
		if ( ie_utilizada_w = 'S') then
			begin
			if (qt_utilizada_w > qt_autorizada_w) then
				qt_regra_w := qt_autorizada_w;
			elsif (qt_utilizada_w < qt_autorizada_w) then
				qt_regra_w := qt_utilizada_w;
			end if;
				
			end;
		end if;
		
		
		insert into ordem_compra_item(	nr_ordem_compra,
			nr_item_oci,
			cd_material,
			cd_unidade_medida_compra,
			vl_unitario_material,
			qt_material,
			qt_original,
			dt_atualizacao,
			nm_usuario,
			ie_situacao,
			cd_pessoa_solicitante,
			pr_descontos,
			pr_desc_financ,
			vl_desconto,
			cd_local_estoque,
			cd_centro_custo,
			vl_total_item)
		values (	nr_ordem_compra_w,
			nr_item_w,
			cd_material_w,
			cd_unidade_medida_w,
			vl_unitario_w,
			qt_regra_w,
			qt_regra_w,
			clock_timestamp(),
			nm_usuario_p,
			'A',
			cd_pessoa_solicitante_w,
			tx_desc_antecipacao_w,
			pr_desc_financeiro_w,
			0,
			cd_local_estoque_w,
			cd_centro_custo_w,
			round((qt_regra_w * vl_unitario_w)::numeric,4));
					

		dt_entrega_w := clock_timestamp();
		if (qt_dia_prazo_entrega_w > 0) then			
			select	obter_proximo_dia_util(cd_estabelecimento_w, clock_timestamp() + qt_dia_prazo_entrega_w)
			into STRICT	dt_entrega_w
			;
		end if;
		
		update	ordem_compra
		set	dt_entrega = dt_entrega_w
		where	nr_ordem_compra = nr_ordem_compra_w;
					
		insert	into ordem_compra_item_entrega(
			nr_sequencia,
			nm_usuario,
			dt_atualizacao,
			qt_prevista_entrega,
			dt_prevista_entrega,
			dt_entrega_original,
			dt_entrega_limite,
			nr_ordem_compra,
			nr_item_oci)
		values (	nextval('ordem_compra_item_entrega_seq'),
			nm_usuario_p,
			clock_timestamp(),
			CASE WHEN qt_autorizada_w=0 THEN qt_solicitada_w  ELSE qt_autorizada_w END ,
			dt_entrega_w,
			dt_entrega_w,
			dt_entrega_w,
			nr_ordem_compra_w,
			nr_item_w);

					
		
		update	material_autorizado
		set	nr_ordem_compra 	= nr_ordem_compra_w,
			nr_item_oci	= nr_item_w,
			dt_atualizacao 	= clock_timestamp(),
			nm_usuario	= nm_usuario_p
		where	nr_sequencia	= nr_sequencia_w;
		
		if (cd_local_entrega_w > 0) then
			update	ordem_compra
			set	cd_local_entrega	= cd_local_entrega_w
			where	nr_ordem_compra		= nr_ordem_compra_w;
		end if;
		
		end;
	end loop;
	close C01;
	
	commit;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_ordem_compra_mat_autor ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
