-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_consulta_preco_proc (cd_estabelecimento_p bigint, dt_conta_p timestamp, cd_tipo_acomodacao_p bigint, ie_tipo_atendimento_p bigint, cd_setor_atendimento_p bigint, cd_medico_p text, cd_funcao_medico_p bigint, qt_idade_p bigint, cd_usuario_convenio_p text, cd_plano_p text, ie_clinica_p bigint, cd_empresa_ref_p bigint, cd_cgc_fornecedor_p text, nr_sequencia_p bigint, nr_seq_pacote_p bigint, ds_conv_adic_p text, ds_tipo_atend_adic_p text, ds_categ_conv_adic_p text, ds_tipo_proc_adic_p text, nm_usuario_p text, ie_carater_inter_sus_p text, ie_carater_cirurgia_p text, ie_video_p text, qt_dia_int_p bigint, ie_calcula_kit_p text, ie_calcula_lanc_auto_p text, ie_cobertura_plano_p text, ie_glosa_p text, ie_calc_adicional_horario_p text, cd_area_procedimento_p bigint, cd_especialidade_p bigint, cd_grupo_proc_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_classif_convenio_p bigint, ie_tipo_atend_p text, ie_percentual_p bigint, cd_convenio_percentual_p bigint, cd_categoria_percentual_p text, ie_proc_utilizado_p text, ds_area_proc_adic_p text, ds_espec_proc_adic_p text, ds_grupo_proc_adic_p text) AS $body$
DECLARE


/*

   ie_calcula_kit_p
	  'N' -  Não calcula preço do Kit.
	  'S' -  Calcula preço do kit.

   ie_calcula_lanc_auto_p
	  'N' -  Não calcula o Lançamento Automático.
	  'S' -  calcula o Lançamento Automático.
*/
qt_pontos_w			preco_amb.qt_pontuacao%type;
nr_sequencia_w			bigint;
dt_consulta_w			timestamp;
vl_material_w			double precision;
dt_ult_vigencia_w		timestamp;
cd_tab_preco_mat_w		smallint;
ie_origem_preco_w		smallint;
vl_procedimento_w		double precision;
vl_procedimento_perc_w		double precision;
vl_custo_operacional_w		double precision;
vl_anestesista_w		double precision;
vl_medico_w			double precision;
vl_auxiliares_w			double precision;
vl_materiais_w			double precision;
vl_pto_procedimento_w		double precision;
vl_pto_custo_operac_w		double precision;
vl_pto_anestesista_w		double precision;
vl_pto_medico_w			double precision;
vl_pto_auxiliares_w		double precision;
vl_pto_materiais_w		double precision;
qt_porte_anestesico_w		smallint;
cd_edicao_amb_w			integer;
cd_categoria_w			varchar(10);
ie_tipo_acomodacao_w		bigint;
cd_convenio_w			bigint;
vl_preco_kit_w			double precision;
vl_lanc_autom_w			double precision;
cd_tipo_acomodacao_w		bigint;
cd_proc_diaria_w		bigint;
ie_origem_proc_diaria_w		bigint;
vl_categoria_w			double precision;
vl_diferenca_w			double precision;
ie_calculo_diferenca_w		varchar(3);
vl_ch_honorarios_w		double precision;
vl_ch_custo_oper_w		double precision;
vl_filme_w               	double precision;
ie_classificacao_w		varchar(01);
ie_preco_informado_w		varchar(01);
tx_adic_medico_w    		double precision		:= 1;
tx_adic_anestesista_w 		double precision		:= 1;
tx_adic_auxiliares_w 		double precision		:= 1;
tx_adic_custo_operacional_w	double precision		:= 1;
tx_adic_materiais_w 		double precision		:= 1;
tx_adic_procedimento_w		double precision		:= 1;
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;

vl_honorarios_moeda_w		double precision;
vl_custo_oper_moeda_w		double precision;
vl_filme_conv_moeda_w		double precision;

cd_proced_calculo_horario_w	bigint;
ie_origem_proced_horario_w	bigint;

cd_procedimento_ww		bigint;
ie_origem_proced_ww		bigint;
cd_convenio_ww			bigint;
cd_categoria_ww			varchar(10);
vl_procedimento_ww		double precision;
ds_convenio_ww			varchar(255);
ds_categoria_ww			varchar(200);
ds_comando_w			varchar(4000);
ds_comando_col_w		varchar(2000);
i				bigint;
qt_colunas_w			bigint;
cd_proc_ant_w			bigint;
cd_conv_ant_w			bigint;
cd_maior_conv_w			bigint;
ie_tipo_atendimento_w		smallint;
vl_adic_proc_w			double precision		:= 0;
vl_adic_medico_w		double precision		:= 0;
nr_seq_adic_w			bigint;


cd_proc_convenio_w    		varchar(20)		:= '0';
nr_seq_conversao_w		bigint		:= 0;
cd_grupo_convenio_w		varchar(10);
cd_moeda_w			bigint;
pr_percentual_w			double precision		:= 0;
ds_erro_w			varchar(255);
nr_seq_regra_w			bigint;
ie_regra_w			varchar(5);
cd_plano_w			varchar(10);

ie_autor_particular_w		varchar(1);
cd_convenio_glosa_w		integer;
cd_categoria_glosa_w		varchar(10);
nr_seq_ajuste_proc_w		bigint;

TX_AJUSTE_PROC_W		double precision := 0;
tx_ajuste_custo_Oper_w		double precision		:= 1;
tx_ajuste_Medico_w		double precision		:= 1;
tx_ajuste_partic_w		double precision		:= 1;
tx_ajuste_Filme_w		double precision		:= 1;
VL_PROC_AJUSTADO_W		double precision := 0;
IE_GLOSA_W			varchar(1);
CD_PROCEDIMENTO_ESP_W		bigint;
NR_SEQ_REGRA_PRECO_W		bigint;
CD_EDICAO_AJUSTE_W		integer    := 0;
vl_medico_neg_w			double precision	:= NULL;
vl_custo_oper_neg_w		double precision	:= NULL;
VL_ANESTESISTA_neg_W		double precision	:= null;
VL_aux_neg_W			double precision	:= null;
qt_filme_neg_w			double precision	:= NULL;
nr_auxiliares_neg_w		smallint	:= NULL;
qt_porte_anest_neg_w		smallint	:= NULL;
pr_glosa_w			double precision		:= 0;
vl_glosa_w			double precision		:= 0;
cd_motivo_exc_conta_w		bigint;
vl_filme_neg_w			double precision;
qt_idade_w			bigint;
cd_pessoa_fisica_w		varchar(10);
ie_sexo_w			varchar(1);

