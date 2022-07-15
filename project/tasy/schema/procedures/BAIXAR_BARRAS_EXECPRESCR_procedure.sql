-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baixar_barras_execprescr ( nr_sequencia_p bigint, nr_prescricao_p bigint, cd_material_p bigint, qt_material_p bigint, nr_atendimento_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, cd_kit_p bigint, cd_setor_atendimento_p bigint, nr_seq_lote_p bigint, ie_tipo_baixa_p text, cd_local_estoque_baixa_p bigint, ds_erro_p INOUT text) AS $body$
DECLARE


/* Juliane Menin - Faz a baixa dos materiais */

cd_material_estoque_w		integer;
ie_consignado_w			varchar(1);
cd_unidade_medida_W		varchar(30)	:= null;
dt_entrada_unidade_w		timestamp;		
dt_prescricao_w			timestamp;
nr_seq_atepacu_W		bigint	:= 0;
nr_seq_lote_fornec_w    	bigint	:= null;
ie_via_aplicacao_w		varchar(5);
ds_observacao_w			varchar(4000);
nr_sequencia_w			bigint	:= 0;
cd_fornec_consignado_w		varchar(14);
vl_unitario_w			double precision	:= 0;
qt_ajuste_conta_w		double precision	:= 0;

ie_valor_informado_w		varchar(1)	:='N';
ie_guia_informada_w		varchar(1)	:='N';
ie_auditoria_w			varchar(1)	:='N';
nm_usuario_original_w		varchar(15)	:= nm_usuario_p;
cd_situacao_glosa_w		smallint	:= 0;
nr_interno_conta_w		bigint	:= null;

cd_convenio_w			integer	:= null;
cd_categoria_w			varchar(10)	:= null;
nr_doc_convenio_w		varchar(20)	:= null;
ie_tipo_guia_w			varchar(2)	:= null;
cd_senha_w			varchar(20)	:= null;

ie_entra_conta_w		varchar(1);
vl_param_w			varchar(15);

ds_erro_w			varchar(2000)	:= null;

cd_local_estoque_w		bigint	:= null;
ie_tipo_baixa_padrao_w		bigint	:= 1;
nr_seq_tipo_baixa_w		integer	:= 0;


ie_baixa_estoque_w		varchar(2);
ie_material_baixa_w		varchar(2);
ie_local_valido_w		varchar(2);
ie_baixa_estoque_pac_w		varchar(2);
ie_estoque_disp_w		varchar(2);
ie_atualizar_estoque_w		varchar(2);

cd_pessoa_fisica_w		varchar(10);
dt_atendimento_w		timestamp;
cd_setor_atend_User_w 		integer;
nr_seq_cor_exec_w		integer	:= 96;	
cd_kit_w			bigint	:= cd_Kit_p;

ie_local_adicional_setor_w      varchar(255);

dt_atualizacao_ww		timestamp;
cd_motivo_exc_conta_w		bigint;
nr_atend_prescr_w		atendimento_paciente.nr_atendimento%type;
nr_atendimento_w		atendimento_paciente.nr_atendimento%type;

cd_convenio_atend_w 		atend_categoria_convenio.cd_convenio%type;
cd_plano_convenio_w  		atend_categoria_convenio.cd_plano_convenio%type;
ie_tipo_atendimento_w  		atendimento_paciente.ie_tipo_atendimento%type;
cd_categoria_convenio_w		atend_categoria_convenio.cd_categoria%type;
vl_param_regra_uso_w		varchar(15);
ie_acao_w 			varchar(5);
qt_excedida_w 			double precision;
nr_seq_regra_uso_w		bigint;
ds_mensagem_uso_w		varchar(255) 	:= null;
cd_convenio_particular_w	integer	:= null;
cd_categoria_particular_w	varchar(10)	:= null;
qt_material_inserir_w		material_atend_paciente.qt_material%type 		:= null;
nr_seq_mat_particular_w		material_atend_paciente.nr_sequencia%type;
cd_motivo_exc_conta_fat_w	parametro_faturamento.cd_motivo_exc_conta%type 		:= null;
ds_compl_motivo_excon_w		material_atend_paciente.ds_compl_motivo_excon%type	:= null;
ie_lancto_auto_mat_w		varchar(10);
ie_tipo_saldo_w				varchar(1);
total_consignado			double precision;
qt_material_w				double precision;
qt_diferenca_w				bigint := 0;
ie_continua					varchar(1)	:= 'S';	
nr_seq_regra_w				bigint;
qt_estoque_proprio_w		double precision;
qt_atendido_proprio_w		double precision := 0;
qt_estoque_consignado_w		double precision;
qt_atendido_consignado_w	double precision := 0;
qt_total_baixada 			double precision;


