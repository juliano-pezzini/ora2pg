-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_mipres_prescriber_item (nr_seq_cpoe_p prescr_mipres.nr_seq_item_cpoe%TYPE, nr_prescricao_p prescr_mipres.nr_prescricao%TYPE, nr_seq_item_presc_p prescr_mipres.nr_seq_item_presc%TYPE, nr_seq_receita_amb_p prescr_mipres.nr_seq_receita_amb%TYPE, nr_seq_item_receita_amb_p prescr_mipres.nr_seq_item_receita_amb%TYPE, ie_tipo_item_presc_p prescr_mipres.ie_tipo_item_presc%TYPE ) RETURNS varchar AS $body$
DECLARE


	ds_result_w	varchar(255);


BEGIN

    SELECT MAX(obter_nome_pf(x.cd_item_prescriber))
    INTO STRICT ds_result_w
    FROM TABLE(mipres_item_data_pck.get_item(nr_seq_cpoe_p, nr_prescricao_p, nr_seq_item_presc_p, nr_seq_receita_amb_p, nr_seq_item_receita_amb_p, ie_tipo_item_presc_p)) x;
	
	RETURN ds_result_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_mipres_prescriber_item (nr_seq_cpoe_p prescr_mipres.nr_seq_item_cpoe%TYPE, nr_prescricao_p prescr_mipres.nr_prescricao%TYPE, nr_seq_item_presc_p prescr_mipres.nr_seq_item_presc%TYPE, nr_seq_receita_amb_p prescr_mipres.nr_seq_receita_amb%TYPE, nr_seq_item_receita_amb_p prescr_mipres.nr_seq_item_receita_amb%TYPE, ie_tipo_item_presc_p prescr_mipres.ie_tipo_item_presc%TYPE ) FROM PUBLIC;

