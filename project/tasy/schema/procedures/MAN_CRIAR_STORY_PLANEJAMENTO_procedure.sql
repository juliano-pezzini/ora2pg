-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_criar_story_planejamento (nr_seq_evento_comp_p text, nr_feature_p bigint, nr_team_p bigint, nr_sprint_p bigint, nm_usuario_p text) AS $body$
DECLARE



nr_seq_comp_w bigint;


BEGIN

select	1
into STRICT	nr_seq_comp_w
;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_criar_story_planejamento (nr_seq_evento_comp_p text, nr_feature_p bigint, nr_team_p bigint, nr_sprint_p bigint, nm_usuario_p text) FROM PUBLIC;

