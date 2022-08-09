-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_proc_assoc_orcamento (nr_seq_orcamento_p bigint, nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_estabelecimento_w		smallint;
nr_atendimento_w		bigint;
ie_tipo_atendimento_w		smallint;
qt_idade_pac_w			double precision;
cd_pessoa_fisica_w		varchar(10);
cd_convenio_w			integer;
cd_categoria_w			varchar(10);
ie_tipo_convenio_w		smallint;
ie_origem_proc_filtro_w		bigint;
nr_seq_proc_int_adic_w 		bigint;
cd_proced_adic_w		bigint;
ie_origem_proc_adic_w 		bigint;
qt_proc_adic_w			double precision;
ie_tipo_regra_w			varchar(1);
ie_ConsisteRegraPlano_w		varchar(1);
cd_plano_w			varchar(10);
dt_orcamento_w			timestamp;
ds_erro_w			varchar(255);
ie_regra_w			varchar(2);
nr_Seq_regra_w			bigint;
ie_autorizacao_w		varchar(3);
ie_resp_autor_w			varchar(2);
ie_ConsisteGlosaParticular_w	varchar(1);
ds_retorno_texto_w		varchar(255);
ds_retorno_numerico_w		bigint;
ie_glosa_w			varchar(5);
cd_conv_glosa_w			integer;
cd_categ_glosa_w		varchar(10);
ie_consiste_edicao_w		varchar(1);
ie_vinc_proc_princ_orc_w	varchar(1);
ie_agenda_integrada_w		varchar(1);
nr_seq_proc_assoc_w		bigint;
cd_tipo_acomodacao_w		smallint;
qt_inativo_proc_int_w		bigint;
qt_inativo_proc_w		bigint;
nr_seq_origem_w			bigint;
ie_calcula_orcamento_w		varchar(1);
ie_glosa_plano_w			regra_ajuste_proc.ie_glosa%type;
nr_seq_regra_preco_w		regra_ajuste_proc.nr_sequencia%type;
nr_seq_classif_medico_w		atendimento_paciente.nr_seq_classif_medico%type;
cd_setor_atendimento_w		setor_atendimento.cd_setor_atendimento%type;

C01 CURSOR FOR
	SELECT	a.nr_seq_proc_int_adic,
		a.qt_proc_adic,
		a.cd_procedimento,
		a.ie_origem_proced,
		a.ie_tipo_regra,
		coalesce(a.ie_vinc_proc_princ_orc, 'N'),
		coalesce(ie_agenda_integrada, 'N'),
		p.cd_setor_atendimento
	FROM	proc_int_proc_prescr 	a,
		orcamento_paciente_proc p
	WHERE	a.nr_seq_proc_interno	 = p.nr_seq_proc_interno
	and	p.nr_sequencia_orcamento = nr_seq_orcamento_p
	and	coalesce(a.ie_situacao,'A')	= 'A'
	and	coalesce(a.ie_somente_agenda_cir,'N') = 'N'
	and		((coalesce(a.cd_estabelecimento::text, '') = '') or (cd_estabelecimento = cd_estabelecimento_w))
	and		((coalesce(a.cd_perfil::text, '') = '') or (a.cd_perfil = obter_perfil_ativo))
	and	((coalesce(a.cd_edicao_amb::text, '') = '') or ((a.cd_procedimento IS NOT NULL AND a.cd_procedimento::text <> '') and (obter_se_proc_edicao2(a.cd_procedimento, a.ie_origem_proced, a.cd_edicao_amb) = 'S')))
	and 	p.nr_sequencia = nr_sequencia_p
	and 	coalesce(a.cd_convenio,cd_convenio_w) = cd_convenio_w
	and 	((coalesce(a.cd_convenio_excluir::text, '') = '') or (a.cd_convenio_excluir <> cd_convenio_w))
	and	((coalesce(a.cd_categoria_convenio::text, '') = '') or (a.cd_categoria_convenio = cd_categoria_w))
	and	((a.cd_plano_convenio	= cd_plano_w) or (coalesce(a.cd_plano_convenio::text, '') = ''))
	and 	((a.ie_origem_proc_filtro = ie_origem_proc_filtro_w) or (coalesce(a.ie_origem_proc_filtro::text, '') = ''))
	and	(((coalesce(qt_idade_pac_w::text, '') = '') or (coalesce(a.qt_idade_min::text, '') = '' and coalesce(a.qt_idade_max::text, '') = '')) or
		((qt_idade_pac_w IS NOT NULL AND qt_idade_pac_w::text <> '') and (qt_idade_pac_w between coalesce(a.qt_idade_min,qt_idade_pac_w) and coalesce(a.qt_idade_max,qt_idade_pac_w))))
	and	Obter_conv_excluir_proc_assoc(a.nr_sequencia,cd_convenio_w) = 'S';


BEGIN

select	coalesce(max(cd_estabelecimento),1),
	max(nr_atendimento),
	max(ie_tipo_atendimento),
	max(cd_pessoa_fisica),
	max(cd_convenio),
	max(cd_categoria),
	max(cd_plano),
	max(dt_orcamento),
	max(cd_tipo_acomodacao)
into STRICT	cd_estabelecimento_w,
	nr_atendimento_w,
	ie_tipo_atendimento_w,
	cd_pessoa_fisica_w,
	cd_convenio_w,
	cd_categoria_w,
	cd_plano_w,
	dt_orcamento_w,
	cd_tipo_acomodacao_w
from	orcamento_paciente
where	nr_sequencia_orcamento	= nr_seq_orcamento_p;

ie_ConsisteRegraPlano_w		:= coalesce(obter_valor_param_usuario(106, 28, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w),'N');
ie_ConsisteGlosaParticular_w	:= coalesce(obter_valor_param_usuario(106, 44, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w),'N');
ie_consiste_edicao_w		:= coalesce(obter_valor_param_usuario(106, 36, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w),'N');
ie_calcula_orcamento_w		:= coalesce(obter_valor_param_usuario(106, 52, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w),'N');

if (coalesce(nr_atendimento_w,0) > 0) then

	select 	max(ie_tipo_atendimento),
		coalesce(max(nr_seq_classif_medico),0)
	into STRICT	ie_tipo_atendimento_w,
		nr_seq_classif_medico_w
	from 	atendimento_paciente
	where 	nr_atendimento = nr_atendimento_w;
	
end if;

select	obter_idade_pf(cd_pessoa_fisica_w, clock_timestamp(), 'A')
into STRICT	qt_idade_pac_w
;

if (coalesce(cd_convenio_w,0) = 0) and (coalesce(nr_atendimento_w,0) = 0) then
	
	select 	coalesce(max(obter_convenio_atendimento(nr_atendimento_w)),0),
		coalesce(max(obter_categoria_atendimento(nr_atendimento_w)),0)
	into STRICT	cd_convenio_w,
		cd_categoria_w
	;

end if;

select 	max(ie_tipo_convenio)
into STRICT	ie_tipo_convenio_w
from 	convenio
where 	cd_convenio = cd_convenio_w;

nr_seq_origem_w := coalesce((obter_dados_categ_conv(nr_atendimento_w,'OC'))::numeric ,0);

ie_origem_proc_filtro_w:= Obter_Origem_Proced_Cat(cd_estabelecimento_w, ie_tipo_atendimento_w, ie_tipo_convenio_w, cd_convenio_w, cd_categoria_w);

open C01;
loop
fetch C01 into
	nr_seq_proc_int_adic_w,
	qt_proc_adic_w,
	cd_proced_adic_w,
	ie_origem_proc_adic_w,
	ie_tipo_regra_w,
	ie_vinc_proc_princ_orc_w,
	ie_agenda_integrada_w,
	cd_setor_atendimento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	
	if (ie_tipo_regra_w = 'I') then
		SELECT * FROM obter_proc_tab_interno_conv(nr_seq_proc_int_adic_w, cd_estabelecimento_w, cd_convenio_w, cd_categoria_w, cd_plano_w, cd_setor_atendimento_w, cd_proced_adic_w, ie_origem_proc_adic_w, null, clock_timestamp(), cd_tipo_acomodacao_w, null, null, null, null, null, null, null) INTO STRICT cd_proced_adic_w, ie_origem_proc_adic_w;
	end if;	
				
	ie_autorizacao_w:= null;
	
	if (coalesce(ie_consiste_edicao_w,'N') <> 'N') and
		--(obter_se_proc_edicao(cd_estabelecimento_w, cd_convenio_w, cd_categoria_w, dt_orcamento_w, cd_proced_adic_w, ie_tipo_atendimento_w) = 'N') and
		(obter_se_proc_conv(cd_estabelecimento_w, cd_convenio_w, cd_categoria_w, dt_orcamento_w, cd_proced_adic_w, ie_origem_proc_adic_w,  nr_seq_proc_int_adic_w, ie_tipo_atendimento_w) = 'N') and (obter_se_pacote_convenio(cd_proced_adic_w, ie_origem_proc_adic_w, cd_convenio_w, cd_estabelecimento_w) = 'N') then		
		ie_autorizacao_w:= 'B'; --Nao esta na Edicao do convenio ou nao e um pacote do convenio
	end if;
	
	if (coalesce(ie_ConsisteGlosaParticular_w,'N') = 'S') and (coalesce(ie_autorizacao_w::text, '') = '') then
	
		ie_glosa_w	:= null;
		cd_conv_glosa_w	:= cd_convenio_w;
		cd_categ_glosa_w:= cd_categoria_w;
	
		SELECT * FROM Glosa_Procedimento(cd_estabelecimento_w, nr_atendimento_w, clock_timestamp(), cd_proced_adic_w, ie_origem_proc_adic_w, qt_proc_adic_w, 0, ie_tipo_atendimento_w, cd_setor_atendimento_w, 0, nr_seq_proc_int_adic_w, null, cd_plano_w, 0, 0, null, null, cd_conv_glosa_w, cd_categ_glosa_w, ds_retorno_numerico_w,  	--IE_TIPO_CONVENIO_P
				ds_retorno_texto_w,  	--IE_CLASSIF_CONVENIO_P          
				ds_retorno_texto_w,   	--CD_AUTORIZACAO_P              
				ds_retorno_numerico_w,  	--NR_SEQ_AUTORIZACAO_P          
				ds_retorno_numerico_w,  	--QT_AUTORIZADA_P               
				ds_retorno_texto_w,  	--CD_SENHA_P                     
				ds_retorno_texto_w,  	--NM_RESPONSAVEL_P               
				ie_glosa_w,  		--IE_GLOSA_P                     
				ds_retorno_numerico_w,  	--CD_SITUACAO_GLOSA_P           
				ds_retorno_numerico_w,  	--NR_SEQ_REGRA_PRECO_P          
				ds_retorno_numerico_w,  	--PR_GLOSA_P                    
				ds_retorno_numerico_w,  	--VL_GLOSA_P                    
				ds_retorno_numerico_w,  	--CD_MOTIVO_EXC_CONTA_P         
				ds_retorno_texto_w,  	--IE_PRECO_INFORMADO_P           
				ds_retorno_numerico_w,  	--VL_NEGOCIADO_P                
				ds_retorno_texto_w,  	--IE_AUTOR_PARTICULAR_P          
				ds_retorno_numerico_w,  	--CD_CONVENIO_GLOSA_P           
				ds_retorno_texto_w,  	--CD_CATEGORIA_GLOSA_P           
				ds_retorno_numerico_w,  	--NR_SEQUENCIA_P                 
				null, null, null, null, null, null, null, null, null, null, null, nr_seq_origem_w, nr_seq_classif_medico_w) INTO STRICT cd_conv_glosa_w, cd_categ_glosa_w, ds_retorno_numerico_w, 
				ds_retorno_texto_w, 
				ds_retorno_texto_w, 
				ds_retorno_numerico_w, 
				ds_retorno_numerico_w, 
				ds_retorno_texto_w, 
				ds_retorno_texto_w, 
				ie_glosa_w, 
				ds_retorno_numerico_w, 
				ds_retorno_numerico_w, 
				ds_retorno_numerico_w, 
				ds_retorno_numerico_w, 
				ds_retorno_numerico_w, 
				ds_retorno_texto_w, 
				ds_retorno_numerico_w, 
				ds_retorno_texto_w, 
				ds_retorno_numerico_w, 
				ds_retorno_texto_w, 
				ds_retorno_numerico_w;	
				
		if (ie_glosa_w IS NOT NULL AND ie_glosa_w::text <> '') and (ie_glosa_w in ('G', 'T', 'D', 'F')) then
			ie_autorizacao_w:= 'B'; --Possui regra de glosa e sera glosado
		end if;
		
	end if;
			
	if (coalesce(ie_ConsisteRegraPlano_w,'N') = 'S') and (cd_plano_w IS NOT NULL AND cd_plano_w::text <> '') and (coalesce(ie_autorizacao_w::text, '') = '') then
		
		ie_regra_w:= 0;		
		
		SELECT * FROM Consiste_Plano_Convenio(nr_atendimento_w, cd_convenio_w, cd_proced_adic_w, ie_origem_proc_adic_w, dt_orcamento_w, qt_proc_adic_w, ie_tipo_atendimento_w, cd_plano_w, null,  -- cd_autorizacao_p
					ds_erro_w, cd_setor_atendimento_w,  -- cd_setor_atendimento_p
					0,  --nr_seq_exame_p
					ie_regra_w, null,  --nr_seq_agenda_p
					nr_Seq_regra_w, nr_seq_proc_int_adic_w, cd_categoria_w, cd_estabelecimento_w, null,  --cd_setor_entrega_prescr_p
					null, cd_pessoa_fisica_w, ie_glosa_plano_w, nr_seq_regra_preco_w) INTO STRICT 
					ds_erro_w, 
					ie_regra_w, 
					nr_Seq_regra_w, ie_glosa_plano_w, nr_seq_regra_preco_w; --ie_vago2_p			
					
		if (coalesce(ie_regra_w,0) > 0) then
					
			ie_autorizacao_w := 'L';
			
			if (ie_regra_w in (1,2,5)) then
				
				ie_autorizacao_w := 'B';
				
			elsif (ie_regra_w in (3,6,7)) then				
				
				select 	coalesce(max(ie_resp_autor),'H')
				into STRICT	ie_resp_autor_w
				from 	regra_convenio_plano
				where 	nr_sequencia = nr_seq_regra_w;
				
				if (ie_resp_autor_w = 'H') then
					ie_autorizacao_w:= 'PAH'; --Pendente de autorizacao (Guia Hospital)
				elsif (ie_resp_autor_w = 'P') then
					ie_autorizacao_w:= 'PAP'; --Pendente de autorizacao (Guia Paciente)
				end if;
			
			end if;
			
		end if;		

	end if;
	
	qt_inativo_proc_int_w	:= 0;
	qt_inativo_proc_w	:= 0;
	
	if (coalesce(nr_seq_proc_int_adic_w,0) > 0) then
		select 	count(*)
		into STRICT	qt_inativo_proc_int_w
		from 	proc_interno
		where 	nr_sequencia = nr_seq_proc_int_adic_w
		and 	ie_situacao = 'I';
	end if;
		
	if (coalesce(cd_proced_adic_w,0) > 0) then
		select 	count(*)
		into STRICT	qt_inativo_proc_w
		from 	procedimento
		where 	cd_procedimento = cd_proced_adic_w
		and 	ie_origem_proced = ie_origem_proc_adic_w
		and 	ie_situacao = 'I';
	end if;
	
	if	((qt_inativo_proc_w + qt_inativo_proc_int_w) = 0) then	
	
		select	nextval('orcamento_paciente_proc_seq')
		into STRICT	nr_seq_proc_assoc_w
		;
	
		Insert	into orcamento_paciente_proc(
				nr_sequencia_orcamento,
				cd_procedimento, 
				ie_origem_proced, 
				qt_procedimento, 
				dt_atualizacao, 
				nm_usuario, 
				vl_procedimento, 
				vl_medico, 
				vl_anestesista, 
				vl_filme, 
				vl_auxiliares, 
				vl_custo_operacional, 
				vl_desconto, 
				cd_medico, 
				ie_procedimento_principal, 
				qt_dia_internacao, 
				ie_valor_informado, 
				nr_seq_exame, 
				nr_sequencia, 
				nr_seq_proc_interno, 
				ie_via_acesso, 
				nr_seq_regra_lanc, 
				vl_custo, 
				ie_pacote, 
				nr_seq_proc_princ, 
				ie_autorizacao,
				ie_exame_assoc,
				cd_setor_atendimento)
			values (nr_seq_orcamento_p,
				cd_proced_adic_w,
				ie_origem_proc_adic_w,
				qt_proc_adic_w,
				clock_timestamp(),
				nm_usuario_p,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				null, 
				null,
				null,
				'N',
				null, 
				nr_seq_proc_assoc_w,
				nr_seq_proc_int_adic_w,
				null,
				null,
				0, 'N',
				--decode(ie_vinc_proc_princ_orc_w, 'N', null, nr_sequencia_p),
				nr_sequencia_p,
				ie_autorizacao_w,
				CASE WHEN ie_agenda_integrada_w='S' THEN  'A'  ELSE 'S' END ,
				cd_setor_atendimento_w);
			
		CALL gerar_lanc_orc_automatico(nr_atendimento_w, nr_seq_orcamento_p, 34, nr_seq_proc_assoc_w, nm_usuario_p);
		
	end if;

	end;
end loop;
close C01;

commit;

if (ie_calcula_orcamento_w <> 'N') then
	CALL calcular_orcamento_paciente(nr_seq_orcamento_p, nm_usuario_p, cd_estabelecimento_w);
end if;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_proc_assoc_orcamento (nr_seq_orcamento_p bigint, nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
