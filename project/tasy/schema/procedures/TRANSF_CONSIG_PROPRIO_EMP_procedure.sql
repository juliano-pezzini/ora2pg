-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE transf_consig_proprio_emp ( nr_emprestimo_p bigint, nr_seq_item_p bigint, nm_usuario_p text, dt_atendimento_p timestamp) AS $body$
DECLARE

				
/* Procedure utilizada na função Administração de Estoques
para o processo de empréstimo, onde o local de estoque que irá atender o empréstimo
possui somente saldo consignado do item solicitado. Para permitir atender
o empréstimo, o saldo consignado deve ser transformado em saldo próprio.*/
dt_atualizacao_w			timestamp := clock_timestamp();
nr_movimento_estoque_w		bigint;
cd_acao_w			varchar(1) := '1';
ie_origem_documento_w		varchar(1) := '3';
cd_estabelecimento_w		smallint := 0;
cd_operacao_cons_consignado_w	smallint := 0;
cd_setor_atendimento_w		integer;
cd_setor_atendimento_dest_w	integer;
cd_cgc_fornec_w			pessoa_juridica.cd_cgc%type;
ie_gera_ordem_w			varchar(1);
cd_local_entrega_w		local_estoque.cd_local_estoque%type;
cd_centro_custo_w			bigint;
pr_desconto_w			bigint;
nm_usuario_dest_w			varchar(255);
cd_perfil_comunic_w		integer;
cd_pessoa_solicitante_w		varchar(10);
ie_gera_oc_reposicao_w		varchar(1);
cd_comprador_consig_w		parametro_compras.cd_comprador_consig%type;
ie_solicitante_oc_consig_w		parametro_compras.ie_solicitante_oc_consig%type;
cd_comprador_padrao_w		parametro_compras.cd_comprador_padrao%type;
qt_compra_w			ordem_compra_item.qt_material%type;
qt_conv_compra_estoque_w		material.qt_conv_compra_estoque%type;
qt_conv_estoque_consumo_w	material.qt_conv_estoque_consumo%type;
cd_unidade_medida_compra_w	material.cd_unidade_medida_compra%type;
ds_material_w			material.ds_material%type;
nr_ordem_compra_gerada_w		ordem_compra_item.nr_ordem_compra%type;
nr_item_oci_gerado_w		ordem_compra_item.nr_item_oci%type;
lista_usuario_w			varchar(2000);
ie_pos_virgula_w			bigint;
ds_email_usuario_w			varchar(255);
ds_lista_email_usuario_w		varchar(2000);
tam_lista_w			bigint;
ds_comunicacao_w			varchar(2000);
nm_usuario_w			usuario.nm_usuario%type;
cd_operacao_entrada_w		operacao_estoque.cd_operacao_estoque%type;
cd_material_estoque_w		material.cd_material_estoque%type;
vl_movimento_w			movimento_estoque_valor.vl_movimento%type;
cd_material_w			material.cd_material%type;
cd_unidade_medida_w		material.cd_unidade_medida_estoque%type;
qt_saldo_proprio_w			double precision;
qt_saldo_consig_w			double precision;
qt_saldo_entrega_w		emprestimo_material.qt_emprestimo%type;
qt_transferir_w			double precision;
qt_saldo_consig_fornec_w		double precision;
qt_movimento_w			double precision;
cd_local_estoque_w		local_estoque.cd_local_estoque%type;


BEGIN

begin
select	cd_estabelecimento,
	cd_local_estoque
into STRICT	cd_estabelecimento_w,
	cd_local_estoque_w
from	emprestimo
where	nr_emprestimo = nr_emprestimo_p;
exception
  	when no_data_found then
   	-- Não encontrado estabelecimento;
	CALL wheb_mensagem_pck.exibir_mensagem_abort(261633);
end;

begin
select	cd_operacao_cons_consignado
into STRICT	cd_operacao_cons_consignado_w
from	parametro_estoque
where	cd_estabelecimento = cd_estabelecimento_w;
exception
	when others then
	-- Não encontrado oper transf paciente;
	CALL wheb_mensagem_pck.exibir_mensagem_abort(261634);
end;

if (coalesce(cd_operacao_cons_consignado_w::text, '') = '') then
	-- Não encontrado oper transf paciente;
	CALL wheb_mensagem_pck.exibir_mensagem_abort(261634);
end if;

begin
select	b.cd_setor_atendimento
into STRICT	cd_setor_atendimento_w
from	local_estoque a,
	setor_atendimento b