cd_proc_w			bigint;
ie_origem_proc_w		bigint;
qt_proc_w			bigint;
nr_seq_ajuste_proc_def_w	bigint;
ds_texto_w			varchar(255);
ie_glosa_plano_w		regra_ajuste_proc.ie_glosa%type;
nr_seq_regra_ajuste_w		regra_ajuste_proc.nr_sequencia%type;
vl_kit_p			double precision;

C1 CURSOR FOR
	SELECT	cd_procedimento,
		ie_origem_proced
	from	estrutura_procedimento_v
	where	ie_situacao	= 'A'
	and	((coalesce(cd_procedimento_p::text, '') = '') or (cd_procedimento = cd_procedimento_p AND ie_origem_proced = ie_origem_proced_p))
	and	((coalesce(cd_area_procedimento_p::text, '') = '') or (cd_area_procedimento = cd_area_procedimento_p))
	and	((coalesce(cd_especialidade_p::text, '') = '') or (cd_especialidade = cd_especialidade_p))
	and	((coalesce(cd_grupo_proc_p::text, '') = '') or (cd_grupo_proc = cd_grupo_proc_p))
	and	((coalesce(ds_tipo_proc_adic_p::text, '') = '') or (obter_se_contido(cd_tipo_procedimento, elimina_aspas(ds_tipo_proc_adic_p)) = 'S'))
	and	((cd_area_procedimento_p IS NOT NULL AND cd_area_procedimento_p::text <> '') or (coalesce(ds_area_proc_adic_p::text, '') = '') or (obter_se_contido(cd_area_procedimento, elimina_aspas(ds_area_proc_adic_p)) = 'S'))
	and	((cd_especialidade_p IS NOT NULL AND cd_especialidade_p::text <> '') or (coalesce(ds_espec_proc_adic_p::text, '') = '') or (obter_se_contido(cd_especialidade, elimina_aspas(ds_espec_proc_adic_p)) = 'S'))
	and	((cd_grupo_proc_p IS NOT NULL AND cd_grupo_proc_p::text <> '') or (coalesce(ds_grupo_proc_adic_p::text, '') = '') or (obter_se_contido(cd_grupo_proc, elimina_aspas(ds_grupo_proc_adic_p)) = 'S'))
	order by cd_procedimento;

c00 CURSOR FOR
	SELECT	cd_convenio
	from	convenio
	where	ie_situacao = 'A'
	and	coalesce(cd_classif_convenio_p,0) = 0
	and	((coalesce(ds_conv_adic_p::text, '') = '') or (obter_se_contido(cd_convenio, elimina_aspas(ds_conv_adic_p)) = 'S'))
	
union

	SELECT	a.cd_convenio
	from	convenio_classif b,
		convenio a
	where	a.ie_situacao 		= 'A'
	and	a.cd_convenio		= b.cd_convenio
	and	b.nr_seq_classificacao	= coalesce(cd_classif_convenio_p,0)
	and	((coalesce(ds_conv_adic_p::text, '') = '') or (obter_se_contido(a.cd_convenio, elimina_aspas(ds_conv_adic_p)) = 'S'))
	order by 1;


c01 CURSOR FOR
	SELECT	a.cd_categoria
	from	categoria_convenio a
	where	a.cd_convenio	= cd_convenio_w
	and 	Obter_Se_Categoria_Lib_Estab(cd_estabelecimento_p, a.cd_convenio, a.cd_categoria) = 'S'
	and	((coalesce(ds_categ_conv_adic_p::text, '') = '') or (obter_se_contido(somente_numero(a.cd_convenio||a.cd_categoria), elimina_aspas(ds_categ_conv_adic_p)) = 'S'))
	and	a.ie_situacao	= 'A'
	and	exists (SELECT	1
		from	convenio_amb x
		where	x.cd_convenio		= a.cd_convenio
		and	x.cd_estabelecimento	= cd_estabelecimento_p
		and	x.cd_categoria		= a.cd_categoria
		
union 	all

		select	1
		from	convenio_preco_mat x
		where	x.cd_convenio		= a.cd_convenio
		and	x.cd_estabelecimento	= cd_estabelecimento_p
		and	x.cd_categoria		= a.cd_categoria
		
union 	all

		select	1
		from	convenio_servico x
		where	x.cd_convenio		= a.cd_convenio
		and	x.cd_estabelecimento	= cd_estabelecimento_p
		and	x.cd_categoria		= a.cd_categoria
		
union   all

		select	1
		from	categoria_convenio x
		where	x.cd_convenio		= a.cd_convenio
		and	x.cd_categoria		= a.cd_categoria
		and	x.IE_PRECO_CUSTO	= 'S');

c02 CURSOR FOR
	SELECT	vl_dominio
	from	valor_dominio
	where	cd_dominio	= 12
	and	((coalesce(ds_tipo_atend_adic_p::text, '') = '') or (obter_se_contido(vl_dominio, elimina_aspas(ds_tipo_atend_adic_p)) = 'S'))
	and	ie_tipo_atend_p = 'S'
	
union

	SELECT	vl_dominio
	from	valor_dominio
	where	cd_dominio	= 12
	and	vl_dominio	= 1
	and	ie_tipo_atend_p = 'N';

C05 CURSOR FOR
	SELECT	cd_plano
	from	convenio_plano
	where	cd_convenio	= cd_convenio_w
	and	ie_situacao	= 'A';

C06 CURSOR FOR
	SELECT  cd_procedimento,
		ie_origem_proced
	from 	w_consulta_preco_proc
	where 	nm_usuario = nm_usuario_p;


BEGIN

vl_preco_kit_w := 0;
VL_LANC_AUTOM_W:= 0;


delete	from W_CONSULTA_PRECO_PROC
where	dt_consulta	< clock_timestamp()
and	nm_usuario	= nm_usuario_p;

delete	from W_CONSULTA_PRECO_PROC
where	dt_consulta	< clock_timestamp() - interval '17280 seconds';

delete from W_CONSULTA_COBERTURA_PLANO
where	dt_atualizacao	< clock_timestamp()
and	nm_usuario	= nm_usuario_p;
delete from W_CONSULTA_COBERTURA_PLANO
where	dt_atualizacao	< clock_timestamp() - interval '17280 seconds';

delete from W_CONSULTA_regra_glosa
where	dt_atualizacao	< clock_timestamp()
and	nm_usuario	= nm_usuario_p;
delete from W_CONSULTA_regra_glosa
where	dt_atualizacao	< clock_timestamp() - interval '17280 seconds';


open C1;
loop
fetch C1 into
	cd_procedimento_w,
	ie_origem_proced_w;
