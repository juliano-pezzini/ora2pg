-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE verifica_dose_prescr_prot_onc ( nr_seq_paciente_p bigint, nr_sequencia_p bigint, ds_erro_p INOUT text, ds_erro2_p INOUT text) AS $body$
DECLARE



cd_pessoa_fisica_w		varchar(30);
ie_via_aplicacao_w		varchar(5);
qt_regra_w			bigint;
nr_ciclos_w			bigint;


cd_material_w				integer;
nr_agrupamento_w			bigint;
qt_dose_w					double precision;
cd_unidade_medida_dose_w	varchar(30);
qt_reg_w					bigint;



BEGIN
ds_erro_p	:= '';
ds_erro2_p	:= '';


select	max(cd_unid_med_prescr),
		max(qt_dose_prescr),
		max(cd_material),
		count(*)
into STRICT	cd_unidade_medida_dose_w,
		qt_dose_w,
		cd_material_w,
		qt_reg_w
from	paciente_protocolo_medic
where	nr_seq_paciente = nr_seq_paciente_p
and		nr_seq_material = nr_sequencia_p
and   	coalesce(nr_seq_diluicao::text, '') = ''
and   	coalesce(nr_seq_solucao::text, '') = ''
and   	coalesce(nr_seq_medic_material::text, '') = ''
and   	coalesce(nr_seq_procedimento::text, '') = '';

if ( qt_reg_w > 0 ) then

	if (coalesce(qt_dose_w::text, '') = '') and (coalesce(cd_unidade_medida_dose_w::text, '') = '') then

		ds_erro_p	:= wheb_mensagem_pck.get_texto(277899);

	elsif ( coalesce(qt_dose_w::text, '') = '') then

		ds_erro_p	:= wheb_mensagem_pck.get_texto(277900);

	elsif (coalesce(cd_unidade_medida_dose_w::text, '') = '') then

		ds_erro_p	:= wheb_mensagem_pck.get_texto(277901);

	end if;

end if;


END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE verifica_dose_prescr_prot_onc ( nr_seq_paciente_p bigint, nr_sequencia_p bigint, ds_erro_p INOUT text, ds_erro2_p INOUT text) FROM PUBLIC;
