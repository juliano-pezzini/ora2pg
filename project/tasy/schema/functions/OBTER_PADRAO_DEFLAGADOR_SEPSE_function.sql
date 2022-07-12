-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_padrao_deflagador_sepse (nr_sequencia_p bigint default null) RETURNS varchar AS $body$
DECLARE


ie_deflagador_cliente_w	varchar(1);
ds_retorno_w            varchar(255);
sql_w varchar(250);

BEGIN

    if (coalesce(nr_sequencia_p::text, '') = '') then

        select coalesce(max('S'), 'N')
        into STRICT   ie_deflagador_cliente_w
        from   sepse_atributo_cliente;

    else

        select coalesce(max('S'), 'N')
        into STRICT   ie_deflagador_cliente_w
        from   sepse_atributo_cliente
        where  nr_seq_atributo = nr_sequencia_p;

    end if;

    ds_retorno_w := 'P';
    begin
      sql_w := 'CALL OBTER_PAD_DEFLAG_SEPSE_MD(:1) INTO :ds_retorno_w';
      EXECUTE sql_w USING IN ie_deflagador_cliente_w, OUT ds_retorno_w;
    exception
      when others then
        ds_retorno_w := null;
    end;
    return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_padrao_deflagador_sepse (nr_sequencia_p bigint default null) FROM PUBLIC;

