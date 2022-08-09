-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE reprovar_material_solic ( nr_seq_solic_p bigint, ie_opcao_p text, nr_seq_motivo_reprov_p bigint, nm_usuario_p text) AS $body$
BEGIN
 
CALL pls_atualizar_mat_med_solic(nr_seq_solic_p, ie_opcao_p, nm_usuario_p,'S');
 
CALL pls_insere_motivo_rep_mat_med(nr_seq_solic_p, nr_seq_motivo_reprov_p, nm_usuario_p);
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reprovar_material_solic ( nr_seq_solic_p bigint, ie_opcao_p text, nr_seq_motivo_reprov_p bigint, nm_usuario_p text) FROM PUBLIC;
