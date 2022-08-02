-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sup_dispensar_kit ( nr_seq_kit_estoque_p bigint, nm_usuario_p text, cd_local_estoque_destino_p bigint, cd_setor_atendimento_p bigint, ie_liberar_p text, ie_baixar_p text, ie_estorno_p text default 'N', nr_requisicao_p INOUT bigint DEFAULT NULL, ds_erro_p INOUT text DEFAULT NULL) AS $body$
DECLARE

					
					
ie_status_kit_w			varchar(2);	
nr_requisicao_w			bigint;
cd_estabelecimento_w		smallint;
cd_local_estoque_w		smallint;
cd_material_w			integer;
qt_requisicao_w			double precision;
cd_pessoa_requisitante_w		bigint;	
cd_unidade_medida_estoque_w	varchar(30);
cd_unidade_medida_w		varchar(30);
nr_sequencia_w			bigint;
nr_seq_erro_w			bigint;
cd_operacao_estoque_w		requisicao_material.cd_operacao_estoque%type;
qt_requisicao_estoque_w		double precision;
ie_baixa_sem_estoque_w		varchar(255);
cd_setor_atendimento_w		integer;
cd_centro_custo_w			integer;
ds_erro_w			varchar(255);
nr_seq_lote_fornec_w		bigint;
cd_setor_destino_w			kit_estoque.cd_setor_destino%type;
qt_req_kit_w			smallint;

C01 CURSOR FOR
SELECT	a.cd_material,
	a.qt_material,
	a.nr_seq_lote_fornec
from	kit_estoque_comp a
where	nr_seq_kit_estoque = nr_seq_kit_estoque_p
and 	ie_gerado_barras = 'S';


BEGIN
ie_status_kit_w := substr(obter_status_montagem_kit(nr_seq_kit_estoque_p),1,2);
	
begin
select	cd_estabelecimento,
	cd_local_estoque,
	cd_setor_destino
into STRICT	cd_estabelecimento_w,
	cd_local_estoque_w,
	cd_setor_destino_w
from	kit_estoque
where	nr_sequencia = nr_seq_kit_estoque_p;
exception
when others then
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(263000,'NR_SEQ_KIT_ESTOQUE=' || nr_seq_kit_estoque_p);
end;

if (ie_estorno_p = 'S') then
	cd_setor_atendimento_w := cd_setor_destino_w;
else
	cd_setor_atendimento_w := cd_setor_atendimento_p;
end if;

/*if	(ie_status_kit_w <> 'PD') then
	Wheb_mensagem_pck.exibir_mensagem_abort(263001,'NR_SEQ_KIT_ESTOQUE=' || nr_seq_kit_estoque_p);
elsif	(ie_estorno_p = 'S') and
	(ie_status_kit_w <> 'DI') then
	-- O kit estoque #@NR_SEQ_KIT_ESTOQUE#@ nao esta dispensado!

	Wheb_mensagem_pck.exibir_mensagem_abort(449588,'NR_SEQ_KIT_ESTOQUE=' || nr_seq_kit_estoque_p);
end if;*/
if (ie_estorno_p = 'S') then
	begin
	if (ie_status_kit_w <> 'DI') then
		begin
		-- O kit estoque #@NR_SEQ_KIT_ESTOQUE#@ nao esta dispensado!
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(449588,'NR_SEQ_KIT_ESTOQUE=' || nr_seq_kit_estoque_p);
		end;
	end if;
	
	select	count(1)
	into STRICT	qt_req_kit_w
	from	requisicao_material a,
		item_requisicao_material b
	where	b.nr_requisicao = a.nr_requisicao
	and	a.ie_origem_requisicao = 'DKT'
	and	b.nr_seq_kit_estoque = nr_seq_kit_estoque_p;
	
	if (qt_req_kit_w = 0) then
		-- 449971 - Nao e possivel realizar o estorno pois nao existe requisicao para o kit.
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(449971);
	end if;
	
	end;
elsif (ie_status_kit_w <> 'PD') then
	begin
	-- O kit estoque #@NR_SEQ_KIT_ESTOQUE#@ nao esta pendente de dispensacao!
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(263001,'NR_SEQ_KIT_ESTOQUE=' || nr_seq_kit_estoque_p);
	end;
end if;

