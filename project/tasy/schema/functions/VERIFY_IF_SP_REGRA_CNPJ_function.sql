-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION verify_if_sp_regra_cnpj ( cd_cnpj_p text, cd_versao_p text, nr_service_pack_p text, ds_hotfix_p text ) RETURNS varchar AS $body$
DECLARE


nr_sequencia_w				bigint		:= null;
qt_existe_w					bigint		:= 0;
ie_libera_w					varchar(1)		:= 'S';
ie_classificacao_w          varchar(1)     := 'S';
instance_name_w     varchar(50) := null;
user_w              varchar(50) := null;
dblink_w            varchar(50) := null;


sql_classcif_sp_w           varchar(32767) := '
SELECT nvl(ie_classificacao, ''S'')
FROM   #@user#@man_service_pack_versao#@dblink#@
WHERE  cd_versao = :cd_versao_p
AND    nr_service_pack = :nr_service_pack_p
';

sql_regra_versao_pack_sp_w varchar(32767) := '
select	max(nr_sequencia)
from	#@user#@regra_versao_pacote_sp#@dblink#@
where	cd_versao = :cd_versao_p
and		nr_service_pack = :nr_service_pack_p
and		NVL(ds_hotfix,''0'') = NVL(:ds_hotfix_p,''0'')
';

sql_regra_cliente_os_sp_w varchar(32767) := '
select	count(*)
from	#@user#@regra_cliente_os_sp#@dblink#@
where	nr_seq_rgr_ver_pac	= :nr_sequencia_w
and		cd_cnpj = :cd_cnpj_p
';


BEGIN

    instance_name_w := sys_context('userenv','instance_name');

    if (instance_name_w = 'PHDEV') then
        dblink_w := '@whebl01_dbcorp';
        user_w := 'corp.';
    end if;

    sql_classcif_sp_w := replace(sql_classcif_sp_w,'#@user#@',user_w);
    sql_classcif_sp_w := replace(sql_classcif_sp_w,'#@dblink#@',dblink_w);

    begin
        EXECUTE sql_classcif_sp_w
        into STRICT ie_classificacao_w
        using cd_versao_p, nr_service_pack_p;
    exception
        when others then ie_classificacao_w := 'S';
    end;

    if (ie_classificacao_w != 'S') then
        
        sql_regra_versao_pack_sp_w := replace(sql_regra_versao_pack_sp_w,'#@user#@',user_w);
        sql_regra_versao_pack_sp_w := replace(sql_regra_versao_pack_sp_w,'#@dblink#@',dblink_w);

        EXECUTE sql_regra_versao_pack_sp_w
        into STRICT nr_sequencia_w
        using cd_versao_p, nr_service_pack_p, ds_hotfix_p;

        if (nr_sequencia_w IS NOT NULL AND nr_sequencia_w::text <> '') then
    
            sql_regra_cliente_os_sp_w := replace(sql_regra_cliente_os_sp_w,'#@user#@',user_w);
            sql_regra_cliente_os_sp_w := replace(sql_regra_cliente_os_sp_w,'#@dblink#@',dblink_w);

            EXECUTE sql_regra_cliente_os_sp_w
            into STRICT qt_existe_w
            using nr_sequencia_w, cd_cnpj_p;

            if (qt_existe_w > 0) then
                  ie_libera_w	:= 'S';
            else
                  ie_libera_w	:= 'N';
            end if;
        else
            ie_libera_w	:= 'S';
        end if;
    end if;

return ie_libera_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION verify_if_sp_regra_cnpj ( cd_cnpj_p text, cd_versao_p text, nr_service_pack_p text, ds_hotfix_p text ) FROM PUBLIC;

