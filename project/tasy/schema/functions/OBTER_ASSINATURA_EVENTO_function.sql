-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_assinatura_evento ( nr_seq_item_pend_p bigint, ie_tipo_item_p text) RETURNS varchar AS $body$
DECLARE


nr_seq_evento_w 	varchar(10);
nm_tabela_w 	        varchar(30);


BEGIN

if (coalesce(nr_seq_item_pend_p, 0) > 0) then

	if (ie_tipo_item_p = 'O') then

		select 	max(nr_seq_prescr_gas)
		into STRICT 	nr_seq_evento_w
		from 	pep_item_pendente_comp
		where 	nr_seq_item_pend 	= nr_seq_item_pend_p;

		nm_tabela_w := 'prescr_gasoterapia_evento';
	elsif (ie_tipo_item_p = 'DI') then

		select 	max(nr_seq_presc_alter)
		into STRICT 	nr_seq_evento_w
		from 	pep_item_pendente_comp
		where 	nr_seq_item_pend 	= nr_seq_item_pend_p;

		nm_tabela_w := 'hd_prescricao_evento';
	elsif (ie_tipo_item_p in ('IA', 'ME', 'IAG', 'IAH', 'LD', 'MAT', 'M', 'D', 'P', 'G', 'C', 'I', 'L', 'R', 'E')) then


		select 	max(nr_seq_mat_alter)
		into STRICT 	nr_seq_evento_w
		from 	pep_item_pendente_comp
		where 	nr_seq_item_pend 	= nr_seq_item_pend_p;

		nm_tabela_w := 'prescr_mat_alteracao';
	else

		select 	max(nr_seq_prescr_sol)
		into STRICT 	nr_seq_evento_w
		from 	pep_item_pendente_comp
		where 	nr_seq_item_pend 	= nr_seq_item_pend_p;

		nm_tabela_w := 'prescr_solucao_evento';
	end if;

end if;

return nr_seq_evento_w ||':'|| nm_tabela_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_assinatura_evento ( nr_seq_item_pend_p bigint, ie_tipo_item_p text) FROM PUBLIC;

