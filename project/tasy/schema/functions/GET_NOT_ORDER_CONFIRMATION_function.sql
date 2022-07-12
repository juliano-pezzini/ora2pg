-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_not_order_confirmation ( ie_tipo_item_p text, nr_seq_cpoe_p bigint ) RETURNS varchar AS $body$
DECLARE

    ie_return_w    varchar(1) := 'N';
    count_flag_w   smallint := 0;

BEGIN
    SELECT
        COUNT(*)
    INTO STRICT count_flag_w
    FROM
        cpoe_tipo_pedido
    WHERE
        ie_situacao = 'A'
        AND cd_order_confirmation = '3'
        AND nr_sequencia = obter_order_type_cpoe(nr_seq_cpoe_p, ie_tipo_item_p);

    IF ( count_flag_w > 0 ) THEN
        ie_return_w := 'X';
    END IF;
    RETURN ie_return_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_not_order_confirmation ( ie_tipo_item_p text, nr_seq_cpoe_p bigint ) FROM PUBLIC;

