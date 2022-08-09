-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_info_avaliacao_anterior ( cd_perfil_p bigint, nr_atendimento_p bigint, cd_pessoa_fisica_p usuario.cd_pessoa_fisica%type, nm_usuario_p text, nr_seq_prescr_atual_p bigint, nr_seq_prescr_p INOUT bigint, nr_seq_modelo_p INOUT bigint) AS $body$
DECLARE


  type_of_care_user_w    varchar(1);
  type_evol_prescricao_w varchar(1);
  type_evol_user_w       usuario.ie_tipo_evolucao%type;
  qt_itens_prescr_atual_w bigint;

  C01 CURSOR FOR
    SELECT *
    FROM (SELECT b.nr_sequencia, c.ie_tipo_evolucao, b.nr_seq_modelo
          FROM pe_prescricao b, usuario c
          WHERE c.nm_usuario = b.nm_usuario
          AND (b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '')
          AND coalesce(b.dt_suspensao::text, '') = ''
          AND (
          (type_of_care_user_w = 'T' AND (b.cd_pessoa_fisica = cd_pessoa_fisica_p AND b.ie_nivel_atencao = 'T'))
          OR (type_of_care_user_w = 'S' AND (b.cd_pessoa_fisica = cd_pessoa_fisica_p AND b.ie_nivel_atencao = 'S')))
          ORDER BY b.dt_liberacao desc) alias7 LIMIT 1;


BEGIN
  nr_seq_prescr_p := 0;
  nr_seq_modelo_p := 0;

  SELECT MAX(ie_tipo_evolucao)
  INTO STRICT type_evol_user_w
  FROM usuario
  WHERE nm_usuario = nm_usuario_p;

  SELECT coalesce(MAX(a.ie_nivel_atencao),'T')
  INTO STRICT type_of_care_user_w
  FROM perfil a
  WHERE a.cd_perfil = cd_perfil_p;

  OPEN C01;
  FETCH C01
  INTO nr_seq_prescr_p,
    type_evol_prescricao_w,
    nr_seq_modelo_p;
  CLOSE C01;

  IF (type_evol_prescricao_w <> type_evol_user_w) THEN
    nr_seq_prescr_p := 0;
  END IF;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_info_avaliacao_anterior ( cd_perfil_p bigint, nr_atendimento_p bigint, cd_pessoa_fisica_p usuario.cd_pessoa_fisica%type, nm_usuario_p text, nr_seq_prescr_atual_p bigint, nr_seq_prescr_p INOUT bigint, nr_seq_modelo_p INOUT bigint) FROM PUBLIC;
