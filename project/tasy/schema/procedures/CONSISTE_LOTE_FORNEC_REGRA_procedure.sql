-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_lote_fornec_regra ( cd_material_p bigint, nr_seq_lote_fornec_p bigint, nr_sequencia_p bigint, cd_local_estoque_p bigint, ie_evento_p bigint, cd_lote_fabricacao_p text default null) AS $body$
DECLARE


ds_lote_fornec_w	material_lote_fornec.ds_lote_fornec%type;
ds_acao_lote_w		lote_fornec_restricao.ds_acao%type;
qt_existe_regra_w	integer;
ie_bloqueio_w		varchar(1);
nr_sequencia_ww		bigint;
dt_validade_ww		timestamp;
ie_avisa_val_menor_w	varchar(1);
ie_local_estoque_lote_w	varchar(1) := 'N';
qt_dias_validade_w	bigint := 0;
cd_local_estoque_w	smallint;
cd_estabelecimento_w	bigint;
cd_local_est_w		smallint;
ie_bloqueio_lote_w	varchar(1);
ie_estoque_lote_w	varchar(1);
dt_validade_w		material_lote_fornec.dt_validade%type;
nr_prescricao_w		ap_lote.nr_prescricao%type;

C01 CURSOR FOR
	SELECT 	nr_sequencia,
		dt_validade	
	from	material_lote_fornec a
	where	dt_validade < dt_validade_w
	and	dt_validade > clock_timestamp()
	and	ie_situacao = 'A'
	and	cd_material = cd_material_p
	and	cd_estabelecimento = cd_estabelecimento_w
	and (ie_estoque_lote_w = 'N' or coalesce(ie_local_estoque_lote_w,'N') = 'N')
	and (ie_bloqueio_lote_w = 'N' or coalesce(ie_bloqueio,'N') = 'N')
	
union all

	SELECT 	nr_sequencia,
		dt_validade	
	from	material_lote_fornec a
	where	obter_saldo_estoque_lote(cd_estabelecimento_w,cd_material_p, cd_local_estoque_w,pkg_date_utils.start_of(clock_timestamp(), 'MM', null),nr_sequencia) > 0
	and	dt_validade < dt_validade_w
	and	dt_validade > clock_timestamp()
	and	ie_situacao = 'A'
	and	cd_material = cd_material_p
	and	cd_estabelecimento = cd_estabelecimento_w
	and	ie_estoque_lote_w = 'S'
	and	coalesce(ie_local_estoque_lote_w,'N') = 'S'
	and (ie_bloqueio_lote_w = 'N' or coalesce(ie_bloqueio,'N') = 'N')
	order by dt_validade desc;


BEGIN

