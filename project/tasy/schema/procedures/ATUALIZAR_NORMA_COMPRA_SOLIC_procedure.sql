-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_norma_compra_solic ( nr_solic_compra_p bigint, ie_acao_p text, nm_usuario_p text) AS $body$
DECLARE


/*
ie_acao_p
L	- Foi executada no momento de liberar a solicitacao
A	- Foi executada no momento de aprovar a solicitacao
SS	- Salvar a solicitacao de compras
SI	- Salvar o item da solicitacao de compras
*/
					
					
nr_seq_norma_compra_w		bigint;
cd_estabelecimento_w		bigint;
cd_material_w			bigint;
nr_item_solic_compra_w		bigint;
dt_entrega_ant_w			timestamp;
dt_entrega_atual_w			timestamp;
dt_entrega_ref_w			timestamp;
qt_dias_ajustado_w			bigint;
nr_item_solic_compra_entr_w		bigint;
dt_entrega_solicitada_ant_w		timestamp;
dt_entrega_solicitada_atual_w	timestamp;
ie_dias_uteis_w			varchar(1);
ds_acao_w			varchar(20);
ds_historico_item_w			varchar(500);
ds_historico_prog_w		varchar(3500);
ds_historico_geral_w		varchar(4000);	
nm_usuario_solic_w			varchar(15);
nr_seq_classif_w			bigint;
nr_seq_comunic_w			bigint;
linha_w					bigint;
ds_comunicado_w				text;
ds_material_w				varchar(255);
nr_solic_compra_w			bigint;

c01 CURSOR FOR
SELECT	cd_material,
	substr(obter_desc_material(cd_material),1,255),
	nr_item_solic_compra,
	ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_solic_item)
from	solic_compra_item
where	nr_solic_compra = nr_solic_compra_w;

c02 CURSOR FOR
SELECT	row_number() OVER () AS linha,
	nr_item_solic_compra_entr,
	dt_entrega
from (	SELECT	nr_item_solic_compra_entr,
		ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_entrega_solicitada) dt_entrega
	from	solic_compra_item_entrega
	where	nr_solic_compra = nr_solic_compra_w
	and	nr_item_solic_compra = nr_item_solic_compra_w
	order by	dt_entrega_solicitada) alias1;


BEGIN

if (ie_acao_p = 'L') then
	ds_acao_w	:= WHEB_MENSAGEM_PCK.get_texto(297553);
elsif (ie_acao_p = 'A') then
	ds_acao_w	:= WHEB_MENSAGEM_PCK.get_texto(297555);
end if;

nr_solic_compra_w := nr_solic_compra_p;

begin
	select	cd_estabelecimento,
		obter_usuario_pessoa(cd_pessoa_solicitante)
	into STRICT	cd_estabelecimento_w,
		nm_usuario_solic_w
	from	solic_compra
	where	nr_solic_compra = nr_solic_compra_w;
exception
when others then
	nr_solic_compra_w := 0;
end;