if (cd_local_estoque_destino_p IS NOT NULL AND cd_local_estoque_destino_p::text <> '') then
	begin
	select	max(cd_operacao_transf_setor)
	into STRICT	cd_operacao_estoque_w
	from	parametro_estoque
	where	cd_estabelecimento = cd_estabelecimento_w;
	end;
elsif (cd_setor_atendimento_w IS NOT NULL AND cd_setor_atendimento_w::text <> '') then
	begin
	
	if (ie_estorno_p = 'S') then
		begin
		
		begin
		select	cd_oper_dev_consumo_setor
		into STRICT	cd_operacao_estoque_w
		from	parametro_estoque
		where	cd_estabelecimento = cd_estabelecimento_w
		and	(cd_oper_dev_consumo_setor IS NOT NULL AND cd_oper_dev_consumo_setor::text <> '');
		exception
		when others then
			-- 449953 - Para realizar o estorno deve possuir operacao de devolucao de consumo cadastrada para este estabelecimento.
			CALL Wheb_mensagem_pck.exibir_mensagem_abort(449953);
		end;
		
		end;
	else
		select	max(cd_operacao_consumo_setor)
		into STRICT	cd_operacao_estoque_w
		from	parametro_estoque
		where	cd_estabelecimento = cd_estabelecimento_w;
	end if;
			
	begin
	select	cd_centro_custo
	into STRICT	cd_centro_custo_w
	from	setor_atendimento
	where	cd_setor_atendimento = cd_setor_atendimento_w;
	exception
	when others then
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(263005);
	end;
	end;
end if;

if (coalesce(nr_requisicao_p::text, '') = '') then
	begin
	select	nextval('requisicao_seq') 
	into STRICT	nr_requisicao_w
	;
	
	nr_requisicao_p := nr_requisicao_w;
	
	cd_pessoa_requisitante_w := substr(obter_pessoa_fisica_usuario(nm_usuario_p,'C'),1,10);
	
	insert into requisicao_material(
		nr_requisicao,
		cd_estabelecimento,
		dt_solicitacao_requisicao,
		dt_atualizacao,
		nm_usuario,
		cd_operacao_estoque,
		cd_pessoa_requisitante,
		cd_local_estoque,
		cd_local_estoque_destino,
		nm_usuario_lib,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ie_geracao,
		ie_urgente,
		nr_seq_solic_kit,
		cd_centro_custo,
		ie_origem_requisicao)
	values (	nr_requisicao_p,
		cd_estabelecimento_w,
		clock_timestamp(),
		clock_timestamp(),
		nm_usuario_p,
		cd_operacao_estoque_w,
		cd_pessoa_requisitante_w,
		cd_local_estoque_w,
		cd_local_estoque_destino_p,
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		'K',
		'N',
		null,
		cd_centro_custo_w,
		'DKT');
	end;
end if;


update	kit_estoque
set	cd_setor_destino = CASE WHEN ie_estorno_p='S' THEN  null  ELSE cd_setor_atendimento_w END
where	nr_sequencia 	 = nr_seq_kit_estoque_p;


begin
open C01;
loop
fetch C01 into	
	cd_material_w,
	qt_requisicao_w,
	nr_seq_lote_fornec_w;
EXIT WHEN NOT FOUND; /* apply on C01 */	
	begin
	select	coalesce(max(nr_sequencia),0) + 1
	into STRICT	nr_sequencia_w
	from	item_requisicao_material
	where	nr_requisicao = nr_requisicao_p;
		
	cd_unidade_medida_w 		:= substr(obter_dados_material_estab(cd_material_w,cd_estabelecimento_w,'UMS'),1,30);
	cd_unidade_medida_estoque_w	:= substr(obter_dados_material_estab(cd_material_w,cd_estabelecimento_w,'UME'),1,30);
	qt_requisicao_estoque_w		:= obter_quantidade_convertida(cd_material_w,qt_requisicao_w,cd_unidade_medida_w,'UME');
	
	update	item_requisicao_material
	set	qt_material_requisitada = qt_material_requisitada + qt_requisicao_w,
		qt_estoque = qt_estoque + qt_requisicao_estoque_w
	where	nr_requisicao = nr_requisicao_p
	and	cd_material = cd_material_w
	and	nr_seq_kit_estoque = nr_seq_kit_estoque_p
	and	coalesce(nr_seq_lote_fornec, 0) = coalesce(nr_seq_lote_fornec_w,0);
	
	if (NOT FOUND) then
		insert into item_requisicao_material(
			nr_requisicao,
			nr_sequencia,
			cd_estabelecimento,
			cd_material,
			qt_material_requisitada,
			vl_material,
			dt_atualizacao,
			nm_usuario,
			cd_unidade_medida,
			cd_unidade_medida_estoque,
			qt_estoque,
			nr_seq_kit_estoque,
			nr_seq_lote_fornec)
		values ( nr_requisicao_p,
			nr_sequencia_w,
			cd_estabelecimento_w,
			cd_material_w,
			qt_requisicao_w,
			0,
			clock_timestamp(),
			nm_usuario_p,
			cd_unidade_medida_w,
			cd_unidade_medida_estoque_w,
			qt_requisicao_estoque_w,
			nr_seq_kit_estoque_p,
			nr_seq_lote_fornec_w);
	end if;
	end;
