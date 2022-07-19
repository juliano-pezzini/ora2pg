-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sams_import_pf (DS_JSON_P text, CD_PESSOA_FISICA_OUT_P INOUT text) AS $body$
DECLARE

    
    json_lista_w philips_json_list;
    registro_w   philips_json;

    nm_usuario_w pessoa_fisica.nm_usuario%TYPE := 'SAMS';
    nm_usuario_nrec_w pessoa_fisica.nm_usuario_nrec%TYPE := 'SAMS';
    dt_atualizacao_w pessoa_fisica.dt_atualizacao%TYPE := clock_timestamp();
    dt_atualizacao_nrec_w pessoa_fisica.dt_atualizacao_nrec%TYPE := clock_timestamp();
    ie_tipo_pessoa_w pessoa_fisica.ie_tipo_pessoa%TYPE := 2;
    ie_revisar_w pessoa_fisica.ie_revisar%TYPE := 'N';
    cd_sistema_ant_w pessoa_fisica.cd_sistema_ant%TYPE;
    nm_pessoa_fisica_w pessoa_fisica.nm_pessoa_fisica%TYPE;
    dt_nascimento_w pessoa_fisica.dt_nascimento%TYPE;
    ie_sexo_w pessoa_fisica.ie_sexo%TYPE;
    nr_ddd_celular_w pessoa_fisica.nr_ddd_celular%TYPE;
    nr_telefone_celular_w pessoa_fisica.nr_telefone_celular%TYPE;
    nm_social_w pessoa_fisica.nm_social%TYPE;
    nr_cpf_w pessoa_fisica.nr_cpf%TYPE;
    nr_identidade_w pessoa_fisica.nr_identidade%TYPE;
    nr_cartao_nac_sus_w pessoa_fisica.nr_cartao_nac_sus%TYPE;

    ie_tipo_complemento_w compl_pessoa_fisica.ie_tipo_complemento%TYPE := 1;
    cd_pessoa_fisica_w compl_pessoa_fisica.cd_pessoa_fisica%TYPE;
    ds_endereco_w compl_pessoa_fisica.ds_endereco%TYPE;
    nm_contato_w compl_pessoa_fisica.nm_contato%TYPE;
    ds_municipio_w compl_pessoa_fisica.ds_municipio%TYPE;
    ds_bairro_w compl_pessoa_fisica.ds_bairro%TYPE;
    nr_telefone_w compl_pessoa_fisica.nr_telefone%TYPE;
    nr_endereco_w compl_pessoa_fisica.nr_endereco%TYPE;
    ds_fone_adic_w compl_pessoa_fisica.ds_fone_adic%TYPE;
    cd_municipio_ibge_w compl_pessoa_fisica.cd_municipio_ibge%TYPE;
    nr_sequencia_w compl_pessoa_fisica.nr_sequencia%TYPE;


BEGIN
    json_lista_w := philips_json_list(ds_json_p);
    IF json_lista_w.count() > 0 THEN
        registro_w := philips_json(json_lista_w.get(1));

        IF registro_w.exist('PAC_NUM_CADASTRO') THEN
            cd_sistema_ant_w := registro_w.get['PAC_NUM_CADASTRO'].get_string;
        END IF;

        IF registro_w.exist('PAC_CPF') THEN
            nr_cpf_w := registro_w.get['PAC_CPF'].get_string;
        END IF;
    
        IF registro_w.exist('PAC_CARTAO_SUS') THEN
            nr_cartao_nac_sus_w := registro_w.get['PAC_CARTAO_SUS'].get_string;
        END IF;

        IF registro_w.exist('PAC_NOME_PACIENTE') THEN
            nm_pessoa_fisica_w := registro_w.get['PAC_NOME_PACIENTE'].get_string;
        END IF;

        IF registro_w.exist('PAC_DATA_NASCIMENTO') THEN
            dt_nascimento_w := to_date(registro_w.get['PAC_DATA_NASCIMENTO'].get_string, 'DD/MM/YYYY HH24:MI:SS');
        END IF;

        SELECT sams_busca_pessoa_fisica(cd_sistema_ant_w,nr_cpf_w, nr_cartao_nac_sus_w, nm_pessoa_fisica_w, dt_nascimento_w) 
            INTO STRICT cd_pessoa_fisica_out_p 
