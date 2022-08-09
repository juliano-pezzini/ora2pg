-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_inventario ( nr_sequencia_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_movimento_w				bigint;
cd_local_estoque_w			smallint;
dt_mesano_referencia_w		timestamp;
qt_inventario_w				double precision;
qt_diferenca_w				double precision;
cd_material_w				integer;
cd_material_estoque_w		integer;
cd_unidade_medida_estoque_w	varchar(30);
ie_tipo_entrada_w			varchar(1);

cd_operacao_entrada_w		operacao_estoque.cd_operacao_estoque%type;
cd_operacao_saida_w			operacao_estoque.cd_operacao_estoque%type;
cd_operacao_estoque_w		operacao_estoque.cd_operacao_estoque%type;

nr_seq_lote_fornec_w		bigint;
dt_validade_w				timestamp;
ds_lote_fornec_w			varchar(20);
cd_fornecedor_w				varchar(14);
ie_consignado_w				varchar(1);
ds_observacao_w				varchar(255);
ie_estoque_lote_w			varchar(1);
nr_sequencia_w				bigint;
dt_atualizacao_saldo_w		inventario.dt_atualizacao_saldo%type;
ie_mat_consignado_w			material.ie_consignado%type;
ie_inv_ambos_w				varchar(1);
qt_est_proprio_w			double precision;
reg_integracao_w      		gerar_int_padrao.reg_integracao;

c01 CURSOR FOR
SELECT	b.nr_sequencia,
	b.cd_material,
	b.qt_inventario,
	b.qt_diferenca,
	b.nr_seq_lote_fornec,
	coalesce(b.cd_fornecedor, a.cd_fornecedor),
	b.ds_observacao
from	inventario a,
	inventario_material b
where	b.nr_seq_inventario = a.nr_sequencia
and	b.nr_seq_inventario = nr_sequencia_p;

C02 CURSOR FOR
SELECT	c.qt_inventario,
	c.qt_diferenca,
	c.nr_seq_lote_fornec,
	b.ds_observacao,
	d.cd_cgc_fornec,
	d.dt_validade,
	d.ds_lote_fornec
from	inventario_material b,
	inventario_material_lote c,
	material_lote_fornec d
where	b.nr_sequencia = c.nr_seq_item
and	c.nr_seq_lote_fornec = d.nr_sequencia
and	b.nr_sequencia = nr_sequencia_w
order by c.qt_diferenca desc;

C03 CURSOR FOR
SELECT c.cd_cgc_fornec
from  inventario_material a,
      inventario_material_lote b,
      material_lote_fornec c
where b.nr_seq_item = a.nr_sequencia
and   b.nr_seq_lote_fornec = c.nr_sequencia
and   a.nr_sequencia = nr_sequencia_w
group by c.cd_cgc_fornec;	



BEGIN
ie_inv_ambos_w := obter_param_usuario(143, 388, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_inv_ambos_w);

select	max(dt_atualizacao_saldo)
into STRICT	dt_atualizacao_saldo_w
from	inventario
where	nr_sequencia = nr_sequencia_p;

if (dt_atualizacao_saldo_w IS NOT NULL AND dt_atualizacao_saldo_w::text <> '') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(253111);
end if;

select	cd_local_estoque,
		ie_consignado
into STRICT	cd_local_estoque_w,
		ie_consignado_w
from	inventario
where	nr_sequencia = nr_sequencia_p;

select	max(dt_mes)
into STRICT	dt_mesano_referencia_w
from	mes_v;

if (coalesce(ie_consignado_w, 'N') = 'N') then
	begin
	cd_operacao_entrada_w := sup_verifica_cria_operacao(cd_estabelecimento_p, 15, nm_usuario_p, cd_operacao_entrada_w);
	cd_operacao_saida_w := sup_verifica_cria_operacao(cd_estabelecimento_p, 16, nm_usuario_p, cd_operacao_saida_w);
	end;
elsif (coalesce(ie_consignado_w, 'N') = 'S') then
	begin
	cd_operacao_entrada_w := sup_verifica_cria_operacao(cd_estabelecimento_p, 17, nm_usuario_p, cd_operacao_entrada_w);
	cd_operacao_saida_w := sup_verifica_cria_operacao(cd_estabelecimento_p, 18, nm_usuario_p, cd_operacao_saida_w);
	end;
end if;

open c01;
loop
fetch c01 into
	nr_sequencia_w,
	cd_material_w,
	qt_inventario_w,
	qt_diferenca_w,
	nr_seq_lote_fornec_w,
	cd_fornecedor_w,
	ds_observacao_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	ie_estoque_lote_w := substr(coalesce(obter_se_material_estoque_lote(cd_estabelecimento_p,cd_material_w),'N'),1,1);

	begin
	select	substr(obter_dados_material_estab(cd_material,cd_estabelecimento_p,'UME'),1,30) cd_unidade_medida_estoque,
			cd_material_estoque,
			ie_consignado
	into STRICT	cd_unidade_medida_estoque_w,
			cd_material_estoque_w,
			ie_mat_consignado_w
	from	material
	where	cd_material = cd_material_w;
	exception when others then
		ie_mat_consignado_w := 1;
	end;

	if (qt_diferenca_w = 0) then
		CALL sup_atualizar_saldo_invent(
			cd_estabelecimento_p,
			dt_mesano_referencia_w,
			cd_local_estoque_w,
			cd_material_w,
			1,
			1,
			qt_diferenca_w,
			nm_usuario_p);
	end if;

	if (coalesce(ie_consignado_w, 'N') = 'N') then
		update	saldo_estoque
		set	ie_bloqueio_inventario	= 'N'
		where	cd_estabelecimento		= cd_estabelecimento_p
		and	cd_local_estoque		= cd_local_estoque_w
		and	cd_material 		= cd_material_estoque_w
		and	dt_mesano_referencia	<= dt_mesano_referencia_w;		
	elsif (coalesce(ie_consignado_w, 'N') = 'S') then
		begin
		update	fornecedor_mat_consignado
		set	ie_bloqueio_inventario 	= 'N'
		where	cd_estabelecimento		= cd_estabelecimento_p
		and	cd_local_estoque		= cd_local_estoque_w
		and	cd_material 		= cd_material_estoque_w
		and	dt_mesano_referencia	<= dt_mesano_referencia_w
		and	cd_fornecedor		= cd_fornecedor_w;

		if (ie_estoque_lote_w = 'S') then
            if (coalesce(cd_fornecedor_w::text, '') = '') then
                update	fornecedor_mat_consignado
				set	ie_bloqueio_inventario 	= 'N'
				where	cd_estabelecimento		= cd_estabelecimento_p
				and	cd_local_estoque		= cd_local_estoque_w
				and	cd_material 		= cd_material_estoque_w
				and	dt_mesano_referencia	<= dt_mesano_referencia_w;
            else
                open C03;
                loop
                fetch C03 into	
                    cd_fornecedor_w;
                EXIT WHEN NOT FOUND; /* apply on C03 */
                    begin
                    update	fornecedor_mat_consignado
                    set	ie_bloqueio_inventario 	= 'N'
                    where	cd_estabelecimento		= cd_estabelecimento_p
                    and	cd_local_estoque		= cd_local_estoque_w
                    and	cd_material 		= cd_material_estoque_w
                    and	dt_mesano_referencia	<= dt_mesano_referencia_w
                    and	cd_fornecedor		= cd_fornecedor_w;
                    end;
                end loop;
                close C03;
            end if;
		end if;		
		end;
	end if;		

	if (ie_estoque_lote_w = 'S') then
		begin
		open C02;
		loop
		fetch C02 into
			qt_inventario_w,
			qt_diferenca_w,
			nr_seq_lote_fornec_w,
			ds_observacao_w,
			cd_fornecedor_w,
			dt_validade_w,
			ds_lote_fornec_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			if (qt_diferenca_w < 0) then
				begin
				qt_diferenca_w		:=	abs(qt_diferenca_w);
				cd_operacao_estoque_w	:=	cd_operacao_saida_w;
				end;
			else
				cd_operacao_estoque_w	:=	cd_operacao_entrada_w;
			end if;

			if (coalesce(cd_operacao_estoque_w::text, '') = '') then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(265571);
			end if;

			if (qt_diferenca_w > 0) then
				begin
				select	nextval('movimento_estoque_seq')
				into STRICT	nr_movimento_w
				;

				insert into movimento_estoque(
					nr_movimento_estoque,
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
					ie_origem_proced,
					nr_documento,
					cd_unidade_medida_estoque,
					qt_estoque,
					dt_processo,
					cd_unidade_med_mov,
					cd_material_estoque,
					qt_inventario,
					nr_seq_lote_fornec,
					dt_validade,
					cd_lote_fabricacao,
					cd_fornecedor,
					ie_movto_consignado,
					ds_observacao)
				values (nr_movimento_w,
					cd_estabelecimento_p,
					cd_local_estoque_w,
					clock_timestamp(),
					cd_operacao_estoque_w,
					1,
					cd_material_w,
					dt_mesano_referencia_w,
					qt_diferenca_w,
					clock_timestamp(),
					nm_usuario_p,
					5,
					1,
					nr_sequencia_p,
					cd_unidade_medida_estoque_w,
					qt_diferenca_w,
					null,
					cd_unidade_medida_estoque_w,
					cd_material_estoque_w,
					qt_inventario_w,
					nr_seq_lote_fornec_w,
					dt_validade_w,
					ds_lote_fornec_w,
					cd_fornecedor_w,
					CASE WHEN coalesce(ie_consignado_w, 'N')='S' THEN  'C'  ELSE 'N' END ,
					ds_observacao_w);
				end;
			end if;
			end;
		end loop;
		close C02;
		end;
	else
		begin
		if (ie_mat_consignado_w = '2') and (qt_diferenca_w < 0) and (coalesce(ie_inv_ambos_w,'N') = 'S') then
			qt_est_proprio_w := Obter_Saldo_Estoque(cd_estabelecimento_p, cd_material_estoque_w, cd_local_estoque_w, dt_mesano_referencia_w, qt_est_proprio_w);

			/* Estoque Proprio nao e o bastante para a diference no inventario */
 
			/* Deve reduzir em consignado a quantidade que o saldo proprio nao comporta. */

			if (qt_est_proprio_w < abs(qt_diferenca_w)) then
				CALL inventario_item_ambos(nr_sequencia_p,
							cd_material_w,
							cd_material_estoque_w,
							(abs(qt_diferenca_w)-qt_est_proprio_w),
							qt_inventario_w,
							cd_unidade_medida_estoque_w,
							nr_seq_lote_fornec_w,
							cd_local_estoque_w,
							dt_mesano_referencia_w,
							ds_observacao_w,
							cd_estabelecimento_p,
							nm_usuario_p);

				/* Resta apenas estoque proprio para diminuir */


				/* Estoque proprio se torna o pendente para reduzir */

				qt_diferenca_w := 0 - qt_est_proprio_w;
			end if;
		end if;

		if (qt_diferenca_w < 0) then
			begin
			qt_diferenca_w			:= abs(qt_diferenca_w);
			cd_operacao_estoque_w	:= cd_operacao_saida_w;
			end;
		else
			cd_operacao_estoque_w	:= cd_operacao_entrada_w;
		end if;

		if (coalesce(cd_operacao_estoque_w::text, '') = '') then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(265571);
		end if;

		if (qt_diferenca_w > 0) then
			begin
			if (nr_seq_lote_fornec_w IS NOT NULL AND nr_seq_lote_fornec_w::text <> '') then
				select	dt_validade,
					ds_lote_fornec
				into STRICT	dt_validade_w,
					ds_lote_fornec_w
				from	material_lote_fornec
				where	nr_sequencia = nr_seq_lote_fornec_w;
			end if;

			select	nextval('movimento_estoque_seq')
			into STRICT	nr_movimento_w
			;

			insert into movimento_estoque(
				nr_movimento_estoque,
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
				ie_origem_proced,
				nr_documento,
				cd_unidade_medida_estoque,
				qt_estoque,
				dt_processo,
				cd_unidade_med_mov,
				cd_material_estoque,
				qt_inventario,
				nr_seq_lote_fornec,
				dt_validade,
				cd_lote_fabricacao,
				cd_fornecedor,
				ie_movto_consignado,
				ds_observacao)
			values (nr_movimento_w,
				cd_estabelecimento_p,
				cd_local_estoque_w,
				clock_timestamp(),
				cd_operacao_estoque_w,
				1,
				cd_material_w,
				dt_mesano_referencia_w,
				qt_diferenca_w,
				clock_timestamp(),
				nm_usuario_p,
				5,
				1,
				nr_sequencia_p,
				cd_unidade_medida_estoque_w,
				qt_diferenca_w,
				null,
				cd_unidade_medida_estoque_w,
				cd_material_estoque_w,
				qt_inventario_w,
				nr_seq_lote_fornec_w,
				dt_validade_w,
				ds_lote_fornec_w,
				cd_fornecedor_w,
				CASE WHEN coalesce(ie_consignado_w, 'N')='S' THEN  'C'  ELSE 'N' END ,
				ds_observacao_w);
			end;
		end if;

		end;
	end if;
	end;
end loop;
close c01;

begin /*   Atualiza os itens com status de finalizado   */
update	inventario_material
set	ie_status_inventario		= 'F' -- Finalizado
where	nr_seq_inventario		= nr_sequencia_p;
exception when others then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(265573,'DS_ERRO=' || sqlerrm);
end;

update	inventario
set	dt_atualizacao_saldo	= clock_timestamp(),
	nm_usuario_atualizacao	= nm_usuario_p
where	nr_sequencia		= nr_sequencia_p;

if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
	open c01;
	loop
	fetch c01 into
		nr_sequencia_w,
		cd_material_w,
		qt_inventario_w,
		qt_diferenca_w,
		nr_seq_lote_fornec_w,
		cd_fornecedor_w,
		ds_observacao_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
			reg_integracao_w.ie_operacao				:= 'I';
			reg_integracao_w.cd_estab_documento			:= wheb_usuario_pck.get_cd_estabelecimento;
			reg_integracao_w.nr_seq_item_documento_p	:= cd_material_w;
			reg_integracao_w.cd_local_estoque			:= cd_local_estoque_w;
			reg_integracao_w := gerar_int_padrao.gravar_integracao('426', nr_sequencia_p, wheb_usuario_pck.get_nm_usuario, reg_integracao_w);
		end;
	end loop;
	close c01;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_inventario ( nr_sequencia_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
