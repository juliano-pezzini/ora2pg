-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE psa_active_subject_datasource ( nm_datasource_p text) AS $body$
BEGIN
  insert
  into subject_datasource(
      id,
      dt_creation,
      dt_modification,
      id_subject,
      id_datasource,
      vl_activation_status,
      vl_attempts_so_far
    )
  SELECT
    psa_uuid_generator id,
    clock_timestamp() dt_creation,
    clock_timestamp() dt_modification,
    s.id id_subject,
    d.id id_datasource,
    coalesce(CASE WHEN u.ie_situacao='A' THEN  0 WHEN u.ie_situacao='I' THEN  1 WHEN u.ie_situacao='B' THEN  2 END , 0) vl_activation_status,
    0
  FROM usuario u, datasource d, subject s
LEFT OUTER JOIN subject_datasource sd ON (s.id = sd.id_subject)
WHERE s.ds_login      = u.nm_usuario and coalesce(sd.id_subject::text, '') = '' and d.nm_datasource = nm_datasource_p;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE psa_active_subject_datasource ( nm_datasource_p text) FROM PUBLIC;

