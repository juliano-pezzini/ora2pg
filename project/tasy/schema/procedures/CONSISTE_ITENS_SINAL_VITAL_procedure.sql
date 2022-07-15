-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_itens_sinal_vital ( nr_seq_sv_p bigint, ds_retorno_p INOUT text, ie_retorno_p INOUT text) AS $body$
DECLARE


cd_pessoa_fisisca_w varchar(10);
nr_atendimento_w    bigint;
nr_seq_item_w       bigint;
nm_atributo_w       varchar(60);
ie_rn_w             varchar(8);
vl_item_w           double precision;
ie_retorno_w        varchar(10);
ds_retorno_w        varchar(2000);
sql_w               varchar(500);

c01 CURSOR FOR
SELECT  a.nr_sequencia,
        a.nm_atributo
from    sinal_vital a
where   nr_sequencia <> 58
order   by 1;


BEGIN
     ie_retorno_w := 'N';

    select  coalesce(max(cd_pessoa_fisica),''), 
            coalesce(max(nr_atendimento),'')
    into STRICT    cd_pessoa_fisisca_w,
            nr_atendimento_w
    from    atendimento_sinal_vital
    where   nr_sequencia = nr_seq_sv_p;

	open C01;
	loop
	fetch C01 into
		nr_seq_item_w,
		nm_atributo_w;
	EXIT WHEN NOT FOUND or ie_retorno_w <> 'N';  /* apply on C01 */

        if (nm_atributo_w IS NOT NULL AND nm_atributo_w::text <> '') then    
            sql_w := ' select max(' || nm_atributo_w || '), ' ||
                     '        nvl(max(ie_rn), ''N'' )' ||
                     ' from   atendimento_sinal_vital ' ||
                     ' where  nr_sequencia = :nr_seq_sv_p ';
			
			begin
            EXECUTE sql_w
            into STRICT    vl_item_w,
                    ie_rn_w
            using   nr_seq_sv_p;
			exception
                when others then
                null;
            end;			

            if (vl_item_w IS NOT NULL AND vl_item_w::text <> '') then 

                SELECT * FROM consiste_sinal_vital(
                    cd_pessoa_fisisca_w, --Pessoa Fisica
                    vl_item_w,           --Valor item
                    nr_seq_item_w,       --Sequencia do Item
                    ds_retorno_w,        --Retorno
                    ie_retorno_w,        --Tipo de retorno (A: Avisar; E: Erro)
                    null,                -- Unidade de medida
                    nr_atendimento_w,    --Atendimento
                    null,                -- Escala de dor
                    ie_rn_w,             -- RN
                    null                -- HTML5
) INTO STRICT 
                    ds_retorno_w, 
                    ie_retorno_w;
            end if;

        end if;
	end loop;
	close C01;

    ie_retorno_p := ie_retorno_w;
    ds_retorno_p := ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_itens_sinal_vital ( nr_seq_sv_p bigint, ds_retorno_p INOUT text, ie_retorno_p INOUT text) FROM PUBLIC;

