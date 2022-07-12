-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_parametro_aih ( ds_campo_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(255);

c01 CURSOR FOR
	SELECT	cd_acervo,
		cd_cnes_hospital,
		cd_diretor_clinico,
		cd_diretor_tecnico,
		cd_estabelecimento,
		cd_interface_envio,
		cd_medico_autorizador,
		cd_medico_responsavel,
		cd_municipio_ibge,
		cd_orgao_emissor_aih,
		cd_prestador_laudo_ach,
		ds_carater_incremento,
		ie_ajusta_atend_dest,
		ie_alterar_sp_proc_rim,
		ie_arred_sp_sisaih,
		ie_diaria_uti,
		ie_exp_cnpj_fornec_fabric,
		ie_exporta_cnes,
		ie_exporta_cnes_hosp,
		ie_exporta_cnes_setor,
		ie_exporta_resp,
		ie_forma_calculo_sadt,
		ie_forma_envio_data_proc,
		ie_gera_aih_laudo_tranf,
		ie_gera_longa_perm,
		ie_gerar_partic_cirurg,
		ie_ignora_participou_sus,
		ie_incemento_seq_onco,
		ie_inc_proc_conta,
		ie_inc_proc_urg_aih,
		ie_incremento_anestesista,
		ie_momento_rateio_sh,
		ie_ordem_telefone_pac,
		ie_ordena_proc_valor,
		ie_proc_princ_receb_sh,
		ie_repasse_proc,
		ie_vincular_laudo_atend_ext,
		ie_vincular_laudo_atend_ps,
		ie_vincular_laudo_tipo_atend,
		nr_nac_serventia,
		nr_tipo_livro,
		pr_cesariana_permitida,
		pr_ivh,
		pr_urg_emerg,
		qt_max_diaria_enferm,
		qt_max_diaria_uti,
		vl_incremento_pnash,
		ie_consist_proc_onco_prot,
		ie_restringe_cid_proc,
		ie_transf_diag_interna_bpa,
		ie_clinica_laudo_int_bpa
	from	sus_parametros_aih
	where	cd_estabelecimento	= cd_estabelecimento_p;

c01_w c01%rowtype;


BEGIN

open c01;
loop
fetch c01 into
	c01_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
end loop;
close c01;

if (upper(ds_campo_p)	= 'IE_IGNORA_PARTICIPOU_SUS') then
	ds_retorno_w	:= coalesce(c01_w.ie_ignora_participou_sus,'N');
elsif (upper(ds_campo_p)	= 'IE_EXP_CNPJ_FORNEC_FABRIC') then
	ds_retorno_w	:= coalesce(c01_w.ie_exp_cnpj_fornec_fabric,'N');
elsif (upper(ds_campo_p)	= 'QT_MAX_DIARIA_UTI') then
	ds_retorno_w	:= coalesce(c01_w.qt_max_diaria_uti,0);
elsif (upper(ds_campo_p)	= 'QT_MAX_DIARIA_ENFERM') then
	ds_retorno_w	:= coalesce(c01_w.qt_max_diaria_enferm,0);
elsif (upper(ds_campo_p)	= 'CD_ACERVO') then
	ds_retorno_w	:= coalesce(c01_w.cd_acervo,'');
elsif (upper(ds_campo_p)	= 'CD_CNES_HOSPITAL') then
	ds_retorno_w	:= coalesce(c01_w.cd_cnes_hospital,'');
elsif (upper(ds_campo_p)	= 'CD_DIRETOR_CLINICO') then
	ds_retorno_w	:= coalesce(c01_w.cd_diretor_clinico,'');
elsif (upper(ds_campo_p)	= 'CD_DIRETOR_TECNICO') then
	ds_retorno_w	:= coalesce(c01_w.cd_diretor_tecnico,'');
elsif (upper(ds_campo_p)	= 'CD_INTERFACE_ENVIO') then
	ds_retorno_w	:= coalesce(c01_w.cd_interface_envio,0);
elsif (upper(ds_campo_p)	= 'CD_MEDICO_AUTORIZADOR') then
	ds_retorno_w	:= coalesce(c01_w.cd_medico_autorizador,'');
elsif (upper(ds_campo_p)	= 'CD_MEDICO_RESPONSAVEL') then
	ds_retorno_w	:= coalesce(c01_w.cd_medico_responsavel,'');
elsif (upper(ds_campo_p)	= 'CD_MUNICIPIO_IBGE') then
	ds_retorno_w	:= coalesce(c01_w.cd_municipio_ibge,'');
elsif (upper(ds_campo_p)	= 'CD_ORGAO_EMISSOR_AIH') then
	ds_retorno_w	:= coalesce(c01_w.cd_orgao_emissor_aih,'');
elsif (upper(ds_campo_p)	= 'CD_PRESTADOR_LAUDO_ACH') then
	ds_retorno_w	:= coalesce(c01_w.cd_prestador_laudo_ach,'');
elsif (upper(ds_campo_p)	= 'DS_CARATER_INCREMENTO') then
	ds_retorno_w	:= coalesce(c01_w.ds_carater_incremento,'');
elsif (upper(ds_campo_p)	= 'IE_AJUSTA_ATEND_DEST') then
	ds_retorno_w	:= coalesce(c01_w.ie_ajusta_atend_dest,'N');
elsif (upper(ds_campo_p)	= 'IE_ALTERAR_SP_PROC_RIM') then
	ds_retorno_w	:= coalesce(c01_w.ie_alterar_sp_proc_rim,'N');
elsif (upper(ds_campo_p)	= 'IE_ARRED_SP_SISAIH') then
	ds_retorno_w	:= coalesce(c01_w.ie_arred_sp_sisaih,'N');
elsif (upper(ds_campo_p)	= 'IE_DIARIA_UTI') then
	ds_retorno_w	:= coalesce(c01_w.ie_diaria_uti,'N');
elsif (upper(ds_campo_p)	= 'IE_EXPORTA_CNES') then
	ds_retorno_w	:= coalesce(c01_w.ie_exporta_cnes,'N');
elsif (upper(ds_campo_p)	= 'IE_EXPORTA_CNES_HOSP') then
	ds_retorno_w	:= coalesce(c01_w.ie_exporta_cnes_hosp,'N');
elsif (upper(ds_campo_p)	= 'IE_EXPORTA_CNES_SETOR') then
	ds_retorno_w	:= coalesce(c01_w.ie_exporta_cnes_setor,'N');
elsif (upper(ds_campo_p)	= 'IE_EXPORTA_RESP') then
	ds_retorno_w	:= coalesce(c01_w.ie_exporta_resp,'C');
elsif (upper(ds_campo_p)	= 'IE_FORMA_CALCULO_SADT') then
	ds_retorno_w	:= coalesce(c01_w.ie_forma_calculo_sadt,'P');
elsif (upper(ds_campo_p)	= 'IE_FORMA_ENVIO_DATA_PROC') then
	ds_retorno_w	:= coalesce(c01_w.ie_forma_envio_data_proc,'P');
elsif (upper(ds_campo_p)	= 'IE_GERA_AIH_LAUDO_TRANF') then
	ds_retorno_w	:= coalesce(c01_w.ie_gera_aih_laudo_tranf,'N');
elsif (upper(ds_campo_p)	= 'IE_GERA_LONGA_PERM') then
	ds_retorno_w	:= coalesce(c01_w.ie_gera_longa_perm,'N');
elsif (upper(ds_campo_p)	= 'IE_GERAR_PARTIC_CIRURG') then
	ds_retorno_w	:= coalesce(c01_w.ie_gerar_partic_cirurg,'N');
elsif (upper(ds_campo_p)	= 'IE_INCEMENTO_SEQ_ONCO') then
	ds_retorno_w	:= coalesce(c01_w.ie_incemento_seq_onco,'N');
elsif (upper(ds_campo_p)	= 'IE_INC_PROC_CONTA') then
	ds_retorno_w	:= coalesce(c01_w.ie_inc_proc_conta,'N');
elsif (upper(ds_campo_p)	= 'IE_INC_PROC_URG_AIH') then
	ds_retorno_w	:= coalesce(c01_w.ie_inc_proc_urg_aih,'S');
elsif (upper(ds_campo_p)	= 'IE_INCREMENTO_ANESTESISTA') then
	ds_retorno_w	:= coalesce(c01_w.ie_incremento_anestesista,'N');
elsif (upper(ds_campo_p)	= 'IE_MOMENTO_RATEIO_SH') then
	ds_retorno_w	:= coalesce(c01_w.ie_momento_rateio_sh,'P');
elsif (upper(ds_campo_p)	= 'IE_ORDEM_TELEFONE_PAC') then
	ds_retorno_w	:= coalesce(c01_w.ie_ordem_telefone_pac,'TC');
elsif (upper(ds_campo_p)	= 'IE_ORDENA_PROC_VALOR') then
	ds_retorno_w	:= coalesce(c01_w.ie_ordena_proc_valor,'N');
elsif (upper(ds_campo_p)	= 'IE_PROC_PRINC_RECEB_SH') then
	ds_retorno_w	:= coalesce(c01_w.ie_proc_princ_receb_sh,'S');
elsif (upper(ds_campo_p)	= 'IE_REPASSE_PROC') then
	ds_retorno_w	:= coalesce(c01_w.ie_repasse_proc,'');
elsif (upper(ds_campo_p)	= 'IE_VINCULAR_LAUDO_ATEND_EXT') then
	ds_retorno_w	:= coalesce(c01_w.ie_vincular_laudo_atend_ext,'N');
elsif (upper(ds_campo_p)	= 'IE_VINCULAR_LAUDO_ATEND_PS') then
	ds_retorno_w	:= coalesce(c01_w.ie_vincular_laudo_atend_ps,'N');
elsif (upper(ds_campo_p)	= 'IE_VINCULAR_LAUDO_TIPO_ATEND') then
	ds_retorno_w	:= coalesce(c01_w.ie_vincular_laudo_tipo_atend,'N');
elsif (upper(ds_campo_p)	= 'NR_NAC_SERVENTIA') then
	ds_retorno_w	:= coalesce(c01_w.nr_nac_serventia,0);
elsif (upper(ds_campo_p)	= 'NR_TIPO_LIVRO') then
	ds_retorno_w	:= coalesce(c01_w.nr_tipo_livro,0);
elsif (upper(ds_campo_p)	= 'PR_CESARIANA_PERMITIDA') then
	ds_retorno_w	:= coalesce(c01_w.pr_cesariana_permitida,0);
elsif (upper(ds_campo_p)	= 'PR_IVH') then
	ds_retorno_w	:= coalesce(c01_w.pr_ivh,0);
elsif (upper(ds_campo_p)	= 'PR_URG_EMERG') then
	ds_retorno_w	:= coalesce(c01_w.pr_urg_emerg,0);
elsif (upper(ds_campo_p)	= 'VL_INCREMENTO_PNASH') then
	ds_retorno_w	:= coalesce(c01_w.vl_incremento_pnash,0);
elsif (upper(ds_campo_p)	= 'IE_CONSIST_PROC_ONCO_PROT') then
	ds_retorno_w	:= coalesce(c01_w.ie_consist_proc_onco_prot,'N');
elsif (upper(ds_campo_p)	= 'IE_RESTRINGE_CID_PROC') then
	ds_retorno_w	:= coalesce(c01_w.ie_restringe_cid_proc,'N');
elsif (upper(ds_campo_p)	= 'IE_TRANSF_DIAG_INTERNA_BPA') then
	ds_retorno_w	:= coalesce(c01_w.ie_transf_diag_interna_bpa,'N');
elsif (upper(ds_campo_p)	= 'IE_CLINICA_LAUDO_INT_BPA') then
	ds_retorno_w	:= coalesce(c01_w.ie_clinica_laudo_int_bpa,'N');
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_parametro_aih ( ds_campo_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
