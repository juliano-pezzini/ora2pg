-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION gpt_obter_se_exibe_motivo ( nr_prescricao_p prescr_medica.nr_prescricao%type, ds_motivos_p text ) RETURNS varchar AS $body$
DECLARE


	ie_motivo_w varchar(1);


BEGIN

	select	coalesce(max('S'), 'N')
	into STRICT	ie_motivo_w
	from	prescr_medica a
	where	a.nr_prescricao = nr_prescricao_p
	and		coalesce(a.ie_motivo_prescricao, '0') in (
										SELECT	x.cd_registro cd_setor_atendimento
										from	table( lista_pck.obter_lista_char(ds_motivos_p, ',') ) x
										);

	return ie_motivo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION gpt_obter_se_exibe_motivo ( nr_prescricao_p prescr_medica.nr_prescricao%type, ds_motivos_p text ) FROM PUBLIC;
