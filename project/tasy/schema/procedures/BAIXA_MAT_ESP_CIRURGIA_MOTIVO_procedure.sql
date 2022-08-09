-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baixa_mat_esp_cirurgia_motivo ( nr_cirurgia_p bigint, nr_prescricao_p bigint, nr_seq_material_p bigint, cd_local_estoque_p bigint, nr_seq_atepacu_p bigint, cd_motivo_baixa_p bigint, dt_atendimento_p timestamp, cd_perfil_p bigint, nm_usuario_p text, cd_setor_atendimento_p bigint, ds_erro_p INOUT text) AS $body$
DECLARE


cd_baixa_incorreta_w	smallint;
Param21Funcao900		smallint;
cd_motivo_baixa_regra_w	smallint;
ie_baixa_sem_estoque_w	varchar(1);

cd_setor_atendimento_w	integer;
dt_entrada_unidade_w	timestamp;

nr_prescricao_w		bigint;
dt_prescricao_w		timestamp;
nr_atendimento_w		bigint;
cd_estab_w		bigint;

nr_seq_prescr_w		bigint;
cd_material_w		integer;
qt_material_w		double precision;
qt_material_ww		double precision:=null;
qt_dispensar_w		double precision;
qt_dias_solic_w		smallint;
qt_dias_lib_w		smallint;
ie_status_w		varchar(2);
ie_baixa_paciente_w	varchar(1) := 'S';
ie_via_aplicacao_w		varchar(5);
cd_unidade_medida_w	varchar(30);
cd_fornec_consignado_w	varchar(14);
nr_seq_lote_fornec_w	bigint;

ie_local_valido_w		varchar(1) := 'S';
ie_disp_estoque_w		varchar(1) := 'S';
ie_atualiza_estoque_w	varchar(1) := 'S';

cd_local_estoque_w	integer;
cd_local_estoque_ww	integer;
cd_local_estoque_www integer;

cd_local_est_fatur_direto_ww	integer;

nr_sequencia_w		bigint;

cd_convenio_w		integer;
cd_categoria_w		varchar(10);
nr_doc_convenio_w	varchar(20);
ie_tipo_guia_w		varchar(2);
cd_funcao_w		bigint;
ie_somente_cb_w		varchar(01)	:= 'N';
ie_consiste_baixa_estoque_w	varchar(01) := 'N';
ie_material_estoque_w	varchar(01) := 'N';
ie_mat_estoque_mat_w	varchar(01) := 'N';
cd_convenio_ww		integer;
cd_categoria_ww		varchar(10);
cd_senha_w		varchar(20);
ie_receita_w		varchar(5) := 'N';
nr_receita_w		bigint;
ie_tipo_lancto_w		varchar(10)	:= '3';
ds_local_estoque_w	varchar(100);
ie_cons_baixa_estoque_nova_w varchar(01) := 'N';
nr_seq_agenda_w		            autorizacao_cirurgia.nr_seq_agenda%type;
nr_seq_agenda_ww                cirurgia.nr_seq_agenda%type;
ie_inicio_cirurgia_w		varchar(1);
cd_estabelecimento_w	smallint;
dt_inicio_w		timestamp;
nr_serie_material_w	varchar(80):=null;
ie_Solic_num_serie_w	varchar(1);
ie_data_conta_w		varchar(01)	:= 'N';
qt_registro_w		bigint;
cd_grupo_material_w	smallint;
cd_subgrupo_material_w	smallint;
cd_classe_material_w	integer;
nr_seq_familia_w	bigint;
cd_setor_atendimento_ww	integer  := null;
nr_seq_interno_ww	bigint := null;
dt_entrada_unidade_ww	timestamp 	   := null;
nr_seq_material_autor_w	bigint;
ie_valor_informado_w	varchar(1);
vl_unitario_material_w	double precision;
vl_material_w		double precision;
ie_qtd_cirurgia_w	varchar(1);
ie_consiste_se_cobra_pac_w	varchar(1) := 'N';
ie_autor_atend_prescr_w		varchar(1) := 'N';
ie_loc_estoque_do_disponivel_w	varchar(1) := 'N';
cd_local_est_mat_esp_w	bigint := null;
ie_faturamento_direto_w	varchar(1);
ie_local_est_fatur_direto_w	varchar(1);
nr_seq_interno_w		bigint;
ie_regra_baixa_mat_sem_est_w	varchar(1);
ie_solic_num_serie_novo_w	varchar(1);
nr_seq_tipo_baixa_w		regra_qt_opme_material.nr_sequencia%type;
ie_erro_w varchar(1) := 'N';
ie_consignado_w		material.ie_consignado%type;
ie_tipo_saldo_w		varchar(1);

