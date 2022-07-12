-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_item_solic_same (nr_seq_Item_solic_p bigint ) RETURNS varchar AS $body$
DECLARE

ds_item_solic_w                       varchar(255);


BEGIN

select max(ds_item_solic)
into STRICT ds_item_solic_w
from same_itens_solic_pront
where nr_sequencia = nr_seq_item_solic_p;

return ds_item_solic_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_item_solic_same (nr_seq_Item_solic_p bigint ) FROM PUBLIC;