EXIT WHEN NOT FOUND; /* apply on C1 */
	begin

	select	max(ie_classificacao)
	into STRICT	IE_CLASSIFICACAO_w
	from	procedimento
	where	cd_procedimento 	= cd_procedimento_w
	and	ie_origem_proced	= ie_origem_proced_w;

	ds_texto_w := substr(wheb_mensagem_pck.get_texto(299649),1,255);-- Regra glosa
	open	c00;
	loop
	fetch	c00 into
		cd_convenio_w;
	EXIT WHEN NOT FOUND; /* apply on c00 */
		begin


		SELECT * FROM converte_proc_convenio(cd_estabelecimento_p, cd_convenio_w, cd_categoria_w, cd_procedimento_w, ie_origem_proced_w, null, null, null, DT_CONTA_P, cd_proc_convenio_w, cd_grupo_convenio_w, nr_seq_conversao_w, null, null, null, 'A', null, ie_clinica_p, 0, null, null, 0, null, cd_empresa_ref_p, ie_carater_inter_sus_p, nr_seq_pacote_p, null, null, null) INTO STRICT cd_proc_convenio_w, cd_grupo_convenio_w, nr_seq_conversao_w;

	open	c01;
	        loop
	        fetch	c01 into
	            cd_categoria_w;
	        EXIT WHEN NOT FOUND; /* apply on c01 */
	            begin

		    open C02;
		    loop
		    fetch C02 into
		    	  ie_tipo_atendimento_w;
		    EXIT WHEN NOT FOUND; /* apply on C02 */
		    	begin

		            if (IE_CLASSIFICACAO_w = 1) then

		                SELECT * FROM define_preco_procedimento(CD_ESTABELECIMENTO_P, cd_convenio_w, CD_CATEGORIA_w, DT_conta_P, cd_procedimento_w, coalesce(CD_TIPO_ACOMODACAO_P,0), IE_TIPO_ATENDIMENTO_w, coalesce(CD_SETOR_ATENDIMENTO_P,0), CD_MEDICO_P, coalesce(CD_FUNCAO_MEDICO_P,0), coalesce(QT_IDADE_P,0), 0, 0, CD_USUARIO_CONVENIO_P, CD_PLANO_P, coalesce(IE_CLINICA_P,0), coalesce(CD_EMPRESA_REF_P,0), null, vl_procedimento_w, VL_CUSTO_OPERACIONAL_w, VL_ANESTESISTA_w, VL_MEDICO_w, VL_AUXILIARES_w, VL_MATERIAIS_w, VL_PTO_PROCEDIMENTO_w, VL_PTO_CUSTO_OPERAC_w, VL_PTO_ANESTESISTA_w, VL_PTO_MEDICO_w, VL_PTO_AUXILIARES_w, VL_PTO_MATERIAIS_w, QT_PORTE_ANESTESICO_w, qt_pontos_w, CD_EDICAO_AMB_w, ie_preco_informado_w, nr_seq_ajuste_proc_def_w, coalesce(NR_SEQUENCIA_P,0), null, 0, null, null, NULL, NULL, null, null, null, null, null, null, ie_carater_inter_sus_p, null, null, null, null, null, null) INTO STRICT vl_procedimento_w, VL_CUSTO_OPERACIONAL_w, VL_ANESTESISTA_w, VL_MEDICO_w, VL_AUXILIARES_w, VL_MATERIAIS_w, VL_PTO_PROCEDIMENTO_w, VL_PTO_CUSTO_OPERAC_w, VL_PTO_ANESTESISTA_w, VL_PTO_MEDICO_w, VL_PTO_AUXILIARES_w, VL_PTO_MATERIAIS_w, QT_PORTE_ANESTESICO_w, qt_pontos_w, CD_EDICAO_AMB_w, ie_preco_informado_w, nr_seq_ajuste_proc_def_w;

				if (ie_calcula_kit_p = 'S') then
					vl_preco_kit_w := Calcular_Preco_Kit(CD_ESTABELECIMENTO_P, cd_convenio_w, CD_CATEGORIA_W, DT_conta_P, cd_procedimento_w, coalesce(CD_TIPO_ACOMODACAO_P,0), coalesce(QT_IDADE_P,0), coalesce(NR_SEQUENCIA_P,0), IE_TIPO_ATENDIMENTO_w, coalesce(CD_SETOR_ATENDIMENTO_P,0), 1, CD_CGC_FORNECEDOR_P, vl_preco_kit_w);
				end if;

				if (ie_calcula_lanc_auto_p = 'S') then
				vl_kit_p := 0;

					SELECT * FROM Calcular_Lancamento_Automatico(CD_ESTABELECIMENTO_P, cd_convenio_w, CD_CATEGORIA_W, DT_conta_P, coalesce(CD_TIPO_ACOMODACAO_P,0), cd_procedimento_w, IE_ORIGEM_PROCED_w, CD_MEDICO_P, coalesce(CD_FUNCAO_MEDICO_P,0), coalesce(QT_IDADE_P,0), coalesce(NR_SEQUENCIA_P,0), 0, 0, IE_TIPO_ATENDIMENTO_w, coalesce(CD_SETOR_ATENDIMENTO_P,0), CD_USUARIO_CONVENIO_P, CD_PLANO_P, coalesce(IE_CLINICA_P,0), coalesce(CD_EMPRESA_REF_P,0), 1, CD_CGC_FORNECEDOR_P, CD_EDICAO_AMB_w, 'N', vl_kit_p, VL_LANC_AUTOM_W) INTO STRICT vl_kit_p, VL_LANC_AUTOM_W;
				end if;


			   	VL_CH_HONORARIOS_w	:= 0;
			   	VL_CH_CUSTO_OPER_w	:= 0;
			   	VL_FILME_w 		:= 0;


			   	if (CD_EDICAO_AMB_W IS NOT NULL AND CD_EDICAO_AMB_W::text <> '') and (CD_EDICAO_AMB_W > 0) then
					select	max(VL_CH_HONORARIOS),
						max(VL_CH_CUSTO_OPER),
				 		max(VL_FILME)
					into STRICT	VL_CH_HONORARIOS_w,
						VL_CH_CUSTO_OPER_w,
						VL_FILME_W
					from	convenio_amb
					where	cd_estabelecimento	= CD_ESTABELECIMENTO_P
					and	cd_convenio		= cd_convenio_w
					and	cd_categoria		= CD_CATEGORIA_w
					and 	cd_edicao_amb		= cd_edicao_amb_w
					and 	coalesce(ie_situacao,'A')	= 'A'
					and	dt_inicio_vigencia	=
							(SELECT	max(dt_inicio_vigencia)
							from	convenio_amb a
							where	a.cd_estabelecimento	= CD_ESTABELECIMENTO_P
							and	a.cd_convenio		= cd_convenio_w
							and	a.cd_categoria		= CD_CATEGORIA_w
							and 	cd_edicao_amb		= cd_edicao_amb_w
			   				and 	coalesce(ie_situacao,'A')	= 'A'
							and	a.dt_inicio_vigencia 	<= DT_CONTA_P);

		            	end if;


				SELECT * FROM OBTER_COTACAO_MOEDA_CONVENIO(
						CD_ESTABELECIMENTO_P, CD_CONVENIO_w, CD_CATEGORIA_w, CD_PROCEDIMENTO_w, coalesce(ie_origem_proced_w,ie_origem_proced_p), DT_CONTA_P, 'P', coalesce(CD_SETOR_ATENDIMENTO_P,0), IE_TIPO_ATENDIMENTO_w, coalesce(CD_FUNCAO_MEDICO_P,0), cd_usuario_convenio_p, cd_plano_p, coalesce(IE_CLINICA_P,0), coalesce(CD_EMPRESA_REF_P,0), CD_EDICAO_AMB_W, null, null, cd_tipo_acomodacao_p, VL_HONORARIOS_moeda_W, VL_CUSTO_OPER_moeda_W, VL_FILME_CONV_moeda_W) INTO STRICT VL_HONORARIOS_moeda_W, VL_CUSTO_OPER_moeda_W, VL_FILME_CONV_moeda_W;



				if (ie_calc_adicional_horario_p = 'S') then

					SELECT * FROM DEFINE_ADICIONAL_HORARIO(CD_ESTABELECIMENTO_P, cd_procedimento_w, IE_ORIGEM_PROCED_w, CD_CONVENIO_W, CD_CATEGORIA_W, coalesce(CD_SETOR_ATENDIMENTO_P,0), IE_TIPO_ATENDIMENTO_w, IE_CARATER_INTER_SUS_P, DT_CONTA_P, IE_CARATER_CIRURGIA_P, IE_VIDEO_P, null, null, cd_tipo_acomodacao_p, CD_MEDICO_P, cd_plano_p, null, tx_adic_medico_w, tx_adic_anestesista_w, tx_adic_auxiliares_w, tx_adic_custo_operacional_w, tx_adic_materiais_w, tx_adic_procedimento_w, vl_adic_proc_w, vl_adic_medico_w, cd_proced_calculo_horario_w, ie_origem_proced_horario_w, nr_seq_adic_w, ie_clinica_p, somente_numero(cd_edicao_amb_w), 0) INTO STRICT tx_adic_medico_w, tx_adic_anestesista_w, tx_adic_auxiliares_w, tx_adic_custo_operacional_w, tx_adic_materiais_w, tx_adic_procedimento_w, vl_adic_proc_w, vl_adic_medico_w, cd_proced_calculo_horario_w, ie_origem_proced_horario_w, nr_seq_adic_w;

					vl_custo_operacional_w 	:= (tx_adic_custo_operacional_w 	* vl_custo_operacional_w);
					vl_anestesista_w 	:= (tx_adic_anestesista_w 		* vl_anestesista_w);
					vl_medico_w 		:= (tx_adic_medico_w * (vl_adic_medico_w + vl_medico_w));
					vl_auxiliares_w 	:= (tx_adic_auxiliares_w 		* vl_auxiliares_w);
					vl_materiais_w 		:= (tx_adic_materiais_w 		* vl_materiais_w);
					vl_procedimento_w	:= (tx_adic_procedimento_w * (vl_adic_proc_w + vl_custo_operacional_w + vl_anestesista_w +
									vl_medico_w + vl_auxiliares_w + vl_materiais_w));


				end if;
			if (Obter_Valor_Param_Usuario(1115,8,obter_perfil_ativo,nm_usuario_p,0)	= 'S') then
				SELECT * FROM consiste_plano_convenio(	null, cd_convenio_w, cd_procedimento_w, ie_origem_proced_w, dt_conta_p, 1, ie_tipo_atendimento_w, cd_plano_p, null, ds_erro_w, cd_setor_atendimento_p, null, ie_regra_w, null, nr_seq_regra_w, null, cd_categoria_w, cd_estabelecimento_p, null, null, '', ie_glosa_plano_w, nr_seq_regra_ajuste_w) INTO STRICT ds_erro_w, ie_regra_w, nr_seq_regra_w, ie_glosa_plano_w, nr_seq_regra_ajuste_w;
				if (ie_regra_w	in (1,2) ) then
					vl_procedimento_w 	:= 0;
					vl_preco_kit_w 		:= 0;
					vl_lanc_autom_w		:= 0;
					vl_custo_operacional_w	:= 0;
					vl_medico_w		:= 0;
					vl_anestesista_w	:= 0;
					vl_auxiliares_w		:= 0;
					vl_materiais_w		:= 0;
				end if;
			end if;

			select	nextval('w_consulta_preco_seq')
			into STRICT	nr_sequencia_w
			;

			select	max(cd_edicao_amb)
			into STRICT	CD_EDICAO_AMB_w
			from	edicao_amb
			where	cd_edicao_amb	= CD_EDICAO_AMB_w;

			begin
			select	a.cd_moeda
			into STRICT	cd_moeda_w
			from	preco_amb a
			where (a.cd_edicao_amb    	= cd_edicao_amb_w)
			and (a.cd_procedimento  	= cd_procedimento_w)
			and	coalesce(a.dt_inicio_vigencia,clock_timestamp() - interval '3650 days')	=
				 (	SELECT	max(coalesce(b.dt_inicio_vigencia,clock_timestamp() - interval '3650 days'))
					from  	preco_amb b
					where 	b.cd_edicao_amb		= cd_edicao_amb_w
					and	b.cd_procedimento		= cd_procedimento_w
					and	coalesce(b.dt_inicio_vigencia,clock_timestamp() - interval '3650 days')	<= dt_conta_p);
			exception
			when others then
				cd_moeda_w	:=1;
			end;
			pr_percentual_w	:= 0;
			if (ie_percentual_p	<> 0) then
				SELECT * FROM define_preco_procedimento(CD_ESTABELECIMENTO_P, cd_convenio_percentual_p, cd_categoria_percentual_p, DT_conta_P, cd_procedimento_w, coalesce(CD_TIPO_ACOMODACAO_P,0), IE_TIPO_ATENDIMENTO_w, coalesce(CD_SETOR_ATENDIMENTO_P,0), CD_MEDICO_P, coalesce(CD_FUNCAO_MEDICO_P,0), coalesce(QT_IDADE_P,0), 0, 0, CD_USUARIO_CONVENIO_P, CD_PLANO_P, coalesce(IE_CLINICA_P,0), coalesce(CD_EMPRESA_REF_P,0), null, vl_procedimento_perc_w, VL_CUSTO_OPERACIONAL_w, VL_ANESTESISTA_w, VL_MEDICO_w, VL_AUXILIARES_w, VL_MATERIAIS_w, VL_PTO_PROCEDIMENTO_w, VL_PTO_CUSTO_OPERAC_w, VL_PTO_ANESTESISTA_w, VL_PTO_MEDICO_w, VL_PTO_AUXILIARES_w, VL_PTO_MATERIAIS_w, QT_PORTE_ANESTESICO_w, qt_pontos_w, CD_EDICAO_AMB_w, ie_preco_informado_w, nr_seq_ajuste_proc_def_w, coalesce(NR_SEQUENCIA_P,0), null, 0, null, null, NULL, NULL, null, null, null, null, null, null, ie_carater_inter_sus_p, null, null, null, null, null, null) INTO STRICT vl_procedimento_perc_w, VL_CUSTO_OPERACIONAL_w, VL_ANESTESISTA_w, VL_MEDICO_w, VL_AUXILIARES_w, VL_MATERIAIS_w, VL_PTO_PROCEDIMENTO_w, VL_PTO_CUSTO_OPERAC_w, VL_PTO_ANESTESISTA_w, VL_PTO_MEDICO_w, VL_PTO_AUXILIARES_w, VL_PTO_MATERIAIS_w, QT_PORTE_ANESTESICO_w, qt_pontos_w, CD_EDICAO_AMB_w, ie_preco_informado_w, nr_seq_ajuste_proc_def_w;

					if (ie_percentual_p	= 1) then
						pr_percentual_w := dividir(vl_procedimento_w * 100,vl_procedimento_perc_w);
					elsif (ie_percentual_p	= 2) then
						pr_percentual_w := abs((dividir(vl_procedimento_w,vl_procedimento_perc_w) -1) * 100);
					end if;
				end if;


		            insert into w_consulta_preco_proc(cd_procedimento,
				ie_origem_proced,
				dt_consulta,
				cd_convenio,
				cd_categoria,
				ie_tipo_atendimento,
				dt_atualizacao,
				nm_usuario,
				vl_procedimento,
				vl_custo_operacional,
				vl_medico,
				vl_anestesista,
				vl_auxiliares,
				vl_materiais,
				cd_edicao_amb,
				cd_proc_convenio,
				cd_moeda,
				pr_particular)
			    values (cd_procedimento_w,
				coalesce(ie_origem_proced_w,ie_origem_proced_p),
				clock_timestamp(),
		                cd_convenio_w,
		                cd_categoria_w,
				ie_tipo_atendimento_w,
		                clock_timestamp(),
		                nm_usuario_p,
		                vl_procedimento_w + vl_preco_kit_w + vl_lanc_autom_w,
		                vl_custo_operacional_w,
		                vl_medico_w,
		                vl_anestesista_w,
		                vl_auxiliares_w,
		                vl_materiais_w,
		                CASE WHEN cd_edicao_amb_w=0 THEN  null  ELSE cd_edicao_amb_w END ,
				cd_proc_convenio_w,
				cd_moeda_w,
				pr_percentual_w);

		if (ie_cobertura_plano_p	= 'S') then
			open C05;
			loop
			fetch C05 into
				cd_plano_w;
			EXIT WHEN NOT FOUND; /* apply on C05 */
				begin
				SELECT * FROM consiste_plano_convenio(	null, cd_convenio_w, cd_procedimento_w, ie_origem_proced_w, dt_conta_p, 1, ie_tipo_atendimento_w, cd_plano_w, null, ds_erro_w, cd_setor_atendimento_p, null, ie_regra_w, null, nr_seq_regra_w, null, cd_categoria_w, cd_estabelecimento_p, null, null, '', ie_glosa_plano_w, nr_seq_regra_ajuste_w) INTO STRICT ds_erro_w, ie_regra_w, nr_seq_regra_w, ie_glosa_plano_w, nr_seq_regra_ajuste_w;
				insert into  W_CONSULTA_COBERTURA_PLANO(	cd_convenio,
										cd_plano,
										cd_categoria,
										dt_atualizacao,
										nm_usuario,
										ie_regra_plano,
										cd_procedimento,
										ie_origem_proced,
										ie_tipo_atendimento)

							values (	cd_convenio_w,
										cd_plano_w,
										cd_categoria_w,
										clock_timestamp(),
										nm_usuario_p,
										ie_regra_w,
										cd_procedimento_w,
										ie_origem_proced_w,
										ie_tipo_atendimento_w);


				end;
			end loop;
			close C05;
		end if;

		if (ie_glosa_p	= 'S') then

			SELECT * FROM OBTER_REGRA_AJUSTE_PROC(cd_estabelecimento_p, cd_convenio_w, cd_categoria_w, cd_procedimento_w, ie_origem_proced_w, null, dt_conta_p, coalesce(CD_TIPO_ACOMODACAO_P,0), IE_TIPO_ATENDIMENTO_w, coalesce(CD_SETOR_ATENDIMENTO_P,0), CD_MEDICO_P, coalesce(CD_FUNCAO_MEDICO_P,0), coalesce(QT_IDADE_P,0), null, null, null, null, coalesce(IE_CLINICA_P,0), coalesce(CD_EMPRESA_REF_P,0), null, tx_ajuste_proc_w, tx_ajuste_Custo_Oper_w, tx_ajuste_Medico_w, tx_ajuste_partic_w, tx_ajuste_Filme_w, vl_proc_ajustado_w, ie_preco_informado_w, ie_glosa_w, cd_procedimento_esp_w, nr_seq_regra_preco_w, CD_EDICAO_AJUSTE_W, vl_medico_neg_w, vl_custo_oper_neg_w, qt_filme_neg_w, nr_auxiliares_neg_w, qt_porte_anest_neg_w, pr_glosa_w, vl_glosa_w, cd_motivo_exc_conta_w, 'A', 0, ie_autor_particular_w, cd_convenio_glosa_w, cd_categoria_glosa_w, nr_seq_ajuste_proc_w, null, null, null, null, null, null, null, null, vl_filme_neg_w, null, null, null, null, ie_carater_inter_sus_p, null, null, null, null, null) INTO STRICT tx_ajuste_proc_w, tx_ajuste_Custo_Oper_w, tx_ajuste_Medico_w, tx_ajuste_partic_w, tx_ajuste_Filme_w, vl_proc_ajustado_w, ie_preco_informado_w, ie_glosa_w, cd_procedimento_esp_w, nr_seq_regra_preco_w, CD_EDICAO_AJUSTE_W, vl_medico_neg_w, vl_custo_oper_neg_w, qt_filme_neg_w, nr_auxiliares_neg_w, qt_porte_anest_neg_w, pr_glosa_w, vl_glosa_w, cd_motivo_exc_conta_w, ie_autor_particular_w, cd_convenio_glosa_w, cd_categoria_glosa_w, nr_seq_ajuste_proc_w, vl_filme_neg_w;


			Insert into  W_CONSULTA_REGRA_GLOSA(	cd_convenio,
									cd_categoria,
									dt_atualizacao,
									nm_usuario,
									ds_glosa,
									ie_glosa,
									cd_procedimento,
									ie_origem_proced,
									ie_tipo_atendimento)

							values (cd_convenio_w,
									cd_categoria_w,
									clock_timestamp(),
									nm_usuario_p,
									ds_texto_w,
									ie_glosa_w,
									cd_procedimento_w,
									ie_origem_proced_w,
									ie_tipo_atendimento_w);



		end if;

		            elsif (IE_CLASSIFICACAO_w <> 1) then


				SELECT * FROM define_preco_servico(CD_ESTABELECIMENTO_P, cd_convenio_w, CD_CATEGORIA_w, DT_conta_P, cd_procedimento_w, coalesce(CD_SETOR_ATENDIMENTO_P,0), IE_TIPO_ATENDIMENTO_w, coalesce(CD_TIPO_ACOMODACAO_P,0), CD_USUARIO_CONVENIO_P, CD_PLANO_P, coalesce(IE_CLINICA_P,0), coalesce(CD_EMPRESA_REF_P,0), null, vl_procedimento_w, nr_seq_ajuste_proc_def_w, null, 0, null, null, null, null, null, null, null, null, null, null, null, cd_medico_p) INTO STRICT vl_procedimento_w, nr_seq_ajuste_proc_def_w;

				if (ie_calcula_kit_p = 'S') then
					vl_preco_kit_w := Calcular_Preco_Kit(CD_ESTABELECIMENTO_P, cd_convenio_w, CD_CATEGORIA_W, DT_conta_P, cd_procedimento_w, coalesce(CD_TIPO_ACOMODACAO_P,0), coalesce(QT_IDADE_P,0), coalesce(NR_SEQUENCIA_P,0), IE_TIPO_ATENDIMENTO_w, coalesce(CD_SETOR_ATENDIMENTO_P,0), 3, CD_CGC_FORNECEDOR_P, vl_preco_kit_w);
				end if;

				if (ie_calcula_lanc_auto_p = 'S') then
				vl_kit_p := 0;

					SELECT * FROM Calcular_Lancamento_Automatico(CD_ESTABELECIMENTO_P, cd_convenio_w, CD_CATEGORIA_W, DT_conta_P, coalesce(CD_TIPO_ACOMODACAO_P,0), cd_procedimento_w, IE_ORIGEM_PROCED_w, CD_MEDICO_P, coalesce(CD_FUNCAO_MEDICO_P,0), coalesce(QT_IDADE_P,0), coalesce(NR_SEQUENCIA_P,0), 0, 0, IE_TIPO_ATENDIMENTO_w, coalesce(CD_SETOR_ATENDIMENTO_P,0), CD_USUARIO_CONVENIO_P, CD_PLANO_P, coalesce(IE_CLINICA_P,0), coalesce(CD_EMPRESA_REF_P,0), 3, CD_CGC_FORNECEDOR_P, null, 'N', vl_kit_p, VL_LANC_AUTOM_W) INTO STRICT vl_kit_p, VL_LANC_AUTOM_W;

				end if;


			   	VL_CH_HONORARIOS_w	:= 0;
			   	VL_CH_CUSTO_OPER_w	:= 0;
			   	VL_FILME_w 		:= 0;

			   	if (CD_EDICAO_AMB_W IS NOT NULL AND CD_EDICAO_AMB_W::text <> '') and (CD_EDICAO_AMB_W > 0) then
					begin
					select	VL_CH_HONORARIOS,
						VL_CH_CUSTO_OPER,
				 		VL_FILME
					into STRICT	VL_CH_HONORARIOS_w,
						VL_CH_CUSTO_OPER_w,
						VL_FILME_W
					from	convenio_amb
					where	cd_estabelecimento	= CD_ESTABELECIMENTO_P
					and	cd_convenio		= cd_convenio_w
					and	cd_categoria		= CD_CATEGORIA_w
					and 	cd_edicao_amb		= cd_edicao_amb_w
					and 	coalesce(ie_situacao,'A')	= 'A'
					and	dt_inicio_vigencia	=
							(SELECT	max(dt_inicio_vigencia)
							from	convenio_amb a
							where	a.cd_estabelecimento	= CD_ESTABELECIMENTO_P
							and	a.cd_convenio		= cd_convenio_w
							and	a.cd_categoria		= CD_CATEGORIA_w
							and 	cd_edicao_amb		= cd_edicao_amb_w
			   				and 	coalesce(ie_situacao,'A')	= 'A'
							and	a.dt_inicio_vigencia 	<= DT_CONTA_P);
					exception
					when others then
						VL_CH_HONORARIOS_w	:= 1;
						VL_CH_CUSTO_OPER_w	:= 1;
						VL_FILME_W		:= 1;
					end;
		            	end if;

				begin
				select	a.cd_moeda
				into STRICT	cd_moeda_w
				from	preco_amb a
				where (a.cd_edicao_amb    	= cd_edicao_amb_w)
		  		and (a.cd_procedimento  	= cd_procedimento_w)
	  			and	coalesce(a.dt_inicio_vigencia,clock_timestamp() - interval '3650 days')	=
					 (	SELECT	max(coalesce(b.dt_inicio_vigencia,clock_timestamp() - interval '3650 days'))
						from  	preco_amb b
						where 	b.cd_edicao_amb		= cd_edicao_amb_w
						and	b.cd_procedimento		= cd_procedimento_w
						and	coalesce(b.dt_inicio_vigencia,clock_timestamp() - interval '3650 days')	<= dt_conta_p);
				exception
				when others then
					cd_moeda_w	:=1;
				end;

				if (ie_calc_adicional_horario_p = 'S') then

					SELECT * FROM define_adicional_horario(cd_estabelecimento_p, cd_procedimento_w, ie_origem_proced_w, cd_convenio_w, cd_categoria_w, coalesce(cd_setor_atendimento_p,0), ie_tipo_atendimento_w, ie_carater_inter_sus_p, dt_conta_p, ie_carater_cirurgia_p, ie_video_p, null, null, cd_tipo_acomodacao_p, CD_MEDICO_P, cd_plano_p, null, tx_adic_medico_w, tx_adic_anestesista_w, tx_adic_auxiliares_w, tx_adic_custo_operacional_w, tx_adic_materiais_w, tx_adic_procedimento_w, vl_adic_proc_w, vl_adic_medico_w, cd_proced_calculo_horario_w, ie_origem_proced_horario_w, nr_seq_adic_w, null, null, 0) INTO STRICT tx_adic_medico_w, tx_adic_anestesista_w, tx_adic_auxiliares_w, tx_adic_custo_operacional_w, tx_adic_materiais_w, tx_adic_procedimento_w, vl_adic_proc_w, vl_adic_medico_w, cd_proced_calculo_horario_w, ie_origem_proced_horario_w, nr_seq_adic_w;

					vl_procedimento_w	:= (tx_adic_procedimento_w * (vl_adic_proc_w + vl_procedimento_w));

				end if;

				if (Obter_Valor_Param_Usuario(1115,8,obter_perfil_ativo,nm_usuario_p,0)	= 'S')  then
					SELECT * FROM consiste_plano_convenio(	null, cd_convenio_w, cd_procedimento_w, ie_origem_proced_w, dt_conta_p, 1, ie_tipo_atendimento_w, cd_plano_p, null, ds_erro_w, cd_setor_atendimento_p, null, ie_regra_w, null, nr_seq_regra_w, null, cd_categoria_w, cd_estabelecimento_p, null, null, '', ie_glosa_plano_w, nr_seq_regra_ajuste_w) INTO STRICT ds_erro_w, ie_regra_w, nr_seq_regra_w, ie_glosa_plano_w, nr_seq_regra_ajuste_w;
					if (ie_regra_w	in (1,2) ) then
						vl_procedimento_w 	:= 0;
						vl_preco_kit_w 		:= 0;
						vl_lanc_autom_w		:= 0;
						vl_custo_operacional_w	:= 0;
						vl_medico_w		:= 0;
						vl_anestesista_w	:= 0;
						vl_auxiliares_w		:= 0;
						vl_materiais_w		:= 0;
					end if;
				end if;
				pr_percentual_w		:=0;
				if (ie_percentual_p	<> 0) then

					SELECT * FROM define_preco_servico(CD_ESTABELECIMENTO_P, cd_convenio_percentual_p, cd_categoria_percentual_p, DT_conta_P, cd_procedimento_w, coalesce(CD_SETOR_ATENDIMENTO_P,0), IE_TIPO_ATENDIMENTO_w, coalesce(CD_TIPO_ACOMODACAO_P,0), CD_USUARIO_CONVENIO_P, CD_PLANO_P, coalesce(IE_CLINICA_P,0), coalesce(CD_EMPRESA_REF_P,0), null, vl_procedimento_perc_w, nr_seq_ajuste_proc_def_w, null, 0, null, null, null, null, null, null, null, null, null, null, null, cd_medico_p) INTO STRICT vl_procedimento_perc_w, nr_seq_ajuste_proc_def_w;
					if (ie_percentual_p	= 1) then
						pr_percentual_w := dividir(vl_procedimento_w * 100,vl_procedimento_perc_w);
					elsif (ie_percentual_p	= 2) then
						pr_percentual_w := abs((dividir(vl_procedimento_w,vl_procedimento_perc_w) -1) * 100);
					end if;
				end if;

		            select	nextval('w_consulta_preco_seq')
		            into STRICT	nr_sequencia_w
		;

		            insert	into w_consulta_preco_proc(cd_procedimento,
					ie_origem_proced,
					dt_consulta,
					cd_convenio,
					cd_categoria,
					ie_tipo_atendimento,
					dt_atualizacao,
					nm_usuario,
					vl_procedimento,
					vl_custo_operacional,
					vl_medico,
					vl_anestesista,
					vl_auxiliares,
					vl_materiais,
					cd_edicao_amb,
					cd_proc_convenio,
					cd_moeda,
					pr_particular)
				    values (cd_procedimento_w,
					coalesce(ie_origem_proced_w,ie_origem_proced_p),
					clock_timestamp(),
			                cd_convenio_w,
			                cd_categoria_w,
					ie_tipo_atendimento_w,
			                clock_timestamp(),
			                nm_usuario_p,
			                vl_procedimento_w + vl_preco_kit_w + vl_lanc_autom_w,
			                null,
			                null,
			                null,
			                null,
			                null,
			                null,
					cd_proc_convenio_w,
					cd_moeda_w,
					pr_percentual_w);

		if (ie_glosa_p	= 'S') then

			SELECT * FROM OBTER_REGRA_AJUSTE_PROC(cd_estabelecimento_p, cd_convenio_w, cd_categoria_w, cd_procedimento_w, ie_origem_proced_w, ie_video_p, dt_conta_p, coalesce(CD_TIPO_ACOMODACAO_P,0), IE_TIPO_ATENDIMENTO_w, coalesce(CD_SETOR_ATENDIMENTO_P,0), CD_MEDICO_P, coalesce(CD_FUNCAO_MEDICO_P,0), coalesce(QT_IDADE_P,0), 0, 0, CD_USUARIO_CONVENIO_P, CD_PLANO_P, coalesce(IE_CLINICA_P,0), coalesce(CD_EMPRESA_REF_P,0), null, tx_ajuste_proc_w, tx_ajuste_Custo_Oper_w, tx_ajuste_Medico_w, tx_ajuste_partic_w, tx_ajuste_Filme_w, vl_proc_ajustado_w, ie_preco_informado_w, ie_glosa_w, cd_procedimento_esp_w, nr_seq_regra_preco_w, CD_EDICAO_AJUSTE_W, vl_medico_neg_w, vl_custo_oper_neg_w, qt_filme_neg_w, nr_auxiliares_neg_w, qt_porte_anest_neg_w, pr_glosa_w, vl_glosa_w, cd_motivo_exc_conta_w, null, null, ie_autor_particular_w, cd_convenio_glosa_w, cd_categoria_glosa_w, nr_seq_ajuste_proc_w, null, null, null, null, null, null, null, null, vl_filme_neg_w, null, null, null, null, ie_carater_inter_sus_p, null, null, null, null, null) INTO STRICT tx_ajuste_proc_w, tx_ajuste_Custo_Oper_w, tx_ajuste_Medico_w, tx_ajuste_partic_w, tx_ajuste_Filme_w, vl_proc_ajustado_w, ie_preco_informado_w, ie_glosa_w, cd_procedimento_esp_w, nr_seq_regra_preco_w, CD_EDICAO_AJUSTE_W, vl_medico_neg_w, vl_custo_oper_neg_w, qt_filme_neg_w, nr_auxiliares_neg_w, qt_porte_anest_neg_w, pr_glosa_w, vl_glosa_w, cd_motivo_exc_conta_w, ie_autor_particular_w, cd_convenio_glosa_w, cd_categoria_glosa_w, nr_seq_ajuste_proc_w, vl_filme_neg_w;

			insert into  W_CONSULTA_REGRA_GLOSA(	cd_convenio,
									cd_categoria,
									dt_atualizacao,
									nm_usuario,
									ds_glosa,
									ie_glosa,
									cd_procedimento,
									ie_origem_proced,
									ie_tipo_atendimento)

							values (cd_convenio_w,
									cd_categoria_w,
									clock_timestamp(),
									nm_usuario_p,
									ds_texto_w,
									ie_glosa_w,
									cd_procedimento_w,
									ie_origem_proced_w,
									ie_tipo_atendimento_w);



		end if;


		if (ie_cobertura_plano_p	= 'S') then
			open C05;
			loop
			fetch C05 into
				cd_plano_w;
			EXIT WHEN NOT FOUND; /* apply on C05 */
				begin
				SELECT * FROM consiste_plano_convenio(	null, cd_convenio_w, cd_procedimento_w, ie_origem_proced_w, dt_conta_p, 1, ie_tipo_atendimento_w, cd_plano_p, null, ds_erro_w, cd_setor_atendimento_p, null, ie_regra_w, null, nr_seq_regra_w, null, cd_categoria_w, cd_estabelecimento_p, null, null, '', ie_glosa_plano_w, nr_seq_regra_ajuste_w) INTO STRICT ds_erro_w, ie_regra_w, nr_seq_regra_w, ie_glosa_plano_w, nr_seq_regra_ajuste_w;

				insert into  W_CONSULTA_COBERTURA_PLANO(	cd_convenio,
										cd_plano,
										cd_categoria,
										dt_atualizacao,
										nm_usuario,
										ie_regra_plano,
										cd_procedimento,
										ie_origem_proced,
										ie_tipo_atendimento)

							values (	cd_convenio_w,
										cd_plano_w,
										cd_categoria_w,
										clock_timestamp(),
										nm_usuario_p,
										ie_regra_w,
										cd_procedimento_w,
										ie_origem_proced_w,
										ie_tipo_atendimento_w);

				end;
			end loop;
			close C05;
		end if;
		            end if;

		    	end;
			end loop;
		    close C02;


	            end;
	        end loop;
	        close c01;

		end;
	end loop;
	close c00;

	/*
	select	count(distinct cd_convenio)
	into	qt_colunas_w
	from	w_consulta_preco_proc a
	where	a.nm_usuario	= nm_usuario_p;

	if	(qt_colunas_w > 0) then

		ds_comando_w		:= ' create table ww_cons_conv_' || nm_usuario_p || ' (';

		for i 	in 1..qt_colunas_w loop
			begin
			ds_comando_w		:= ds_comando_w || ' ds_coluna' || i || ' varchar2(80), ';
			end;
		end loop;

		ds_comando_w	:= ds_comando_w || ' nm_usuario		varchar2(15)) ';

		begin
		Exec_sql_Dinamico('Consulta Proc', 'drop table ' || ' ww_cons_conv_' || nm_usuario_p);
		exception
			when others then
				cd_procedimento_ww	:= cd_procedimento_ww;
			end;
		Exec_sql_Dinamico('Consulta Proc', ds_comando_w);
	end if;

	cd_proc_ant_w		:= 0;
	cd_conv_ant_w		:= 0;
	ds_comando_w		:= '';
	ds_comando_col_w	:= ' ';

	open C09;
	loop
	fetch C09 into
		cd_convenio_ww,
		ds_convenio_ww;
	exit when C09%notfound;
		begin

		if	(cd_conv_ant_w	 = 0) then
			ds_comando_w		:= ' insert into ww_cons_conv_' || nm_usuario_p || ' values (';
		end if;

		ds_comando_w		:= ds_comando_w || chr(39) || cd_convenio_ww || ';' || ds_convenio_ww || chr(39) || ',';

		cd_conv_ant_w	:= cd_convenio_ww;
		end;
	end loop;
	close C09;

	Exec_sql_Dinamico('Consulta Proc', ds_comando_w || chr(39) || nm_usuario_p || chr(39) || ')');

*/
	end;
