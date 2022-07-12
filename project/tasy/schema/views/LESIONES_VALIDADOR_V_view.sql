-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW lesiones_validador_v (ie_tipo_registro, cabecario, clues, folio, curppaciente, nombre, primerapellido, segundoapellido, fechanacimiento, nacioextranjero, paisorigen, entidadnacimiento, escolaridad, sabeleerescribir, edad, claveedad, sexo, afiliacion, gratuidad, numeroafiliacion, digitoverificador, seconsideraindigena, hablalenguaindigena, cuallengua, mujerfertil, discapacidad, fechaevento, horaevento, diafestivo, sitioocurrencia, entidadocurrencia, municipioocurrencia, localidadocurrencia, otralocalidad, codigopostal, seignoracp, tipovialidad, nombrevialidad, numeroexteriornumerico, tipoasentamiento, nombreasentamiento, atencionprehospitalaria, tiempotrasladouh, sospechabajoefectosde, intencionalidad, eventorepetido, agentelesion, especifique, lesionadovehiculomotor, usoequiposeguridad, equipoutilizado, especifiqueequipo, tipoviolencia, parentescoafetado, numeroagresores, especifiqueparentesco, agresorbajoefectos, fechaingreso, horaingreso, servicioatencion, tipoatencion, areaanatomica, especifiquearea, consecuenciagravedad, especifiqueconsecuencia, mesestadistico, descripcionafeccionprincipal, afeccionprincipal, afeccionlesione, afeccionreseleccionada, causaexterna, codigociecausaexterna, despuesatencion, especifiquedestino, foliocertificadodefuncion, ministeriopublico, responsableatencion, curpresponsable, nombreresponsable, primerapellidoresponsable, segundoapellidoresponsable, cedulaprofesional, dt_entrada, cd_pessoa_fisica, cd_cgc, cd_cgc_convenio, dt_notificacao) AS select  --REGISTRO--
	1 ie_tipo_registro,
	'' cabecario,
	pj.cd_internacional clues,
	b.nr_atendimento folio,
	--DADOS PACIENTE--
	a.cd_curp curppaciente,
	y.ds_given_name nombre,
	y.ds_family_name primerapellido,
	y.ds_component_name_1 segundoapellido,
	a.dt_nascimento fechanacimiento,
        CASE WHEN i.ie_brasileiro='N' THEN  0  WHEN i.ie_brasileiro='S' THEN  1 END  nacioextranjero,
        CASE WHEN i.ie_brasileiro='S' THEN  i.cd_externo  ELSE '142 – MÉXICO' END  paisorigen,
        CASE WHEN i.ie_brasileiro='S' THEN  97  ELSE obter_dados_cat_entidade(a.cd_pessoa_fisica, 'CD_ENTIDADE') END  entidadnacimiento,
	case
		when obter_idade(a.dt_nascimento, LOCALTIMESTAMP, 'A') > 5
		then CASE WHEN a.ie_grau_instrucao=7 THEN  1 WHEN a.ie_grau_instrucao=8 THEN  3 WHEN a.ie_grau_instrucao=3 THEN  4 WHEN a.ie_grau_instrucao=9 THEN  5 WHEN a.ie_grau_instrucao=4 THEN  6  ELSE 13 END
		else 000
	end as escolaridad,
	case
		when obter_idade(a.dt_nascimento, LOCALTIMESTAMP, 'A') > 5
		then CASE WHEN a.ie_grau_instrucao=11 THEN 0 WHEN a.ie_grau_instrucao=14 THEN  9  ELSE 1 END 
		when a.ie_grau_instrucao in (7,8,3,9,4)
		then 1
		else 000
	end as sabeleerescribir,
	case
		when obter_idade(a.dt_nascimento, b.dt_entrada, 'A') is not null
		then obter_idade_imc_nom(b.nr_atendimento,a.dt_nascimento,b.dt_entrada,'IDADE')
	end as edad,
	case
		when obter_idade(a.dt_nascimento, b.dt_entrada, 'A') is not null
		then obter_idade_imc_nom(b.nr_atendimento,a.dt_nascimento,b.dt_entrada,'CLAVEEDAD')
	end as claveedad,
	CASE WHEN a.ie_sexo='F' THEN  2 WHEN a.ie_sexo='M' THEN  1 END  sexo,
	k.cd_der_lesiones afiliacion,
	case
		when k.cd_der_lesiones = 12
		then CASE WHEN n.ie_classif_contabil='3' THEN  1  ELSE 0 END 
		else 000
	end as gratuidad,
	case
		when n.ie_classif_contabil = 3 and k.cd_der_lesiones <> 0 and k.cd_der_lesiones <> 98
		then substr(n.cd_integracao,1,16)
		else 'NO OBLIGATORIO'
	end as numeroafiliacion,
	CASE WHEN k.cd_der_lesiones=11 THEN  n.nr_prim_digitos  ELSE 0 END  digitoverificador,
	CASE WHEN a.nr_seq_cor_pele=201 THEN  1  ELSE 0 END  seconsideraindigena,
	CASE WHEN a.nr_seq_lingua_indigena IS NULL THEN  0  ELSE 1 END  hablalenguaindigena,
	CASE WHEN a.nr_seq_cor_pele=201 THEN  coalesce(a.nr_seq_lingua_indigena, '-1')  ELSE '-1' END  cuallengua,
	coalesce(b.ie_paciente_gravida, '-1') mujerfertil,
	coalesce(e.ie_deficiencia, '-1') discapacidad,
	--EVENTO--
	c.dt_notificacao fechaevento,
	c.dt_notificacao horaevento,
	c.ie_dia_festivo diafestivo,
	CASE WHEN d.ds_local_ocorrencia=3 THEN 2 WHEN d.ds_local_ocorrencia=4 THEN 3 WHEN d.ds_local_ocorrencia=6 THEN 4 WHEN d.ds_local_ocorrencia=7 THEN 5 WHEN d.ds_local_ocorrencia=9 THEN 6 WHEN d.ds_local_ocorrencia=5 THEN 8 WHEN d.ds_local_ocorrencia=10 THEN 9 WHEN d.ds_local_ocorrencia=11 THEN 10  ELSE 12 END  sitioocurrencia,
	d.nr_seq_entidade entidadocurrencia,
	d.nr_seq_municipio municipioocurrencia,
	d.nr_seq_localidade localidadocurrencia,
	case
		when coalesce(d.nr_seq_localidade, 9999) = 9999
		then substr(upper(d.ds_complemento),1,50)
		else 'NO OBLIGATORIO'
	end otralocalidad,
	d.nr_seq_cod_postal codigopostal,
	d.ie_possue_codigo_postal seignoracp,
	d.nr_seq_tipo_via tipovialidad,
	d.nr_seq_vialidade nombrevialidad,
	d.nr_endereco numeroexteriornumerico,
	d.nr_seq_tipo_assen tipoasentamiento,
	d.nr_seq_assentamento nombreasentamiento,
	--ATENCIÓN PRE-HOSPITALARIA--
	CASE WHEN c.dt_tempo_translado IS NULL THEN  'N'  ELSE 'S' END  atencionprehospitalaria,
	CASE WHEN c.dt_tempo_translado='S' THEN  to_char(c.dt_tempo_translado, 'hh:mm') END  tiempotrasladouh,
	e.ie_efeito_drogas_alcool sospechabajoefectosde,
	--CIRCUNSTANCIAS EN LAS QUE OCURRIÓ EL EVENTO--
	v.ie_tipo_violencia intencionalidad,
	case
		when v.ie_tipo_violencia in (2,3,4)
		then v.ie_causador_violencia
		else -1
	end as eventorepetido,
	case
		when r.ie_violencia_fisica = 1 or r.ie_violencia_sexual = 1
		then 97
		else v.ie_agente_violencia
	end as agentelesion,
	CASE WHEN v.ie_agente_violencia=25 THEN  substr(trim(both v.ds_outro),1,50) END  especifique,
	--en caso de accidente--
	CASE WHEN v.ie_agente_violencia=20 THEN  v.ie_tipo_condutor  ELSE '-1' END  lesionadovehiculomotor,
	case
		when v.ie_tipo_condutor in (1.2)
		then v.ie_sinto_seguranca
		else -1
	end as usoequiposeguridad,
	CASE WHEN v.ie_sinto_seguranca=1 THEN v.ie_item_utilizado  ELSE '-1' END  equipoutilizado,
	CASE WHEN v.ie_item_utilizado=4 THEN (' '||substr(v.ds_item_utilizado,1,50)||' ') END  especifiqueequipo,
	--EN CASO DE VIOLENCIA--
	coalesce(substr(CASE WHEN r.ie_violencia_fisica='s' THEN  chr(38)||'6'  ELSE null END ||CASE WHEN r.ie_violencia_sexual='S' THEN  chr(38)||'7'  ELSE null END ||CASE WHEN r.ie_violencia_psicologica='S' THEN  chr(38)||'8'  ELSE null END ||CASE WHEN r.ie_violencia_fin_eco='S' THEN  chr(38)||'9'  ELSE null END ||CASE WHEN r.ie_neglicegencia_abandono='S' THEN  chr(38)||'10'  ELSE null END , 2,5), '-1') as tipoviolencia ,
	--DATOS DEL AGRESOR--
	case
		when v.ie_causador_violencia = 1
		then
		case
			when ie_tipo_violencia in (2,3)
			then
			case
				when j.ie_vinculo_pai = 'S'  then 1
				when j.ie_vinculo_mae = 'S' then 2
				when j.ie_vinculo_filho = 'S' then 6
				when j.ie_vinculo_padastro = 'S' then 8
				when j.ie_vinculo_madastra = 'S' then 9
				when j.ie_vinculo_desconhecido = 'S' then 17
				when j.ds_outro_vinculo = 'S' then 19
			end
		end
		else -1
	end as parentescoafetado,
	case
		when v.ie_tipo_violencia in (2,3)
		then j.nr_envolvido
		else -1
	end as numeroagresores,
	case
		when v.ie_tipo_violencia = 2 and j.nr_envolvido = 1 and j.ds_outro_vinculo = 'S'
		then j.ds_outro_vinculo
	end as especifiqueparentesco,
	case
		when v.ie_tipo_violencia in (2,3)
		then j.ie_uso_alcool
		else -1
	end as agresorbajoefectos,
		--atención médica--
	b.dt_entrada fechaingreso,
	b.dt_entrada horaingreso,
	ss.ie_servico_especializado servicioatencion,
	c.ie_tipo_atendimento tipoatencion,
	v.ie_local_violencia areaanatomica,
	CASE WHEN v.ie_local_violencia=16 THEN  substr(trim(both v.ds_local_violencia),1,50)  ELSE 'NO OBLIGATORIO' END  especifiquearea,
	v.ie_consequencia_violencia consecuenciagravedad,
	CASE WHEN v.ie_consequencia_violencia=22 THEN  substr(trim(both v.ds_outra_consequencia),1,50)  ELSE 'NO OBLIGATORIO' END  especifiqueconsecuencia,
	b.dt_saida_real mesestadistico,
	elimina_caractere_especial(substr(upper((select max(cd.ds_doenca_cid)
						FROM diagnostico_doenca dd, cid_doenca cd
						where dd.nr_atendimento = b.nr_atendimento
						and dd.cd_doenca = cd.cd_doenca_cid
						and dd.ie_classificacao_doenca = 'P')),1, 255)) descripcionafeccionprincipal,
	(select max(cc1.cd_doenca)
	from 	cid_doenca cc1, diagnostico_doenca dd
	where (cc1.cd_categoria_cid like('%T%') or cc1.cd_categoria_cid like('%S%') or cc1.cd_categoria_cid like('%F%')) or (cc1.cd_doenca_cid in ('O04','O05','O06','','O07','O20','O267','O267','O429','O468','O469','O68','O710','O713','O714','O715','O716','O717','O718','O719','O95','O9'))
	and cc1.cd_doenca_cid like dd.cd_doenca and dd.nr_atendimento = b.nr_atendimento) afeccionprincipal,
	--afecciones--
	substr(get_afecciones_sinan(c.nr_atendimento),1,2000) afeccionlesione,
	trim((select max(dd.cd_doenca) from diagnostico_doenca dd where dd.nr_atendimento = b.nr_atendimento and dd.ie_tipo_doenca = 'S')) afeccionreseleccionada,
	substr(trim(substr(obter_desc_cid((select max(dd.cd_doenca) from diagnostico_doenca dd where dd.nr_atendimento = b.nr_atendimento)),1, 250)),1,250) causaexterna,
	t.ds_observacao codigociecausaexterna,
	CASE WHEN v.ie_consequencia_violencia=19 THEN  coalesce(v.ie_destino, 5) END  despuesatencion,
	CASE WHEN v.ie_destino=11 THEN  substr(trim(both v.ds_outro_destino),1,250)  ELSE 'NO OBLIGATORIO' END  especifiquedestino,
	case
		when v.ie_destino = 5 and ie_envio_ministerio = 2
		then substr(xx.nr_declaracao, 1,9)
		else 'NO OBLIGATORIO'
	end as foliocertificadodefuncion,
	CASE WHEN v.ie_destino=5 THEN  v.ie_envio_ministerio  ELSE -1 END  ministeriopublico,
	--profesional responsable de la salud--
	coalesce(v.ie_tipo_atendimento,'-1') responsableatencion,
	aa.cd_curp curpresponsable,
        yy.ds_given_name nombreresponsable,
	yy.ds_family_name primerapellidoresponsable,
	yy.ds_component_name_1 segundoapellidoresponsable,
	coalesce(aa.ds_codigo_prof, mm.nr_crm) cedulaprofesional,
	b.dt_entrada dt_entrada,
	c.cd_paciente cd_pessoa_fisica,
	pj.cd_cgc cd_cgc,
	n.cd_cgc cd_cgc_convenio,
	c.dt_notificacao dt_notificacao
