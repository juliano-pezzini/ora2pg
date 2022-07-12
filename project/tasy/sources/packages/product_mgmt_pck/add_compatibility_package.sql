-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE product_mgmt_pck.add_compatibility (p_product_name text, p_product_version text, p_service_pack text, p_product_name_compat text, p_product_version_compat text, p_service_pack_compat text, p_nm_usuario text default 'Tasy') AS $body$
BEGIN
    insert into product_compatibility(product_name,
       product_version,
       service_pack,
       product_name_compat,
       product_version_compat,
       service_pack_compat,
       nm_usuario,
       dt_atualizacao)
    values (p_product_name,
       p_product_version,
       p_service_pack,
       p_product_name_compat,
       p_product_version_compat,
       p_service_pack_compat,
       p_nm_usuario,
       clock_timestamp());
  end;

  ---------------------------------------------------------------

  --

  -- Mark a product as installed. To be installed, the product

  -- must have a record in the product table.

  --

  ---------------------------------------------------------------


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE product_mgmt_pck.add_compatibility (p_product_name text, p_product_version text, p_service_pack text, p_product_name_compat text, p_product_version_compat text, p_service_pack_compat text, p_nm_usuario text default 'Tasy') FROM PUBLIC;
