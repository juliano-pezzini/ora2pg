-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_turno_conv_agecons ( cd_agenda_p bigint, nr_seq_agenda_p bigint, dt_agenda_p timestamp, nr_seq_turno_p bigint, nr_seq_turno_esp_p bigint, cd_convenio_p bigint, ds_consistencia_p INOUT text, nm_usuario_p text, cd_estabelecimento_p bigint, cd_categoria_p text) AS $body$
DECLARE


ds_consistencia_w varchar(255);


BEGIN
if (cd_agenda_p IS NOT NULL AND cd_agenda_p::text <> '') and (dt_agenda_p IS NOT NULL AND dt_agenda_p::text <> '') and (cd_convenio_p IS NOT NULL AND cd_convenio_p::text <> '') and (nr_seq_turno_p IS NOT NULL AND nr_seq_turno_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin	

	ds_consistencia_w := consistir_turno_convenio(nr_seq_agenda_p, cd_agenda_p, dt_agenda_p, nr_seq_turno_p, cd_convenio_p, cd_categoria_p, ds_consistencia_w, nm_usuario_p, cd_estabelecimento_p, null);
	
	if (coalesce(ds_consistencia_w::text, '') = '') then
		begin
		ds_consistencia_w := consistir_turno_esp_convenio(cd_agenda_p, dt_agenda_p, nr_seq_turno_esp_p, cd_convenio_p, nr_seq_agenda_p, ds_consistencia_w, cd_categoria_p);
		end;
	end if;
	end;
end if;
ds_consistencia_p := ds_consistencia_w;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_turno_conv_agecons ( cd_agenda_p bigint, nr_seq_agenda_p bigint, dt_agenda_p timestamp, nr_seq_turno_p bigint, nr_seq_turno_esp_p bigint, cd_convenio_p bigint, ds_consistencia_p INOUT text, nm_usuario_p text, cd_estabelecimento_p bigint, cd_categoria_p text) FROM PUBLIC;

