-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_cons_agrup_onc_md ( qt_reg_p bigint, ds_retorno_p text, nr_tipo_ret_p bigint ) RETURNS varchar AS $body$
DECLARE

    ds_retorno_w varchar(4000) := ds_retorno_p;

BEGIN
    IF ( qt_reg_p > 0 ) THEN
        IF ( nr_tipo_ret_p = 1 ) THEN
            ds_retorno_w := ds_retorno_w
                            || wheb_mensagem_pck.get_texto(881808)
                            || chr(13)
                            || chr(10);
        END IF;

        IF ( nr_tipo_ret_p = 2 ) THEN
            ds_retorno_w := ds_retorno_w
                            || wheb_mensagem_pck.get_texto(881809)
                            || chr(13)
                            || chr(10);

        END IF;

        IF ( nr_tipo_ret_p = 3 ) THEN
            ds_retorno_w := ds_retorno_w
                            || wheb_mensagem_pck.get_texto(881808)
                            || chr(13)
                            || chr(10);
        END IF;

        IF ( nr_tipo_ret_p = 4 ) THEN
            ds_retorno_w := ds_retorno_w
                            || wheb_mensagem_pck.get_texto(881809)
                            || chr(13)
                            || chr(10);
        END IF;

    END IF;

    RETURN ds_retorno_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_cons_agrup_onc_md ( qt_reg_p bigint, ds_retorno_p text, nr_tipo_ret_p bigint ) FROM PUBLIC;
