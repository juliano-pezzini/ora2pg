-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE swisslog_gerar_inventario ( cd_local_estoque_p bigint, cd_material_p bigint, qt_contagem_p bigint, nr_lote_fornec_p text, nm_usuario_p text, cd_estabelecimento_p bigint, ds_erro_p INOUT text, ie_opcao_p text) AS $body$
DECLARE


/* I = Inicio inventário
     C = Continuação
     R = Registrar inventário */
ds_erro_w			varchar(2000);
ie_tipo_entrada_w			varchar(1);
dt_mesano_referencia_w		timestamp;
dt_mesano_ref_saldo_w		timestamp;
qt_estoque_w                		double precision := 0;
qt_estoque_consig_w                	double precision := 0;
qt_material_estoque_w		double precision;
qt_material_w			double precision;
qt_dif_estoque_w			double precision;
nr_movimento_w			movimento_estoque.nr_movimento_estoque%type;
cd_operacao_estoque_w		operacao_estoque.cd_operacao_estoque%type;
cd_material_w			material.cd_material%type;
cd_local_estoque_w		local_estoque.cd_local_estoque%type;

cd_material_return_w 		integer;
qt_material_return_w 		double precision 	:= 0;
nr_seq_lote_return_w 		bigint;
nr_seq_loteagrup_return_w 		bigint;
cd_kit_mat_return_w 		integer	:= 0;
ds_validade_return_w	 	varchar(30);
ds_material_return_w	 	varchar(255);
cd_unid_med_return_w	 	varchar(30);
nr_etiqueta_lp_return_w 		varchar(10);
ds_erro_return_w	 		varchar(255);
ie_movto_consignado_w		movimento_estoque.ie_movto_consignado%type;
ie_consignado_w			material.ie_consignado%type;
cd_material_est_w			material.cd_material%type;
cd_cgc_fornec_w			varchar(14);
cd_cgc_fornec_ant_w		varchar(14);

C01 CURSOR FOR
	SELECT	cd_material,
		sum(qt_material),
		cd_local_estoque
	from	swisslog_inventario
	where	obter_material_generico(cd_material) = obter_material_generico(cd_material_w)
	and	nm_usuario = nm_usuario_p
	group by cd_material,
		cd_local_estoque
	order by cd_material;


BEGIN
dt_mesano_referencia_w := trunc(clock_timestamp(),'mm');

begin

SELECT * FROM converte_codigo_barras( nr_lote_fornec_p, cd_estabelecimento_p, 'B', cd_local_estoque_p, cd_material_return_w, qt_material_return_w, nr_seq_lote_return_w, nr_seq_loteagrup_return_w, cd_kit_mat_return_w, ds_validade_return_w, ds_material_return_w, cd_unid_med_return_w, nr_etiqueta_lp_return_w, ds_erro_return_w, NULL, NULL) INTO STRICT cd_material_return_w, qt_material_return_w, nr_seq_lote_return_w, nr_seq_loteagrup_return_w, cd_kit_mat_return_w, ds_validade_return_w, ds_material_return_w, cd_unid_med_return_w, nr_etiqueta_lp_return_w, ds_erro_return_w;

		
if (coalesce(cd_material_return_w,0) <> 0) then	
	
	cd_material_w := cd_material_return_w;
else

	select	cd_material
	into STRICT	cd_material_w
	from	material_lote_fornec
	where	nr_sequencia = (substr(nr_lote_fornec_p,1,length(nr_lote_fornec_p)-1))::numeric;
	
end if;			
													
exception
	when others then
		cd_material_w := cd_material_p;
end;

/*insert into log_tasy values (sysdate,nm_usuario_p,24,
				'Local estoque='||cd_local_estoque_p||' | Material='||cd_material_p||
				' | Material lt.fornec.='||cd_material_w||' | Qtde='||qt_contagem_p||
				' | Lt.Fornecedor='||nr_lote_fornec_p||' | Opção='||ie_opcao_p);
commit;*/
if	((cd_material_p <> cd_material_w) and (cd_material_p <> obter_material_generico(cd_material_w))) then
	goto Final;
end if;

CALL swisslog_registrar_itens(cd_local_estoque_p,cd_material_w,qt_contagem_p,nm_usuario_p,ie_opcao_p);

if (ie_opcao_p <> 'R') then
	goto Final;
end if;