if (nr_seq_lote_fornec_p IS NOT NULL AND nr_seq_lote_fornec_p::text <> '') or (cd_lote_fabricacao_p IS NOT NULL AND cd_lote_fabricacao_p::text <> '') then
	/*Primeira validacao regra Restricao do lote fornecedor*/

	select	upper(max(ds_lote_fornec))
	into STRICT	ds_lote_fornec_w
	from	material_lote_fornec
	where 	nr_sequencia = nr_seq_lote_fornec_p;
	
	if (cd_lote_fabricacao_p IS NOT NULL AND cd_lote_fabricacao_p::text <> '') then
		ds_lote_fornec_w := cd_lote_fabricacao_p;
	end if;
	
	if (coalesce(obter_se_lote_forn_restricao(cd_material_p, ds_lote_fornec_w),'N') = 'S') then
		
		select	max(ds_acao)
		into STRICT	ds_acao_lote_w
		from	lote_fornec_restricao
		where	cd_material = cd_material_p
		and		upper(ds_lote_fornec) = ds_lote_fornec_w
		and		ie_bloquear_lote_nf = 'S'
		and		ie_situacao = 'A'  LIMIT 1;
		
		CALL wheb_mensagem_pck.exibir_mensagem_abort(289182, 'DS_LOTE_FORNEC='||ds_lote_fornec_w||';'||
								'NR_ITEM_NF='||cd_material_p || ';' ||
								'DS_ACAO='||DS_ACAO_lote_w || ' - ' ||
								WHEB_MENSAGEM_PCK.get_texto(289181));
	end if;

	/*Segunda validacao regra Validade menor lote*/

	if (ie_evento_p = 34) then
		select	max(cd_local_estoque),
			max(cd_estabelecimento)
		into STRICT	cd_local_est_w,
			cd_estabelecimento_w
		from	requisicao_material
		where 	nr_requisicao = nr_sequencia_p;
	elsif (ie_evento_p = 270) then
		select	max(cd_estabelecimento)
		into STRICT	cd_estabelecimento_w
		from	atendimento_paciente
		where 	nr_atendimento = nr_sequencia_p;
		
		cd_local_est_w := cd_local_estoque_p;
	elsif (ie_evento_p = 265) then
		select	max(cd_local_estoque),
			max(nr_prescricao)
		into STRICT	cd_local_est_w,
			nr_prescricao_w
		from	ap_lote
		where 	nr_sequencia = nr_sequencia_p;
		
		select 	max(cd_estabelecimento)
		into STRICT	cd_estabelecimento_w
		from	prescr_medica
		where 	nr_prescricao = nr_prescricao_w;
	elsif (ie_evento_p = 295) then		
		goto final_1;
	elsif (ie_evento_p in (65,66)) then		
		goto final_1;
	end if;
	
	select	coalesce(max(ie_avisa_validade_lote),'N')
	into STRICT	ie_avisa_val_menor_w
	from	parametro_estoque
	where	cd_estabelecimento	= cd_estabelecimento_w;
	
	select	coalesce(max(ie_bloqueio_lote),'N')
	into STRICT	ie_bloqueio_lote_w
	from	parametro_estoque
	where	cd_estabelecimento	= cd_estabelecimento_w;
	
	CALL wheb_adm_pck.set_cd_estabelecimento(cd_estabelecimento_w);
	
	if (ie_avisa_val_menor_w = 'R') and (coalesce(cd_material_p,0) > 0) then
		SELECT * FROM obter_regra_aviso_validade(cd_material_p, cd_estabelecimento_w, ie_avisa_val_menor_w, qt_dias_validade_w, ie_local_estoque_lote_w) INTO STRICT ie_avisa_val_menor_w, qt_dias_validade_w, ie_local_estoque_lote_w;
	end if;
		
	if (ie_avisa_val_menor_w <> 'N') then
		if (ie_local_estoque_lote_w = 'S') then
			cd_local_estoque_w := cd_local_est_w;
		end if;
		
		select	coalesce(max(ie_estoque_lote),'N')
		into STRICT	ie_estoque_lote_w
		from	material_estab
		where	cd_material = cd_material_p
		and	cd_estabelecimento = cd_estabelecimento_w;
				
		select	max(a.dt_validade)
		into STRICT	dt_validade_w
		from	material_lote_fornec a
		where	a.nr_sequencia = nr_seq_lote_fornec_p;
		
		open C01;
		loop
		fetch C01 into	
			nr_sequencia_ww,
			dt_validade_ww;
		EXIT WHEN NOT FOUND; /* apply on C01 */
		end loop;
		close C01;
	
		if (dt_validade_ww IS NOT NULL AND dt_validade_ww::text <> '') then
			if (ie_avisa_val_menor_w = 'S') then
				if (qt_dias_validade_w = 0) or
					((dt_validade_ww - qt_dias_validade_w) < clock_timestamp()) then
					--avisar
					CALL wheb_mensagem_pck.exibir_mensagem_abort(WHEB_MENSAGEM_PCK.get_texto(281023) || WHEB_MENSAGEM_PCK.get_texto(281024) || nr_sequencia_ww || ' ' || WHEB_MENSAGEM_PCK.get_texto(281025) || to_char(dt_validade_ww,'dd/mm/yyyy'));
				end if;
			else
				if (qt_dias_validade_w = 0) or
					((dt_validade_ww - qt_dias_validade_w) < clock_timestamp()) then
					--impedir
					CALL wheb_mensagem_pck.exibir_mensagem_abort(WHEB_MENSAGEM_PCK.get_texto(953220) || WHEB_MENSAGEM_PCK.get_texto(281024) || nr_sequencia_ww || ' ' || WHEB_MENSAGEM_PCK.get_texto(281025) || to_char(dt_validade_ww,'dd/mm/yyyy'));
				end if;
			end if;
		end if;
	end if;
end if;
<<final_1>>
null;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_lote_fornec_regra ( cd_material_p bigint, nr_seq_lote_fornec_p bigint, nr_sequencia_p bigint, cd_local_estoque_p bigint, ie_evento_p bigint, cd_lote_fabricacao_p text default null) FROM PUBLIC;

