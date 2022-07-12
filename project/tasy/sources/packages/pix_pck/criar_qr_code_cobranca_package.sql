-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pix_pck.criar_qr_code_cobranca (valor_cobranca_p bigint, ds_chave_p text, cd_pessoa_fisica_p text default '', cd_pessoa_juridica_p text default '', ds_cidade_cobranca_p text DEFAULT NULL, ds_url_payload_p text DEFAULT NULL) RETURNS varchar AS $body$
DECLARE

    ds_qr_code_w varchar(999);
    ds_nome_cobrador_w varchar(100);


BEGIN

        if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
            select  OBTER_NOME_PESSOA_FISICA(cd_pessoa_fisica_p, '')
            into STRICT    ds_nome_cobrador_w
;
        else      
            select OBTER_NOME_FANTASIA_PJ(cd_pessoa_juridica_p)
            into STRICT   ds_nome_cobrador_w
;
        end if;

        ds_qr_code_w := '000201' ||
                        '26' || (LENGTH(ds_url_payload_p) + 22) ||
                        '0014BR.GOV.BCB.PIX' ||
                        '25' || LENGTH(ds_url_payload_p) || ds_url_payload_p ||
                        '52040000' ||
                        '5303986' || 
                        '540' || LENGTH(TO_CHAR(valor_cobranca_p, 'FM99999.00')) || TO_CHAR(valor_cobranca_p, 'FM99999.00') ||
                        '5802BR' ||
                        '59' || LENGTH(substr(ds_nome_cobrador_w,0,25)) || substr(ELIMINA_ACENTOS(ds_nome_cobrador_w, 'S'),0,25) ||
                        '600' || LENGTH(ds_cidade_cobranca_p) || ELIMINA_ACENTOS(ds_cidade_cobranca_p, 'S') ||
                        '6207' ||
                        '0503***';

        return ds_qr_code_w || pix_pck.crc16(ds_qr_code_w);

    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pix_pck.criar_qr_code_cobranca (valor_cobranca_p bigint, ds_chave_p text, cd_pessoa_fisica_p text default '', cd_pessoa_juridica_p text default '', ds_cidade_cobranca_p text DEFAULT NULL, ds_url_payload_p text DEFAULT NULL) FROM PUBLIC;
