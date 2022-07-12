-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_icone_legend_inter_medic ( nr_dominio_legenda_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);


BEGIN

SELECT
CASE nr_dominio_legenda_p
    WHEN 1 THEN '/assets/icons/status-and-feedback/medications-benzo-antagonist.svg'
    WHEN 2 THEN '/assets/icons/status-and-feedback/medications-local-anesthetics.svg'
    WHEN 3 THEN '/assets/icons/status-and-feedback/medications-opiates-antagonist.svg'
    WHEN 4 THEN '/assets/icons/status-and-feedback/medications-mr-antagonist.svg'
    WHEN 5 THEN '/assets/icons/status-and-feedback/medications-antiarrhythmic.svg'
    WHEN 6 THEN '/assets/icons/status-and-feedback/medications-anticoagulants.svg'
    WHEN 7 THEN '/assets/icons/status-and-feedback/medications-heparin-exception.svg'
    WHEN 8 THEN '/assets/icons/status-and-feedback/medications-anticholinergics.svg'
    WHEN 9 THEN '/assets/icons/status-and-feedback/medications-anticonvulsants.svg'
    WHEN 10 THEN '/assets/icons/status-and-feedback/medications-antiemetics.svg'
    WHEN 11 THEN '/assets/icons/status-and-feedback/medications-benzodiazepines.svg'
    WHEN 12 THEN '/assets/icons/status-and-feedback/medications-beta-blockers.svg'
    WHEN 13 THEN '/assets/icons/status-and-feedback/medications-bronchodilators.svg'
    WHEN 14 THEN '/assets/icons/status-and-feedback/medications-coagulants.svg'
    WHEN 15 THEN '/assets/icons/status-and-feedback/medications-protamine-exception.svg'
    WHEN 16 THEN '/assets/icons/status-and-feedback/medications-cholinergics.svg'
    WHEN 17 THEN '/assets/icons/status-and-feedback/medications-electrolytes.svg'
    WHEN 18 THEN '/assets/icons/status-and-feedback/medications-nacl-exception.svg'
    WHEN 19 THEN '/assets/icons/status-and-feedback/medications-potassium-exception.svg'
    WHEN 20 THEN '/assets/icons/status-and-feedback/medications-hypnotics.svg'
    WHEN 21 THEN '/assets/icons/status-and-feedback/medications-hormones.svg'
    WHEN 22 THEN '/assets/icons/status-and-feedback/medications-insulin-exception.svg'
    WHEN 23 THEN '/assets/icons/status-and-feedback/medications-inodilators.svg'
    WHEN 24 THEN '/assets/icons/status-and-feedback/medications-opiates.svg'
    WHEN 25 THEN '/assets/icons/status-and-feedback/medications-muscle-relaxants.svg'
    WHEN 26 THEN '/assets/icons/status-and-feedback/medications-suxamethonium-exception.svg'
    WHEN 27 THEN '/assets/icons/status-and-feedback/medications-vasoladitatoria.svg'
    WHEN 28 THEN '/assets/icons/status-and-feedback/medications-vasopressors.svg'
    WHEN 29 THEN '/assets/icons/status-and-feedback/medications-epinephrine-exception.svg'
    WHEN 99 THEN '/assets/icons/status-and-feedback/medications-different-drugs.svg'
    ELSE ''
  END AS ds_retorno
INTO STRICT	ds_retorno_w
;

RETURN ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_icone_legend_inter_medic ( nr_dominio_legenda_p bigint) FROM PUBLIC;

