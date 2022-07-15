-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_requisicao_mat_barras ( nr_prescricao_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, cd_local_origem_p bigint, cd_local_destino_p bigint) AS $body$
DECLARE

	 
nr_requisicao_w				bigint:=0;
cd_operacao_transf_setor_w		smallint;
cd_oper_estoque_w			smallint;
cd_setor_atend_w			integer;
cd_local_estoque_w			smallint;
nr_sequencia_w				bigint;
cd_unid_med_consumo_w			varchar(30);
cd_unid_med_estoque_w			varchar(30);
qt_conv_estoque_consumo_w 		double precision;
qt_existe_w				bigint;
cd_material_w				integer;
qt_material_w				double precision;
cd_operacao_padrao_w			smallint;
ie_centro_custo_usua_w			varchar(1);
nm_paciente_w				varchar(150);
ie_prescr_especial_w			varchar(1);

expressao1_w	varchar(255) := obter_desc_expressao_idioma(325811, null, wheb_usuario_pck.get_nr_seq_idioma);--Paciente: 
	 
c01 CURSOR FOR	 
	SELECT	cd_material, 
		qt_material 
	from 	prescr_material 
	where	nr_prescricao    = nr_prescricao_p 
	and	ie_status_cirurgia = 'CB';
						

BEGIN 
 
select	count(*) 
into STRICT	qt_existe_w 
from 	prescr_material 
where	nr_prescricao    = coalesce(nr_prescricao_p,0) 
and	ie_status_cirurgia = 'CB';
 
if (qt_existe_w > 0) then 
	cd_operacao_padrao_w := Obter_Param_Usuario(871, 667, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, cd_operacao_padrao_w);
	 
	select	nextval('requisicao_seq') 
	into STRICT	nr_requisicao_w 
	;
	 
	if (coalesce(cd_operacao_padrao_w::text, '') = '') then 
		CALL wheb_mensagem_pck.Exibir_Mensagem_Abort(190833);
	end if;
	 
	 
	SELECT	SUBSTR(expressao1_w || ' ' || obter_nome_pf(max(cd_pessoa_fisica)),1,150) 
	into STRICT	nm_paciente_w 
	from	prescr_medica 
	where	nr_prescricao = nr_prescricao_p;
		 
	 
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
		ds_observacao) 
	values (	nr_requisicao_w, 
		cd_estabelecimento_p, 
		cd_local_origem_p, 
		clock_timestamp(), 
		clock_timestamp(), 
		nm_usuario_p, 
		cd_operacao_padrao_w, 
		Obter_Pessoa_Fisica_Usuario(nm_usuario_p,'C'), 
		cd_estabelecimento_p, 
		cd_local_destino_p, 
		null, 
		'N', 
		'A', 
		nm_paciente_w);
 
	if (nr_requisicao_w > 0) then 
		select	cd_operacao_estoque, 
			cd_setor_atendimento, 
			cd_local_estoque 
		into STRICT	cd_oper_estoque_w, 
			cd_setor_atend_w, 
			cd_local_estoque_w 
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
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_requisicao_mat_barras ( nr_prescricao_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, cd_local_origem_p bigint, cd_local_destino_p bigint) FROM PUBLIC;