FROM atend_categoria_convenio p, medico mm, categoria_convenio m, pessoa_fisica a
LEFT OUTER JOIN person_name y ON (a.nr_seq_person_name = y.nr_sequencia AND 'main' = y.ds_type)
LEFT OUTER JOIN nacionalidade i ON (a.cd_nacionalidade = i.cd_nacionalidade)
LEFT OUTER JOIN sus_municipio s ON (a.cd_municipio_ibge = s.cd_municipio_ibge)
LEFT OUTER JOIN cat_entidade ce ON (s.nr_seq_entidade_mx = ce.nr_sequencia)
, pessoa_fisica aa
LEFT OUTER JOIN atendimento_paciente b ON (aa.cd_pessoa_fisica = b.cd_medico_resp)
LEFT OUTER JOIN person_name yy ON (aa.nr_seq_person_name = yy.nr_sequencia AND 'main' = yy.ds_type)
LEFT OUTER JOIN declaracao_obito xx ON (b.nr_atendimento = xx.nr_atendimento)
LEFT OUTER JOIN classificacao_atendimento ss ON (b.nr_seq_classificacao = ss.nr_sequencia)
, notificacao_sinan c
LEFT OUTER JOIN sinan_dados_complementares e ON (c.nr_sequencia = e.nr_seq_notificacao)
LEFT OUTER JOIN sinan_dados_ocorrencia d ON (c.nr_sequencia = d.nr_seq_notificacao)
LEFT OUTER JOIN sinan_inf_violencia v ON (c.nr_sequencia = v.nr_seq_notificacao)
LEFT OUTER JOIN sinan_dados_agressao j ON (c.nr_sequencia = j.nr_seq_notificacao)
LEFT OUTER JOIN sinan_inf_complementar t ON (c.nr_sequencia = t.nr_seq_notificacao)
LEFT OUTER JOIN sinan_violencia r ON (c.nr_sequencia = r.nr_seq_notificacao)
, convenio n
LEFT OUTER JOIN cat_derechohabiencia k ON (n.cd_tipo_convenio_mx = k.nr_sequencia)
, pessoa_juridica pj
LEFT OUTER JOIN estabelecimento ee ON (pj.cd_cgc = ee.cd_cgc)
WHERE a.cd_pessoa_fisica	= b.cd_pessoa_fisica   and c.nr_atendimento	= b.nr_atendimento           and p.nr_atendimento 	= b.nr_atendimento and p.cd_convenio 		= m.cd_convenio and p.cd_categoria 		= m.cd_categoria and n.cd_convenio 		= m.cd_convenio    and c.nr_seq_doenca_compulsoria = 109 and b.cd_estabelecimento 	= ee.cd_estabelecimento  and mm.cd_pessoa_fisica 	= aa.cd_pessoa_fisica;
