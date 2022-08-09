-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE grava_erro_prescr_mat ( nr_prescricao_p bigint, nr_seq_prescricao_p bigint, nm_usuario_p text, ie_libera_p text, ds_erro_p text) AS $body$
DECLARE



nr_sequencia_w		bigint;


BEGIN

select	nextval('prescr_material_erro_seq')
into STRICT	nr_sequencia_w
;

insert into prescr_material_erro(
	nr_sequencia, nr_prescricao, nr_seq_prescricao,
	dt_atualizacao, nm_usuario, ie_libera, ds_erro)
values (
	nr_sequencia_w, nr_prescricao_p, nr_seq_prescricao_p,
	clock_timestamp(), nm_usuario_p, ie_libera_p, substr(ds_erro_p,1,255));

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE grava_erro_prescr_mat ( nr_prescricao_p bigint, nr_seq_prescricao_p bigint, nm_usuario_p text, ie_libera_p text, ds_erro_p text) FROM PUBLIC;