end loop;
close C1;


if (ie_proc_utilizado_p = 'S') then

	open C06;
	loop
	fetch C06 into
		cd_proc_w,
		ie_origem_proc_w;
	EXIT WHEN NOT FOUND; /* apply on C06 */
		begin

		select 	count(*)
		into STRICT	qt_proc_w
		from 	procedimento_paciente
		where 	cd_procedimento = cd_proc_w
		and 	ie_origem_proced = ie_origem_proc_w
		and 	dt_procedimento > clock_timestamp() - interval '60 days';

		if (qt_proc_w = 0) then

			delete 	from w_consulta_preco_proc
			where	nm_usuario	= nm_usuario_p
			and 	cd_procedimento = cd_proc_w
			and 	ie_origem_proced = ie_origem_proc_w;

		end if;

		end;
	end loop;
	close C06;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_consulta_preco_proc (cd_estabelecimento_p bigint, dt_conta_p timestamp, cd_tipo_acomodacao_p bigint, ie_tipo_atendimento_p bigint, cd_setor_atendimento_p bigint, cd_medico_p text, cd_funcao_medico_p bigint, qt_idade_p bigint, cd_usuario_convenio_p text, cd_plano_p text, ie_clinica_p bigint, cd_empresa_ref_p bigint, cd_cgc_fornecedor_p text, nr_sequencia_p bigint, nr_seq_pacote_p bigint, ds_conv_adic_p text, ds_tipo_atend_adic_p text, ds_categ_conv_adic_p text, ds_tipo_proc_adic_p text, nm_usuario_p text, ie_carater_inter_sus_p text, ie_carater_cirurgia_p text, ie_video_p text, qt_dia_int_p bigint, ie_calcula_kit_p text, ie_calcula_lanc_auto_p text, ie_cobertura_plano_p text, ie_glosa_p text, ie_calc_adicional_horario_p text, cd_area_procedimento_p bigint, cd_especialidade_p bigint, cd_grupo_proc_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_classif_convenio_p bigint, ie_tipo_atend_p text, ie_percentual_p bigint, cd_convenio_percentual_p bigint, cd_categoria_percentual_p text, ie_proc_utilizado_p text, ds_area_proc_adic_p text, ds_espec_proc_adic_p text, ds_grupo_proc_adic_p text) FROM PUBLIC;

