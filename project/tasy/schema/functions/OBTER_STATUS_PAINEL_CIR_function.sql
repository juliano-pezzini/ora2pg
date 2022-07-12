-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_status_painel_cir ( NR_SEQ_STATUS_PAINEL_P bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/* ie_opcao
   S = Descrição do Status
   C = Cor da Fonte
   F = Cor do Fundo  */
ds_status_w            varchar(254);
ds_cor_fonte_w         varchar(254);
ds_cor_fundo_w         varchar(254);
ds_retorno_w           varchar(254) := '';



BEGIN

    if (NR_SEQ_STATUS_PAINEL_P IS NOT NULL AND NR_SEQ_STATUS_PAINEL_P::text <> '') then

        select  a.DS_STATUS,
                a.DS_COR_FONTE,
                a.DS_COR_FUNDO
        into STRICT    ds_status_w,
                ds_cor_fonte_w,
                ds_cor_fundo_w
        from    STATUS_PAINEL_AGENDA a
        where   a.nr_sequencia = NR_SEQ_STATUS_PAINEL_P;

        if ( ie_opcao_p = 'S' ) then
            ds_retorno_w := ds_status_w;
        elsif ( ie_opcao_p = 'C' ) then
            ds_retorno_w := ds_cor_fonte_w;
        elsif ( ie_opcao_p = 'F' ) then
            ds_retorno_w := ds_cor_fundo_w;
        end if;

    end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_status_painel_cir ( NR_SEQ_STATUS_PAINEL_P bigint, ie_opcao_p text) FROM PUBLIC;

