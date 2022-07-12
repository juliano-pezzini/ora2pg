-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_ds_motivo_lib_cartao (nr_seq_motivo_cartao_p pls_motivo_lib_cartao.nr_sequencia%type, ie_tipo_liberacao_p text) RETURNS PLS_MOTIVO_LIB_CARTAO.DS_MOTIVO%TYPE AS $body$
DECLARE


/*
retorna a descrição do motivo da liberação de cartão ou da biometria de acordo com ie_tipo_liberacao_p.
    C - Cartão
    B - Biometria
*/
ds_motivo_w pls_motivo_lib_cartao.ds_motivo%type;


BEGIN

begin
    if (ie_tipo_liberacao_p = 'C') then
        select  substr(ds_motivo, 1, 255)
        into STRICT    ds_motivo_w
        from    pls_motivo_lib_cartao
        where   nr_sequencia    = nr_seq_motivo_cartao_p;
    else
        select  substr(ds_motivo, 1, 255)
        into STRICT    ds_motivo_w
        from    pls_motivo_lib_digital
        where   nr_sequencia    = nr_seq_motivo_cartao_p;
    end if;
    exception
when others then
	ds_motivo_w := '';
end;


return	ds_motivo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_ds_motivo_lib_cartao (nr_seq_motivo_cartao_p pls_motivo_lib_cartao.nr_sequencia%type, ie_tipo_liberacao_p text) FROM PUBLIC;

