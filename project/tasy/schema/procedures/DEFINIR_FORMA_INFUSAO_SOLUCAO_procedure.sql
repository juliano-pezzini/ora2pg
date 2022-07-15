-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE definir_forma_infusao_solucao (ie_tipo_solucao_p bigint, nr_prescricao_p bigint, nr_seq_solucao_p bigint, ie_forma_infusao_p text) AS $body$
BEGIN
if (ie_tipo_solucao_p IS NOT NULL AND ie_tipo_solucao_p::text <> '') and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_solucao_p IS NOT NULL AND nr_seq_solucao_p::text <> '') and (ie_forma_infusao_p IS NOT NULL AND ie_forma_infusao_p::text <> '') then

	if (ie_tipo_solucao_p = 1) then
		update	prescr_solucao
		set	ie_forma_infusao = ie_forma_infusao_p
		where	nr_prescricao = nr_prescricao_p
		and	nr_seq_solucao = nr_seq_solucao_p;

	elsif (ie_tipo_solucao_p = 2) then
		update	prescr_material
		set	ie_forma_infusao = ie_forma_infusao_p
		where	nr_prescricao = nr_prescricao_p
		and	nr_sequencia = nr_seq_solucao_p
		and	ie_agrupador = 8;

	elsif (ie_tipo_solucao_p = 3) then
		update	prescr_procedimento
		set	ie_forma_infusao = ie_forma_infusao_p
		where	nr_prescricao = nr_prescricao_p
		and	nr_sequencia = nr_seq_solucao_p
		and	(nr_seq_solic_sangue IS NOT NULL AND nr_seq_solic_sangue::text <> '')
		and	(nr_seq_derivado IS NOT NULL AND nr_seq_derivado::text <> '');

	elsif (ie_tipo_solucao_p = 4) then
		update	nut_paciente
		set	ie_forma_infusao = ie_forma_infusao_p
		where	nr_prescricao = nr_prescricao_p
		and	nr_sequencia = nr_seq_solucao_p;

	elsif (ie_tipo_solucao_p = 5) then
		update	nut_pac
		set	ie_forma_infusao = ie_forma_infusao_p
		where	nr_prescricao = nr_prescricao_p
		and	nr_sequencia = nr_seq_solucao_p;

	elsif (ie_tipo_solucao_p = 6) then
		update	nut_pac
		set	ie_forma_infusao = ie_forma_infusao_p
		where	nr_prescricao = nr_prescricao_p
		and	nr_sequencia = nr_seq_solucao_p;
	end if;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE definir_forma_infusao_solucao (ie_tipo_solucao_p bigint, nr_prescricao_p bigint, nr_seq_solucao_p bigint, ie_forma_infusao_p text) FROM PUBLIC;