end loop;
close C01;
end;

if (ie_liberar_p = 'S') and (nr_requisicao_p IS NOT NULL AND nr_requisicao_p::text <> '') then
	begin
	ds_erro_p := consistir_requisicao(nr_requisicao_p, nm_usuario_p, cd_local_estoque_destino_p, cd_centro_custo_w, 'N', 'N', 'N', 'N', 'S', 'S', 'N', cd_operacao_estoque_w, ds_erro_p);
	
	begin
	select	nr_sequencia,
		cd_material,
		substr(ds_consistencia,1,255)
	into STRICT	nr_seq_erro_w,
		cd_material_w,
		ds_erro_p
	from	requisicao_mat_consist
	where	nr_requisicao = nr_requisicao_p  LIMIT 1;	
	exception
	when others then
		nr_seq_erro_w	:= 0;
		ds_erro_p	:= null;
	end;

	if (nr_seq_erro_w > 0) then
		begin
		if (cd_material_w IS NOT NULL AND cd_material_w::text <> '') then
			ds_erro_p := substr(WHEB_MENSAGEM_PCK.get_texto(281036) || lpad(cd_material_w,6,'0') || ' - ' || Obter_Desc_Material(cd_material_w) || ', ' || ds_erro_p,1,255);
		end if;
		end;
	end if;				
	end;
end if;

if (ds_erro_p IS NOT NULL AND ds_erro_p::text <> '' AND nr_requisicao_p IS NOT NULL AND nr_requisicao_p::text <> '') then
	rollback;
	if (ie_estorno_p <> 'S' or coalesce(ie_estorno_p::text, '') = '') then
		update kit_estoque a set  a.cd_setor_destino  = NULL
		where exists (
			SELECT a.cd_setor_destino, a.nr_sequencia, b.nr_requisicao
            from  
                requisicao_material b,
                item_requisicao_material c
             where   a.nr_sequencia = c.nr_seq_kit_estoque
             and 	 b.nr_requisicao = c.nr_requisicao
             and     b.nr_requisicao = nr_requisicao_p 
             and     coalesce(b.dt_baixa::text, '') = ''
        );
	
		delete from requisicao_material a
		where a.nr_requisicao = nr_requisicao_p
		and   coalesce(a.dt_baixa::text, '') = '';
	end if;	
elsif (ie_baixar_p = 'S') and (nr_requisicao_p IS NOT NULL AND nr_requisicao_p::text <> '') then
	begin
	ie_baixa_sem_estoque_w	:= substr(obter_parametro_funcao(919,7,nm_usuario_p),1,1);
	cd_setor_atendimento_w	:= wheb_usuario_pck.get_cd_setor_atendimento;
	
	ds_erro_p := baixa_automatica_requisicao('1', cd_local_estoque_w, nr_requisicao_p, cd_operacao_estoque_w, ie_baixa_sem_estoque_w, nm_usuario_p, cd_setor_atendimento_w, ds_erro_p);
	end;
end if;

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sup_dispensar_kit ( nr_seq_kit_estoque_p bigint, nm_usuario_p text, cd_local_estoque_destino_p bigint, cd_setor_atendimento_p bigint, ie_liberar_p text, ie_baixar_p text, ie_estorno_p text default 'N', nr_requisicao_p INOUT bigint DEFAULT NULL, ds_erro_p INOUT text DEFAULT NULL) FROM PUBLIC;