ie_conta_paciente_w	varchar(1) := 'S';
ds_retorno_integracao_w varchar(400);

C01 CURSOR FOR
	SELECT	c.nr_prescricao,				
			c.nr_atendimento,
			c.cd_estabelecimento
	from  	cirurgia c						  
	where 	c.nr_cirurgia		= nr_cirurgia_p
	and 	c.nr_prescricao 	= nr_prescricao_p
	
union

	SELECT	a.nr_prescricao,				  
			a.nr_atendimento,
			a.cd_estabelecimento
	from  	prescr_medica a						  
	where 	a.nr_cirurgia		= nr_cirurgia_p
	and 	a.nr_prescricao 	= nr_prescricao_p;										

C02 CURSOR FOR
	SELECT 	nr_sequencia,
		cd_material,
		qt_material,
		coalesce(qt_total_dispensar,qt_material),
		coalesce(qt_dias_solicitado,0),
		coalesce(qt_dias_liberado,0),
		ie_status_cirurgia,
		obter_se_baixa_estoque_pac(cd_setor_atendimento_w, cd_material,null,0),
		ie_via_aplicacao,
		cd_unidade_medida,
		cd_fornec_consignado,
		nr_seq_lote_fornec,
		cd_convenio,
		cd_categoria,
		coalesce(nr_receita,0),
		nr_seq_material_autor,
		CASE WHEN ie_loc_estoque_do_disponivel_w='S' THEN cd_local_estoque  ELSE null END ,
		substr(obter_se_faturamento_direto(nr_sequencia,nr_prescricao),1,1),
		nr_seq_interno
	from 	prescr_material
	where 	nr_prescricao = nr_prescricao_w
	and 	nr_sequencia = nr_seq_material_p
	AND 	cd_motivo_baixa = 0
	AND	((ie_consiste_se_cobra_pac_w = 'N') or (obter_se_mat_cobra_paciente(cd_material) = 'S'))
	and	((ie_somente_cb_w = 'N')
		or ((ie_status_cirurgia = 'CB')
		or (ie_status_cirurgia = 'AD')))
	order by 1;



BEGIN
select 	wheb_usuario_pck.get_cd_estabelecimento
into STRICT	cd_estabelecimento_w
;

select	coalesce(dt_inicio_real,dt_inicio_prevista)
into STRICT	dt_inicio_w
from 	cirurgia
where	nr_cirurgia = nr_cirurgia_p;

ie_inicio_cirurgia_w	:= 'N';

select 	coalesce(max(nr_seq_agenda),0)
into STRICT 	nr_seq_agenda_w
from	autorizacao_cirurgia b,
	agenda_paciente a
where 	a.nr_sequencia	= b.nr_seq_agenda
  and 	a.nr_cirurgia	= nr_cirurgia_p;


select	obter_funcao_ativa
into STRICT	cd_funcao_w
;

ie_tipo_lancto_w := obter_param_usuario(901, 121, cd_perfil_p, nm_usuario_p, cd_estabelecimento_w, ie_tipo_lancto_w);
ie_receita_w := obter_param_usuario(901, 101, cd_perfil_p, nm_usuario_p, cd_estabelecimento_w, ie_receita_w);