BEGIN

nr_atendimento_w := nr_atendimento_p;
qt_material_w := qt_material_p;

while(qt_diferenca_w > 0 or ie_continua = 'S') loop
begin
	select	cd_setor_atendimento
	into STRICT	cd_setor_atend_User_w  
	from	usuario
	where	nm_usuario	=	nm_usuario_p;

	select	coalesce(max(IE_REGRA_SALDO_CONSIG),0)
	into STRICT	nr_seq_regra_w
	from	parametro_estoque
	where	cd_estabelecimento = cd_estabelecimento_p;
	
	/* Pega o local de estoque adicional com maior prioridade do setor do USUARIO ou do PACIENTE */

	ie_local_adicional_setor_w := Obter_Param_Usuario(88, 134, Obter_Perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_local_adicional_setor_w);
	ie_lancto_auto_mat_w := Obter_Param_Usuario(24, 83, Obter_Perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_lancto_auto_mat_w);

	/** Verificar local de estoque - usuario ou Paciente */

	if (ie_tipo_baixa_p = 'P') then	
		select	obter_valor_param_usuario(88,6,Obter_Perfil_ativo,nm_usuario_p,cd_estabelecimento_p)
		into STRICT	vl_param_w
		;
	else
		select	obter_valor_param_usuario(24,14,Obter_Perfil_ativo,nm_usuario_p,cd_estabelecimento_p)
		into STRICT	vl_param_w
		;
	end if;

	if (upper(vl_param_W) = 'USUARIO') then
		if (coalesce(ie_local_adicional_setor_w, 'N') = 'S') and (ie_tipo_baixa_p = 'P') then
			/*select	decode( obter_local_prioridade_setor(cd_setor_atend_User_w, cd_estabelecimento_p), 0,
					obter_local_estoque_setor(cd_setor_atend_User_w, cd_estabelecimento_p),
					obter_local_prioridade_setor(cd_setor_atend_User_w, cd_estabelecimento_p)) cd_local_estoque
			into	cd_local_estoque_w
			from	dual;*/
			cd_local_estoque_w := cd_local_estoque_baixa_p;
		else
			select	obter_local_estoque_setor(cd_setor_atend_User_w, cd_estabelecimento_p)
			into STRICT	cd_local_estoque_w
			;
		end if;
	else
		if (coalesce(ie_local_adicional_setor_w, 'N') = 'S') and (ie_tipo_baixa_p = 'P') then
			/*select	decode( obter_local_prioridade_setor(cd_setor_atendimento_p, cd_estabelecimento_p), 0,
					obter_local_estoque_setor(cd_setor_atendimento_p, cd_estabelecimento_p),
					obter_local_prioridade_setor(cd_setor_atendimento_p, cd_estabelecimento_p)) cd_local_estoque
			into	cd_local_estoque_w
			from	dual;*/
			cd_local_estoque_w := cd_local_estoque_baixa_p;
		else
			select	obter_local_estoque_setor(cd_setor_atendimento_p, cd_estabelecimento_p)
			into STRICT	cd_local_estoque_w
			;
		end if;
	end if;

	-- Obter o c?digo do tipo de baixa prescri??o - Param 28 e 6 no PalmWeb
	if (ie_tipo_baixa_p = 'P') then
		select	obter_valor_param_usuario(88, 7, Obter_Perfil_ativo, nm_usuario_p, cd_estabelecimento_p)
		into STRICT	vl_param_w
		;
	else
		select	obter_valor_param_usuario(24, 28, Obter_Perfil_ativo, nm_usuario_p, cd_estabelecimento_p)
		into STRICT	vl_param_w
		;
	end if;

	/*Adicionado o comando a baixo para OS 885207 
	pois os lan?amentos pelo PalmWeb estavam
	ficando com o antendimento diferente da prescri??o*/
	select	coalesce(max(nr_atendimento),0)
	into STRICT	nr_atend_prescr_w
	from	prescr_medica
	where	nr_prescricao = nr_prescricao_p;	

	if (nr_atend_prescr_w > 0) then	
		nr_atendimento_w := nr_atend_prescr_w;
	end if;

	-- Obter o c?digo do tipo de baixa 
	select 	nr_sequencia
	into STRICT	nr_seq_tipo_baixa_w
	from 	tipo_baixa_prescricao
	where	cd_tipo_baixa 		=  coalesce(vl_param_w, 1)
	and 	ie_prescricao_devolucao 	= 'P';

	-- Obter o c?digo do tipo de baixa pela regra local/tipo baixa
	select coalesce(obter_local_tipo_baixa_prescr(cd_material_p,cd_setor_atendimento_p,'S'), nr_seq_tipo_baixa_w)
    into STRICT nr_seq_tipo_baixa_w
	;

	-- Obter o c?digo da pessoa F?sica
	select	cd_pessoa_fisica
	into STRICT	cd_pessoa_fisica_w
	from	atendimento_paciente
	where	nr_atendimento 		= nr_atendimento_w;


	-- Obter a data de atendimento (Se a data da alta for igual a null ent?o dt_atendimento = dt_alta sen?o dt_atendimento = sysdate)
	begin
		select	dt_alta
		into STRICT	dt_atendimento_w
		from	atendimento_paciente
		where	cd_pessoa_fisica    	= cd_pessoa_fisica_w
		and	nr_atendimento      	= nr_atendimento_w;
	exception
		when others then
		dt_atendimento_w	:=	clock_timestamp();
	end;

	if ( coalesce(dt_atendimento_w::text, '') = '' ) then
		dt_atendimento_w	:=	clock_timestamp();	
	end if;


	-- Consistir material antes de fazer a baixa 
	begin
		select 	coalesce(max(ie_baixa_estoque), 'S')
		into STRICT	ie_baixa_estoque_w
		from 	componente_kit
		where  	cd_kit_material		= cd_Kit_p
		and   	cd_material 		= cd_material_p
		and	((coalesce(cd_estab_regra::text, '') = '') or (cd_estab_regra = cd_estabelecimento_p));

		select	ie_atualiza_estoque
		into STRICT	ie_atualizar_estoque_w 
		from 	tipo_baixa_prescricao
		where 	nr_sequencia		= nr_seq_tipo_baixa_w;

		select	obter_se_material_baixa_prescr( cd_estabelecimento_p, cd_local_estoque_w, cd_material_p)
		into STRICT	ie_material_baixa_w
		;

		select	obter_se_baixa_estoque_pac(cd_setor_atendimento_p, cd_material_p,null,0)
		into STRICT	ie_baixa_estoque_pac_w
		;

		if ( ie_atualizar_estoque_w  = 'S'  or  ie_material_baixa_w = 'S' )
					and ( ie_baixa_estoque_w = 'S')  then

			-- Obter local v?lido
			ie_local_valido_w := obter_local_valido(cd_estabelecimento_p, cd_local_estoque_w, cd_material_p, ' ', ie_local_valido_w);

			select	cd_material_estoque,
				ie_consignado
			into STRICT	cd_material_estoque_w,
				ie_consignado_w
			from	material
			where	cd_material = cd_material_p;


			if (ie_consignado_w = '1') then
				if (coalesce(nr_seq_lote_p, 0) > 0) then
					select	cd_cgc_fornec
					into STRICT	cd_fornec_consignado_w
					from	material_lote_fornec
					where	nr_sequencia = nr_seq_lote_p;
				else					
					select	cd_fornecedor
					into STRICT	cd_fornec_consignado_w
					from	fornecedor_mat_consignado
					where	cd_estabelecimento	= cd_estabelecimento_p
					and	cd_local_estoque	= cd_local_estoque_w
					and	cd_material		= cd_material_estoque_w
					and	dt_mesano_referencia	= trunc(clock_timestamp(),'mm')
					and	qt_estoque = (
						SELECT	max(qt_estoque)
						from	fornecedor_mat_consignado
						where	cd_estabelecimento	= cd_estabelecimento_p
						and	cd_local_estoque	= cd_local_estoque_w
						and	cd_material		= cd_material_estoque_w
						and	dt_mesano_referencia	= trunc(clock_timestamp(),'mm'));
				end if;
			elsif (ie_consignado_w = '2') then
				SELECT * FROM obter_fornec_consig_ambos(cd_estabelecimento_p, cd_material_estoque_w, nr_seq_lote_p, cd_local_estoque_w, ie_tipo_saldo_w, cd_fornec_consignado_w) INTO STRICT ie_tipo_saldo_w, cd_fornec_consignado_w;
			end if;
			
			if (ie_consignado_w = '2' and  nr_seq_regra_w > 0) then
				total_consignado := Obter_Saldo_Total_Consig(cd_estabelecimento_p, cd_material_p, cd_local_estoque_w);
				
				if (ie_tipo_saldo_w = 'N')then
				begin
					qt_estoque_proprio_w :=	obter_saldo_disp_estoque(cd_estabelecimento_p,
																cd_material_p,
																cd_local_estoque_w,
																PKG_DATE_UTILS.start_of(clock_timestamp(), 'month', 0));
					
					if (qt_material_w > qt_estoque_proprio_w and qt_estoque_proprio_w <> 0)then
					begin							
						qt_diferenca_w 	:= qt_material_w - qt_estoque_proprio_w;
						qt_material_w 	:= qt_estoque_proprio_w;
						ie_continua 	:= 'S';	
					end;
					else
						ie_continua := 'N';
					end if;	
					qt_atendido_proprio_w := qt_atendido_proprio_w + qt_material_w;					
				end;
				elsif (ie_tipo_saldo_w = 'C')then
				begin
					select	coalesce(sum(qt_estoque),0)
					into STRICT	qt_estoque_consignado_w
					from	fornecedor_mat_consignado a
					where	a.cd_estabelecimento	= cd_estabelecimento_p
					and	a.cd_local_estoque	= cd_local_estoque_w
					and	a.cd_material		= cd_material_p
					and	a.cd_fornecedor		= cd_fornec_consignado_w
					and	a.dt_mesano_referencia	=
						(SELECT max(dt_mesano_referencia)
						from	fornecedor_mat_consignado b,
							Parametro_estoque p
						where	p.cd_estabelecimento	= cd_estabelecimento_p
						and	b.cd_estabelecimento	= cd_estabelecimento_p
						and	b.cd_local_estoque		= cd_local_estoque_w
						and	b.cd_material		= cd_material_p
						and	b.cd_fornecedor		= cd_fornec_consignado_w
						and	b.dt_mesano_referencia	>= p.dt_mesano_vigente);					
				
					if (qt_material_w > qt_estoque_consignado_w and qt_estoque_consignado_w <> 0)then
					begin
						qt_diferenca_w 	:= qt_material_w - qt_estoque_consignado_w;
						qt_material_w 	:= qt_estoque_consignado_w;
						ie_continua 	:= 'S';						
					end;
					else
						ie_continua 	:= 'N';
						qt_diferenca_w 	:= 0;
					end if;
					
					qt_atendido_consignado_w := qt_atendido_consignado_w + qt_material_w;
				end;
				else
				begin
					ie_continua := 'N';
				end;
				end if;
				
				if (total_consignado >= qt_material_w)then
					ie_estoque_disp_w := 'S';
				else
					ie_estoque_disp_w := 'N';
				end if;				
			else
				-- Obter estoque dispon?vel 
				ie_estoque_disp_w := obter_disp_estoque( cd_material_p, cd_local_estoque_w, cd_estabelecimento_p, 0, qt_material_w, cd_fornec_consignado_w, ie_estoque_disp_w);
			end if;
			
			if ( ie_local_valido_w = 'N') 	then
				ds_erro_w		:=	 WHEB_MENSAGEM_PCK.get_texto(279005);
			elsif (ie_baixa_estoque_pac_w = 'S'  and   ie_estoque_disp_w = 'N')	then
				ds_erro_w	:=	WHEB_MENSAGEM_PCK.get_texto(279006);
			end if;
		else
			cd_local_estoque_w:= null;
		end if;

	/*------------------------------------------- Regra de uso adaptado para PALM WEB----------------------------------------------------*/

	select  max(a.cd_convenio),
			max(a.cd_plano_convenio),
			max(b.ie_tipo_atendimento),
			max(a.cd_categoria)	
	into STRICT	cd_convenio_atend_w,
		cd_plano_convenio_w,
		ie_tipo_atendimento_w,
		cd_categoria_convenio_w
	from    atendimento_paciente 	 b,
			atend_categoria_convenio a
	where	a.nr_atendimento  	= b.nr_atendimento
	and     a.nr_atendimento  	= nr_atendimento_w
	and     obter_atecaco_atendimento(a.nr_atendimento)  = a.nr_seq_interno;

	/* Obter os valores da atend_paciente_unidade */

	select		max(nr_seq_interno),
			max(dt_entrada_unidade)
	into STRICT		nr_seq_atepacu_w,
			dt_entrada_unidade_w
	from		atend_paciente_unidade
	where		nr_atendimento		= nr_atendimento_w
	and 		cd_setor_atendimento	= cd_setor_atendimento_p;

	select	obter_valor_param_usuario(88,339, Obter_Perfil_ativo, nm_usuario_p, cd_estabelecimento_p)
	into STRICT	vl_param_regra_uso_w
	;

	if (coalesce(vl_param_regra_uso_w,'N') = 'N') then
		goto final_regra_uso;
	end if;

	SELECT * FROM obter_regra_uso_mat(	nr_atendimento_w, cd_material_p, qt_material_w, cd_setor_atendimento_p, ie_acao_w, qt_excedida_w, nr_seq_regra_uso_w, ds_mensagem_uso_w, cd_categoria_convenio_w, cd_plano_convenio_w, cd_fornec_consignado_w, null, dt_atendimento_w, null) INTO STRICT ie_acao_w, qt_excedida_w, nr_seq_regra_uso_w, ds_mensagem_uso_w;
	
	/* Conta Particular */

	if (ie_acao_w = 'P') then
		SELECT * FROM obter_convenio_particular_pf(	cd_estabelecimento_p, cd_convenio_atend_w, '', dt_atendimento_w, cd_convenio_particular_w, cd_categoria_particular_w) INTO STRICT cd_convenio_particular_w, cd_categoria_particular_w;

		if (qt_excedida_w >= qt_material_w) then
			/*ao final desta procedure, sera inserido estes convenio e categoria*/

			cd_convenio_particular_w  := cd_convenio_particular_w;
			cd_categoria_particular_w := cd_categoria_particular_w;
		else
			qt_material_inserir_w := qt_material_w - qt_excedida_w;
			
			nr_seq_mat_particular_w := inserir_material_atend_pac(	nr_atendimento_w, null, cd_material_p, dt_atendimento_w, cd_convenio_particular_w, cd_categoria_particular_w, nr_seq_atepacu_w, nm_usuario_p, qt_excedida_w, cd_local_estoque_w, '1', ie_valor_informado_w, nr_seq_mat_particular_w,  --nr_sequencia out
							null, null);
							
			if (nr_seq_mat_particular_w > 0) then
				CALL atualiza_preco_material(nr_seq_mat_particular_w,nm_usuario_p);
			end if;
			cd_convenio_particular_w  := null;
			cd_categoria_particular_w := null;
			/*NO DELPHI EMITE MENSAGEM PARA O USUARIO*/


			--  messagedlg('Este material ser? glosado particular ,'+ds_consiste_regra+'.',MtInformation,[mbok],0);
		end if;
	/* Zerar item na conta*/

	elsif (ie_acao_w = 'Z') then
		if (qt_excedida_w >= qt_material_w) then
			ie_valor_informado_w := 'S';
		else
			qt_material_inserir_w := qt_material_w - qt_excedida_w;
			
			nr_seq_mat_particular_w := inserir_material_atend_pac(	nr_atendimento_w, null, cd_material_p, dt_atendimento_w, cd_convenio_atend_w, cd_categoria_convenio_w, nr_seq_atepacu_w, nm_usuario_p, qt_excedida_w, cd_local_estoque_w, '1', 'S', nr_seq_mat_particular_w,  --nr_sequencia out
							null, null);
						
			if (nr_seq_mat_particular_w > 0) then
				CALL atualiza_preco_material(nr_seq_mat_particular_w,nm_usuario_p);
			end if;
		end if;

	/* Exibe alerta e permite salvar*/
	
	elsif (ie_acao_w = 'M')	and (ds_mensagem_uso_w IS NOT NULL AND ds_mensagem_uso_w::text <> '') then
		ds_mensagem_uso_w := ds_mensagem_uso_w;
		/*mostra mensagem para usuario por dialog*/


		--MessageDlg(ds_consiste_regra,MtWarning,[MbOk],0)


	/*Exige justificativa*/

	elsif (ie_acao_w = 'J') then
		if (qt_excedida_w > 0) then
			if (ds_mensagem_uso_w IS NOT NULL AND ds_mensagem_uso_w::text <> '') then
				--MessageDlg(ds_consiste_regra,MtInformation,[MbOk],0);
				ds_mensagem_uso_w := ds_mensagem_uso_w;
			end if;
			/*NO DELPHI PEGA A JUSTIFICATIVA DE ALGUM LUGAR*/


			--DataSet.FieldByName('ds_observacao').AsString:= Copy(DataSet.FieldByName('ds_observacao').AsString + ' Justificativa: '+AtePac_qm.ds_justificativa,1,255);
		end if;

	/*Mover para excluidos da conta*/

	elsif (ie_acao_w = 'E') then
		if (qt_excedida_w > 0) then
			begin
			select 	max(cd_motivo_exc_conta)
			into STRICT	cd_motivo_exc_conta_fat_w
			from 	parametro_faturamento
			where 	cd_estabelecimento 	= cd_estabelecimento_p;
			exception
			when others then
				cd_motivo_exc_conta_fat_w := null;
			end;
			ds_compl_motivo_excon_w		:= 'PalmWeb - '||wheb_mensagem_pck.get_texto(181763);/*PalmWeb - Excluido pela regra de uso de mat/med da funcao Cadastro de Convenios,*/
			
			qt_material_inserir_w	:= qt_material_w - qt_excedida_w;
			
			if (qt_material_inserir_w = 0 )then
				qt_material_inserir_w		:= qt_excedida_w;
				cd_motivo_exc_conta_fat_w 	:= cd_motivo_exc_conta_fat_w;			
				ds_compl_motivo_excon_w		:= ds_compl_motivo_excon_w;
			else
				nr_seq_mat_particular_w := inserir_material_atend_pac(	nr_atendimento_w, null,  --conta
								cd_material_p, dt_atendimento_w, cd_convenio_atend_w, cd_categoria_convenio_w, nr_seq_atepacu_w, nm_usuario_p, qt_excedida_w, cd_local_estoque_w, '1', 'S', nr_seq_mat_particular_w,   --nr_sequencia out
								null, null);
									
				if (nr_seq_mat_particular_w IS NOT NULL AND nr_seq_mat_particular_w::text <> '') then
				
					CALL atualiza_preco_material(nr_seq_mat_particular_w, nm_usuario_p);			
					
					CALL excluir_matproc_conta(	nr_seq_mat_particular_w,
								nr_interno_conta_w, --NAO TEMOS NR_INTERNO_CONTA AQUI NO PALMWEB
								cd_motivo_exc_conta_fat_w,
								ds_compl_motivo_excon_w,
								'M',
								nm_usuario_p,
								null);
				end if;
				cd_motivo_exc_conta_fat_w := null;
				ds_compl_motivo_excon_w   := null;
			end if;
		end if;
	/*ie_acao_w = I      Impede execucao*/

	elsif (ie_acao_w  <> 'P') and (ds_mensagem_uso_w IS NOT NULL AND ds_mensagem_uso_w::text <> '') then
		if (vl_param_regra_uso_w = 'S') then
			ds_erro_w := ds_mensagem_uso_w;
		end if;
	end if;

	<<final_regra_uso>>
	vl_param_regra_uso_w := vl_param_regra_uso_w;

	/*------------------------------------------- Fim regra de uso----------------------------------------------------*/

	exception
		when others then
		   ds_erro_w	:= WHEB_MENSAGEM_PCK.get_texto(279007)  + cd_material_p;
	end;


	if (coalesce(ds_erro_w::text, '') = '') then
		
		select   	coalesce(max(ie_entra_conta), 'S')
		into STRICT 		ie_entra_conta_w
		from     	componente_kit
		where    	cd_material       = cd_material_p
		and      	cd_kit_material   = cd_kit_p;


		if (ie_entra_conta_w = 'S')  then
			
			-- Se tiver prescri??o buscar a data da prescri??o
			if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then
				select	dt_entrada_unidade
				into STRICT	dt_prescricao_w
				from	prescr_medica
				where	nr_prescricao		=	nr_prescricao_p;
			end if;
		

			if (ie_consignado_w = '2') and (cd_fornec_consignado_w IS NOT NULL AND cd_fornec_consignado_w::text <> '') then
				select	substr(obter_dados_material_estab(cd_material,cd_estabelecimento_p,'UMS'),1,30) cd_unidade_medida_consumo
				into STRICT	cd_unidade_medida_w
				from 	material
				where 	cd_material = cd_material_p;
			else	
				/* Buscar alguns campos da prescr_material*/

				begin
				select
					cd_unidade_medida,
					nr_seq_lote_fornec,
					ie_via_aplicacao,
					cd_fornec_consignado,
					ds_observacao
				into STRICT   
					cd_unidade_medida_w,
					nr_seq_lote_fornec_w,
					ie_via_aplicacao_w,
					cd_fornec_consignado_w,
					ds_observacao_w
				from	prescr_material
				where	nr_prescricao	= nr_prescricao_p
				and	cd_material   	= cd_material_p
				and	nr_sequencia	= nr_sequencia_P;
				exception
					when others then
						select	substr(obter_dados_material_estab(cd_material,cd_estabelecimento_p,'UMS'),1,30) cd_unidade_medida_consumo
						into STRICT	cd_unidade_medida_w
						from 	material
						where 	cd_material		= 	cd_material_p;
				end;
			end if;


			/* Obter os valores de alguns campos atrav?s da procedure*/

			SELECT * FROM obter_convenio_execucao(nr_atendimento_w, dt_entrada_unidade_w, cd_convenio_w, cd_categoria_w, nr_doc_convenio_w, ie_tipo_guia_w, cd_senha_w) INTO STRICT cd_convenio_w, cd_categoria_w, nr_doc_convenio_w, ie_tipo_guia_w, cd_senha_w;

		
			/* Obter a m?xima sequencia da material_aten_paciente */

			select	nextval('material_atend_paciente_seq')
			into STRICT	nr_sequencia_w
			;

			
			if ( ie_tipo_baixa_p	=	'P') then --Via PalmWeb	
				nr_seq_cor_exec_w := 1013;
				ds_observacao_w	  := substr('PalmWeb'||' AtPW:'||nr_atendimento_p||' AtPr:'||nr_atend_prescr_w||' AtMt:'||nr_atendimento_w||' NrPr:'||nr_prescricao_p,1,255);
			end if;

			if (cd_kit_p = 0) 	then
				cd_kit_w := NULL;
			end if;

			if ( nr_seq_lote_p = 0) then
				nr_seq_lote_fornec_w := null;
			else
				nr_seq_lote_fornec_w := nr_seq_lote_p;
			end if;
		/* Inserir na tabela material_atend_paciente */

			begin
			insert into material_atend_paciente(
				nr_sequencia,
				nr_prescricao,
				cd_kit_material,
				cd_unidade_medida,
				cd_setor_atendimento,
				nr_atendimento,
				dt_entrada_unidade,
				cd_local_estoque,
				nr_seq_atepacu,
				qt_executada,
				qt_material,
				cd_material,
				cd_material_exec,
				cd_cgc_fornecedor,
				nr_seq_cor_exec,
				cd_acao,
				dt_atendimento,
				dt_prescricao,
				nr_sequencia_prescricao,
				nr_seq_lote_fornec,
				nr_seq_tipo_baixa,
				ie_via_aplicacao,
				ds_observacao,
				vl_unitario,
				qt_ajuste_conta,
				ie_valor_informado,
				ie_guia_informada,
				ie_auditoria,	
				nm_usuario_original,
				cd_situacao_glosa,
				cd_convenio,
				cd_categoria,
				nr_doc_convenio,
				ie_tipo_guia,
				cd_senha,
				cd_material_prescricao,
				dt_atualizacao,
				nm_usuario,
				cd_motivo_exc_conta,
				ds_compl_motivo_excon)
			values (	
				nr_sequencia_w,
				nr_prescricao_p,
				cd_kit_w,
				cd_unidade_medida_w,
				cd_setor_atendimento_p,
				nr_atendimento_w,
				dt_entrada_unidade_w,
				cd_local_estoque_w,
				nr_seq_atepacu_w,
				coalesce(qt_material_inserir_w,qt_material_w),
				coalesce(qt_material_inserir_w,qt_material_w),
				cd_material_p,
				cd_material_p,
				cd_fornec_consignado_w,
				nr_seq_cor_exec_w,
				ie_tipo_baixa_padrao_w,
				dt_atendimento_w,
				dt_prescricao_w,
				nr_sequencia_p,
				nr_seq_lote_fornec_w,
				nr_seq_tipo_baixa_w,
				ie_via_aplicacao_w,
				ds_observacao_w,
				vl_unitario_w,
				qt_ajuste_conta_w,
				ie_valor_informado_w,
				ie_guia_informada_w,
				ie_auditoria_w,	
				nm_usuario_original_w,
				cd_situacao_glosa_w,
				coalesce(cd_convenio_particular_w,cd_convenio_w),
				coalesce(cd_categoria_particular_w,cd_categoria_w),
				nr_doc_convenio_w,
				ie_tipo_guia_w,
				cd_senha_w,
				cd_material_p,
				clock_timestamp(),
				nm_usuario_p,
				cd_motivo_exc_conta_fat_w,
				ds_compl_motivo_excon_w);
			exception
				when others then
				ds_erro_w := SQLERRM(SQLSTATE);
				
				commit;
			end;

			select  max(a.dt_atualizacao),
				max(a.cd_motivo_exc_conta)
			into STRICT	dt_atualizacao_ww,
				cd_motivo_exc_conta_w
			from    material c,
				MATERIAL B,
				MATERIAL_ATEND_PACIENTE A
			WHERE   B.CD_MATERIAL           = A.CD_MATERIAL
			and     c.cd_material           = coalesce(a.cd_material_exec,a.cd_material)
			and     a.nr_atendimento        = 11786
			and     a.cd_setor_atendimento  = '47';

			/* Ap?s a insers?o atualizar o pre?o do material */

			CALL Atualiza_Preco_Material(nr_sequencia_w, nm_usuario_p);
			
			if (coalesce(ie_lancto_auto_mat_w,'0') = '0') then
				CALL gerar_lanc_automatico_mat( nr_atendimento_p, null, 132, nm_usuario_p, nr_sequencia_w,null,null);
			end if;
			/* Obter o valor nr_interno_conta da material_atend_paciente */


			/*select	nr_interno_conta
			into	nr_interno_conta_w
			from 	material_atend_paciente
			where	nr_sequencia = nr_sequencia_w;*/



			/* Enviar comunicacao interna quando o material for de alto custo */


			/*envia_alerta_mat_alto_custo(cd_material_p, nr_atendimento_w, nr_interno_conta_w, cd_estabelecimento_p, nm_usuario_p);*/
		
		end if;
	end if;	
	
	if ((ie_consignado_w = '2' and nr_seq_regra_w > 0) and qt_diferenca_w > 0 and ((ie_tipo_saldo_w = 'N') or (ie_tipo_saldo_w = 'C')) and ie_continua = 'S')then
	begin
		qt_material_w := qt_diferenca_w;
	end;
	else
		qt_diferenca_w := 0;
		ie_continua := 'N';
	end if;
	
	qt_total_baixada := qt_atendido_consignado_w + qt_atendido_proprio_w;
	
	if ((ie_consignado_w = '2' and nr_seq_regra_w > 0) and (qt_total_baixada < qt_material_p) and qt_diferenca_w = 0 and qt_total_baixada > 0) then
	begin
		ds_erro_w := WHEB_MENSAGEM_PCK.get_texto(1091648, 'QT_BAIXADA=' || qt_total_baixada);
	end;
	end if;
	
	ds_erro_p := substr(ds_erro_w,1,255);
	
	commit;
end;
end loop;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baixar_barras_execprescr ( nr_sequencia_p bigint, nr_prescricao_p bigint, cd_material_p bigint, qt_material_p bigint, nr_atendimento_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, cd_kit_p bigint, cd_setor_atendimento_p bigint, nr_seq_lote_p bigint, ie_tipo_baixa_p text, cd_local_estoque_baixa_p bigint, ds_erro_p INOUT text) FROM PUBLIC;

