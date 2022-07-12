-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_get_if_mat_visible_jp ( in_hospital_tp_p text, out_of_hospital_tp_p text, ie_out_of_hospital_mat_p text, ie_in_hospital_mat_p text, dt_inicio_rp_p timestamp, dt_in_periodo_uso_mat_p timestamp, dt_out_periodo_uso_mat_p timestamp ) RETURNS varchar AS $body$
DECLARE

  ie_ret_w varchar(1);


BEGIN
  ie_ret_w := 'S';

  /* Verify prescription type */
  
  if (coalesce(in_hospital_tp_p,'S') = 'S' and coalesce(out_of_hospital_tp_p,'S') = 'S') then
    if (coalesce(ie_in_hospital_mat_p,'S') = 'N' and coalesce(ie_out_of_hospital_mat_p,'S') = 'N') then
      ie_ret_w := 'N';
    end if;
  else
    if (coalesce(in_hospital_tp_p,'S') = 'S' and coalesce(ie_in_hospital_mat_p,'S') = 'N') then
      ie_ret_w := 'N';
    end if;
    if (coalesce(out_of_hospital_tp_p,'S') = 'S' and coalesce(ie_out_of_hospital_mat_p,'S') = 'N') then
      ie_ret_w := 'N';
    end if;
  end if;

  /*Verifiy RP date */

  if ((dt_in_periodo_uso_mat_p IS NOT NULL AND dt_in_periodo_uso_mat_p::text <> '') and dt_inicio_rp_p < dt_in_periodo_uso_mat_p) then
    ie_ret_w := 'N';
  end if;

  if ((dt_out_periodo_uso_mat_p IS NOT NULL AND dt_out_periodo_uso_mat_p::text <> '') and dt_inicio_rp_p > dt_out_periodo_uso_mat_p) then
    ie_ret_w := 'N';
  end if;

  return ie_ret_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 IMMUTABLE;
-- REVOKE ALL ON FUNCTION cpoe_get_if_mat_visible_jp ( in_hospital_tp_p text, out_of_hospital_tp_p text, ie_out_of_hospital_mat_p text, ie_in_hospital_mat_p text, dt_inicio_rp_p timestamp, dt_in_periodo_uso_mat_p timestamp, dt_out_periodo_uso_mat_p timestamp ) FROM PUBLIC;