;

        IF coalesce(cd_pessoa_fisica_out_p::text, '') = '' THEN
            
            IF registro_w.exist('PAC_ENDERECO') THEN
                ds_endereco_w := registro_w.get['PAC_ENDERECO'].get_string;
            END IF;

            IF registro_w.exist('PAC_NOME_MAE') THEN
                nm_contato_w := registro_w.get['PAC_NOME_MAE'].get_string;
            END IF;

            IF registro_w.exist('MUN_DESCRICAO') THEN
                ds_municipio_w := registro_w.get['MUN_DESCRICAO'].get_string;
            END IF;

            IF registro_w.exist('BAI_DESCRICAO') THEN
                ds_bairro_w := registro_w.get['BAI_DESCRICAO'].get_string;
            END IF;

            IF registro_w.exist('PAC_TELEFONE') THEN
                nr_telefone_w := registro_w.get['PAC_TELEFONE'].get_string;
            END IF;

            IF registro_w.exist('PAC_NUMERO_ENDERECO') THEN
                nr_endereco_w := registro_w.get['PAC_NUMERO_ENDERECO'].get_string;
            END IF;

            IF registro_w.exist('PAC_SEXO') THEN
                ie_sexo_w := registro_w.get['PAC_SEXO'].get_string;
            END IF;

            IF registro_w.exist('PAC_CELULAR_DDD') THEN
                nr_ddd_celular_w := registro_w.get['PAC_CELULAR_DDD'].get_string;
            END IF;

            IF registro_w.exist('PAC_CELULAR') THEN
                nr_telefone_celular_w := registro_w.get['PAC_CELULAR'].get_string;
            END IF;

            IF registro_w.exist('PAC_CELULAR2') THEN
                ds_fone_adic_w := registro_w.get['PAC_SEXO'].get_string;
            END IF;

            IF registro_w.exist('MUN_CODIGO') THEN
                cd_municipio_ibge_w := substr(obter_conversao_interna_int(NULL, 'COMPL_PESSOA_FISICA', 'CD_MUNICIPIO_IBGE', registro_w.get['MUN_CODIGO'].get_string, 'SAMS'), 1, 6);
            END IF;

            IF registro_w.exist('PAC_NOME_SOCIAL') THEN
                nm_social_w := registro_w.get['PAC_NOME_SOCIAL'].get_string;
            END IF;

            IF registro_w.exist('PAC_RG') THEN
                nr_identidade_w := registro_w.get['PAC_RG'].get_string;
            END IF;

            SELECT nextval('pessoa_fisica_seq') 
                INTO STRICT cd_pessoa_fisica_out_p 
;

            SELECT COUNT(1) + 1
                INTO STRICT nr_sequencia_w
                FROM compl_pessoa_fisica
                WHERE cd_pessoa_fisica = cd_pessoa_fisica_out_p;

            BEGIN    
                INSERT INTO pessoa_fisica(cd_pessoa_fisica,
                    nm_usuario,
                    nm_usuario_nrec,
                    dt_atualizacao,
                    dt_atualizacao_nrec,
                    ie_tipo_pessoa,
                    ie_revisar,
                    cd_sistema_ant,
                    nm_pessoa_fisica,
                    dt_nascimento,
                    ie_sexo,
                    nr_ddd_celular,
                    nr_telefone_celular,
                    nm_social,
                    nr_cpf,
                    nr_identidade,
                    nr_cartao_nac_sus)
                VALUES (cd_pessoa_fisica_out_p, 
                    nm_usuario_w,
                    nm_usuario_nrec_w,
                    dt_atualizacao_w,
                    dt_atualizacao_nrec_w,
                    ie_tipo_pessoa_w,
                    ie_revisar_w,
                    cd_sistema_ant_w,
                    nm_pessoa_fisica_w,
                    dt_nascimento_w,
                    obter_conversao_interna_int(NULL, 'PESSOA_FISICA', 'IE_SEXO', ie_sexo_w, 'SAMS'),
                    nr_ddd_celular_w,
                    nr_telefone_celular_w,
                    nm_social_w,
                    nr_cpf_w,
                    nr_identidade_w,
                    nr_cartao_nac_sus_w);

                INSERT INTO compl_pessoa_fisica(cd_pessoa_fisica,
                    nm_usuario,
                    nm_usuario_nrec,
                    dt_atualizacao,
                    dt_atualizacao_nrec,
                    ie_tipo_complemento,
                    ds_endereco,
                    nm_contato,
                    ds_municipio,
                    ds_bairro,
                    nr_telefone,
                    nr_endereco,
                    ds_fone_adic,
                    cd_municipio_ibge,
                    nr_sequencia)
                VALUES (cd_pessoa_fisica_out_p,
                    nm_usuario_w,
                    nm_usuario_nrec_w,
                    dt_atualizacao_w,
                    dt_atualizacao_nrec_w,
                    ie_tipo_complemento_w,
                    ds_endereco_w,
                    nm_contato_w,
                    ds_municipio_w,
                    ds_bairro_w,
                    nr_telefone_w,
                    nr_endereco_w,
                    ds_fone_adic_w,
                    cd_municipio_ibge_w,
                    nr_sequencia_w);
                COMMIT;
            EXCEPTION
                WHEN OTHERS THEN
                    cd_pessoa_fisica_out_p := NULL;
            END;
        END IF;
    END IF;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sams_import_pf (DS_JSON_P text, CD_PESSOA_FISICA_OUT_P INOUT text) FROM PUBLIC;