where	a.cd_centro_custo = b.cd_centro_custo
and	a.cd_local_estoque = cd_local_estoque_w  LIMIT 1;
exception
	when others then
	-- Não encontrado setor atendimento;
	CALL wheb_mensagem_pck.exibir_mensagem_abort(261635);
end;

begin
select	b.cd_setor_atendimento
into STRICT	cd_setor_atendimento_dest_w
from	local_estoque a,
	setor_atendimento b
where	a.cd_centro_custo  = b.cd_centro_custo
and	a.cd_local_estoque = cd_local_estoque_w  LIMIT 1;
exception
	when others then
	-- Não encontrado setor atendimento destino;
	CALL wheb_mensagem_pck.exibir_mensagem_abort(261636);
end;

/* Tratar consumo de consignados  */

select	coalesce(max(ie_solicitante_oc_consig), 'R'),
	max(cd_comprador_consig),
	max(cd_comprador_padrao)
into STRICT	ie_solicitante_oc_consig_w,
	cd_comprador_consig_w,
	cd_comprador_padrao_w
from	parametro_compras
where	cd_estabelecimento = cd_estabelecimento_w;
	
select	cd_material,
	substr(obter_dados_material(cd_material,'UME'),1,30) cd_unidade_medida_estoque,
	qt_emprestimo
into STRICT	cd_material_w,
	cd_unidade_medida_w,
	qt_saldo_entrega_w
from	emprestimo_material
where	nr_emprestimo = nr_emprestimo_p
and	nr_sequencia = nr_seq_item_p;	

begin
select	substr(obter_dados_material_estab(cd_material,cd_estabelecimento_w,'UMC'),1,30) cd_unidade_medida_compra,
	ds_material,
	qt_conv_compra_estoque,
	qt_conv_estoque_consumo
into STRICT	cd_unidade_medida_compra_w,
	ds_material_w,
	qt_conv_compra_estoque_w,
	qt_conv_estoque_consumo_w
from	material
where	cd_material = cd_material_w;
exception
	when others then
     	/*(-20011,'Falta indicador baixa e/ou min. mult. solic do material');*/

	CALL wheb_mensagem_pck.exibir_mensagem_abort(196049);
end;

/* Retorna a quantidade do material em estoque próprio */

qt_saldo_proprio_w := obter_saldo_disp_estoque(cd_estabelecimento_w, cd_material_w, cd_local_estoque_w, null);

/* Calcula a quantidade necessária a ser transferida para saldo próprio para atender a solicitação de transferência */

qt_transferir_w := qt_saldo_entrega_w - qt_saldo_proprio_w;

/* Se a quantidade a transferir for menor ou igual a zero, quer dizer que há quantidade em estoque prórpio suficiente para atender a solicitação de transferência */