open c01;
loop
fetch c01 into
	cd_material_w,
	qt_material_w,
	cd_local_estoque_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	qt_estoque_consig_w := 0;
	
	select	ie_consignado,
		coalesce(cd_material_estoque, cd_material)
	into STRICT	ie_consignado_w,
		cd_material_est_w
	from	material
	where	cd_material = cd_material_w;
		
	if (ie_consignado_w = '2') then
		begin
		select	max(f.dt_mesano_referencia)
		into STRICT	dt_mesano_ref_saldo_w
		from	fornecedor_mat_consignado f
		where	f.cd_estabelecimento = cd_estabelecimento_p
		and		f.cd_local_estoque = coalesce(cd_local_estoque_w,  f.cd_local_estoque)
		and		f.cd_material = cd_material_est_w;
		exception
			when others then
				dt_mesano_ref_saldo_w := PKG_DATE_UTILS.start_of(clock_timestamp(), 'MONTH', 0);
		end;
		begin
		select 	f.qt_estoque
		into STRICT	qt_estoque_consig_w
		from 	fornecedor_mat_consignado f
		where 	f.cd_estabelecimento = cd_estabelecimento_p
		and 	f.cd_material = cd_material_est_w
		and 	f.cd_local_estoque = coalesce(cd_local_estoque_w, f.cd_local_estoque)
		and 	f.dt_mesano_referencia = dt_mesano_ref_saldo_w;
		exception
			when others then
				qt_estoque_consig_w := 0;
		end;
	end if;
	
	qt_estoque_w := Obter_Saldo_Estoque(cd_estabelecimento_p, cd_material_est_w, cd_local_estoque_w, dt_mesano_referencia_w, qt_estoque_w);
	
	select	(qt_material_w - (qt_estoque_w + qt_estoque_consig_w))
	into STRICT	qt_material_estoque_w
	;
	
	if (coalesce(qt_material_estoque_w,0) > 0) then
		ie_tipo_entrada_w := 'E';
	else
		ie_tipo_entrada_w := 'S';
		qt_material_estoque_w := (qt_material_estoque_w * -1);
	end if;
	
	if (coalesce(ie_tipo_entrada_w,'X') <> 'X') then
		select	min(cd_operacao_estoque)
		into STRICT	cd_operacao_estoque_w
		from	operacao_estoque
		where	ie_tipo_requisicao = 5
		and	ie_entrada_saida = ie_tipo_entrada_w
		and	ie_consignado = '0'
		and	ie_situacao	= 'A';
	end if;
	
	if (ie_consignado_w = '2') and (ie_tipo_entrada_w = 'S') and (qt_material_estoque_w > 0) and
		((qt_estoque_w = 0) or (qt_estoque_w < qt_material_estoque_w)) then
		begin
		select	min(cd_operacao_estoque)
		into STRICT	cd_operacao_estoque_w
		from	operacao_estoque
		where	ie_tipo_requisicao = 5
		and	ie_entrada_saida = ie_tipo_entrada_w
		and	ie_consignado = '7'
		and	ie_situacao	= 'A';
		
		if (coalesce(cd_operacao_estoque_w,0) <> 0) then
			begin
			qt_dif_estoque_w := 0;
			cd_cgc_fornec_ant_w := '0';
			
			while(qt_material_estoque_w > 0) loop
				begin
				cd_cgc_fornec_w	:= substr(obter_fornecedor_regra_consig(cd_estabelecimento_p, cd_material_est_w, '1'),1,14);
				qt_estoque_consig_w := obter_saldo_estoque_consignado(cd_estabelecimento_p, cd_cgc_fornec_w, cd_material_est_w, cd_local_estoque_p, clock_timestamp(), qt_estoque_consig_w);
				
				if (qt_estoque_consig_w > 0) then
					if (qt_estoque_consig_w < qt_material_estoque_w) then
						qt_dif_estoque_w		:= qt_material_estoque_w - qt_estoque_consig_w;
						qt_material_estoque_w	:= qt_material_estoque_w - qt_dif_estoque_w;
					end if;
					
					select	nextval('movimento_estoque_seq')
					into STRICT	nr_movimento_w
					;
					
					insert into movimento_estoque(nr_movimento_estoque,cd_estabelecimento,cd_local_estoque,dt_movimento_estoque,cd_operacao_estoque,cd_acao,
						cd_material,dt_mesano_referencia,qt_movimento,dt_atualizacao,nm_usuario,ie_origem_documento,ie_origem_proced,qt_estoque,
						dt_processo,cd_material_estoque,qt_inventario,cd_fornecedor,ds_observacao)
					values ( nr_movimento_w,cd_estabelecimento_p,cd_local_estoque_w,clock_timestamp(),cd_operacao_estoque_w,1,
						cd_material_est_w,dt_mesano_referencia_w,qt_material_estoque_w,clock_timestamp(),nm_usuario_p,5,1,qt_material_estoque_w,
						null,cd_material_est_w,qt_material_estoque_w,cd_cgc_fornec_w,WHEB_MENSAGEM_PCK.get_texto(288517));
						
					qt_material_estoque_w := qt_material_estoque_w - qt_estoque_consig_w;
					if (qt_dif_estoque_w > 0) then
						qt_material_estoque_w := qt_dif_estoque_w;
						qt_dif_estoque_w := 0;
					end if;
				else
					if (cd_cgc_fornec_ant_w <> cd_cgc_fornec_w) then
						cd_cgc_fornec_ant_w := cd_cgc_fornec_w;
					else
						exit;
					end if;
				end if;
				exception
					when others then
						ds_erro_w := substr(sqlerrm,1,2000);
				end;
			end loop;
			end;
		end if;
		end;
	else
		begin
		if (coalesce(cd_operacao_estoque_w,0) <> 0) and (qt_material_estoque_w > 0) then
			begin
			select	nextval('movimento_estoque_seq')
			into STRICT	nr_movimento_w
			;
			
			begin
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
				qt_estoque,
				dt_processo,
				cd_material_estoque,
				qt_inventario,
				ds_observacao)
			values ( nr_movimento_w,
				cd_estabelecimento_p,
				cd_local_estoque_w,
				clock_timestamp(),
				cd_operacao_estoque_w,
				1,
				cd_material_est_w,
				dt_mesano_referencia_w,
				qt_material_estoque_w,
				clock_timestamp(),
				nm_usuario_p,
				5,
				1,
				qt_material_estoque_w,
				null,
				cd_material_est_w,
				qt_material_estoque_w,
				WHEB_MENSAGEM_PCK.get_texto(288517));
			exception
			when others then
				ds_erro_w := substr(sqlerrm,1,2000);
			end;
			end;
		end if;
		end;
	end if;
	end;
end loop;
close c01;

<<Final>>

ds_erro_p := ds_erro_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE swisslog_gerar_inventario ( cd_local_estoque_p bigint, cd_material_p bigint, qt_contagem_p bigint, nr_lote_fornec_p text, nm_usuario_p text, cd_estabelecimento_p bigint, ds_erro_p INOUT text, ie_opcao_p text) FROM PUBLIC;

