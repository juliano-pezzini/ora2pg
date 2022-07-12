-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_possivel_prox_build (cd_versao_p text, nr_seq_man_os_ctrl_desc_p bigint) RETURNS bigint AS $body$
DECLARE


cd_prox_build_w	bigint;
ie_aplicacao_w	varchar(2);
ds_comando_cursor_w text;
C010 integer;
retorno_w bigint;


BEGIN

select	ie_aplicacao
into STRICT	ie_aplicacao_w
from	man_os_ctrl_desc
where	nr_sequencia = nr_seq_man_os_ctrl_desc_p;

if (ie_aplicacao_w = 'S') then
    /*select MAX(nvl(nr_pacote,0))+1
    into  cd_prox_build_w
    from  ajuste_versao@orcl
    where cd_versao = cd_versao_p;
    */
    null;
else
    if (ie_aplicacao_w = 'H' and somente_numero(cd_versao_p) > 3011733) then
        select count(distinct nr_service_pack)
        into STRICT   cd_prox_build_w
        from   man_service_pack_versao
        where  cd_versao = cd_versao_p;
    Else
        SELECT	max(coalesce(cd_build,0))+1
        into STRICT	cd_prox_build_w
        FROM	man_versao_calendario
        WHERE	cd_versao = cd_versao_p
        and		ie_aplicacao = ie_aplicacao_w;
    end if;
end if;

return	cd_prox_build_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_possivel_prox_build (cd_versao_p text, nr_seq_man_os_ctrl_desc_p bigint) FROM PUBLIC;
