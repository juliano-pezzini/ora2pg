-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hd_exame_mes_anter_relat4 ( DT_REFERENCIA_P timestamp, NR_SEQ_UNIDADE_P bigint, DS_ITENS_P bigint, nm_usuario_p text ) AS $body$
BEGIN
delete from HD_GRID_CONTROLE_DIALISE where nm_usuario = nm_usuario_p;
CALL hd_gerar_contr_dial_rel_4(
     0,
     DS_ITENS_P,
     nm_usuario_P,
     NR_SEQ_UNIDADE_P,
     0,
     null,
     null,
     'S',
     'N',
     'S',
     (trunc(DT_REFERENCIA_P,'MM') - 5),
     'N',
     'N',
     null,
     null,
     null,
     0,
     0);
-------------------------------------------------------------------------------
CALL hd_gerar_contr_dial_rel_4(
     0,
     DS_ITENS_P,
     nm_usuario_P,
     NR_SEQ_UNIDADE_P,
     0,
     null,
     null,
     'S',
     'N',
     'S',
     DT_REFERENCIA_P,
     'N',
     'N',
     null,
     null,
     null,
     0,
     0);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hd_exame_mes_anter_relat4 ( DT_REFERENCIA_P timestamp, NR_SEQ_UNIDADE_P bigint, DS_ITENS_P bigint, nm_usuario_p text ) FROM PUBLIC;
