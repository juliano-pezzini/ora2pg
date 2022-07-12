-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_acao_dispositivo ( nr_seq_dispositivo_p bigint, ie_opcao_disp_p text, nr_seq_acao_disp_p bigint ) RETURNS varchar AS $body$
DECLARE

    ds_texto_w varchar(4000);

BEGIN
    ds_texto_w := '';

    if (ie_opcao_disp_p = 'P') then
        ds_texto_w := substr(obter_desc_proc_interno(nr_seq_acao_disp_p), 1, 100);
    elsif (ie_opcao_disp_p = 'SAE') then
        ds_texto_w := substr(obter_desc_intervencoes(nr_seq_acao_disp_p), 1, 100);
    end if;

     return ds_texto_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_acao_dispositivo ( nr_seq_dispositivo_p bigint, ie_opcao_disp_p text, nr_seq_acao_disp_p bigint ) FROM PUBLIC;