if (ie_tipo_lancto_w <> 0) then
	ie_tipo_lancto_w := obter_param_usuario(900, 258, cd_perfil_p, nm_usuario_p, cd_estabelecimento_w, ie_tipo_lancto_w);
	if (ie_tipo_lancto_w = 'S') then
		ie_tipo_lancto_w := '0';
	end if;
end if;

ie_consiste_baixa_estoque_w	:= 'N';

Param21Funcao900 := obter_param_usuario(36, 21, cd_perfil_p, nm_usuario_p, cd_estabelecimento_w, Param21Funcao900);
ie_consiste_baixa_estoque_w := obter_param_usuario(901, 19, cd_perfil_p, nm_usuario_p, cd_estabelecimento_w, ie_consiste_baixa_estoque_w);
				

if (cd_funcao_w = 901) then
	ie_somente_cb_w := obter_param_usuario(901, 45, cd_perfil_p, nm_usuario_p, cd_estabelecimento_w, ie_somente_cb_w);
	ie_inicio_cirurgia_w := obter_param_usuario(901, 134, cd_perfil_p, nm_usuario_p, cd_estabelecimento_w, ie_inicio_cirurgia_w);
end if;

if (cd_funcao_w = 900) then
	ie_cons_baixa_estoque_nova_w := obter_param_usuario(900, 36, cd_perfil_p, nm_usuario_p, cd_estabelecimento_w, ie_cons_baixa_estoque_nova_w);
	ie_inicio_cirurgia_w := obter_param_usuario(900, 134, cd_perfil_p, nm_usuario_p, cd_estabelecimento_w, ie_inicio_cirurgia_w);
	ie_Solic_num_serie_w := obter_param_usuario(900, 200, cd_perfil_p, nm_usuario_p, cd_estabelecimento_w, ie_Solic_num_serie_w);
	ie_solic_num_serie_novo_w := obter_param_usuario(900, 478, cd_perfil_p, nm_usuario_p, cd_estabelecimento_w, ie_solic_num_serie_novo_w);
	ie_data_conta_w := obter_param_usuario(900, 309, cd_perfil_p, nm_usuario_p, cd_estabelecimento_w, ie_data_conta_w);
	ie_qtd_cirurgia_w := obter_param_usuario(900, 394, cd_perfil_p, nm_usuario_p, cd_estabelecimento_w, ie_qtd_cirurgia_w);
	ie_consiste_se_cobra_pac_w := obter_param_usuario(900, 449, cd_perfil_p, nm_usuario_p, cd_estabelecimento_w, ie_consiste_se_cobra_pac_w);
	ie_autor_atend_prescr_w := obter_param_usuario(900, 224, cd_perfil_p, nm_usuario_p, cd_estabelecimento_w, ie_autor_atend_prescr_w);
	ie_loc_estoque_do_disponivel_w := obter_param_usuario(900, 463, cd_perfil_p, nm_usuario_p, cd_estabelecimento_w, ie_loc_estoque_do_disponivel_w);
	cd_local_est_mat_esp_w := obter_param_usuario(900, 128, cd_perfil_p, nm_usuario_p, cd_estabelecimento_w, cd_local_est_mat_esp_w);
	ie_local_est_fatur_direto_w := obter_param_usuario(900, 464, cd_perfil_p, nm_usuario_p, cd_estabelecimento_w, ie_local_est_fatur_direto_w);
	ie_somente_cb_w := obter_param_usuario(900, 476, cd_perfil_p, nm_usuario_p, cd_estabelecimento_w, ie_somente_cb_w);
	ie_regra_baixa_mat_sem_est_w := obter_param_usuario(900, 477, cd_perfil_p, nm_usuario_p, cd_estabelecimento_w, ie_regra_baixa_mat_sem_est_w);
