-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_dados_pf_unimedrio ( CD_MUNICIPIO_IBGE_p text, NR_CPF_p text, DT_CADASTRO_ORIGINAL_p text, DT_EMISSAO_CERT_NASC_p text, IE_ESTADO_CIVIL_p text, FK_TP_ESC_p text, NR_IDENTIDADE_p text, BLOQ_MODIF_EMP_p text, COD_CON_p text, CD_EMPRESA_p text, COD_PLAN_p text, DH_VALIDADE_MATRICULA_p text, MATRICULA_p text, MATRICULA_TITULAR_p text, SN_MATRICULA_ATIVA_p text, CD_CEP_p text, DS_ENDERECO_p text, NR_ENDERECO_p text, DS_COMPLEMENTO_p text, DS_BAIRRO_p text, DS_MUNICIPIO_p text, SG_ESTADO_p text, DT_NASCIMENTO_p text, NOME_MAE_p text, NM_PESSOA_FISICA_p text, NOME_PAI_p text, NR_PIS_PASEP_p text, IE_SEXO_p text, nm_usuario_p text, nr_prontuario_p text) AS $body$
DECLARE



--     TASY                             -- XML
/*CD_MUNICIPIO_IBGE     =       CO_IBGE_MUNI_NASC
   NR_CPF                       =       CPF
    DT_CADASTRO_ORIGINAL        =       DATA_ABERTU
    DT_EMISSAO_CERT_NASC        =       DATA_EMISS_ID
    IE_ESTADO_CIVIL             =       EST_CIVIL
    FK_TP_ESC           =       FK_TP_ESC               ****
    NR_IDENTIDADE               =       IDENTIDADE
    BLOQ_MODIF_EMP              =       BLOQ_MODIF_EMP  ****
    COD_CON             =       COD_CON         ****
    CD_EMPRESA          =       COD_EMPRESA
    COD_PLAN            =       COD_PLAN                ****
    DH_VALIDADE_MATRICULA       =       DH_VALIDADE_MATRICULA  ****
    MATRICULA           =       MATRICULA       ****
    MATRICULA_TITULAR   =       MATRICULA_TITULAR       ****
    SN_MATRICULA_ATIVA  =       SN_MATRICULA_ATIVA ****
    CD_CEP                      =       CO_CEP
    DS_ENDERECO         =       NO_LOGRADOURO
    NR_ENDERECO         =       DS_NUMERO
   DS_COMPLEMENTO               =       DS_COMPLEMENTO
   DS_BAIRRO            =       NO_BAIRRO
   DS_MUNICIPIO         =       NO_LOCALIDADE
   SG_ESTADO            =       SG_UF
   DT_NASCIMENTO                =       NASCIMENTO
   NOME_MAE             =       NOME_MAE  ****
   NM_PESSOA_FISICA             =       NOME_PAC
   NOME_PAI             =       NOME_PAI  ****
   NR_PIS_PASEP         =       NUM_PIS_PASEP
   IE_SEXO                      =       SEXO
*/
--  **** campos não reconhecidos nas tabelas do TASY
DT_CADASTRO_ORIGINAL_w  timestamp;
DT_EMISSAO_CERT_NASC_w  timestamp;
DT_NASCIMENTO_w         timestamp;
DH_VALIDADE_MATRICULA_w timestamp;


BEGIN
DT_CADASTRO_ORIGINAL_w 	:= to_date(DT_CADASTRO_ORIGINAL_p, 'yyyy-mm-dd');
DT_EMISSAO_CERT_NASC_w 	:= to_date(DT_EMISSAO_CERT_NASC_p, 'yyyy-mm-dd');
DT_NASCIMENTO_w 	:= to_date(DT_NASCIMENTO_p, 'yyyy-mm-dd');
DH_VALIDADE_MATRICULA_w := to_date(DH_VALIDADE_MATRICULA_p, 'yyyy-mm-dd');

