-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_mipres_route (nr_seq_cpoe_p prescr_mipres.nr_seq_item_cpoe%type, nr_prescricao_p prescr_mipres.nr_prescricao%type, nr_seq_item_presc_p prescr_mipres.nr_seq_item_presc%type, nr_seq_receita_amb_p prescr_mipres.nr_seq_receita_amb%type, nr_seq_item_receita_amb_p prescr_mipres.nr_seq_item_receita_amb%type, ie_tipo_item_presc_p prescr_mipres.ie_tipo_item_presc%type, nr_seq_prescr_mipres_p prescr_mipres.nr_sequencia%type default null) RETURNS varchar AS $body$
DECLARE


	ds_result_w	varchar(255);


BEGIN

	select max(obter_via_aplicacao(x.ie_route, 'D'))
	  into STRICT ds_result_w
	  from table(mipres_item_data_pck.get_item(nr_seq_cpoe_p, nr_prescricao_p, nr_seq_item_presc_p, nr_seq_receita_amb_p, nr_seq_item_receita_amb_p, ie_tipo_item_presc_p, nr_seq_prescr_mipres_p)) x;

	return ds_result_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_mipres_route (nr_seq_cpoe_p prescr_mipres.nr_seq_item_cpoe%type, nr_prescricao_p prescr_mipres.nr_prescricao%type, nr_seq_item_presc_p prescr_mipres.nr_seq_item_presc%type, nr_seq_receita_amb_p prescr_mipres.nr_seq_receita_amb%type, nr_seq_item_receita_amb_p prescr_mipres.nr_seq_item_receita_amb%type, ie_tipo_item_presc_p prescr_mipres.ie_tipo_item_presc%type, nr_seq_prescr_mipres_p prescr_mipres.nr_sequencia%type default null) FROM PUBLIC;