end if;

ie_baixa_sem_estoque_w := obter_param_usuario(36, 9, cd_perfil_p, nm_usuario_p, cd_estabelecimento_w, ie_baixa_sem_estoque_w);
cd_baixa_incorreta_w := obter_param_usuario(36, 22, cd_perfil_p, nm_usuario_p, cd_estabelecimento_w, cd_baixa_incorreta_w);

cd_setor_atendimento_w := cd_setor_atendimento_p;

if (coalesce(cd_setor_atendimento_w::text, '') = '' or cd_setor_atendimento_w = 0) then
	select	max(cd_setor_atendimento)
	into STRICT	cd_setor_atendimento_w
	from 	atend_paciente_unidade
	where 	nr_seq_interno = nr_seq_atepacu_p;
end if;

select	max(dt_entrada_unidade)
into STRICT	dt_entrada_unidade_w
from 	atend_paciente_unidade
where 	nr_seq_interno = nr_seq_atepacu_p;

select 	max(cd_local_fatur_direto)
into STRICT	cd_local_est_fatur_direto_ww
from	parametro_compras
where 	cd_estabelecimento = cd_estabelecimento_w;

cd_local_estoque_w := cd_local_estoque_p;

if (coalesce(cd_local_estoque_w::text, '') = '' or cd_local_estoque_w = 0) then
	select cd_local_estoque
	into STRICT cd_local_estoque_w
	from setor_atendimento
	where cd_setor_atendimento = cd_setor_atendimento_w;
end if;

cd_local_estoque_www := cd_local_estoque_w;	

open C01;
loop
fetch C01 into
	nr_prescricao_w,
	nr_atendimento_w,
	cd_estab_w;
