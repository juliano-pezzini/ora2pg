-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_local_prescr_material ( nr_prescricao_p bigint, cd_local_estoque_p bigint, ds_sequencia_p text, nm_usuario_p text) AS $body$
DECLARE


ds_sequencia_w			varchar(2000);
ie_separador_w			integer;
nr_sequencia_w			bigint;


BEGIN

ds_sequencia_w	:= ds_sequencia_p;
ie_separador_w	:= position(',' in ds_sequencia_w);
nr_sequencia_w	:= (coalesce(substr(ds_sequencia_w,1,ie_separador_w-1),-1))::numeric;
ds_sequencia_w	:= substr(ds_sequencia_w,ie_separador_w + 1,length(ds_sequencia_w));

while	coalesce(nr_sequencia_w,-1) <> -1 loop

	update	prescr_material
	set	cd_local_estoque	= cd_local_estoque_p,
		dt_alteracao_local	= clock_timestamp(),
		nm_usuario_alt_local	= nm_usuario_p,
		dt_emissao_setor_atend	 = NULL
	where	nr_prescricao		= nr_prescricao_p
	and	nr_sequencia		= nr_sequencia_w;

	ie_separador_w	:= position(',' in ds_sequencia_w);
	nr_sequencia_w	:= (coalesce(substr(ds_sequencia_w,1,ie_separador_w-1),-1))::numeric;
	ds_sequencia_w	:= substr(ds_sequencia_w,ie_separador_w + 1,length(ds_sequencia_w));

end loop;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_local_prescr_material ( nr_prescricao_p bigint, cd_local_estoque_p bigint, ds_sequencia_p text, nm_usuario_p text) FROM PUBLIC;

