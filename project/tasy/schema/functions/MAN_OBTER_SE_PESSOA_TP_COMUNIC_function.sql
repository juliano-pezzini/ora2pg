-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_se_pessoa_tp_comunic ( nr_seq_pessoa_p bigint, nr_seq_comunicado_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w                    	varchar(15);
nr_seq_tipo_comunic_w	bigint;
nr_seq_tipo_comunic_ww	bigint;
ie_tipo_recebe_w		varchar(15) := '';
ie_tipo_nao_recebe_w	varchar(15) := '';

c01 CURSOR FOR
        SELECT  a.nr_seq_tipo_comunicado
        from    man_pessoa_localiz_comunic a
        where   a.nr_seq_pessoa = nr_seq_pessoa_p;
c02 CURSOR FOR
        SELECT  a.nr_seq_tipo_comunicado
        from    suporte_comunicado a
        where   a.nr_sequencia = nr_seq_comunicado_p;

BEGIN

open c01;
loop
fetch c01 into
        nr_seq_tipo_comunic_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
        begin
        open c02;
        loop
        fetch c02 into
                nr_seq_tipo_comunic_ww;
        EXIT WHEN NOT FOUND; /* apply on c02 */
                begin
                if (nr_seq_tipo_comunic_w = nr_seq_tipo_comunic_ww) then
                        ie_tipo_recebe_w := 'S';
                else
                        ie_tipo_nao_recebe_w := 'N';
                end if;
                end;
        end loop;
        close c02;
        end;
end loop;
close c01;

ds_retorno_w := coalesce(coalesce(ie_tipo_recebe_w,ie_tipo_nao_recebe_w),'S');

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_se_pessoa_tp_comunic ( nr_seq_pessoa_p bigint, nr_seq_comunicado_p bigint) FROM PUBLIC;