EXIT WHEN NOT FOUND; /* apply on C01 */

	select	max(dt_prescricao),
			coalesce(max(nr_atendimento),nr_atendimento_w)
	into STRICT	dt_prescricao_w,
			nr_atendimento_w
	from 	prescr_medica
	where 	nr_prescricao = nr_prescricao_w
	and 	coalesce(dt_baixa::text, '') = '';
	open C02;
	loop
	fetch c02 into
		nr_seq_prescr_w,
		cd_material_w,
		qt_material_w,
		qt_dispensar_w,
		qt_dias_solic_w,
		qt_dias_lib_w,
		ie_status_w,
		ie_baixa_paciente_w,
		ie_via_aplicacao_w,
		cd_unidade_medida_w,
		cd_fornec_consignado_w,
		nr_seq_lote_fornec_w,
		cd_convenio_ww,
		cd_categoria_ww,
		nr_receita_w,
		nr_seq_material_autor_w,
		cd_local_estoque_ww,
		ie_faturamento_direto_w,
		nr_seq_interno_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		ie_erro_w := 'N';
		cd_local_estoque_w := cd_local_estoque_www;		
		
		if (ie_local_est_fatur_direto_w = 'S' AND ie_faturamento_direto_w = 'S') then
			cd_local_estoque_w := cd_local_est_fatur_direto_ww;
		elsif (coalesce(cd_local_est_mat_esp_w::text, '') = '') and (ie_loc_estoque_do_disponivel_w = 'S') then
			cd_local_estoque_w := cd_local_estoque_ww;
		end if;	
		
		select	coalesce(max(ie_atualiza_estoque),'N'),
				coalesce(max(ie_conta_paciente),'S')
		into STRICT	ie_atualiza_estoque_w,
				ie_conta_paciente_w		
		from	tipo_baixa_prescricao
		where	cd_tipo_baixa = cd_motivo_baixa_p
		and		ie_prescricao_devolucao = 'P';
				
		if (ie_atualiza_estoque_w = 'N') then
			cd_local_estoque_w := null;
		end if;
	
		if (coalesce(ie_autor_atend_prescr_w,'N') = 'E') then
			CALL gerar_mat_esp_prescr_cirurgia(	nr_prescricao_p,
							nr_atendimento_w,
							cd_estabelecimento_w,
							nm_usuario_p);
		end if;	

		select	count(*)
		into STRICT	qt_registro_w
		from	regra_setor_atend_cirur;
		if (qt_registro_w > 0) then
			cd_classe_material_w	:= coalesce(obter_estrutura_material(cd_material_w,'C'),0);
			cd_subgrupo_material_w	:= coalesce(obter_estrutura_material(cd_material_w,'S'),0);
			cd_grupo_material_w	:= coalesce(obter_estrutura_material(cd_material_w,'G'),0);
			nr_seq_familia_w	:= coalesce(obter_dados_material(cd_material_w,'FA'),0);

			select	max(cd_setor_atendimento)
			into STRICT	cd_setor_atendimento_ww
			from	regra_setor_atend_cirur
			where (cd_material		= cd_material_w) or (cd_classe_material	= cd_classe_material_w)	or (cd_subgrupo_material	= cd_subgrupo_material_w) or (cd_grupo_material	= cd_grupo_material_w) or (nr_seq_familia		= nr_seq_familia_w);

			select	max(nr_seq_interno),
				max(dt_entrada_unidade)
			into STRICT	nr_seq_interno_ww,
				dt_entrada_unidade_ww
			from 	atend_paciente_unidade
			where 	nr_atendimento 			= nr_atendimento_w
			and	trunc(dt_entrada_unidade) 	= trunc(clock_timestamp())
			and	cd_setor_atendimento		= cd_setor_atendimento_ww;

			if (coalesce(nr_seq_interno_ww::text, '') = '') then
				dt_entrada_unidade_ww := clock_timestamp();
				CALL gerar_passagem_setor_atend(nr_atendimento_w,cd_setor_atendimento_ww,dt_entrada_unidade_ww,'N',nm_usuario_p);
				select	max(nr_seq_interno)
				into STRICT	nr_seq_interno_ww
				from	atend_paciente_unidade
				where	nr_atendimento 		= nr_atendimento_w
				and	dt_entrada_unidade	= dt_entrada_unidade_ww;
			end if;
		end if;

		ie_disp_estoque_w 		:= 'S';

		select	max(ie_material_estoque),
			coalesce(max(ie_consignado),'0')
		into STRICT	ie_mat_estoque_mat_w,
			ie_consignado_w
		from	material
		where	cd_material		= cd_material_w;

		select	coalesce(max(ie_material_estoque), ie_mat_estoque_mat_w)
		into STRICT	ie_material_estoque_w
		from	material_estab
		where	cd_estabelecimento	= cd_estab_w
		and	cd_material		= cd_material_w;

		if (qt_material_w = 0) and (cd_baixa_incorreta_w <> 0) then
			
			update 	prescr_material
			set	dt_baixa	= clock_timestamp(),
				cd_motivo_baixa = cd_baixa_incorreta_w,
				dt_atualizacao	= clock_timestamp(),
				nm_usuario	= nm_usuario_p
			where	nr_prescricao	= nr_prescricao_w
			and	nr_sequencia 	= nr_seq_prescr_w;


		elsif (qt_dispensar_w = qt_material_w) and (qt_dispensar_w > 0) and
			((qt_dias_solic_w = 0) or (qt_dias_lib_w > 0)) then
			
			ie_local_valido_w := obter_local_valido(cd_estab_w, cd_local_estoque_w, cd_material_w, '', ie_local_valido_w);

			if (ie_receita_w = 'S') and (nr_receita_w = 0) and (obter_se_medic_controlado(cd_material_w) = 'S') then
				CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(200309, 'DS_MATERIAL_W='||to_char(obter_desc_material(cd_material_w)));
			elsif (ie_receita_w = 'M') and (nr_receita_w = 0) and (obter_se_medic_controlado(cd_material_w) = 'S') then
				ds_erro_p := ds_erro_p || WHEB_MENSAGEM_PCK.get_texto(280934) || obter_desc_material(cd_material_w) || WHEB_MENSAGEM_PCK.get_texto(280935) || chr(13);
			end if;

			if (ie_atualiza_estoque_w = 'S') and (ie_status_w not in ('CB','AD')) and
				((ie_baixa_sem_estoque_w <> 'S') or (ie_baixa_paciente_w = 'S')) then
				
				if (ie_consignado_w = '2') and (coalesce(cd_fornec_consignado_w::text, '') = '') then
					SELECT * FROM obter_fornec_consig_ambos(cd_estab_w, cd_material_w, nr_seq_lote_fornec_w, cd_local_estoque_w, ie_tipo_saldo_w, cd_fornec_consignado_w) INTO STRICT ie_tipo_saldo_w, cd_fornec_consignado_w;
				end if;

				ie_disp_estoque_w := obter_disp_estoque(cd_material_w, cd_local_estoque_w, cd_estab_w, 0, qt_material_w, cd_fornec_consignado_w, ie_disp_estoque_w);

				if (ie_disp_estoque_w = 'N') then
					if	((ie_consiste_baixa_estoque_w = 'S') or (ie_cons_baixa_estoque_nova_w = 'S' and cd_funcao_w = 900)) and (ie_material_estoque_w = 'S') and (ie_baixa_paciente_w = 'S') then
						CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(200310, 'CD_MATERIAL_W='||to_char(cd_material_w));
					end if;
				end if;
			end if;

			ds_local_estoque_w	:= substr(OBTER_DESC_LOCAL_ESTOQUE(cd_local_estoque_w),1,100);
			
			if (ie_local_valido_w	= 'N') and (ie_atualiza_estoque_w 	= 'S') then
				CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(200311, 'DS_LOCAL_ESTOQUE_W='||to_char(coalesce(ds_local_estoque_w,WHEB_MENSAGEM_PCK.get_texto(280937)))||';CD_MATERIAL_W='|| to_char(cd_material_w));
			end if;
			
			if	((ie_local_valido_w = 'S') or (ie_atualiza_estoque_w = 'N')) and (ie_conta_paciente_w = 'S')
				 then
				
				select nextval('material_atend_paciente_seq')
				into STRICT nr_sequencia_w
				;

				if (coalesce(cd_convenio_ww::text, '') = '') then
					SELECT * FROM obter_convenio_execucao(nr_atendimento_w, clock_timestamp(), cd_convenio_w, cd_categoria_w, nr_doc_convenio_w, ie_tipo_guia_w, cd_senha_w) INTO STRICT cd_convenio_w, cd_categoria_w, nr_doc_convenio_w, ie_tipo_guia_w, cd_senha_w;
				else
					cd_convenio_w	:= cd_convenio_ww;
					cd_categoria_w	:= cd_categoria_ww;
				end if;

				if (ie_Solic_num_serie_w = 'S') or (ie_solic_num_serie_novo_w = 'S') then
					select	max(nr_serie_material)
					into STRICT	nr_serie_material_w
					from	w_mat_serie_cirurgia
					where	nr_prescricao 	= nr_prescricao_p
					and	cd_material		= cd_material_w;
				end if;

				if (ie_qtd_cirurgia_w = 'S') then
					qt_material_ww := qt_material_w;
				end if;

				select	coalesce(max(ie_valor_informado),'N'),
					coalesce(max(qt_material),qt_material_w),
					coalesce(max(vl_unitario_material),0),
					max(vl_material)
				into STRICT	ie_valor_informado_w,
					qt_material_w,
					vl_unitario_material_w,
					vl_material_w
				from	material_autor_cirurgia
				where	nr_sequencia 		= nr_seq_material_autor_w
				and	ie_valor_informado 	= 'S';
				
				begin
				insert into material_atend_paciente(			NR_SEQUENCIA,
											NR_ATENDIMENTO,
											DT_ENTRADA_UNIDADE,
											CD_MATERIAL,
											DT_ATENDIMENTO,
											CD_UNIDADE_MEDIDA,
											QT_MATERIAL,
											DT_ATUALIZACAO,
											NM_USUARIO,
											CD_ACAO,
											CD_SETOR_ATENDIMENTO,
											NR_SEQ_ATEPACU,
											CD_MATERIAL_PRESCRICAO,
											CD_MATERIAL_EXEC,
											IE_VIA_APLICACAO,
											DT_PRESCRICAO,
											NR_PRESCRICAO,
											NR_SEQUENCIA_PRESCRICAO,
											CD_CGC_FORNECEDOR,
											QT_EXECUTADA,
											NR_CIRURGIA,
											CD_LOCAL_ESTOQUE,
											VL_UNITARIO,
											QT_AJUSTE_CONTA,
											IE_VALOR_INFORMADO,
											IE_GUIA_INFORMADA,
											IE_AUDITORIA,
											NM_USUARIO_ORIGINAL,
											CD_SITUACAO_GLOSA,
											CD_CONVENIO,
											CD_CATEGORIA,
											NR_DOC_CONVENIO,
											IE_TIPO_GUIA,
											NR_SEQ_LOTE_FORNEC,
											cd_senha,
											nr_serie_material,
											dt_conta,
											vl_material
										)
				values (	nr_sequencia_w,
						nr_atendimento_w,
						coalesce(dt_entrada_unidade_ww,dt_entrada_unidade_w),
						cd_material_w,
						dt_atendimento_p,
						cd_unidade_medida_w,
						coalesce(qt_material_ww,qt_material_w),
						clock_timestamp(),
						nm_usuario_p,
						'1',
						coalesce(cd_setor_atendimento_ww,cd_setor_atendimento_w),
						coalesce(nr_seq_interno_ww,nr_seq_atepacu_p),
						cd_material_w,
						cd_material_w,
						ie_via_aplicacao_w,
						dt_prescricao_w,
						nr_prescricao_w,
						nr_seq_prescr_w,
						cd_fornec_consignado_w,
						coalesce(qt_material_ww,qt_material_w),
						nr_cirurgia_p,
						cd_local_estoque_w,
						vl_unitario_material_w,
						0,
						ie_valor_informado_w,
						'N',
						'N',
						nm_usuario_p,
						0,
						cd_convenio_w,
						cd_categoria_w,
						nr_doc_convenio_w,
						ie_tipo_guia_w,
						nr_seq_lote_fornec_w,
						cd_senha_w,
						nr_serie_material_w,
						CASE WHEN ie_data_conta_w='S' THEN  dt_inicio_w  ELSE null END ,
						vl_material_w);
						
				exception
				when others then
						ds_erro_p 	:= substr(ds_erro_p || sqlerrm,1,255);
						ie_erro_w	:= 'S';
				end;

				if (ie_erro_w = 'N') then
                
					CALL atualiza_preco_material(nr_sequencia_w, nm_usuario_p);
								
					CALL gerar_faturamento_direto_mat(nr_sequencia_w, nm_usuario_p);
					
					CALL gerar_autor_regra(nr_atendimento_w,
								nr_sequencia_w,
								null,
								null,
								null,
								null,
								'PC',
								nm_usuario_p,
								null,
								null,
								null,
								null,
								null,
								null,


								'',
								'',
								'');


					if (ie_tipo_lancto_w	= '0') then
						CALL Gerar_Lanc_Automatico_Mat(nr_atendimento_w,cd_local_estoque_w,132,nm_usuario_p,nr_sequencia_w,null,null);
					end if;
					
					if (ie_atualiza_estoque_w = 'N') then					
						update	prescr_material
						set	dt_baixa 	= clock_timestamp(),
							cd_motivo_baixa = cd_motivo_baixa_p,
							dt_atualizacao	= clock_timestamp(),
							nm_usuario	= nm_usuario_p
						where	nr_prescricao	= nr_prescricao_w
						and	nr_sequencia	= nr_seq_prescr_w;
					else
                        update prescr_material
						set	   cd_local_estoque = cd_local_estoque_p
						where  nr_prescricao	= nr_prescricao_w
						and	   nr_sequencia	    = nr_seq_prescr_w;
					end if;
					
					select	max(nr_sequencia)
					into STRICT	nr_seq_tipo_baixa_w
					from	tipo_baixa_prescricao
					where	cd_tipo_baixa = cd_motivo_baixa_p
					and	ie_prescricao_devolucao = 'P';
					
					update	material_atend_paciente
					set	nr_seq_tipo_baixa = nr_seq_tipo_baixa_w
					where	nr_sequencia = nr_sequencia_w;
				end if;	
			else
				if (ie_erro_w = 'N') then
					update	prescr_material
					set	dt_baixa = clock_timestamp(),
						cd_motivo_baixa = cd_motivo_baixa_p,
						dt_atualizacao = clock_timestamp(),
						nm_usuario = nm_usuario_p
					where	nr_prescricao = nr_prescricao_w
					and	nr_sequencia  = nr_seq_prescr_w;
					
					select	max(nr_sequencia)
					into STRICT	nr_seq_tipo_baixa_w
					from	tipo_baixa_prescricao
					where	cd_tipo_baixa = cd_motivo_baixa_p
					and	ie_prescricao_devolucao = 'P';


					update	material_atend_paciente
					set	nr_seq_tipo_baixa = nr_seq_tipo_baixa_w
					where	nr_sequencia = nr_sequencia_w;

				end if;	
			end if;

		end if;

	end loop;
	close C02;

