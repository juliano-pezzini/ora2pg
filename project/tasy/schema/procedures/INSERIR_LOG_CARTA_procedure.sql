-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_log_carta ( nr_seq_carta_p bigint, ie_opcao_p text, cd_chave_p bigint, ds_texto_padrao_p text, nm_usuario_p text, nr_seq_result_p bigint default 0, nr_seq_result_item_p bigint default 0, ie_incluir_aut_p text default 'N', nr_seq_carta_conteudo_p INOUT bigint DEFAULT NULL, ie_tipo_regra_p text default 'N', ie_incluso_p text DEFAULT NULL, nr_seq_carta_mae_p bigint DEFAULT NULL, nr_conteudo_relevante_p bigint default null) AS $body$
DECLARE


const_alergias_reac_adv_w			constant varchar(2) := 'AL';
const_anamnese_w					constant varchar(2) := 'AN';
const_cirurgias_w					constant varchar(2) := 'CI';
const_comorbidades_w				constant varchar(2) := 'CO';
const_diagnostico_w 				constant varchar(2) := 'DI';
const_exames_nao_lab_w				constant varchar(3) := 'EI';
const_laboratorio_w					constant varchar(3) := 'EL';
const_epicrise_w                   	constant varchar(2) := 'EP';
const_medicamentos_cpoe_w			constant varchar(2) := 'MD';
const_medicamentos_em_uso_w        	constant varchar(2) := 'ME';
const_plano_medicamentos_w         	constant varchar(2) := 'MP';
const_notas_clinicas_w				varchar(3) := 'NC';
const_procedimentos_w				constant varchar(2) := 'PR';
const_medicamentos_KV_w				constant varchar(3) := 'RE';
const_diag_paciente_w				constant varchar(2) := 'DP';
const_pattern_nao_lab_w             constant varchar(60):= '<div data-wate-column="">((.|\n)*?)<\/div>';
const_pattern_nao_lab_begin_w       constant varchar(60):= '.*<div data-wate-column=""((.|\n)*?)>';
const_pattern_nao_lab_end_w         constant varchar(60):= '*<div data-wate-footer="| *<\/div>';
const_tempos_movimentos_w			constant varchar(3) := 'STM'; --	Tempos e Movimentos
const_tempos_cirurgicos_w			constant varchar(3) := 'STC'; --	Tempos Cirurgicos
const_participantes_w				constant varchar(3) := 'SP'; --	Participantes
const_tecnica_w						constant varchar(3) := 'ST'; --	Tecnica
const_equipamentos_w				constant varchar(3) := 'SE'; --	Equipamentos
const_dispositivos_w				constant varchar(3) := 'SDI'; --	Dispositivos
const_descricao_w					constant varchar(3) := 'SD'; --	Dispositivos
nr_seq_carta_conteudo_w				carta_conteudo.nr_sequencia%type;
nr_seq_cirurgia_w					cirurgia_descricao.nr_cirurgia%type;
ie_inserir_carta_w					varchar(1);
ie_inf_adic_w						varchar(1);
ie_possui_info_adic_diag_w			varchar(1);
ds_exames_w							varchar(255);
ds_texto_padrao_w                   text;
ds_texto_padrao_aux_w               text;
nr_carta_conteudo_relevante_w		carta_conteudo.nr_carta_conteudo_relevante%type;
qt_nota_clinicas_w                  bigint;
nr_sequencia_w                      bigint;
nr_notas_clinicas_w                 bigint;
nr_seq_secao_w						carta_medica_regra.nr_seq_secao%type;

