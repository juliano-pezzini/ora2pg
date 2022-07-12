-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW nom_morte_geral_v (cd_estado_capt, nr_folio, nr_declaracao_obito, ds_nome_def, ds_sobrenome_pat_def, ds_sobrenome_mat_def, cd_curp_def, ie_sexo_def, ie_nacionalidigena_def, nr_seq_lingua_indigena_def, dt_nascimento_def, nr_certificado_nasc_def, ie_estado_civil_def, ds_endereco_hab_def, cd_estado_hab_def, cd_municipio_hab_def, cd_localidade_hab_def, ie_grau_instrucao_def, cd_cargo_def, ie_trabalha_def, cd_der_fetal_def, nr_filiacao_def, cd_der_fetal_def_2, cd_sitio_def, ds_estab_saude_def, cd_internacional_def, ds_endereco_ocor_def, ds_bairro_ocor_def, cd_estado_ocor_def, cd_municipio_ocor_def, cd_localidade_ocor_def, cd_jurisdicao_ocor_def, dt_ocorrencia_def, hr_ocorrencia_def, ie_recebeu_atendimento, ie_autopsia, ds_causa_1, qt_tempo_causa_1, cd_causa_1, ie_tipo_causa_1, ds_causa_1a, qt_tempo_causa_1a, cd_causa_1a, cd_tempo_causa_1a, ds_causa_2, qt_tempo_causa_2, cd_causa_2, ie_tipo_causa_2, ds_causa_2a, qt_tempo_causa_2a, cd_causa_2a, cd_tempo_causa_2a, ds_causa_3, qt_tempo_causa_3, cd_causa_3, ie_tipo_causa_3, ds_causa_3a, qt_tempo_causa_3a, cd_causa_3a, cd_tempo_causa_3a, ds_causa_4, qt_tempo_causa_4, cd_causa_4, ie_tipo_causa_4, ds_causa_4a, qt_tempo_causa_4a, cd_causa_4a, cd_tempo_causa_4a, ds_causa_5, qt_tempo_causa_5, cd_causa_5, ie_tipo_causa_5, ds_causa_5a, qt_tempo_causa_5a, cd_causa_5a, cd_tempo_causa_5a, ds_causa_6, qt_tempo_causa_6, cd_causa_6, ie_tipo_causa_6, ds_causa_6a, qt_tempo_causa_6a, cd_causa_6a, cd_tempo_causa_6a, cd_cid_basica, ie_periodo_ocorr_def, ie_gravidez_causou_morte, ie_morte_complicou_gravidez, ie_tipo_acidente, ie_obito_trabalho, ie_tipo_idade_def, cd_lugar_acc_mg_def, ie_parentesco_agressor_def, nr_notificacao_def, ds_diagnostico_les_def, cd_estado_ocor_acidente, cd_municipio_ocor_acidente, cd_localidade_ocor_acidente, ds_nome_inf, ds_sobrenome_pat_inf, ds_sobrenome_mat_inf, ds_family_name_inf, ie_emissor_certif, nr_cedula_medico_certif, ds_nome_cert, ds_sobrenome_pat_cert, ds_sobrenome_mat_cert, nr_telefone_certif, ds_endereco_certif, ie_assinou_cert_obito, dt_cert_obito, dt_certificado_obito, nr_declaracao_oficial, ds_livro_cert_obito, nr_certificado_obito, cd_estado_reg, cd_municipio_reg, cd_localidade_reg, dt_capt_reg, ie_usuario_capt_reg, dt_criacao_cre, ie_nivel_usu_capt_cre, cd_sitio_capt_cre, cd_sitio_capt, cd_estado_capt_cre, cd_jurisdicao_capt_cre, cd_municipio_capt_cre, cd_internacional_capt_cre, nm_usuario_mod, dt_modificacao, ie_nivel_ult_mod, cd_estado_ult_mod, cd_jurisdicao_capt_reg, cd_municipio_capt_reg, cd_clues_mod_reg, ie_tipo_certif_obt, ie_vig_epidemiologica, ie_morte_materna, dt_captura, ie_retificado, ie_bloq_perfil_fed, ie_bloq_perfil_est, ie_controle_interno, cd_estado_nasc, ds_nacionalidade, cd_tipo_vialidad_def, nr_exterior_hab, nr_interior_hab, cd_tipo_asentamiento_hab, ds_bairro_hab_def, cd_codigo_postal_hab, qt_idade_def, qt_semanas_gestacao, qt_peso_gramas, ds_espc_cert, cd_entidade_cert, cd_munideftpo_embcipio_cert, cd_localidade_cert, cd_codigo_postal_cert, cd_tipo_vialidad_cert, nr_exterior_cert, nr_interior_cert, cd_tipo_asentamiento_cert, ds_bairro_cert, ie_ignorar_cp_cert, cd_tipo_vialidad_ocor_def, nr_exterior_ocor_def, nr_interior_ocor_def, cd_tipo_asent_ocor_def, cd_cp_ocor_def, cd_tipo_vialidad_acc, ds_tipo_vialidad_acc, nr_exterior_acc, nr_interior_acc, cd_tipo_asentamiento_acc, ds_tipo_asentamiento_acc, cd_codigo_postal_acc, imagre_med, imuni_adsc, imuni_aten, imseryesp_med, imssdelega_capt, imssclavepre_capt) AS select  upper(a.cd_estado_capt) cd_estado_capt, /*CEDOCAPT - tipoHoja - catálogo*/

    upper(substr(trim(both a.nr_folio), 1, 9)) nr_folio, /* DEFFOLIO - folio - os dois primeiros digitos correspondem aos dois ultimos digitos do ano (9 caracteres)*/

    upper(a.nr_declaracao_obito) nr_declaracao_obito, /*DEFFOLIOCO - folioControl - Texto(9)*/

    substr(upper(coalesce(trim(both b.ds_given_name),'NO ESPECIFICADO')),1,40) ds_nome_def, /*DEFNOMBRE - nombre -  Texto (40) -  padrão: SE IGNORA*/

    substr(upper(coalesce(trim(both b.ds_family_name),'NO ESPECIFICADO')),1,20) ds_sobrenome_pat_def, /*DEFAPEPATER -  primerApellido - Texto (20) -  padrão: SE IGNORA**/

    substr(upper(coalesce(trim(both b.ds_component_name_1),'NO ESPECIFICADO')),1,20) ds_sobrenome_mat_def, /*DEFAPEMATER - segundoApellido - Texto (20) -  padrão: SE IGNORA**/

    substr(upper(coalesce(a.cd_curp_def, 'XXXX999999XXXXXX99')),1,18) cd_curp_def, /*DEFCURP - curp Texto(18) */

    upper(coalesce(a.ie_sexo_def, 0)) ie_sexo_def , /*DEFSEXO - sexo - Catálogo*/

    upper(a.ie_nacionalidade_def) ie_nacionalidigena_def, /* DEFNACION - nacionalidad Catálogo */

    upper(coalesce(a.nr_seq_lingua_indigena_def, 0)) nr_seq_lingua_indigena_def, /*LENG_INDIG - hablaLenguaIndigena -  Catálogo */

    /*nvl(upper(a.qt_peso_kg_def),888) qt_peso_kg_def, - Não há mais na versão nova*/


    /*upper(a.qt_peso_gr_def) qt_peso_gr_def, - Não há mais na versão nova*/


    /*upper(a.qt_altura_mt_def) qt_altura_mt_def, - Não há mais na versão nova*/


    /*upper(a.qt_altura_cm_def) qt_altura_cm_def, - Não há mais na versão nova*/


    upper(coalesce(to_char(a.dt_nascimento_def, 'dd/mm/yyyy'), '08/08/8888')) dt_nascimento_def, /*DT_NASCIMENTO_DEF - fechaNacimiento */

    /*upper(a.qt_idade_anos_def) qt_idade_anos_def,  - Não utilizado na geração do MDB*/


    /*upper(a.qt_idade_meses_def) qt_idade_meses_def,  - Não utilizado na geração do MDB*/


    /*upper(a.qt_idade_dias_def) qt_idade_dias_def, - Não utilizado na geração do MDB*/


    /*decode(  upper(lpad(nvl(a.nr_certificado_nasc_def, '888888888'), 9, '0')),
        '000000000','00000E00000000',
        upper(lpad(nvl(a.nr_certificado_nasc_def, '888888888'), 9, '0'))) nr_certificado_nasc_def, /* DEFFOL_CN_CEN  - folioCertificadoNacimiento - Texto(14)*/

    coalesce(a.nr_certificado_nasc_def,'000000000') nr_certificado_nasc_def,
    upper(coalesce(a.ie_estado_civil_def,'8')) ie_estado_civil_def, /*DEFEDO_CIV - estadoConyugal*/

    upper(coalesce(substr(trim(both a.ds_endereco_hab_def), 1, 100), 'NO ESPECIFICADO')) ds_endereco_hab_def, /*24 DEFNOMVIA_HAB - nombreVialidadResidencia*/

    --upper(nvl(a.cd_estado_hab_def, '00')) cd_estado_hab_def, /*DEFENT_HAB - entidadResidencia*/

    upper(coalesce(obter_conversao_catalogo_nom('MUERTES_FETALES','ESTADO_PROVINCI','A',cd_estado_hab_def), '00')) cd_estado_hab_def,
    --lpad(upper(nvl(a.cd_municipio_hab_def, '999')),'3', '0') cd_municipio_hab_def, /* DEFDEL_HAB - municipioResidencia*/

    lpad(coalesce(obter_conversao_catalogo_nom('MUERTES_FETALES','MUNICIPIO','A',a.cd_municipio_hab_def),''),3,'0') cd_municipio_hab_def,
    --lpad(upper(nvl(a.cd_localidade_hab_def, '9999')),'4','0') cd_localidade_hab_def, /*DEFLOC_HAB - localidadResidencia */

    lpad(coalesce(obter_conversao_catalogo_nom('MUERTES_FETALES','LOCALIDADE_AREA','A',coalesce(a.cd_localidade_hab_def,'9999')),''),4,'0') cd_localidade_hab_def,
    upper(coalesce(a.ie_grau_instrucao_def, 0)) ie_grau_instrucao_def, /*DEFESCOLAR - escolaridad*/

    upper(lpad(coalesce(a.cd_cargo_def, '00'), 2, '0')) cd_cargo_def, /*DEFOCUPACI - claveOcupacionHabitual*/

    upper(coalesce(a.ie_trabalha_def, 0)) ie_trabalha_def, /*DEFTRABAJA - trabajaActualmente*/

    coalesce(upper(a.cd_der_fetal_def),'00') cd_der_fetal_def, /*DEFDERECHO - afiliacion*/

    upper(substr(ADICIONA_ZEROS_ESQUERDA(coalesce(trim(both a.nr_filiacao_def||CASE WHEN a.cd_der_fetal_def='07' THEN a.cd_complemento_filiacao  ELSE '' END ), 'NO ESPECIFICADO'), 5), 1, 16)) nr_filiacao_def, /*DEFAFIL_DH - numeroAfiliacion*/

    upper(a.cd_der_fetal_def_2) cd_der_fetal_def_2, /*DEFDERECHO2 */

    upper(coalesce(a.cd_sitio_def,'00')) cd_sitio_def, /*DEFSITIO - Catálogo sítios - CLUES */

    substr(upper(a.ds_estab_saude_def),1,255) ds_estab_saude_def, /*DEFUNIMED - nombreUnidadMedica*/

    upper(a.cd_internacional_def) cd_internacional_def, /*DEFCLUES - clues*/

    substr(coalesce(upper(a.ds_endereco_ocor_def),'SIN INFORMACIÓN'),1,100) ds_endereco_ocor_def, /*DEFNOMVIA_DEF - nombreVialidadDefuncion */

    substr(upper(coalesce(a.ds_bairro_ocor_def,'SIN INFORMACIÓN')),1,100) ds_bairro_ocor_def, /*DEFNOMASEN_DEF - nombreAsentamientoDefuncion*/

    --lpad(upper(nvl(a.cd_estado_ocor_def,'00')),2,'0') cd_estado_ocor_def, /*DEFENT_DEF - entidadDefuncion */

    lpad(coalesce(obter_conversao_catalogo_nom('MUERTES_FETALES','ESTADO_PROVINCI','A',a.cd_estado_ocor_def),'00'),2,'0') cd_estado_ocor_def,
    --lpad(upper(a.cd_municipio_ocor_def),3,'0') cd_municipio_ocor_def, /* DEFDEL_DEF - municipioDefuncion*/

    lpad(coalesce(obter_conversao_catalogo_nom('MUERTES_FETALES','MUNICIPIO','A',a.cd_municipio_ocor_def),''),3,'0') cd_municipio_ocor_def,
    --lpad(upper(a.cd_localidade_ocor_def),4,'0') cd_localidade_ocor_def, /*DEFLOC_DEF - localidadDefuncion*/

    lpad(coalesce(obter_conversao_catalogo_nom('MUERTES_FETALES','LOCALIDADE_AREA','A',a.cd_localidade_ocor_def),''),4,'0') cd_localidade_ocor_def,
    coalesce((select max(x.cd_jurisdicao) FROM cat_jurisdicao x where x.nr_sequencia = a.cd_jurisdicao_ocor_def),nom_obter_jurisdicao_def(estab.cd_estabelecimento,a.cd_internacional_def,null)) cd_jurisdicao_ocor_def, /* DEFJUR_DEF - jurisdicionDefuncion*/

    coalesce(upper(to_char(a.dt_ocorrencia_def,'dd/mm/yyyy')),'08/08/8888') dt_ocorrencia_def, /*DEFFECH_DEF - fechaDefuncion*/

    coalesce(upper(a.hr_ocorrencia_def),'88:88') hr_ocorrencia_def, /* DEFHORA  - horaDefuncion*/

    upper(coalesce(a.ie_recebeu_atendimento, 0)) ie_recebeu_atendimento, /*DEFATENCIO - atencionMedica*/

    upper(coalesce(a.ie_autopsia, 0)) ie_autopsia, /*DEFNECROPS - practicoNecropsia*/

    substr(upper(a.ds_causa_1),1,250)     ds_causa_1, /*DESCAUSA1 - descripcionCausa1*/

    upper(a.qt_tempo_causa_1)   qt_tempo_causa_1, /*TIEMPO_C1 -  tiempo1*/

    upper(a.cd_causa_1)     cd_causa_1, /*CAUSA1 - codigoCIECausa_1*/

    /*upper(a.cd_tempo_causa_1)   cd_tempo_causa_1  -------------------------------------------------------Não utilizado no fonte */


    upper(a.cd_tempo_causa_1)   ie_tipo_causa_1, /*CVETPO_C1 - claveTiempo1 */

    upper(null)     ds_causa_1a, /*------------------------------------------------------- Não está mais em tela */

    upper(null)   qt_tempo_causa_1a, /*------------------------------------------------------- Não está mais em tela */

    upper(null)     cd_causa_1a, /*------------------------------------------------------- Não está mais em tela */

    upper(null)   cd_tempo_causa_1a, /*------------------------------------------------------- Não está mais em tela */

    upper(a.ds_causa_1a)     ds_causa_2, /*DESCAUSA2 - descripcionCausa2 */

    upper(a.qt_tempo_causa_1a)   qt_tempo_causa_2, /*TIEMPO_C2 - tiempo2*/

    upper(a.cd_causa_1a)     cd_causa_2, /*CAUSA2 - codigoCIECausa_2*/

    /*upper(a.cd_tempo_causa_1a) cd_tempo_causa_2, ------------------------------------------------------- Não utilizado no fonte */


    upper(a.cd_tempo_causa_1a) ie_tipo_causa_2, /*CVETPO_C2 - claveTiempo2 */

    upper(null) ds_causa_2a, /* -------------------------------------------------------Não está mais em tela */

    upper(null) qt_tempo_causa_2a, /*-------------------------------------------------- Não está mais em tela */

    upper(null) cd_causa_2a, /* ------------------------------------------------------- Não está mais em tela */

    upper(null) cd_tempo_causa_2a, /* --------------------------------------------------Não está mais em tela */

    upper(a.ds_causa_2) ds_causa_3, /*DESCAUSA3 - descripcionCausa3*/

    upper(a.qt_tempo_causa_2) qt_tempo_causa_3, /*TIEMPO_C3 - tiempo3*/

    upper(a.cd_causa_2) cd_causa_3, /*CAUSA3 - codigoCIECausa_3*/

    upper(a.cd_tempo_causa_2) ie_tipo_causa_3, /*CVETPO_C3 - claveTiempo2*/

    upper(null) ds_causa_3a,      /* -------------------------------------------------------Não está mais em tela */

    upper(null) qt_tempo_causa_3a,/* -------------------------------------------------------Não está mais em tela */

    upper(null) cd_causa_3a,      /* -------------------------------------------------------Não está mais em tela */

    upper(null) cd_tempo_causa_3a,/* -------------------------------------------------------Não está mais em tela */

    upper(a.ds_causa_2a) ds_causa_4, /*DESCAUSA4 - descripcionCausa4*/

    upper(a.qt_tempo_causa_2a) qt_tempo_causa_4, /*TIEMPO_C4 - tiempo4*/

    upper(a.cd_causa_2a) cd_causa_4, /*CAUSA4 - codigoCIECausa_4*/

    upper(a.cd_tempo_causa_2a) ie_tipo_causa_4, /*CVETPO_C4 - claveTiempo4*/

    upper(null) ds_causa_4a, /* -------------------------------------------------------Não está mais em tela */

    upper(null) qt_tempo_causa_4a, /* -------------------------------------------------------Não está mais em tela */

    upper(null) cd_causa_4a, /* -------------------------------------------------------Não está mais em tela */

    upper(null) cd_tempo_causa_4a, /* -------------------------------------------------------Não está mais em tela */

    upper(a.ds_causa_5) ds_causa_5, /*DESCAUSA5 - descripcionCausa5*/

    upper(a.qt_tempo_causa_5) qt_tempo_causa_5, /*TIEMPO_C5 - tiempo4*/

    upper(a.cd_causa_5) cd_causa_5, /*CAUSA5 - codigoCIECausa_5*/

    /*upper(a.cd_tempo_causa_5) cd_tempo_causa_5, ------------------------------------------------------- Não utilizado no fonte */


    upper(a.CD_TEMPO_CAUSA_5) ie_tipo_causa_5, /* CVETPO_C5 - claveTiempo5 */

    upper(null) ds_causa_5a, /* -------------------------------------------------------Não está mais em tela */

    upper(null) qt_tempo_causa_5a, /* -------------------------------------------------------Não está mais em tela */

    upper(null) cd_causa_5a, /* -------------------------------------------------------Não está mais em tela */

    upper(null) cd_tempo_causa_5a, /* -------------------------------------------------------Não está mais em tela */

    upper(a.ds_causa_5a) ds_causa_6, /* DESCAUSA6 - descripcionCausa6 */

    upper(a.qt_tempo_causa_5a) qt_tempo_causa_6, /*TIEMPO_C6 - tiempo6*/

    upper(a.cd_causa_5a) cd_causa_6, /*CAUSA6 - codigoCIECausa_6*/

    /*upper(a.cd_tempo_causa_5a) cd_tempo_causa_6,------------------------------------------------------- Não utilizado no fonte */


    upper(a.CD_TEMPO_CAUSA_5a) ie_tipo_causa_6, /*CVETPO_C6 - claveTiempo6*/

    upper(null) ds_causa_6a, /* -------------------------------------------------------Não está mais em tela */

    upper(null) qt_tempo_causa_6a, /* -------------------------------------------------------Não está mais em tela */

    upper(null) cd_causa_6a, /* -------------------------------------------------------Não está mais em tela */

    upper(null) cd_tempo_causa_6a, /* -------------------------------------------------------Não está mais em tela */

    upper(a.cd_cid_basica) cd_cid_basica, /*DEFCAUSABAS - cieCausaBasica*/

    upper(CASE WHEN a.ie_periodo_ocorr_def='-1' THEN '0'  ELSE coalesce(a.ie_periodo_ocorr_def,0) END ) as ie_periodo_ocorr_def, /*DEFDURANTE - ocorrioDuranteEmbarazo*/

    upper(CASE WHEN a.ie_gravidez_causou_morte='-1' THEN '0'  ELSE coalesce(a.ie_gravidez_causou_morte,0) END ) as ie_gravidez_causou_morte, /* DEFTPO_EMB - causaPropiaEmbarazo*/

    upper(CASE WHEN a.ie_morte_complicou_gravidez='-1' THEN '0'  ELSE coalesce(a.ie_morte_complicou_gravidez,0) END ) as ie_morte_complicou_gravidez, /*DEFCOM_EMB - causaComplicoEmbarazo*/

    upper(a.ie_tipo_acidente) ie_tipo_acidente, /*DEFPRESUNT - muerteAccidentalViolenta*/

    a.ie_obito_trabalho, /*DEFDESEMPE - ocurrioEnTrabajo*/

        upper(coalesce(a.ie_tipo_idade_def, 8)) ie_tipo_idade_def, /*DEFCLV_EDA - claveEdad*/

    upper(a.cd_lugar_acc_mg_def) cd_lugar_acc_mg_def, /*DEFLUG_OCU - sitioOcurrencia*/

    upper(a.ie_parentesco_agressor_def) ie_parentesco_agressor_def, /*DEFVIO_FAM - parentescoAgresor*/

    upper(coalesce(a.nr_notificacao_def, '8888888888')) nr_notificacao_def, /*DEFACTAMP - actaMP*/

    upper(a.ds_diagnostico_les_def) ds_diagnostico_les_def, /*DEFDESC_LES - descripcionSituacion*/

    /*upper(a.ds_endereco_ocor_acidente) ds_endereco_ocor_acidente,------------------------------------------------------- Não utilizado no fonte */


    /*upper(a.ds_bairro_ocor_acidente) ds_bairro_ocor_acidente,------------------------------------------------------- Não utilizado no fonte */


    --upper(a.cd_estado_ocor_acidente) cd_estado_ocor_acidente, /*DEFENT_ACC - entidadOcorrencia*/

    lpad(coalesce(obter_conversao_catalogo_nom('MUERTES_FETALES','ESTADO_PROVINCI','A',a.cd_estado_ocor_acidente),''),2,'0') cd_estado_ocor_acidente,
    --upper(a.cd_municipio_ocor_acidente) cd_municipio_ocor_acidente, /*DEFDEL_ACC - municipioOcurrencia*/

    lpad(coalesce(obter_conversao_catalogo_nom('MUERTES_FETALES','MUNICIPIO','A',a.cd_municipio_ocor_acidente),''),3,'0') cd_municipio_ocor_acidente,
    --upper(a.cd_localidade_ocor_acidente) cd_localidade_ocor_acidente, /*DEFLOC_ACC - localidadOcurrencia*/

    lpad(coalesce(obter_conversao_catalogo_nom('MUERTES_FETALES','LOCALIDADE_AREA','A',a.cd_localidade_ocor_acidente),''),4,'0') cd_localidade_ocor_acidente,
    upper(coalesce(w.ds_given_name,'NO ESPECIFICADO')) ds_nome_inf, /*DEFNOMBINFOR - nombreInformante*/

    upper(coalesce(w.ds_family_name,'NO ESPECIFICADO')) ds_sobrenome_pat_inf, /*DEFPATINFOR - primerApellidoInformante*/

    upper(coalesce(w.ds_component_name_1,'NO ESPECIFICADO')) ds_sobrenome_mat_inf, /*DEFMATINFOR - segundoApellidoInformante*/

    upper(a.ds_family_name_inf) ds_family_name_inf, /*DEFPARENTINFOR - parentescoInformante*/

    upper(a.ie_emissor_certif) ie_emissor_certif, /*DEFCERTIFI - certificadoPor*/

    upper(substr(ADICIONA_ZEROS_ESQUERDA(coalesce(trim(both a.nr_cedula_medico_certif), '88888888'), 6), 1, 14)) nr_cedula_medico_certif, /*DEFCEDCERTIFI - cedulaProfisional*/

    upper(coalesce(z.ds_given_name,'SE IGNORA')) ds_nome_cert, /*DEFNOMBCERTIFI - nombreCertificante*/

    upper(coalesce(z.ds_family_name,'SE IGNORA')) ds_sobrenome_pat_cert, /*DEFPATCERTI - primerApellidoCertificante */

    upper(coalesce(z.ds_component_name_1,'SE IGNORA')) ds_sobrenome_mat_cert, /*DEFMATCERTI - segundoApellidoCertificante*/

    upper(coalesce(a.nr_telefone_certif, '9999999999')) nr_telefone_certif, /*DEFTEL_CERT - telefoneCertificante*/

    /*upper(nvl(a.nr_ddi_telefone_certif, '9999999999')) nr_ddi_telefone_certif,------------------------------------------------------- Não utilizado no fonte */


    upper(coalesce(a.ds_endereco_certif, 'NO ESPECIFICADO')) ds_endereco_certif, /*DEFFIRMOCERT - nombreVialidadCertificante*/

    upper(a.ie_assinou_cert_obito) ie_assinou_cert_obito, /*DEFFIRMOCERT - firmaCertificante*/

    --upper(a.dt_cert_obito) dt_cert_obito,------------------------------------------------------- Não utilizado no fonte */

    upper(a.dt_cert_obito) dt_cert_obito,
    upper(to_char(a.dt_cert_obito, 'dd/mm/yyyy')) DT_CERTIFICADO_OBITO, /*DEFFECH_CER - fechaCertificacion*/

    upper(CASE WHEN a.IE_CONTA_REG_CIVIL='N' THEN '8888888888'  ELSE a.nr_declaracao_oficial END ) nr_declaracao_oficial, /*DEFOFICIAL - numeroJuzgado*/

    upper(CASE WHEN a.IE_CONTA_REG_CIVIL='N' THEN '8888888888'  ELSE a.ds_livro_cert_obito END ) ds_livro_cert_obito, /*DEFLIBRONUM - numeroLibro*/

    upper(CASE WHEN a.IE_CONTA_REG_CIVIL='N' THEN '8888888888'  ELSE a.nr_certificado_obito END ) nr_certificado_obito, /*DEFNACTARC - numeroActa*/

    --upper(decode(a.IE_CONTA_REG_CIVIL,'N','88',a.cd_estado_reg )) cd_estado_reg, /*DEFENT_REG - entidadeJuzgado */

    upper(CASE WHEN a.IE_CONTA_REG_CIVIL='N' THEN '88'  ELSE lpad(coalesce(obter_conversao_catalogo_nom('MUERTES_FETALES','ESTADO_PROVINCI','A',a.cd_estado_reg),'88'),2,'0') END ) cd_estado_reg,
    --upper(decode(a.IE_CONTA_REG_CIVIL,'N','888',a.cd_municipio_reg)) cd_municipio_reg, /*DEFDEL_REG - municipioJuzgado*/

    upper(CASE WHEN a.IE_CONTA_REG_CIVIL='N' THEN '888'  ELSE lpad(coalesce(obter_conversao_catalogo_nom('MUERTES_FETALES','MUNICIPIO','A',a.cd_municipio_reg),'888'),3,'0') END ) cd_municipio_reg, /*DEFDEL_REG - municipioJuzgado*/

    --upper(decode(a.IE_CONTA_REG_CIVIL,'N','8888',a.cd_localidade_reg)) cd_localidade_reg, /*DEFLOC_REG - localidadeJuzgado */

    upper(CASE WHEN a.IE_CONTA_REG_CIVIL='N' THEN '8888'  ELSE lpad(coalesce(obter_conversao_catalogo_nom('MUERTES_FETALES','LOCALIDADE_AREA','A',a.cd_localidade_reg),'8888'),4,'0') END ) cd_localidade_reg, /*DEFLOC_REG - localidadeJuzgado */

    upper(CASE WHEN a.IE_CONTA_REG_CIVIL='N' THEN '88/88/8888'  ELSE to_char(a.dt_capt_reg, 'dd/mm/yyyy') END ) dt_capt_reg, /*DEFFECH_REG - fechaRegistro */

    upper(a.ie_usuario_capt_reg) ie_usuario_capt_reg, /*DEFUSU_CRE - */

    upper(to_char(a.dt_criacao_cre, 'dd/mm/yyyy')) dt_criacao_cre, /* DEFFEC_CRE - */

    upper(a.ie_nivel_usu_capt_cre) ie_nivel_usu_capt_cre, /* DEFNIVCAPT_CRE */

    lpad(coalesce(pj.ie_tipo_inst_saude,'01'),2,'0') cd_sitio_capt_cre, /*DEFINSTCAPT_CRE */

    '01' cd_sitio_capt, /*DEFINSTCAPT*/

    --upper(a.cd_estado_capt_cre) cd_estado_capt_cre,

    lpad(coalesce(obter_conversao_catalogo_nom('MUERTES_FETALES','ESTADO_PROVINCI','A',a.cd_estado_capt_cre),''),2,'0') cd_estado_capt_cre,
    nom_obter_jurisdicao_def(null,null,(select max(x.nm_usuario) from declaracao_obito x where x.nr_atendimento = a.nr_atendimento)) cd_jurisdicao_capt_cre, /* DEFJURCAPT_CRE */

    --upper(a.cd_municipio_capt_cre) cd_municipio_capt_cre,

    lpad(coalesce(obter_conversao_catalogo_nom('MUERTES_FETALES','MUNICIPIO','A',a.cd_municipio_capt_cre),''),3,'0') cd_municipio_capt_cre,
    upper(a.cd_internacional_capt_cre) cd_internacional_capt_cre,
    null nm_usuario_mod, /* DEFUSU_MOD */

    null dt_modificacao, /* DEFFEC_MOD */

    upper(a.ie_nivel_usu_capt_cre) ie_nivel_ult_mod, /*DEFNIVCAPT */

    null cd_estado_ult_mod, /*DEFEDOCAPT */

    nom_obter_jurisdicao_def(null,null,a.nm_usuario)  cd_jurisdicao_capt_reg, /*DEFJURCAPT */

    null cd_municipio_capt_reg, /* DEFMPOCAPT */

    null cd_clues_mod_reg, /*DEFCLUESCAPT */

    upper(a.ie_tipo_certif_obt) ie_tipo_certif_obt,
    --upper(a.ie_vig_epidemiologica) ie_vig_epidemiologica,

    ('N') ie_vig_epidemiologica,
    upper(a.ie_morte_materna) ie_morte_materna,
    upper(null) as dt_captura, --a.dt_captura,
    '0' ie_retificado,
    upper(a.ie_bloq_perfil_fed) ie_bloq_perfil_fed,
    upper(a.ie_bloq_perfil_est) ie_bloq_perfil_est,
    upper(a.ie_controle_interno) ie_controle_interno,
    lpad(coalesce(obter_conversao_catalogo_nom('MUERTES_FETALES','ESTADO_PROVINCI','A', a.CD_ESTADO_NASC),''),2,'0') cd_estado_nasc,
    coalesce(upper(a.ds_nacionalidade),'NO APLICA') ds_nacionalidade, /*DEFNACIONESPE */

        --upper(lpad(nvl(a.cd_tipo_vialidad_def, '99'), 2, '0')) cd_tipo_vialidad_def,

    lpad(coalesce(obter_conversao_catalogo_nom('MUERTES_FETALES','TIPO_LOGRAD','A',a.cd_tipo_vialidad_def),'99'),2,'0') cd_tipo_vialidad_def,
        upper(substr(coalesce(a.nr_exterior_hab, 'SIN NUMERO'), 1, 10)) nr_exterior_hab,
        upper(coalesce(substr(a.nr_interior_hab, 1, 5), 'SIN NUMERO')) nr_interior_hab,
        --upper(lpad(decode(a.cd_tipo_asentamiento_hab, '99', '88', a.cd_tipo_asentamiento_hab), 2, '0')) cd_tipo_asentamiento_hab,

    lpad(coalesce(obter_conversao_catalogo_nom('MUERTES_FETALES','TIPO_BAIRRO','A',lpad(CASE WHEN a.cd_tipo_asentamiento_hab='99' THEN  '88'  ELSE a.cd_tipo_asentamiento_hab END , 2, '0')),'99'),2,'0') cd_tipo_asentamiento_hab,
        upper(substr(Elimina_Acentuacao(trim(both coalesce(a.ds_bairro_hab_def, 'NO ESPECIFICADO'))), 1, 100)) ds_bairro_hab_def,
        upper(substr(trim(both coalesce(a.cd_codigo_postal_hab, '00000')), 1, 5)) cd_codigo_postal_hab,
        upper(coalesce(a.qt_idade_def, 999)) qt_idade_def,
        upper(coalesce(a.qt_semanas_gestacao, '99')) qt_semanas_gestacao,
    upper(coalesce(CASE WHEN a.qt_peso_gramas='9999' THEN '8888'  ELSE a.qt_peso_gramas END , '8888')) qt_peso_gramas,
        upper(coalesce(a.ds_espc_cert, 'NO APLICA')) ds_espc_cert,
        --upper(nvl(a.cd_entidade_cert, '00')) cd_entidade_cert,

    lpad(coalesce(obter_conversao_catalogo_nom('MUERTES_FETALES','ESTADO_PROVINCI','A',a.cd_entidade_cert),'00'),2,'0') cd_entidade_cert,
        --upper(nvl(a.cd_municipio_cert, '999')) cd_munideftpo_embcipio_cert,

    lpad(coalesce(obter_conversao_catalogo_nom('MUERTES_FETALES','MUNICIPIO','A',a.cd_municipio_cert),'999'),3,'0') cd_munideftpo_embcipio_cert,
        --upper(nvl(a.cd_localidade_cert, '9999')) cd_localidade_cert,

    lpad(coalesce(obter_conversao_catalogo_nom('MUERTES_FETALES','LOCALIDADE_AREA','A',a.cd_localidade_cert),'9999'),4,'0') cd_localidade_cert,
        upper(coalesce(a.cd_codigo_postal_cert, '00000')) cd_codigo_postal_cert,
        --upper(lpad(nvl(a.cd_tipo_vialidad_cert, '99'),2,'00')) cd_tipo_vialidad_cert,

    lpad(coalesce(obter_conversao_catalogo_nom('MUERTES_FETALES','TIPO_LOGRAD','A',a.cd_tipo_vialidad_cert),'99'),2,'0') cd_tipo_vialidad_cert,
        upper(coalesce(a.nr_exterior_cert, 'SIN NUMERO')) nr_exterior_cert,
        upper(coalesce(a.nr_interior_cert, 'SIN NUMERO')) nr_interior_cert,
        --upper(lpad(nvl(a.cd_tipo_asentamiento_cert, '46'),2,'00')) cd_tipo_asentamiento_cert,

    lpad(coalesce(obter_conversao_catalogo_nom('MUERTES_FETALES','TIPO_BAIRRO','A',a.cd_tipo_asentamiento_cert),'00'),2,'0') cd_tipo_asentamiento_cert,
        upper(coalesce(a.ds_asentamiento_cert, 'NO ESPECIFICADO')) ds_bairro_cert,
        upper(coalesce(a.ie_ignorar_cp_cert, '2')) ie_ignorar_cp_cert,
        --upper(lpad(a.CD_TIPO_VIALIDAD_DEF,2,'00')) cd_tipo_vialidad_ocor_def,

    lpad(coalesce(obter_conversao_catalogo_nom('MUERTES_FETALES','TIPO_LOGRAD','A',a.CD_TIPO_VIALIDAD_DEF),'00'),2,'0') cd_tipo_vialidad_ocor_def,
        upper(a.nr_exterior_def) NR_EXTERIOR_OCOR_DEF,
        upper(a.nr_interior_def) NR_INTERIOR_OCOR_DEF,
        --upper(lpad(a.CD_TIPO_ASENTAMIENTO_DEF,2,'00')) cd_tipo_asent_ocor_def,

    lpad(coalesce(obter_conversao_catalogo_nom('MUERTES_FETALES','TIPO_BAIRRO','A',a.CD_TIPO_ASENTAMIENTO_DEF),'00'),2,'0') cd_tipo_asent_ocor_def,
        upper(a.CD_CODIGO_POSTAL_DEF) cd_cp_ocor_def,
        --upper(lpad(a.cd_tipo_vialidad_acc,2,'00')) cd_tipo_vialidad_acc,

    lpad(CASE WHEN coalesce(obter_conversao_catalogo_nom('MUERTES_FETALES','TIPO_LOGRAD','A',a.cd_tipo_vialidad_acc),'44')='00' THEN 97  ELSE coalesce(obter_conversao_catalogo_nom('MUERTES_FETALES','TIPO_LOGRAD','A',a.cd_tipo_vialidad_acc),'44') END  ,2,'0') cd_tipo_vialidad_acc,
        upper(coalesce(a.DS_ENDERECO_OCOR_ACIDENTE,'NO APLICA')) ds_tipo_vialidad_acc, /* DEFNOMVIA_ACC - nombreVialidadAccidente */

        upper(a.nr_exterior_acc) nr_exterior_acc,
        upper(a.nr_interior_acc) nr_interior_acc,
        --upper(lpad(a.cd_tipo_asentamiento_acc,2,'00')) cd_tipo_asentamiento_acc,

    lpad(CASE WHEN coalesce(obter_conversao_catalogo_nom('MUERTES_FETALES','TIPO_BAIRRO','A',a.cd_tipo_asentamiento_acc),'00')=97 THEN  44  ELSE coalesce(obter_conversao_catalogo_nom('MUERTES_FETALES','TIPO_BAIRRO','A',a.cd_tipo_asentamiento_acc),'00') END ,2,'0')  cd_tipo_asentamiento_acc,
    upper(coalesce(a.DS_BAIRRO_OCOR_ACIDENTE, 'NO APLICA')) ds_tipo_asentamiento_acc, /*DEFNOMASEN_ACC - nombreAsentamientoAccidente*/

    upper(a.cd_codigo_postal_acc) cd_codigo_postal_acc,
        '88888888' IMAGRE_MED ,
        '8888' IMUNI_ADSC,
        '88888888' IMUNI_ATEN,
        '88' IMSERYESP_MED ,
        '88' IMSSDELEGA_CAPT ,
        '9997' IMSSCLAVEPRE_CAPT
FROM pessoa_juridica pj, estabelecimento estab, atendimento_paciente atend, guia_morte_noms a
LEFT OUTER JOIN person_name b ON (a.nr_seq_person_name_def = b.nr_sequencia AND 'main' = b.ds_type)
LEFT OUTER JOIN person_name w ON (a.nr_seq_person_name_inf = w.nr_sequencia AND 'main' = w.ds_type)
LEFT OUTER JOIN person_name z ON (a.nr_seq_person_name_cert = z.nr_sequencia AND 'main' = z.ds_type)
WHERE a.nr_atendimento = atend.nr_atendimento and pj.cd_cgc = estab.cd_cgc and estab.cd_estabelecimento = atend.cd_estabelecimento and a.dt_liberacao is not null;