end loop;
close c01;

if (ie_Solic_num_serie_w = 'S') or (ie_solic_num_serie_novo_w = 'S') then
	delete from	w_mat_serie_cirurgia where nr_prescricao = nr_prescricao_p;
end if;

if (coalesce(nr_prescricao_w::text, '') = '') then
	ds_erro_p := WHEB_MENSAGEM_PCK.get_texto(1170082);
end if;

if (coalesce(cd_material_w::text, '') = '') then
	ds_erro_p := WHEB_MENSAGEM_PCK.get_texto(1170083, 'NR_PRESCRICAO='|| nr_prescricao_p || ';NR_SEQ_EXAME=' || null);
end if;

commit;

begin

    if (coalesce(nr_seq_agenda_w,0) = 0) then
      
      select max(a.nr_seq_agenda)
      into STRICT  nr_seq_agenda_ww
      from  cirurgia a
      where a.nr_cirurgia	= nr_cirurgia_p;

    end if;

    select   BIFROST.SEND_INTEGRATION( 'surgery.scheduling.items',
    'com.philips.tasy.integration.atepac.surgery.scheduling.inpart.SurgerySchedulingUsedItemsRequest',
    '{"sequence" : '||coalesce(nullif(nr_seq_agenda_w,0),nr_seq_agenda_ww)||', "prescription" : '||nr_prescricao_p||' }',
    'integration')
    into STRICT ds_retorno_integracao_w
;

    commit;

    exception  
    when others then
    ds_retorno_integracao_w := null;
end;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baixa_mat_esp_cirurgia_motivo ( nr_cirurgia_p bigint, nr_prescricao_p bigint, nr_seq_material_p bigint, cd_local_estoque_p bigint, nr_seq_atepacu_p bigint, cd_motivo_baixa_p bigint, dt_atendimento_p timestamp, cd_perfil_p bigint, nm_usuario_p text, cd_setor_atendimento_p bigint, ds_erro_p INOUT text) FROM PUBLIC;