C10 CURSOR FOR
	SELECT	nr_sequencia, dt_liberacao
	from	cirurgia_descricao
	where	nr_cirurgia = nr_seq_cirurgia_w
	and		(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and		coalesce(dt_inativacao::text, '') = ''
	and     (ds_cirurgia IS NOT NULL AND ds_cirurgia::text <> '')
	order by 1;

C11 CURSOR FOR
        SELECT distinct obter_codigo_usuario(pi.nm_usuario)     cd_usuario,
                        pi.nm_usuario                           nm_usuario,
                        pi.ds_imagem                            ds_imagem,
                        'A'                                     ie_situacao, 
                        ep.cd_pessoa_fisica                     cd_pessoa_fisica
        from PEP_IMAGEM pi, 
             carta_conteudo cc, 
             EVOLUCAO_PACIENTE ep 
        where pi.CD_EVOLUCAO = cd_chave_p  and (ep.DT_LIBERACAO IS NOT NULL AND ep.DT_LIBERACAO::text <> '')
        and pi.cd_evolucao = cc.cd_evolucao
        and pi.cd_evolucao = ep.cd_evolucao
        and ep.cd_evolucao = cc.cd_evolucao;

BEGIN

	select  max(nr_seq_secao)
    into STRICT    nr_seq_secao_w
    from    carta_medica_regra
    where   ie_secao||nr_seq_secao = ie_opcao_p;
	
	if (nr_seq_secao_w IS NOT NULL AND nr_seq_secao_w::text <> '') then
		const_notas_clinicas_w := 'NC'||nr_seq_secao_w;
	end if;

    select count(*) into STRICT nr_notas_clinicas_w  where ie_opcao_p like '%'||const_notas_clinicas_w||'%';

    select  count(*)    
    into STRICT    qt_nota_clinicas_w
    from    carta_medica_regra
    where   ie_secao||nr_seq_secao = ie_opcao_p;

	if (ie_opcao_p = 'DI') then
		if (nr_seq_result_p IS NOT NULL AND nr_seq_result_p::text <> '') then
			ie_inf_adic_w := 'S';
		else
			ie_inf_adic_w := 'N';
		end if;
	end if;


	select	coalesce(max('N'),'S'),
			max(obter_se_inf_adic_diag_carta((select max(x.nr_seq_modelo) from carta_medica x where nr_seq_carta_mae = nr_seq_carta))),
			max(nr_sequencia),
			max(nr_carta_conteudo_relevante)
	into STRICT	ie_inserir_carta_w,
			ie_possui_info_adic_diag_w,
			nr_seq_carta_conteudo_w,
			nr_carta_conteudo_relevante_w
	from	carta_conteudo
	where	((coalesce(nr_seq_cirurgia,nr_seq_alergia,cd_evolucao,nr_seq_medic_uso,nr_seq_comorbidade,nr_seq_procedimento, nr_seq_laudo,nr_seq_kv_item,NR_SEQ_MAT_CPOE,NR_SEQ_REC_CPOE,NR_SEQ_EVENTO_PAC_CIR,NR_SEQ_TEMPO_CIR,NR_SEQ_PARTIC_CIR,NR_SEQ_TEC_ANESTES_CIR,NR_SEQ_ANES_DESC_CIR,NR_SEQ_PAC_DISP_CIR, NR_SEQ_PLANO_VERSAO_MEDIC) = cd_chave_p
	and (ie_opcao_p <> const_laboratorio_w and ie_opcao_p <> const_diagnostico_w and ie_opcao_p <> const_diag_paciente_w and ie_opcao_p <> const_procedimentos_w))
	or 		(ie_opcao_p = const_diagnostico_w
	and 	((ie_inf_adic_w = 'N' and nr_seq_diag_doenca = cd_chave_p) or (ie_inf_adic_w = 'S' and nr_seq_diag_doenca = cd_chave_p and NR_SEQ_DIAG_DOENCA_INF = nr_seq_result_p)))
	or 		(ie_opcao_p = const_procedimentos_w
	and 	((ie_inf_adic_w = 'N' and nr_seq_proc_pac = cd_chave_p) or (ie_inf_adic_w = 'S' and nr_seq_proc_pac = cd_chave_p and nr_seq_proc_pac_inf = nr_seq_result_p)))
	or (ie_opcao_p = const_diag_paciente_w
	and 	ie_tipo_item = const_diag_paciente_w and nr_seq_diag_doenca = cd_chave_p)
	or (ie_opcao_p = const_laboratorio_w and nr_prescricao = nr_seq_result_p and nr_seq_prescricao = nr_seq_result_item_p))
	and		nr_seq_carta = nr_seq_carta_p
	and      coalesce(nr_carta_conteudo_relevante::text, '') = '';

	if (ie_inserir_carta_w = 'S'  and (nr_carta_conteudo_relevante_w IS NOT NULL AND nr_carta_conteudo_relevante_w::text <> '')) then
		if (ie_incluir_aut_p = 'S') then
			ie_inserir_carta_w := 'N';
			update 	CARTA_CONTEUDO
			set 	ie_incluso_carta = 'S'
			where 	nr_sequencia = nr_seq_carta_conteudo_w;
			commit;
		end if;

	end if;
	if (ie_inserir_carta_w = 'S') then
		select	nextval('carta_conteudo_seq')
		into STRICT	nr_seq_carta_conteudo_w
		;
        
		if (ie_opcao_p = const_exames_nao_lab_w) then    
			insert into CARTA_CONTEUDO(
					nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					nr_seq_carta,
					nr_seq_diag_doenca,
					cd_evolucao,
					nr_seq_medic_uso,
					nr_seq_comorbidade,
					nr_seq_procedimento,
					ds_texto,
					ie_tipo_item,
					ie_incluir_aut,
					nr_prescricao,
					nr_seq_prescricao,
					nr_seq_resultado_exame,
					nr_seq_resultado_exame_item,
					nr_seq_alergia,
					nr_seq_cirurgia,
					nr_seq_proc_pac,
					nr_seq_laudo,
					NR_SEQ_MAT_CPOE,
					NR_SEQ_REC_CPOE,
					IE_TIPO_EPICRISE,
					IE_INCLUSO_CARTA,
					nr_seq_carta_mae,
					NR_SEQ_DIAG_DOENCA_INF,
					nr_carta_conteudo_relevante,
					ie_tipo_nota_clinica)
			SELECT	nr_seq_carta_conteudo_w,
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_carta_p,
					case when ie_opcao_p = const_diagnostico_w  then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end,
					case when ((ie_opcao_p = const_epicrise_w and ie_tipo_regra_p = 'C') or ie_opcao_p = const_anamnese_w or (nr_notas_clinicas_w > 0 and qt_nota_clinicas_w > 0))  then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end,
					case when(ie_opcao_p = const_medicamentos_em_uso_w or ie_opcao_p = const_plano_medicamentos_w)  then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end,
					case when ie_opcao_p = const_comorbidades_w  then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end,
					case when(ie_opcao_p = 'NA') then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end,
					to_lob(ds_laudo),
					ie_opcao_p,
					ie_incluir_aut_p,
					case when ie_opcao_p = const_laboratorio_w  then  CASE WHEN nr_seq_result_p=0 THEN null  ELSE nr_seq_result_p END  else null end,--NR_PRESCRICAO
					case when ie_opcao_p = const_laboratorio_w  then  CASE WHEN nr_seq_result_item_p=0 THEN null  ELSE nr_seq_result_item_p END  else null end,--NR_SEQ_PRESCRICAO
					null,--case when ie_opcao_p = const_laboratorio_w  then  decode(nr_seq_result_p,0,null,nr_seq_result_p) else null end,
					null,--case when ie_opcao_p = const_laboratorio_w  then  decode(nr_seq_result_item_p,0,null,nr_seq_result_item_p) else null end,
					case when ie_opcao_p = const_alergias_reac_adv_w  then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end,
					case when ie_opcao_p = const_cirurgias_w  then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end,
					case when(ie_opcao_p = const_procedimentos_w)  then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end,
					case when(ie_opcao_p = const_exames_nao_lab_w) then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end,
					case when(ie_opcao_p = const_epicrise_w and ie_tipo_regra_p = 'M')  then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end,
					case when(ie_opcao_p = const_epicrise_w and ie_tipo_regra_p = 'R') then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end,
					case when(ie_opcao_p = const_epicrise_w) then  ie_tipo_regra_p else null end,
					ie_incluso_p,
					nr_seq_carta_mae_p,
					case when ie_opcao_p = const_diagnostico_w  then  CASE WHEN nr_seq_result_p=0 THEN null  ELSE nr_seq_result_p END  else null end,
					nr_conteudo_relevante_p,
					ie_tipo_regra_p
			from	laudo_paciente_v
			where	nr_sequencia = cd_chave_p;

			begin
				select	ds_texto
				into STRICT	ds_texto_padrao_w
				from	carta_conteudo
				where	nr_sequencia = nr_seq_carta_conteudo_w;
				select 	substr(ds_texto_padrao_w, DBMS_LOB.position('<div data-wate-footer=' in ds_texto_padrao_w) - DBMS_LOB.position('<div data-wate-column=' in ds_texto_padrao_w) + 23, DBMS_LOB.position('<div data-wate-column=' in ds_texto_padrao_w))
				into STRICT	ds_texto_padrao_w
				;
			EXCEPTION
			when others then
				ds_texto_padrao_w := '';
			end;
			
			ds_texto_padrao_w := REGEXP_REPLACE(ds_texto_padrao_w, const_pattern_nao_lab_begin_w, '');
			ds_texto_padrao_w := REGEXP_REPLACE(ds_texto_padrao_w, const_pattern_nao_lab_end_w  , '');

			if (coalesce(ds_texto_padrao_w, '') = '') then
				ds_texto_padrao_w := ds_texto_padrao_p;
			end if;

			select 	max('<b>' || substr(Obter_Desc_Prescr_Proc_exam(c.cd_procedimento,c.ie_origem_proced, c.nr_seq_proc_interno, c.nr_seq_exame),1,245) || '</b>')
			into STRICT	ds_exames_w
			from	laudo_paciente_v x,
					procedimento_paciente c,
					procedimento b
			where	x.nr_seq_proc = c.nr_sequencia
			and    	c.cd_procedimento = b.cd_procedimento
			and    	c.ie_origem_proced = b.ie_origem_proced
			and		x.nr_sequencia = cd_chave_p;

			ds_texto_padrao_w := ds_exames_w || ' ' || ds_texto_padrao_w;

			update	carta_conteudo
			set		ds_texto = ds_texto_padrao_w
			where	nr_sequencia = nr_seq_carta_conteudo_w;


		elsif ((ie_opcao_p = const_epicrise_w and (ie_tipo_regra_p = 'C' or coalesce(ie_tipo_regra_p::text, '') = '')) or
			ie_opcao_p = const_anamnese_w or (nr_notas_clinicas_w > 0 and qt_nota_clinicas_w > 0)) then
            
          	insert into CARTA_CONTEUDO(
					nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					nr_seq_carta,
					nr_seq_diag_doenca,
					cd_evolucao,
					nr_seq_medic_uso,
					nr_seq_comorbidade,
					nr_seq_procedimento,
					ds_texto,
					ie_tipo_item,
					ie_incluir_aut,
					nr_prescricao,
					nr_seq_prescricao,
					nr_seq_resultado_exame,
					nr_seq_resultado_exame_item,
					nr_seq_alergia,
					nr_seq_cirurgia,
					nr_seq_proc_pac,
					nr_seq_laudo,
					NR_SEQ_MAT_CPOE,
					NR_SEQ_REC_CPOE,
					IE_TIPO_EPICRISE,
					IE_INCLUSO_CARTA,
					nr_seq_carta_mae,
					NR_SEQ_DIAG_DOENCA_INF,
					nr_carta_conteudo_relevante,
					ie_tipo_nota_clinica)
			SELECT	nr_seq_carta_conteudo_w,
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_carta_p,
					case when ie_opcao_p = const_diagnostico_w  then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end,
					case when ((ie_opcao_p = const_epicrise_w and (ie_tipo_regra_p = 'C' or coalesce(ie_tipo_regra_p::text, '') = '')) or ie_opcao_p = const_anamnese_w or (nr_notas_clinicas_w > 0 and qt_nota_clinicas_w > 0))  then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end,
					case when(ie_opcao_p = const_medicamentos_em_uso_w or ie_opcao_p = const_plano_medicamentos_w)  then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end,
					case when ie_opcao_p = const_comorbidades_w  then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end,
					case when(ie_opcao_p = 'NA') then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end,
					to_lob(ds_evolucao),
				    ie_opcao_p,
					ie_incluir_aut_p,
					case when ie_opcao_p = const_laboratorio_w  then  CASE WHEN nr_seq_result_p=0 THEN null  ELSE nr_seq_result_p END  else null end,--NR_PRESCRICAO
					case when ie_opcao_p = const_laboratorio_w  then  CASE WHEN nr_seq_result_item_p=0 THEN null  ELSE nr_seq_result_item_p END  else null end,--NR_SEQ_PRESCRICAO
					null,--case when ie_opcao_p = const_laboratorio_w  then  decode(nr_seq_result_p,0,null,nr_seq_result_p) else null end,
					null,--case when ie_opcao_p = const_laboratorio_w  then  decode(nr_seq_result_item_p,0,null,nr_seq_result_item_p) else null end,
					case when ie_opcao_p = const_alergias_reac_adv_w  then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end,
					case when ie_opcao_p = const_cirurgias_w  then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end,
					case when(ie_opcao_p = const_procedimentos_w)  then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end,
					case when(ie_opcao_p = const_exames_nao_lab_w) then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end,
					case when(ie_opcao_p = const_epicrise_w and ie_tipo_regra_p = 'M')  then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end,
					case when(ie_opcao_p = const_epicrise_w and ie_tipo_regra_p = 'R') then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end,
					case when(ie_opcao_p = const_epicrise_w) then  ie_tipo_regra_p else null end,
					ie_incluso_p,
					nr_seq_carta_mae_p,
					case when ie_opcao_p = const_diagnostico_w  then  CASE WHEN nr_seq_result_p=0 THEN null  ELSE nr_seq_result_p END  else null end,
					nr_conteudo_relevante_p,
					ie_tipo_regra_p
			from	evolucao_paciente
			where	cd_evolucao = cd_chave_p;
            select nextval('carta_medica_anexo_seq') 
            into STRICT   nr_sequencia_w 
;
            
            for c11_w in C11 loop
                  begin
                    insert into carta_medica_anexo(
                        nr_sequencia,
                        cd_estabelecimento,
                        cd_profissional, 
                        dt_atualizacao,
                        nm_usuario,
                        dt_registro, 
                        ds_arquivo, 
                        ie_situacao, 
                        cd_pessoa_fisica,
                        nr_seq_carta_mae, 
                        ds_titulo)
                    values ( 
                        nr_sequencia_w,
                        wheb_usuario_pck.get_cd_estabelecimento,
                        c11_w.cd_usuario,
                        clock_timestamp(),
                        c11_w.nm_usuario,
                        clock_timestamp(),
                        c11_w.ds_imagem,
                        c11_w.ie_situacao,
                        c11_w.cd_pessoa_fisica,
                        nr_seq_carta_mae_p,
                        obter_desc_expressao_idioma(283478, null, wheb_usuario_pck.get_nr_seq_idioma)||'_'||nr_seq_carta_conteudo_w);

                      select nextval('carta_conteudo_seq') 
                      into STRICT   nr_seq_carta_conteudo_w 
;

                        insert into CARTA_CONTEUDO(
                        nr_sequencia,
                        dt_atualizacao,
                        nm_usuario,
                        nr_seq_carta,                        
                        ds_texto,
                        IE_TIPO_ITEM,
                        ie_incluir_aut)
                SELECT	nr_seq_carta_conteudo_w,
                        clock_timestamp(),
                        nm_usuario_p,
                        nr_seq_carta_p,
                        obter_desc_expressao_idioma(283478, null, wheb_usuario_pck.get_nr_seq_idioma)||'_'||nr_seq_carta_conteudo_w,
			ie_opcao_p,
             		ie_incluir_aut_p                                     
                from	evolucao_paciente
                where	cd_evolucao = cd_chave_p;
         	  end;
			end loop;
       	elsif (ie_opcao_p = const_medicamentos_cpoe_w) then


			insert into CARTA_CONTEUDO(
					nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					nr_seq_carta,
					ds_texto,
					nr_seq_mat_cpoe,
					ie_tipo_item,
					ie_incluir_aut,
					IE_INCLUSO_CARTA,
					nr_seq_carta_mae,
					nr_carta_conteudo_relevante,
					ie_tipo_nota_clinica)
			values (nr_seq_carta_conteudo_w,
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_carta_p,
					ds_texto_padrao_p,
					cd_chave_p,
					ie_opcao_p,
					ie_incluir_aut_p,
					ie_incluso_p,
					nr_seq_carta_mae_p,
					nr_conteudo_relevante_p,


					ie_tipo_regra_p);

		elsif (const_descricao_w = ie_opcao_p) then
			insert into CARTA_CONTEUDO(
					nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					nr_seq_carta,
					nr_seq_diag_doenca,
					cd_evolucao,
					nr_seq_medic_uso,
					nr_seq_comorbidade,
					nr_seq_procedimento,
					ds_texto,
					ie_tipo_item,
					ie_incluir_aut,
					nr_prescricao,
					nr_seq_prescricao,
					nr_seq_resultado_exame,
					nr_seq_resultado_exame_item,
					nr_seq_alergia,
					nr_seq_cirurgia,
					nr_seq_proc_pac,
					nr_seq_laudo,
					NR_SEQ_MAT_CPOE,
					NR_SEQ_REC_CPOE,
					IE_TIPO_EPICRISE,
					IE_INCLUSO_CARTA,
					nr_seq_carta_mae,
					NR_SEQ_DIAG_DOENCA_INF,
					nr_carta_conteudo_relevante,
					ie_tipo_nota_clinica)
			SELECT	nr_seq_carta_conteudo_w,
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_carta_p,
					case when ie_opcao_p = const_diagnostico_w  then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end,
					case when ((ie_opcao_p = const_epicrise_w and (ie_tipo_regra_p = 'C' or coalesce(ie_tipo_regra_p::text, '') = '')) or ie_opcao_p = const_anamnese_w or (nr_notas_clinicas_w > 0 and qt_nota_clinicas_w > 0))  then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end,
					case when(ie_opcao_p = const_medicamentos_em_uso_w or ie_opcao_p = const_plano_medicamentos_w)  then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end,
					case when ie_opcao_p = const_comorbidades_w  then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end,
					case when(ie_opcao_p = 'NA') then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end,
					to_lob(DS_ANESTESIA),
					ie_opcao_p,
					ie_incluir_aut_p,
					case when ie_opcao_p = const_laboratorio_w  then  CASE WHEN nr_seq_result_p=0 THEN null  ELSE nr_seq_result_p END  else null end,--NR_PRESCRICAO
					case when ie_opcao_p = const_laboratorio_w  then  CASE WHEN nr_seq_result_item_p=0 THEN null  ELSE nr_seq_result_item_p END  else null end,--NR_SEQ_PRESCRICAO
					null,--case when ie_opcao_p = const_laboratorio_w  then  decode(nr_seq_result_p,0,null,nr_seq_result_p) else null end,
					null,--case when ie_opcao_p = const_laboratorio_w  then  decode(nr_seq_result_item_p,0,null,nr_seq_result_item_p) else null end,
					case when ie_opcao_p = const_alergias_reac_adv_w  then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end,
					case when ie_opcao_p = const_cirurgias_w  then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end,
					case when(ie_opcao_p = const_procedimentos_w)  then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end,
					case when(ie_opcao_p = const_exames_nao_lab_w) then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end,
					case when(ie_opcao_p = const_epicrise_w and ie_tipo_regra_p = 'M')  then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end,
					case when(ie_opcao_p = const_epicrise_w and ie_tipo_regra_p = 'R') then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end,
					case when(ie_opcao_p = const_epicrise_w) then  ie_tipo_regra_p else null end,
					ie_incluso_p,
					nr_seq_carta_mae_p,
					case when ie_opcao_p = const_diagnostico_w  then  CASE WHEN nr_seq_result_p=0 THEN null  ELSE nr_seq_result_p END  else null end,
					nr_conteudo_relevante_p,
					ie_tipo_regra_p
			from	anestesia_descricao
			where	nr_sequencia = cd_chave_p;
		else
			if (ie_opcao_p = const_cirurgias_w) then
				nr_seq_cirurgia_w := cd_chave_p;
				ds_texto_padrao_aux_w := '';
				for c10_w in C10 loop
					begin
						pls_convert_long_(	'CIRURGIA_DESCRICAO',
								'DS_CIRURGIA',
								'WHERE NR_SEQUENCIA = :NR_SEQUENCIA',
								'NR_SEQUENCIA='|| c10_w.nr_sequencia,
								ds_texto_padrao_w);


						ds_texto_padrao_aux_w := ds_texto_padrao_aux_w || ' <p><p> ' || obter_texto_tasy(1045020, null) || ': ' || pkg_date_formaters.to_varchar(c10_w.dt_liberacao, 'timestamp', wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario) || '<p>' ||ds_texto_padrao_w || ' <p> ';
					end;
				end loop;
				ds_texto_padrao_w := ds_texto_padrao_p || ds_texto_padrao_aux_w || ' <p> ';
			else
				ds_texto_padrao_w := ds_texto_padrao_p;
			end if;
			if (ie_opcao_p = const_diagnostico_w and ie_possui_info_adic_diag_w = 'N') then
				select	CASE WHEN position('<b>' in ds_texto_padrao_w)=0 THEN ds_texto_padrao_w  ELSE substr(ds_texto_padrao_w,(position('<b>' in ds_texto_padrao_w) + 3) ,(position('</span' in ds_texto_padrao_w) - position('<b>' in ds_texto_padrao_w) - 3)) END  ds_texto_normal
				into STRICT	ds_texto_padrao_w
				;

			end if;
			insert into CARTA_CONTEUDO(
						nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						nr_seq_carta,
						nr_seq_diag_doenca,
						cd_evolucao,
						nr_seq_medic_uso,
						nr_seq_comorbidade,
						nr_seq_procedimento,
						ds_texto,
						ie_tipo_item,
						ie_incluir_aut,
						nr_prescricao,
						nr_seq_prescricao,
						nr_seq_resultado_exame,
						nr_seq_resultado_exame_item,
						nr_seq_alergia,
						nr_seq_cirurgia,
						nr_seq_proc_pac,
						nr_seq_laudo,
						nr_seq_kv_item,
						NR_SEQ_MAT_CPOE,
						NR_SEQ_REC_CPOE,
						IE_TIPO_EPICRISE,
						IE_INCLUSO_CARTA,
						nr_seq_carta_mae,
						NR_SEQ_DIAG_DOENCA_INF,
						nr_seq_proc_pac_inf,
						nr_carta_conteudo_relevante,
						ie_tipo_nota_clinica,
						NR_SEQ_PLANO_VERSAO_MEDIC)
			values(		nr_seq_carta_conteudo_w,
						clock_timestamp(),
						nm_usuario_p,
						nr_seq_carta_p,
						case when(ie_opcao_p = const_diagnostico_w or ie_opcao_p = const_diag_paciente_w)  then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end,
						case when ((ie_opcao_p = const_epicrise_w and ie_tipo_regra_p = 'C') or ie_opcao_p = const_anamnese_w or (nr_notas_clinicas_w > 0 and qt_nota_clinicas_w > 0))  then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end,
						case when(ie_opcao_p = const_medicamentos_em_uso_w)  then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end,
						case when ie_opcao_p = const_comorbidades_w  then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end,
						case when(ie_opcao_p = 'NA' or ie_opcao_p = const_laboratorio_w) then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end,
						ds_texto_padrao_w,
						ie_opcao_p,
						ie_incluir_aut_p,
						case when ie_opcao_p = const_laboratorio_w  then  CASE WHEN nr_seq_result_p=0 THEN null  ELSE nr_seq_result_p END  else null end,--NR_PRESCRICAO
						case when ie_opcao_p = const_laboratorio_w  then  CASE WHEN nr_seq_result_item_p=0 THEN null  ELSE nr_seq_result_item_p END  else null end,--NR_SEQ_PRESCRICAO
						null,--case when ie_opcao_p = const_laboratorio_w  then  decode(nr_seq_result_p,0,null,nr_seq_result_p) else null end,
						null,--case when ie_opcao_p = const_laboratorio_w  then  decode(nr_seq_result_item_p,0,null,nr_seq_result_item_p) else null end,
						case when ie_opcao_p = const_alergias_reac_adv_w  then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end,
						case when ie_opcao_p = const_cirurgias_w  then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end,
						case when(ie_opcao_p = const_procedimentos_w)  then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end,
						case when(ie_opcao_p = const_exames_nao_lab_w) then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end,
						case when(ie_opcao_p = const_medicamentos_KV_w) then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end,
						case when(ie_opcao_p = const_epicrise_w and ie_tipo_regra_p = 'M')  then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end,
						case when(ie_opcao_p = const_epicrise_w and ie_tipo_regra_p = 'R') then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end,
						case when(ie_opcao_p = const_epicrise_w) then  ie_tipo_regra_p else null end,
						ie_incluso_p,
						nr_seq_carta_mae_p,
						case when ie_opcao_p = const_diagnostico_w  then  CASE WHEN nr_seq_result_p=0 THEN null  ELSE nr_seq_result_p END  else null end,
						case when ie_opcao_p = const_procedimentos_w then CASE WHEN nr_seq_result_p=0 THEN null  ELSE nr_seq_result_p END  else null end,
						nr_conteudo_relevante_p,
						ie_tipo_regra_p,
						case when(ie_opcao_p = const_plano_medicamentos_w)  then  CASE WHEN cd_chave_p=0 THEN null  ELSE cd_chave_p END  else null end);
		end if;
		nr_seq_carta_conteudo_p := nr_seq_carta_conteudo_w;
		commit;
	end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_log_carta ( nr_seq_carta_p bigint, ie_opcao_p text, cd_chave_p bigint, ds_texto_padrao_p text, nm_usuario_p text, nr_seq_result_p bigint default 0, nr_seq_result_item_p bigint default 0, ie_incluir_aut_p text default 'N', nr_seq_carta_conteudo_p INOUT bigint DEFAULT NULL, ie_tipo_regra_p text default 'N', ie_incluso_p text DEFAULT NULL, nr_seq_carta_mae_p bigint DEFAULT NULL, nr_conteudo_relevante_p bigint default null) FROM PUBLIC;