insert into w_integr_pf_unimedrio(CD_MUNICIPIO_IBGE,
                                        NR_CPF,
                                        DT_CADASTRO_ORIGINAL,
                                        DT_EMISSAO_CERT_NASC,
                                        IE_ESTADO_CIVIL,
                                        FK_TP_ESC,
                                        NR_IDENTIDADE,
                                        BLOQ_MODIF_EMP,
                                        COD_CON,
                                        CD_EMPRESA,
                                        COD_PLAN,
                                        DH_VALIDADE_MATRICULA,
                                        MATRICULA,
                                        MATRICULA_TITULAR,
                                        SN_MATRICULA_ATIVA,
                                        CD_CEP,
                                        DS_ENDERECO,
                                        NR_ENDERECO,
                                        DS_COMPLEMENTO,
                                        DS_BAIRRO,
                                        DS_MUNICIPIO,
                                        SG_ESTADO,
                                        DT_NASCIMENTO,
                                        NOME_MAE,
                                        NM_PESSOA_FISICA,
                                        NOME_PAI,
                                        NR_PIS_PASEP,
                                        IE_SEXO,
                                        nm_usuario,
                                        dt_atualizacao,
					nr_prontuario,
					nr_prontuario_texto)
        values (CD_MUNICIPIO_IBGE_p,
                                        NR_CPF_p,
                                        DT_CADASTRO_ORIGINAL_w,
                                        DT_EMISSAO_CERT_NASC_w,
                                        IE_ESTADO_CIVIL_p,
                                        FK_TP_ESC_p,
                                        NR_IDENTIDADE_p,
                                        BLOQ_MODIF_EMP_p,
                                        COD_CON_p,
                                        null,
					substr(COD_PLAN_p, position('-' in COD_PLAN_p) +1, length(COD_PLAN_p)), --alterado devido a OS 602797, antes estava gravando apenas COD_PLAN_p, mas agora está vindo concatenado   categoria-plano
                                        DH_VALIDADE_MATRICULA_w,
                                        MATRICULA_p,
                                        MATRICULA_TITULAR_p,
                                        SN_MATRICULA_ATIVA_p,
                                        CD_CEP_p,
                                        DS_ENDERECO_p,
                                        NR_ENDERECO_p,
                                        DS_COMPLEMENTO_p,
                                        DS_BAIRRO_p,
                                        DS_MUNICIPIO_p,
                                        SG_ESTADO_p,
                                        DT_NASCIMENTO_w,
                                        NOME_MAE_p,
                                        NM_PESSOA_FISICA_p,
                                        NOME_PAI_p,
                                        NR_PIS_PASEP_p,
                                        IE_SEXO_p,
                                        nm_usuario_p,
                                        clock_timestamp(),
					somente_numero(nr_prontuario_p),
					nr_prontuario_p);
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_dados_pf_unimedrio ( CD_MUNICIPIO_IBGE_p text, NR_CPF_p text, DT_CADASTRO_ORIGINAL_p text, DT_EMISSAO_CERT_NASC_p text, IE_ESTADO_CIVIL_p text, FK_TP_ESC_p text, NR_IDENTIDADE_p text, BLOQ_MODIF_EMP_p text, COD_CON_p text, CD_EMPRESA_p text, COD_PLAN_p text, DH_VALIDADE_MATRICULA_p text, MATRICULA_p text, MATRICULA_TITULAR_p text, SN_MATRICULA_ATIVA_p text, CD_CEP_p text, DS_ENDERECO_p text, NR_ENDERECO_p text, DS_COMPLEMENTO_p text, DS_BAIRRO_p text, DS_MUNICIPIO_p text, SG_ESTADO_p text, DT_NASCIMENTO_p text, NOME_MAE_p text, NM_PESSOA_FISICA_p text, NOME_PAI_p text, NR_PIS_PASEP_p text, IE_SEXO_p text, nm_usuario_p text, nr_prontuario_p text) FROM PUBLIC;

