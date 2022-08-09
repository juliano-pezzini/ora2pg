-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE get_text_conteudo ( ie_tipo_conteudo_p text, ds_string_text_p INOUT text, ie_param_aux_p text default null) AS $body$
DECLARE


const_alergias_reac_adv_w			constant varchar(2) := 'AL';
const_anamnese_w					constant varchar(2) := 'AN';
const_cirurgias_w					constant varchar(2) := 'CI';
const_comorbidades_w				constant varchar(2) := 'CO';
const_diagnostico_w 				constant varchar(2) := 'DI';
const_laboratorio_w					constant varchar(3) := 'EL';
const_exames_nao_lab_w				constant varchar(3) := 'EI';
const_epicrise_w                   	constant varchar(2) := 'EP';
const_medicamentos_em_uso_w        	constant varchar(2) := 'ME';
const_plano_medicamentos_w         	constant varchar(2) := 'MP';
const_notas_clinicas_w				constant varchar(2) := 'NC';
const_procedimentos_w				constant varchar(2) := 'PR';
const_diag_paciente_w				constant varchar(3) := 'DP';
const_tempos_movimentos_w			constant varchar(3) := 'STM'; --	Tempos e Movimentos
const_tempos_cirurgicos_w			constant varchar(3) := 'STC'; --	Tempos Cirurgicos
const_participantes_w				constant varchar(3) := 'SP'; --	Participantes
const_tecnica_w						constant varchar(3) := 'ST'; --	Tecnica
const_equipamentos_w				constant varchar(3) := 'SE'; --	Equipamentos
const_dispositivos_w				constant varchar(3) := 'SDI'; --	Dispositivos
BEGIN

	if (ie_tipo_conteudo_p = const_diagnostico_w) then
        ds_string_text_p :=  chr(39)||'<span id="' ||chr(39)|| '||nr_seq_interno||'|| chr(39)|| '"> '||chr(39)||' ||cd_doenca||'|| chr(39)|| ' - ' ||chr(39)|| ' || substr(obter_desc_cid(cd_doenca),1,200) ||'|| chr(39)|| ' - ' ||chr(39)|| ' || pkg_date_formaters.to_varchar(dt_atualizacao, ''short'', wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario) ||'|| chr(39)|| ' - ' ||chr(39)|| ' || obter_valor_dominio(13,ie_tipo_diagnostico) ||'|| chr(39)|| ' - ' ||chr(39)|| ' || obter_valor_dominio(1758,IE_TIPO_DOENCA) ||'|| chr(39)|| ' - ' ||chr(39)|| ' || obter_valor_dominio(58,IE_CLASSIFICACAO_DOENCA) ||'|| chr(39)||'</span>'|| chr(39)||' ds_cid_doenca,';
	elsif (ie_tipo_conteudo_p = const_comorbidades_w) then
		ds_string_text_p 	:=  chr(39) || ' <ul id=\"LISTA_COMORBIDADES\">   <li data-tasy-advancedtexteditor-section=\"1\" class=\"paragraph\" style=\"margin-left: -0.4095px;\" data-tasy-advancedtexteditor-page=\"1\"> ' || chr(39)
								||  '||			wheb_mensagem_pck.get_texto(877982)||'||chr(39)|| ': ' ||chr(39)||'||pkg_date_formaters.to_varchar(dt_registro, ''shortDate'', wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario) ||' || chr(39)|| ' - ' ||chr(39)||' ||DECODE(cd_doenca, null, decode(ds_doenca, null, wheb_mensagem_pck.get_texto(880553), ds_doenca), cd_doenca || ' || chr(39)|| ' - ' ||chr(39)|| ' || obter_desc_cid(cd_doenca)) ||  '
								||	chr(39) || ' </li>   </ul> ' || chr(39) || ',';
	elsif (ie_tipo_conteudo_p = const_medicamentos_em_uso_w) then
		ds_string_text_p	:=	chr(39) || 	'	<tr id=' || chr(39) || ' || cd_material || ' || chr(39) || ' data-width="641px" data-height="20px">  ' ||
											'		<td id="CD_MATERIAL" data-width="320px" data-height="20px" style="max-width: 321px; overflow: overlay; display: none;"> ' || chr(39) ||
											'			|| cd_material || ' ||chr(39)|| ' - ' ||chr(39) || '||' ||
								chr(39) ||	'		</td > ';
								if (ie_param_aux_p = 'S') then
									ds_string_text_p := 	ds_string_text_p ||		'		<td id="DS_MATERIAL" data-width="320px" data-height="20px" style="max-width: 321px; overflow: overlay; border: 1px solid #fff !important;"> ' || chr(39) ||
												'			|| substr(nvl(substr(obter_desc_material(cd_material),1,50),wheb_mensagem_pck.get_texto(880553)),1,255) || ' ||
									chr(39) ||	'		</td > ';
								else
									ds_string_text_p := 	ds_string_text_p ||		'		<td id="DS_MATERIAL" data-width="320px" data-height="20px" style="max-width: 321px; overflow: overlay; border: 1px solid #fff !important;"> ' || chr(39) ||
												'			|| substr(nvl(decode(cd_material,null,ds_medicamento,substr(obter_desc_material(cd_material),1,50)),wheb_mensagem_pck.get_texto(880553)),1,255) || ' ||
									chr(39) ||	'		</td > ';
								end if;
								
								ds_string_text_p := 	ds_string_text_p ||					'		<td id="EXAMES" data-width="320px" data-height="20px" style="max-width: 321px; overflow: overlay; border: 1px solid #fff !important;"> ' || chr(39) ||
											'			|| substr(obter_desc_via(ie_via_aplicacao),1,255) || ' ||
								chr(39) ||	'		</td > ' ||
											'		<td id="EXAMES" data-width="320px" data-height="20px" style="max-width: 321px; overflow: overlay; border: 1px solid #fff !important;"> ' || chr(39) ||
											'			|| qt_dose || ' ||
								chr(39) ||	'		</td > ';
								if (ie_param_aux_p = 'S') then
									ds_string_text_p := 	ds_string_text_p ||		
												'		<td id="EXAMES" data-width="320px" data-height="20px" style="max-width: 321px; overflow: overlay; border: 1px solid #fff !important;"> ' || chr(39) ||
												'			|| substr(obter_desc_unid_med(cd_unidade_medida),1,150) || ' ||
									chr(39) ||	'		</td > ';
								else
									ds_string_text_p := 	ds_string_text_p ||		
												'		<td id="EXAMES" data-width="320px" data-height="20px" style="max-width: 321px; overflow: overlay; border: 1px solid #fff !important;"> ' || chr(39) ||
												'			|| substr(obter_desc_unid_med(cd_unid_med),1,150) || ' ||
									chr(39) ||	'		</td > ';
								end if;
								ds_string_text_p := 	ds_string_text_p ||
											'		<td id="EXAMES" data-width="320px" data-height="20px" style="max-width: 321px; overflow: overlay; border: 1px solid #fff !important;"> ' || chr(39) ||
											'			|| substr(obter_desc_intervalo_prescr(cd_intervalo),1,60) || ' ||
								chr(39) ||	'		</td > ' ||
											'	</tr> ' || chr(39);
	elsif (ie_tipo_conteudo_p = const_plano_medicamentos_w) then
		ds_string_text_p :=  '			wheb_mensagem_pck.get_texto(939364)||'||chr(39)|| ': ' ||chr(39)||'||substr(nvl(decode(cd_material,null,ds_medicamento,substr(obter_desc_material(cd_material),1,50)),wheb_mensagem_pck.get_texto(880553)),1,255)|| '||
								chr(39)|| ' - ' ||chr(39)||'||wheb_mensagem_pck.get_texto(940684)||'||chr(39)|| ': ' ||chr(39)||'||nvl(QT_DOSE_MANHA,0)|| '||
								chr(39)|| '-' ||chr(39)||'||nvl(QT_DOSE_ALMOCO,0)|| '||
								chr(39)|| '-' ||chr(39)||'||nvl(QT_DOSE_TARDE,0)|| '||
								chr(39)|| '-' ||chr(39)||'||nvl(QT_DOSE_NOITE,0)|| '||
								chr(39)|| ' - ' ||chr(39)||'||wheb_mensagem_pck.get_texto(940694)||'||chr(39)|| ': ' ||chr(39)||'||decode(IE_TIPO_MEDICAMENTO, ''S'', (substr(obter_desc_unid_med(CD_UNIDADE_MEDIDA),1,150)), DS_UNID_MED_DESC), ';
	elsif (ie_tipo_conteudo_p = const_alergias_reac_adv_w) then
		ds_string_text_p :=  '			DECODE(nvl(nr_seq_dcb, nvl(cd_material, nvl(cd_classe_mat, nvl(nr_seq_ficha_tecnica,nr_seq_familia)))), NULL, NULL,wheb_mensagem_pck.get_texto(939364)||'||chr(39)|| ': ' ||chr(39)||
							 '			||substr(nvl(nvl(nvl(nvl(nvl(obter_desc_dcb(nr_seq_dcb),substr(obter_desc_material(cd_material),1,254)), substr(obter_desc_classe_mat(cd_classe_mat),1,255)),obter_desc_ficha_tecnica(nr_seq_ficha_tecnica)),obter_desc_familia_mat(nr_seq_familia)),wheb_mensagem_pck.get_texto(880553)),1,255) ||'||chr(39)|| ' - ' ||chr(39)|| ')'||
							 '			||DECODE(obter_desc_alergeno(nr_seq_tipo), NULL, NULL, wheb_mensagem_pck.get_texto(1025632)||'||chr(39)|| ': ' ||chr(39)|| 
							 '			||substr(nvl(obter_desc_alergeno(nr_seq_tipo),wheb_mensagem_pck.get_texto(880553)),1,80)||'||chr(39)|| ' - ' ||chr(39)|| ')'||
							 '			||DECODE(obter_valor_dominio(1337,ie_abordagem), NULL, NULL, wheb_mensagem_pck.get_texto(1025633)||'||chr(39)|| ': ' ||chr(39)|| 
							 '			||substr(nvl(obter_valor_dominio(1337,ie_abordagem),wheb_mensagem_pck.get_texto(880553)),1,60)||'||chr(39)|| ' - ' ||chr(39)|| ')'||
							 '			||DECODE(ie_nega_alergias,''N'', NULL, wheb_mensagem_pck.get_texto(1025635)||'||chr(39)|| ': ' ||chr(39)|| 
							 '			||decode(ie_nega_alergias,''N'',wheb_mensagem_pck.get_texto(1025636),wheb_mensagem_pck.get_texto(1025637))||'||chr(39)|| ' - ' ||chr(39)|| ')'||
							 '			||DECODE(cd_doenca, NULL, NULL, wheb_mensagem_pck.get_texto(1043957)||'||chr(39)|| ': ' ||chr(39)|| 
							 '			||cd_doenca||'||chr(39)|| ' - ' ||chr(39)||'||substr(obter_desc_cid(cd_doenca),1,200))';
	elsif (ie_tipo_conteudo_p = const_cirurgias_w) then
		ds_string_text_p := '			obter_desc_expressao(885796) || '||chr(39)||' ' ||chr(39)||'||nvl(nr_seq_proc_interno, cd_procedimento_princ)||'||chr(39)||' - ' ||chr(39)||'|| substr(obter_desc_proc_interno(nr_seq_proc_interno),1,150)|| '||
							'			obter_desc_expressao(347323) || '||chr(39)||' ' ||chr(39)||'||substr(nvl(obter_valor_dominio(1372,ie_lado),wheb_mensagem_pck.get_texto(880553)),1,150)|| '||
							'			'||chr(39)||' - ' ||chr(39)||'|| obter_desc_expressao(293107) || '||chr(39)||' ' ||chr(39)||'|| substr(obter_status_cirurgia(ie_status_cirurgia),1,200)|| '||
							'			'||chr(39)||' - ' ||chr(39)||'|| obter_desc_expressao(293107) || '||chr(39)||': ' ||chr(39)||'||substr(obter_nome_medico(cd_medico_cirurgiao,''N''),1,200)|| '||
							'			'||chr(39)||' - ' ||chr(39)||'|| obter_desc_expressao(289016) || '||chr(39)||': ' ||chr(39)||'||nr_min_duracao_prev ';
	elsif (ie_tipo_conteudo_p = const_procedimentos_w) then
		ds_string_text_p := '			(select max(x.cd_procedimento_loc) from procedimento x where x.cd_procedimento = a.cd_procedimento and x.ie_origem_proced = a.ie_origem_proced) ||'|| chr(39)|| ' - ' ||chr(39)||'|| substr(nvl(obter_desc_curta_proc_rotina(nr_seq_proc_interno,cd_procedimento,ie_origem_proced),obter_desc_procedimento(cd_procedimento, ie_origem_proced)),1,150) || '' - '' ds_procedimento ';
	elsif (ie_tipo_conteudo_p = const_exames_nao_lab_w) then
		if (ie_param_aux_p = 'S') then
			ds_string_text_p := '	x.ds_laudo		ds_texto ';
		elsif (ie_param_aux_p = 'N') then
			ds_string_text_p := '			obter_desc_expressao(296423) ||'' ''||substr(Obter_Desc_Prescr_Proc_exam(c.cd_procedimento,c.ie_origem_proced, c.nr_seq_proc_interno, c.nr_seq_exame),1,255)||'' - Quantidade: ''|| '||'			c.qt_procedimento ';
		end if;
	elsif (ie_tipo_conteudo_p = const_epicrise_w) then
		ds_string_text_p	:=	chr(39) || 	'	<tr id=' || chr(39) || ' || b.cd_material || ' || chr(39) || ' data-width="641px" data-height="20px">  ' ||
											'		<td id="CD_MATERIAL" data-width="320px" data-height="20px" style="max-width: 321px; overflow: overlay; display: none;"> ' || chr(39) ||
											'			|| b.cd_material || ' ||
								chr(39) ||	'		</td > ';
								
								ds_string_text_p := 	ds_string_text_p ||		'		<td id="DS_MATERIAL" data-width="320px" data-height="20px" style="max-width: 321px; overflow: overlay; border: 1px solid #fff !important;"> ' || chr(39) ||
											'			|| OBTER_DESC_MATERIAL(b.cd_material) || ' ||
								chr(39) ||	'		</td > ';
								
								ds_string_text_p := 	ds_string_text_p ||					'		<td id="EXAMES" data-width="320px" data-height="20px" style="max-width: 321px; overflow: overlay; border: 1px solid #fff !important;"> ' || chr(39) ||
											'			|| substr(obter_desc_via(b.ie_via_aplicacao),1,255) || ' ||
								chr(39) ||	'		</td > ' ||
											'		<td id="EXAMES" data-width="320px" data-height="20px" style="max-width: 321px; overflow: overlay; border: 1px solid #fff !important;"> ' || chr(39) ||
											'			|| b.qt_dose || ' ||
								chr(39) ||	'		</td > ';
								
								ds_string_text_p := 	ds_string_text_p ||		
											'		<td id="EXAMES" data-width="320px" data-height="20px" style="max-width: 321px; overflow: overlay; border: 1px solid #fff !important;"> ' || chr(39) ||
											'			|| substr(obter_desc_unid_med(b.CD_UNIDADE_MEDIDA),1,150) || ' ||
								chr(39) ||	'		</td > ';
								
								ds_string_text_p := 	ds_string_text_p ||
											'		<td id="EXAMES" data-width="320px" data-height="20px" style="max-width: 321px; overflow: overlay; border: 1px solid #fff !important;"> ' || chr(39) ||
											'			|| substr(obter_desc_intervalo_prescr(b.CD_INTERVALO),1,60) || ' ||
								chr(39) ||	'		</td > ' ||
											'	</tr> ' || chr(39);
											
	elsif (ie_tipo_conteudo_p = const_laboratorio_w) then	
		ds_string_text_p	:=	chr(39) || 	'	<tr id=' || chr(39) || ' || e.NR_SEQ_EXAME || ' || chr(39) || ' data-width=\"641px\" data-height=\"20px\">  ' ||
											'		<td id="NM_EXAME_CHAVE" data-width="320px" data-height="20px" style="max-width: 321px; overflow: overlay; display: none;"> ' || chr(39) ||
											'			|| substr(obter_desc_exame_lab(e.nr_seq_exame,null,null,null),1,255) || ' ||
								chr(39) ||	'		</td > ' ||
											'		<td id="DT_RESULTADO_CHAVE" data-width="320px" data-height="20px" style="max-width: 321px; overflow: overlay; display: none;"> ' || chr(39) ||
											'			|| substr(pkg_date_formaters.to_varchar(d.dt_resultado, ' || chr(39) ||'shortDate' || chr(39) || ', wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario),1,150) || ' ||
								chr(39) ||	'		</td > ' ||
											'		<td id="NM_EXAME" data-width="320px" data-height="20px" style="max-width: 321px; overflow: overlay; border: 1px solid #fff !important;"> ' || chr(39) ||
											'			|| substr(obter_desc_exame_lab(e.nr_seq_exame,null,null,null),1,255) || ' ||
								chr(39) ||	'		</td > ' ||
											'		<td id="DT_RESULTADO" data-width="320px" data-height="20px" style="max-width: 321px; overflow: overlay; border: 1px solid #fff !important;"> ' || chr(39) ||
											'			|| substr(pkg_date_formaters.to_varchar(d.dt_resultado,  ' || chr(39) ||'shortDate' || chr(39) || ', wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario),1,150) || ' ||
								chr(39) ||	'		</td > ' ||
											'		<td id="DS_RESULTADO_EXAME" data-width="320px" data-height="20px" style="max-width: 321px; overflow: overlay; border: 1px solid #fff !important;"> ' || chr(39) ||
											'			|| substr(decode(nvl(e.qt_resultado,0),0,decode(nvl(e.pr_resultado,0),0,decode(e.ds_resultado,null,' || chr(39) ||'0' || chr(39) || ',e.ds_resultado),e.pr_resultado),e.qt_resultado),1,50) || ' ||
								chr(39) ||	'		</td > ' ||
											'		<td id="IE_RESULTADO_REFERENCIA" data-width="320px" data-height="20px" style="max-width: 321px; overflow: overlay; border: 1px solid #fff !important;"> ' || chr(39) ||
											'			|| decode(e.ie_resultado_referencia, ' || chr(39) || 'H' || chr(39) || ', ' || chr(39) || '+' || chr(39) || ', ' || chr(39) || 'HH' || chr(39) ||  ', ' || chr(39) || '++' || chr(39) || ', ' || chr(39) || 'L' || chr(39) || ', ' || chr(39) || '-' || chr(39) || ', ' || chr(39) || 'LL' ||  chr(39) || ', ' || chr(39) || '--' || chr(39) || ', e.ie_resultado_referencia) || ' ||
								chr(39) ||	'		</td > ' ||
											'		<td id="DS_UNIDADE_MEDIDA" data-width="320px" data-height="20px" style="max-width: 321px; overflow: overlay; border: 1px solid #fff !important;"> ' || chr(39) ||
											'			|| e.ds_unidade_medida || ' ||
								chr(39) ||	'		</td > ' ||
											'		<td id="DS_REFERENCIA_EXAME" data-width="320px" data-height="20px" style="max-width: 321px; overflow: overlay; border: 1px solid #fff !important;"> ' || chr(39) ||
											'			|| decode(e.pr_resultado,null,substr(obter_valor_ref_exame(e.nr_seq_resultado,e.nr_sequencia),1,255),substr(obter_valor_ref_exame_porc(e.nr_seq_resultado,e.nr_sequencia),1,255)) || ' ||
								chr(39) ||	'		</td > ' ||
											'	</tr> ' || chr(39);
	elsif (ie_tipo_conteudo_p = const_tempos_movimentos_w) then
		ds_string_text_p :=  	chr(39)||'<span id="' ||chr(39)|| '||NR_SEQUENCIA||'|| chr(39)|| '"> '||chr(39)||
			' || pkg_date_formaters.to_varchar(DT_INICIO_EVENTO, ''timeStamp'', wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario) ||'|| chr(39)||
			' - ' ||chr(39)|| ' || substr(obter_nome_medico(CD_PROFISSIONAL,''N''),1,200) ||'|| chr(39)||
			' - ' ||chr(39)|| ' || substr(OBTER_DESC_EVENTO_CIRURGIA(NR_SEQ_EVENTO),1,200) ||'|| chr(39)||
			'</span>'|| chr(39)||'  ds_evento';
	elsif (ie_tipo_conteudo_p = const_tempos_cirurgicos_w) then
		ds_string_text_p :=  	chr(39)||'<span id="' ||chr(39)|| '||NR_SEQUENCIA||'|| chr(39)|| '"> '
		||chr(39)||' || pkg_date_formaters.to_varchar(DT_INICIO, ''timeStamp'', wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario) ||'
		|| chr(39)|| ' - ' ||chr(39)|| ' || pkg_date_formaters.to_varchar(DT_FIM, ''timeStamp'', wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario) ||'
		|| chr(39)|| ' - ' ||chr(39)|| ' || substr(obter_nome_medico(CD_PROFISSIONAL,''N''),1,200) ||'
		|| chr(39)|| ' - ' ||chr(39)|| ' || (select substr(ds_tempo, 1, 150) ds from    tempo_cirurgico where nr_sequencia = nr_seq_tempo) ||'
		|| chr(39)||'</span>'|| chr(39)||'  ds_tempo';	
	elsif (ie_tipo_conteudo_p = const_participantes_w) then
		ds_string_text_p :=  	chr(39)||'<span id="' ||chr(39)|| '||NR_SEQUENCIA||'|| chr(39)|| '"> '
		||chr(39)||' || substr(obter_nome_medico(CD_PESSOA_FISICA,''N''),1,200) ||'
		|| chr(39)|| ' - ' ||chr(39)|| ' || substr(obter_funcao_medico(IE_FUNCAO),1,80) ||'
		|| chr(39)||'</span>'|| chr(39)||'  ds_participante';	
	elsif (ie_tipo_conteudo_p = const_tecnica_w) then
		ds_string_text_p :=  	chr(39)||'<span id="' ||chr(39)|| '||NR_SEQUENCIA||'|| chr(39)|| '"> '
		||chr(39)||' || pkg_date_formaters.to_varchar(DT_INICIO, ''timeStamp'', wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario) ||'
		|| chr(39)|| ' - ' ||chr(39)|| ' || obter_desc_tecnica_anest(nr_seq_tecnica) ||'
		|| chr(39)|| ' - ' ||chr(39)|| ' ||  substr(obter_nome_medico(CD_PROFISSIONAL,''N''),1,200) ||'|| chr(39)||'</span>'|| chr(39)||'  ds_participante ';	
	elsif (ie_tipo_conteudo_p = const_equipamentos_w) then
		ds_string_text_p :=  	chr(39)||'<span id="' ||chr(39)|| '||NR_SEQUENCIA||'|| chr(39)|| '"> '||chr(39)||' || Obter_Desc_Equipamento(CD_EQUIPAMENTO)||'
		|| chr(39)|| ' - ' ||chr(39)|| '|| pkg_date_formaters.to_varchar(DT_INICIO, ''timeStamp'', wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario) ||' 
		|| chr(39)|| ' - ' ||chr(39)|| '|| pkg_date_formaters.to_varchar(DT_FIM, ''timeStamp'', wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario) ||' ||chr(39)||
		'</span>'|| chr(39)||'  ds_equipamento ';	
	elsif (ie_tipo_conteudo_p = const_dispositivos_w) then
		ds_string_text_p :=  	chr(39)||'<span id="' ||chr(39)|| '||NR_SEQUENCIA||'|| chr(39)|| '"> '
		||chr(39)||' ||pkg_date_formaters.to_varchar(DT_INSTALACAO, ''timeStamp'', wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario)||'
		|| chr(39)|| ' - ' ||chr(39)|| ' || pkg_date_formaters.to_varchar(nvl(DT_RETIRADA, DT_RETIRADA_PREV), ''timeStamp'', wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario) ||'
		|| chr(39)|| ' - ' ||chr(39)|| ' || substr(OBTER_NOME_DISPOSITIVO(NR_SEQ_DISPOSITIVO),1,200) ||'
		|| chr(39)|| ' - ' ||chr(39)|| ' || substr(OBTER_DESC_TOPOGRAFIA(NR_SEQ_TOPOGRAFIA),1,200) ||'
		|| chr(39)||'</span>'|| chr(39)||'  ds_dispositivo ';
	elsif (ie_tipo_conteudo_p = const_diag_paciente_w) then
		ds_string_text_p := chr(39)||'<tr id="' ||chr(39)|| '|| cd_doenca ||'||chr(39)|| '" data-width=\"641px\" data-height=\"20px\"> '||
		'	<td id="cd_doenca" data-width="320px" data-height="20px" style="max-width: 321px; overflow: overlay; border: 1px solid rgb(0,0,0) !important;"> '||chr(39)|| '||cd_doenca||' ||chr(39)|| '</td>' ||
		'	<td id="nm_diagnostico" data-width="320px" data-height="20px" style="max-width: 321px; overflow: overlay; border: 1px solid rgb(0,0,0) !important;"> '||chr(39)|| '||substr(obter_desc_cid(cd_doenca),1,200)||' ||chr(39)|| '</td>' ||
		'	<td id="qt_registros" data-width="320px" data-height="20px" style="max-width: 321px; overflow: overlay; border: 1px solid rgb(0,0,0) !important;"> '||chr(39)|| '|| (select count(*) from diagnostico_doenca where nr_atendimento in ( select nr_atendimento from atendimento_paciente where cd_pessoa_fisica = :cd_pessoa_fisica_p) and cd_doenca = a.cd_doenca) ||' ||chr(39)|| '</td>' ||
        '	<td id="ie_tipo_diagnostico" data-width="320px" data-height="20px" style="max-width: 321px; overflow: overlay; border: 1px solid rgb(0,0,0) !important;"> '||chr(39)|| '|| obter_valor_dominio(13,ie_tipo_diagnostico) ||' ||chr(39)|| '</td>' ||
        '	<td id="ie_tipo_doenca" data-width="320px" data-height="20px" style="max-width: 321px; overflow: overlay; border: 1px solid rgb(0,0,0) !important;"> '||chr(39)|| '|| obter_valor_dominio(1758,IE_TIPO_DOENCA) ||' ||chr(39)|| '</td>' || 
        '	<td id="ie_classificacao_doenca" data-width="320px" data-height="20px" style="max-width: 321px; overflow: overlay; border: 1px solid rgb(0,0,0) !important;"> '||chr(39)|| '|| obter_valor_dominio(58,IE_CLASSIFICACAO_DOENCA) ||' ||chr(39)|| '</td>' || 
		'	<td id="dt_atualizacao" data-width="320px" data-height="20px" style="max-width: 321px; overflow: overlay; border: 1px solid rgb(0,0,0) !important;"> '||chr(39)|| '||pkg_date_formaters.to_varchar(dt_atualizacao, ''short'', wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario)||' ||chr(39)|| '</td>' || '</tr>' ||chr(39)|| 'qt_registros';
	end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE get_text_conteudo ( ie_tipo_conteudo_p text, ds_string_text_p INOUT text, ie_param_aux_p text default null) FROM PUBLIC;
