-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE int_suspender_item_prescr (nr_prescricao_p bigint, nr_sequencia_p bigint, cd_motivo_p bigint, ds_motivo_p text, nm_tabela_p text, ie_gerar_evento_p text, cd_funcao_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
BEGIN
 
CALL suspender_item_prescricao(nr_prescricao_p, nr_sequencia_p, cd_motivo_p, ds_motivo_p, nm_tabela_p, nm_usuario_p, coalesce(ie_gerar_evento_p,'S'), coalesce(cd_funcao_p,924));
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE int_suspender_item_prescr (nr_prescricao_p bigint, nr_sequencia_p bigint, cd_motivo_p bigint, ds_motivo_p text, nm_tabela_p text, ie_gerar_evento_p text, cd_funcao_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
