-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_mipres_establishment_info ( ie_opcao_p text default 'N') RETURNS varchar AS $body$
DECLARE


	cd_cgc_w	estabelecimento.cd_cgc%type;
    cd_rfc_w    pessoa_juridica.cd_rfc%type;
    ds_retorno_w			varchar(255)  := null;



BEGIN

    if (ie_opcao_p = 'N') then
        cd_cgc_w := obter_cgc_estabelecimento(wheb_usuario_pck.get_cd_estabelecimento);
        cd_rfc_w := obter_dados_pf_pj(null, cd_cgc_w, 'RFC');
        ds_retorno_w := cd_rfc_w;
    elsif (ie_opcao_p = 'T') then
        select max(cd_token_integracao)
        into STRICT ds_retorno_w
        from integracao_mipres_conf
        where cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;
    end if;

    return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_mipres_establishment_info ( ie_opcao_p text default 'N') FROM PUBLIC;

