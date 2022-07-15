-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_requisicao_mat_cirurgia ( nr_prescricao_p bigint, nr_requisicao_p INOUT bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

	 
nr_requisicao_w			bigint:=0;
cd_operacao_transf_setor_w		smallint;
cd_local_padrao_w			varchar(4);
cd_oper_estoque_w		smallint;
cd_setor_atend_w			integer;
cd_centro_custo_w			integer:=null;
nr_sequencia_w			bigint;
cd_unid_med_consumo_w		varchar(30);
cd_unid_med_estoque_w		varchar(30);
qt_conv_estoque_consumo_w 	double precision;
qt_existe_w			bigint;
cd_material_w			integer;
qt_material_w			double precision;
cd_operacao_padrao_w		smallint;
ie_centro_custo_usua_w		varchar(1);
cd_local_usuario_w			varchar(4);
ie_verifica_local_estoque_w		varchar(4);
cd_local_estoque_w		varchar(4) := 0;
cd_setor_centro_custo_w		integer;
cd_setor_local_estoque_w		integer;
ie_centro_custo_w			varchar(15);	
ie_mat_controlador_w		varchar(15);
nr_atendimento_w			bigint;
nr_cirurgia_w			bigint;

c01 CURSOR FOR	 
	SELECT	CASE WHEN ie_mat_controlador_w='N' THEN cd_material  ELSE obter_dados_material(cd_material,'EST') END , 
		qt_material 
	from 	prescr_material 
	where	nr_prescricao    = nr_prescricao_p 
	and	ie_status_cirurgia = 'GI';
						

BEGIN 
 
select	count(*) 
into STRICT	qt_existe_w 
from 	prescr_material 
where	nr_prescricao    = coalesce(nr_prescricao_p,0) 
and	ie_status_cirurgia = 'GI';
 
if (coalesce(nr_prescricao_p,0) > 0) then 
	select	max(nr_atendimento), 
		max(nr_cirurgia) 
	into STRICT	nr_atendimento_w, 
		nr_cirurgia_w 
	from 	cirurgia 
	where	nr_prescricao    = nr_prescricao_p;
end if;
 
if (qt_existe_w > 0) then 
 
	cd_local_padrao_w := Obter_Param_Usuario(900, 347, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, cd_local_padrao_w);
	cd_operacao_padrao_w := Obter_Param_Usuario(900, 346, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, cd_operacao_padrao_w);
	ie_centro_custo_usua_w := Obter_Param_Usuario(919, 10, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_centro_custo_usua_w);
	ie_verifica_local_estoque_w := Obter_Param_Usuario(900, 453, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_verifica_local_estoque_w);
	ie_centro_custo_w := Obter_Param_Usuario(900, 468, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_centro_custo_w);
	ie_mat_controlador_w := Obter_Param_Usuario(900, 487, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_mat_controlador_w);
	 
	if (ie_centro_custo_usua_w = 'S') then 
		select 	max(cd_centro_custo) 
		into STRICT	cd_centro_custo_w 
		from  	setor_atendimento 
		where 	cd_setor_atendimento = (SELECT max(cd_setor_Atendimento) 
						from	usuario 
						where	nm_usuario = nm_usuario_p);
	end if;	
 
	if (ie_verifica_local_estoque_w = 'U') then 
		cd_setor_local_estoque_w := wheb_usuario_pck.get_cd_setor_atendimento;
	elsif (ie_verifica_local_estoque_w = 'C') then 
		select	max(cd_setor_atendimento) 
		into STRICT	cd_setor_local_estoque_w 
		from	cirurgia 
		where	nr_prescricao = nr_prescricao_p;
	end if;	
	 
	if (ie_centro_custo_w = 'U') then 
		select 	max(cd_centro_custo) 
		into STRICT	cd_centro_custo_w 
		from  	setor_atendimento 
		where 	cd_setor_atendimento = wheb_usuario_pck.get_cd_setor_atendimento;
	elsif (ie_centro_custo_w = 'C') then 
		select	max(cd_setor_atendimento) 
		into STRICT	cd_setor_centro_custo_w 
		from	cirurgia 
		where	nr_prescricao = nr_prescricao_p;
		 
		select 	max(cd_centro_custo) 
		into STRICT	cd_centro_custo_w 
		from  	setor_atendimento 
		where 	cd_setor_atendimento = cd_setor_centro_custo_w;
	end if;	
 
	if (cd_local_padrao_w IS NOT NULL AND cd_local_padrao_w::text <> '') then 
		cd_local_estoque_w := coalesce(cd_local_padrao_w,0);
	elsif (cd_setor_local_estoque_w IS NOT NULL AND cd_setor_local_estoque_w::text <> '') then 
		select coalesce(max(cd_local_estoque),0) 
		into STRICT	cd_local_estoque_w 
		from  setor_atendimento 
		where  cd_setor_atendimento = cd_setor_local_estoque_w;
	end if;			
	 
	 
	 
	select	count(*) 
	into STRICT	qt_existe_w 
	from	local_estoque 
	where	cd_local_estoque = cd_local_estoque_w;
 
	if (qt_existe_w = 0) then 
		--(-20011,'Para gerar a requisição, deve ser informado o código de local de estoque destino! Parâmetro [347]/[453].'); 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(203883);
	end if;
		 
	if (coalesce(cd_operacao_padrao_w::text, '') = '') then 
		--(-20011,'Para gerar a requisição, deve ser informado a operação de estoque padrão! Parâmetro [346].'); 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(203884);
	end if;
 
	select	nextval('requisicao_seq') 
	into STRICT	nr_requisicao_w 
	;
 
	begin 
	insert into requisicao_material( 
		nr_requisicao, 
		cd_estabelecimento, 
		cd_local_estoque, 
		dt_solicitacao_requisicao, 
		dt_atualizacao, 
		nm_usuario, 
		cd_operacao_estoque, 
		cd_pessoa_requisitante, 
		cd_estabelecimento_destino, 
		cd_local_estoque_destino, 
		cd_setor_atendimento, 
		ie_urgente, 
		ie_geracao, 
		cd_centro_custo, 
		nr_cirurgia, 
		nr_prescricao, 
		nr_atendimento) 
	values (	nr_requisicao_w, 
		cd_estabelecimento_p, 
		CASE WHEN coalesce(campo_numerico(cd_local_estoque_w),0)=0 THEN null  ELSE coalesce(campo_numerico(cd_local_estoque_w),0) END , 
		clock_timestamp(), 
		clock_timestamp(), 
		nm_usuario_p, 
		cd_operacao_padrao_w, 
		Obter_Pessoa_Fisica_Usuario(nm_usuario_p,'C'), 
		cd_estabelecimento_p, 
		null, 
		null, 
		'N', 
		'A', 
		cd_centro_custo_w, 
		nr_cirurgia_w, 
		nr_prescricao_p, 
		nr_atendimento_w);
	exception when others then 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(203890);
	end;
 
	if (nr_requisicao_w > 0) then 
		select	cd_operacao_estoque, 
			cd_setor_atendimento, 
			cd_centro_custo 
		into STRICT	cd_oper_estoque_w, 
			cd_setor_atend_w, 
			cd_centro_custo_w 
		from	requisicao_material 
		where	nr_requisicao = nr_requisicao_w;
		 
		open C01;
		loop 
		fetch C01 into	 
			cd_material_w, 
			qt_material_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin 
			select	substr(obter_dados_material_estab(cd_material,cd_estabelecimento_p,'UMS'),1,30) cd_unidade_medida_consumo, 
				substr(obter_dados_material_estab(cd_material,cd_estabelecimento_p,'UME'),1,30) cd_unidade_medida_estoque, 
				qt_conv_estoque_consumo 
			into STRICT	cd_unid_med_consumo_w, 
				cd_unid_med_estoque_w, 
				qt_conv_estoque_consumo_w 
			from	material 
			where	cd_material = cd_material_w;			
 
			select	coalesce(max(nr_sequencia),0) + 1 
			into STRICT	nr_sequencia_w 
			from	item_requisicao_material 
			where	nr_requisicao = nr_requisicao_w;
 
			insert into item_requisicao_material( 
				nr_requisicao, 
				nr_sequencia, 
				cd_estabelecimento, 
				cd_material, 
				qt_material_requisitada, 
				qt_material_atendida, 
				vl_material, 
				dt_atualizacao, 
				nm_usuario, 
				cd_unidade_medida, 
				dt_atendimento, 
				cd_pessoa_recebe, 
				cd_pessoa_atende, 
				ie_acao, 
				cd_motivo_baixa, 
				qt_estoque, 
				cd_unidade_medida_estoque, 
				cd_conta_contabil, 
				cd_material_req, 
				ds_observacao, 
				ie_geracao) 
			values (	nr_requisicao_w, 
				nr_sequencia_w, 
				cd_estabelecimento_p, 
				cd_material_w, 
				qt_material_w, 
				0, 
				0, 
				clock_timestamp(), 
				nm_usuario_p, 
				cd_unid_med_consumo_w, 
				null, 
				null, 
				null, 
				'1', 
				0, 
				(qt_material_w / qt_conv_estoque_consumo_w), 
				cd_unid_med_estoque_w, 
				null, 
				cd_material_w, 
				null, 
				null);
			 
			end;
		end loop;
		close C01;
	end if;	
	commit;
end if;
nr_requisicao_p	:= nr_requisicao_w;	
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_requisicao_mat_cirurgia ( nr_prescricao_p bigint, nr_requisicao_p INOUT bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

