-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION cpoe_calc_valores_sol_md_pck.calcula_ds_diluicao_md (ds_diluicao_out_p text, ds_diluicao_aux_p text, ds_horarios_valor_p text ) RETURNS varchar AS $body$
DECLARE


      ds_diluicao_out_w varchar(4000);

BEGIN
    if (coalesce(ds_horarios_valor_p::text, '') = '') then
      ds_diluicao_out_w := substr(ds_diluicao_out_p || wheb_mensagem_pck.get_texto(341494, 'HORA=' || '#@HORA#@' || ';') || ' ' || ds_diluicao_aux_p,1,4000);
    else
      ds_diluicao_out_w := substr(ds_diluicao_out_p || wheb_mensagem_pck.get_texto(341494, 'HORA=' || ds_horarios_valor_p || ';') || ' ' || ds_diluicao_aux_p,1,4000);
    end if;

    return ds_diluicao_out_w;
  end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_calc_valores_sol_md_pck.calcula_ds_diluicao_md (ds_diluicao_out_p text, ds_diluicao_aux_p text, ds_horarios_valor_p text ) FROM PUBLIC;