if (nr_solic_compra_w > 0) then

	open C01;
	loop
	fetch C01 into	
		cd_material_w,
		ds_material_w,
		nr_item_solic_compra_w,
		dt_entrega_ant_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		
		ds_historico_item_w	:= '';
		ds_historico_prog_w	:= '';
		ds_historico_geral_w	:= '';
		qt_dias_ajustado_w	:= 0;
		
		select	obter_norma_compra_item_solic(nr_solic_compra_w, cd_material_w)
		into STRICT	nr_seq_norma_compra_w
		;
		
		update	solic_compra_item
		set	nr_seq_norma_compra	= nr_seq_norma_compra_w,
			nm_usuario		= nm_usuario_p,
			dt_atualizacao		= clock_timestamp()
		where	nr_solic_compra		= nr_solic_compra_w
		and	nr_item_solic_compra	= nr_item_solic_compra_w;
		
		if (nr_seq_norma_compra_w > 0) then
			
			select	ie_dias_uteis
			into STRICT	ie_dias_uteis_w
			from	sup_normas_compras
			where	nr_sequencia = nr_seq_norma_compra_w;
			
			select	trunc(obter_dt_entrega_norma_compra(nr_seq_norma_compra_w, cd_estabelecimento_w),'dd')
			into STRICT	dt_entrega_atual_w
			;
			
			if (dt_entrega_atual_w <> dt_entrega_ant_w) and (dt_entrega_atual_w > ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(clock_timestamp())) then

				update	solic_compra_item
				set	dt_solic_item		= dt_entrega_atual_w,
					nm_usuario		= nm_usuario_p,
					dt_atualizacao		= clock_timestamp()
				where	nr_solic_compra		= nr_solic_compra_w
				and	nr_item_solic_compra	= nr_item_solic_compra_w;
				
				ds_historico_item_w		:= substr(	WHEB_MENSAGEM_PCK.get_texto(297564,'DS_ACAO_W=' || ds_acao_w || ';' || 'NR_ITEM_SOLIC_COMPRA_W=' || nr_item_solic_compra_w || ';' ||
													'CD_MATERIAL_W=' || cd_material_w || ';' || 'DS_AMTERIAL_W=' || ds_material_w || ';' ||
													'DT_ENTREGA_ANT_W=' || dt_entrega_ant_w || ';' || 'DT_ENTREGA_ATUAL_W=' || dt_entrega_atual_w),1,500);
			
								
				open C02;
				loop
				fetch C02 into	
					linha_w,
					nr_item_solic_compra_entr_w,
					dt_entrega_solicitada_ant_w;
				EXIT WHEN NOT FOUND; /* apply on C02 */
					begin

					if (linha_w = 1) then					

						if (dt_entrega_atual_w <> dt_entrega_solicitada_ant_w) then
							update	solic_compra_item_entrega
							set	dt_entrega_solicitada		= dt_entrega_atual_w,
								nm_usuario			= nm_usuario_p,
								dt_atualizacao			= clock_timestamp()
							where	nr_solic_compra			= nr_solic_compra_w
							and	nr_item_solic_compra		= nr_item_solic_compra_w
							and	nr_item_solic_compra_entr	= nr_item_solic_compra_entr_w;
											
							ds_historico_prog_w	:= substr(WHEB_MENSAGEM_PCK.get_texto(297565,'DS_HISTORICO_PROG_W=' || ds_historico_prog_w || ';' ||
															'DT_ENTREGA_SOLICITADA_ANT_W=' || dt_entrega_solicitada_ant_w || ';' ||
															'DT_ENTREGA_ATUAL_W=' || dt_entrega_atual_w),1,3500);						
						end if;
						
						dt_entrega_ref_w	:= dt_entrega_solicitada_ant_w;
						
					else
						
						if (ie_dias_uteis_w = 'S') then
							qt_dias_ajustado_w		:= obter_dias_entre_datas(dt_entrega_ref_w, dt_entrega_solicitada_ant_w);
							dt_entrega_solicitada_atual_w	:= obter_dia_util_periodo(cd_estabelecimento_w, dt_entrega_ref_w, qt_dias_ajustado_w);
						else
							qt_dias_ajustado_w		:= obter_dias_entre_datas(dt_entrega_ref_w, dt_entrega_solicitada_ant_w);
							dt_entrega_solicitada_atual_w	:= ESTABLISHMENT_TIMEZONE_UTILS.startOfDay((dt_entrega_ref_w + (qt_dias_ajustado_w)));
						end if;
					
						dt_entrega_ref_w			:= dt_entrega_solicitada_ant_w;
					
						if (dt_entrega_solicitada_atual_w <> dt_entrega_solicitada_ant_w) then
							
							update	solic_compra_item_entrega
							set	dt_entrega_solicitada		= dt_entrega_solicitada_atual_w,
								nm_usuario			= nm_usuario_p,
								dt_atualizacao			= clock_timestamp()
							where	nr_solic_compra			= nr_solic_compra_w
							and	nr_item_solic_compra		= nr_item_solic_compra_w
							and	nr_item_solic_compra_entr	= nr_item_solic_compra_entr_w;
											
							ds_historico_prog_w	:= substr(WHEB_MENSAGEM_PCK.get_texto(297565,'DS_HISTORICO_PROG_W=' || ds_historico_prog_w || ';' ||
															'DT_ENTREGA_SOLICITADA_ANT_W=' || dt_entrega_solicitada_ant_w || ';' ||
															'DT_ENTREGA_ATUAL_W=' || dt_entrega_solicitada_atual_w),1,3500);
							
						end if;
					end if;
					end;
				end loop;
				close C02;

				ds_historico_prog_w := substr(ds_historico_prog_w ||  chr(13) || chr(10) ||  chr(13) || chr(10),1,3500);
				
				if (ds_historico_item_w IS NOT NULL AND ds_historico_item_w::text <> '') then
				
					ds_historico_geral_w := ds_historico_item_w;
					
					if (ds_historico_prog_w IS NOT NULL AND ds_historico_prog_w::text <> '') then	
						ds_historico_geral_w	:= substr(WHEB_MENSAGEM_PCK.get_texto(297566,'DS_HISTORICO_GERAL_W=' || ds_historico_geral_w || ';' ||
													'DS_HISTORICO_PROG_W=' || ds_historico_prog_w),1,4000);
					end if;
					
					ds_comunicado_w	:= substr(ds_comunicado_w || ds_historico_geral_w,1,4000);
					
					if (ie_acao_p in ('A','L')) then
						CALL gerar_historico_solic_compra(
							nr_solic_compra_w,
							WHEB_MENSAGEM_PCK.get_texto(297567),
							ds_historico_geral_w,
							'NCO',
							nm_usuario_p);	
					end if;
				end if;
			end if;
		end if;
		
		end;
	end loop;
	close C01;

	if (ds_comunicado_w IS NOT NULL AND ds_comunicado_w::text <> '') and (ie_acao_p in ('A','L')) then

		select	obter_classif_comunic('F')
		into STRICT	nr_seq_classif_w
		;
			
		select	nextval('comunic_interna_seq')
		into STRICT	nr_seq_comunic_w
		;

		insert into comunic_interna(
			dt_comunicado,
			ds_titulo,
			ds_comunicado,
			nm_usuario,
			dt_atualizacao,
			ie_geral,
			nm_usuario_destino,
			nr_sequencia,
			ie_gerencial,
			nr_seq_classif,
			dt_liberacao)
		values (	clock_timestamp(),
			WHEB_MENSAGEM_PCK.get_texto(297568,'NR_SOLIC_COMPRA_W=' || nr_solic_compra_w),
			ds_comunicado_w,
			nm_usuario_p,
			clock_timestamp(),
			'N',
			nm_usuario_solic_w,
			nr_seq_comunic_w,
			'N',
			nr_seq_classif_w,
			clock_timestamp());

		insert into comunic_interna_lida(nr_sequencia,nm_usuario,dt_atualizacao)values (nr_seq_comunic_w,nm_usuario_p,clock_timestamp());
	end if;

	if (ie_acao_p in ('SS','SI')) then
		if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
	end if;
end if;
	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_norma_compra_solic ( nr_solic_compra_p bigint, ie_acao_p text, nm_usuario_p text) FROM PUBLIC;