if (qt_transferir_w > 0) then
	begin
	/* Retorna a quantidade do material em estoque consignado */

	qt_saldo_consig_w := obter_saldo_disp_consig(cd_estabelecimento_w, null, cd_material_w, cd_local_estoque_w, null);
	
	/* Se a quantidade a transferir para saldo próprio for maior que a quantidade em estoque consignado,
	então a quantidade a transferir assume a quantidade de consignados em estoque,
	para que sejam transferidos todos os consignados disponíveis naquele local para saldo próprio */
	if (qt_transferir_w > qt_saldo_consig_w) then
		qt_transferir_w := qt_saldo_consig_w;
	end if;
	
	/* Loop para realizar a busca do fornecedor e realizar a transferencia de saldo consignado para próprio enquanto houver saldo consignado disponível
	ou até que seja transferida para saldo próprio toda a quantidade necessária para atendimento da solicitação de transferência de estabelecimento */
	while(qt_transferir_w > 0) loop
		begin
		/* Retorna o código do fornecedor conforme regra */

		cd_cgc_fornec_w	:= substr(obter_fornecedor_regra_consig(cd_estabelecimento_w, cd_material_w, '1', cd_local_estoque_w),1,14);
		
		/* Retorna a quantidade de material consignado disponível do fornecedor obtido */

		qt_saldo_consig_fornec_w := obter_saldo_disp_consig(cd_estabelecimento_w, cd_cgc_fornec_w, cd_material_w, cd_local_estoque_w, null);
		
		/* Se a quantidade a transferir para o saldo próprio for maior que o saldo consignado disponível para o fornecedor,
		então a quantidade a ser transferida será o total disponível para o fornecedor.
		Caso contrário, será transferida a quantidade necessária para atendimento da solicitação de transferência de estabelecimento */
		if (qt_transferir_w > qt_saldo_consig_fornec_w) then
			qt_movimento_w := qt_saldo_consig_fornec_w;
		else
			qt_movimento_w := qt_transferir_w;
		end if;
		
		/* Caso a quantidade a ser movimentada não for maior que zero, significa que o fornecedor não possui saldo. Nesse caso,
		a regra de fornecedor consignado do cliente deve estar para 'Mostrar todos os fornecedores'. Nesse caso sempre trará o primeiro fornecedor.
		Assim, para não entrar em loop infinito, no else é finalizado o loop. */
		if (qt_movimento_w > 0) then
			begin		

			SELECT * FROM obter_regra_ordem_consignado(cd_estabelecimento_w, cd_local_estoque_w, cd_operacao_cons_consignado_w, cd_material_w, cd_cgc_fornec_w, 0, cd_setor_atendimento_w, ie_gera_ordem_w, cd_local_entrega_w, cd_centro_custo_w, pr_desconto_w, nm_usuario_dest_w, cd_perfil_comunic_w, cd_pessoa_solicitante_w, ie_gera_oc_reposicao_w) INTO STRICT ie_gera_ordem_w, cd_local_entrega_w, cd_centro_custo_w, pr_desconto_w, nm_usuario_dest_w, cd_perfil_comunic_w, cd_pessoa_solicitante_w, ie_gera_oc_reposicao_w;

			/* Solicitante do consumo */

			if (ie_solicitante_oc_consig_w = 'C') then
				cd_pessoa_solicitante_w	:= obter_pessoa_fisica_usuario(nm_usuario_p,'C');
			end if;

			ds_comunicacao_w := wheb_mensagem_pck.get_texto(301938,	'cd_material_p='||cd_material_w||
										';ds_material_w='||ds_material_w||
										';qt_movimento_p='||campo_mascara_virgula(qt_movimento_w)||
										';cd_acao_w='||cd_acao_w||
										';nm_fornecedor_w='||cd_cgc_fornec_w);

			if (ie_gera_ordem_w = 'N') and (ie_gera_oc_reposicao_w = 'S') then
				
				qt_compra_w	:= (qt_movimento_w / qt_conv_compra_estoque_w / qt_conv_estoque_consumo_w);
				
				CALL gerar_ordem_reposicao_consig(
					cd_estabelecimento_w,
					cd_cgc_fornec_w,
					cd_material_w,
					qt_movimento_w,
					dt_atendimento_p,
					nm_usuario_p,
					null,--nr_prescricao_p,
					null,--nr_seq_prescricao_p,
					null,--nr_atendimento_p,
					cd_local_estoque_w,
					null,
					cd_local_estoque_w,
					cd_centro_custo_w,
					pr_desconto_w,
					null,
					cd_pessoa_solicitante_w,
					null,
					cd_setor_atendimento_w,
					null,
					qt_compra_w,
					cd_unidade_medida_compra_w,
					coalesce(cd_comprador_consig_w,cd_comprador_padrao_w));

			/* S = gera a ordem; A = gera a ordem + comunicação interna; O = ordem + e-mail */

			elsif (ie_gera_ordem_w in ('S','A','O')) then

				SELECT * FROM gerar_ordem_compra_consig(
					cd_estabelecimento_w, cd_cgc_fornec_w, cd_material_w, qt_movimento_w, dt_atendimento_p, nm_usuario_p, null, --nr_prescricao_p,
					null, --nr_seq_prescricao_p,
					null, --nr_atendimento_p,
					cd_local_estoque_w, null, cd_local_entrega_w, cd_centro_custo_w, pr_desconto_w, null, cd_pessoa_solicitante_w, null, cd_setor_atendimento_w, ie_gera_oc_reposicao_w, null, nr_ordem_compra_gerada_w, nr_item_oci_gerado_w) INTO STRICT nr_ordem_compra_gerada_w, nr_item_oci_gerado_w;
				
				/* Para enviar a comunicação interna quando a opção 'A' - ordem + comunicação */

				if (ie_gera_ordem_w = 'A') then
					CALL gerar_comunic_consignado(nm_usuario_p,nm_usuario_dest_w,ds_comunicacao_w,cd_perfil_comunic_w);
				end if;
				
				/* Para enviar e-mail quando a opção 'O' = ordem + e-mail */

				if (ie_gera_ordem_w = 'O') then
					lista_usuario_w	:= substr(nm_usuario_dest_w,1,2000);
					
					while(lista_usuario_w IS NOT NULL AND lista_usuario_w::text <> '') and (trim(both lista_usuario_w) <> ',') loop
						
						tam_lista_w := length(lista_usuario_w);
						ie_pos_virgula_w := position(',' in lista_usuario_w);
						
						if (ie_pos_virgula_w <> 0) then
						
							nm_usuario_w	:= substr(lista_usuario_w,1,(ie_pos_virgula_w - 1));
							lista_usuario_w	:= substr(lista_usuario_w,(ie_pos_virgula_w + 1), tam_lista_w);
							
							select	trim(both max(ds_email))
							into STRICT	ds_email_usuario_w
							from	usuario
							where	nm_usuario = nm_usuario_w;
							
							if (coalesce(ds_email_usuario_w,'X') <> 'X') then
								ds_lista_email_usuario_w	:= substr(ds_lista_email_usuario_w||ds_email_usuario_w||',',1,2000);
							end if;
						elsif (tam_lista_w > 1) then
							nm_usuario_w	:= lista_usuario_w;
							lista_usuario_w	:= null;
							
							select	trim(both max(ds_email))
							into STRICT	ds_email_usuario_w
							from	usuario
							where	nm_usuario = nm_usuario_w;
							
							if (coalesce(ds_email_usuario_w,'X') <> 'X') then
								begin
								ds_lista_email_usuario_w	:= substr(ds_lista_email_usuario_w||ds_email_usuario_w||',',1,2000);
								end;
							end if;
						else
							lista_usuario_w	:= null;
						end if;
					end loop;
					
					if (coalesce(ds_lista_email_usuario_w,'X') <> 'X') then
						begin
						CALL enviar_email(wheb_mensagem_pck.get_texto(301943),ds_comunicacao_w, null, ds_lista_email_usuario_w, nm_usuario_p,'M');
						exception
						when others then
							null;
						end;
					end if;
				end if;

			/* C = comunicação, A = gera ordem e envia comunicação */

			elsif (ie_gera_ordem_w = 'C') and (cd_local_estoque_w IS NOT NULL AND cd_local_estoque_w::text <> '') then
				CALL gerar_comunic_consignado(nm_usuario_p,
							nm_usuario_dest_w,
							wheb_mensagem_pck.get_texto(301944, 'cd_material_p='||cd_material_w||
											';ds_material_w='||ds_material_w||
											';qt_movimento_p='||campo_mascara_virgula(qt_movimento_w)||
											';cd_acao_w='||cd_acao_w),
							cd_perfil_comunic_w);
							
			/*'E' = e-mail */

			elsif (ie_gera_ordem_w = 'E') and (cd_local_estoque_w IS NOT NULL AND cd_local_estoque_w::text <> '') then
				lista_usuario_w	:= substr(nm_usuario_dest_w,1,2000);
				
				while(lista_usuario_w IS NOT NULL AND lista_usuario_w::text <> '') and (trim(both lista_usuario_w) <> ',') loop
					tam_lista_w := length(lista_usuario_w);
					ie_pos_virgula_w := position(',' in lista_usuario_w);
					
					if (ie_pos_virgula_w <> 0) then
						nm_usuario_w	:= substr(lista_usuario_w,1,(ie_pos_virgula_w - 1));
						lista_usuario_w	:= substr(lista_usuario_w,(ie_pos_virgula_w + 1), tam_lista_w);
						
						select	trim(both max(ds_email))
						into STRICT	ds_email_usuario_w
						from	usuario
						where	nm_usuario = nm_usuario_w;
						
						if (coalesce(ds_email_usuario_w,'X') <> 'X') then
							begin
							ds_lista_email_usuario_w := substr(ds_lista_email_usuario_w||ds_email_usuario_w||',',1,2000);
							end;
						end if;
					elsif (tam_lista_w > 1) then
						nm_usuario_w	:= lista_usuario_w;
						lista_usuario_w	:= null;
						
						select	trim(both max(ds_email))
						into STRICT	ds_email_usuario_w
						from	usuario
						where	nm_usuario = nm_usuario_w;
						
						if (coalesce(ds_email_usuario_w,'X') <> 'X') then
							ds_lista_email_usuario_w	:= substr(ds_lista_email_usuario_w||ds_email_usuario_w||',',1,2000);
						end if;
					else
						lista_usuario_w	:= null;
					end if;
				end loop;
				
				if (coalesce(ds_lista_email_usuario_w,'X') <> 'X') then
					begin
					CALL enviar_email(wheb_mensagem_pck.get_texto(301943),ds_comunicacao_w, null, ds_lista_email_usuario_w, nm_usuario_p,'M');
					exception
					when others then
						null;
					end;
				end if;
			end if;
			
			begin
			select	cd_operacao_estoque
			into STRICT	cd_operacao_entrada_w
			from	operacao_estoque
			where	ie_entrada_saida = 'E'
			and	ie_tipo_requisicao = 6
			and	ie_consignado = 0
			and	ie_altera_custo = 'S'
			and	ie_situacao = 'A'
			and	ie_atualiza_estoque = 'S'
			and	ie_consumo = 'N'
			order by cd_operacao_estoque LIMIT 1;
			exception
			      when others then
				-- Não encontrado operacao correspondente;
				CALL wheb_mensagem_pck.exibir_mensagem_abort(261637);
			end;

			select nextval('movimento_estoque_seq')
			into STRICT nr_movimento_estoque_w
			;

			insert into movimento_estoque(nr_movimento_estoque,
				cd_estabelecimento,
				cd_local_estoque,
				dt_movimento_estoque,
				cd_operacao_estoque,
				cd_acao,
				cd_material,
				dt_mesano_referencia,
				qt_movimento,
				dt_atualizacao,
				nm_usuario,
				ie_origem_documento,
				nr_documento,
				nr_sequencia_item_docto,
				cd_unidade_medida_estoque,
				qt_estoque,
				cd_unidade_med_mov,
				cd_setor_atendimento,
				cd_fornecedor)
			values (nr_movimento_estoque_w,
				cd_estabelecimento_w,
				cd_local_estoque_w,
				dt_atendimento_p,
				cd_operacao_cons_consignado_w,
				cd_acao_w,
				cd_material_w,
				trunc(dt_atendimento_p,'mm'),
				qt_movimento_w,
				dt_atualizacao_w,
				nm_usuario_p,
				ie_origem_documento_w,
				nr_emprestimo_p,
				nr_seq_item_p,
				cd_unidade_medida_w,
				qt_movimento_w,
				cd_unidade_medida_w,
				cd_setor_atendimento_w,
				cd_cgc_fornec_w);

			select nextval('movimento_estoque_seq')
			into STRICT nr_movimento_estoque_w
			;

			insert into movimento_estoque(nr_movimento_estoque,
				cd_estabelecimento,
				cd_local_estoque,
				dt_movimento_estoque,
				cd_operacao_estoque,
				cd_acao,
				cd_material,
				dt_mesano_referencia,
				qt_movimento,
				dt_atualizacao,
				nm_usuario,
				ie_origem_documento,
				nr_documento,
				nr_sequencia_item_docto,
				cd_unidade_medida_estoque,
				qt_estoque,
				cd_unidade_med_mov,
				cd_setor_atendimento,
				cd_fornecedor)
			values (nr_movimento_estoque_w,
				cd_estabelecimento_w,
				cd_local_estoque_w,
				dt_atendimento_p,
				cd_operacao_entrada_w,
				cd_acao_w,
				cd_material_w,
				trunc(dt_atendimento_p,'mm'),
				qt_movimento_w,
				dt_atualizacao_w,
				nm_usuario_p,
				ie_origem_documento_w,
				nr_emprestimo_p,
				nr_seq_item_p,
				cd_unidade_medida_w,
				qt_movimento_w,
				cd_unidade_medida_w,
				cd_setor_atendimento_dest_w,
				cd_cgc_fornec_w);
				
			vl_movimento_w := qt_movimento_w * obter_custo_medio_consig(cd_estabelecimento_w, cd_local_estoque_w, cd_material_w, cd_cgc_fornec_w, dt_atendimento_p);

			insert into movimento_estoque_valor(
				nr_movimento_estoque,
				cd_tipo_valor,
				vl_movimento,
				dt_atualizacao,
				nm_usuario)
			values (nr_movimento_estoque_w,
				1,
				vl_movimento_w,
				dt_atualizacao_w,
				nm_usuario_p);
				
			select	cd_material_estoque
			into STRICT	cd_material_estoque_w
			from	material
			where	cd_material = cd_material_w;

			if (substr(sup_obter_metodo_valorizacao(trunc(dt_atendimento_p,'mm'), cd_estabelecimento_w),1,15) = 'MPM') then
				CALL val_estoque_media_ponderada.val_prod_mat(trunc(dt_atendimento_p,'mm'), cd_estabelecimento_w, cd_material_estoque_w, nm_usuario_p);
			else
				CALL val_mensal_estoque.val_est_prod_mat(trunc(dt_atendimento_p,'mm'), cd_estabelecimento_w, cd_material_estoque_w, nm_usuario_p);
			end if;	

			/* É retirada da quantidade a transferir para saldo próprio a quantidade já transferida */

			qt_transferir_w := qt_transferir_w - qt_movimento_w;

			end;
		else
			exit;
		end if;		
		end;
	end loop;
	
	commit;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE transf_consig_proprio_emp ( nr_emprestimo_p bigint, nr_seq_item_p bigint, nm_usuario_p text, dt_atendimento_p timestamp) FROM PUBLIC;
